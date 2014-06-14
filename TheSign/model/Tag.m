//
//  Tag.m
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-06-13.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import "Tag.h"
#import "TagConnection.h"
#import "TagSet.h"
#import "Model.h"

#define P_NAME (@"name")
#define P_DETAILS (@"details")

#define CD_NAME (@"name")
#define CD_DETAILS (@"details")

@implementation Tag

@dynamic details;
@dynamic name;
@dynamic pObjectID;
@dynamic controlConnection;
@dynamic tagSets;
@dynamic relatedConnection;

@synthesize parseObject=_parseObject;

+(NSString*) entityName {return @"Tag";}
+(NSString*) parseEntityName {return @"Tag";}


+(Tag*) getByID:(NSString*)identifier
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
        return (Tag*)result.firstObject;
}


+ (void)createFromParse:(PFObject *)object
{
    Tag *tag = [NSEntityDescription insertNewObjectForEntityForName:self.entityName
                                             inManagedObjectContext:[Model sharedModel].managedObjectContext];
    tag.parseObject=object;
    tag.pObjectID=object.objectId;
    if(object[P_NAME]!=nil) tag.name=object[P_NAME];
    tag.details=object[P_DETAILS];
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
    self.name=self.parseObject[P_NAME];
    self.details=self.parseObject[P_DETAILS];
}

@end
