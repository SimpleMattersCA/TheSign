//
//  BusinessListController.m
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-05-29.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import "BusinessListController.h"
#import "Model.h"
#import "FeaturedViewController.h"
#import "Business.h"
#import "BUsinessInfoCell.h"
#import "DealListController.h"

@interface BusinessListController ()

@property (nonatomic, weak, readonly) NSArray* businesses;
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationBar;
@property (nonatomic, weak) NSArray* businessTypes;
@end

@implementation BusinessListController

@synthesize businesses=_businesses;
@synthesize businessTypes=_businessTypes;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(NSArray*) businesses
{
    if(!_businesses)
        _businesses=[Business getBusinessesByType:nil];
    return _businesses;
}

-(NSArray*) businessTypes
{
    if(!_businessTypes)
        _businessTypes=[Business getBusinessTypes];
    return _businessTypes;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pulledNewDataFromCloud:)
                                                 name:@"pulledNewDataFromCloud"
                                               object:nil];
    [self.tableView registerNib:[UINib nibWithNibName:@"BusinessInfoCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"BusinessInfo"];
    
    self.navigationBar.title=(NSString*)(self.businessTypes.firstObject);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationBar.backBarButtonItem=backButton;
    //[self.tableView setAllowsSelection:YES];
   // self.tableView.delegate=self;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;

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
    return self.businesses.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BusinessInfo" forIndexPath:indexPath];
    
    NSInteger bID = indexPath.row;
    [(BusinessInfoCell*)cell businessTitle].text=((Business*)(self.businesses[bID])).name;
    
    [(BusinessInfoCell*)cell businessLogo].image=[UIImage imageWithData:((Business*)(self.businesses[bID])).logo];
    [(BusinessInfoCell*)cell businessDescription].text=((Business*)(self.businesses[bID])).welcomeText;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"ShowBusiness" sender:indexPath];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowBusiness"])
    {
        if ([segue.destinationViewController isKindOfClass:[DealListController class]])
        {
            
            NSArray *indexPaths = [self.tableView indexPathsForSelectedRows];
            NSIndexPath *indexPath = [indexPaths objectAtIndex:0];
            
            DealListController *dest = (DealListController *)segue.destinationViewController;
            //NSNumber *businessID=[NSNumber numberWithLong:indexPath.row];
            
            [dest prepareDealsForBusiness:self.businesses[indexPath.row]];
        }
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
