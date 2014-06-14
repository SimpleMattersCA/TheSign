//
//  TagConnection.m
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-06-13.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import "TagConnection.h"
#import "Tag.h"
#import "Model.h"

#define P_WEIGHT (@"weight")
#define P_CONTROL_TAG (@"controlTag")
#define P_RELATED_TAG (@"relatedTag")

#define CD_WEIGHT (@"weight")
#define CD_CONTROL_TAG (@"controlTag")
#define CD_RELATED_TAG (@"relatedTag")

@implementation TagConnection

@dynamic pObjectID;
@dynamic weight;
@dynamic relatedTag;
@dynamic controlTag;

@synthesize parseObject=_parseObject;

+(NSString*) entityName {return @"TagConnection";}
+(NSString*) parseEntityName {return @"TagConnection";}

+(TagConnection*) getByID:(NSString*)identifier
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
        return (TagConnection*)result.firstObject;
}

+ (void)createFromParse:(PFObject *)object
{
    TagConnection *connection = [NSEntityDescription insertNewObjectForEntityForName:[self entityName]
                                                                   inManagedObjectContext:[Model sharedModel].managedObjectContext];
    connection.parseObject=object;
    connection.pObjectID=object.objectId;
    if(object[P_WEIGHT]!=nil) connection.weight=object[P_WEIGHT];
    
    NSError *error;
    PFObject *fromParseControlTag=[object[P_CONTROL_TAG] fetchIfNeeded:&error];
    if (!error)
    {
        Tag *linkedControlTag=[Tag getByID:fromParseControlTag.objectId];
        connection.controlTag=linkedControlTag;
        [linkedControlTag addControlConnectionObject:connection];
    }
    else
        NSLog(@"%@",[error localizedDescription]);
    
    PFObject *fromParseRelatedTag=[object[P_RELATED_TAG] fetchIfNeeded:&error];
    if (!error)
    {
        Tag *linkedRelatedTag=[Tag getByID:fromParseRelatedTag.objectId];
        connection.relatedTag=linkedRelatedTag;
        [linkedRelatedTag addRelatedConnectionObject:connection];
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
    
    PFObject *fromParseControlTag=[self.parseObject[P_CONTROL_TAG] fetchIfNeeded:&error];
    if (!error)
    {
        [self.controlTag removeControlConnectionObject:self];
        Tag *linkedControlTag=[Tag getByID:fromParseControlTag.objectId];
        self.controlTag=linkedControlTag;
        [linkedControlTag addControlConnectionObject:self];
    }
    else
        NSLog(@"%@",[error localizedDescription]);
    
    PFObject *fromParseRelatedTag=[self.parseObject[P_RELATED_TAG] fetchIfNeeded:&error];
    if (!error)
    {
        [self.relatedTag removeRelatedConnectionObject:self];
        Tag *linkedRelatedTag=[Tag getByID:fromParseRelatedTag.objectId];
        self.relatedTag=linkedRelatedTag;
        [linkedRelatedTag addRelatedConnectionObject:self];
    }
    else
        NSLog(@"%@",[error localizedDescription]);
    
}


@end
