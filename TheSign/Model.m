//
//  Model.m
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-03-21.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//


#import "Model.h"

//All table names, columns names are defined there
#import "Parse_CoreData_Header.h"







@implementation Model

//all the tables from coredata that we are dealing with
//NSArray *tables;
//hashtable for items that are being downloaded assynchronysly. Key - objectID, Value - downloading item(column name)
NSMutableDictionary *downloadingItems;

//all the tables from coredata that we are dealing with.
NSArray *parseTableNames;
//all the tables from Parse that we are dealing with.
NSArray *coreDataTableNames;

//hashtable for converting Core Data Names into Parse Names
NSDictionary *coreDataToParseNames;
//hashtable for column Names For Core Data Tables. Key- column name, value - Table Name
NSDictionary *coreDataColumnNames;

//hashtable for converting Parse Names into Core Data Names
NSDictionary *parseToCoreDataNames;
//hashtable for column Names For Parse Tables. Key- column name, value - Table Name
NSDictionary *parseColumnNames;


//array of column names for items that are going to be downloaded assynchronysly (gosh I hate this word)
NSArray *parseDownloadableItems;


@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


#pragma mark - Static boolean flags that totally need to be replaced



//terrible coding ahead
//static bool featuredImageDownloaded;
//static bool featuredBusinessDownloaded;
//end of terrible coding


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

        coreDataTableNames=[NSArray arrayWithObjects:CD_BUSINESS,CD_FEATURED,CD_TAG,CD_TAGCLASS,CD_TAGSET,CD_TIMESTAMP, nil];
        
        parseTableNames=[NSArray arrayWithObjects:PARSE_BUSINESS,PARSE_FEATURED,PARSE_TAG,PARSE_TAGCLASS,PARSE_TAGSET,PARSE_TIMESTAMP, nil];
        coreDataToParseNames=[NSDictionary dictionaryWithObjects:parseTableNames forKeys:coreDataTableNames];
        parseToCoreDataNames=[NSDictionary dictionaryWithObjects:coreDataTableNames forKeys:parseTableNames];
        
        coreDataColumnNames=[NSDictionary dictionaryWithObjectsAndKeys:
                             CD_BUSINESS,CD_BUSINESS_ID,
                             CD_BUSINESS,CD_BUSINESS_NAME,
                             CD_BUSINESS,CD_BUSINESS_LOGO,
                             CD_BUSINESS,CD_BUSINESS_WELCOMETEXT,
                             
                             CD_FEATURED,CD_FEATURED_TITLE,
                             CD_FEATURED,CD_FEATURED_DETAILS,
                             CD_FEATURED,CD_FEATURED_VIDEO,
                             CD_FEATURED,CD_FEATURED_IMAGE,
                             CD_FEATURED,CD_FEATURED_BUSINESS,
                             
                             CD_TIMESTAMP,CD_TIMESTAMP_TABLENAME,
                             CD_TIMESTAMP,CD_TIMESTAMP_DATE,
                             
                             CD_TAG,CD_TAG_ID,
                             CD_TAG,CD_TAG_NAME,
                             CD_TAG,CD_TAG_DETAILS,
                             CD_TAG,CD_TAG_CLASS,
                             CD_TAG,CD_TAG_SET,
                             
                             CD_TAGCLASS,CD_TAGCLASS_ID,
                             CD_TAGCLASS,CD_TAGCLASS_NAME,
                             
                             CD_TAGSET,CD_TAGSET_WEIGHT,
                             nil];
        
        parseColumnNames=[NSDictionary dictionaryWithObjectsAndKeys:
                             PARSE_BUSINESS,PARSE_BUSINESS_ID,
                             PARSE_BUSINESS,PARSE_BUSINESS_NAME,
                             PARSE_BUSINESS,PARSE_BUSINESS_LOGO,
                             PARSE_BUSINESS,PARSE_BUSINESS_WELCOMETEXT,
                             
                             PARSE_FEATURED,PARSE_FEATURED_TITLE,
                             PARSE_FEATURED,PARSE_FEATURED_DETAILS,
                             PARSE_FEATURED,PARSE_FEATURED_VIDEO,
                             PARSE_FEATURED,PARSE_FEATURED_IMAGE,
                             PARSE_FEATURED,PARSE_FEATURED_BUSINESS,
                             
                             PARSE_TIMESTAMP,PARSE_TIMESTAMP_TABLENAME,
                             PARSE_TIMESTAMP,PARSE_TIMESTAMP_DATE,
                             
                             PARSE_TAG,PARSE_TAG_ID,
                             PARSE_TAG,PARSE_TAG_NAME,
                             PARSE_TAG,PARSE_TAG_DETAILS,
                             PARSE_TAG,PARSE_TAG_CLASS,
                             PARSE_TAG,PARSE_TAG_SET,
                             
                             PARSE_TAGCLASS,PARSE_TAGCLASS_ID,
                             PARSE_TAGCLASS,PARSE_TAGCLASS_NAME,
                             
                             PARSE_TAGSET,PARSE_TAGSET_WEIGHT,
                             nil];
        
        downloadingItems=[[NSMutableDictionary alloc] init];
        
        parseDownloadableItems=[NSArray arrayWithObjects:PARSE_BUSINESS_LOGO,PARSE_FEATURED_IMAGE,PARSE_FEATURED_BUSINESS,PARSE_TAG_CLASS,PARSE_TAG_SET, nil];
        
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
                NSDate *timestamp=[self getUpdateTimestampForTable:object[PARSE_TIMESTAMP_TABLENAME]];
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

    NSString *itemDownloaded=notification.userInfo[@"DownloadedItem"];
    NSString *parseTableNameForDownloadedItem=parseColumnNames[itemDownloaded];
    NSString *entity=parseToCoreDataNames[parseTableNameForDownloadedItem];
    
    //check which table downloaded completely, only then selectevely update the table.
    
    
    if(downloadingItems.count==0)
    {
        [self saveContext];
        [self pullFromCoreData];
        //[self pullFromCoreData:entity];
        [self postLocalNotificationForCoreDataRefresh:entity];
    }
}





