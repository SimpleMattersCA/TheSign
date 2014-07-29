//
//  Model.m
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-03-21.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//
#import "Parse/Parse.h"

#import "Model.h"
#import "Featured.h"
#import "Business.h"
#import "Tag.h"
#import "TagSet.h"
#import "TagConnection.h"
#import "Link.h"
#import "Statistics.h"
#import "TableTimestamp.h"
#import "Settings.h"
#import "Location.h"
#import "Area.h"
#import "Context.h"
#import "Template.h"
#import "User.h"
#import "BusinessCategory.h"

@interface Model()

@property (strong) NSTimer *networkTimer;

@property NSNumber* isUpdating;
@end

@implementation NSManagedObjectContext (FetchedObjectFromURI)

- (NSManagedObject *)objectWithURI:(NSURL *)uri
{
    NSManagedObjectID *objectID =
    [[self persistentStoreCoordinator]
     managedObjectIDForURIRepresentation:uri];
    
    if (!objectID)
    {
        return nil;
    }
    
    NSManagedObject *objectForID = [self objectWithID:objectID];
    if (![objectForID isFault])
    {
        return objectForID;
    }
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[objectID entity]];
    
    // Equivalent to
    // predicate = [NSPredicate predicateWithFormat:@"SELF = %@", objectForID];
    NSPredicate *predicate =
    [NSComparisonPredicate
     predicateWithLeftExpression:
     [NSExpression expressionForEvaluatedObject]
     rightExpression:
     [NSExpression expressionForConstantValue:objectForID]
     modifier:NSDirectPredicateModifier
     type:NSEqualToPredicateOperatorType
     options:0];
    [request setPredicate:predicate];
    
    NSArray *results = [self executeFetchRequest:request error:nil];
    if ([results count] > 0 )
    {
        return [results objectAtIndex:0];
    }
    
    return nil;
}
@end


@implementation Model


@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectContextBackground = _managedObjectContextBackground;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


-(BOOL)isBeingUpdated
{
   // if(!self.isUpdating)
    //     NSLog(@"No value");
    //else
    //    NSLog(@"IS updated: %d",self.isUpdating.boolValue);
    
    if(!self.isUpdating)
        return NO;
    else
        return self.isUpdating.boolValue;
}



-(double)getLikeValueForAction:(OfferLike)action
{
    switch(action)
    {
        case LK_None:
            return self.lk_none.doubleValue;
        case LK_Like:
            return self.lk_like.doubleValue;
        case LK_Dislike:
            return self.lk_dislike.doubleValue;
        case LK_UnLike:
            return -self.lk_like.doubleValue;
        case LK_UnDislike:
            return -self.lk_dislike.doubleValue;
        default:
            return 0;
    }
}


#pragma mark - model initialization
- (id)init
{
    if (self = [super init])
    {
        
        //checking database every hour with tolerance of 10 minutes

        self.networkTimer=[NSTimer scheduledTimerWithTimeInterval:3600 target:self selector:@selector(requestCloudOnTimer) userInfo:nil repeats:YES];
        [self.networkTimer fire];
        [self.networkTimer setTolerance:600];
        
        //[self checkModel];
        
        //when you do too many changes to data model it might be neccessary to explisistly delete the current datastore in order to build a new one
        //[self deleteModel];
        //[self performSelectorInBackground:@selector(checkModel) withObject:nil];
        
    }
    return self;
}

- (void)requestCloudOnTimer
{
    [self performSelectorInBackground:@selector(requestCloud) withObject:nil];
}

-(void) requestCloud
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components: NSHourCalendarUnit fromDate:[NSDate date]];
    //at night we pause database updates firing 8 hours from now
    if(components.hour>22)
        [self.networkTimer setFireDate:[[NSDate date] dateByAddingTimeInterval:60*60*8]];
    
//    [Statistics sendToCloudForContext:self.managedObjectContextBackground];
    [self updateDBinBackground:NO];
}

