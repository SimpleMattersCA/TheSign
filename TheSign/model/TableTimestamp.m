//
//  TableTimestamp.m
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-05-24.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import "TableTimestamp.h"
#import "Model.h"

@implementation TableTimestamp

@dynamic pObjectID;
@dynamic tableName;
@dynamic timeStamp;
@dynamic order;

+(NSString*) entityName
{
    return TIMESTAMP;
}
+(NSString*) parseEntityName
{
    return [self parseName:[self entityName]];
}

+(TableTimestamp*) getByID:(NSString*)identifier
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:TIMESTAMP];
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
        return (TableTimestamp*)result.firstObject;
}
+(NSString*)parseName:(NSString*)coreDataName
{
    if ([coreDataName isEqual:TIMESTAMP])
        return @"UpdateTimestamps";
    if ([coreDataName isEqual:TIMESTAMP_TABLENAME])
        return @"TableName";
    if ([coreDataName isEqual:TIMESTAMP_DATE])
        return @"TimeStamp";
    return coreDataName;
}

+(NSDate*) getUpdateTimestampForTable:(NSString*)tName
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[self entityName]];
    NSString *predicate = [NSString stringWithFormat: @"%@==\"%@\"", TIMESTAMP_TABLENAME,tName];
    request.predicate=[NSPredicate predicateWithFormat:predicate];
    NSError *error;
    NSArray *timestamp = [[Model sharedModel].managedObjectContext executeFetchRequest:request error:&error];
    
    if(error)
    {
        NSLog(@"%@",[error localizedDescription]);
        return nil;
    }
    
    if(timestamp.count==0)
        return nil;
    else
        return ((TableTimestamp*)timestamp[0]).timeStamp;
}

+ (void)createFromParseObject:(PFObject *)object
{
    TableTimestamp *timeStamp = [NSEntityDescription insertNewObjectForEntityForName:[self entityName]
                                                          inManagedObjectContext:[Model sharedModel].managedObjectContext];
    timeStamp.pObjectID=object[OBJECT_ID];
    timeStamp.timeStamp=object[[TableTimestamp parseName:TIMESTAMP_DATE]];
    timeStamp.tableName=object[[TableTimestamp parseName:TIMESTAMP_TABLENAME]];
}

+ (NSArray*)getTableNames
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[self entityName]];
    NSError *error;
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:TIMESTAMP_ORDER ascending:YES];
    [request setSortDescriptors:@[sortDescriptor]];
    NSArray *timestamps = [[Model sharedModel].managedObjectContext executeFetchRequest:request error:&error];
    
    if(error)
    {
        NSLog(@"%@",[error localizedDescription]);
        return nil;
    }
    else
    {
        
        return [timestamps valueForKey:TIMESTAMP_TABLENAME];
    }
}

@end
