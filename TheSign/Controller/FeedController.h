//
//  FeedController.h
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-06-17.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+SignExtension.h"

@class Featured,Statistics;

@interface FeedController : UITableViewController

-(void) showDealAfterLoad:(Featured*)offer Statistics:(Statistics*)stat;

@end
