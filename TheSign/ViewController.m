//
//  ViewController.m
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2/20/2014.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import "ViewController.h"
#import "Business.h"
#import "Item.h"

@import CoreLocation;

@interface ViewController () <CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *outputText;
@property (weak, nonatomic) IBOutlet UITextView *outputDescription;
@property (strong,nonatomic) CLLocationManager *locationManager;

@end

@implementation ViewController

NSUUID *proximityUUID;



NSArray *businesses;
NSArray *items;

- (void)viewDidLoad
{
    [super viewDidLoad];
  
 //   self.locationManager = [[CLLocationManager alloc] init];
  //  self.locationManager.delegate = self;

   // proximityUUID=  [[NSUUID alloc] initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"];
   
   // [self registerBeaconRegionWithUUID:proximityUUID andIdentifier:@"TheSign"];

    
}

-(void) updateViewForTitle:(NSString *) title andDescription:(NSString *)description
{
    _outputText.text=title;
    _outputDescription.text=description;

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
  //  [self.locationManager stopRangingBeaconsInRegion:(CLBeaconRegion *)region];
   // _outputText.text=@"Default";
   // _outputDescription.text=@"";
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

- (void) locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    switch (state) {
        case CLRegionStateInside:
            [self.locationManager startRangingBeaconsInRegion:(CLBeaconRegion *)region];
            break;
        case CLRegionStateOutside:
             [self.locationManager stopRangingBeaconsInRegion:(CLBeaconRegion *)region];
            break;
        case CLRegionStateUnknown:
        default:
            // stop ranging beacons, etc
            _outputText.text=@"Outside";
            _outputDescription.text=@"Outside Uknown";
            break;
    }
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
        _outputText.text=((Business*)businesses[i]).name;
        _outputDescription.text=((Business*)businesses[i]).welcomeText;
        
        
        // Present the exhibit-specific UI only when
      //  // the user is relatively close to the exhibit.
       // if (CLProximityNear == nearestExhibit.proximity) {
            
       // } else {
            //[self dismissExhibitInfo];
      //  }
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showInfo1:(UIButton *)sender {
    
 //    proximityUUID=  [[NSUUID alloc] initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"];
 //   CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc]
 //                                   initWithProximityUUID:proximityUUID
 //                                   identifier:@"TheSign"];
  //  [self.locationManager startRangingBeaconsInRegion:beaconRegion];
  //  UILocalNotification *localNotification = [[UILocalNotification alloc] init];
  //  localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:5];
    
 //   localNotification.alertBody = @"test";
 //    localNotification.alertAction=@"YEeeah!!";
 //   localNotification.timeZone = [NSTimeZone defaultTimeZone];
    
 //   [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
      
}


@end
