//
//  FeaturedViewController.m
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-03-26.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import "FeaturedViewController.h"
#import "DetailsViewController.h"
#import "FeaturedDealCell.h"
#import "FeaturedViewHeader.h"
#import "FeaturedViewFooter.h"

#import "Business.h"

# pragma mark - DEPRECATED
@interface FeaturedViewController () <ScrollingCellDelegate>

//@property (strong,nonatomic) NSNumber* businessID;
@property (strong,nonatomic) Business* business;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property IBOutlet UIView *rightView;

@property IBOutlet UIView *leftView;

@end

@implementation FeaturedViewController

#pragma mark - ScrollingCellDelegate
-(void)scrollingCellDidBeginPulling:(FeaturedDealCell *)cell
{
    [_scrollView setScrollEnabled:NO];
}
-(void)scrollingCell:(FeaturedDealCell *)cell didChangePullOffset:(CGFloat)offset
{
    [_scrollView setContentOffset:CGPointMake(offset, 0)];
}
-(void)scrollingCellDidEndPulling:(FeaturedDealCell *)cell
{
    [_scrollView setScrollEnabled:YES];
}


#pragma mark - Preparing the View
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [self.collectionView registerNib:[UINib nibWithNibName:@"FeaturedDealCell" bundle:[NSBundle mainBundle]]
        forCellWithReuseIdentifier:@"FeaturedDeal"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"FeaturedHeaderView" bundle:[NSBundle mainBundle]]
          forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"BusinessInfo"];
     
    [self.collectionView registerNib:[UINib nibWithNibName:@"FeaturedFooterView" bundle:[NSBundle mainBundle]]
          forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"BusinessActions"];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
  //  NSLayoutConstraint *contentWidth = [NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeLeading multiplier:1 constant:self.view.bounds.size.width*3];
    
  //  [self.scrollView addConstraint:contentWidth];
    
   // _scrollView.contentSize=CGSizeMake(960,self.view.bounds.size.height);

    
    
    CGRect  viewRect = CGRectMake(40, 10, 100, 100);
    UILabel *lab1=[[UILabel alloc] initWithFrame:viewRect];
    lab1.text=@"Blabla";
    lab1.backgroundColor=[UIColor redColor];
    [self.rightView addSubview:lab1];
    
    

    //moving collectionview from the position of leftmost to the right
 //      _collectionView.center=CGPointMake(self.view.bounds.size.width, _collectionView.center.y);
     //    _collectionView.frame=CGRectMake(self.view.bounds.size.width,
       //                                        self.view.frame.origin.y,
           //                                  self.view.frame.size.width,
         //                                  self.view.frame.size.height);
    
    //Since there gonna be a deal view on the left our collection view will be on the right so we scroll to it
    
 /*   NSLayoutConstraint *collectionViewPosition = [NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeLeading multiplier:2 constant:self.view.bounds.size.width];
    
    [self.scrollView addConstraint:collectionViewPosition];
    
    
    
    
    
    [_scrollView setContentOffset:CGPointMake(self.view.frame.size.width,
                                              self.view.frame.origin.y)
                       animated:NO];*/
    
    
      //UIView* _rightView = [[UIView alloc] init];
   // _rightView.frame = CGRectMake(self.view.bounds.size.width, 0, self.view.bounds.size.width, _scrollView.bounds.size.height);
   // [_scrollView addSubview:_rightView];

}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.scrollView setContentSize:CGSizeMake(self.view.bounds.size.width * 2, self.scrollView.bounds.size.height)];
    
    self.rightView = [[UIView alloc] init];
    self.rightView.frame = CGRectMake(self.view.bounds.size.width, 0, self.view.bounds.size.width, self.scrollView.bounds.size.height);
    [self.scrollView addSubview:self.rightView];
    
   /* switch(self.business.feature.allObjects.count)
    {
        case 0:
        {
            //we aren't really changing anything here. No deal - no problemo
            _scrollView.contentSize=CGSizeMake(self.view.bounds.size.width,self.view.bounds.size.height);
            break;
        }
        case 1:
        {
            //doubling scrollview's contentsize to accomodate collection view and one view(on the left) for deals
            [_scrollView setContentSize:CGSizeMake(self.view.bounds.size.width*2,_scrollView.bounds.size.height)];

            //moving collectionview from the position of leftmost to the right
         //   _collectionView.center=CGPointMake(_collectionView.center.x+_scrollView.bounds.size.width, _collectionView.center.y);
       //     _collectionView.frame=CGRectMake(320,
         //                                           self.view.frame.origin.y,
           //                                         self.view.frame.size.width,
             //                                       self.view.frame.size.height);
            
            //Since there gonna be a deal view on the left our collection view will be on the right so we scroll to it
          //  [_scrollView setContentOffset:CGPointMake(self.view.frame.size.width,
            //                                          self.view.frame.origin.y)
              //                   animated:NO];
            
            CGRect frame;
            frame.origin.x = self.view.bounds.size.width;
            frame.origin.y = 0;
            frame.size.width =self.view.bounds.size.width;
            frame.size.height=_scrollView.bounds.size.height;
            UIView *subview = [[UIView alloc]initWithFrame:frame];
            CGRect  viewRect = CGRectMake(10, 10, 100, 100);
            UILabel *lab1=[[UILabel alloc] initWithFrame:viewRect];
            lab1.text=@"Blabla";
            lab1.backgroundColor=[UIColor redColor];
            [subview addSubview:lab1];
            [_scrollView addSubview:subview];
            
            break;
        }
        default:
        {
            //tripling scrollview's contentsize to accomodate collection view and two views(on left and right) for deals
            _scrollView.contentSize=CGSizeMake(self.view.bounds.size.width*3,self.view.bounds.size.height);
            
            //moving collectionview from leftmost position to the middle
            _collectionView.frame=CGRectMake(_scrollView.frame.size.width,
                                             _collectionView.frame.origin.y,
                                             _collectionView.frame.size.width,
                                             _collectionView.frame.size.height);
            //Since there gonna be a deal view on the left our collection view will be on the right so we scroll to it
            [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width,
                                                      _scrollView.frame.origin.y)
                                 animated:NO];
            
           CGRect frame;
            frame.origin.x = 0;
            frame.origin.y = 0;
            frame.size =_scrollView.frame.size;
            UIView *subview = [[UIView alloc]initWithFrame:frame];
            CGRect  viewRect = CGRectMake(10, 10, 100, 100);
            UILabel *lab1=[[UILabel alloc] initWithFrame:viewRect];
            lab1.text=@"Blabla";
            lab1.backgroundColor=[UIColor redColor];
            [subview addSubview:lab1];
            [_scrollView addSubview:subview];
            
            CGRect frame2;
            frame2.origin.x = _scrollView.frame.size.width*2;
            frame2.origin.y = 0;
            frame2.size =_scrollView.frame.size;
            UIView *subview2 = [[UIView alloc]initWithFrame:frame2];
            UILabel *lab2=[[UILabel alloc] initWithFrame:viewRect];
            lab2.text=@"Blabla";
            lab2.backgroundColor=[UIColor redColor];
            [subview2 addSubview:lab2];
            [_scrollView addSubview:subview2];
            break;
        }
    }*/
    
    // Do any additional setup after loading the view.
}


