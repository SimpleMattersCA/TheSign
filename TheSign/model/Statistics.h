//
//  Statistics.h
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-06-05.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

@import Foundation;
@import CoreData;


@interface Statistics : NSManagedObject

@property (nonatomic, retain) NSNumber * major;
@property (nonatomic, retain) NSNumber * minor;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * openedOffer;

+(NSString*) entityName;
+(NSString*) colMajor;
+(NSString*) colMinor;
+(NSString*) colDate;
+(NSString*) colOpenedOffer;

+(Statistics*) recordBeaconDetectedOn:(NSDate*) date withMajor:(NSNumber*) major andMinor: (NSNumber*) minor;

+(NSArray*) getStatisticsFrom:(NSDate*) startDate To:(NSDate*) endDate ForMajor:(NSNumber*) major andMinor:(NSNumber*)minor;

@end
