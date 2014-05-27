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

+(void) saveFavourite:(Featured*)offer onDate:(NSDate*) date
{
    Favourites *newFav = [NSEntityDescription insertNewObjectForEntityForName:FAVOURITES
                                                        inManagedObjectContext:[Model sharedModel].managedObjectContext];
    newFav.favouriteOffer=offer;
    newFav.recordedDate=date;
    [[Model sharedModel] saveContext];
}

+(NSArray*) getFavourites
{
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:FAVOURITES];
    //NSString *predicate = [NSString stringWithFormat: @"%@==%@", OBJECT_ID, identifier];
    //request.predicate=[NSPredicate predicateWithFormat:predicate];
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
