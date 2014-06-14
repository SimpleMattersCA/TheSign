//
//  Statistics.h
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-06-13.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Featured;

@interface Statistics : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * major;
@property (nonatomic, retain) NSNumber * minor;
@property (nonatomic, retain) NSNumber * wasOpened;
@property (nonatomic, retain) NSNumber * liked;
@property (nonatomic, retain) Featured *referenceOffer;

+(NSString*) entityName;
+(NSString*) colDate;
+(NSString*) colMajor;
+(NSString*) colMinor;
+(NSString*) colWasOpened;
+(NSString*) colLiked;
+(NSString*) colReferenceOffer;

-(void) savePreference:(Featured*)offer Liked:(Boolean)liked;

+(Statistics*) recordBeaconDetectedOn:(NSDate*) date withMajor:(NSNumber*) major andMinor: (NSNumber*) minor;

+(NSArray*) getStatisticsFrom:(NSDate*) startDate To:(NSDate*) endDate ForMajor:(NSNumber*) major andMinor:(NSNumber*)minor;



@end
