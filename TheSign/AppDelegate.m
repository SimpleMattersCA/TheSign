//
//  AppDelegate.m
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2/20/2014.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import "AppDelegate.h"
#import "Model.h"
#import "InsightEngine.h"
#import "Location.h"
#import "Business.h"
#import "Statistics.h"
#import "Featured.h"
#import "FeedController.h"
#import "TutorialController.h"

@import UIKit.UINavigationController;
@import CoreLocation;



@interface AppDelegate() <UIApplicationDelegate,CLLocationManagerDelegate>

@property (strong) CLLocationManager *locationManager;
@property (strong) NSTimer *locationTimer;
@property (strong) CLCircularRegion* gpsRegion;
@property (strong) CLBeaconRegion *beaconRegion;

@end


NSNumber *detectedBeaconMinor;
NSNumber *detectedBeaconMajor;

@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
{
    [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge categories:nil]];

    [Parse setApplicationId:@"sLTJk7olnOIsBgPq9OhQDx1uPIkFefZeRUt46SWS"
                  clientKey:@"7y0Fw4xQ2GGxCNQ93LO4yjD4cPzlD6Qfi75bYlSa"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    //Push Notifications
    //[application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|
    // UIRemoteNotificationTypeAlert];
    

    //Twitter support
    [PFTwitterUtils initializeWithConsumerKey:@"1sFhbRIBGn3KOvKmn1R4V7eod"
                    consumerSecret:@"IE5JpeGBTTY6509x72MGvfLOEDEcQQSBtBetiaAdJplik9Qxyq"];
    
    //Facebook support
    [PFFacebookUtils initializeFacebook];
    
    
    
    
    [self.window makeKeyAndVisible];

//
    
    
    //first-time ever defaults check and set
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"SetUpCompleted"]==NO)
    {
    
        UINavigationController *navigation=(UINavigationController*)self.window.rootViewController;
        TutorialController *firstRun=[navigation.storyboard instantiateViewControllerWithIdentifier:@"WelcomeScreen"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"SetUpCompleted"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    
        [navigation pushViewController:firstRun animated:YES];

    }
    else
    {
        [self startLocationMonitoring];
        [Model sharedModel];
    }
 //   NSDictionary *remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    
  //  if(remoteNotification)
  //  {
        //check model
   // }

    
    return YES;
}


/**
Preparing and starting geofence and beacon monitoring
 */
-(void) startLocationMonitoring
{
    if(!_locationManager)
    {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
#warning ios8 only
        [self.locationManager requestAlwaysAuthorization];
        self.locationManager.pausesLocationUpdatesAutomatically=YES;
        //********* Geofence monitoring *********//
      //  [self.locationManager startMonitoringSignificantLocationChanges];
        
        //Setting up the timer that will check the closest location and if it's nearby it will monitor the region and fire the welcome message when the device is in it
        //The timer runs
        self.locationTimer=[NSTimer scheduledTimerWithTimeInterval:3600 target:self selector:@selector(updateGPS) userInfo:nil repeats:YES];
        [self.locationTimer setTolerance:600];
        [self.locationTimer fire];
        
        
        
        
        
         //********* Beacon monitoring *********//
        
        //Beacon UUID, the identifier common for all the beacons
        NSUUID *proximityUUID=  [[NSUUID alloc] initWithUUIDString:[Model sharedModel].beaconUUID
];
        self.beaconRegion = [[CLBeaconRegion alloc]
                                        initWithProximityUUID:proximityUUID
                                        identifier:@"SignBeacon"];
        
        //show notificaiton only when screen is on
        self.beaconRegion.notifyEntryStateOnDisplay=YES;
        self.beaconRegion.notifyOnEntry=NO;
        self.beaconRegion.notifyOnExit=YES;
        
        // Register the beacon region with the location manager.
        [self.locationManager startMonitoringForRegion:self.beaconRegion];
        [self.locationManager requestStateForRegion:self.beaconRegion];
        
    }
}

-(void)updateGPS
{
    [self.locationManager startUpdatingLocation];
}

-(void)updateGPSRegionForLocation:(CLLocation*)currentLocation
{
    [self.locationManager stopUpdatingLocation];
    Location* closestBusiness=[[Model sharedModel] getClosestBusinessToLocation:currentLocation];
    [self.locationManager stopMonitoringForRegion:self.gpsRegion];
    self.gpsRegion=[[CLCircularRegion alloc] initWithCenter:[closestBusiness getLocationObject].coordinate radius:10 identifier:closestBusiness.linkedBusiness.uid.stringValue];
    //if distance is less than something, start monitoring for a region
    [self.locationManager startMonitoringForRegion:self.gpsRegion];
    //else
    [self.locationManager stopMonitoringForRegion:self.gpsRegion];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {

    //the last object is the most recent locaiton. We don't really pay attention to those that we missed (at the beginning of the array)
    [self updateGPSRegionForLocation:(CLLocation*)(locations.lastObject)];
}


- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    switch (state) {
        case CLRegionStateInside:
            [self.locationManager startRangingBeaconsInRegion:(CLBeaconRegion *)region];

            break;
        case CLRegionStateOutside:
            [self.locationManager stopRangingBeaconsInRegion:(CLBeaconRegion *)region];
            break;
        
        case CLRegionStateUnknown:
            [self.locationManager stopRangingBeaconsInRegion:(CLBeaconRegion *)region];
            break;
    
        default:
            break;
    }

  
}


- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
    if (application.applicationState == UIApplicationStateInactive ) {
        
        
        Statistics* stat=[[Model sharedModel] getStatisticsByURL:[notification.userInfo objectForKey:@"StatisticsObjectID"]];
        Featured* offer;
        
        NSString* offerObjectID=(NSString*)[notification.userInfo objectForKey:@"StatisticsObjectID"];
        if(offerObjectID)
            offer=[Featured getByID:offerObjectID Context:[Model sharedModel].managedObjectContext];
        
        if(stat && offer)
        {
            [stat setDeal:offer];
            
            //present deal view
            UINavigationController *navigation=(UINavigationController*)self.window.rootViewController;
            [navigation popToRootViewControllerAnimated:NO];
            FeedController* feed=(FeedController*)(navigation.topViewController);
            [feed showDealAfterLoad:offer Statistics:stat];
        }
        
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
    }
    
    if(application.applicationState == UIApplicationStateActive )
    {
        //TODO: process notification when application is in foreground
    }
}


- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    if([region isEqual:self.beaconRegion])
        [self.locationManager startRangingBeaconsInRegion:(CLBeaconRegion *)region];
    else
        [self welcomeCustomerGPSforRegion:region];
    
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    if([region isEqual:self.beaconRegion])
        [self.locationManager stopRangingBeaconsInRegion:(CLBeaconRegion *)region];
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];

}


-(void) welcomeCustomerGPSforRegion:(CLRegion*)region
{
    NSNumber* major=@([region.identifier intValue]);
    Statistics* stat=[[Model sharedModel] recordStatisticsFromGPS:major];
    Featured* chosenOffer;
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertBody = [[InsightEngine sharedInsight] generateWelcomeTextForGPSdetectedMajor:major ChosenOffer:&chosenOffer];

    
    NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:chosenOffer.pObjectID,@"OfferID",stat.objectID.URIRepresentation,@"StatisticsObjectID", nil];
    
    
    notification.userInfo=infoDict;
    if(notification.alertBody!=nil && ![notification.alertBody isEqual:@""] && chosenOffer!=nil)
    {
        [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 1];
    }

}


// Delegate method from the CLLocationManagerDelegate protocol.
- (void)locationManager:(CLLocationManager *)manager
        didRangeBeacons:(NSArray *)beacons 
               inRegion:(CLBeaconRegion *)region {
    
    CLBeacon *closest=(CLBeacon*)[beacons firstObject];
   
   
    if (beacons.count > 0 && (![detectedBeaconMajor isEqual:closest.major] && ![detectedBeaconMinor isEqual:closest.minor]))
    {
        detectedBeaconMinor =closest.minor;
        detectedBeaconMajor =closest.major;

        //CLearing notification center and lock screen notificaitons. Yeah, it's that weird
        //[[UIApplication sharedApplication] setApplicationIconBadgeNumber: 1];
        //[[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
        
        [[UIApplication sharedApplication] cancelAllLocalNotifications];

        
        
               //change the local notification name and add corresponding logic to handle new beacon detection inside the app (don't forget to change notificaitonName
       // NSDictionary* dict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:closest.major,closest.minor, nil] forKeys:[NSArray arrayWithObjects:@"major",@"minor", nil]];
     //   [[NSNotificationCenter defaultCenter] postNotificationName:@"pulledNewDataFromCloud" object:self userInfo:dict];
        
        
        Statistics* stat=[[Model sharedModel] recordStatisticsFromBeaconMajor:detectedBeaconMajor Minor:detectedBeaconMinor];
        Featured* chosenOffer;
        
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.alertBody = [[InsightEngine sharedInsight] generateWelcomeTextForBeaconWithMajor:detectedBeaconMajor andMinor:detectedBeaconMinor ChosenOffer:&chosenOffer];
        
        
        
        NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:chosenOffer.pObjectID,@"OfferID",stat.objectID.URIRepresentation,@"StatisticsObjectID", nil];

    
        notification.userInfo=infoDict;
        if(notification.alertBody!=nil && ![notification.alertBody isEqual:@""] && chosenOffer!=nil)
        {
            [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
            [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 1];
        }
       
        
        
    }
}

#pragma mark - Push notifications from Parse

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    //[PFPush handlePush:userInfo];
    [[Model sharedModel] checkModel];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:[PFFacebookUtils session]];
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[Model sharedModel] saveEverything];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
 //   NSLog(@"EnerForeground");
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    NSLog(@"will terminate");
    [[Model sharedModel] saveEverything];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
