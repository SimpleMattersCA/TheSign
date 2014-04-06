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
#import "Featured.h"
#import "TableTimestamp.h"
#import "Featured.h"
@import CoreData;


typedef NS_ENUM(NSInteger, DownloadedItemType) {
    Downloaded_BusinessLogo,
    Downloaded_FeaturedDeal
};



#define CD_BUSINESS (@"Business")
#define CD_BUSINESS_ID (@"uid")
#define CD_BUSINESS_NAME (@"name")
#define CD_BUSINESS_LOGO (@"logo")
#define CD_BUSINESS_WELCOMETEXT (@"welcomeText")

#define PARSE_BUSINESS (@"Business")
#define PARSE_BUSINESS_ID (@"uid")
#define PARSE_BUSINESS_NAME (@"name")
#define PARSE_BUSINESS_LOGO (@"logo")
#define PARSE_BUSINESS_WELCOMETEXT (@"welcomeText")

#define CD_FEATURED (@"Featured")
#define CD_FEATURED_TITLE (@"title")
#define CD_FEATURED_DETAILS (@"details")
#define CD_FEATURED_VIDEO (@"videoUrl")
#define CD_FEATURED_IMAGE (@"image")
#define CD_FEATURED_BUSINESS (@"featuredBy")

#define PARSE_FEATURED (@"Info")
#define PARSE_FEATURED_TITLE (@"featured")
#define PARSE_FEATURED_DETAILS (@"description")
#define PARSE_FEATURED_VIDEO (@"video")
#define PARSE_FEATURED_IMAGE (@"picture")
#define PARSE_FEATURED_BUSINESS (@"BusinessID")

#define CD_TIMESTAMP (@"TableTimestamp")
#define CD_TIMESTAMP_TABLENAME (@"tableName")
#define CD_TIMESTAMP_DATE (@"timeStamp")

#define PARSE_TIMESTAMP (@"UpdateTimestamps")
#define PARSE_TIMESTAMP_TABLENAME (@"TableName")
#define PARSE_TIMESTAMP_DATE (@"TimeStamp")


@implementation Model

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


#pragma mark - Static boolean flags that totally need to be replaced
//terrible coding ahead
static bool featuredImageDownloaded;
static bool featuredBusinessDownloaded;
//end of terrible coding

-(NSString *)getCoreDataNameByParseName:(NSString*)cloudEntityName
{
    NSString *entityName=@"";
    if([cloudEntityName isEqualToString:PARSE_BUSINESS])
        entityName=CD_BUSINESS;
    if([cloudEntityName isEqualToString:PARSE_FEATURED])
        entityName=CD_FEATURED;
    else if([cloudEntityName isEqualToString:PARSE_TIMESTAMP])
        entityName=CD_TIMESTAMP;
    return entityName;

}

-(NSString *)getParseNameByCoreDataName:(NSString*)entityName
{
    NSString *cloudEntityName=@"";
    if([entityName isEqualToString:CD_BUSINESS])
        cloudEntityName=PARSE_BUSINESS;
    if([entityName isEqualToString:CD_FEATURED])
        cloudEntityName=PARSE_FEATURED;
    else if([entityName isEqualToString:CD_TIMESTAMP])
        cloudEntityName=PARSE_TIMESTAMP;
    return cloudEntityName;
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

- (id)init
{
    if (self = [super init])
    {
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(itemPulledFromCloud:)
                                                     name:@"itemPulledFromCloud"
                                                   object:nil];
        

      //  [self deleteModel];
        [self checkModel];
        [self pullFromCoreData];

    }
    return self;
}



/*!
 
 */