-(void) updateDBinBackground:(Boolean)inBackground
{
    if(!self.isUpdating && self.isUpdating.boolValue==NO)
    {
        self.isUpdating=@(YES);
        if(inBackground)
            [self performSelectorInBackground:@selector(checkModel) withObject:nil];
        else
            [self checkModel];
    }

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
-(Boolean)checkModel
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
    [self checkDeleteHistory];

    Boolean completeData=YES;    
    
    //pull from cloud for
    PFQuery *query = [PFQuery queryWithClassName:[TableTimestamp parseEntityName]];
    NSError *error;
    [query orderByAscending:TableTimestamp.pOrder];
    NSArray *objects=[query findObjects:&error];
    
    
    
    if (!error)
    {
        for (PFObject *object in objects)
        {
            NSString *tableName=object[[TableTimestamp pTableName]];
            NSDate *timestamp=[TableTimestamp getUpdateTimestampForTable:tableName Context:self.managedObjectContextBackground];
            if(![timestamp isEqualToDate:object[[TableTimestamp pTimeStamp]]])
            {
              //  NSLog(@"Pulling %@",tableName);
                if([self pullFromCloud:tableName]==NO)
                    completeData=NO;
                
                
            }
        }
        [self pullFromCloud:[TableTimestamp parseEntityName]];
    }
    else
    {
     //   NSLog(@"Error in CheckModel: %@ %@", error, [error userInfo]);
    }
    
    
    [self saveContext:self.managedObjectContextBackground];
    
    self.isUpdating=@(NO);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dbUpdated"
                                                            object:nil];
    return completeData;
}

/**
 deleting the model
 */
-(void)deleteModelForContext:(NSManagedObjectContext *)context
{
    [self deleteEntity:[TableTimestamp entityName]];
    [self deleteEntity:[Settings entityName]];
    [self deleteEntity:[Context entityName]];
    [self deleteEntity:[Business entityName]];
    [self deleteEntity:[Link entityName]];
    [self deleteEntity:[Featured entityName]];
    [self deleteEntity:[Tag entityName]];
    [self deleteEntity:[TagSet entityName]];
    [self deleteEntity:[TagConnection entityName]];
    [self deleteEntity:[Location entityName]];
    [self deleteEntity:[Area entityName]];
    [self deleteEntity:[Template entityName]];
    [self deleteEntity:[BusinessCategory entityName]];
    [self saveContext:context];
}

-(void)deleteDataStore
{
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"SignModel.sqlite"];
    [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
}


-(Class)getClassForParseEntity:(NSString*)entityName
{
    if([entityName isEqualToString:[TableTimestamp parseEntityName]])
        return [TableTimestamp class];
    else if([entityName isEqualToString:[Settings parseEntityName]])
        return [Settings class];
    else if([entityName isEqualToString:[Context parseEntityName]])
        return [Context class];
    else if([entityName isEqualToString:[Business parseEntityName]])
        return [Business class];
    else if([entityName isEqualToString:[BusinessCategory parseEntityName]])
        return [BusinessCategory class];
    else if([entityName isEqualToString:[Link parseEntityName]])
        return [Link class];
    else if([entityName isEqualToString:[Featured parseEntityName]])
        return [Featured class];
    else if([entityName isEqualToString:[Tag parseEntityName]])
        return [Tag class];
    else if([entityName isEqualToString:[TagSet parseEntityName]])
        return [TagSet class];
    else if([entityName isEqualToString:[TagConnection parseEntityName]])
        return [TagConnection class];
    else if([entityName isEqualToString:[Location parseEntityName]])
        return [Location class];
    else if([entityName isEqualToString:[Area parseEntityName]])
        return [Area class];
    else if([entityName isEqualToString:[Template parseEntityName]])
        return [Template class];
    
    return nil;
}



