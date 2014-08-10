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
@property (nonatomic, retain) NSString * timePeriod;
@property (nonatomic, retain) NSNumber * score;
@property (nonatomic, retain) NSNumber * active;
@property (nonatomic, retain) NSNumber * opened;
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

/**
 Getting the offer that is tied to the iBeacon with specific Major and Minor
 */
+(Featured*) getOfferByMajor:(NSNumber*)major andMinor:(NSNumber*)minor Context:(NSManagedObjectContext*)context;

/**
 Checking if a specific Context Tag is in the Tag's graph for this offer
 */
-(Boolean)checkContextTag:(Tag*) lookupTag;

/**
 Changing relevancy score for this offer by a specific value
 */
-(void)changeRelevancyByValue:(NSNumber*)value;

/**
 Get a special tag(sale, discount, featured etc.) associated with this offer. If it's missing, returns nil.
 */
-(NSString*)getSpecialTagName;

/**
 Getting a category icon
 */
-(UIImage*)getCategoryIcon;

/**
 Getting a location description
 */
-(NSString*)getLocationAddress;

/**
 Getting the name of the business that provides this offer
 */
-(NSString*)getBusinessName;

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
