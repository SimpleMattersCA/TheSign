//
//  Featured.m
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-06-13.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import "Featured.h"
#import "Business.h"
#import "Statistics.h"
#import "TagSet.h"
#import "Model.h"

#define CD_NAME (@"name")
#define CD_TITLE (@"title")
#define CD_DETAILS (@"details")
#define CD_IMAGE (@"image")
#define CD_MAJOR (@"major")
#define CD_MINOR (@"minor")
#define CD_VIDEO (@"videoUrl")
#define CD_BUSINESS (@"parentBusiness")
#define CD_ACIVE (@"active")

#define P_NAME (@"name")
#define P_TITLE (@"featured")
#define P_DETAILS (@"description")
#define P_IMAGE (@"picture")
#define P_MINOR (@"minor")
#define P_VIDEO (@"video")
#define P_BUSINESS (@"BusinessID")
#define P_ACIVE (@"active")



@implementation Featured

@dynamic active;
@dynamic details;
@dynamic image;
@dynamic major;
@dynamic minor;
@dynamic pObjectID;
@dynamic title;
@dynamic videoUrl;
@dynamic name;
@dynamic featuredTagSets;
@dynamic parentBusiness;
@dynamic records;

@synthesize parseObject=_parseObject;

+(NSString*) entityName {return @"Featured";}
+(NSString*) parseEntityName {return @"Info";}

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

//+(NSArray*) getOffersForBusiness:(Business*)business
//{
//   NSNumber* major=business.uid;
//   return [self getOffersByMajor:major andMinor:nil];
//}

//Getting array of Featured objects by beacon's major and minor. The idea is that optionally the offer can be attached to a specific beacon, but it doesn't have to so we first check if there are offers with such major and minor id's and if not, we check only by major
+(NSArray*) getOffersByMajor:(NSNumber*)major andMinor:(NSNumber*)minor
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:self.entityName];
    NSString *predicateMajor = [NSString stringWithFormat: @"(%@==%ld)", CD_MAJOR, (long)major.integerValue];
    if(minor!=nil)
    {
        NSString *predicateMinor = [NSString stringWithFormat: @"(%@==%ld)", CD_MINOR, (long)minor.integerValue];
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


+ (void)createFromParse:(PFObject *)object
{
    Featured *deal = [NSEntityDescription insertNewObjectForEntityForName:self.entityName
                                                   inManagedObjectContext:[Model sharedModel].managedObjectContext];
    deal.parseObject=object;
    deal.pObjectID=object.objectId;
    
    if(object[P_NAME]!=nil) deal.name=object[P_NAME];
    if(object[P_TITLE]!=nil) deal.title=object[P_TITLE];
    deal.details=object[P_DETAILS];
    deal.videoUrl=object[P_VIDEO];
    if(object[P_ACIVE]!=nil) deal.active=object[P_ACIVE];
    deal.minor=object[P_MINOR];
    PFFile *image=object[P_IMAGE];
    
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
    
    PFObject *fromParseBusiness=[object[P_BUSINESS] fetchIfNeeded:&error];
    
    if (!error)
    {
        Business *linkedBusiness=[Business getByID:fromParseBusiness.objectId];
        deal.major=linkedBusiness.uid;
        deal.parentBusiness = linkedBusiness;
        [linkedBusiness addFeaturedOffersObject:deal];
    }
    else
        NSLog(@"%@",[error localizedDescription]);
}

-(void)refreshFromParse
{
    NSError *error;
    [self.parseObject refresh:&error];
    if(error)
    {
        NSLog(@"%@",[error localizedDescription]);
        return;
    }
    
    self.name=self.parseObject[P_NAME];
    self.title=self.parseObject[P_TITLE];
    self.details=self.parseObject[P_DETAILS];
    self.videoUrl=self.parseObject[P_VIDEO];
    self.active=self.parseObject[P_ACIVE];
    self.minor=self.parseObject[P_MINOR];
    
    PFFile *image=self.parseObject[P_IMAGE];
    
    NSData *pulledImage;
    
    pulledImage=[image getData:&error];
#pragma mark - asdaskd
    if(!error)
    {
        if(pulledImage!=nil)
            self.image = pulledImage;
        else
            NSLog(@"Image offer is missing");
    }
    else
    {
        NSLog(@"%@",[error localizedDescription]);
        return;
    }
    
    
    PFObject *fromParseBusiness=[self.parseObject[P_BUSINESS] fetchIfNeeded:&error];
    if (!error)
    {
        if(self.parentBusiness.pObjectID!=fromParseBusiness.objectId)
        {
            [self.parentBusiness removeLinksObject:self];
            Business *linkedBusiness=[Business getByID:fromParseBusiness.objectId];
            self.major=linkedBusiness.uid;
            self.parentBusiness = linkedBusiness;
            [linkedBusiness addFeaturedOffersObject:self];
        }
    }
    else
        NSLog(@"%@",[error localizedDescription]);
    
    
}



@end
