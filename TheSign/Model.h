//
//  Model.h
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-03-21.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

@import UIKit;
@import CoreData;
#import "Business.h"
#import "Parse/Parse.h"
#import "Business.h"
#import "Featured.h"
#import "TableTimestamp.h"
#import "Tag.h"
#import "TagClass.h"
#import "TagSet.h"
#import "TagClass.h"
#import "Statistics.h"
#import "TagClassRelation.h"
#import "TagClassConnection.h"
#import "Link.h"
#import "Favourites.h"



@interface Model : NSObject 

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

-(void)postLocalNotificationForCoreDataRefresh:(NSString*) entityName;

+ (Model*) sharedModel;

- (NSURL *)applicationDocumentsDirectory;

- (void) pullFromCloud;

-(void) saveContext;

@end
