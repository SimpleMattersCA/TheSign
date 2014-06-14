//
//  TableTimestamp.m
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-05-24.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import "TableTimestamp.h"
#import "Model.h"

#define CD_TABLE (@"tableName")
#define CD_TIMESTAMP (@"timeStamp")
#define CD_ORDER (@"order")

#define P_TABLE (@"TableName")
#define P_TIMESTAMP (@"TimeStamp")
#define P_ORDER (@"order")

@implementation TableTimestamp

@dynamic pObjectID;
@dynamic tableName;
@dynamic timeStamp;
@dynamic order;

@synthesize parseObject=_parseObject;

+(NSString*) entityName {return @"TableTimestamp";}
+(NSString*) parseEntityName {return @"UpdateTimestamps";}

+(NSString*)pTableName {return P_TABLE;}
+(NSString*)pTimeStamp {return P_TIMESTAMP;}
+(NSString*)pOrder {return P_ORDER;}

+ (NSArray*)getTableNames
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:TableTimestamp.entityName];
    NSError *error;
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:CD_ORDER ascending:YES];
    [request setSortDescriptors:@[sortDescriptor]];
    NSArray *timestamps = [[Model sharedModel].managedObjectContext executeFetchRequest:request error:&error];
    
    if(error)
    {
        NSLog(@"%@",[error localizedDescription]);
        return nil;
    }
    else
    {
        return [timestamps valueForKey:CD_TABLE];
    }
}

+(NSDate*) getUpdateTimestampForTable:(NSString*)tName
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:TableTimestamp.entityName];
    NSString *predicate = [NSString stringWithFormat: @"%@==\"%@\"", CD_TABLE,tName];
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



+ (void)createFromParse:(PFObject *)object
{
    TableTimestamp *timeStamp = [NSEntityDescription insertNewObjectForEntityForName:self.entityName
                                                          inManagedObjectContext:[Model sharedModel].managedObjectContext];
    timeStamp.parseObject=object;
    timeStamp.pObjectID=object.objectId;
    timeStamp.timeStamp=object[TableTimestamp.pTimeStamp];
    timeStamp.tableName=object[TableTimestamp.pTableName];
    timeStamp.order=object[TableTimestamp.pOrder];
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
    self.timeStamp=self.parseObject[TableTimestamp.pTimeStamp];
    self.tableName=self.parseObject[TableTimestamp.pTableName];
    self.order=self.parseObject[TableTimestamp.pOrder];
}


@end
