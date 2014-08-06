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

///Enum for types of interactions with the offer
typedef NS_ENUM(NSInteger, OfferLike) {
    LK_None,
    LK_Like,
    LK_Dislike,
    //when user cancels his like
    LK_UnLike,
    //when user cancels his dislike
    LK_UnDislike
};


@class Business,Statistics,Location,User;


/**
 Singleton that encapsulated some of the basics of the model such as pulling data from Parse and filling CoreData.
 */
@interface Model : NSObject 


///The object that represents currently logged user
@property (nonatomic, strong) User * currentUser;

///The UUID of the beacons
@property (nonatomic, strong) NSString * beaconUUID;

///Probability of choosing offer based purely on relevancy and not considering context
@property (nonatomic, strong) NSNumber * prob_pref;

///How many levels deep we go into the tags graphs to spread the likeness
@property (nonatomic, strong) NSNumber * relevancyDepth;

///The minimum level of likeness for tags
@property (nonatomic, strong) NSNumber * min_like_level;

///The value that tells if the deal is considered somewhat relevant
@property (nonatomic, strong) NSNumber * prob_no_relev;

///Effect of just looking at the deal
@property (nonatomic, strong) NSNumber * lk_none;

///Effect of liking
@property (nonatomic, strong) NSNumber * lk_like;

///Effect of disliking
@property (nonatomic, strong) NSNumber * lk_dislike;

///Effect of canceling the like
@property (nonatomic, strong) NSNumber * lk_unlike;

///Effect of canceling the dislike
@property (nonatomic, strong) NSNumber * lk_undislike;


///The value of negative relevancy that is considered ok for deal to have. Less than this - it will never be showed anywhere.
@property (nonatomic, strong) NSNumber * min_negativeScore;

///How many deals we load for the feed
@property (nonatomic, strong) NSNumber * offersFeedLimit;

///Maximum probability of swapping deals in the feed for the randomization
@property (nonatomic, strong) NSNumber * feed_swap_prob;

///Time in minutes when weather data becomes irrelevant
@property (nonatomic, strong) NSNumber * weather_poll;

///If interest tag has at least this much of likeness it is considered active
@property (nonatomic, strong) NSNumber * interest_value;




///Object context for main thread operations
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
///Object context for background thread operations
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContextBackground;

@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


/**
 Returns TRUE if the internal database is being updated in the background, FALSE if not
 */
-(BOOL)isBeingUpdated;


/**
 Returns the current object of Model
 */
+ (Model*) sharedModel;

- (NSURL *)applicationDocumentsDirectory;

/**
 Triggers saving all object contexts
 */
-(void)saveEverything;

/**
 Saving particular object context
 */
-(void) saveContext:(NSManagedObjectContext*)context;


-(NSArray*)getDealsForFeed;


//********* Commonly used methods from Statistics Class *********//
-(Statistics*)recordStatisticsFromBeaconMajor:(NSNumber*)major Minor:(NSNumber*)minor;
-(Statistics*)recordStatisticsFromGPS:(NSNumber*)businessUID;
-(Statistics*)recordStatisticsFromFeed;


//********* Commonly used methods from Business Class *********//

/**
 Get the business location that is the closest to a specific geographical location
 */
-(Location*)getClosestBusinessToLocation:(CLLocation*)location;

/**
 Get the array of interest-tags
 */
-(NSArray*)getInterests;

/**
 Get all the businesses
 */
-(NSArray*) getBusinesses;

/**
 Recreating the Statistics object from persistent store based on its NSURL
 */
-(Statistics*)getStatisticsByURL:(NSURL*)stringID;

/**
 Triggering database refresh. 
 @param inBackground If True the update happens in the background thread, if False - in the main thread.
 */
-(void) updateDBinBackground:(Boolean)inBackground;





//********* For testign purpoces *********//
-(Boolean)checkModel;
-(void)deleteModelForContext:(NSManagedObjectContext*)context;
-(void) deleteDataStore;
-(void)checkDeleteHistory;
-(NSArray*) getObjectsDeletedFromParse;


@end
