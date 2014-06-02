//
//  Favourites.m
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-05-24.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import "Favourites.h"
#import "Featured.h"
#import "Model.h"

@implementation Favourites

@dynamic favouriteOffer;
@dynamic recordedDate;

+(NSString*) entityName
{
    return @"Favourites";
}

+(Favourites*) saveFavourite:(Featured*)offer onDate:(NSDate*) date
{
    Favourites *newFav = [NSEntityDescription insertNewObjectForEntityForName:self.entityName
                                                        inManagedObjectContext:[Model sharedModel].managedObjectContext];
    newFav.favouriteOffer=offer;
    newFav.recordedDate=date;
    [[Model sharedModel] saveContext];
    return newFav;
}

+(NSArray*) getFavourites
{
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:self.entityName];
    NSError *error;
    NSArray *favourites = [[Model sharedModel].managedObjectContext executeFetchRequest:request error:&error];
    
    if(error)
    {
        NSLog(@"%@",[error localizedDescription]);
        return nil;
    }
    
    return favourites;
  
}

@end
