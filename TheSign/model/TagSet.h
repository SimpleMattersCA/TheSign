//
//  TagSet.h
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-05-26.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

@import Foundation;
@import CoreData;

#import "SignEntityProtocol.h"



@class Featured, Tag;

@interface TagSet : NSManagedObject <SignEntityProtocol>

@property (nonatomic, retain) NSNumber * weight;
@property (nonatomic, retain) NSString * pObjectID;
@property (nonatomic, retain) Featured *taggedFeature;
@property (nonatomic, retain) Tag *tagInSet;

+(NSString*)colWeight;
+(NSString*)colTaggedFeature;
+(NSString*)colTagInSet;
+(NSString*)pWeight;
+(NSString*)pTaggedFeature;
+(NSString*)pTagInSet;



@end
