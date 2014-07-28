//
//  Common.h
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-07-26.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#ifndef TheSign_Common_h
#define TheSign_Common_h

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


#endif
