//
//  BusinessHeader.h
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-07-26.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BusinessHeader : UITableViewHeaderFooterView
@property (weak, nonatomic) IBOutlet UIImageView *imgLogo;
@property (weak, nonatomic) IBOutlet UIImageView *imgBlurredBack;
@property (weak, nonatomic) IBOutlet UILabel *lbAbout;

@end
