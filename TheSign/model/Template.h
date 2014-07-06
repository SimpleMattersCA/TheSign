//
//  Template.h
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-07-05.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

@import Foundation;
@import CoreData;
#import "SignEntityProtocol.h"

@class Tag;

@interface Template : NSManagedObject <SignEntityProtocol>
@property (nonatomic, retain) NSString * messageText;
@property (nonatomic, retain) Tag *linkedContextTag;
@property (nonatomic, retain) Tag *linkedCategoryTag;
@property (nonatomic, retain) NSString * pObjectID;

@end
