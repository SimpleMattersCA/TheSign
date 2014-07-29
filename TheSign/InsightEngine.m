//
//  InsightEngine.m
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-05-06.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import "InsightEngine.h"
#import <stdlib.h>
#import "Featured.h"
#import "Business.h"
#import "Location.h"
#import "Template.h"
#import "Context.h"
#import "Tag.h"

@implementation InsightEngine

- (id)init
{
    if (self = [super init])
    {
        
    }
    return self;
}



+(InsightEngine*)sharedInsight
{
    static InsightEngine *sharedInsightObj = nil;    // static instance variable
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInsightObj = [[self alloc] init];
    });
    return sharedInsightObj;
}

-(NSString*)generateWelcomeTextForGPSdetectedMajor:(NSNumber*)major ChosenOffer:(Featured**)chosenOffer;
{
    Location *bizLocation=[Location getLocationByMajor:major Context:[Model sharedModel].managedObjectContext];
    return [self genereteWelcomeMessageForLocation:bizLocation ChosenOffer:chosenOffer];
}


-(NSString*)generateWelcomeTextForBeaconWithMajor: (NSNumber*)major andMinor:(NSNumber*)minor ChosenOffer:(Featured**)chosenOffer;
{
    Featured* tiedOffer=[Featured getOfferByMajor:major andMinor:minor Context:[Model sharedModel].managedObjectContext];
    
    if(tiedOffer)
    {
        *chosenOffer=tiedOffer;
        return tiedOffer.welcomeText;
    }
    else
    {
        Location *bizLocation=[Location getLocationByMajor:major Context:[Model sharedModel].managedObjectContext];
        return [self genereteWelcomeMessageForLocation:bizLocation ChosenOffer:chosenOffer];
    }
}

-(NSString*)genereteWelcomeMessageForLocation:(Location*)location ChosenOffer:(Featured**)chosenOffer
{
    Business* business=location.linkedBusiness;
    NSSet* activeOffers=[business getActiveOffers];
    
    Tag* chosenContextTag;
    Template* chosenTemplate;

    //check if we do have a business object that has active offers
    if(business && activeOffers && activeOffers.count!=0)
    {
        
        //get current contexts (interesting time, day, weather etc.)
        NSArray* activeContextTags=[Context getCurrentContextsForBusiness:business AtLocation:location Context:[Model sharedModel].managedObjectContext];
        
        
        if(activeContextTags && activeContextTags.count!=0)
        {
            
            NSMutableArray* contextTagsWithOffers=[NSMutableArray arrayWithCapacity:activeContextTags.count];
            NSMutableArray* offerArrays=[NSMutableArray arrayWithCapacity:activeContextTags.count];

            //find if there are offers for active contexts, get arrays of those offers
            for(Tag* contextTag in activeContextTags)
            {
                NSSet* offersForContext=[self findOffersFromSet:activeOffers ForContextTag:contextTag];
                if(offersForContext.count>0)
                {
                    [offerArrays addObject:offersForContext];
                    [contextTagsWithOffers addObject:contextTag];
                }
            }
            
            if(contextTagsWithOffers.count==0)
            {
                //no active contexts, choose based on relevancy
                *chosenOffer=[self chooseOfferMostlyByRelevancy:activeOffers];
            }
            else if(contextTagsWithOffers.count==1)
            {
                //one actve contexts with offers, choose it
                chosenContextTag=[contextTagsWithOffers firstObject];
                *chosenOffer=[self chooseOfferMostlyByRelevancy:[offerArrays firstObject]];
            }
            else if(contextTagsWithOffers.count>1)
            {
                //multiple active contexts with offers, randomly(with given probabilites) choose the one
                chosenContextTag  =[self chooseContextFromArray:contextTagsWithOffers];
                NSUInteger keyIndex=[contextTagsWithOffers indexOfObject:chosenContextTag];
                //choose offer for the active context, if there are more than one - use relevancy score
                *chosenOffer=[self chooseOfferMostlyByRelevancy:[offerArrays objectAtIndex:keyIndex]];
            }
        }
        //no contexts founds
        else
        {
            *chosenOffer=[self chooseOfferMostlyByRelevancy:activeOffers];
        }
        
        //choose random template from those that are attaached to the context
        if(chosenContextTag && chosenContextTag.linkedContextTemplates)
        {
            chosenTemplate=[[chosenContextTag.linkedContextTemplates allObjects] objectAtIndex:arc4random_uniform((short)chosenContextTag.linkedContextTemplates.count)];
        }
        //choose template unatached from tags
        else
        {
            NSArray* genericTemplates=[Template getGenericTemplatesForContext:[Model sharedModel].managedObjectContext];
            if(genericTemplates)
                chosenTemplate=genericTemplates[arc4random_uniform((short)genericTemplates.count)];
           // else
             //   NSLog(@"No generic templates found");
        }
        
        if(chosenTemplate)
            return [chosenTemplate generateMessageForOffer:*chosenOffer];
        else
            //no template
            return nil;

    }
    else
        //no active offers
        //TODO: show some kind of a default business message, not associated with offers
        return nil;
}


