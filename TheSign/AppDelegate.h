//
//  AppDelegate.h
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2/20/2014.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

@import UIKit;

@class CLRegion;

@interface AppDelegate : UIResponder


@property (strong, nonatomic) UIWindow *window;


//TODO: remove once testing is done
-(void) welcomeCustomerGPSforRegion:(CLRegion*)region;

-(void) startLocationMonitoring;

@end
