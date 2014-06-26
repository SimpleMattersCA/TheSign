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


@class Like, TagConnection, TagSet, Relevancy;

@interface Tag : NSManagedObject <SignEntityProtocol>

@property (nonatomic, retain) NSNumber * interest;
@property (nonatomic, retain) NSNumber * condition;
@property (nonatomic, retain) NSString * details;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * pObjectID;
@property (nonatomic, retain) NSSet *linkedConnectionsFrom;
@property (nonatomic, retain) Like *linkedLike;
@property (nonatomic, retain) NSSet *linkedTagSets;
@property (nonatomic, retain) NSSet *linkedScores;
@property (nonatomic, retain) NSSet *linkedConnectionsTo;


/**
 Setting likeness score to tag and releated tags by traversing through the TagConnection graph.
 The minimal likeness to be used = 0.1
 */
-(void)processLike:(double)effect AlreadyProcessed:(NSMutableArray**)processedTags;
-(double) calculateRelevancyOnLevel:(NSInteger)depth;

@end


@interface Tag (CoreDataGeneratedAccessors)

- (void)addLinkedConnectionsFromObject:(TagConnection *)value;
- (void)removeLinkedConnectionsFromObject:(TagConnection *)value;
- (void)addLinkedConnectionsFrom:(NSSet *)values;
- (void)removeLinkedConnectionsFrom:(NSSet *)values;

- (void)addLinkedTagSetsObject:(TagSet *)value;
- (void)removeLinkedTagSetsObject:(TagSet *)value;
- (void)addLinkedTagSets:(NSSet *)values;
- (void)removeLinkedTagSets:(NSSet *)values;

- (void)addLinkedScoresObject:(Relevancy *)value;
- (void)removeLinkedScoresObject:(Relevancy *)value;
- (void)addLinkedScores:(NSSet *)values;
- (void)removeLinkedScores:(NSSet *)values;

- (void)addLinkedConnectionsToObject:(TagConnection *)value;
- (void)removeLinkedConnectionsToObject:(TagConnection *)value;
- (void)addLinkedConnectionsTo:(NSSet *)values;
- (void)removeLinkedConnectionsTo:(NSSet *)values;

@end
