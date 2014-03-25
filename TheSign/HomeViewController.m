//
//  HomeViewController.m
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-03-05.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import "HomeViewController.h"
#import "Business.h"
#import "DetailsViewController.h"
#import "Model.h"

@interface HomeViewController () <UICollectionViewDataSource>

@property (nonatomic, strong) NSArray * businesses;

@property (weak, nonatomic) IBOutlet UINavigationItem *navigationBar;

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
    }
    return self;
}

- (void) pulledNewDataFromCloud:(NSNotification *) notification
{
    // [notification name] should always be @"TestNotification"
    // unless you use this method for observation of other notifications
    // as well.
    
    if ([[notification name] isEqualToString:@"pulledNewDataFromCloud"])
    {
        [self.collectionView reloadItemsAtIndexPaths:[self.collectionView indexPathsForVisibleItems]];
        [self.collectionView reloadData];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pulledNewDataFromCloud:)
                                                 name:@"pulledNewDataFromCloud"
                                               object:nil];

	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.businesses.count;
}


-(NSArray*) businesses
{
    if(!_businesses)
    {
        _businesses=[Model sharedModel].businesses;
    }
    return _businesses;
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ListToBusiness"]){
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


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Cell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    
    //UILabel *businessTitle = (UILabel *)[cell viewWithTag:100];
    UIImageView *businessLogo = (UIImageView *)[cell viewWithTag:100];
    CALayer *imageLayer = businessLogo.layer;
    imageLayer.cornerRadius=cell.frame.size.width/2;
    imageLayer.borderWidth=3;
    imageLayer.masksToBounds=YES;
    
    UIImage *image = [UIImage imageWithData:((Business*)self.businesses[indexPath.row]).logo];
    
    businessLogo.image= image;
   
    return cell;
}

@end
