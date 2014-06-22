//
//  DiscoveredBusiness.h
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-06-19.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

@import Foundation;
@import CoreData;

@class Business,User;

@interface DiscoveredBusiness : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) Business *linkedBusiness;
@property (nonatomic, retain) User *linkedUser;

+(void)updateDiscoveryList:(NSNumber*)businessUID;

@end
