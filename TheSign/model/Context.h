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

@class Featured, Tag,Business,Location;

@interface Context : NSManagedObject <SignEntityProtocol>

@property (nonatomic, retain) NSString * pObjectID;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * probability;
@property (nonatomic, retain) NSSet *linkedTags;

/**
 Return array of Context Tags that correspond to the specific Busines's Location
 */
+(NSArray*)getCurrentContextsForBusiness:(Business*)business AtLocation:(Location*)location Context:(NSManagedObjectContext*)context;

@end

@interface Context (CoreDataGeneratedAccessors)

- (void)addLinkedTagsObject:(Tag *)value;
- (void)removeLinkedTagsObject:(Tag *)value;
- (void)addLinkedTags:(NSSet *)values;
- (void)removeLinkedTags:(NSSet *)values;


@end
