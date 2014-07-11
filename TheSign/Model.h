//
//  Model.h
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-03-21.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

@import UIKit;
@import CoreData;
#import "Settings.h"
#import "Parse/Parse.h"

typedef NS_ENUM(NSInteger, OfferLike) {
    LK_None,
    LK_Like,
    LK_Dislike
};


@class Business,Statistics,Location;
/**
 Encapsulated some of the basics of the model such as pulling data from Parse and filling CoreData
 */
@interface Model : NSObject 


@property (nonatomic, retain) NSString * beaconUUID;
@property (nonatomic, retain) NSNumber * prob_pref;
@property (nonatomic, retain) NSNumber * relevancyDepth;
@property (nonatomic, retain) NSNumber * min_like_level;
@property (nonatomic, retain) NSNumber * prob_no_relev;
@property (nonatomic, retain) NSNumber * lk_none;
@property (nonatomic, retain) NSNumber * lk_like;
@property (nonatomic, retain) NSNumber * lk_dislike;
@property (nonatomic, retain) NSNumber * min_negativeScore;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (Model*) sharedModel;

- (NSURL *)applicationDocumentsDirectory;

-(void) saveContext;

-(double)getLikeValueForAction:(OfferLike)action;


//********* Commonly used methods from Statistics Class *********//
-(Statistics*)recordStatisticsFromBeaconMajor:(NSNumber*)major Minor:(NSNumber*)minor;
-(Statistics*)recordStatisticsFromGPS:(NSNumber*)businessUID;


//********* Commonly used methods from Business Class *********//
-(Location*)getClosestBusinessToLocation:(CLLocation*)location;


//********* For testign purpoces *********//
-(Boolean)checkModel;
-(void)deleteModel;


@end
