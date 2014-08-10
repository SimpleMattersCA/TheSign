//
//  TutorialController.m
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-07-21.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import "TutorialController.h"
#import "Model.h"
@interface TutorialController ()

@end

@implementation TutorialController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"";
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    //[self.navigationItem setHidesBackButton:YES animated:NO];
    ((UILabel*)[self.view viewWithTag:1]).layer.cornerRadius=8;

    [[Model sharedModel] updateDBinBackground:YES];
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

@end
