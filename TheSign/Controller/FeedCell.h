//
//  FeedCell.h
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-06-17.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Featured;

@interface FeedCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dealTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *businessTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *businessAddressLabel;

@property (strong, nonatomic) Featured* deal;

-(void)setDealToShow:(Featured*)deal;
-(void)setGestureRecognizersForTarget:(UIViewController*)controller;
@end
