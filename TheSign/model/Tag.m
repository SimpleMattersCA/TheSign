//
//  Tag.m
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-05-26.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import "Tag.h"
#import "TagClassRelation.h"
#import "TagSet.h"
#import "Model.h"


@implementation Tag

@dynamic details;
@dynamic name;
@dynamic pObjectID;
@dynamic tagClasses;
@dynamic tagSets;


+(NSString*) entityName
{
    return TAG;
}

+(Tag*) getByID:(NSString*)identifier
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[self entityName]];
    NSString *predicate = [NSString stringWithFormat: @"%@==%@", OBJECT_ID, identifier];
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

+(NSString*)parseName:(NSString*)coreDataName
{
    if ([coreDataName isEqual:TAG_CLASS])
        return @"class";
    if ([coreDataName isEqual:TAG_SET])
        return @"set";
    return coreDataName;
}


+ (void)createFromParseObject:(PFObject *)object
{
    Tag *tag = [NSEntityDescription insertNewObjectForEntityForName:[self entityName]
                                             inManagedObjectContext:[Model sharedModel].managedObjectContext];
    tag.pObjectID=object[OBJECT_ID];
    tag.name=object[[Tag parseName:TAG_NAME]];
    tag.details=object[[Tag parseName:TAG_DETAILS]];
}


@end
