//
//  TagClass.h
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-05-13.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Tag;

@interface TagClass : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * uid;
@property (nonatomic, retain) NSSet *tagsInClass;
@end

@interface TagClass (CoreDataGeneratedAccessors)

- (void)addTagsInClassObject:(Tag *)value;
- (void)removeTagsInClassObject:(Tag *)value;
- (void)addTagsInClass:(NSSet *)values;
- (void)removeTagsInClass:(NSSet *)values;

@end
