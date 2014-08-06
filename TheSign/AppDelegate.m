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
#import "TutorialController.h"
#import "SignNotificationBanner.h"
#import "UIViewController+SignExtension.h"
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
    /*
    //ios 8
    if([application respondsToSelector:@selector(registerUserNotificationSettings)])
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge categories:nil]];
*/
    
    //Parse requirements
    [Parse setApplicationId:@"sLTJk7olnOIsBgPq9OhQDx1uPIkFefZeRUt46SWS"
                  clientKey:@"7y0Fw4xQ2GGxCNQ93LO4yjD4cPzlD6Qfi75bYlSa"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
 

    //Twitter support
    [PFTwitterUtils initializeWithConsumerKey:@"1sFhbRIBGn3KOvKmn1R4V7eod"
                    consumerSecret:@"IE5JpeGBTTY6509x72MGvfLOEDEcQQSBtBetiaAdJplik9Qxyq"];
    
    //Facebook support
    [PFFacebookUtils initializeFacebook];
    
    

    
    // Override point for customization after application launch.
    [self.window makeKeyAndVisible];
    


    //First Run Experience
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (![userDefaults boolForKey:@"DidFirstRun"])
    {
        [userDefaults setBool:YES forKey:@"DidFirstRun"];
        [[NSUserDefaults standardUserDefaults] synchronize];

        UINavigationController *navigation=(UINavigationController*)self.window.rootViewController;
        TutorialController *firstRun=[navigation.storyboard instantiateViewControllerWithIdentifier:@"WelcomeScreen"];
        [navigation pushViewController:firstRun animated:NO];
    }
    else
    {
        [self startLocationMonitoring];
        [[Model sharedModel] updateDBinBackground:YES];
    }
    
    
    //Push Notifications
    //[application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|
    // UIRemoteNotificationTypeAlert];
    //NSDictionary *remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    //if(remoteNotification)
    //{
    //}

    
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
        [self.locationManager pausesLocationUpdatesAutomatically];

        /*//ios8 only
        if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
        {
            [self.locationManager requestAlwaysAuthorization];
        }*/
        
        //********* Geofence monitoring *********//
        //[self.locationManager startMonitoringSignificantLocationChanges];
        //Setting up the timer that will check the closest location and if it's nearby it will monitor the region and fire the welcome message when the device is in it
        self.locationTimer=[NSTimer timerWithTimeInterval:3600 target:self selector:@selector(updateGPS)  userInfo:nil repeats:NO];
      
        [self.locationTimer setTolerance:300];
       //[self.locationTimer fire];
        //[self updateGPS];
        
        
        
        
         //********* Beacon monitoring *********//
        
        //Beacon UUID, the identifier common for all the beacons
        NSUUID *proximityUUID=  [[NSUUID alloc] initWithUUIDString:[Model sharedModel].beaconUUID];
        self.beaconRegion = [[CLBeaconRegion alloc]
                                        initWithProximityUUID:proximityUUID
                                        identifier:@"SignBeacon"];
        
        //show notificaiton only when screen is on
        //self.beaconRegion.notifyEntryStateOnDisplay=YES;
        //self.beaconRegion.notifyOnEntry=NO;
        self.beaconRegion.notifyOnEntry=YES;
        self.beaconRegion.notifyOnExit=YES;
        
        //Register the beacon region with the location manager.
        [self.locationManager startMonitoringForRegion:self.beaconRegion];
        [self.locationManager requestStateForRegion:self.beaconRegion];
        
    }
}

/**
 Starting fetching new GPS locations from location manager
*/
-(void)updateGPS
{
    [self.locationManager startUpdatingLocation];
}


