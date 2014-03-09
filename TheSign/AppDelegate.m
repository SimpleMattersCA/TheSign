//
//  AppDelegate.m
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2/20/2014.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "Business.h"
@import CoreLocation;




@interface AppDelegate() <UIApplicationDelegate,CLLocationManagerDelegate>
@property CLLocationManager *locationManager;

@end


NSUUID *proximityUUID;

NSArray *businesses;
NSArray *items;


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self.window makeKeyAndVisible];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;

    
    
    Business *b1=[[Business alloc] init];
    b1.name=@"Apple";
    b1.welcomeText=@"Welcome to Apple Store";
    
    Business *b2=[[Business alloc] init];
    b2.name=@"Microsoft";
    b2.welcomeText=@"Welcome to Microsoft Store";
    
    businesses=[[NSArray alloc]initWithObjects:b1,b2, nil];
    

    proximityUUID=  [[NSUUID alloc] initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"];
    
    [self registerBeaconRegionWithUUID:proximityUUID andIdentifier:@"TheSign"];
    
    // Override point for customization after application launch.
    return YES;
}


- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
  
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    [self.locationManager startRangingBeaconsInRegion:(CLBeaconRegion*)region];
    // NSInteger i=[((CLBeaconRegion *)region).major integerValue];
    // i=i-1;
    // _outputText.text=((Business*)businesses[i]).name;
    // _outputDescription.text=((Business*)businesses[i]).welcomeText;
    
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
      [self.locationManager stopRangingBeaconsInRegion:(CLBeaconRegion *)region];
    // _outputText.text=@"Default";
    // _outputDescription.text=@"";
}



- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    NSString *cancelButtonTitle = NSLocalizedString(@"OK", @"Cancel");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:notification.alertBody message:nil delegate:nil cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
    [alert show];
}

- (void)registerBeaconRegionWithUUID:(NSUUID *)proximityUUID
                       andIdentifier:(NSString*)identifier
{
    
    // Create the beacon region to be monitored.
    CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc]
                                    initWithProximityUUID:proximityUUID
                                    identifier:identifier];
    [beaconRegion setNotifyOnEntry:YES];
    [beaconRegion setNotifyOnExit:YES];
    [beaconRegion setNotifyEntryStateOnDisplay:YES];
    // Register the beacon region with the location manager.
    [self.locationManager startMonitoringForRegion:beaconRegion];
}

// Delegate method from the CLLocationManagerDelegate protocol.
- (void)locationManager:(CLLocationManager *)manager
        didRangeBeacons:(NSArray *)beacons
               inRegion:(CLBeaconRegion *)region {
    
    if ([beacons count] > 0) {
        CLBeacon *nearest = [beacons firstObject];
        
        NSInteger i=[nearest.major integerValue];
        // NSLog([region.major stringValue]);
        i=i-1;
        NSString* title=((Business*)businesses[i]).name;
       NSString* description=((Business*)businesses[i]).welcomeText;
        
        ViewController* viewController = (ViewController*)  self.window.rootViewController;
        
        [viewController updateViewForTitle:title andDescription:description];
        
        // Present the exhibit-specific UI only when
        //  // the user is relatively close to the exhibit.
        // if (CLProximityNear == nearestExhibit.proximity) {
        
        // } else {
        //[self dismissExhibitInfo];
        //  }
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
