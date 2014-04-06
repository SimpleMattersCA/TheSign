//
//  FeaturedDealCell.h
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-03-31.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeaturedDealCell : UICollectionViewCell

@property (nonatomic, strong) NSString *dealText;
@property (nonatomic, strong) UIColor *dealColor;
@property (nonatomic, strong) NSNumber *order;

-(void)showDealInfo;

@end
