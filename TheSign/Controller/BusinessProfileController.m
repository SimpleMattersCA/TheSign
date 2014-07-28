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
#import "Model.h"
#import "DealViewController.h"
#import "UIViewController+SignExtension.h"
#import "BusinessHeader.h"
#import "UIImage+ImageEffects.h"

@interface BusinessProfileController ()
//@property (weak, nonatomic) IBOutlet UIImageView *businessLogo;
@property (weak, nonatomic) IBOutlet UITableView *dealList;
//@property (weak, nonatomic) IBOutlet UIImageView *blurredBack;
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationBar;

@property (nonatomic, strong) NSArray* deals;
@property (nonatomic, strong) Business* business;

@end

@implementation BusinessProfileController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.title=self.business.name;
    self.dealList.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.dealList registerNib:[UINib nibWithNibName:@"BusinessProfileHeader" bundle:nil] forHeaderFooterViewReuseIdentifier:@"CustomHeader"];
    //[self.dealList registerClass:[BusinessHeader class] forHeaderFooterViewReuseIdentifier:@"CustomHeader"];
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
    UIView* outterView=[cell viewWithTag:1];
    outterView.layer.cornerRadius=8;

    UILabel* lbDeal=(UILabel*)[cell viewWithTag:2];
    lbDeal.text=deal.fullName;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 320;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    BusinessHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"CustomHeader"];
    
   /*
    UIImageView *blurredBack=(UIImageView*)[header viewWithTag:3];
    UIImageView *logo=(UIImageView*)[header viewWithTag:4];
    UILabel *descr=(UILabel*)[header viewWithTag:5];
    
    logo.image=[UIImage imageWithData:self.business.logo];
    CALayer *imageLayer = logo.layer;
    imageLayer.cornerRadius=logo.frame.size.width/2;
    imageLayer.borderWidth=1;
    imageLayer.borderColor=[UIColor whiteColor].CGColor;
    imageLayer.masksToBounds=YES;
    
    blurredBack.image=[UIImage imageWithData:self.business.blurredBack];
    descr.text=self.business.about;
*/
    header.imgLogo.image=[UIImage imageWithData:self.business.logo];
    CALayer *imageLayer = header.imgLogo.layer;
    imageLayer.cornerRadius=header.imgLogo.frame.size.width/2;
    imageLayer.borderWidth=1;
    imageLayer.borderColor=[UIColor colorWithRed:61.0/255.0 green:81.0/255.0 blue:83.0/255.0 alpha:1].CGColor;
    imageLayer.masksToBounds=YES;
    
    UIImage* blurredBack = [[UIImage imageWithData:self.business.blurredBack] applyBlurWithRadius:8
                                                                                        tintColor:[UIColor colorWithWhite:1.0 alpha:0.2]
                                                                            saturationDeltaFactor:1.2
                                                                                        maskImage:nil];
    header.imgBlurredBack.image=blurredBack;
    header.lbAbout.text=self.business.about;
    
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self showModalDeal:self.deals[indexPath.row] Statistics:nil];
}

@end
