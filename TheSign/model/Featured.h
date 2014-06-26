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

@class Business, Statistics, TagSet,Relevancy;

@interface Featured : NSManagedObject <SignEntityProtocol>

@property (nonatomic, retain) NSNumber * active;
@property (nonatomic, retain) NSString * details;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSNumber * major;
@property (nonatomic, retain) NSNumber * minor;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * pObjectID;
@property (nonatomic, retain) NSString * about;
@property (nonatomic, retain) NSSet *linkedTagSets;
@property (nonatomic, retain) Business *linkedBusiness;
@property (nonatomic, retain) Relevancy *linkedScore;

@property (nonatomic, retain) NSSet *linkedStats;

+(NSArray*) getOffersByMajor:(NSNumber*)major andMinor:(NSNumber*)minor;

-(void) processLike:(double)effect;


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
