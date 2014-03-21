//
//  Item.h
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-03-01.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

@import Foundation;
@import CoreData;

@interface Item : NSManagedObjectContext

@property (nonatomic) NSString *title;
@property (nonatomic) NSString *description;


@end
