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




#pragma mark - Sign Entity Protocol

@synthesize parseObject=_parseObject;

-(PFObject*)parseObject
{
    if(!_parseObject)
    {
        NSError *error;
        if(!error)
            _parseObject=[PFQuery getObjectOfClass:[self.class parseEntityName] objectId:self.pObjectID error:&error];
        else
            NSLog(@"%@",[error localizedDescription]);
    }
    return _parseObject;
}

+(Boolean)checkIfParseObjectRight:(PFObject*)object
{
    if(object[P_OFFER] && object[P_TAG])
        return YES;
    else
        return NO;
}

+(NSString*) entityName {return @"TagSet";}
+(NSString*) parseEntityName {return @"TagSet";}

+(TagSet*) getByID:(NSString*)identifier Context:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:self.entityName];
    request.predicate=[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@='%@'", OBJECT_ID, identifier]];
    NSError *error;
    NSArray *result = [context executeFetchRequest:request error:&error];
    
    if(error)
    {
        NSLog(@"%@",[error localizedDescription]);
        return nil;
    }
    else
        return result.firstObject;
}



+(Boolean)createFromParse:(PFObject *)object Context:(NSManagedObjectContext *)context
{
    if([self checkIfParseObjectRight:object]==NO)
    {
        NSLog(@"%@: The object %@ is missing mandatory fields",self.entityName,object.objectId);
        return NO;
    }
    
    Boolean complete=YES;

    TagSet *tagset = [NSEntityDescription insertNewObjectForEntityForName:self.entityName
                                                   inManagedObjectContext:context];
    tagset.pObjectID=object.objectId;
    if(object[P_WEIGHT])
        tagset.weight=object[P_WEIGHT];
    
    //careful, incomplete object - only objectId property is there
    PFObject *fromParseFeatured=object[P_OFFER];
    
    Featured *linkedFeatured=[Featured getByID:fromParseFeatured.objectId Context:context];
    if(linkedFeatured)
    {
        tagset.linkedOffer = linkedFeatured;
        [linkedFeatured addLinkedTagSetsObject:tagset];
    }
    else
    {
        NSLog(@"TagSet: Linked offer wasn't found");
        complete=NO;
    }

    //careful, incomplete object - only objectId property is there
    PFObject *fromParseTag=object[P_TAG];
    Tag *linkedTag=[Tag getByID:fromParseTag.objectId Context:context];
    if(linkedTag)
    {
        tagset.linkedTag = linkedTag;
        [linkedTag addLinkedTagSetsObject:tagset];
    }
    else
    {
        NSLog(@"TagSet: Linked tag wasn't found");
        complete=NO;
    }
    
    return complete;
}

-(Boolean)refreshFromParseForContext:(NSManagedObjectContext *)context
{
    if(!self.parseObject)
    {
        NSLog(@"%@: Couldn't fetch the parse object with id: %@",[self.class entityName],self.pObjectID);
        return NO;
    }
    
    if([self.class checkIfParseObjectRight:self.parseObject]==NO)
    {
        NSLog(@"TagSet: The object %@ is missing mandatory fields",self.parseObject.objectId);
        return NO;
    }
    
    Boolean complete=YES;
    
    if(self.parseObject[P_WEIGHT])
        self.weight=self.parseObject[P_WEIGHT];
    else
        //default value
        self.weight=@(1);
    
    //careful, incomplete object - only objectId property is there
    
    Boolean needOfferUpdate=NO;
    PFObject *fromParseFeatured=self.parseObject[P_OFFER];
    if (fromParseFeatured.objectId!=self.linkedOffer.pObjectID)
    {
        [self.linkedOffer removeLinkedTagSetsObject:self];
        Featured *linkedFeatured=[Featured getByID:fromParseFeatured.objectId Context:context];
        if(linkedFeatured!=nil)
        {
            self.linkedOffer = linkedFeatured;
            [linkedFeatured addLinkedTagSetsObject:self];
            needOfferUpdate=YES;
        }
        else
        {
            NSLog(@"TagSet: Linked offer wasn't found");
            complete=NO;
        }
    }

    //careful, incomplete object - only objectId property is there
    PFObject *fromParseTag=self.parseObject[P_TAG];
    if (fromParseTag.objectId!=self.linkedTag.pObjectID)
    {
        [self.linkedTag removeLinkedTagSetsObject:self];
        Tag *linkedTag=[Tag getByID:fromParseTag.objectId Context:context];
        if(linkedTag!=nil)
        {
            self.linkedTag = linkedTag;
            [linkedTag addLinkedTagSetsObject:self];
            needOfferUpdate=YES;
        }
        else
        {
            NSLog(@"TagSet: Linked tag wasn't found");
            complete=NO;
        }
    }
    
    return complete;
}

+(NSInteger)getRowCountForContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:self.entityName];
    NSError *error;
    NSInteger result = [context countForFetchRequest:request error:&error];
    
    if(error)
    {
        NSLog(@"%@",[error localizedDescription]);
        return 0;
    }
    else
        return result;
}

@end
