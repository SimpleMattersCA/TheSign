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

#define TAGCLASS (@"TagClass")
#define TAGCLASS_NAME (@"name")
#define TAGCLASS_CONTROLCLASS (@"controllClassConnection")
#define TAGCLASS_RELATEDCLASS (@"relatedClassConnection")
#define TAGCLASS_TAGS (@"tagsInClass")

@class Tag, TagClass;

@interface TagClassRelation : NSManagedObject <SignEntityProtocol>

@property (nonatomic, retain) NSNumber * weight;
@property (nonatomic, retain) NSString * pObjectID;
@property (nonatomic, retain) Tag *relatedTag;
@property (nonatomic, retain) TagClass *relatedClass;

@end
