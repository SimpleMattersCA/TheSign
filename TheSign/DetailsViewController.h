//
//  ViewController.h
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2/20/2014.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

@import UIKit;

@interface DetailsViewController :UIViewController

@property (nonatomic,strong) NSArray *model;

-(void) setBusinessToShow:(NSNumber*) identifier;

-(void) updateViewForBusiness:(NSNumber*) identifier;


-(void) beaconActivatedWithMajor:(NSNumber*)major;
-(void) beaconActivatedWithMajor:(NSNumber*)major withMinor:(NSNumber*)minor;
-(void) beaconLeft;

@end
