//
//  TagConnection.m
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-06-19.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import "TagConnection.h"
#import "Tag.h"
#import "Model.h"
#import "TagSet.h"
#import "Relevancy.h"
#import "Featured.h"

#define P_WEIGHT (@"weight")
#define P_CONTROL_TAG (@"controlTag")
#define P_RELATED_TAG (@"relatedTag")

#define CD_WEIGHT (@"weight")
#define CD_CONTROL_TAG (@"controlTag")
#define CD_RELATED_TAG (@"relatedTag")

@implementation TagConnection

@dynamic pObjectID;
@dynamic weight;
@dynamic linkedTag1;
@dynamic linkedTag2;

@synthesize parseObject=_parseObject;

+(NSString*) entityName {return @"TagConnection";}
+(NSString*) parseEntityName {return @"TagConnection";}

+(TagConnection*) getByID:(NSString*)identifier
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
        return (TagConnection*)result.firstObject;
}

+ (void)createFromParse:(PFObject *)object
{
    
    TagConnection *connection = [NSEntityDescription insertNewObjectForEntityForName:[self entityName]
                                                              inManagedObjectContext:[Model sharedModel].managedObjectContext];
    connection.parseObject=object;
    connection.pObjectID=object.objectId;
    if(object[P_WEIGHT]!=nil) connection.weight=object[P_WEIGHT];
        
    //careful, incomplete object - only objectId property is there
    PFObject *fromParseControlTag=object[P_CONTROL_TAG];
    Tag *linkedControlTag=[Tag getByID:fromParseControlTag.objectId];
    if (linkedControlTag!=nil)
    {
        connection.linkedTag1=linkedControlTag;
        [linkedControlTag addLinkedConnections1Object:connection];
    }
    else
        NSLog(@"Linked tag wasn't found");
    
    //careful, incomplete object - only objectId property is there
    PFObject *fromParseRelatedTag=object[P_RELATED_TAG];
    Tag *linkedRelatedTag=[Tag getByID:fromParseRelatedTag.objectId];
    if (linkedRelatedTag!=nil)
    {
        connection.linkedTag2=linkedRelatedTag;
        [linkedRelatedTag addLinkedConnections2Object:connection];
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
    {
        for(TagSet* tagset in self.linkedTag1.linkedTagSets)
            [tagset.linkedOffer.linkedScore rescore];
        
        for(TagSet* tagset in self.linkedTag2.linkedTagSets)
            [tagset.linkedOffer.linkedScore rescore];
    }
    
    self.weight=self.parseObject[P_WEIGHT];
    
    //careful, incomplete object - only objectId property is there
    PFObject *fromParseControlTag=self.parseObject[P_CONTROL_TAG];
    if (fromParseControlTag.objectId!=self.linkedTag1.pObjectID)
    {
        [self.linkedTag1 removeLinkedConnections1Object:self];
        Tag *linkedControlTag=[Tag getByID:fromParseControlTag.objectId];
        if (linkedControlTag!=nil)
        {
            self.linkedTag1=linkedControlTag;
            [linkedControlTag addLinkedConnections1Object:self];
        }
        else
            NSLog(@"Linked tag wasn't found");
    }
    
    //careful, incomplete object - only objectId property is there
    PFObject *fromParseRelatedTag=self.parseObject[P_RELATED_TAG];
    if (fromParseRelatedTag.objectId!=self.linkedTag2.pObjectID)
    {
        [self.linkedTag2 removeLinkedConnections2Object:self];
        Tag *linkedRelatedTag=[Tag getByID:fromParseRelatedTag.objectId];
        if (linkedRelatedTag!=nil)
        {
            self.linkedTag2=linkedRelatedTag;
            [linkedRelatedTag addLinkedConnections2Object:self];
        }
        else
            NSLog(@"Linked tag wasn't found");
    }
}



@end
