//
//  FeaturedDealCell.m
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-03-31.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import "FeaturedDealCell.h"
#import "Featured.h"
@import QuartzCore.QuartzCore;
@interface FeaturedDealCell()


@property (strong, nonatomic) IBOutlet UILabel *dealTextLabel;

@end



@implementation FeaturedDealCell


-(void) showDealInfo
{
    _dealTextLabel.text=_deal.title;
    if(_isRight)
        _dealTextLabel.textAlignment=NSTextAlignmentRight;
    else
        _dealTextLabel.textAlignment=NSTextAlignmentLeft;
    [self roundCornersOnView:self];
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

-(UIView *)roundCornersOnView:(UIView *)view
{
    CGFloat radius=28;
    
    UIRectCorner corner; //holds the corner
    if(_isRight)
        corner = UIRectCornerBottomRight | UIRectCornerTopRight;
    else
        corner = UIRectCornerBottomLeft | UIRectCornerTopLeft;
    UIView *roundedView = view;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:roundedView.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = roundedView.bounds;
    maskLayer.path = maskPath.CGPath;
    roundedView.layer.mask = maskLayer;
    return roundedView;
    
}



- (id)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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
