//
//  Tag.h
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-05-26.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

@import Foundation;
@import CoreData;

#import "SignEntityProtocol.h"

#define TAG (@"Tag")
#define TAG_NAME (@"name")
#define TAG_DETAILS (@"details")
#define TAG_CLASS (@"fromClass")
#define TAG_SET (@"fromSet")

@class TagClassRelation, TagSet;

@interface Tag : NSManagedObject <SignEntityProtocol>

@property (nonatomic, retain) NSString * details;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * pObjectID;
@property (nonatomic, retain) NSSet *tagClasses;
@property (nonatomic, retain) NSSet *tagSets;
@end

@interface Tag (CoreDataGeneratedAccessors)

- (void)addTagClassesObject:(TagClassRelation *)value;
- (void)removeTagClassesObject:(TagClassRelation *)value;
- (void)addTagClasses:(NSSet *)values;
- (void)removeTagClasses:(NSSet *)values;

- (void)addTagSetsObject:(TagSet *)value;
- (void)removeTagSetsObject:(TagSet *)value;
- (void)addTagSets:(NSSet *)values;
- (void)removeTagSets:(NSSet *)values;

@end
