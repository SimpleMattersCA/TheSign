//
//  TagSet.m
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-05-26.
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

@dynamic weight;
@dynamic pObjectID;
@dynamic taggedFeature;
@dynamic tagInSet;

@synthesize parseObject=_parseObject;

+(NSString*) entityName {return @"TagSet";}
+(NSString*) parseEntityName {return @"TagSet";}

+(TagSet*) getByID:(NSString*)identifier
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:self.entityName];
    NSString *predicate = [NSString stringWithFormat: @"%@=='%@'", OBJECT_ID, identifier];
    request.predicate=[NSPredicate predicateWithFormat:predicate];
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
    
    NSError *error;
    
    PFObject *fromParseFeatured=[object[P_OFFER] fetchIfNeeded:&error];
    
    if (!error)
    {
        Featured *linkedFeatured=[Featured getByID:fromParseFeatured.objectId];
        tagset.taggedFeature = linkedFeatured;
        [linkedFeatured addFeaturedTagSetsObject:tagset];
        
    }
    else
        NSLog(@"%@",[error localizedDescription]);
    
    
    PFObject *fromParseTag=[object[P_TAG] fetchIfNeeded:&error];
    
    if (!error)
    {
        Tag *linkedTag=[Tag getByID:fromParseTag.objectId];
        tagset.tagInSet = linkedTag;
        [linkedTag addTagSetsObject:tagset];
    }
    else
        NSLog(@"%@",[error localizedDescription]);
    
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
    
    self.weight=self.parseObject[P_WEIGHT];
    
    PFObject *fromParseFeatured=[self.parseObject[P_OFFER] fetchIfNeeded:&error];
    if (!error)
    {
        [self.taggedFeature removeFeaturedTagSetsObject:self];
        Featured *linkedFeatured=[Featured getByID:fromParseFeatured.objectId];
        self.taggedFeature = linkedFeatured;
        [linkedFeatured addFeaturedTagSetsObject:self];
        
    }
    else
        NSLog(@"%@",[error localizedDescription]);
    
    
    PFObject *fromParseTag=[self.parseObject[P_TAG] fetchIfNeeded:&error];
    
    if (!error)
    {
        [self.tagInSet removeTagSetsObject:self];
        Tag *linkedTag=[Tag getByID:fromParseTag.objectId];
        self.tagInSet = linkedTag;
        [linkedTag addTagSetsObject:self];
    }
    else
        NSLog(@"%@",[error localizedDescription]);
}

@end