/**
 Updating the currently monitorred gps region, calculating the right time interval for checking updating it
*/
-(void)updateGPSRegionForLocation:(CLLocation*)currentLocation
{
    [self.locationManager stopUpdatingLocation];
    [self.locationManager stopMonitoringForRegion:self.gpsRegion];

    //Updating the closest business location to monitor
    Location* closestBusiness=[[Model sharedModel] getClosestBusinessToLocation:currentLocation];
    CLLocation* closestBusinessLocation=[[CLLocation alloc] initWithLatitude:closestBusiness.latitude.doubleValue longitude:closestBusiness.longitude.doubleValue];
    double distance=[currentLocation distanceFromLocation:closestBusinessLocation];
    
    //Based on the distance we calculate the time of the next location check
    if(distance<50)
    {
        self.gpsRegion=[[CLCircularRegion alloc] initWithCenter:[closestBusiness getLocationObject].coordinate radius:10 identifier:closestBusiness.linkedBusiness.uid.stringValue];
        [self.locationManager startMonitoringForRegion:self.gpsRegion];
        
    } else if(distance<100)
            [self.locationTimer setFireDate:[NSDate dateWithTimeInterval:180 sinceDate:[NSDate date]]];
        else if(distance<250)
            [self.locationTimer setFireDate:[NSDate dateWithTimeInterval:600 sinceDate:[NSDate date]]];
        else if(distance<500)
            [self.locationTimer setFireDate:[NSDate dateWithTimeInterval:1800 sinceDate:[NSDate date]]];
        else
            [self.locationTimer setFireDate:[NSDate dateWithTimeInterval:3600 sinceDate:[NSDate date]]];


}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {

    //the last object is the most recent locaiton. We don't really pay attention to those that we missed (at the beginning of the array)
    [self updateGPSRegionForLocation:(CLLocation*)(locations.lastObject)];
}


- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    //Whenever we are in the Beacon region we start ranging beacons to get ther IDs
    switch (state) {
        case CLRegionStateInside:
            [self.locationManager startRangingBeaconsInRegion:(CLBeaconRegion *)region];

            break;
        case CLRegionStateOutside:
            [self.locationManager stopRangingBeaconsInRegion:(CLBeaconRegion *)region];
            break;
        
        case CLRegionStateUnknown:
       //     [self.locationManager stopRangingBeaconsInRegion:(CLBeaconRegion *)region];
            break;
    
        default:
            break;
    }

  
}


- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
    //Clearing up the notification badge (and also apparently it affects on the number of notifications in notification center
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
    
    //Getting Statistics object and the Featured object that were attached to the welcome message
    Statistics* stat=[[Model sharedModel] getStatisticsByURL:[NSURL URLWithString:[notification.userInfo objectForKey:@"StatisticsObjectID"]]];
    Featured* offer;
    NSString* offerObjectID=(NSString*)[notification.userInfo objectForKey:@"OfferID"];
    if(offerObjectID)
        offer=[Featured getByID:offerObjectID Context:[Model sharedModel].managedObjectContext];
    
    if(stat && offer)
    {
        UINavigationController *navigation=(UINavigationController*)self.window.rootViewController;
        UIViewController* currentController=navigation.topViewController;
        
        
        //when app was in background we will show the deal above whatever view was opened
        if (application.applicationState == UIApplicationStateInactive )
        {
            [currentController showModalDeal:offer Statistics:stat];
        }
        
        //if application is in foreground we show our custom notification banner
        if(application.applicationState == UIApplicationStateActive )
        {
            if(self.banner)
            {
                [self.banner.view removeFromSuperview];
                self.banner=nil;
            }
            self.banner=[SignNotificationBanner new];
            [currentController addBanner:self.banner WithText:notification.alertBody ForDeal:offer Statistics:stat];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeBannerNotification) name:@"removeBannerNotification" object:nil];
        }
    }
}
/**
  Notification that removes the custom notification banner and frees the memory
*/
-(void)removeBannerNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"removeBannerNotification" object:nil];
    self.banner=nil;
}


- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    //Depending to which region - iBeacon or GPS - we entered we process accordingly
    if([region isEqual:self.beaconRegion])
        [self.locationManager startRangingBeaconsInRegion:(CLBeaconRegion *)region];
    else
        [self welcomeCustomerGPSforRegion:region];
    
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    //Depending from which region - iBeacon or GPS - we left we process accordingly
    if([region isEqual:self.beaconRegion])
        [self.locationManager stopRangingBeaconsInRegion:(CLBeaconRegion *)region];
    else
        [self.locationManager stopMonitoringForRegion:self.gpsRegion];

    [[UIApplication sharedApplication] cancelAllLocalNotifications];

}


/**
 Processing generation of the welcoming message for GPS location
*/
-(void) welcomeCustomerGPSforRegion:(CLRegion*)region
{
    NSNumber* major=@([region.identifier intValue]);
    Statistics* stat=[[Model sharedModel] recordStatisticsFromGPS:major];
    Featured* chosenOffer;
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    
    //Generating the welcome notificaiton text and set it to local notification body. Passing the address of the variable storing chosen Deal
    notification.alertBody = [[InsightEngine sharedInsight] generateWelcomeTextForGPSdetectedMajor:major ChosenOffer:&chosenOffer];

    //With local notification we pass chosen offer's pObjectID, statistics object's objectID
    NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:chosenOffer.pObjectID,@"OfferID",stat.objectID.URIRepresentation.absoluteString,@"StatisticsObjectID", nil];
    
    
    notification.userInfo=infoDict;
    if(notification.alertBody!=nil && ![notification.alertBody isEqual:@""] && chosenOffer!=nil)
    {
        [stat setDeal:chosenOffer];
        [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
       // [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 1];
    }
    
    [self.locationManager stopMonitoringForRegion:self.gpsRegion];
}


/**
 Processing generation of the welcoming message for iBeacon location
*/
- (void)locationManager:(CLLocationManager *)manager
        didRangeBeacons:(NSArray *)beacons 
               inRegion:(CLBeaconRegion *)region {
    CLBeacon *closest=(CLBeacon*)[beacons firstObject];
    
    //in otder to not spam user with notifications we store the closest of the detected ibeacons major and minor
    if (beacons.count > 0 && (![detectedBeaconMajor isEqual:closest.major] && ![detectedBeaconMinor isEqual:closest.minor]))
    {
        detectedBeaconMinor =closest.minor;
        detectedBeaconMajor =closest.major;

        //CLearing notification center and lock screen notificaitons. Yeah, it's that weird
        //[[UIApplication sharedApplication] setApplicationIconBadgeNumber: 1];
        //[[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        
        //Creating a statistics object
        Statistics* stat=[[Model sharedModel] recordStatisticsFromBeaconMajor:detectedBeaconMajor Minor:detectedBeaconMinor];
        //The variable will be populated as part of the welcome text generation process
        Featured* chosenOffer;
        UILocalNotification *notification = [UILocalNotification new];
        
        //Generating the welcome notificaiton text and set it to local notification body. Passing the address of the variable storing chosen Deal
        notification.alertBody = [[InsightEngine sharedInsight] generateWelcomeTextForBeaconWithMajor:detectedBeaconMajor andMinor:detectedBeaconMinor ChosenOffer:&chosenOffer];
        
        //With local notification we pass chosen offer's pObjectID, statistics object's objectID
        NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:chosenOffer.pObjectID,@"OfferID",stat.objectID.URIRepresentation.absoluteString,@"StatisticsObjectID", nil];

    
        notification.userInfo=infoDict;
        if(notification.alertBody!=nil && ![notification.alertBody isEqual:@""] && chosenOffer!=nil)
        {
            [stat setDeal:chosenOffer];
            [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
          //  [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 1];
        }
       
        
        
    }
}

/*#pragma mark - Push notifications from Parse

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
  //  [[Model sharedModel] checkModel];
}*/

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
   // NSLog(@"will terminate");
    [[Model sharedModel] saveEverything];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
