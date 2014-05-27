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
#import "TagClass.h"
#import "TagClassConnection.h"
#import "Link.h"
#import "Statistics.h"
#import "Favourites.h"
#import "TableTimestamp.h"


//All table names, columns names are defined there







@implementation Model

//all the tables from coredata that we are dealing with
//NSArray *tables;
//hashtable for items that are being downloaded assynchronysly. Key - objectID, Value - downloading item(column name)
//NSMutableDictionary *downloadingItems;

//all the tables from Parse that we are dealing with.
NSArray *coreDataTableNames;



//array of column names for items that are going to be downloaded assynchronysly (gosh I hate this word)
NSArray *parseDownloadableItems;


@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


#pragma mark - Static boolean flags that totally need to be replaced



#pragma mark - the backbone of model initialization
- (id)init
{
    if (self = [super init])
    {
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(itemPulledFromCloud:)
                                                     name:@"itemPulledFromCloud"
                                                   object:nil];
        
        //tables=[[NSArray alloc]initWithObjects:CD_BUSINESS,CD_FEATURED,CD_TAG,CD_TAGCLASS, CD_TAGSET,nil];

        coreDataTableNames=[NSArray arrayWithObjects:BUSINESS,FEATURED,TAG,TAGCLASS,TAGSET,IMESTAMP, nil];
        
        //when you do too many changes to data model it might be neccessary to explisistly delete the current datastore in order to build a new one
        //self deleteModel];
        [self checkModel];
        [self pullFromCoreData];
        
    }
    return self;
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




//check if we need to pull data from parse based on comparing timestamps of the tables.
-(BOOL)checkModel
{
    //pull from cloud for
    PFQuery *query = [PFQuery queryWithClassName:PARSE_TIMESTAMP];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        if (!error)
        {
            for (PFObject *object in objects)
            {
                NSDate *timestamp=[TableTimestamp getUpdateTimestampForTable:object[PARSE_TIMESTAMP_TABLENAME]];
                if(![timestamp isEqualToDate:object[PARSE_TIMESTAMP_DATE]])
                {
                    [self pullFromCloud:parseToCoreDataNames[PARSE_TIMESTAMP_TABLENAME]];
                }
            }
            [self pullFromCloud:CD_TIMESTAMP];
        }
        else
        {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];

    return NO;
}

-(void)pullFromCloud
{
    for (NSString* tableName in coreDataTableNames)
        [self pullFromCloud:tableName];
}
-(void)pullFromCoreData
{
    for (NSString* tableName in coreDataTableNames)
        [self pullFromCoreData:tableName];
}
-(void)deleteModel
{
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"SignModel.sqlite"];
    [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
}






//items that are downloaded assynchroniously
-(void)itemPulledFromCloud:(NSNotification *) notification
{

   // NSString *itemDownloaded=notification.userInfo[@"DownloadedItem"];
  //  NSString *parseTableNameForDownloadedItem=parseColumnNames[itemDownloaded];
  //  NSString *entity=parseToCoreDataNames[parseTableNameForDownloadedItem];
    
    //check which table downloaded completely, only then selectevely update the table.
    
    

    [self saveContext];
    [self pullFromCoreData];
    //[self pullFromCoreData:entity];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"databaseUpdated" object:self];
    
}















//The method for pulling data from Parse based on the requested table name
-(void)pullFromCloud:(NSString*)entityName
{
    NSString *cloudEntityName=parseToCoreDataNames[entityName];
    PFQuery *query = [PFQuery queryWithClassName:cloudEntityName];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        if (!error)
        {
            //delete entity from coredata, so we can create a new one
            [self deleteEntity:entityName];
            //go through the objects we got from Parse
            for (PFObject *object in objects)
            {
                if([entityName isEqualToString:CD_BUSINESS])
                {
                    [Business createBusinessFromParseObject:object];
                }
               
                
                if([entityName isEqualToString:CD_FEATURED])
                {
                    [Featured createFeaturedFromParseObject:object];
                }
                
                if([entityName isEqualToString:CD_TAG])
                {
                    [Tag createTagFromParseObject:object];
                }
                
                
                
                if([entityName isEqualToString:CD_TIMESTAMP])
                {
                
                }
            }
        }
        else
        {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}


-(void)postLocalNotificationForCoreDataRefresh:(NSString*) entityName
{
    NSDictionary* dict = [NSDictionary dictionaryWithObject:entityName forKey:@"Entity"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pulledNewDataFromCloud" object:self userInfo:dict];
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



//Since for now we use the list of businesses in memory as a starting point to get any data, we are storing the list of businesses in the array accessible everywhere around the app
-(void)pullFromCoreData:(NSString*)entityName
{
    if([entityName isEqualToString:CD_BUSINESS])
    {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:CD_BUSINESS];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:CD_BUSINESS_ID ascending:YES]];
        NSError *error;
        NSArray *businessesFromCloud = [self.managedObjectContext executeFetchRequest:request error:&error];
        self.businesses=[[NSArray alloc] initWithArray:businessesFromCloud];
    }
}


                   








     
     
     

     
- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
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




@end
