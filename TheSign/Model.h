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




@interface Model : NSObject 

@property NSDate* weatherTimestamp;
@property NSNumber* currentTemperature;
@property NSString* currentWeather;


@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

//@property (nonatomic, strong) NSArray* businesses;

//-(Business*) getBusinessByID:(NSInteger)identifier;
//-(NSString*) getWelcomeTextByBusinessID:(NSInteger)identifier;
//-(NSString*) getBusinessNameByBusinessID:(NSInteger)identifier;
//return the array of offers for a detected beacon
//-(NSArray*) getOffersByMajor:(NSNumber*)major andMinor:(NSNumber*)minor;


//-(void) recordBeaconDetectedOn:(NSDate*) date withMajor:(NSNumber*) major andMinor: (NSNumber*) minor;

+ (Model*) sharedModel;

- (NSURL *)applicationDocumentsDirectory;

- (void) pullFromCloud;

-(void) saveContext;

@end
