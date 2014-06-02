//
//  Featured.h
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-05-27.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

@import Foundation;
@import CoreData;
#import "SignEntityProtocol.h"

@class Business, Favourites, TagSet;

@interface Featured : NSManagedObject <SignEntityProtocol>

@property (nonatomic, retain) NSString * details;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSNumber * major;
@property (nonatomic, retain) NSNumber * minor;
@property (nonatomic, retain) NSString * pObjectID;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * videoUrl;
@property (nonatomic, retain) NSNumber * active;
@property (nonatomic, retain) NSSet *favourited;
@property (nonatomic, retain) NSSet *featuredTagSets;
@property (nonatomic, retain) Business *parentBusiness;

+(NSString*)colDetails;
+(NSString*)colImage;
+(NSString*)colMajor;
+(NSString*)colMinor;
+(NSString*)colTitle;
+(NSString*)colVideoUrl;
+(NSString*)colParentBusiness;
+(NSString*)colActive;

+(NSString*)pDetails;
+(NSString*)pImage;
+(NSString*)pMajor;
+(NSString*)pMinor;
+(NSString*)pTitle;
+(NSString*)pVideoUrl;
+(NSString*)pParentBusiness;
+(NSString*)pActive;



+(NSArray*) getOffersByMajor:(NSNumber*)major andMinor:(NSNumber*)minor;
//+(NSArray*) getOffersForBusiness:(Business*)business;

-(void) recordFavourite;

@end

@interface Featured (CoreDataGeneratedAccessors)

- (void)addFavouritedObject:(Favourites *)value;
- (void)removeFavouritedObject:(Favourites *)value;
- (void)addFavourited:(NSSet *)values;
- (void)removeFavourited:(NSSet *)values;

- (void)addFeaturedTagSetsObject:(TagSet *)value;
- (void)removeFeaturedTagSetsObject:(TagSet *)value;
- (void)addFeaturedTagSets:(NSSet *)values;
- (void)removeFeaturedTagSets:(NSSet *)values;

@end
