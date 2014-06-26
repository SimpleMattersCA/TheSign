//
//  Model.h
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-03-21.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

@import UIKit;
@import CoreData;
#import "Parse/Parse.h"


typedef NS_ENUM(NSInteger, OfferLike) {
    LK_None,
    LK_Like,
    LK_Dislike
};

NSInteger relevancyDepth=2;

@class Business,Statistics;
/**
 Encapsulated some of the basics of the model such as pulling data from Parse and filling CoreData
 */
@interface Model : NSObject 


///When the weather was updated
@property NSDate* weatherTimestamp;
///The current temperature for Vancouver
@property NSNumber* currentTemperature;
///The description of weather conditions in Vancouver
@property NSString* currentWeather;


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

-(NSArray*) getStatisticsFrom:(NSDate*) startDate To:(NSDate*) endDate ForMajor:(NSNumber*) major andMinor:(NSNumber*)minor;

//********* Commonly used methods from Business Class *********//
-(NSString*) getBusinessNameByBusinessID:(NSInteger)identifier;
-(CLLocation*)getClosestBusinessToLocation:(CLLocation*)location;
-(CLLocation*)getLocationObjectByBusinessID:(NSInteger)identifier;




//********* For testign purpoces *********//
-(void)checkModel;


@end
