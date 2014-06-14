//
//  Featured.h
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-06-13.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SignEntityProtocol.h"

@class Business, Statistics, TagSet;

@interface Featured : NSManagedObject <SignEntityProtocol>

@property (nonatomic, retain) NSNumber * active;
@property (nonatomic, retain) NSString * details;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSNumber * major;
@property (nonatomic, retain) NSNumber * minor;
@property (nonatomic, retain) NSString * pObjectID;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * videoUrl;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *featuredTagSets;
@property (nonatomic, retain) Business *parentBusiness;
@property (nonatomic, retain) NSSet *records;


+(NSArray*) getOffersByMajor:(NSNumber*)major andMinor:(NSNumber*)minor;


@end

@interface Featured (CoreDataGeneratedAccessors)

- (void)addFeaturedTagSetsObject:(TagSet *)value;
- (void)removeFeaturedTagSetsObject:(TagSet *)value;
- (void)addFeaturedTagSets:(NSSet *)values;
- (void)removeFeaturedTagSets:(NSSet *)values;

- (void)addRecordsObject:(Statistics *)value;
- (void)removeRecordsObject:(Statistics *)value;
- (void)addRecords:(NSSet *)values;
- (void)removeRecords:(NSSet *)values;

@end
