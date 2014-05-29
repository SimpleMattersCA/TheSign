//
//  ParseConvertable.h
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-05-24.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import <Foundation/Foundation.h>
#define OBJECT_ID (@"pObjectID")

@class PFObject;

@protocol SignEntityProtocol <NSObject>

+(instancetype) getByID:(NSString*)objectId;
+(void)createFromParseObject:(PFObject *)object;
+(NSString*) entityName;
+(NSString*) parseEntityName;

@end
