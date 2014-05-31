//
//  BusinessInfoCell.h
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-05-29.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BusinessInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *businessLogo;
@property (weak, nonatomic) IBOutlet UILabel *businessTitle;
@property (weak, nonatomic) IBOutlet UILabel *businessDescription;

@end
