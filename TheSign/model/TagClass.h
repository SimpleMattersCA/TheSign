//
//  TagClass.h
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-05-26.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

@import Foundation;
@import CoreData;

#import "SignEntityProtocol.h"



@class TagClassConnection, TagClassRelation;

@interface TagClass : NSManagedObject <SignEntityProtocol>

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * pObjectID;
@property (nonatomic, retain) NSSet *controllClassConnection;
@property (nonatomic, retain) NSSet *relatedClassConnection;
@property (nonatomic, retain) NSSet *tagsInClass;

+(NSString*) colName;
+(NSString*) pName;

@end

@interface TagClass (CoreDataGeneratedAccessors)

- (void)addControllClassConnectionObject:(TagClassConnection *)value;
- (void)removeControllClassConnectionObject:(TagClassConnection *)value;
- (void)addControllClassConnection:(NSSet *)values;
- (void)removeControllClassConnection:(NSSet *)values;

- (void)addRelatedClassConnectionObject:(TagClassConnection *)value;
- (void)removeRelatedClassConnectionObject:(TagClassConnection *)value;
- (void)addRelatedClassConnection:(NSSet *)values;
- (void)removeRelatedClassConnection:(NSSet *)values;

- (void)addTagsInClassObject:(TagClassRelation *)value;
- (void)removeTagsInClassObject:(TagClassRelation *)value;
- (void)addTagsInClass:(NSSet *)values;
- (void)removeTagsInClass:(NSSet *)values;

@end
