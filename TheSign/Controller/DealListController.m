//
//  DealListController.m
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-05-30.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import "DealListController.h"
#import "Business.h"
#import "Featured.h"
#import "DetailsViewController.h"

@interface DealListController ()

@property (nonatomic) Business* business;
@property (nonatomic) NSArray* deals;
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationBar;

@end

@implementation DealListController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationBar.title=self.business.name;
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationBar.backBarButtonItem=backButton;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return self.deals.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DealCell" forIndexPath:indexPath];
    cell.textLabel.text=((Featured*)(self.deals[indexPath.row])).title;
    // Configure the cell...
    
    return cell;
}



-(void) prepareDealsForBusiness:(Business*) business
{
    self.business=business;
    self.deals=[business.featuredOffers allObjects];
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowDeal"])
    {
        if ([segue.destinationViewController isKindOfClass:[DetailsViewController class]])
        {
            
            NSArray *indexPaths = [self.tableView indexPathsForSelectedRows];
            NSIndexPath *indexPath = [indexPaths objectAtIndex:0];
            
            DetailsViewController *dest = (DetailsViewController *)segue.destinationViewController;
            //NSNumber *businessID=[NSNumber numberWithLong:indexPath.row];
            [dest prepareDealToShow:self.deals[indexPath.row]];
        }
    }

}


@end
