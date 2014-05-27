//
//  Favourites.h
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-05-24.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

@import Foundation;
@import CoreData;

#define FAVOURITES (@"Favourites")

@class Featured;

@interface Favourites : NSManagedObject

@property (nonatomic, retain) Featured *favouriteOffer;
@property (nonatomic, retain) NSDate *recordedDate;

+(void) saveFavourite:(Featured*)offer onDate:(NSDate*) date;

+(NSArray*) getFavourites;

@end
