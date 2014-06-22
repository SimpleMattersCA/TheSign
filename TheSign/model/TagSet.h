//
//  TagSet.h
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-06-19.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

@import Foundation;
@import CoreData;
#import "SignEntityProtocol.h"


@class Featured, Tag;

@interface TagSet : NSManagedObject <SignEntityProtocol>

@property (nonatomic, retain) NSString * pObjectID;
@property (nonatomic, retain) NSNumber * weight;
@property (nonatomic, retain) Featured *linkedOffer;
@property (nonatomic, retain) Tag *linkedTag;

@end