- (void)createBusinessFromParseObject:(PFObject *)object
{
    Business *business = [NSEntityDescription insertNewObjectForEntityForName:CD_BUSINESS
                                                       inManagedObjectContext:self.managedObjectContext];
    business.name=object[PARSE_BUSINESS_NAME];
    business.welcomeText=object[PARSE_BUSINESS_WELCOMETEXT];
    business.uid=object[PARSE_BUSINESS_ID];
    
    PFFile *logo=object[PARSE_BUSINESS_LOGO];
    [downloadingItems setObject:PARSE_BUSINESS_LOGO forKey:object.objectId];
    //image needs to be downloaded assynchroniously
    [logo getDataInBackgroundWithBlock:^(NSData *logoFile, NSError *error)
     {
         if (!error)
         {
             business.logo = logoFile;
             [downloadingItems removeObjectForKey:object.objectId];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"itemPulledFromCloud" object:self
                                                              userInfo:[NSDictionary dictionaryWithObject: PARSE_BUSINESS_LOGO forKey:@"DownloadedItem"]];
         }
         else
             NSLog(@"%@",[error localizedDescription]);
     }];
}



- (void)createFeaturedFromParseObject:(PFObject *)object
{
    Featured *deal = [NSEntityDescription insertNewObjectForEntityForName:CD_FEATURED
                                                   inManagedObjectContext:self.managedObjectContext];
    deal.title=object[PARSE_FEATURED_TITLE];
    deal.details=object[PARSE_FEATURED_DETAILS];
    deal.videoUrl=object[PARSE_FEATURED_VIDEO];
    
    PFFile *image=object[PARSE_FEATURED_IMAGE];
    [downloadingItems setObject:PARSE_FEATURED_IMAGE forKey:object.objectId];
    [image getDataInBackgroundWithBlock:^(NSData *imageFile, NSError *error)
     {
         if (!error)
         {
             deal.image = imageFile;
             [downloadingItems removeObjectForKey:object.objectId];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"itemPulledFromCloud"
                                                                 object:self
                                                              userInfo:[NSDictionary dictionaryWithObject: PARSE_FEATURED_IMAGE forKey:@"DownloadedItem"]];
         }
         else
             NSLog(@"%@",[error localizedDescription]);
     }];
    
    PFObject *business = object[PARSE_FEATURED_BUSINESS];
    [downloadingItems setObject:PARSE_FEATURED_BUSINESS forKey:object.objectId];
    [business fetchIfNeededInBackgroundWithBlock:^(PFObject *retrievedBusiness, NSError *error) {
        if (!error)
        {
            Business *linkedBusiness=[self getBusinessByID:[(NSNumber*)(retrievedBusiness[PARSE_BUSINESS_ID]) integerValue]];
            deal.parentBusiness = linkedBusiness;
            
#pragma mark - not very safe adding deal to business before it was saved context
            [linkedBusiness addFeaturedOffersObject:deal];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"itemPulledFromCloud" object:self
                                                              userInfo:[NSDictionary dictionaryWithObject: PARSE_FEATURED_BUSINESS forKey:@"DownloadedItem"]];
        }
        else
            NSLog(@"%@",[error localizedDescription]);
    }];
}


