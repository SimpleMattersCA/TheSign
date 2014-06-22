//
//  Tag.h
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-06-19.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

@import Foundation;
@import CoreData;
#import "SignEntityProtocol.h"


@class Like, TagConnection, TagSet;

@interface Tag : NSManagedObject <SignEntityProtocol>

@property (nonatomic, retain) NSNumber * interest;
@property (nonatomic, retain) NSString * details;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * pObjectID;
@property (nonatomic, retain) NSSet *linkedConnections1;
@property (nonatomic, retain) Like *linkedLike;
@property (nonatomic, retain) NSSet *linkedTagSets;
@property (nonatomic, retain) NSSet *linkedConnections2;
@end

@interface Tag (CoreDataGeneratedAccessors)

- (void)addLinkedConnections1Object:(TagConnection *)value;
- (void)removeLinkedConnections1Object:(TagConnection *)value;
- (void)addLinkedConnections1:(NSSet *)values;
- (void)removeLinkedConnections1:(NSSet *)values;

- (void)addLinkedTagSetsObject:(TagSet *)value;
- (void)removeLinkedTagSetsObject:(TagSet *)value;
- (void)addLinkedTagSets:(NSSet *)values;
- (void)removeLinkedTagSets:(NSSet *)values;

- (void)addLinkedConnections2Object:(TagConnection *)value;
- (void)removeLinkedConnections2Object:(TagConnection *)value;
- (void)addLinkedConnections2:(NSSet *)values;
- (void)removeLinkedConnections2:(NSSet *)values;

@end
