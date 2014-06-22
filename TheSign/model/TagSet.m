//
//  TagSet.m
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-06-19.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import "TagSet.h"
#import "Featured.h"
#import "Tag.h"
#import "Relevancy.h"
#import "Model.h"

#define CD_WEIGHT (@"weight")
#define CD_OFFER (@"taggedFeature")
#define CD_TAG (@"tagInSet")

#define P_WEIGHT (@"weight")
#define P_OFFER (@"DealID")
#define P_TAG (@"TagID")


@implementation TagSet

@dynamic pObjectID;
@dynamic weight;
@dynamic linkedOffer;
@dynamic linkedTag;

@synthesize parseObject=_parseObject;

+(NSString*) entityName {return @"TagSet";}
+(NSString*) parseEntityName {return @"TagSet";}

+(TagSet*) getByID:(NSString*)identifier
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:self.entityName];
    request.predicate=[NSPredicate predicateWithFormat:@"%@=='%@'", OBJECT_ID, identifier];
    NSError *error;
    NSArray *result = [[Model sharedModel].managedObjectContext executeFetchRequest:request error:&error];
    
    if(error)
    {
        NSLog(@"%@",[error localizedDescription]);
        return nil;
    }
    else
        return (TagSet*)result.firstObject;
}

+(void)createFromParse:(PFObject *)object
{
    TagSet *tagset = [NSEntityDescription insertNewObjectForEntityForName:self.entityName
                                                   inManagedObjectContext:[Model sharedModel].managedObjectContext];
    tagset.parseObject=object;
    tagset.pObjectID=object.objectId;
    tagset.weight=object[P_WEIGHT];
    
    //careful, incomplete object - only objectId property is there
    PFObject *fromParseFeatured=object[P_OFFER];
    
    Featured *linkedFeatured=[Featured getByID:fromParseFeatured.objectId];
    if(linkedFeatured!=nil)
    {
        tagset.linkedOffer = linkedFeatured;
        [linkedFeatured addLinkedTagSetsObject:tagset];
    }
    else
        NSLog(@"Linked offer wasn't found");

    //careful, incomplete object - only objectId property is there
    PFObject *fromParseTag=object[P_TAG];
    Tag *linkedTag=[Tag getByID:fromParseTag.objectId];
    if(linkedTag!=nil)
    {
        tagset.linkedTag = linkedTag;
        [linkedTag addLinkedTagSetsObject:tagset];
    }
    else
        NSLog(@"Linked tag wasn't found");
}

-(void)refreshFromParse
{
    
    NSError *error;
    [self.parseObject refresh:&error];
    if(error)
    {
        NSLog(@"%@",[error localizedDescription]);
        return;
    }
    
    //rescoring relevancy if we changed the weight
    if(self.weight!=self.parseObject[P_WEIGHT])
        [self.linkedOffer.linkedScore rescore];
    self.weight=self.parseObject[P_WEIGHT];
    
    //careful, incomplete object - only objectId property is there
    PFObject *fromParseFeatured=self.parseObject[P_OFFER];
    if (fromParseFeatured.objectId!=self.linkedOffer.pObjectID)
    {
        [self.linkedOffer removeLinkedTagSetsObject:self];
        Featured *linkedFeatured=[Featured getByID:fromParseFeatured.objectId];
        if(linkedFeatured!=nil)
        {
            self.linkedOffer = linkedFeatured;
            [linkedFeatured addLinkedTagSetsObject:self];
        }
        else
            NSLog(@"Linked offer wasn't found");
    }

    //careful, incomplete object - only objectId property is there
    PFObject *fromParseTag=self.parseObject[P_TAG];
    if (fromParseTag.objectId!=self.linkedTag.pObjectID)
    {
        [self.linkedTag removeLinkedTagSetsObject:self];
        Tag *linkedTag=[Tag getByID:fromParseTag.objectId];
        if(linkedTag!=nil)
        {
            self.linkedTag = linkedTag;
            [linkedTag addLinkedTagSetsObject:self];
        }
        else
            NSLog(@"Linked tag wasn't found");
    }
}

@end