- (void)createTagFromParseObject:(PFObject *)object
{
    
    Tag *tag =[NSEntityDescription insertNewObjectForEntityForName:CD_TAG inManagedObjectContext:self.managedObjectContext];
    tag.uid=object[PARSE_TAG_ID];
    tag.name=object[PARSE_TAG_NAME];
    tag.details=object[PARSE_TAG_DETAILS];
    
    PFObject* tagSet=object[PARSE_TAG_SET];
    [downloadingItems setObject:PARSE_TAG_SET forKey:object.objectId];
    [tagSet fetchIfNeededInBackgroundWithBlock:^(PFObject *retrievedTagSet, NSError *error) {
        if (!error)
        {
            tag.fromSet=retrievedTagSet;
            //now you gotta add the linked object of the tagset from core data and got help you so it already exist
            
            //TagSet *linkedTagSet=[self getBusinessByID:[(NSNumber*)(retrievedBusiness[PARSE_BUSINESS_ID]) integerValue]];
            
          //  deal.parentBusiness = linkedBusiness;
            
#pragma mark - not very safe adding deal to business before it was saved context
            [linkedBusiness addFeaturedOffersObject:deal];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"itemPulledFromCloud" object:self
                                                              userInfo:[NSDictionary dictionaryWithObject: PARSE_FEATURED_BUSINESS forKey:@"DownloadedItem"]];
        }
        else
            NSLog(@"%@",[error localizedDescription]);

        
    }

    
    PFObject *business = object[PARSE_FEATURED_BUSINESS];
    [downloadingItems setObject:PARSE_FEATURED_BUSINESS forKey:object.objectId];
    [business fetchIfNeededInBackgroundWithBlock:^(PFObject *retrievedBusiness, NSError *error) {
        if (!error)
        {
            Business *linkedBusiness=[self getBusinessByID:[(NSNumber*)(retrievedBusiness[PARSE_BUSINESS_ID]) integerValue]];
            deal.parentBusiness = linkedBusiness;
            
#pragma mark - not very safe adding deal to business before it was saved context
            [linkedBusiness addFeatureObject:deal];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"itemPulledFromCloud" object:self
                                                              userInfo:[NSDictionary dictionaryWithObject: PARSE_FEATURED_BUSINESS forKey:@"DownloadedItem"]];
        }
        else
            NSLog(@"%@",[error localizedDescription]);
    }];
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
                    [self createBusinessFromParseObject:object];
                }
               
                
                if([entityName isEqualToString:CD_FEATURED])
                {
                    [self createFeaturedFromParseObject:object];
                }
                
                if([entityName isEqualToString:CD_TAG])
                {
                    [self createTagFromParseObject:object];
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

//Getting array of Featured objects by beacon's major and minor. The idea is that optionally the offer can be attached to a specific beacon, but it doesn't have to so we first check if there are offers with such major and minor id's and if not, we check only by major
-(NSArray*) getOffersByMajor:(NSNumber*)major andMinor:(NSNumber*)minor;
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:CD_FEATURED];

    NSString *predicateMajor = [NSString stringWithFormat: @"(%@==%d)", CD_FEATURED_MAJOR, major.integerValue];
    NSString *predicateMinor = [NSString stringWithFormat: @"(%@==%d)", CD_FEATURED_MINOR, minor.integerValue];
    
    request.predicate=[NSCompoundPredicate andPredicateWithSubpredicates:@[predicateMajor, predicateMinor]];
    NSError *error;
    NSArray *featured = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    //if there are no offers tied directly to the beacon we try to find all the offers for the business
    if(featured.count==0)
    {
        request.predicate=[NSPredicate predicateWithFormat:predicateMajor];
        featured = [self.managedObjectContext executeFetchRequest:request error:&error];
    }
    return featured;
}
     
     
     
     
-(void) recordBeaconDetectedOn:(NSDate*) date withMajor:(NSNumber*) major andMinor: (NSNumber*) minor
{
    Statistics *newStat = [NSEntityDescription insertNewObjectForEntityForName:CD_STATISTICS
                                                       inManagedObjectContext:self.managedObjectContext];
    newStat.major=major;
    newStat.minor=minor;
    newStat.date=date;
    [self saveContext];
    
    PFObject *newStatistics = [PFObject objectWithClassName:PARSE_STATISTICS];
    newStatistics[PARSE_STATISTICS_MAJOR] = major;
    newStatistics[PARSE_STATISTICS_MINOR] = minor;
    newStatistics[PARSE_STATISTICS_DATE] = date;
    
#pragma mark - do a callback with processing the result of the save
    [newStatistics saveEventually];
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
