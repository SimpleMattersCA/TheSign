//
//  TagClassRelation.h
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-05-26.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

@import Foundation;
@import CoreData;

#import "SignEntityProtocol.h"

#define TAGCLASSRELATION (@"TagClass")
#define TAGCLASSRELATION_WEIGHT (@"weight")
#define TAGCLASSRELATION_TAG (@"relatedTag")
#define TAGCLASSRELATION_CLASS (@"relatedClass")

@class Tag, TagClass;

@interface TagClassRelation : NSManagedObject <SignEntityProtocol>

@property (nonatomic, retain) NSNumber * weight;
@property (nonatomic, retain) NSString * pObjectID;
@property (nonatomic, retain) Tag *relatedTag;
@property (nonatomic, retain) TagClass *relatedClass;

@end
