//
//  BusinessCategory.h
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-07-26.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

@import Foundation;
@import CoreData;
#import "SignEntityProtocol.h"

@class Business;

@interface BusinessCategory : NSManagedObject <SignEntityProtocol>

@property (nonatomic, retain) NSString * pObjectID;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSData * icon;
@property (nonatomic, retain) NSSet *linkedBusinesses;


/**
 Getting the array of all business categories
 */
+(NSArray*) getCategoriesForContext:(NSManagedObjectContext*)context;

@end

@interface BusinessCategory (CoreDataGeneratedAccessors)

- (void)addLinkedBusinessesObject:(Business *)value;
- (void)removeLinkedBusinessesObject:(Business *)value;
- (void)addLinkedBusinesses:(NSSet *)values;
- (void)removeLinkedBusinesses:(NSSet *)values;

@end
