//
//  FeedCell.m
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-06-17.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import "FeedCell.h"

@interface FeedCell()
@property (weak, nonatomic) IBOutlet UILabel *dealTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *businessTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *businessAddressLabel;


@end


@implementation FeedCell

- (IBAction)tapDeal:(id)sender {
    NSLog(@"Deal");
}
- (IBAction)tapBusiness:(id)sender {
    NSLog(@"Business");

}

- (void)awakeFromNib
{
    
    // Initialization code
}

-(void)setDealTitle:(NSString *)dTitle BusinessTitle:(NSString*)bTitle Adress:(NSString*)bAddress
{
    self.dealTitleLabel.text=dTitle;
    self.businessTitleLabel.text=bTitle;
    self.businessAddressLabel.text=bAddress;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
