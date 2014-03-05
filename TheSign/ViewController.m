//
//  ViewController.m
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2/20/2014.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import "ViewController.h"
#import "InfoModel.h"
#import "PopulateView.h"
#import "CoreBluetooth/CBCentralManager.h"
#import "CoreBluetooth/CBPeripheral.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *outputText;
@property (weak, nonatomic) IBOutlet UITextView *outputDescription;

@end

@implementation ViewController

CBCentralManager *man;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    man =[[CBCentralManager alloc] initWithDelegate:self queue:nil options:nil];
    [man scanForPeripheralsWithServices:nil options:nil];
}

- (void)centralManager:(CBCentralManager *)central
 didDiscoverPeripheral:(CBPeripheral *)peripheral
     advertisementData:(NSDictionary *)advertisementData
                  RSSI:(NSNumber *)RSSI {
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = nil;
    localNotification.alertBody = [@"Found: " stringByAppendingString:peripheral.identifier.UUIDString];
    
  //  peripheral.identifier;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    // _outputDescription.text=peripheral.name;
    //NSLog(@"Discovered %@", peripheral.name);
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if(central.state==CBCentralManagerStatePoweredOn)
    {
        
        
        //Now do your scanning and retrievals
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showInfo1:(UIButton *)sender {
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:5];
    
    localNotification.alertBody = @"test";
     localNotification.alertAction=@"YEeeah!!";
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
   // if(man.state==CBCentralManagerStatePoweredOn)
   // {
   //     [man scanForPeripheralsWithServices:nil options:nil];
  //  }
  /*  PopulateView *data=  [[PopulateView alloc]init];
    InfoModel *model=[[InfoModel alloc] init];
    
    model=[data getTextByID:0];
    
    _outputText.text=model.title;
    _outputDescription.text=model.description;*/
    
}
/*
- (IBAction)showInfo2:(id)sender {
    PopulateView *data=  [[PopulateView alloc]init];
    InfoModel *model=[[InfoModel alloc] init];
    
    model=[data getTextByID:1];
    
    _outputText.text=model.title;
    _outputDescription.text=model.description;
}*/





@end
