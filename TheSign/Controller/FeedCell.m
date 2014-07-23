//
//  FeedCell.m
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-06-17.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import "FeedCell.h"
#import "Featured.h"

@interface FeedCell()

@property (weak, nonatomic) IBOutlet UIView *dealTile;
@property (weak, nonatomic) IBOutlet UIView *businessTile;

@end

/*
 


 */
@implementation FeedCell




- (id)initWithCoder:(NSCoder*)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
    }
    return self;
}

- (void)awakeFromNib
{
    self.dealTile.layer.borderWidth=0.5;
    self.dealTile.layer.borderColor=[UIColor whiteColor].CGColor;
    
    self.businessTile.layer.borderWidth=0.5;
    self.businessTile.layer.borderColor=[UIColor whiteColor].CGColor;
    
    
    ;
    
    // Initialization code
}

-(void)setDealToShow:(Featured*)deal
{
    self.deal=deal;
    self.dealTitleLabel.text=deal.fullName;
    self.businessTitleLabel.text=[deal getBusinessName];
    self.businessAddressLabel.text=[deal getLocationAddress];
}

-(void)setGestureRecognizersForTarget:(UIViewController*)controller
{
    [self.dealTile addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:controller action:@selector(actionTapDeal:)]];
    [self.businessTile addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:controller action:@selector(actionTapBusiness:)]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
