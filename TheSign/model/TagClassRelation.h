//
//  TagClassRelation.h
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-05-26.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

@import Foundation;
@import CoreData;

#import "SignEntityProtocol.h"



@class Tag, TagClass;

@interface TagClassRelation : NSManagedObject <SignEntityProtocol>

@property (nonatomic, retain) NSNumber * weight;
@property (nonatomic, retain) NSString * pObjectID;
@property (nonatomic, retain) Tag *relatedTag;
@property (nonatomic, retain) TagClass *relatedClass;

+(NSString*)colWeight;
+(NSString*)colTag;
+(NSString*)colClass;

+(NSString*)pWeight;
+(NSString*)pTag;
+(NSString*)pClass;

@end
