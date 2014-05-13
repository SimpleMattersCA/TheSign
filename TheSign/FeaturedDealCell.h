//
//  FeaturedDealCell.h
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-03-31.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model.h"

@protocol ScrollingCellDelegate;

@interface FeaturedDealCell : UICollectionViewCell

@property (nonatomic) Boolean isRight;
@property (nonatomic, strong) Featured* deal;
@property (nonatomic,weak) id<ScrollingCellDelegate> delegate;


-(void)showDealInfo;

@end

@protocol ScrollingCellDelegate <NSObject>
-(void)scrollingCellDidBeginPulling:(FeaturedDealCell *)cell;
-(void)scrollingCell:(FeaturedDealCell *)cell didChangePullOffset:(CGFloat)offset;
-(void)scrollingCellDidEndPulling:(FeaturedDealCell *)cell;
@end




