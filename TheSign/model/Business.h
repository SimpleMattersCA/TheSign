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


@class DiscoveredBusiness, Featured, Link,PFObject,CLLocation,Location,BusinessCategory;

@interface Business : NSManagedObject <SignEntityProtocol>

@property (nonatomic, retain) NSData * blurredBack;
@property (nonatomic, retain) NSData * logo;
@property (nonatomic, retain) NSString * about;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * pObjectID;
@property (nonatomic, retain) NSNumber * uid;
@property (nonatomic, retain) NSString * welcomeText;
@property (nonatomic, retain) NSNumber * discovered;
@property (nonatomic, retain) NSDate * discoveryDate;
@property (nonatomic, retain) NSSet *linkedOffers;
@property (nonatomic, retain) NSSet *linkedLinks;
@property (nonatomic, retain) NSSet *linkedLocations;
@property (nonatomic, retain) BusinessCategory *linkedCategory;


/**
 Get the Location object that corresponds to this Business that is closest to a specific geographical location
 */
+(Location*)getClosestBusinessToLocation:(CLLocation*)location Context:(NSManagedObjectContext*)context;

/**
 Get the list of active offers
 */
-(NSSet*) getActiveOffers;


/**
 Get the Business object by UID(iBeacon's major) identifier
 */
+(Business*) getBusinessByUID:(NSNumber*)identifier Context:(NSManagedObjectContext*)context;

/**
 Get all the businesses
 */
+(NSArray*) getBusinessesForContext:(NSManagedObjectContext*)context;

/**
 Add business with a specific UID (iBeacon's major) to the list of discovered
 */
+(void)discoverBusinessByID:(NSNumber*)businessUID Context:(NSManagedObjectContext*)context;

/**
 Get only businesses that were discovered
 */
+(NSArray*)getDiscoveredBusinessesForContext:(NSManagedObjectContext*)context;

/**
 Get the description of the location for a specific deal (certain deals can be location specific)
 */
-(NSString*)getLocationAddressForDeal:(Featured*)deal;

/**
 Get the icon of the category that this business corresponds
 */
-(UIImage*)getCategoryIcon;

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
