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
@interface LoginController ()



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
        self.delegate=self;
        self.facebookPermissions = @[@"public_profile,user_friends"];
        self.fields = /* PFLogInFieldsTwitter |*/ PFLogInFieldsFacebook  | PFLogInFieldsDismissButton;
        [self.view setBackgroundColor:[UIColor colorWithRed:(72.0/255.0) green:(82.0/255.0) blue:(84.0/255.0) alpha:1]];
        // Add your subviews here
        // self.contentView for content
        // self.backgroundView for the cell background
        // self.selectedBackgroundView for the selected cell background
        
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];

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

#pragma mark - PFLogInViewControllerDelegate


// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:NULL];
    [User createUserFromParse:user];
    UINavigationController *navigation=(UINavigationController*)self.view.window.rootViewController;
    FeedController *feed=[navigation.storyboard instantiateViewControllerWithIdentifier:@"FeedView"];
    [navigation pushViewController:feed animated:YES];

}

// Sent to the delegate when the log in screen is dismissed.
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    NSLog(@"User dismissed the logInViewController");
}

// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    NSLog(@"Failed to log in...");
}



@end
