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
    self.tableView.backgroundColor=[UIColor colorWithRed:244.0/255.0 green:248.0/255.0 blue:249.0/255.0 alpha:1];
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
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0,self.tableView.frame.size.width,45)];
    header.backgroundColor=[UIColor colorWithRed:245.0/255.0 green:249.0/255.0 blue:250.0/255.0 alpha:1];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,30,self.tableView.frame.size.width,30)];
    label.text=self.firstLetters[section];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"Futura" size:14];
    label.textColor=[UIColor colorWithRed:60.0/255.0 green:81.0/255.0 blue:83.0/255.0 alpha:1];
    [header addSubview:label];

    return header;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BusinessCell" forIndexPath:indexPath];
    
    UIView *lineViewUp = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.contentView.frame.size.width, 1)];
    
    if(indexPath.row==0)
        lineViewUp.backgroundColor =[UIColor colorWithRed:60.0/255.0 green:81.0/255.0 blue:83.0/255.0 alpha:1];

    else
        lineViewUp.backgroundColor =[UIColor colorWithRed:216.0/255.0 green:216.0/255.0 blue:216.0/255.0 alpha:1];
    
    UIView *lineViewDown = [[UIView alloc] initWithFrame:CGRectMake(0, cell.contentView.frame.size.height-1, cell.contentView.frame.size.width, 1)];
    
    if(indexPath.row==[self.tableView numberOfRowsInSection:indexPath.section]-1)
    {
        lineViewDown.backgroundColor = [UIColor colorWithRed:216.0/255.0 green:216.0/255.0 blue:216.0/255.0 alpha:1];
        [cell.contentView addSubview:lineViewDown];

    }
    //else
     //   lineViewDown.backgroundColor = [UIColor grayColor];
    [cell.contentView addSubview:lineViewUp];
    
    NSInteger index=((NSNumber*)[[self.businessesInSections allKeysForObject:self.firstLetters[indexPath.section]] objectAtIndex:indexPath.row]).integerValue;
    
    Business* business=self.businesses[index];
    cell.textLabel.text=business.name;
    cell.detailTextLabel.text=business.welcomeText;
    
    cell.backgroundColor=[UIColor colorWithRed:245.0/255.0 green:249.0/255.0 blue:250.0/255.0 alpha:1];
    
    return cell;
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
