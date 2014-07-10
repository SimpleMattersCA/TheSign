//
//  Settings.h
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-06-25.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

@import Foundation;
@import CoreData;
#import "SignEntityProtocol.h"

@interface Settings : NSManagedObject <SignEntityProtocol>

@property (nonatomic, retain) NSString * pObjectID;
@property (nonatomic, retain) NSString * beaconUUID;
@property (nonatomic, retain) NSNumber * prob_pref;
@property (nonatomic, retain) NSNumber * relevancyDepth;
@property (nonatomic, retain) NSNumber * minLike;
@property (nonatomic, retain) NSNumber * minProb;
@property (nonatomic, retain) NSNumber * lk_none;
@property (nonatomic, retain) NSNumber * lk_like;
@property (nonatomic, retain) NSNumber * lk_dislike;

+(Settings*)getSettingsSet;

@end
