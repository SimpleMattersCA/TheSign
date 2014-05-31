//
//  ViewController.m
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2/20/2014.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import "DetailsViewController.h"
#import "Featured.h"

@interface DetailsViewController ()

@property (strong,nonatomic) Featured* deal;

@property (weak, nonatomic) IBOutlet UIImageView *dealImage;
@property (weak, nonatomic) IBOutlet UITextView* outputDescription;
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationBar;

@end

@implementation DetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateViewContent];
}

-(void) prepareDealToShow:(Featured*) deal
{
    self.deal=deal;
}

-(void) updateViewContent
{
    self.dealImage.image=[UIImage imageWithData:self.deal.image];
    self.outputDescription.text=self.deal.details;
    self.navigationBar.title=self.deal.title;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showInfo1:(UIButton *)sender {
    

}


@end
