//
//  Business.h
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-05-24.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

@import Foundation;
@import CoreData;

#import "SignEntityProtocol.h"



@class Featured,PFObject,CLLocation;

@interface Business : NSManagedObject <SignEntityProtocol>

@property (nonatomic, retain) NSString * pObjectID;
@property (nonatomic, retain) NSData * logo;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * uid;
@property (nonatomic, retain) NSString * welcomeText;
@property (nonatomic, retain) NSNumber * workingHoursEnd;
@property (nonatomic, retain) NSNumber * workingHoursStart;
@property (nonatomic, retain) NSString * businessType;
@property (nonatomic, retain) NSSet *featuredOffers;
@property (nonatomic, retain) NSSet *links;
@property (nonatomic, retain) NSNumber *locationLatt;
@property (nonatomic, retain) NSNumber *locationLong;




+(NSString*) getBusinessNameByBusinessID:(NSInteger)identifier;
+(NSString*) getWelcomeTextByBusinessID:(NSInteger)identifier;
+(NSArray*) getBusinessesByType:(NSString*)type;
+(NSArray*) getBusinessTypes;
+(CLLocation*)getClosestBusinessToLocation:(CLLocation*)location;

+(CLLocation*)getLocationObjectByBusinessID:(NSInteger)identifier;


@end


@interface Business (CoreDataGeneratedAccessors)

- (void)addFeaturedOffersObject:(Featured *)value;
- (void)removeFeaturedOffersObject:(Featured *)value;
- (void)addFeaturedOffers:(NSSet *)values;
- (void)removeFeaturedOffers:(NSSet *)values;

- (void)addLinksObject:(NSManagedObject *)value;
- (void)removeLinksObject:(NSManagedObject *)value;
- (void)addLinks:(NSSet *)values;
- (void)removeLinks:(NSSet *)values;

@end
