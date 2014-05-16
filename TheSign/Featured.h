//
//  Featured.h
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-05-15.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Business, TagSet;

@interface Featured : NSManagedObject

@property (nonatomic, retain) NSString * details;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * videoUrl;
@property (nonatomic, retain) NSNumber * major;
@property (nonatomic, retain) NSNumber * minor;
@property (nonatomic, retain) Business *parentBusiness;
@property (nonatomic, retain) TagSet *featuredTagSet;

@end
