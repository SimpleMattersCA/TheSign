//
//  Featured.m
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-05-24.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import "Featured.h"
#import "Business.h"
#import "Favourites.h"
#import "TagSet.h"
#import "Model.h"

@implementation Featured

@dynamic pObjectID;
@dynamic details;
@dynamic image;
@dynamic major;
@dynamic minor;
@dynamic title;
@dynamic videoUrl;
@dynamic favourited;
@dynamic featuredTagSet;
@dynamic parentBusiness;

+(NSString*) entityName
{
    return FEATURED;
}

+(NSString*) parseEntityName
{
    return [self parseName:[self entityName]];
}

+(Featured*) getByID:(NSString*)identifier
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[self entityName]];
    NSString *predicate = [NSString stringWithFormat: @"%@==%@", OBJECT_ID, identifier];
    request.predicate=[NSPredicate predicateWithFormat:predicate];
    NSError *error;
    NSArray *result = [[Model sharedModel].managedObjectContext executeFetchRequest:request error:&error];
    
    if(error)
    {
        NSLog(@"%@",[error localizedDescription]);
        return nil;
    }
    else
        return (Featured*)result.firstObject;
}

+(NSString*)parseName:(NSString*)coreDataName
{
    if ([coreDataName isEqual:FEATURED])
        return @"Info";
    if ([coreDataName isEqual:FEATURED_TITLE])
        return @"featured";
    if ([coreDataName isEqual:FEATURED_DETAILS])
        return @"description";
    if ([coreDataName isEqual:FEATURED_VIDEO])
        return @"video";
    if ([coreDataName isEqual:FEATURED_IMAGE])
        return @"picture";
    if ([coreDataName isEqual:FEATURED_BUSINESS])
        return @"BusinessID";
    return coreDataName;
}

//Getting array of Featured objects by beacon's major and minor. The idea is that optionally the offer can be attached to a specific beacon, but it doesn't have to so we first check if there are offers with such major and minor id's and if not, we check only by major
+(NSArray*) getOffersByMajor:(NSNumber*)major andMinor:(NSNumber*)minor
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[self entityName]];
    
    NSString *predicateMajor = [NSString stringWithFormat: @"(%@==%d)", FEATURED_MAJOR, major.integerValue];
    NSString *predicateMinor = [NSString stringWithFormat: @"(%@==%d)", FEATURED_MINOR, minor.integerValue];
    
    request.predicate=[NSCompoundPredicate andPredicateWithSubpredicates:@[predicateMajor, predicateMinor]];
    NSError *error;
    NSArray *featured = [[Model sharedModel].managedObjectContext executeFetchRequest:request error:&error];
    
    if(error)
    {
        NSLog(@"%@",[error localizedDescription]);
        return nil;
    }
    
    //if there are no offers tied directly to the beacon we try to find all the offers for the business
    if(featured.count==0)
    {
        request.predicate=[NSPredicate predicateWithFormat:predicateMajor];
        featured = [[Model sharedModel].managedObjectContext executeFetchRequest:request error:&error];
    }
    return featured;
}


+ (void)createFromParseObject:(PFObject *)object
{
    Featured *deal = [NSEntityDescription insertNewObjectForEntityForName:[self entityName]
                                                   inManagedObjectContext:[Model sharedModel].managedObjectContext];
    deal.pObjectID=object[OBJECT_ID];
    deal.title=object[[Featured parseName:FEATURED_TITLE]];
    deal.details=object[[Featured parseName:FEATURED_DETAILS]];
    deal.videoUrl=object[[Featured parseName:FEATURED_VIDEO]];
    
    PFFile *image=object[[Featured parseName:FEATURED_IMAGE]];
    
    NSError *error;
    NSData *pulledImage;
    
    pulledImage=[image getData:&error];
    
    if(!error)
    {
        if(pulledImage!=nil)
            deal.image = pulledImage;
        else
            NSLog(@"Image offer is missing");
    }
    else
    {
        NSLog(@"%@",[error localizedDescription]);
        return;
    }
    
    PFObject *retrievedBusiness=[object[[Featured parseName:FEATURED_BUSINESS]] fetchIfNeeded:&error];
    
    if (!error)
    {
        Business *linkedBusiness=[Business getByID:(NSString*)(retrievedBusiness[OBJECT_ID])];
        deal.parentBusiness = linkedBusiness;
        [linkedBusiness addFeaturedOffersObject:deal];
    }
    else
        NSLog(@"%@",[error localizedDescription]);
}


@end
