//
//  ProfileController.h
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-06-18.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+SignExtension.h"

@interface ProfileController : UIViewController <UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong) NSNumber* afterRegistration;

@end