//The method for pulling data from Parse based on the requested table name
-(Boolean)pullFromCloud:(NSString*)cloudEntityName
{
    Boolean completeFull=YES;;
    
    Class targetClass=[self getClassForParseEntity:cloudEntityName];
    NSDate* cdTimestamp=[TableTimestamp getUpdateTimestampForTable:cloudEntityName Context:self.managedObjectContextBackground];
    
    PFQuery *query = [PFQuery queryWithClassName:cloudEntityName];
    if (cdTimestamp!=nil)[query whereKey:@"updatedAt" greaterThan:cdTimestamp];
    NSError *error;
    NSArray *result=[query findObjects:&error];
    
    
    if (!error)
    {
        //delete entity from coredata, so we can create a new one
      //  [self deleteEntity:entityName];
        //go through the objects we got from Parse
        Boolean completeRecord=YES;;

        for (PFObject *object in result)
        {
            id cdObject=[targetClass getByID:object.objectId Context:self.managedObjectContextBackground];
            
            if(cdObject!=nil)
                completeRecord=[cdObject refreshFromParseForContext:self.managedObjectContextBackground];
            else
                completeRecord=[targetClass createFromParse:object Context:self.managedObjectContextBackground];
            
            if(completeFull && !completeRecord)
                completeFull=NO;
        }
    }
    else
    {
    //    NSLog(@"Pulling from cloud error: %@ %@", error, [error userInfo]);
        completeFull=NO;
    }
    
    return completeFull;
}

-(void)deleteObjectForClass:(Class)class ParseObjectID:(NSString*)pObjectID
{
    NSManagedObject* objectToDelete=[class getByID:pObjectID Context:self.managedObjectContextBackground];
    if(objectToDelete)
        [self.managedObjectContext deleteObject:objectToDelete];
}

-(void)checkDeleteHistory
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components: NSHourCalendarUnit fromDate:[NSDate date]];
    [components setMonth:-1];
    NSDate* monthAgo=[[NSCalendar currentCalendar] dateFromComponents:components];
    PFQuery *query = [PFQuery queryWithClassName:@"DeleteHistory"];
    [query whereKey:@"updatedAt" greaterThan:monthAgo];
    
    NSError *error;
    NSArray *deletedObjects=[query findObjects:&error];
    
    for(PFObject *deletedObject in deletedObjects)
    {
        Class entityClass=[self getClassForParseEntity:deletedObject[@"table"]];
        [self deleteObjectForClass:entityClass ParseObjectID:deletedObject[@"delObjectID"]];
    }

}

-(NSArray*) getObjectsDeletedFromParse
{
    NSMutableArray* result=[NSMutableArray array];
    
    PFQuery *query = [PFQuery queryWithClassName:@"DeleteHistory"];
    
    NSError *error;
    NSManagedObject* cdObjectToDelete;

    NSArray *deletedObjects=[query findObjects:&error];
    
    for(PFObject *deletedObject in deletedObjects)
    {
        Class entityClass=[self getClassForParseEntity:deletedObject[@"table"]];
        cdObjectToDelete=[entityClass getByID:deletedObject[@"delObjectID"] Context:self.managedObjectContextBackground];
        if(cdObjectToDelete)
            [result addObject:cdObjectToDelete];
    }
    
    return result;

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
    
    [self saveContext:self.managedObjectContextBackground];
}

-(void)saveEverything
{
    [self saveContext:self.managedObjectContext];
    [self saveContext:self.managedObjectContextBackground];
}

- (void)saveContext:(NSManagedObjectContext*)context
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = context;
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




#pragma mark - Settings properties
-(NSString*) beaconUUID
{
    if(!_beaconUUID)
    {
        Settings* param=[Settings getValueForParamName:@"beaconUUID" Context:self.managedObjectContext];
        if(param)
            _beaconUUID=param.paramStr;
        else
            _beaconUUID=@"B9407F30-F5F8-466E-AFF9-25556B57FE6D";
    }
    return _beaconUUID;
}

-(NSNumber*) prob_pref
{
    if(!_prob_pref)
    {
        Settings* param=[Settings getValueForParamName:@"prob_pref" Context:self.managedObjectContext];
        if(param)
            _prob_pref=param.paramFloat;
        else
            _prob_pref=@(0.5);
    }
    return _prob_pref;
}

-(NSNumber*) min_negativeScore
{
    if(!_min_negativeScore)
    {
        Settings* param=[Settings getValueForParamName:@"min_negativeScore" Context:self.managedObjectContext];
        if(param)
            _min_negativeScore=param.paramFloat;
        else
            _min_negativeScore=@(-3);
    }
    return _min_negativeScore;
}

