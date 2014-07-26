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

@interface DealViewController ()  <UIDynamicAnimatorDelegate>
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelDescription;
@property (strong, nonatomic) Featured* deal;
@property (strong, nonatomic) Statistics* stat;
@property (strong) NSNumber* actioned;
@property (weak, nonatomic) IBOutlet UIButton *dislikeButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;

@property (strong, nonatomic) UIImage* blurredBack;

@property (weak, nonatomic) IBOutlet UIView *actualDealView;

@property (strong, nonatomic) UIImageView* background;

@property (strong, nonatomic) UIImage* backgroundImage;


@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UISnapBehavior *ohSnap;
@property (strong, nonatomic) UIAttachmentBehavior *panAttachment;


@property (strong) NSNumber* isRemoving;

@end

BOOL clickedLike=NO;
BOOL clickedDislike=NO;


@implementation DealViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //recreating actualDealView in code to avoid issues with repositioning of the view with enabked Autolayout
    
    
    self.labelTitle.text=self.deal.title;
    self.labelDescription.text=self.deal.details;
    
    self.actualDealView.layer.cornerRadius = 4; // if you like rounded corners
    self.actualDealView.layer.shadowOffset = CGSizeMake(-5, 10);
    self.actualDealView.layer.shadowRadius = 4;
    self.actualDealView.layer.shadowOpacity = 0.2;
    
    UIImageView* imageView = [[UIImageView alloc] initWithImage:self.backgroundImage];
    [self.view addSubview:imageView ];
    [self.view sendSubviewToBack:imageView ];
    self.background=imageView;
    //There is a case of mismatching color palettes between what I set in storyboard and what I set programmatically, until I find the reason I'm gonna set it in code
    self.likeButton.backgroundColor=[UIColor colorWithRed:236.0/255.0 green:115.0/255.0 blue:62.0/255.0 alpha:1];
    self.dislikeButton.backgroundColor=[UIColor colorWithRed:236.0/255.0 green:115.0/255.0 blue:62.0/255.0 alpha:1];
    
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];

    
}







- (void)addMotionEffects {
    UIInterpolatingMotionEffect *horizontalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalMotionEffect.minimumRelativeValue = @(-25);
    horizontalMotionEffect.maximumRelativeValue = @(25);
    
    UIInterpolatingMotionEffect *verticalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalMotionEffect.minimumRelativeValue = @(-25);
    verticalMotionEffect.maximumRelativeValue = @(25);
    
   // UIInterpolatingMotionEffect *shadowEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"layer.shadowOffset" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
   // shadowEffect.minimumRelativeValue = [NSValue valueWithCGSize:CGSizeMake(-10, 5)];
  //  shadowEffect.maximumRelativeValue = [NSValue valueWithCGSize:CGSizeMake(10, 5)];
    
    UIMotionEffectGroup *group = [UIMotionEffectGroup new];
    group.motionEffects = @[horizontalMotionEffect, verticalMotionEffect];//,shadowEffect];
    
    [self.actualDealView addMotionEffect:group];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)dismissView:(id)sender
{
    [self.animator removeBehavior:self.ohSnap];
    
    CGPoint point = CGPointMake(160, 790);
    self.ohSnap=[[UISnapBehavior alloc] initWithItem:self.actualDealView snapToPoint:point];
    self.ohSnap.damping=0.4;
    [self.animator addBehavior:self.ohSnap];
    
    if (![self.presentingViewController.presentedViewController isBeingDismissed])
    {
        if([self.presentingViewController respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
            [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
                if(self.actioned.boolValue==NO)
                    [self.deal processLike:[[Model sharedModel] getLikeValueForAction:LK_None]];
            }];
        }
    }
}



- (IBAction)didPan:(UIPanGestureRecognizer *)sender {
    CGPoint location = [sender locationInView:self.view];
    
    switch (sender.state) {
        case UIGestureRecognizerStateBegan: {
            
            // Cleanup existing behaviors like the "snap" behavior when, after a pan starts, this view
            // gets snapped back into place
            [self.animator removeAllBehaviors];
            
            // Give the view some rotation
            UIDynamicItemBehavior *rotationBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.actualDealView]];
            rotationBehavior.allowsRotation = YES;
            rotationBehavior.angularResistance = 10.0f;
            
            [self.animator addBehavior:rotationBehavior];
            
            // Calculate the offset from the center of the view to use in the attachment behavior
            CGPoint viewCenter = self.actualDealView.center;
            UIOffset centerOffset = UIOffsetMake(location.x - viewCenter.x, location.y - viewCenter.y);
            
            // Attach to the location of the pan in the container view.
            self.panAttachment = [[UIAttachmentBehavior alloc] initWithItem:self.actualDealView
                                                           offsetFromCenter:centerOffset
                                                           attachedToAnchor:location];
            self.panAttachment.damping = 0.7f;
            self.panAttachment.length = 0;
            [self.animator addBehavior:self.panAttachment];
            
            break;
        }
        case UIGestureRecognizerStateChanged: {
            // Now when the finger moves around we just update the anchor point,
            // which will move the view around
            self.panAttachment.anchorPoint = location;
            
            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded: {
            // Not enough velocity to exit the modal, so snap it back into the center of the screen
            [self.animator removeAllBehaviors];
            
            UISnapBehavior *snapIt = [[UISnapBehavior alloc] initWithItem:self.actualDealView snapToPoint:CGPointMake(160, 284)];
            snapIt.damping = 0.7;
            
            [self.animator addBehavior:snapIt];
            
            
            break;
        }
        default:
            break;
    }
}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:
(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

-(void)setDealToShow:(Featured*) deal Statistics:(Statistics*)stat NormalBackground:(UIImage*)nImage BlurredBackground:(UIImage*)bImage
{
    self.deal=deal;
    self.backgroundImage=bImage;
    self.blurredBack=bImage;
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    CGPoint point = CGPointMake(160, 290);
    
    self.ohSnap=[[UISnapBehavior alloc] initWithItem:self.actualDealView snapToPoint:point];
    self.ohSnap.damping=0.8;
    [self.animator addBehavior:self.ohSnap];
   

}

-(void)viewDidAppear:(BOOL)animated
{
    [self addMotionEffects];

    [super viewDidAppear:animated];
    
    /*[UIView transitionWithView:self.view
                      duration:0.1
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        self.background.image = self.blurredBack;
                    }
                    completion:nil];*/
   
    
}

-(void)viewDidDisappear:(BOOL)animated
{
   
    [super viewDidDisappear:animated];
}


- (void)dynamicAnimatorWillResume:(UIDynamicAnimator*)animator
{
}
- (void)dynamicAnimatorDidPause:(UIDynamicAnimator*)animator
{
    if(self.isRemoving && self.isRemoving.boolValue==YES)
        [[NSNotificationCenter defaultCenter] postNotificationName:@"removeBannerNotification"
                                                            object:nil];
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
