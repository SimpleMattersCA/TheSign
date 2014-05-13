//
//  FeaturedViewFooterView.m
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-04-15.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import "FeaturedViewFooter.h"

@interface FeaturedViewFooter()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end


@implementation FeaturedViewFooter

-(void) showBusinessActions
{
   
    _scrollView.contentSize=CGSizeMake( self.frame.size.width*2, self.frame.size.height);
    CGRect frame;
    
    frame.origin.x = self.frame.size.width;
    frame.origin.y = 0;
    frame.size =self.frame.size;
    UIView *subview = [[UIView alloc]initWithFrame:frame];
    
    CGRect  viewRect = CGRectMake(10, 10, 100, 100);

    UILabel *lab1=[[UILabel alloc] initWithFrame:viewRect];
    lab1.text=@"Blabla";

    lab1.backgroundColor=[UIColor redColor];
    
    [subview addSubview:lab1];
    [_scrollView addSubview:subview];

}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)prepareForReuse
{
    [super prepareForReuse];
    
}


@end
