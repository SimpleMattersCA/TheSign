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
    // Do any additional setup after loading the view.
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
        if(!error)
        {
            if (!user)
            {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
            }
            else
            {
                [self.spinner startAnimating];
                [User CreateUserProfile:user CompletionDelegate:self];

            //    UINavigationController *navigation=(UINavigationController*)self.view.window.rootViewController;
                //FeedController *feed=[navigation.storyboard instantiateViewControllerWithIdentifier:@"FeedView"];
               // [navigation pushViewController:feed animated:YES];
            }
        }
        else
        {
            
            NSLog(@"%@",error.localizedDescription);
            NSLog(@"%@",error.localizedFailureReason);
            for(NSString *key in [error.userInfo allKeys])
                NSLog(@"%@",[error.userInfo objectForKey:key]);
        }
    }];
}



#pragma mark - PFLogInViewControllerDelegate


// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    
}


-(void)finishSetup
{
    [self.spinner stopAnimating];
    [self performSegueWithIdentifier:@"ProfileAfterRegistration" sender:self];
}

@end
