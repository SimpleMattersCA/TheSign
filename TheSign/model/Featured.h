//
//  Featured.h
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-06-19.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

@import Foundation;
@import CoreData;
#import "SignEntityProtocol.h"

@class Business, Statistics, TagSet,Relevancy, Context,Tag;

@interface Featured : NSManagedObject <SignEntityProtocol>

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * fullName;
@property (nonatomic, retain) NSString * welcomeText;
@property (nonatomic, retain) NSString * details;
@property (nonatomic, retain) NSNumber * score;
@property (nonatomic, retain) NSNumber * active;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSNumber * major;
@property (nonatomic, retain) NSNumber * minor;
@property (nonatomic, retain) NSString * pObjectID;
@property (nonatomic, retain) Business *linkedBusiness;

@property (nonatomic, retain) NSSet *linkedStats;
@property (nonatomic, retain) NSSet *linkedTagSets;


/**
 Transfering the faiding like through the graph
 */
-(void) processLike:(double)effect;

+(Featured*) getOfferByMajor:(NSNumber*)major andMinor:(NSNumber*)minor;

-(Boolean)checkContextTag:(Tag*) lookupTag;

-(void)changeRelevancyByValue:(NSNumber*)value;

@end

@interface Featured (CoreDataGeneratedAccessors)

- (void)addLinkedTagSetsObject:(TagSet *)value;
- (void)removeLinkedTagSetsObject:(TagSet *)value;
- (void)addLinkedTagSets:(NSSet *)values;
- (void)removeLinkedTagSets:(NSSet *)values;

- (void)addLinkedStatsObject:(Statistics *)value;
- (void)removeLinkedStatsObject:(Statistics *)value;
- (void)addLinkedStats:(NSSet *)values;
- (void)removeLinkedStats:(NSSet *)values;


@end
