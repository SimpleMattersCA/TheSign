//
//  TableTimestamp.h
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-05-24.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

@import Foundation;
@import CoreData;
#import "SignEntityProtocol.h"


@interface TableTimestamp : NSManagedObject <SignEntityProtocol>

@property (nonatomic, retain) NSString * pObjectID;
@property (nonatomic, retain) NSString * tableName;
@property (nonatomic, retain) NSDate * timeStamp;
@property (nonatomic, retain) NSNumber * order;

+(NSString*)pTableName;
+(NSString*)pTimeStamp;
+(NSString*)pOrder;

+(NSDate*) getUpdateTimestampForTable:(NSString*)tName;
+ (NSArray*)getTableNames;



@end
