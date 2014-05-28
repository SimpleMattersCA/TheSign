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

+(NSString*) entityName {return @"TableTimestamp";}
+(NSString*) parseEntityName {return @"UpdateTimestamps";}

+(NSString*)colTableName {return @"tableName";}
+(NSString*)colTimeStamp {return @"timeStamp";}
+(NSString*)colOrder {return @"order";}

+(NSString*)pTableName {return @"TableName";}
+(NSString*)pTimeStamp {return @"TimeStamp";}
+(NSString*)pOrder {return TableTimestamp.colOrder;}

+(TableTimestamp*) getByID:(NSString*)identifier
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
        return (TableTimestamp*)result.firstObject;
}

+(NSDate*) getUpdateTimestampForTable:(NSString*)tName
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:TableTimestamp.entityName];
    NSString *predicate = [NSString stringWithFormat: @"%@==\"%@\"", TableTimestamp.colTableName,tName];
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
    TableTimestamp *timeStamp = [NSEntityDescription insertNewObjectForEntityForName:self.entityName
                                                          inManagedObjectContext:[Model sharedModel].managedObjectContext];
    timeStamp.pObjectID=object.objectId;
    timeStamp.timeStamp=object[TableTimestamp.pTimeStamp];
    timeStamp.tableName=object[TableTimestamp.pTableName];
    timeStamp.order=object[TableTimestamp.pOrder];
}

+ (NSArray*)getTableNames
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:TableTimestamp.entityName];
    NSError *error;
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:TableTimestamp.colOrder ascending:YES];
    [request setSortDescriptors:@[sortDescriptor]];
    NSArray *timestamps = [[Model sharedModel].managedObjectContext executeFetchRequest:request error:&error];
    
    if(error)
    {
        NSLog(@"%@",[error localizedDescription]);
        return nil;
    }
    else
    {
        
        return [timestamps valueForKey:TableTimestamp.colTableName];
    }
}

@end
