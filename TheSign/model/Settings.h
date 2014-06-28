//
//  Settings.h
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-06-25.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

@import Foundation;
@import CoreData;


@interface Settings : NSManagedObject

@property (nonatomic, retain) NSString * beaconUUID;
@property (nonatomic, retain) NSNumber * prob_weather;
@property (nonatomic, retain) NSNumber * prob_pref;
@property (nonatomic, retain) NSNumber * prob_day;
@property (nonatomic, retain) NSNumber * prob_date;
@property (nonatomic, retain) NSNumber * relevancyDepth;
@property (nonatomic, retain) NSNumber * minLike;
@property (nonatomic, retain) NSNumber * lk_none;
@property (nonatomic, retain) NSNumber * lk_like;
@property (nonatomic, retain) NSNumber * lk_dislike;


+(Settings*)getSettingsSet;

@end
