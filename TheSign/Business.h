//
//  Business.h
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-05-13.
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
@property (nonatomic, retain) NSSet *feature;
@end

@interface Business (CoreDataGeneratedAccessors)

- (void)addFeatureObject:(Featured *)value;
- (void)removeFeatureObject:(Featured *)value;
- (void)addFeature:(NSSet *)values;
- (void)removeFeature:(NSSet *)values;

@end
