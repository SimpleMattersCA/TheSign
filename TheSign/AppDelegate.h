//
//  AppDelegate.h
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2/20/2014.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

@import UIKit;

@class CLRegion, SignNotificationBanner;

@interface AppDelegate : UIResponder <UIApplicationDelegate>


@property (strong, nonatomic) UIWindow *window;

//the object of the custom notificaton banner, it is independed from
@property (strong, nonatomic) SignNotificationBanner* banner;





//********* For testign purpoces *********//
-(void) welcomeCustomerGPSforRegion:(CLRegion*)region;
-(void) startLocationMonitoring;

@end
