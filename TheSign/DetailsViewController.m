//
//  ViewController.m
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2/20/2014.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import "DetailsViewController.h"
#import "Business.h"
#import "Item.h"
#import "AppDelegate.h"

@import CoreLocation;

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel* outputText;
@property (weak, nonatomic) IBOutlet UITextView* outputDescription;
@property (strong,nonatomic) NSNumber* businessID;

@property (weak, nonatomic) IBOutlet UINavigationItem *navigationBar;

@end

@implementation DetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateViewForBusiness:self.businessID];
}

-(NSArray*) model
{
    if(!_model)
    {
        _model=((AppDelegate*)[[UIApplication sharedApplication] delegate]).model;
    }
    return _model;
}

-(void) updateViewForBusiness:(NSNumber*)identifier
{
    NSInteger i=[identifier integerValue];
  //  _outputText.text=((Business*)self.model[i]).name;
    _navigationBar.title=((Business*)self.model[i]).name;
    _outputDescription.text=((Business*)self.model[i]).welcomeText;

}

-(void) setBusinessToShow:(NSNumber*) identifier
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


//reaction for closest beacon in range
-(void) beaconActivatedWithMajor:(NSNumber*)major
{
}

-(void) beaconActivatedWithMajor:(NSNumber*)major withMinor:(NSNumber*)minor;
{
    //Beacon specific reaction
}

-(void) beaconLeft
{
    
}


@end
