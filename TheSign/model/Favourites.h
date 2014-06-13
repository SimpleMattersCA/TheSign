//
//  Favourites.h
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-05-24.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

@import Foundation;
@import CoreData;

#define FAVOURITES ()

@class Featured;

@interface Favourites : NSManagedObject

@property (nonatomic, retain) Featured *favouriteOffer;
@property (nonatomic, retain) NSDate *recordedDate;
@property (nonatomic, retain) NSNumber *liked;


+(Favourites*) savePreference:(Featured*)offer Liked:(Boolean)liked onDate:(NSDate*) date;


+(NSArray*) getFavourites;

@end
