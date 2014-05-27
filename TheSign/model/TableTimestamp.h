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

#define TIMESTAMP (@"TableTimestamp")
#define TIMESTAMP_TABLENAME (@"tableName")
#define TIMESTAMP_DATE (@"timeStamp")

@interface TableTimestamp : NSManagedObject <SignEntityProtocol>

@property (nonatomic, retain) NSString * pObjectID;
@property (nonatomic, retain) NSString * tableName;
@property (nonatomic, retain) NSDate * timeStamp;


+(NSDate*) getUpdateTimestampForTable:(NSString*)tName;



@end
