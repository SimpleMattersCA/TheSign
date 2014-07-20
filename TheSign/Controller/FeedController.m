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
#import "UIImage+ImageEffects.h"
#import "Featured.h"

@interface FeedController ()

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

-(void) showDealAfterLoad:(Featured*)offer Statistics:(Statistics*)stat
{
    self.dealToShow=offer;
    self.statForDeal=stat;
}

- (void)actionTapDeal:(UIGestureRecognizer *)sender
{
   // NSLog(@"%@",((FeedCell*)sender.view.superview.superview).dealTitleLabel.text);
    [self performSegueWithIdentifier:@"ShowDeal" sender:sender.view.superview.superview];
}
- (void)actionTapBusiness:(UIGestureRecognizer *)sender
{
   // NSLog(@"%@",((FeedCell*)sender.view.superview.superview).businessTitleLabel.text);
    [self performSegueWithIdentifier:@"ShowOneBusiness" sender:sender.view.superview.superview];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.deals=[[Model sharedModel] getDealsForFeed];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if(self.dealToShow && self.statForDeal)
    {
        [self performSegueWithIdentifier:@"ShowDeal" sender:self];
        self.dealToShow=nil;
        self.statForDeal=nil;
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    
   // [self.tableView registerNib:[UINib nibWithNibName:@"FeedCell" bundle:[NSBundle mainBundle]]
    //      forCellReuseIdentifier:@"DealCell"];
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



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"!!!Row Selected :%d",indexPath.row);
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"ShowDeal"] && [segue.destinationViewController isKindOfClass:[DealViewController class]])
    {
        UIImage* background=[self getBlurredScreenshot];
        DealViewController * controller = segue.destinationViewController ;
        if([sender isKindOfClass:[FeedCell class]])
            [controller setDealToShow:((FeedCell*)sender).deal Statistics:nil BackgroundImage:background];
        else if([sender isKindOfClass:[FeedController class]])
            [controller setDealToShow:self.dealToShow Statistics:self.statForDeal BackgroundImage:background];
        controller.modalPresentationStyle = UIModalPresentationCustom;
    }
    
    if([segue.identifier isEqualToString:@"ShowOneBusiness"] && [segue.destinationViewController isKindOfClass:[BusinessProfileController class]])
    {
        BusinessProfileController * controller = segue.destinationViewController;
        [controller setBusinessToShow:((FeedCell*)sender).deal.linkedBusiness];
    }

}

-(UIImage*)getBlurredScreenshot
{
    UIImage* imageOfUnderlyingView = [self convertViewToImage];
    imageOfUnderlyingView = [imageOfUnderlyingView applyBlurWithRadius:10
                                                             tintColor:[UIColor colorWithWhite:1.0 alpha:0.2]
                                                 saturationDeltaFactor:1.2
                                                             maskImage:nil];
    return imageOfUnderlyingView;
}

-(UIImage *)convertViewToImage
{
    UIGraphicsBeginImageContext(self.view.window.bounds.size);
    //[self.view drawViewHierarchyInRect:[UIScreen mainScreen].applicationFrame afterScreenUpdates:YES];
    [self.view.window.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
