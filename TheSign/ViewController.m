//
//  ViewController.m
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2/20/2014.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import "ViewController.h"
#import "InfoModel.h"
#import "PopulateView.h"
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
    
    Business *b1=[[Business alloc] init];
    b1.name=@"Apple";
    b1.welcomeText=@"Welcome to Apple Store";
    
    Business *b2=[[Business alloc] init];
    b2.name=@"Microsoft";
    b2.welcomeText=@"Welcome to Microsoft Store";
    
    businesses=[[NSArray alloc]initWithObjects:b1,b2, nil];


    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;

    proximityUUID=  [[NSUUID alloc] initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"];
    
    [self registerBeaconRegionWithUUID:proximityUUID andIdentifier:@"Estimote Region"];
    
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    
    NSInteger i=[((CLBeaconRegion *)region).major integerValue];
    // NSLog([region.major stringValue]);
    //    i=i-1;
    _outputText.text=((Business*)businesses[i]).name;
    _outputDescription.text=((Business*)businesses[i]).welcomeText;

}

- (void)registerBeaconRegionWithUUID:(NSUUID *)proximityUUID andIdentifier:(NSString*)identifier {
    
    // Create the beacon region to be monitored.
    CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc]
                                    initWithProximityUUID:proximityUUID
                                    identifier:identifier];
       // Register the beacon region with the location manager.
    [self.locationManager startMonitoringForRegion:beaconRegion];
}

/*- (void) locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    switch (state) {
        case CLRegionStateInside:
            [self.locationManager startRangingBeaconsInRegion:self.region];
            NSInteger i=[self.region.major integerValue];
            NSLog([region.major stringValue]);
        //    i=i-1;
            _outputText.text=((Business*)businesses[i]).name;
            _outputDescription.text=((Business*)businesses[i]).welcomeText;
            break;
        case CLRegionStateOutside:
            _outputText.text=@"Default";
            _outputDescription.text=@"Noone";
            break;
        case CLRegionStateUnknown:
        default:
            // stop ranging beacons, etc
            _outputText.text=@"Outside";
            _outputDescription.text=@"Outside Uknown";
            break;
            NSLog(@"Region unknown");
    }
}*/

// Delegate method from the CLLocationManagerDelegate protocol.
- (void)locationManager:(CLLocationManager *)manager
        didRangeBeacons:(NSArray *)beacons
               inRegion:(CLBeaconRegion *)region {
    
    if ([beacons count] > 0) {
        CLBeacon *nearestExhibit = [beacons firstObject];
        
        // Present the exhibit-specific UI only when
        // the user is relatively close to the exhibit.
        if (CLProximityNear == nearestExhibit.proximity) {
            NSInteger i=[region.major integerValue];
           // NSLog([region.major stringValue]);
            //    i=i-1;
            _outputText.text=((Business*)businesses[i]).name;
            _outputDescription.text=((Business*)businesses[i]).welcomeText;
        } else {
            //[self dismissExhibitInfo];
        }
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showInfo1:(UIButton *)sender {
    
  //  UILocalNotification *localNotification = [[UILocalNotification alloc] init];
  //  localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:5];
    
 //   localNotification.alertBody = @"test";
 //    localNotification.alertAction=@"YEeeah!!";
 //   localNotification.timeZone = [NSTimeZone defaultTimeZone];
    
 //   [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
      
}


@end
