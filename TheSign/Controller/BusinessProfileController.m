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
#import "UIImage+ImageEffects.h"

@interface BusinessProfileController ()
@property (weak, nonatomic) IBOutlet UIImageView *businessLogo;
@property (weak, nonatomic) IBOutlet UITableView *dealList;
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationBar;

@property (nonatomic, strong) NSArray* deals;
@property (nonatomic, strong) Business* business;

@end

@implementation BusinessProfileController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.businessLogo.image=[UIImage imageWithData:self.business.logo];
    CALayer *imageLayer = self.businessLogo.layer;
    imageLayer.cornerRadius=self.businessLogo.frame.size.width/2;
    imageLayer.borderWidth=1;
    imageLayer.borderColor=[UIColor whiteColor].CGColor;
    imageLayer.masksToBounds=YES;
    self.navigationBar.title=self.business.name;
    self.dealList.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
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
    
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"ShowDeal"] && [segue.destinationViewController isKindOfClass:[DealViewController class]])
    {
        NSIndexPath *indexPath = [self.dealList indexPathForCell:sender];

        UIImage* background=[self getBlurredScreenshot];
        DealViewController * controller = segue.destinationViewController ;
     
        [controller setDealToShow:self.deals[indexPath.row] Statistics:nil BackgroundImage:background];
       
        controller.modalPresentationStyle = UIModalPresentationCustom;
    }
    
    
}

-(UIImage*)getBlurredScreenshot
{
    UIGraphicsBeginImageContext(self.view.window.bounds.size);
    //[self.view drawViewHierarchyInRect:[UIScreen mainScreen].applicationFrame afterScreenUpdates:YES];
    [self.view.window.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *imageOfUnderlyingView = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    imageOfUnderlyingView = [imageOfUnderlyingView applyBlurWithRadius:10
                                                             tintColor:[UIColor colorWithWhite:1.0 alpha:0.2]
                                                 saturationDeltaFactor:1.2
                                                             maskImage:nil];
    return imageOfUnderlyingView;
}

@end
