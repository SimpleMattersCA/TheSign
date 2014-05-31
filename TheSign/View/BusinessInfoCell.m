//
//  BusinessInfoCell.m
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-05-29.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import "BusinessInfoCell.h"

@interface BusinessInfoCell()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


@end

@implementation BusinessInfoCell

- (void)awakeFromNib
{
   //     _scrollView.contentSize=CGSizeMake(self.frame.size.width*2,self.frame.size.height);
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
