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


@interface Model : NSObject 

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, strong) NSArray* businesses;

-(Business*) getBusinessByID:(NSInteger)identifier;
-(NSString*) getWelcomeTextByBusinessID:(NSInteger)identifier;
-(NSString*) getBusinessNameByBusinessID:(NSInteger)identifier;



+ (Model*) sharedModel;

- (NSURL *)applicationDocumentsDirectory;

- (void) pullFromCloud;

@end
