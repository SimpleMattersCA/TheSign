//
//  ViewController.m
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2/20/2014.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import "ViewController.h"
#import "Business.h"
#import "Item.h"
#import "AppDelegate.h"

@import CoreLocation;

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *outputText;
@property (weak, nonatomic) IBOutlet UITextView *outputDescription;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
  

}

-(NSArray*) model
{
    if(!_model)
    {
        _model=((AppDelegate*)[[UIApplication sharedApplication] delegate]).model;
    }
    return _model;
}


//reaction for closest beacon in range
-(void) beaconActivatedWithMajor:(NSNumber*)major
{
    NSInteger i=[major integerValue];
    i=i-1;
    _outputText.text=((Business*)self.model[i]).name;
    _outputDescription.text=((Business*)self.model[i]).welcomeText;
}

-(void) beaconActivatedWithMajor:(NSNumber*)major withMinor:(NSNumber*)minor;
{
    //Beacon specific reaction
}

-(void) beaconLeft
{
    _outputText.text=@"No beacon around";
    _outputDescription.text=@"Nothing to show you, buddy";
}

-(void) updateViewForTitle:(NSString *) title andDescription:(NSString *)description
{
    _outputText.text=title;
    _outputDescription.text=description;

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showInfo1:(UIButton *)sender {
    
    
}


@end
