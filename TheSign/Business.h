//
//  Business.h
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-05-15.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Featured;

@interface Business : NSManagedObject

@property (nonatomic, retain) NSData * logo;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * uid;
@property (nonatomic, retain) NSString * welcomeText;
@property (nonatomic, retain) NSNumber * workingHoursStart;
@property (nonatomic, retain) NSNumber * workingHoursEnd;
@property (nonatomic, retain) NSSet *featuredOffers;
@end

@interface Business (CoreDataGeneratedAccessors)

- (void)addFeaturedOffersObject:(Featured *)value;
- (void)removeFeaturedOffersObject:(Featured *)value;
- (void)addFeaturedOffers:(NSSet *)values;
- (void)removeFeaturedOffers:(NSSet *)values;

@end
