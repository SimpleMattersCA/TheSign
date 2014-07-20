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

-(void)setDeal:(Featured*)offer;

+(void)sendToCloudForContext:(NSManagedObjectContext*)context;

+(Statistics*)recordStatisticsFromFeedForContext:(NSManagedObjectContext*)context;
+(Statistics*)recordStatisticsFromBeaconMajor:(NSNumber*)major Minor:(NSNumber*)minor Context:(NSManagedObjectContext*)context;
+(Statistics*)recordStatisticsFromGPS:(NSNumber*)businessUID Context:(NSManagedObjectContext*)context;

+(NSString*) entityName;
+(NSString*) parseEntityName;

@end
