//
//  UIViewController+BlurredScreenshot.m
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-07-23.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import "UIViewController+SignExtension.h"
#import "UIImage+ImageEffects.h"
#import "DealViewController.h"
#import "SignNotificationBanner.h"
#import "AppDelegate.h"

@implementation UIViewController (SignExtension)


-(UIImage*)getBlurredScreenshot
{
    UIGraphicsBeginImageContext(self.view.window.bounds.size);
    //[self.view drawViewHierarchyInRect:[UIScreen mainScreen].applicationFrame afterScreenUpdates:YES];
    [self.view.window.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *imageOfUnderlyingView = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    imageOfUnderlyingView = [imageOfUnderlyingView applyBlurWithRadius:10
                                                             tintColor:[UIColor colorWithWhite:1.0 alpha:0.2]
                                                 saturationDeltaFactor:1.2
                                                             maskImage:nil];
    return imageOfUnderlyingView;
}

-(UIImage*)getScreenshot
{
    UIGraphicsBeginImageContext(self.view.window.bounds.size);
    //[self.view drawViewHierarchyInRect:[UIScreen mainScreen].applicationFrame afterScreenUpdates:YES];
    [self.view.window.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *imageOfUnderlyingView = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageOfUnderlyingView;
}

-(void)showModalDeal:(Featured*)deal Statistics:(Statistics*)stat
{
    //to avoid presemting modal deal view when one is already presented
    if(self.presentedViewController)
        [self dismissViewControllerAnimated:NO completion:nil];
    
    DealViewController *controller=[self.storyboard instantiateViewControllerWithIdentifier:@"DealView"];
    [controller setDealToShow:deal Statistics:stat NormalBackground:[self getScreenshot] BlurredBackground:[self getBlurredScreenshot]];
    controller.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    
    
    [self presentViewController:controller animated:YES completion:nil];
}


-(void)addBanner:(SignNotificationBanner*) banner WithText:(NSString*)welcomeText ForDeal:(Featured*)offer Statistics:(Statistics*)stat
{
    //[self.navigationController.view setUserInteractionEnabled:NO];
    
    banner.controller=self;
    banner.notificationText=welcomeText;
    banner.deal=offer;
    banner.stat=stat;
    NSLog(@"About to show up!");
    
   // CGSize bannerSize=[SignNotificationBanner getViewSize];
   // UIView *newBanner = [[UIView alloc] initWithFrame:CGRectMake(0, bannerSize.height,bannerSize.width,bannerSize.height)];
    //UITapGestureRecognizer* userTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeBanner)];
    //[newBanner addGestureRecognizer:userTap];
    //[newBanner setUserInteractionEnabled:YES];
    //[newBanner addSubview:banner.view];
    //[self.view.window bringSubviewToFront:newBanner];

    [self.view.window addSubview:banner.view];

}

-(void) removeBanner
{
    [((AppDelegate*)[[UIApplication sharedApplication]delegate]).banner hideBanner];
}


@end
