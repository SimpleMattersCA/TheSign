//
//  Featured.m
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-06-19.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import "Featured.h"
#import "Business.h"
#import "Statistics.h"
#import "TagSet.h"
#import "Model.h"

#define CD_ABOUT (@"about")
#define CD_TITLE (@"title")
#define CD_DETAILS (@"details")
#define CD_IMAGE (@"image")
#define CD_MAJOR (@"major")
#define CD_MINOR (@"minor")
#define CD_ACIVE (@"active")

#define P_ABOUT (@"featured")
#define P_TITLE (@"name")
#define P_DETAILS (@"description")
#define P_IMAGE (@"picture")
#define P_MINOR (@"minor")
#define P_BUSINESS (@"BusinessID")
#define P_ACIVE (@"active")

@implementation Featured

@synthesize parseObject=_parseObject;

+(NSString*) entityName {return @"Featured";}
+(NSString*) parseEntityName {return @"Info";}

@dynamic active;
@dynamic details;
@dynamic image;
@dynamic major;
@dynamic minor;
@dynamic title;
@dynamic pObjectID;
@dynamic about;
@dynamic linkedTagSets;
@dynamic linkedBusiness;
@dynamic linkedStats;
@dynamic linkedScore;

+(Featured*) getByID:(NSString*)identifier
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:self.entityName];
    request.predicate=[NSPredicate predicateWithFormat:[NSString stringWithFormat: @"%@=='%@'", OBJECT_ID, identifier]];
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
    NSPredicate *predicateMajor = [NSPredicate predicateWithFormat: @"(%@==%ld)", CD_MAJOR, major.longValue];
    if(minor!=nil)
    {
        NSPredicate *predicateMinor = [NSPredicate predicateWithFormat: @"(%@==%ld)", CD_MINOR, minor.longValue];
        request.predicate=[NSCompoundPredicate andPredicateWithSubpredicates:@[predicateMajor, predicateMinor]];
    }
    else
        request.predicate=predicateMajor;
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
        request.predicate=predicateMajor;
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
    NSError *error;
    Featured *deal = [NSEntityDescription insertNewObjectForEntityForName:self.entityName
                                                   inManagedObjectContext:[Model sharedModel].managedObjectContext];
    deal.parseObject=object;
    deal.pObjectID=object.objectId;
    
    if(object[P_ABOUT]!=nil) deal.about=object[P_ABOUT];
    if(object[P_TITLE]!=nil) deal.title=object[P_TITLE];
    deal.details=object[P_DETAILS];
    if(object[P_ACIVE]!=nil) deal.active=object[P_ACIVE];
    deal.minor=object[P_MINOR];
    
    
    if(object[P_IMAGE]!=nil)
    {
        PFFile *image=object[P_IMAGE];
        
        NSData *pulledImage=[image getData:&error];
        
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
    }
    
    //careful, incomplete object - only objectId property is there
    PFObject *fromParseBusiness=object[P_BUSINESS];
    Business *linkedBusiness=[Business getByID:fromParseBusiness.objectId];
    if (linkedBusiness!=nil)
    {
        deal.major=linkedBusiness.uid;
        deal.linkedBusiness = linkedBusiness;
        [linkedBusiness addLinkedOffersObject:deal];
    }
    else
        NSLog(@"Linked business wasn't found");
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
    
    self.about=self.parseObject[P_ABOUT];
    self.title=self.parseObject[P_TITLE];
    self.details=self.parseObject[P_DETAILS];
    self.active=self.parseObject[P_ACIVE];
    self.minor=self.parseObject[P_MINOR];
    
    if(self.parseObject[P_IMAGE]!=nil)
    {
        PFFile *image=self.parseObject[P_IMAGE];
        NSData *pulledImage=[image getData:&error];
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
    }
    
    //careful, incomplete object - only objectId property is there
    PFObject *fromParseBusiness=self.parseObject[P_BUSINESS];
    if(self.linkedBusiness.pObjectID!=fromParseBusiness.objectId)
    {
        [self.linkedBusiness removeLinkedOffersObject:self];
        Business *linkedBusiness=[Business getByID:fromParseBusiness.objectId];
        if(linkedBusiness!=nil)
        {
            self.major=linkedBusiness.uid;
            self.linkedBusiness = linkedBusiness;
            [linkedBusiness addLinkedOffersObject:self];
        }
        else
            NSLog(@"Linked business wasn't found");
    }
}

@end
