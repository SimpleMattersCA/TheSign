//
//  FeaturedViewHeaderView.h
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-04-15.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

@import UIKit;
#import "Model.h"

@class Business;

@interface FeaturedViewHeader : UICollectionReusableView

@property (nonatomic, strong) Business* business;

-(void) showBusinessInfo;


@end
