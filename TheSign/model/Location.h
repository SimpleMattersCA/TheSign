//
//  Location.h
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-06-25.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

@import Foundation;
@import CoreData;
#import "SignEntityProtocol.h"

@class Business,CLLocation,Area;

@interface Location : NSManagedObject <SignEntityProtocol>

@property (nonatomic, retain) NSString * pObjectID;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) Business * linkedBusiness;
@property (nonatomic, retain) Area * linkedArea;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSNumber * major;

/**
 Get the numeric value of the temperature at this locaiton. Default - nil
 */
-(NSNumber*)getTemperature;
/**
 Get text description of the weather at this locaiton. Default - nil
 */
-(NSString*)getWeather;
/**
 Get the timestamp of weather infomration at this locaiton. Default - nil
 */
-(NSDate*)getWeatherTime;

/**
 Get the location object for a specific Major iBeacon identifier
 */
+(Location*)getLocationByMajor:(NSNumber*)major Context:(NSManagedObjectContext*)context;

/**
 Return CLLocation object based on this business location's longitude and lattitude
 */
-(CLLocation*)getLocationObject;

@end
