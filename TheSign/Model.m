//
//  Model.m
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-03-21.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//


#import "Model.h"
#import "Featured.h"
#import "Business.h"
#import "Tag.h"
#import "TagSet.h"
#import "TagConnection.h"
#import "Link.h"
#import "Statistics.h"
#import "TableTimestamp.h"
#import "Parse/Parse.h"
#import "Settings.h"
#import "Location.h"



@interface Model()

@property (strong) NSTimer *timer;




@end

@implementation Model

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize settings=_settings;


- (Settings*) getSettings
{
    if(!_settings)
        _settings=[Settings getSettingsSet];
    return _settings;
}

#pragma mark - model initialization
- (id)init
{
    if (self = [super init])
    {
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(itemPulledFromCloud:)
                                                     name:@"itemPulledFromCloud"
                                                   object:nil];
        
        self.timer=[NSTimer scheduledTimerWithTimeInterval:3600 target:self selector:@selector(requestCloud) userInfo:nil repeats:YES];
        [self.timer setTolerance:600];
        [self.timer fire];
        //when you do too many changes to data model it might be neccessary to explisistly delete the current datastore in order to build a new one
        //[self deleteModel];
       // [self performSelectorInBackground:@selector(checkModel) withObject:nil];
        
    }
    return self;
}

- (void) requestCloud
{
//TODO: change timer's next fire at night (nobody is gonna update any deals then)
//TODO: location specific weather
    [Statistics sendToCloud];
    [self performSelectorInBackground:@selector(checkModel) withObject:nil];
}



+(Model*)sharedModel
{
    static Model *sharedModelObj = nil;    // static instance variable
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedModelObj = [[self alloc] init];
    });
    return sharedModelObj;
}


/*-(void)checkWeather
{
    PFQuery *query = [PFQuery queryWithClassName:@"WeatherData"];
    [query orderByDescending:@"createdAt"];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *parseWeather, NSError *error) {
        if (!error)
        {
            self.currentTemperature=parseWeather[@"currentTemp"];
            self.currentWeather=parseWeather[@"summary"];
            self.weatherTimestamp=parseWeather.createdAt;
        }
        else
        {
            // Log details of the failure
            NSLog(@"Error in CheckWeather: %@ %@", error, [error userInfo]);
        }
    }];
}*/




//check if we need to pull data from parse based on comparing timestamps of the tables.
-(void)checkModel
{
    
   /* NetworkStatus status = reachability.currentReachabilityStatus;
    switch(status)
    {
        case ReachableViaWiFi:
            // There's a wifi connection, go ahead and download
            break;
        case ReachableViaWWAN:
            // There's only a cell connection, so you may or may not want to download
            break;
        case NotReachable:
            // No connection at all! Bad signal, or perhaps airplane mode?
            break;
    }
    */
    
    
    //pull from cloud for
    PFQuery *query = [PFQuery queryWithClassName:TableTimestamp.parseEntityName];
    NSError *error;
    [query orderByAscending:TableTimestamp.pOrder];
    NSArray *objects=[query findObjects:&error];
    
    if (!error)
    {
        for (PFObject *object in objects)
        {
            NSString *tableName=object[TableTimestamp.pTableName];
            NSDate *timestamp=[TableTimestamp getUpdateTimestampForTable:tableName];
            if(![timestamp isEqualToDate:object[TableTimestamp.pTimeStamp]])
            {
                [self pullFromCloud:tableName];
            }
        }
        [self pullFromCloud:TableTimestamp.parseEntityName];
    }
    else
    {
        NSLog(@"Error in CheckModel: %@ %@", error, [error userInfo]);
    }
   
}

-(void)pullFromCloud
{
    for(NSString *tableName in [TableTimestamp getTableNames])
        [self pullFromCloud:tableName];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"databaseUpdated" object:self];

}
/**
 deleting the model
 */
-(void)deleteModel
{
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"SignModel.sqlite"];
    [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
}

