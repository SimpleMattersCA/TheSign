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
    LK_Dislike,
    LK_UnLike,
    LK_UnDislike
};


@class Business,Statistics,Location,User;
/**
 Encapsulated some of the basics of the model such as pulling data from Parse and filling CoreData
 */
@interface Model : NSObject 


@property (nonatomic, strong) User * currentUser;


@property (nonatomic, strong) NSString * beaconUUID;
@property (nonatomic, strong) NSNumber * prob_pref;
@property (nonatomic, strong) NSNumber * relevancyDepth;
@property (nonatomic, strong) NSNumber * min_like_level;
@property (nonatomic, strong) NSNumber * prob_no_relev;
@property (nonatomic, strong) NSNumber * lk_none;
@property (nonatomic, strong) NSNumber * lk_like;
@property (nonatomic, strong) NSNumber * lk_dislike;
@property (nonatomic, strong) NSNumber * min_negativeScore;
@property (nonatomic, strong) NSNumber * offersFeedLimit;
@property (nonatomic, strong) NSNumber * feed_swap_prob;
@property (nonatomic, strong) NSNumber * weather_poll;
@property (nonatomic, strong) NSNumber * interest_value;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContextBackground;

@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (Model*) sharedModel;

- (NSURL *)applicationDocumentsDirectory;

-(void)saveEverything;

-(void) saveContext:(NSManagedObjectContext*)context;

-(double)getLikeValueForAction:(OfferLike)action;

-(NSArray*)getDealsForFeed;


//********* Commonly used methods from Statistics Class *********//
-(Statistics*)recordStatisticsFromBeaconMajor:(NSNumber*)major Minor:(NSNumber*)minor;
-(Statistics*)recordStatisticsFromGPS:(NSNumber*)businessUID;
-(Statistics*)recordStatisticsFromFeed;


//********* Commonly used methods from Business Class *********//
-(Location*)getClosestBusinessToLocation:(CLLocation*)location;

-(NSArray*)getInterests;

-(NSArray*) getBusinesses;


-(Statistics*)getStatisticsByURL:(NSURL*)stringID;


//********* For testign purpoces *********//
-(void) updateDBinBackground:(Boolean)inBackground;

-(void)deleteModelForContext:(NSManagedObjectContext*)context;
-(void) deleteDataStore;
-(void)checkDeleteHistory;
-(NSArray*) getObjectsDeletedFromParse;


@end
