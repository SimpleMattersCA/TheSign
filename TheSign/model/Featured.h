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

@class Business, Statistics, TagSet,Relevancy, Context;

@interface Featured : NSManagedObject <SignEntityProtocol>

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * fullName;
@property (nonatomic, retain) NSString * welcomeText;
@property (nonatomic, retain) NSString * details;

@property (nonatomic, retain) NSNumber * active;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSNumber * major;
@property (nonatomic, retain) NSNumber * minor;
@property (nonatomic, retain) NSString * pObjectID;
@property (nonatomic, retain) NSSet *linkedTagSets;
@property (nonatomic, retain) Business *linkedBusiness;
@property (nonatomic, retain) Relevancy *linkedScore;

@property (nonatomic, retain) NSSet *linkedStats;
@property (nonatomic, retain) NSSet *linkedContexts;


///Getting the offer that is tied to the beacon. If no such offer, returns nil
+(Featured*) getOfferByMajor:(NSNumber*)major andMinor:(NSNumber*)minor;

-(void) processLike:(double)effect;

-(void)updateContextTagList;

-(NSSet*)findContextTags:(NSSet*) lookupTags;
-(NSSet*)checkContextTags:(NSSet*) lookupTags;


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

- (void)addLinkedContextsObject:(Context *)value;
- (void)removeLinkedContextsObject:(Context *)value;
- (void)addLinkedContexts:(NSSet *)values;
- (void)removeLinkedContexts:(NSSet *)values;

@end
