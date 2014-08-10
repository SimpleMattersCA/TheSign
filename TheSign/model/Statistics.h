//
//  Statistics.h
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-06-19.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

@import Foundation;
@import CoreData;
#import "SignEntityProtocol.h"


@class Featured, User,Business;

@interface Statistics : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * liked;
@property (nonatomic, retain) NSNumber * synced;
@property (nonatomic, retain) NSNumber * major;
@property (nonatomic, retain) NSNumber * minor;
@property (nonatomic, retain) NSNumber * wasOpened;
@property (nonatomic, retain) User *linkedUser;
@property (nonatomic, retain) Featured *linkedOffer;
@property (nonatomic, retain) NSNumber * statType;

/**
 Tying a deal to statistics object
 */
-(void)setDeal:(Featured*)offer;

/**
 
 */
+(void)sendToCloudForContext:(NSManagedObjectContext*)context;

/**
 Creating a statistics object for offer opened from inside the app
 */
+(Statistics*)recordStatisticsFromFeedForContext:(NSManagedObjectContext*)context;

/**
 Creating a statistics object for offer opened from iBeacon notification
 */
+(Statistics*)recordStatisticsFromBeaconMajor:(NSNumber*)major Minor:(NSNumber*)minor Context:(NSManagedObjectContext*)context;

/**
 Creating a statistics object for offer opened from GPS notificaiton
 */
+(Statistics*)recordStatisticsFromGPS:(NSNumber*)businessUID Context:(NSManagedObjectContext*)context;

+(NSString*) entityName;
+(NSString*) parseEntityName;

@end
