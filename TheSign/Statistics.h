//
//  Statistics.h
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-05-14.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Statistics : NSManagedObject

@property (nonatomic, retain) NSNumber * major;
@property (nonatomic, retain) NSNumber * minor;
@property (nonatomic, retain) NSDate * date;

@end