-(NSNumber*) relevancyDepth
{
    if(!_relevancyDepth)
    {
        Settings* param=[Settings getValueForParamName:@"relevancyDepth" Context:self.managedObjectContext];
        if(param)
            _relevancyDepth=param.paramInt;
        else
            _relevancyDepth=@(2);
    }
    return _relevancyDepth;
}
-(NSNumber*) min_like_level
{
    if(!_min_like_level)
    {
        Settings* param=[Settings getValueForParamName:@"min_like_level" Context:self.managedObjectContext];
        if(param)
            _min_like_level=param.paramFloat;
        else
            _min_like_level=@(0.1);
    }
    return _min_like_level;
}

-(NSNumber*) prob_no_relev
{
    if(!_prob_no_relev)
    {
        Settings* param=[Settings getValueForParamName:@"prob_no_relev" Context:self.managedObjectContext];
        if(param)
            _prob_no_relev=param.paramFloat;
        else
            _prob_no_relev=@(0.1);
    }
    return _prob_no_relev;
}

-(NSNumber*) lk_none
{
    if(!_lk_none)
    {
        Settings* param=[Settings getValueForParamName:@"lk_none" Context:self.managedObjectContext];
        if(param)
            _lk_none=param.paramFloat;
        else
            _lk_none=@(0.1);
    }
    return _lk_none;
}

-(NSNumber*) lk_like
{
    if(!_lk_like)
    {
        Settings* param=[Settings getValueForParamName:@"lk_like" Context:self.managedObjectContext];
        if(param)
            _lk_like=param.paramFloat;
        else
            _lk_like=@(1);
    }
    return _lk_like;
}

-(NSNumber*) lk_dislike
{
    if(!_lk_dislike)
    {
        Settings* param=[Settings getValueForParamName:@"lk_dislike" Context:self.managedObjectContext];
        if(param)
            _lk_dislike=param.paramFloat;
        else
            _lk_dislike=@(-1);
    }
    return _lk_dislike;
}

-(NSNumber*) offersFeedLimit
{
    if(!_offersFeedLimit)
    {
        Settings* param=[Settings getValueForParamName:@"offersFeedLimit" Context:self.managedObjectContext];
        if(param)
            _offersFeedLimit=param.paramInt;
        else
            _offersFeedLimit=@(50);
    }
    return _offersFeedLimit;
}

-(NSNumber*) feed_swap_prob
{
    if(!_feed_swap_prob)
    {
        Settings* param=[Settings getValueForParamName:@"feed_swap_prob" Context:self.managedObjectContext];
        if(param)
            _feed_swap_prob=param.paramFloat;
        else
            _feed_swap_prob=@(0.5);
    }
    return _feed_swap_prob;
}

