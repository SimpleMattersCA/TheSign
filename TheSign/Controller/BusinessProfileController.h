//
//  BusinessProfileController.h
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-07-17.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Business;

@interface BusinessProfileController : UIViewController <UITableViewDelegate, UITableViewDataSource>



-(void)setBusinessToShow:(Business*)business;

@end
