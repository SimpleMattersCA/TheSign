//
//  Business.h
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-06-19.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

@import Foundation;
@import CoreData;
#import "SignEntityProtocol.h"


@class DiscoveredBusiness, Featured, Link,PFObject,CLLocation,Location;

@interface Business : NSManagedObject <SignEntityProtocol>

@property (nonatomic, retain) NSString * businessType;
@property (nonatomic, retain) NSData * logo;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * pObjectID;
@property (nonatomic, retain) NSNumber * uid;
@property (nonatomic, retain) NSString * welcomeText;
@property (nonatomic, retain) DiscoveredBusiness *linkedDiscovery;
@property (nonatomic, retain) NSSet *linkedOffers;
@property (nonatomic, retain) NSSet *linkedLinks;
@property (nonatomic, retain) NSSet *linkedLocations;

+(NSArray*) getBusinessesByType:(NSString*)type;
+(NSArray*) getTypes;
+(Location*)getClosestBusinessToLocation:(CLLocation*)location;

-(NSSet*) getActiveOffers;

+(Business*) getBusinessByUID:(NSNumber*)identifier;




@end

@interface Business (CoreDataGeneratedAccessors)

- (void)addLinkedOffersObject:(Featured *)value;
- (void)removeLinkedOffersObject:(Featured *)value;
- (void)addLinkedOffers:(NSSet *)values;
- (void)removeLinkedOffers:(NSSet *)values;

- (void)addLinkedLocationsObject:(Location *)value;
- (void)removeLinkedLocationsObject:(Location *)value;
- (void)addLinkedLocations:(NSSet *)values;
- (void)removeLinkedLocations:(NSSet *)values;

- (void)addLinkedLinksObject:(Link *)value;
- (void)removeLinkedLinksObject:(Link *)value;
- (void)addLinkedLinks:(NSSet *)values;
- (void)removeLinkedLinks:(NSSet *)values;

@end
