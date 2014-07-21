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
        [(AppDelegate*)[[UIApplication sharedApplication] delegate] startLocationMonitoring];
        
        // Open session with public_profile (required) and user_birthday read permissions
        /*[FBSession openActiveSessionWithReadPermissions:@[@"public_profile", @"user_friends"]
                                           allowLoginUI:YES
                                      completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             __block NSString *alertText;
             __block NSString *alertTitle;
             if (!error){
                 // If the session was opened successfully
                 if (state == FBSessionStateOpen){
                     // Your code here
                     
                 } else {
                     // There was an error, handle it
                     if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
                         // Error requires people using an app to make an action outside of the app to recover
                         // The SDK will provide an error message that we have to show the user
                         alertTitle = @"Something went wrong";
                         alertText = [FBErrorUtility userMessageForError:error];
                         [[[UIAlertView alloc] initWithTitle:alertTitle
                                                     message:alertText
                                                    delegate:self
                                           cancelButtonTitle:@"OK!"
                                           otherButtonTitles:nil] show];
                         
                     } else {
                         // If the user cancelled login
                         if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                             alertTitle = @"Login cancelled";
                             alertText = @"Your birthday will not be entered in our calendar because you didn't grant the permission.";
                             [[[UIAlertView alloc] initWithTitle:alertTitle
                                                         message:alertText
                                                        delegate:self
                                               cancelButtonTitle:@"OK!"
                                               otherButtonTitles:nil] show];
                             
                         } else {
                             // For simplicity, in this sample, for all other errors we show a generic message
                             // You can read more about how to handle other errors in our Handling errors guide
                             // https://developers.facebook.com/docs/ios/errors/
                             NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"]
                                                                objectForKey:@"body"]
                                                               objectForKey:@"error"];
                             alertTitle = @"Something went wrong";
                             alertText = [NSString stringWithFormat:@"Please retry. \n If the problem persists contact us and mention this error code: %@",
                                          [errorInformation objectForKey:@"message"]];
                             [[[UIAlertView alloc] initWithTitle:alertTitle
                                                         message:alertText
                                                        delegate:self
                                               cancelButtonTitle:@"OK!"
                                               otherButtonTitles:nil] show];
                         }
                     }
                 }
             }
         }];
        */
        
        
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
                [User createUserFromParse:user];
                [[Model sharedModel] saveContext:[Model sharedModel].managedObjectContext];
                
                UINavigationController *navigation=(UINavigationController*)self.view.window.rootViewController;
                FeedController *feed=[navigation.storyboard instantiateViewControllerWithIdentifier:@"FeedView"];
                [navigation pushViewController:feed animated:YES];
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

// Sent to the delegate when the log in screen is dismissed.
/*- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    NSLog(@"User dismissed the logInViewController");
}*/

// Sent to the delegate when the log in attempt fails.
/*- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    NSLog(@"%@",error.localizedDescription);
    NSLog(@"%@",error.localizedFailureReason);

    NSLog(@"%@",error.debugDescription);
    
    NSLog(@"%@",error.localizedRecoverySuggestion);
    for(NSString *key in [error.userInfo allKeys]) {
        NSLog(@"%@",[error.userInfo objectForKey:key]);
    }


}*/



@end
