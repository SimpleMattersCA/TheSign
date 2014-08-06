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
/**
 Protocol for our custom synchronization with Parse
 */
@protocol SignEntityProtocol <NSObject>

/**
 Stores the object in original Parse form. When needed it's being pulled from the cloud using pObjectID
 */
@property PFObject* parseObject;

/**
 Getting the object from persistent store by pObjectID
 */
+(instancetype) getByID:(NSString*)objectId Context:(NSManagedObjectContext*)context;

/**
 Getting the number of entries for this managed object in the persistent store
 */
+(NSInteger) getRowCountForContext:(NSManagedObjectContext*)context;


/**
 Inserting an entry into CoreData of this managed object using the data from the Parse object;
 */
+(Boolean)createFromParse:(PFObject *)object Context:(NSManagedObjectContext*)context;

/**
 The name of the managed object in CoreData
 */
+(NSString*) entityName;

/**
 The name of the correspodning managed object in Parse
 */
+(NSString*) parseEntityName;


/**
 Updates the fields of the entry in CoreData based on the its current state in Parse
 */
-(Boolean)refreshFromParseForContext:(NSManagedObjectContext*)context;

/**
 Verifying if mandatory fields are correct. If not return FALSE
 */
+(Boolean)checkIfParseObjectRight:(PFObject*)object;
@end
