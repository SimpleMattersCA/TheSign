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


@end


@implementation FeedCell

- (void)awakeFromNib
{
    
    // Initialization code
}

-(void)setDealTitle:(NSString *)dTitle BusinessTitle:(NSString*)bTitle
{
    self.dealTitleLabel.text=dTitle;
    self.businessTitleLabel.text=bTitle;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
