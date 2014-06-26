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

@class Business;

@interface Location : NSManagedObject <SignEntityProtocol>

@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * currentWeather;
@property (nonatomic, retain) NSNumber * currentTemperature;
@property (nonatomic, retain) NSDate * weatherTimestamp;
@property (nonatomic, retain) Business *linkedBusiness;

@end
