//
//  BusinessProfileController.m
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-07-17.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import "BusinessProfileController.h"
#import "Business.h"
#import "Featured.h"

@interface BusinessProfileController ()
@property (weak, nonatomic) IBOutlet UIImageView *businessLogo;
@property (weak, nonatomic) IBOutlet UILabel *businessTitle;
@property (weak, nonatomic) IBOutlet UITableView *dealList;

@property (nonatomic, strong) NSArray* deals;
@property (nonatomic, strong) Business* business;

@end

@implementation BusinessProfileController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.businessLogo.image=[UIImage imageWithData:self.business.logo];
    self.businessTitle.text=self.business.name;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)setBusinessToShow:(Business*)business
{
    self.business=business;
    self.deals=[[business getActiveOffers] allObjects];
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
    //FeedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DealCell" forIndexPath:indexPath];
    Featured* deal=self.deals[indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DealListCell"];
    [cell.textLabel setText:deal.fullName];
    
    
    return cell;
    
    
    // [cell setDealTitle:deal.fullName BusinessTitle:deal.linkedBusiness.name Adress:((Location*)(deal.linkedBusiness.linkedLocations.anyObject)).address];
    // Configure the cell...
    
    return cell;
}



@end
