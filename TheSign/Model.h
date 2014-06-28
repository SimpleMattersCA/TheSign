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


@class Business,Statistics;
/**
 Encapsulated some of the basics of the model such as pulling data from Parse and filling CoreData
 */
@interface Model : NSObject 


@property (nonatomic, retain) Settings* settings;


@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (Model*) sharedModel;

- (NSURL *)applicationDocumentsDirectory;

/**
 Getting data from Parse and putting it to CoreData
 */
- (void) pullFromCloud;


-(void) saveContext;


//********* Commonly used methods from Statistics Class *********//
-(Statistics*)recordStatisticsFromBeaconMajor:(NSNumber*)major Minor:(NSNumber*)minor;
-(Statistics*)recordStatisticsFromGPS:(NSNumber*)businessUID;


//********* Commonly used methods from Business Class *********//
-(CLLocation*)getClosestBusinessToLocation:(CLLocation*)location;


//********* For testign purpoces *********//
-(void)checkModel;


@end
