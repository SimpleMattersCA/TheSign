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
-(void) deleteDataStore;
-(void)checkDeleteHistory;
-(NSArray*) getObjectsDeletedFromParse;


@end
