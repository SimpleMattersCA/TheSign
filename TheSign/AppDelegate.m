//
//  AppDelegate.m
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2/20/2014.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import "AppDelegate.h"
#import "DetailsViewController.h"
#import "HomeViewController.h"
#import "Business.h"
#import "Parse/Parse.h"

@import UIKit.UINavigationController;
@import CoreLocation;




@interface AppDelegate() <UIApplicationDelegate,CLLocationManagerDelegate>
@property (strong) CLLocationManager *locationManager;

@property NSArray *businesses;
@property NSArray *items;
@end


NSUUID *proximityUUID;



NSNumber *detectedBeaconMinor;
NSNumber *detectedBeaconMajor;

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self refreshModel];

    NSLog(@"DidFinishLaunching");


    
    
    
 /*   UILocalNotification *notification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (notification)
    {
        UINavigationController *navigation=(UINavigationController*)self.window.rootViewController.parentViewController;
        DetailsViewController *details =
        [navigation.storyboard instantiateViewControllerWithIdentifier:@"DetailsView"];
        [details setBusinessToShow:detectedBeaconMajor];
        [navigation pushViewController:details animated:NO];
        
        // Process the received notification
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
        
        
    }*/
    [self.window makeKeyAndVisible];

    [self prepareForBeacons];

    // Override point for customization after application launch.
    return YES;
}

-(void) prepareForBeacons
{
    if(!_locationManager)
    {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        proximityUUID=  [[NSUUID alloc] initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"];
        [self registerBeaconRegionWithUUID:proximityUUID andIdentifier:@"TheSign"];
    }
    

}

-(void)refreshModel
{
    if(!_model)
    {
        Business *b0=[[Business alloc] init];
        b0.name=@"Simple Matters";
        b0.welcomeText=@"The fuck is that?";
    
        Business *b1=[[Business alloc] init];
        b1.name=@"Apple";
        b1.welcomeText=@"Welcome to Apple Store";
    
        Business *b2=[[Business alloc] init];
        b2.name=@"Microsoft";
        b2.welcomeText=@"Welcome to Microsoft Store";
    
        _businesses=[[NSArray alloc]initWithObjects:b0,b1,b2, nil];
    
        _model=_businesses;
    }
}


- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    switch (state) {
        case CLRegionStateInside:
            [self.locationManager startRangingBeaconsInRegion:(CLBeaconRegion *)region];

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

  
}


- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    if (application.applicationState == UIApplicationStateInactive ) {
        UINavigationController *navigation=(UINavigationController*)self.window.rootViewController;
        DetailsViewController *details =
        [navigation.storyboard instantiateViewControllerWithIdentifier:@"DetailsView"];
        [details setBusinessToShow:detectedBeaconMajor];
        [navigation pushViewController:details animated:NO];
        
        // Process the received notification
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];

        //The application received the notification from an inactive state, i.e. the user tapped the "View" button for the alert.
        //If the visible view controller in your view controller stack isn't the one you need then show the right one.
    }
    
    if(application.applicationState == UIApplicationStateActive ) {
        //The application received a notification in the active state, so you can display an alert view or do something appropriate.
    }
}


- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
   // [self.locationManager startRangingBeaconsInRegion:(CLBeaconRegion *)region];
 //   [self.locationManager requestStateForRegion:region];
   // UIViewController* viewController = self.window.rootViewController;
    //[viewController beaconLeft];
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    [self.locationManager stopRangingBeaconsInRegion:(CLBeaconRegion *)region];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 1];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];

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
    [self.locationManager requestStateForRegion:beaconRegion];
}

// Delegate method from the CLLocationManagerDelegate protocol.
- (void)locationManager:(CLLocationManager *)manager
        didRangeBeacons:(NSArray *)beacons
               inRegion:(CLBeaconRegion *)region {
    
    CLBeacon *closest=(CLBeacon*)[beacons firstObject];
    if ([beacons count] > 0 && (detectedBeaconMajor==nil || ![detectedBeaconMajor isEqual:closest.major])) {
        detectedBeaconMinor =closest.minor;
        detectedBeaconMajor =closest.major;
        
        //CLearing notification center and lock screen notificaitons. Yeah, it's that weird
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 1];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
        
        
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.alertBody = [NSString stringWithFormat:@"Store detected: %@",((Business*)self.model[[closest.major integerValue]]).name];
       // NSDictionary *infoDict = [NSDictionary dictionaryWithObject:item.eventName forKey:ToDoItemKey];

       // notification.userInfo
        [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
        
        
        if(![detectedBeaconMinor isEqual:closest.minor])
        {
                //beacon specific logic
        }
    }
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
