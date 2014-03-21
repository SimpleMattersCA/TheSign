//
//  Business.h
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-03-18.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

@import Foundation;
@import CoreData;

@interface Business : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * welcomeText;
@property (nonatomic, retain) NSNumber * uid;

@end
