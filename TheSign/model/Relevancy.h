//
//  Relevancy.h
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-06-21.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Featured, Statistics, User;

@interface Relevancy : NSManagedObject

@property (nonatomic, retain) NSNumber * score;
@property (nonatomic, retain) Featured *linkedOffer;
@property (nonatomic, retain) NSSet *linkedStatistics;
@property (nonatomic, retain) User *linkedUser;

-(void)rescore;
@end

@interface Relevancy (CoreDataGeneratedAccessors)

- (void)addLinkedStatisticsObject:(Statistics *)value;
- (void)removeLinkedStatisticsObject:(Statistics *)value;
- (void)addLinkedStatistics:(NSSet *)values;
- (void)removeLinkedStatistics:(NSSet *)values;

@end
