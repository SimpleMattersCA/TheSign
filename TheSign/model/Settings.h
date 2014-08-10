//
//  Settings.h
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-06-25.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

@import Foundation;
@import CoreData;
#import "SignEntityProtocol.h"

@interface Settings : NSManagedObject <SignEntityProtocol>

@property (nonatomic, retain) NSString * pObjectID;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * paramStr;
@property (nonatomic, retain) NSNumber * paramInt;
@property (nonatomic, retain) NSNumber * paramFloat;
@property (nonatomic, retain) NSNumber * paramBool;
@property (nonatomic, retain) NSDate * paramDate;



/**
 Getting the value of the parameter from core data by name. If it's not there, returns nil
 */
+(Settings*)getValueForParamName:(NSString*)paramName Context:(NSManagedObjectContext*)context;

@end
