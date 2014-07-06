//
//  Context.h
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-07-04.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

@import Foundation;
@import CoreData;
#import "SignEntityProtocol.h"

@class Featured, Tag;

@interface Context : NSManagedObject <SignEntityProtocol>

@property (nonatomic, retain) NSString * pObjectID;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * probability;
@property (nonatomic, retain) NSSet *linkedTags;
@property (nonatomic, retain) NSSet *linkedOffers;
@end

@interface Context (CoreDataGeneratedAccessors)

- (void)addLinkedTagsObject:(Tag *)value;
- (void)removeLinkedTagsObject:(Tag *)value;
- (void)addLinkedTags:(NSSet *)values;
- (void)removeLinkedTags:(NSSet *)values;

- (void)addLinkedOffersObject:(Featured *)value;
- (void)removeLinkedOffersObject:(Featured *)value;
- (void)addLinkedOffers:(NSSet *)values;
- (void)removeLinkedOffers:(NSSet *)values;

@end
