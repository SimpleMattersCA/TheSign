//
//  Statistics.h
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-05-24.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

@import Foundation;
@import CoreData;



@interface Statistics : NSManagedObject


@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * major;
@property (nonatomic, retain) NSNumber * minor;

+(NSString*) entityName;
+(NSString*) colMajor;
+(NSString*) colMinor;
+(NSString*) colDate;

+(void) recordBeaconDetectedOn:(NSDate*) date withMajor:(NSNumber*) major andMinor: (NSNumber*) minor;

+(NSArray*) getStatisticsFrom:(NSDate*) startDate To:(NSDate*) endDate ForMajor:(NSNumber*) major andMinor:(NSNumber*)minor;

@end