-(BOOL)checkModel
{
    //pull from cloud for
    PFQuery *query = [PFQuery queryWithClassName:PARSE_TIMESTAMP];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        if (!error)
        {
            BOOL needUpdate=NO;
            for (PFObject *object in objects)
            {
                NSDate *timestamp=[self getUpdateTimestampForTable:object[PARSE_TIMESTAMP_TABLENAME]];
            //    if(![timestamp isEqualToDate:object[PARSE_TIMESTAMP_DATE]])
            //    {
                    [self pullFromCloud:[self getCoreDataNameByParseName:object[PARSE_TIMESTAMP_TABLENAME]]];
                    needUpdate=YES;
            //    }
            }
            if(needUpdate)
            {
                [self pullFromCloud:CD_TIMESTAMP];
            }
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
    //do it through the array
    [self pullFromCloud:CD_BUSINESS];
    [self pullFromCloud:CD_FEATURED];
    [self pullFromCloud:CD_TIMESTAMP];

}
-(void)pullFromCoreData
{
    //do it through array
    [self pullFromCoreData:CD_BUSINESS];
    [self pullFromCoreData:CD_FEATURED];
    [self pullFromCoreData:CD_TIMESTAMP];
}
-(void)deleteModel
{
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"SignModel.sqlite"];
    [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
}


-(void)itemPulledFromCloud:(NSNotification *) notification
{
    bool readyToSave=NO;
    NSString *entity=@"";
    DownloadedItemType type=[((NSNumber*)notification.userInfo[@"DownloadedItem"]) integerValue];
    
    if(type==Downloaded_BusinessLogo)
    {
        entity=CD_BUSINESS;
        readyToSave=YES;
    } else if(type==Downloaded_FeaturedDeal)
    {
         entity=CD_FEATURED;
        if (featuredBusinessDownloaded && featuredImageDownloaded)
            readyToSave=YES;
       
    }
    
    if(readyToSave)
    {
        [self saveContext];
        [self pullFromCoreData:entity];
    }
}





-(void)pullFromCloud:(NSString*)entityName
{
    NSString *cloudEntityName=[self getParseNameByCoreDataName:entityName];
    
    PFQuery *query = [PFQuery queryWithClassName:cloudEntityName];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        if (!error)
        {
            [self deleteEntity:entityName];
            for (PFObject *object in objects)
            {
                if([entityName isEqualToString:CD_BUSINESS])
                {
                    Business *business = [NSEntityDescription insertNewObjectForEntityForName:CD_BUSINESS
                                                                inManagedObjectContext:self.managedObjectContext];
                    business.name=object[PARSE_BUSINESS_NAME];
                    business.welcomeText=object[PARSE_BUSINESS_WELCOMETEXT];
                    business.uid=object[PARSE_BUSINESS_ID];
                    
                    PFFile *logo=object[PARSE_BUSINESS_LOGO];
                    [logo getDataInBackgroundWithBlock:^(NSData *logoFile, NSError *error)
                    {
                        if (!error)
                        {
                            business.logo = logoFile;
                            [self postLocalNotificationForItemDownloadForType:Downloaded_BusinessLogo];
                        }
                        else
                            NSLog(@"%@",[error localizedDescription]);
                    }];
                }
               
                
                if([entityName isEqualToString:CD_FEATURED])
                {
                    Featured *deal = [NSEntityDescription insertNewObjectForEntityForName:CD_FEATURED
                                                                              inManagedObjectContext:self.managedObjectContext];
                    deal.title=object[PARSE_FEATURED_TITLE];
                    deal.details=object[PARSE_FEATURED_DETAILS];
                    deal.videoUrl=object[PARSE_FEATURED_VIDEO];
                    
                    PFFile *image=object[PARSE_FEATURED_IMAGE];
                    featuredImageDownloaded=NO;
                    [image getDataInBackgroundWithBlock:^(NSData *imageFile, NSError *error)
                     {
                         if (!error)
                         {
                             deal.image = imageFile;
                             featuredImageDownloaded=YES;
                             [self postLocalNotificationForItemDownloadForType:Downloaded_FeaturedDeal];
                         }
                         else
                             NSLog(@"%@",[error localizedDescription]);
                     }];

                    PFObject *business = object[PARSE_FEATURED_BUSINESS];
                    featuredBusinessDownloaded=NO;
                    [business fetchIfNeededInBackgroundWithBlock:^(PFObject *retrievedBusiness, NSError *error) {
                        if (!error)
                        {
                            Business *linkedBusiness=[self getBusinessByID:[(NSNumber*)(retrievedBusiness[PARSE_BUSINESS_ID]) integerValue]];
                            deal.featuredBy = linkedBusiness;
                            
#pragma mark - not very safe adding deal to business before it was saved context
                            [linkedBusiness addFeatureObject:deal];
                            featuredBusinessDownloaded=YES;
                            [self postLocalNotificationForItemDownloadForType:Downloaded_FeaturedDeal];
                        }
                        else
                            NSLog(@"%@",[error localizedDescription]);
                    }];
                }
                
                
                if([entityName isEqualToString:CD_TIMESTAMP])
                {
                    TableTimestamp *timeStamp = [NSEntityDescription insertNewObjectForEntityForName:CD_TIMESTAMP
                                                                              inManagedObjectContext:self.managedObjectContext];
                    timeStamp.timeStamp=object[PARSE_TIMESTAMP_DATE];
                    timeStamp.tableName=object[PARSE_TIMESTAMP_TABLENAME];
                }
            }
        }
        else
        {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pulledNewDataFromCloud" object:self];
}

-(void)postLocalNotificationForItemDownloadForType:(DownloadedItemType) type
{
    NSDictionary* dict = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:type] forKey:@"DownloadedItem"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"itemPulledFromCloud" object:self userInfo:dict];
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

-(Business*) getBusinessByID:(NSInteger)identifier
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:CD_BUSINESS];
    NSString *predicate = [NSString stringWithFormat: @"%@==%ld", CD_BUSINESS_ID, (long)identifier];
    request.predicate=[NSPredicate predicateWithFormat:predicate];
    NSError *error;
    NSArray *business = [self.managedObjectContext executeFetchRequest:request error:&error];
    if(business.count==0)
        return nil;
    else
        return (Business*)business[0];
}
                   
-(NSDate*) getUpdateTimestampForTable:(NSString*)tName
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:CD_TIMESTAMP];
    NSString *predicate = [NSString stringWithFormat: @"%@==\"%@\"", CD_TIMESTAMP_TABLENAME,tName];
    request.predicate=[NSPredicate predicateWithFormat:predicate];
    NSError *error;
    NSArray *timestamp = [self.managedObjectContext executeFetchRequest:request error:&error];
    if(timestamp.count==0)
        return nil;
    else
        return ((TableTimestamp*)timestamp[0]).timeStamp;
}


-(NSString*) getWelcomeTextByBusinessID:(NSInteger)identifier
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:CD_BUSINESS];
    NSString *predicate = [NSString stringWithFormat: @"%@==%ld", CD_BUSINESS_ID, (long)identifier];
    request.predicate=[NSPredicate predicateWithFormat:predicate];
    NSError *error;
    NSArray *business = [self.managedObjectContext executeFetchRequest:request error:&error];
    if(business.count==0)
        return nil;
    else
        return ((Business*)business[0]).welcomeText;
}

-(NSString*) getBusinessNameByBusinessID:(NSInteger)identifier
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:CD_BUSINESS];
    NSString *predicate = [NSString stringWithFormat: @"%@==%ld", CD_BUSINESS_ID, (long)identifier];
    request.predicate=[NSPredicate predicateWithFormat:predicate];
    NSError *error;
    NSArray *business = [self.managedObjectContext executeFetchRequest:request error:&error];
    if(business.count==0)
        return nil;
    else
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
