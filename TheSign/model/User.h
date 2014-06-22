//
//  User.h
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-06-20.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

@import Foundation;
@import CoreData;
#import "SignEntityProtocol.h"

@class DiscoveredBusiness, Like, Statistics, User,PFUser;

@interface User : NSManagedObject

@property (nonatomic, retain) NSNumber * isMainUser;
@property (nonatomic, retain) NSData * pic;
@property (nonatomic, retain) NSString * pObjectID;
@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSString* gender;
@property (nonatomic, retain) NSDate* birthdate;

@property (nonatomic, retain) NSString* fbID;
@property (nonatomic, retain) NSString* twID;

@property (nonatomic, retain) NSSet *linkedDiscoveries;
@property (nonatomic, retain) NSSet *linkedLikes;
@property (nonatomic, retain) NSSet *linkedStatistics;
@property (nonatomic, retain) NSSet *linkedFriends;
@property (nonatomic, retain) NSSet *linkedScores;

@property (nonatomic, retain) User *linkedUser;

@property PFUser* parseObject;

+(void)createFromParse:(PFUser *)user;
+(User*) currentUser;


@end

@interface User (CoreDataGeneratedAccessors)

- (void)addLinkedDiscoveriesObject:(DiscoveredBusiness *)value;
- (void)removeLinkedDiscoveriesObject:(DiscoveredBusiness *)value;
- (void)addLinkedDiscoveries:(NSSet *)values;
- (void)removeLinkedDiscoveries:(NSSet *)values;

- (void)addLinkedLikesObject:(Like *)value;
- (void)removeLinkedLikesObject:(Like *)value;
- (void)addLinkedLikes:(NSSet *)values;
- (void)removeLinkedLikes:(NSSet *)values;

- (void)addLinkedStatisticsObject:(Statistics *)value;
- (void)removeLinkedStatisticsObject:(Statistics *)value;
- (void)addLinkedStatistics:(NSSet *)values;
- (void)removeLinkedStatistics:(NSSet *)values;

- (void)addLinkedFriendsObject:(User *)value;
- (void)removeLinkedFriendsObject:(User *)value;
- (void)addLinkedFriends:(NSSet *)values;
- (void)removeLinkedFriends:(NSSet *)values;

- (void)addLinkedScoresObject:(User *)value;
- (void)removeLinkedScoresObject:(User *)value;
- (void)addLinkedScores:(NSSet *)values;
- (void)removeLinkedScores:(NSSet *)values;

@end
