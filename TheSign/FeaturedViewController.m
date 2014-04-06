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
#import "Featured.h"
@interface FeaturedViewController ()

@property (strong,nonatomic) NSNumber* businessID;
@property (strong,nonatomic) Business* business;

@end

@implementation FeaturedViewController


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
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


-(void) setBusinessToShow:(NSNumber*) identifier
{
    self.businessID=identifier;
    self.business=[Model sharedModel].businesses[[identifier integerValue]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.business.feature.count;
}



#pragma mark - Populating the view
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"FeaturedDeal";
    
    FeaturedDealCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    Featured*  deal=self.business.feature.allObjects[indexPath.row];

    cell.dealText=deal.title;
    
    [cell showDealInfo];
    return cell;
}




#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"BusinessToFeatured"]){
        if ([segue.destinationViewController isKindOfClass:[DetailsViewController class]])
        {
            NSArray *indexPaths = [self.collectionView indexPathsForSelectedItems];
            NSIndexPath *indexPath = [indexPaths objectAtIndex:0];
            
            DetailsViewController *dest = (DetailsViewController *)segue.destinationViewController;
            NSNumber *businessID=[[NSNumber alloc] initWithInteger:indexPath.row];
            
            [dest setBusinessToShow:businessID];
        }
    }
}




@end
