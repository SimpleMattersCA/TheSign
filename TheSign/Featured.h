//
//  Featured.h
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-03-29.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Business;

@interface Featured : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * details;
@property (nonatomic, retain) NSString * videoUrl;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) Business *featuredBy;

@end
