//
//  FeaturedViewHeaderView.m
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-04-15.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import "FeaturedViewHeader.h"
#import "Business.h"

@interface FeaturedViewHeader()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

//put initializing code into preapeScrollView method, make these properties weak
@property (strong, nonatomic)  UILabel *businessTitle;
@property (strong, nonatomic)  UIImageView *businessImage;
@property (strong, nonatomic)  UILabel *businessDescription;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;


@property CGFloat titleWidth;
@property CGFloat titleHeight;
@property CGFloat descWidth;
@property CGFloat descHeight;
@property CGFloat imageWidth;
@property CGFloat imageHeight;
@property CGFloat defaultMargin;
@property CGFloat defaultPadding;

@end


@implementation FeaturedViewHeader

-(void) prepareScrollView
{
    _scrollView.contentSize=CGSizeMake(self.frame.size.width*2,self.frame.size.height);
    
    [self.scrollView addSubview:self.businessImage];
    [self.scrollView addSubview:self.businessTitle];
    [self.scrollView addSubview:self.businessDescription];


}
-(UILabel*)businessTitle
{
    if(!_businessTitle)
    {
        CGRect  viewRect = CGRectMake(self.frame.size.width/2-self.titleWidth/2, self.businessImage.frame.size.height+self.defaultPadding, self.titleWidth,self.titleHeight);
        _businessTitle=[[UILabel alloc] initWithFrame:viewRect];
        _businessTitle.textAlignment=NSTextAlignmentCenter;
    }
    return _businessTitle;
}

-(UILabel*)businessDescription
{
    if(!_businessDescription)
    {
        CGRect  viewRect = CGRectMake(self.frame.size.width+self.frame.size.width/2-self.descWidth/2, self.defaultMargin, self.descWidth, self.descHeight);
        
        _businessDescription=[[UILabel alloc] initWithFrame:viewRect];
        _businessDescription.textAlignment=NSTextAlignmentNatural;
        _businessDescription.numberOfLines=0;
    }
    return _businessDescription;
}

-(UIImageView*)businessImage
{
    if(!_businessImage)
    {
        CGRect  viewRect = CGRectMake(self.frame.size.width/2-self.imageWidth/2, self.defaultMargin, self.imageWidth, self.imageHeight);
        _businessImage=[[UIImageView alloc] initWithFrame:viewRect];
    }
    return _businessImage;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.pageControl.currentPage=round(self.scrollView.contentOffset.x/self.frame.size.width);
}


-(void) showBusinessInfo
{
    self.businessTitle.text=self.business.name;
    self.businessImage.image=[UIImage imageWithData:self.business.logo];
    self.businessDescription.text=self.business.welcomeText;
    
    [self prepareScrollView];
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
        
        self.titleWidth=100;
        self.titleHeight=30;
        self.descWidth=300;
        self.descHeight=120;
        self.imageWidth=90;
        self.imageHeight=90;
        self.defaultMargin=10;
        self.defaultPadding=10;
        // Add your subviews here
        // self.contentView for content
        // self.backgroundView for the cell background
        // self.selectedBackgroundView for the selected cell background
        
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
   // _businessTitle=nil;
   // _businessDescription=nil;
   // _businessImage=nil;
    
    
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