-(NSNumber*) weather_poll
{
    if(!_weather_poll)
    {
        Settings* param=[Settings getValueForParamName:@"weather_poll" Context:self.managedObjectContext];
        if(param)
            _weather_poll=param.paramFloat;
        else
            _weather_poll=@(60);
    }
    return _weather_poll;
}
-(NSNumber*) interest_value
{
    if(!_interest_value)
    {
        Settings* param=[Settings getValueForParamName:@"interest_value" Context:self.managedObjectContext];
        if(param)
            _interest_value=param.paramFloat;
        else
            _interest_value=@(5);
    }
    return _interest_value;
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

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContextBackground
{
    if (_managedObjectContextBackground != nil) {
        return _managedObjectContextBackground;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContextBackground = [[NSManagedObjectContext alloc] init];
        [_managedObjectContextBackground setPersistentStoreCoordinator:coordinator];
    }
    
    
    return _managedObjectContextBackground;
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
      //  NSLog(@"Unresolved error %@, %@", error, [error userInfo]);

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
    return [Statistics recordStatisticsFromBeaconMajor:major Minor:minor Context:self.managedObjectContext];
}
-(Statistics*)recordStatisticsFromGPS:(NSNumber*)businessUID
{
    return [Statistics recordStatisticsFromGPS:businessUID Context:self.managedObjectContext];
}
-(Statistics*)recordStatisticsFromFeed
{
    return [Statistics recordStatisticsFromFeedForContext:self.managedObjectContext];
}


-(Location*)getClosestBusinessToLocation:(CLLocation*)location
{
    return [Business getClosestBusinessToLocation:location Context:self.managedObjectContext];
}

-(NSArray*)getInterests
{
    return [Tag getInterestsForContext:self.managedObjectContext];
}

-(NSArray*) getBusinesses
{
    return [Business getBusinessesForContext:self.managedObjectContext];
}


-(User*) currentUser
{
    if(!_currentUser)
        _currentUser=[User currentUser];
    return _currentUser;
}






-(NSArray*)getDealsForFeed
{
    //get discovered businesses
    NSArray* discoveredBusinesses=[Business getDiscoveredBusinessesForContext:self.managedObjectContext];
    
    //get offers from those discovered businesses
    
    NSMutableArray* offersWithScore=[NSMutableArray array];
    NSMutableArray* offersNoScore=[NSMutableArray array];
    
    double minNegScore=[Model sharedModel].min_negativeScore.doubleValue;
    double sum=0;
    
    for(Business *business in discoveredBusinesses)
    {
        if(business.linkedOffers)
        {
            for(Featured* offer in business.linkedOffers)
            {
                if(offer.active.boolValue)
                {
                    if(offer.score.doubleValue>minNegScore)
                    {
                        if(offer.score.doubleValue>0)
                        {
                            sum+=offer.score.doubleValue;
                            [offersWithScore addObject:offer];
                        }
                        else
                            [offersNoScore addObject:offer];
                    }
                }
            }
        
        }
    }
    
    //ordering offers with scores.
    if(offersWithScore.count>1)
    {
        //sort offers with relevancies scores mostly by relevancy
        //first, sort offers by their relevancy scores in descending order
        NSSortDescriptor *scoreDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"score"
                                                                          ascending:NO];
        NSArray *sortedOffers = [offersWithScore sortedArrayUsingDescriptors:[NSArray arrayWithObject:scoreDescriptor]];
        //slightly randomize the order
        double randomBound=self.feed_swap_prob.doubleValue;
        NSInteger startInt=0;
        NSInteger endInt=1;
        NSInteger lengthInt=1;
        
        //cleaning up the array, it's going to store the result
        offersWithScore=[NSMutableArray array];
        
        BOOL loop=YES;
        while(loop)
        {
            double startVal=((Featured*)sortedOffers[startInt]).score.doubleValue;
            double endVal=((Featured*)sortedOffers[endInt]).score.doubleValue;
            
            double r=drand48();
            //depending on how close scores are for the offer at the start of the interval and at the end we determien probabiliy of the swap.
            if(r<randomBound*endVal/startVal)
            {
                //shuffling the interval
                [offersWithScore addObjectsFromArray:[self shuffleArray:[sortedOffers objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(startInt, lengthInt+1)]]]];
            }
            else
            {
                //copying offers from sorted array
                [offersWithScore addObjectsFromArray:[sortedOffers objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(startInt, lengthInt+1)]]];
            }
            lengthInt*=2;
            startInt=endInt+1;
            endInt=startInt+lengthInt;
            
            //handling the end of the interval
            if(endInt>=sortedOffers.count)
            {
                //adding the remainder in the sorted order
                if(startInt<sortedOffers.count)
                {
                    [offersWithScore addObjectsFromArray:[sortedOffers objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(startInt, sortedOffers.count-startInt)]]];
                }
                loop=NO;
            }
        }
    }
    //shuffling offers with zero or acceptably negative relevancy score
    offersNoScore=[self shuffleArray:offersNoScore];
    
    return [offersWithScore arrayByAddingObjectsFromArray:offersNoScore];
}

/**
 Shuffle the array (Knuth-Fisher-Yates shuffle algorithm)
*/
-(NSMutableArray*)shuffleArray:(NSArray*)array;
{
    NSMutableArray* result=[NSMutableArray arrayWithArray:array];
    NSInteger r;
    for (NSInteger i = array.count - 1; i > 0; i--)
    {
        r = arc4random_uniform((int)i + 1);
        [result exchangeObjectAtIndex:i withObjectAtIndex:r];
    }
    return result;
}


-(Statistics*)getStatisticsByURL:(NSURL*)stringID
{
    return (Statistics*)[self.managedObjectContext objectWithURI:stringID];
    
}


@end

