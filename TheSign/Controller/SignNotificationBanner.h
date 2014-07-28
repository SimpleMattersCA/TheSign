//
//  SignNotificationBanner.h
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-07-25.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Featured,Statistics;

@interface SignNotificationBanner : UIViewController 

@property (nonatomic, weak) UIViewController* controller;
@property (nonatomic, weak) Featured* deal;
@property (nonatomic, weak) Statistics* stat;
@property (nonatomic, strong) NSString* notificationText;

@property (nonatomic, strong) UIImage* blurredBackground;

-(void) hideBanner;

+(CGSize)getViewSize;
@end
