//
//  FeaturedDealCell.m
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-03-31.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import "FeaturedDealCell.h"
@import QuartzCore.QuartzCore;
@interface FeaturedDealCell()


@property (strong, nonatomic) IBOutlet UILabel *dealTextLabel;

@end



@implementation FeaturedDealCell


-(void) showDealInfo
{
    _dealTextLabel.text=_dealText;


}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {

        // Add your subviews here
        // self.contentView for content
        // self.backgroundView for the cell background
        // self.selectedBackgroundView for the selected cell background
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
      //  _dealColor=[UIColor colorWithRed:48/255.0f green:109/255.0f blue:226/255.0f alpha:1.0f];
     //   _dealTextLabel.text=_dealText;
    }
    return self;

}
- (void)prepareForReuse
{
    [super prepareForReuse];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
