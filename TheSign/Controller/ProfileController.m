//
//  ProfileController.m
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-06-18.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import "ProfileController.h"
#import "Model.h"
#import "User.h"
#import "Tag.h"
#import <QuartzCore/QuartzCore.h>

@interface ProfileController ()
@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *interestsCollection;

@property (nonatomic, strong) NSArray* interests;
@end

@implementation ProfileController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.profilePic.image=[UIImage imageWithData:[Model sharedModel].currentUser.pic];
    CALayer *imageLayer = self.profilePic.layer;
    imageLayer.cornerRadius=self.profilePic.frame.size.width/2;
    imageLayer.borderWidth=0;
    imageLayer.masksToBounds=YES;
    self.nameLabel.text=[Model sharedModel].currentUser.name;
    self.interests=[[Model sharedModel] getInterests];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [self.interestsCollection dequeueReusableCellWithReuseIdentifier:@"InterestCell" forIndexPath:indexPath];
    [UIView animateWithDuration:1.0 animations:^{
        cell.layer.backgroundColor = [UIColor orangeColor].CGColor;
    } completion:NULL];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.interests.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell *cell = [self.interestsCollection dequeueReusableCellWithReuseIdentifier:@"InterestCell" forIndexPath:indexPath];
    UILabel *interestLabel = (UILabel *)[cell viewWithTag:1];
    interestLabel.text=((Tag*)(self.interests[indexPath.row])).name;
    cell.layer.borderWidth=1.0;
    cell.layer.borderColor=[UIColor whiteColor].CGColor;

    return cell;
}


@end
