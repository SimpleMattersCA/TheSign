//
//  Business.h
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-03-01.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Item.h"

@interface Business : NSObject


@property (nonatomic) NSString *name;
@property (nonatomic) NSString *welcomeText;
@property (nonatomic) NSArray *beacons;
@property (nonatomic) NSArray *items;
@property (nonatomic) NSString *regionUUID;

+(Business*)initWithName:(NSString*)name
     andWelcome:(NSString*)welcome;

@end
