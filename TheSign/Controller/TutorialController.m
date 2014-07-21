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
    [[Model sharedModel] updateDBinBackground:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated
{
    UINavigationController *navigation=(UINavigationController*)self.view.window.rootViewController;
    [navigation.navigationItem setHidesBackButton:YES];
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
