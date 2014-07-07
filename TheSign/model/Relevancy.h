//
//  Relevancy.h
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-06-21.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

@import Foundation;
@import CoreData;

@class Featured, User,Tag;

@interface Relevancy : NSManagedObject

@property (nonatomic, retain) NSNumber * score;
@property (nonatomic, retain) Featured *linkedOffer;
@property (nonatomic, retain) User *linkedUser;

+(void)changeRelevancyForOffer:(Featured*)offer ByValue:(NSNumber*)value;

@end

