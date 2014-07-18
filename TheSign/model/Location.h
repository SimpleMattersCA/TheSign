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

-(NSNumber*)getTemperature;
-(NSString*)getWeather;
-(NSDate*)getWeatherTime;

+(Location*)getLocationByMajor:(NSNumber*)major Context:(NSManagedObjectContext*)context;

-(CLLocation*)getLocationObject;

@end
