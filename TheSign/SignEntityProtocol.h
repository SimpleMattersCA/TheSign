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

@property PFObject* parseObject;

+(instancetype) getByID:(NSString*)objectId Context:(NSManagedObjectContext*)context;
+(NSInteger) getRowCountForContext:(NSManagedObjectContext*)context;

+(Boolean)createFromParse:(PFObject *)object Context:(NSManagedObjectContext*)context;
+(NSString*) entityName;
+(NSString*) parseEntityName;

-(Boolean)refreshFromParseForContext:(NSManagedObjectContext*)context;
+(Boolean)checkIfParseObjectRight:(PFObject*)object;
@end
