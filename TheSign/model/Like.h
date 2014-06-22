//
//  Like.h
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-06-19.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

@import Foundation;
@import CoreData;

@class Tag,User;

@interface Like : NSManagedObject

@property (nonatomic, retain) NSNumber * likeness;
@property (nonatomic, retain) Tag *linkedTag;
@property (nonatomic, retain) User *linkedUser;

+(void)changeLikenessForTag:(Tag*)tag ByValue:(NSNumber*)value;


@end
