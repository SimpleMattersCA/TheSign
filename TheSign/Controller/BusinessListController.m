//
//  BusinessList.m
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-06-18.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import "BusinessListController.h"
#import "Model.h"
#import "Business.h"
#import "BusinessCell.h"
#import "Business.h"
//TODO: remove after testing complete
#import "InsightEngine.h"
#import "Location.h"
#import "BusinessProfileController.h"
#import "DealViewController.h"

@interface BusinessListController ()

@property NSArray *businesses;

@end

@implementation BusinessListController

- (instancetype)initWithStyle:(UITableViewStyle)style
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
    self.businesses=[Business getBusinessesForContext:[Model sharedModel].managedObjectContext];
    //self.edgesForExtendedLayout = UIRectEdgeAll;
    //self.tableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, CGRectGetHeight(self.tabBarController.tabBar.frame), 0.0f);
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


-(void)viewWillAppear:(BOOL)animated{
 //   [self.tableView registerNib:[UINib nibWithNibName:@"BusinessCell" bundle:[NSBundle mainBundle]]
   //      forCellReuseIdentifier:@"BusinessCell"];
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
//    NSArray* businesses=[[Model sharedModel] getBusinessesByType:nil];
    return self.businesses.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BusinessCell" forIndexPath:indexPath];
    Business* business=self.businesses[indexPath.row];
    cell.textLabel.text=business.name;
    cell.detailTextLabel.text=business.welcomeText;
    //  BusinessCell *newCell=[[BusinessCell alloc] init];
    

    
    return cell;
}

//TODO: remove after testing complete
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Business* selected=self.businesses[indexPath.row];
    NSNumber* major=((Location*)selected.linkedLocations.anyObject).major;
    Statistics* stat=[[Model sharedModel] recordStatisticsFromGPS:major];
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertBody = [[InsightEngine sharedInsight] generateWelcomeTextForGPSdetectedMajor:major];
    NSLog(@"%@",notification.alertBody);
    notification.fireDate=[[NSDate date] dateByAddingTimeInterval:10];
    
    NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:major,@"Major",/*stat,@"StatisticsID",*/ nil];
    
    
    notification.userInfo=infoDict;
    if(notification.alertBody!=nil && ![notification.alertBody isEqual:@""])
    {
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 1];
    }


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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"ShowBusiness"] && [segue.destinationViewController isKindOfClass:[BusinessProfileController class]])
    {
        NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
        if(indexPath)
        {
            BusinessProfileController *dest = (BusinessProfileController *)segue.destinationViewController;
            [dest setBusinessToShow:self.businesses[indexPath.row]];
        }
    }
    if([segue.identifier isEqualToString:@"ShowDeal"] && [segue.destinationViewController isKindOfClass:[DealViewController class]])
    {
        NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
        if(indexPath)
        {
            BusinessProfileController *dest = (BusinessProfileController *)segue.destinationViewController;
            [dest setBusinessToShow:self.businesses[indexPath.row]];
        }
    }
}


@end
