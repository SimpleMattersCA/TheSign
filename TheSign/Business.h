//
//  Business.h
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-03-23.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Business : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * uid;
@property (nonatomic, retain) NSString * welcomeText;
@property (nonatomic, retain) NSData * logo;

@end
