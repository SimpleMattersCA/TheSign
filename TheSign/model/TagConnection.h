//
//  TagConnection.h
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-06-19.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

@import Foundation;
@import CoreData;
#import "SignEntityProtocol.h"


@class Tag;

@interface TagConnection : NSManagedObject <SignEntityProtocol>

@property (nonatomic, retain) NSString * pObjectID;
@property (nonatomic, retain) NSNumber * weight;
@property (nonatomic, retain) Tag *linkedTagFrom;
@property (nonatomic, retain) Tag *linkedTagTo;

@end
