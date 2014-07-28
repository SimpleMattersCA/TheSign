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
@property (weak, nonatomic) IBOutlet UIView *outterVIew;

@property (weak, nonatomic) IBOutlet UILabel *lbDealTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbBusinessTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbBusinessAddress;
@property (weak, nonatomic) IBOutlet UILabel *lbTimePeriod;
@property (weak, nonatomic) IBOutlet UIView *vwSpecialTag;
@property (weak, nonatomic) IBOutlet UILabel *lbSpecialTag;
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
    
    
    self.outterVIew.layer.cornerRadius=8;
    self.outterVIew.layer.borderColor=[UIColor colorWithRed:60.0/255.0 green:81.0/255.0 blue:83.0/255.0 alpha:1].CGColor;
    //self.outterVIew.layer.borderColor=[UIColor redColor].CGColor;
    self.outterVIew.layer.borderWidth=1;
    // Initialization code
}

-(void)setDealToShow:(Featured*)deal
{
    self.deal=deal;
    self.lbDealTitle.text=deal.fullName;
    self.lbBusinessTitle.text=[deal getBusinessName];
    self.lbBusinessAddress.text=[deal getLocationAddress];
    self.lbTimePeriod.text=deal.timePeriod;
    NSString* special=[deal getSpecialTagName];
    if(special)
    {
        self.lbSpecialTag.text=special;
        self.vwSpecialTag.backgroundColor=[UIColor colorWithRed:60.0/255.0 green:81.0/255.0 blue:83.0/255.0 alpha:1];
    }
    else
    {
      //  self.lbSpecialTag.text=@"";
        
        self.vwSpecialTag.backgroundColor=[UIColor clearColor];
;
    }
    
    self.imgCategory.image=[deal getCategoryIcon];
    if(deal.opened.boolValue)
        self.imgOpened.image=[UIImage imageNamed:@"Deal_Opened"];
    else
        self.imgOpened.image=[UIImage imageNamed:@"Deal_NotOpened"];
    
    
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
