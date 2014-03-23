//
//  Model.m
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-03-21.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import "Model.h"
#import "Parse/Parse.h"
#import "Business.h"

@import QuartzCore.QuartzCore;
@import CoreData;

@implementation Model

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+(Model*)sharedModel
{
    static Model *sharedModelObj = nil;    // static instance variable
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedModelObj = [[self alloc] init];
    });
    return sharedModelObj;
}

- (id)init
{
    if (self = [super init])
    {
        if([self checkModel])
            [self pullFromCloud];
        else
            [self pullFromCoreData];
    }
    return self;
}
-(BOOL)checkModel
{
    //pull from cloud for
    
    return NO;
}

-(void)pullFromCloud
{
    [self pullFromCloud:@"Business"];
}
-(void)pullFromCoreData
{
    [self pullFromCoreData:@"Business"];
}
-(void)deleteModel
{
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"SignModel.sqlite"];
    [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
 //   [self deleteModel:@"Business"];
}

-(void)pullFromCloud:(NSString*)entityName
{
 
    PFQuery *query = [PFQuery queryWithClassName:entityName];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        if (!error)
        {
            [self deleteModel];
            // NSLog(@"Successfully retrieved %lu .", (unsigned long)objects.count);
            NSInteger i=0;
            for (PFObject *object in objects)
            {
                if([entityName isEqualToString:@"Business"])
                {
                        Business *business = [NSEntityDescription insertNewObjectForEntityForName:@"Business"
                                                                inManagedObjectContext:self.managedObjectContext];
                        business.name=object[@"name"];
                        business.welcomeText=object[@"welcomeText"];
                        business.uid=object[@"uid"];
                
                     PFFile *logo=object[@"logo"];
                    [logo getDataInBackgroundWithBlock:^(NSData *logoFile, NSError *error) {
                        if (!error) {
                            
                            
                            business.logo = logoFile;
                            if(i==objects.count-1)
                            {
                                [self saveContext];
                                [self pullFromCoreData:entityName];
                            }
                        }
                    }];
                   
                }
                i++;
            }
            
            
        }
        else
        {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}



-(void)deleteModel:(NSString*)entityName
{
    if([entityName isEqualToString:@"Business"])
    {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Business"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"uid" ascending:YES]];
        NSError *error;
        NSArray *businesses = [self.managedObjectContext executeFetchRequest:request error:&error];
        for (Business *business in businesses)
        {
            [self.managedObjectContext deleteObject:business];
        }
    }
    [self saveContext];
}



-(void)pullFromCoreData:(NSString*)entityName
{
    if([entityName isEqualToString:@"Business"])
    {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Business"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"uid" ascending:YES]];
        NSError *error;
        NSArray *businessesFromCloud = [self.managedObjectContext executeFetchRequest:request error:&error];
        self.businesses=[[NSArray alloc] initWithArray:businessesFromCloud];
    }
}

-(Business*) getBusinessByID:(NSInteger)identifier
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Business"];
    request.predicate=[NSPredicate predicateWithFormat:@"uid=%d",identifier];
    NSError *error;
    NSArray *business = [self.managedObjectContext executeFetchRequest:request error:&error];
    return (Business*)business[0];
}


-(NSString*) getWelcomeTextByBusinessID:(NSInteger)identifier
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Business"];
    request.predicate=[NSPredicate predicateWithFormat:@"uid=%d",identifier];
    NSError *error;
    NSArray *business = [self.managedObjectContext executeFetchRequest:request error:&error];
    return ((Business*)business[0]).welcomeText;
}

-(NSString*) getBusinessNameByBusinessID:(NSInteger)identifier
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Business"];
    request.predicate=[NSPredicate predicateWithFormat:@"uid=%d",identifier];
    NSError *error;
    NSArray *business = [self.managedObjectContext executeFetchRequest:request error:&error];
    return ((Business*)business[0]).name;
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
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
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
        abort();
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
