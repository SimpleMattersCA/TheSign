//
//  TagSet.h
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-05-26.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

@import Foundation;
@import CoreData;

#import "SignEntityProtocol.h"

#define TAGSET (@"TagSet")
#define TAGSET_WEIGHT (@"weight")

@class Featured, Tag;

@interface TagSet : NSManagedObject

@property (nonatomic, retain) NSNumber * weight;
@property (nonatomic, retain) NSString * pObjectID;
@property (nonatomic, retain) Featured *taggedFeature;
@property (nonatomic, retain) Tag *tagInSet;

@end
