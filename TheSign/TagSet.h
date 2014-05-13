//
//  TagSet.h
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-05-13.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Featured;

@interface TagSet : NSManagedObject

@property (nonatomic, retain) NSNumber * weight;
@property (nonatomic, retain) NSSet *tagsInSet;
@property (nonatomic, retain) Featured *taggedFeature;
@end

@interface TagSet (CoreDataGeneratedAccessors)

- (void)addTagsInSetObject:(NSManagedObject *)value;
- (void)removeTagsInSetObject:(NSManagedObject *)value;
- (void)addTagsInSet:(NSSet *)values;
- (void)removeTagsInSet:(NSSet *)values;

@end