-(Featured*)chooseOfferMostlyByRelevancy:(NSSet*)offers
{
    if(offers.count==0 || offers.count==1)
        return [offers anyObject];
    
    //clean from 0 and negative relevancy scores
    NSMutableSet *offersClean=[NSMutableSet setWithSet:offers];
    Featured* result;

    double minNegScore=[Model sharedModel].min_negativeScore.doubleValue;
    //get a sum of relevancies
    double sum=0.0;
    NSMutableArray* offersWithoutRelevancy=[NSMutableArray arrayWithCapacity:offers.count];
    for(Featured* offer in offers)
    {
        if(offer.score.doubleValue>minNegScore)
        {
            if(offer.score.doubleValue>0.0)
                sum+=offer.score.doubleValue;
            else
            {
                [offersClean removeObject:offer];
                [offersWithoutRelevancy addObject:offer];
            }
        }
    }

    if(offersClean.count==0)
        return  result=[offersWithoutRelevancy objectAtIndex:arc4random_uniform((short)offersWithoutRelevancy.count)];

    //get a value of sum*value from settings for offers with no relevancies
    double minValue=sum*[Model sharedModel].prob_no_relev.doubleValue;
    
    //divide minvalue by number of offers with no relevancy
    
    double bound=0;
    if(offersWithoutRelevancy.count!=0)
        bound=minValue/offersWithoutRelevancy.count;
    
    //do a random select from 0 to sum of relevancies
    double random=drand48()*sum+bound;
    double cumulativeProbability = 0.0;
    
    
    //if it fell to the group do a random choice among members of that group
    if(random<bound)
       return  result=[offersWithoutRelevancy objectAtIndex:arc4random_uniform((short)offersWithoutRelevancy.count)];
    
    for(Featured* offer in offersClean)
    {
        cumulativeProbability += offer.score.doubleValue;
        if (random <= cumulativeProbability)
            result=offer;
    }
    return result;
}


-(NSSet*)findOffersFromSet:(NSSet*)offerList ForContextTag:(Tag*)contextTag
{
    NSMutableSet* offersForContext=[NSMutableSet setWithCapacity:offerList.count];
    //check if there are offers for the chosen context
    for (Featured* offer in offerList)
    {
        if([offer checkContextTag:contextTag])
            [offersForContext addObject:offer];
    }
    return offersForContext;
}

-(Tag*)chooseContextFromArray:(NSArray*)contexts
{
    double sum=0;
    for(Tag* contextTag in contexts)
        if(contextTag.linkedContext)
            sum+=contextTag.linkedContext.probability.doubleValue;
    double random=drand48()*sum;
    
    double cumulativeProbability = 0.0;
    for(Tag* contextTag in contexts)
    {
        if(contextTag.linkedContext)
        {
            cumulativeProbability += contextTag.linkedContext.probability.doubleValue;
            if (random <= cumulativeProbability)
                return contextTag;
        }
    }
    return nil;
}
    





@end
