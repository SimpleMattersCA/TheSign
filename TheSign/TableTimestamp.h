//
//  TableTimestamp.h
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-03-23.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TableTimestamp : NSManagedObject

@property (nonatomic, retain) NSString * tableName;
@property (nonatomic, retain) NSDate * timeStamp;

@end
