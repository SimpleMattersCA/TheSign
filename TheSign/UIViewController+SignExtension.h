//
//  UIViewController+SignExtenstion.h
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-07-23.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Featured,Statistics,SignNotificationBanner;

@interface UIViewController (SignExtension)

-(UIImage*)getBlurredScreenshot;
-(void)addBanner:(SignNotificationBanner*) banner WithText:(NSString*)welcomeText ForDeal:(Featured*)offer Statistics:(Statistics*)stat;

-(void)showModalDeal:(Featured*)deal Statistics:(Statistics*)stat;


@end
