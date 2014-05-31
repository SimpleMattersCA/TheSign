//
//  DealListController.h
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-05-30.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Business;

@interface DealListController : UITableViewController

-(void) prepareDealsForBusiness:(Business*) business;

@end
