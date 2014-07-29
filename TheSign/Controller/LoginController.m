//
//  LoginController.m
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-06-18.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import "LoginController.h"
#import <QuartzCore/QuartzCore.h>
#import "User.h"
#import "FeedController.h"
#import "Model.h"
#import "AppDelegate.h"
#import "ProfileController.h"
@interface LoginController ()

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;



@end

@implementation LoginController

bool fbReady=NO;
bool dbReady=NO;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
            }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [(AppDelegate*)[[UIApplication sharedApplication] delegate] startLocationMonitoring];
        }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationItem.title=@"Login";
    ((UILabel*)[self.view viewWithTag:1]).layer.cornerRadius=8;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dbUpdated) name:@"dbUpdated" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fbUpdated) name:@"facebookDataDownloaded" object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    UINavigationController *navigation=(UINavigationController*)self.view.window.rootViewController;
    [navigation.navigationItem setHidesBackButton:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"ProfileAfterRegistration"] && [segue.destinationViewController isKindOfClass:[ProfileController class]])
    {
        ProfileController * controller = segue.destinationViewController ;
        controller.afterRegistration=@(YES);
    }

    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}




- (IBAction)FacebookLoginAction:(id)sender {
    
    [PFFacebookUtils logInWithPermissions:@[@"public_profile", @"user_friends"] block:^(PFUser *user, NSError *error) {
        [self.spinner startAnimating];
        if(!error)
        {
            if (!user)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"facebookDataDownloaded"
                                                                    object:nil];
                //NSLog(@"Uh oh. The user cancelled the Facebook login.");
            }
            else
            {
                [User CreateUserProfile:user];
            }
        }
        else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"facebookDataDownloaded"
                                                                object:nil];

            /*NSLog(@"%@",error.localizedDescription);
            NSLog(@"%@",error.localizedFailureReason);
            for(NSString *key in [error.userInfo allKeys])
                NSLog(@"%@",[error.userInfo objectForKey:key]);*/
        }
    }];
}



#pragma mark - PFLogInViewControllerDelegate


// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    
}

-(void)dbUpdated
{
  // NSLog(@"DB done");
    dbReady=YES;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"dbUpdated" object:nil];
    if(fbReady)
    {
        [self.spinner stopAnimating];
        [self performSelectorOnMainThread:@selector(goToProfile) withObject:nil waitUntilDone:NO];
    }
}
-(void)fbUpdated
{
   // NSLog(@"FB done");

    fbReady=YES;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"facebookDataDownloaded" object:nil];
    if(dbReady)
    {
        [self.spinner stopAnimating];
        [self performSelectorOnMainThread:@selector(goToProfile) withObject:nil waitUntilDone:NO];
    }
}

-(void)goToProfile
{
    [self performSegueWithIdentifier:@"ProfileAfterRegistration" sender:self];
}


@end
