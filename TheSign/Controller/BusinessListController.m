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
//TODO: remove after testing complete
#import "InsightEngine.h"
#import "Location.h"
#import "BusinessProfileController.h"
#import "DealViewController.h"


@interface BusinessListController ()

@property NSArray *businesses;
@property NSArray *firstLetters;

@property NSDictionary* businessesInSections;

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
    NSArray *unsorted=[[Model sharedModel] getBusinesses];
    
    NSMutableDictionary* indexForLetter=[NSMutableDictionary new];
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    self.businesses=[unsorted sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];

    NSMutableSet *firstCharacters = [NSMutableSet setWithCapacity:0];
    NSString* letter;
    for(NSInteger i=0;i<self.businesses.count;i++)
    {
        letter=[[self.businesses[i] valueForKey:@"name"] substringToIndex:1];
        [firstCharacters addObject:letter];
        [indexForLetter setObject:letter forKey:@(i)];
    }
    
    self.firstLetters = [[firstCharacters allObjects] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    self.businessesInSections=indexForLetter;
    
    //remove extra separators
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0,0,0,10)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

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
    return self.firstLetters.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.businessesInSections allKeysForObject:self.firstLetters[section]].count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger) section
{
    //section text as a label
    UILabel *header = [UILabel new];
    header.text=self.firstLetters[section];
    header.textAlignment = NSTextAlignmentCenter;
    header.backgroundColor=[UIColor clearColor];
    header.font = [UIFont fontWithName:@"Futura" size:10];
    header.textColor=[UIColor whiteColor];
    
    return header;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BusinessCell" forIndexPath:indexPath];
    
    NSInteger index=((NSNumber*)[[self.businessesInSections allKeysForObject:self.firstLetters[indexPath.section]] objectAtIndex:indexPath.row]).integerValue;
    
    Business* business=self.businesses[index];
    cell.textLabel.text=business.name;
    cell.detailTextLabel.text=business.welcomeText;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, cell.contentView.frame.size.width, 1)];
    lineView.backgroundColor = [UIColor whiteColor];
    [cell.contentView addSubview:lineView];
    
    //  BusinessCell *newCell=[[BusinessCell alloc] init];
    

    
    return cell;
}

//TODO: remove after testing complete
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  /*  Business* selected=self.businesses[indexPath.row];
    NSNumber* major=((Location*)selected.linkedLocations.anyObject).major;
    Statistics* stat=[[Model sharedModel] recordStatisticsFromGPS:major];
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertBody = [[InsightEngine sharedInsight] generateWelcomeTextForGPSdetectedMajor:major];
    NSLog(@"%@",notification.alertBody);
    notification.fireDate=[[NSDate date] dateByAddingTimeInterval:10];
    
    NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:major,@"Major",stat,@"StatisticsID", nil];
    
    
    notification.userInfo=infoDict;
    if(notification.alertBody!=nil && ![notification.alertBody isEqual:@""])
    {
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 1];
    }
*/

}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"ShowBusiness"] && [segue.destinationViewController isKindOfClass:[BusinessProfileController class]])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        NSInteger index=((NSNumber*)[[self.businessesInSections allKeysForObject:self.firstLetters[indexPath.section]] objectAtIndex:indexPath.row]).integerValue;

        if(indexPath)
        {
            BusinessProfileController *dest = (BusinessProfileController *)segue.destinationViewController;
            [dest setBusinessToShow:self.businesses[index]];
        }
    }
}


@end
