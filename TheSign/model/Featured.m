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
@dynamic parentBusiness;
@dynamic active;
@dynamic featuredTagSets;
@dynamic favourited;

+(NSString*) entityName {return @"Featured";}
+(NSString*) parseEntityName {return @"Info";}

+(NSString*)colDetails {return @"details";}
+(NSString*)colImage {return @"image";}
+(NSString*)colMajor {return @"major";}
+(NSString*)colMinor {return @"minor";}
+(NSString*)colTitle {return @"title";}
+(NSString*)colVideoUrl {return @"videoUrl";}
+(NSString*)colParentBusiness {return @"parentBusiness";}
+(NSString*)colActive {return @"active";}

+(NSString*)pDetails {return @"description";}
+(NSString*)pImage {return @"picture";}
+(NSString*)pMajor {return Featured.colMajor;}
+(NSString*)pMinor {return Featured.colMinor;}
+(NSString*)pTitle {return @"featured";}
+(NSString*)pVideoUrl {return @"video";}
+(NSString*)pParentBusiness {return @"BusinessID";}
+(NSString*)pActive {return Featured.colActive;}


+(Featured*) getByID:(NSString*)identifier
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:self.entityName];
    NSString *predicate = [NSString stringWithFormat: @"%@=='%@'", OBJECT_ID, identifier];
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


-(void) recordFavourite
{
    Favourites* newFav=[Favourites saveFavourite:self onDate:[NSDate date]];
    [self addFavouritedObject:newFav];
}


//+(NSArray*) getOffersForBusiness:(Business*)business
//{
 //   NSNumber* major=business.uid;
 //   return [self getOffersByMajor:major andMinor:nil];
//}

//Getting array of Featured objects by beacon's major and minor. The idea is that optionally the offer can be attached to a specific beacon, but it doesn't have to so we first check if there are offers with such major and minor id's and if not, we check only by major
+(NSArray*) getOffersByMajor:(NSNumber*)major andMinor:(NSNumber*)minor
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:self.entityName];
    NSString *predicateMajor = [NSString stringWithFormat: @"(%@==%d)", Featured.colMajor, major.integerValue];
    if(minor!=nil)
    {
        NSString *predicateMinor = [NSString stringWithFormat: @"(%@==%d)", Featured.colMinor, minor.integerValue];
        request.predicate=[NSCompoundPredicate andPredicateWithSubpredicates:@[predicateMajor, predicateMinor]];
    }
    else
        request.predicate=[NSPredicate predicateWithFormat:predicateMajor];
    NSError *error;
    NSArray *featured = [[Model sharedModel].managedObjectContext executeFetchRequest:request error:&error];
    
    if(error)
    {
        NSLog(@"%@",[error localizedDescription]);
        return nil;
    }
    
    //if there are no offers tied directly to the beacon we try to find all the offers for the business
    if(featured.count==0 && minor!=nil)
    {
        request.predicate=[NSPredicate predicateWithFormat:predicateMajor];
        featured = [[Model sharedModel].managedObjectContext executeFetchRequest:request error:&error];
        if(error)
        {
            NSLog(@"%@",[error localizedDescription]);
            return nil;
        }
    }
    return featured;
}


+ (void)createFromParseObject:(PFObject *)object
{
    Featured *deal = [NSEntityDescription insertNewObjectForEntityForName:self.entityName
                                                   inManagedObjectContext:[Model sharedModel].managedObjectContext];
    deal.pObjectID=object.objectId;
    if(object[Featured.pTitle]!=nil) deal.title=object[Featured.pTitle];
    deal.details=object[Featured.pDetails];
    deal.videoUrl=object[Featured.pVideoUrl];
    if(object[Featured.pActive]!=nil) deal.active=object[Featured.pActive];
    if(object[Featured.pMajor]!=nil) deal.major=object[Featured.pMajor];
    deal.minor=object[Featured.pMinor];
    PFFile *image=object[Featured.pImage];
    
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
    
    PFObject *retrievedBusiness=[object[Featured.pParentBusiness] fetchIfNeeded:&error];
    
    if (!error)
    {
        Business *linkedBusiness=[Business getByID:(NSString*)(retrievedBusiness.objectId)];
        deal.parentBusiness = linkedBusiness;
        [linkedBusiness addFeaturedOffersObject:deal];
    }
    else
        NSLog(@"%@",[error localizedDescription]);
}



@end
