//
//  FeedController.m
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-06-17.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import "FeedController.h"
#import "FeedCell.h"
#import "Model.h"
#import "DealViewController.h"
#import "BusinessProfileController.h"
#import "Featured.h"

#import "UIImage+ImageEffects.h"
#import "UIViewController+SignExtension.h"

@interface FeedController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnProfile;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnPlaces;

@property (nonatomic, strong) NSArray* deals;

@property (nonatomic, strong) Featured* dealToShow;
@property (nonatomic, strong) Statistics* statForDeal;


@end

@implementation FeedController

- (IBAction)updateDealList:(id)sender {
    self.deals=[[Model sharedModel] getDealsForFeed];
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];

}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization

    }
    return self;
}

//-(void) showDealAfterLoad:(Featured*)offer Statistics:(Statistics*)stat
//{
 //   self.dealToShow=offer;
 //   self.statForDeal=stat;
  //  [self viewDidLoad];
//}

- (void)actionTapDeal:(UIGestureRecognizer *)sender
{
    UIView* view=sender.view;
    while(![view isKindOfClass:[FeedCell class]])
    {
        view=view.superview;
    }
   // [self.tableView ]
    
    ((FeedCell*)view).imgOpened.image=[UIImage imageNamed:@"Deal_NotOpened"];
    [self showModalDeal:((FeedCell*)view).deal Statistics:nil];

}
- (void)actionTapBusiness:(UIGestureRecognizer *)sender
{
    UIView* view=sender.view;
    while(![view isKindOfClass:[FeedCell class]])
    {
        view=view.superview;
    }
    [self performSegueWithIdentifier:@"ShowOneBusiness" sender:view];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.deals=[[Model sharedModel] getDealsForFeed];
    
    [self.btnProfile setTitleTextAttributes:@{
                                         NSFontAttributeName: [UIFont fontWithName:@"Futura" size:18],
                                         NSForegroundColorAttributeName: [UIColor whiteColor]
                                         } forState:UIControlStateNormal];
    [self.btnPlaces setTitleTextAttributes:@{
                                              NSFontAttributeName: [UIFont fontWithName:@"Futura" size:18],
                                              NSForegroundColorAttributeName: [UIColor whiteColor]
                                              } forState:UIControlStateNormal];
    
    if(self.dealToShow && self.statForDeal)
    {
       [self performSegueWithIdentifier:@"ShowDeal" sender:self];
        self.dealToShow=nil;
        self.statForDeal=nil;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //TODO: only a small number at start
    return self.deals.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FeedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DealCell"];
    [cell setDealToShow:self.deals[indexPath.row]];
    [cell setGestureRecognizersForTarget:self];
    
    
    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"ShowDeal"] && [segue.destinationViewController isKindOfClass:[DealViewController class]])
    {
        NSLog(@"Shouldn't be here");
    }

    if([segue.identifier isEqualToString:@"ShowOneBusiness"] && [segue.destinationViewController isKindOfClass:[BusinessProfileController class]])
    {
        BusinessProfileController * controller = segue.destinationViewController;
        [controller setBusinessToShow:((FeedCell*)sender).deal.linkedBusiness];
    }

}





@end
