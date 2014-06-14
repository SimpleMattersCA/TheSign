//
//  Tag.h
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-06-13.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import "SignEntityProtocol.h"

@import Foundation;
@import CoreData;

@class TagConnection, TagSet;

@interface Tag : NSManagedObject <SignEntityProtocol>

@property (nonatomic, retain) NSString * details;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * pObjectID;
@property (nonatomic, retain) NSSet *controlConnection;
@property (nonatomic, retain) NSSet *tagSets;
@property (nonatomic, retain) NSSet *relatedConnection;


@end



@interface Tag (CoreDataGeneratedAccessors)

- (void)addControlConnectionObject:(TagConnection *)value;
- (void)removeControlConnectionObject:(TagConnection *)value;
- (void)addControlConnection:(NSSet *)values;
- (void)removeControlConnection:(NSSet *)values;

- (void)addTagSetsObject:(TagSet *)value;
- (void)removeTagSetsObject:(TagSet *)value;
- (void)addTagSets:(NSSet *)values;
- (void)removeTagSets:(NSSet *)values;

- (void)addRelatedConnectionObject:(TagConnection *)value;
- (void)removeRelatedConnectionObject:(TagConnection *)value;
- (void)addRelatedConnection:(NSSet *)values;
- (void)removeRelatedConnection:(NSSet *)values;

@end
