//
//  SignNotificationBanner.m
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-07-25.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import "SignNotificationBanner.h"
#import "UIViewController+SignExtension.h"
#import "Featured.h"
@interface SignNotificationBanner ()  <UIDynamicAnimatorDelegate>

@property (nonatomic, strong) UIDynamicAnimator *animator;
//! Reference to the previously applied snap behavior.
@property (nonatomic, strong) UISnapBehavior *ohSnap;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *userTap;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *userSwipe;
@property (weak, nonatomic) IBOutlet UILabel *notificationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgBackground;

@property (strong) NSNumber* isRemoving;

@end

@implementation SignNotificationBanner

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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
    [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(hideBanner) userInfo:nil repeats:YES];
    self.view.layer.cornerRadius=8;
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view.superview];
    self.isRemoving=@(NO);
    
    self.notificationLabel.text=self.notificationText;
    
    self.imgBackground.image=self.blurredBackground;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)swipeToDismiss:(id)sender
{
    [self hideBanner];
}

- (IBAction)tapAction:(id)sender
{
    [self.controller showModalDeal:self.deal Statistics:self.stat];
    [self hideBanner];
}



+(CGSize)getViewSize
{
    return CGSizeMake(320, 70);
}

-(void)viewWillAppear:(BOOL)animated
{
    CGSize size=[SignNotificationBanner getViewSize];
    self.view.frame=CGRectMake(0, (-1)*size.height, size.width, size.height);
    
    [super viewWillAppear:animated];
}


-(void)viewDidAppear:(BOOL)animated
{
    
    
    [super viewDidAppear:animated];
    CGSize size=[SignNotificationBanner getViewSize];
    CGPoint point = CGPointMake(size.width/2, size.height/2);
    
    self.ohSnap=[[UISnapBehavior alloc] initWithItem:self.view snapToPoint:point];
    self.ohSnap.damping=0.5;
    [self.animator addBehavior:self.ohSnap];

}

-(void) hideBanner
{
    CGSize size=[SignNotificationBanner getViewSize];
    // Remove the previous behavior.
    [self.animator removeBehavior:self.ohSnap];
    CGPoint point=CGPointMake(size.width/2, (-1)*size.height);
    [self.animator addBehavior:[[UISnapBehavior alloc] initWithItem:self.view snapToPoint:point]];
    
    self.isRemoving=@(YES);
    
}

- (void)dynamicAnimatorWillResume:(UIDynamicAnimator*)animator
{
}
- (void)dynamicAnimatorDidPause:(UIDynamicAnimator*)animator
{
    if(self.isRemoving)
    {
        if(self.isRemoving.boolValue==YES)
            [[NSNotificationCenter defaultCenter] postNotificationName:@"removeBannerNotification"
                                                            object:nil];
        else
        {
            [self.view addGestureRecognizer:self.userTap];
            [self.view addGestureRecognizer:self.userSwipe];

        }
    }
}
@end
