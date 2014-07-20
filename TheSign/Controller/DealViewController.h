//
//  DealViewController.h
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-07-16.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Featured,Statistics;
@interface DealViewController : UIViewController

-(void)setDealToShow:(Featured*) deal Statistics:(Statistics*)stat BackgroundImage:(UIImage*)image;

@end