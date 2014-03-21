//
//  HomeViewController.h
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-03-05.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

@import UIKit;
#import "Model.h"

@interface HomeViewController : UICollectionViewController

-(void) beaconActivatedWithMajor:(NSNumber*)major;
-(void) beaconActivatedWithMajor:(NSNumber*)major withMinor:(NSNumber*)minor;
-(void) beaconLeft;

@end