-(Class)getClassForParseEntity:(NSString*)entityName
{
    if([entityName isEqualToString:Business.parseEntityName])
        return [Business class];
    if([entityName isEqualToString:Link.parseEntityName])
        return [Link class];
    if([entityName isEqualToString:Featured.parseEntityName])
        return [Featured class];
    if([entityName isEqualToString:Tag.parseEntityName])
        return [Tag class];
    if([entityName isEqualToString:TagSet.parseEntityName])
        return [TagSet class];
    if([entityName isEqualToString:TagConnection.parseEntityName])
        return [TagConnection class];
    if([entityName isEqualToString:Location.parseEntityName])
        return [Location class];
    if([entityName isEqualToString:TableTimestamp.parseEntityName])
        return [TableTimestamp class];
    
    return nil;
}



//The method for pulling data from Parse based on the requested table name
-(void)pullFromCloud:(NSString*)cloudEntityName
{
    
    Class targetClass=[self getClassForParseEntity:cloudEntityName];
    NSDate* cdTimestamp=[TableTimestamp getUpdateTimestampForTable:cloudEntityName];
    
    PFQuery *query = [PFQuery queryWithClassName:cloudEntityName];
    if (cdTimestamp!=nil)[query whereKey:@"updatedAt" greaterThan:cdTimestamp];
    NSError *error;
    NSArray *result=[query findObjects:&error];

    if (!error)
    {
        //delete entity from coredata, so we can create a new one
      //  [self deleteEntity:entityName];
        //go through the objects we got from Parse
        
        
        for (PFObject *object in result)
        {
            id cdObject=[targetClass getByID:object.objectId];
            
            if(cdObject!=nil)
                [cdObject refreshFromParse];
            else
                [targetClass createFromParse:object];
        }
      
        
        // [[NSNotificationCenter defaultCenter] postNotificationName:@"pulledNewDataFromCloud"
     //                                                       object:self
        //                                                  userInfo:[NSDictionary dictionaryWithObject:entityName forKey:@"Entity"]];
    }
    else
        NSLog(@"Pulling from cloud error: %@ %@", error, [error userInfo]);
    

}

-(void)deleteObjectForClass:(Class)class ParseObjectID:(NSString*)pObjectID
{
    NSManagedObject* objectToDelete=[class getByID:pObjectID];
    if(objectToDelete)
        [self.managedObjectContext deleteObject:objectToDelete];
}


//deleting all objects from CoreData for a specific entity
-(void)deleteEntity:(NSString*)entityName
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    NSError *error;
    NSArray *objects = [self.managedObjectContext executeFetchRequest:request error:&error];
    for (NSManagedObject *object in objects)
    {
        [self.managedObjectContext deleteObject:object];
    }
    
    [self saveContext];
}


- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Failed to save to data store: %@", [error localizedDescription]);
            NSArray* detailedErrors = [[error userInfo] objectForKey:NSDetailedErrorsKey];
            if(detailedErrors != nil && [detailedErrors count] > 0) {
                for(NSError* detailedError in detailedErrors) {
                    NSLog(@"  DetailedError: %@", [detailedError userInfo]);
                }
            }
            else {
                NSLog(@"  %@", [error userInfo]);
            }
        }
    }
}


#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
   
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
        if (coordinator != nil) {
            _managedObjectContext = [[NSManagedObjectContext alloc] init];
            [_managedObjectContext setPersistentStoreCoordinator:coordinator];
        }
   
    
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"SignModel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"SignModel.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];

    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        [self deleteModel];
        [self checkModel];

        //abort();
    }
    
    return _persistentStoreCoordinator;
}





#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}




#pragma mark - Sending requests for commonly used methods to approrpiate classes
//Commonly used methods from Statistics Class

-(Statistics*)recordStatisticsFromBeaconMajor:(NSNumber*)major Minor:(NSNumber*)minor
{
    return [Statistics recordStatisticsFromBeaconMajor:major Minor:minor];
}
-(Statistics*)recordStatisticsFromGPS:(NSNumber*)businessUID
{
    return [Statistics recordStatisticsFromGPS:businessUID];
}

-(CLLocation*)getClosestBusinessToLocation:(CLLocation*)location
{
    return [Business getClosestBusinessToLocation:location];
}

@end