-(void) setBusinessToShow:(Business*) business
{
    self.business=business;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.business.featuredOffers.count;
}



#pragma mark - Populating the view

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        FeaturedViewHeader *headerView=[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"BusinessInfo" forIndexPath:indexPath];
        headerView.business=_business;
        [headerView showBusinessInfo];
        
        
         reusableview = headerView;
      
        

    }
    
    if (kind == UICollectionElementKindSectionFooter) {
        FeaturedViewFooter *footerView=[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"BusinessActions" forIndexPath:indexPath];
        
        [footerView showBusinessActions];
        reusableview = footerView;

    }
    
    return reusableview;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    FeaturedDealCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FeaturedDeal" forIndexPath:indexPath];

    // TODO: pulling only active deals, there gonna be some sort of a filter
    Featured*  deal=self.business.featuredOffers.allObjects[indexPath.row];
    cell.deal=deal;
    bool isRight=indexPath.row%2==0?YES:NO;
    cell.isRight=isRight;
   // cell.delegate=self;
    [cell showDealInfo];
    return cell;
}




#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"BusinessToFeatured"]){
        // TODO: rework preparing detailsviewcontroller, send the whole deal and not the businessID
        if ([segue.destinationViewController isKindOfClass:[DetailsViewController class]])
        {
            //NSArray *indexPaths = [self.collectionView indexPathsForSelectedItems];
          //  NSIndexPath *indexPath = [indexPaths objectAtIndex:0];
           //
          //  DetailsViewController *dest = (DetailsViewController *)segue.destinationViewController;
          //  NSNumber *businessID=[[NSNumber alloc] initWithInteger:indexPath.row];
            
         //   [dest setBusinessToShow:businessID];
        }
    }
}

- (DetailsViewController*) prepareDestination:(NSInteger)order
{
    DetailsViewController *dest = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailsView"];
    
    //1,3... - are on the left side, 2,4.. - on the right side
    bool isRight=order%2==0?YES:NO;
    
    if(isRight)
    {
    
    }
    else
    {
    
    }
    
    
    return dest;
}




@end
