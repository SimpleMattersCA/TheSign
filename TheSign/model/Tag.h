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

@class TagClassRelation, TagSet;

@interface Tag : NSManagedObject <SignEntityProtocol>

@property (nonatomic, retain) NSString * details;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * pObjectID;
@property (nonatomic, retain) NSSet *tagClasses;
@property (nonatomic, retain) NSSet *tagSets;

+(NSString*) colName;
+(NSString*) colDetails;

+(NSString*) pName;
+(NSString*) pDetails;

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
