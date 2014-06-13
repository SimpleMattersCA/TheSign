//
//  AppDelegate.m
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2/20/2014.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import "AppDelegate.h"
#import "DetailsViewController.h"
#import "Model.h"
#import "InsightEngine.h"
#import "WelcomeScreenViewController.h"

@import UIKit.UINavigationController;
@import CoreLocation;



@interface AppDelegate() <UIApplicationDelegate,CLLocationManagerDelegate>

@property (strong) CLLocationManager *locationManager;

@end


NSUUID *proximityUUID;


CLCircularRegion* currentlyMonitoredRegion;
NSNumber *detectedBeaconMinor;
NSNumber *detectedBeaconMajor;

@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
{

    [Parse setApplicationId:@"sLTJk7olnOIsBgPq9OhQDx1uPIkFefZeRUt46SWS"
                  clientKey:@"7y0Fw4xQ2GGxCNQ93LO4yjD4cPzlD6Qfi75bYlSa"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|
     UIRemoteNotificationTypeAlert|
     UIRemoteNotificationTypeSound];
    
    [self.window makeKeyAndVisible];

    [self startLocationMonitoring];
    
    
    //first-time ever defaults check and set
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"FirstRun"]!=NO)
    {
        UINavigationController *navigation=(UINavigationController*)self.window.rootViewController;
        WelcomeScreenViewController *firstRun=[navigation.storyboard instantiateViewControllerWithIdentifier:@"WelcomeScreenView"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"FirstRun"];
        [navigation pushViewController:firstRun animated:YES];
    }
    
    
    
    
    
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    pageControl.backgroundColor = [UIColor whiteColor];

    return YES;
}

-(void) startLocationMonitoring
{
    if(!_locationManager)
    {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        
        //Geofence monitoring
        [self.locationManager startMonitoringSignificantLocationChanges];
        
        //monitoring for beacons with a specific UUID
        proximityUUID=  [[NSUUID alloc] initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"];
        [self registerBeaconRegionWithUUID:proximityUUID andIdentifier:@"TheSign"];
        
    }
}


-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {

    //the last object is the most recent locaiton. We don't really pay attention to those that we missed (at the beginning of the array)
    CLLocation* location=locations.lastObject;
    CLLocation* closestBusiness=[Model getClosestBusinessToLocation:location];
    [self.locationManager stopMonitoringForRegion:currentlyMonitoredRegion];
    currentlyMonitoredRegion=[[CLCircularRegion alloc] initWithCenter:closestBusiness.coordinate radius:10 identifier:@"ClosestBusiness"];
#warning accuracy is a big question here
    [self.locationManager startMonitoringForRegion:currentlyMonitoredRegion];
}


/*- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    switch (state) {
        case CLRegionStateInside:
          //  [self.locationManager startRangingBeaconsInRegion:(CLBeaconRegion *)region];

            break;
        case CLRegionStateOutside:
        {
            break;
        }
        case CLRegionStateUnknown:
        {
           
            break;
        }
        default:

            break;
    }

  
}*/


- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    if (application.applicationState == UIApplicationStateInactive ) {
        UINavigationController *navigation=(UINavigationController*)self.window.rootViewController;
        DetailsViewController *details =
        [navigation.storyboard instantiateViewControllerWithIdentifier:@"DetailsView"];
        
#warning do a goddamn notificaiton call right
        //details setBusinessToShow:[notification.userInfo objectForKey:@"BeaconMajor"]];
        [navigation pushViewController:details animated:NO];
        
        // Process the received notification
        //[[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];

        //The application received the notification from an inactive state, i.e. the user tapped the "View" button for the alert.
        //If the visible view controller in your view controller stack isn't the one you need then show the right one.
    }
    
    if(application.applicationState == UIApplicationStateActive ) {
        //The application received a notification in the active state, so you can display an alert view or do something appropriate.
    }
}


- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    [self.locationManager startRangingBeaconsInRegion:(CLBeaconRegion *)region];
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    [self.locationManager stopRangingBeaconsInRegion:(CLBeaconRegion *)region];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];

}


- (void)registerBeaconRegionWithUUID:(NSUUID *)proximityUUID
                       andIdentifier:(NSString*)identifier
{
    
    // Create the beacon region to be monitored.
    CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc]
                                    initWithProximityUUID:proximityUUID
                                    identifier:identifier];
    beaconRegion.notifyEntryStateOnDisplay=YES;
    beaconRegion.notifyOnEntry=NO;
    beaconRegion.notifyOnExit=YES;

    // Register the beacon region with the location manager.
    [self.locationManager startMonitoringForRegion:beaconRegion];
    [self.locationManager startRangingBeaconsInRegion:beaconRegion];
}

// Delegate method from the CLLocationManagerDelegate protocol.
- (void)locationManager:(CLLocationManager *)manager
        didRangeBeacons:(NSArray *)beacons 
               inRegion:(CLBeaconRegion *)region {
    
    CLBeacon *closest=(CLBeacon*)[beacons firstObject];
   
   
    if ([beacons count] > 0 && (![detectedBeaconMajor isEqual:closest.major] && ![detectedBeaconMinor isEqual:closest.minor]))
    {
        detectedBeaconMinor =closest.minor;
        detectedBeaconMajor =closest.major;

        //CLearing notification center and lock screen notificaitons. Yeah, it's that weird
        //[[UIApplication sharedApplication] setApplicationIconBadgeNumber: 1];
        //[[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
        
        [[UIApplication sharedApplication] cancelAllLocalNotifications];

        
        
               //change the local notifacation name and add corresponding logic to handle new beacon detection inside the app (don't forget to change notificaitonName
       // NSDictionary* dict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:closest.major,closest.minor, nil] forKeys:[NSArray arrayWithObjects:@"major",@"minor", nil]];
     //   [[NSNotificationCenter defaultCenter] postNotificationName:@"pulledNewDataFromCloud" object:self userInfo:dict];
        
       //Statistics* stat=
        [Model recordBeaconDetectedOn:[NSDate date] withMajor:closest.major andMinor:closest.minor];
        
        
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.alertBody = [[InsightEngine sharedInsight] generateWelcomeTextForBeaconWithMajor:detectedBeaconMajor andMinor:detectedBeaconMinor];
        
        
        
        NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:closest.major,@"BeaconMajor", nil];

    
        notification.userInfo=infoDict;
        if(notification.alertBody!=nil && ![notification.alertBody isEqual:@""])
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
    [PFPush handlePush:userInfo];
    [[Model sharedModel] checkModel];
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
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
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
