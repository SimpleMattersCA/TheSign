//
//  Area.h
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-07-04.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

@import Foundation;
@import CoreData;
#import "SignEntityProtocol.h"

@class Location;

@interface Area : NSManagedObject <SignEntityProtocol>

@property (nonatomic, retain) NSString * pObjectID;
@property (nonatomic, retain) NSNumber * currentTemperature;
@property (nonatomic, retain) NSString * currentWeather;
@property (nonatomic, retain) NSDate * weatherTimestamp;
@property (nonatomic, retain) NSSet *linkedLocations;
@end

@interface Area (CoreDataGeneratedAccessors)

- (void)addLinkedLocationsObject:(Location *)value;
- (void)removeLinkedLocationsObject:(Location *)value;
- (void)addLinkedLocations:(NSSet *)values;
- (void)removeLinkedLocations:(NSSet *)values;

@end
