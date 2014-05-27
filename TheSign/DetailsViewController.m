//
//  ViewController.m
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2/20/2014.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import "DetailsViewController.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UITextView* outputDescription;
@property (strong,nonatomic) NSString* businessID;
@property (strong,nonatomic) Business* business;

@property (weak, nonatomic) IBOutlet UINavigationItem *navigationBar;

@end

@implementation DetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateViewForBusiness:self.businessID];
}

-(void) updateViewForBusiness:(NSString*)identifier
{
    
    self.business=[Business getByID:identifier];
    _navigationBar.title=self.business.name;
    _outputDescription.text=self.business.welcomeText;

}

-(void) setBusinessToShow:(NSString*) identifier
{
    self.businessID=identifier;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showInfo1:(UIButton *)sender {
    

}


@end
