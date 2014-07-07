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
#import "Tag.h"
#import "TagConnection.h"
#import "Model.h"
#import "Relevancy.h"

#define CD_TITLE (@"title")
#define CD_DETAILS (@"details")
#define CD_FULLNAME (@"fullName")
#define CD_WELCOMETEXT (@"welcomeText")
#define CD_IMAGE (@"image")
#define CD_MAJOR (@"major")
#define CD_MINOR (@"minor")
#define CD_ACIVE (@"active")

#define P_TITLE (@"name")
#define P_FULLNAME (@"featured")
#define P_DETAILS (@"description")
#define P_WELCOMETEXT (@"welcomeText")
#define P_IMAGE (@"picture")
#define P_MINOR (@"minor")
#define P_BUSINESS (@"BusinessID")
#define P_ACTIVE (@"active")

@implementation Featured

@synthesize parseObject=_parseObject;

+(NSString*) entityName {return @"Featured";}
+(NSString*) parseEntityName {return @"Info";}

@dynamic title;
@dynamic fullName;
@dynamic details;
@dynamic welcomeText;
@dynamic active;
@dynamic image;
@dynamic major;
@dynamic minor;
@dynamic pObjectID;
@dynamic linkedTagSets;
@dynamic linkedBusiness;
@dynamic linkedStats;
@dynamic linkedScore;

+(Boolean)checkIfParseObjectRight:(PFObject*)object
{
    if(object[P_TITLE] && object[P_FULLNAME] && object[P_ACTIVE] && object[P_BUSINESS])
        return YES;
    else
        return NO;
}

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


+(Featured*) getOfferByMajor:(NSNumber*)major andMinor:(NSNumber*)minor
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:self.entityName];
    NSPredicate *predicateMajor = [NSPredicate predicateWithFormat: @"(%@==%ld)", CD_MAJOR, major.longValue];
    NSPredicate *predicateMinor = [NSPredicate predicateWithFormat: @"(%@==%ld)", CD_MINOR, minor.longValue];
    request.predicate=[NSCompoundPredicate andPredicateWithSubpredicates:@[predicateMajor, predicateMinor]];
   
    NSError *error;
    NSArray *featured = [[Model sharedModel].managedObjectContext executeFetchRequest:request error:&error];
    
    if(error)
    {
        NSLog(@"%@",[error localizedDescription]);
        return nil;
    }
    
    return featured.firstObject;
}


+ (void)createFromParse:(PFObject *)object
{
    if([self checkIfParseObjectRight:object]==NO)
    {
        NSLog(@"The object %@ is missing mandatory fields",object.objectId);
        return;
    }

    NSError *error;
    Featured *deal = [NSEntityDescription insertNewObjectForEntityForName:self.entityName
                                                   inManagedObjectContext:[Model sharedModel].managedObjectContext];
    deal.parseObject=object;
    deal.pObjectID=object.objectId;
    
    if(object[P_FULLNAME]!=nil) deal.fullName=object[P_FULLNAME];
    if(object[P_TITLE]!=nil) deal.title=object[P_TITLE];
    
    deal.details=object[P_DETAILS];
    if(object[P_ACTIVE]!=nil) deal.active=object[P_ACTIVE];
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
    
    if([self.class checkIfParseObjectRight:self.parseObject]==NO)
    {
        NSLog(@"The object %@ is missing mandatory fields",self.parseObject.objectId);
        return;
    }
    
    self.fullName=self.parseObject[P_FULLNAME];
    self.title=self.parseObject[P_TITLE];
    self.details=self.parseObject[P_DETAILS];
    self.active=self.parseObject[P_ACTIVE];
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

/*-(NSSet*)findContextTags:(NSSet*) lookupTags
{
    NSMutableSet *results=[NSMutableSet set];
    double threshold=[Model sharedModel].settings.contextThreshold.doubleValue;
    for(TagSet* tagset in self.linkedTagSets)
    {
        Tag *tag=tagset.linkedTag;
        //look for context tags from lookupTags array
        if(tag && tag.context.boolValue && [lookupTags containsObject:tag.pObjectID] && tagset.weight.doubleValue>=threshold)
            [results addObject:tag.pObjectID];
        
        for (TagConnection* connectionTo in tag.linkedConnectionsTo)
        {
            Tag* tag2=connectionTo.linkedTagFrom;
            //look for context tags from lookupTags array
            if(tag2 && tag2.context.boolValue && [lookupTags containsObject:tag2.pObjectID] && connectionTo.weight.doubleValue>=threshold)
                [results addObject:tag2.pObjectID];
        }
        for (TagConnection* connectionFrom in tag.linkedConnectionsFrom)
        {
            Tag* tag3=connectionFrom.linkedTagFrom;
            //look for context tags from lookupTags array
            if(tag3 && tag3.context.boolValue && [lookupTags containsObject:tag3.pObjectID] && connectionFrom.weight.doubleValue>=threshold)
                [results addObject:tag3.pObjectID];
        }
    }
    return results;
}*/
/*
-(NSSet*)checkContextTags:(NSSet*) lookupTags
{
    NSMutableSet*results=[NSMutableSet set];
    for (Context* context in self.linkedContexts)
    {
        if(context && tag.context.boolValue && [lookupTags containsObject:tag.pObjectID])
            [results addObject:tag.pObjectID];
    }
    return results;
}
*/
/*-(void)updateContextTagList
{
    //clean out the list
    if (self.linkedContextTags)
        [self removeLinkedContextTags:self.linkedContextTags];
    
    for(TagSet* tagset in self.linkedTagSets)
    {
        Tag *tag=tagset.linkedTag;
        if(tag && tag.context.boolValue)
        {
            [self addLinkedContextTagsObject:tag];
           // [tag addLinkedContextOffersObject:self];
        }
        
        for (TagConnection* connectionTo in tag.linkedConnectionsTo)
        {
            Tag* tag2=connectionTo.linkedTagFrom;
            if(tag2 && tag2.context.boolValue)
            {
                [self addLinkedContextTagsObject:tag2];
             //   [tag2 addLinkedContextOffersObject:self];
            }
        }
        for (TagConnection* connectionFrom in tag.linkedConnectionsFrom)
        {
            Tag* tag3=connectionFrom.linkedTagTo;
            if(tag3 && tag3.context.boolValue)
            {
                [self addLinkedContextTagsObject:tag3];
              //  [tag3 addLinkedContextOffersObject:self];
            }
        }
    }
}*/


-(void) processLike:(double)effect
{
    //update likeness scores for tags
    NSMutableArray* alreadyProcessed=[NSMutableArray array];
    for(TagSet* tagset in self.linkedTagSets)
    {
        if( tagset.linkedTag) [tagset.linkedTag processLike:effect*tagset.weight.doubleValue AlreadyProcessed:&alreadyProcessed];
    }

    //update relevancy score
    double score=0;
    for(TagSet* tagset in self.linkedTagSets)
        if( tagset.linkedTag) score+=[tagset.linkedTag calculateRelevancyOnLevel:0];
    
    [Relevancy changeRelevancyForOffer:self ByValue:@(score)];
}






@end
