//
//  DealViewController.m
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-07-16.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import "DealViewController.h"
#import "Featured.h"
#import "Statistics.h"
#import "Model.h"

@interface DealViewController ()
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelDescription;
@property (strong, nonatomic) Featured* deal;
@property (strong, nonatomic) Statistics* stat;
@property (strong) NSNumber* actioned;
@property (weak, nonatomic) IBOutlet UIButton *dislikeButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;


@property (strong, nonatomic) UIImage* backgroundImage;
@end

BOOL clickedLike=NO;
BOOL clickedDislike=NO;


@implementation DealViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"%@",self.deal.title);
    self.labelTitle.text=self.deal.title;
    self.labelDescription.text=self.deal.details;
    UIImageView* imageView = [[UIImageView alloc] initWithImage:self.backgroundImage];
    
    [self.view addSubview:imageView ];
    [self.view sendSubviewToBack:imageView ];
    
    
}
- (IBAction)actionButton:(id)sender {
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertBody =@"Mary's Cafe: So hot and sunny outside! Come in for a refreshing Iced Tea";
    notification.fireDate=[[NSDate date] dateByAddingTimeInterval:10];
    
    

    [[UIApplication sharedApplication] scheduleLocalNotification:notification];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)dismissView:(id)sender {
    if (![self.presentedViewController isBeingDismissed])
    {
        [self dismissViewControllerAnimated:YES completion:^{
            if(self.actioned.boolValue==NO)
                [self.deal processLike:[[Model sharedModel] getLikeValueForAction:LK_None]];
        }];
    }
}

-(void)setDealToShow:(Featured*) deal Statistics:(Statistics*)stat BackgroundImage:(UIImage*)image
{
    self.deal=deal;
    self.backgroundImage=image;
    if(stat)
        self.stat=stat;
    else
        self.stat=[[Model sharedModel] recordStatisticsFromFeed];

}
- (IBAction)actionLike:(id)sender {
    
    //if hasn't clicked before
    if(self.dislikeButton.enabled)
    {
        self.actioned=@(YES);
        [self.deal processLike:[[Model sharedModel] getLikeValueForAction:LK_Like]];
        self.stat.liked=@(LK_Like);
        self.dislikeButton.enabled=NO;
        self.dislikeButton.backgroundColor=[UIColor grayColor];
    }
    //if clicked before
    else
    {
        [self.deal processLike:[[Model sharedModel] getLikeValueForAction:LK_UnLike]];
        self.stat.liked=@(0);
        self.dislikeButton.enabled=YES;
        self.dislikeButton.backgroundColor=[UIColor colorWithRed:236.0/255.0 green:115.0/255.0 blue:62.0/255.0 alpha:1];
    }
    
}
- (IBAction)actionDislike:(id)sender {
    
    //if hasn't clicked before
    if(self.likeButton.enabled)
    {
        self.actioned=@(YES);
        [self.deal processLike:[[Model sharedModel] getLikeValueForAction:LK_Dislike]];
        self.stat.liked=@(LK_Dislike);
        self.likeButton.enabled=NO;
        self.likeButton.backgroundColor=[UIColor grayColor];
    }
    //if clickedbefore
    else
    {
        [self.deal processLike:[[Model sharedModel] getLikeValueForAction:LK_UnDislike]];
        self.stat.liked=@(0);
        self.likeButton.enabled=YES;
        self.likeButton.backgroundColor=[UIColor colorWithRed:236.0/255.0 green:115.0/255.0 blue:62.0/255.0 alpha:1];
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
