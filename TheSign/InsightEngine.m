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
#import "Relevancy.h"

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

-(NSString*)generateWelcomeTextForGPSdetectedMajor:(NSNumber*)major
{
    Location *bizLocation=[Location getLocationByMajor:major];
    return [self genereteWelcomeMessageForLocation:bizLocation];
}


-(NSString*)generateWelcomeTextForBeaconWithMajor: (NSNumber*)major andMinor:(NSNumber*)minor
{
    Featured* tiedOffer=[Featured getOfferByMajor:major andMinor:minor];
    
    if(!tiedOffer)
        return tiedOffer.welcomeText;
    else
    {
        Location *bizLocation=[Location getLocationByMajor:major];
        return [self genereteWelcomeMessageForLocation:bizLocation];
    }
}

-(NSString*)genereteWelcomeMessageForLocation:(Location*)location
{
    Business* business=location.linkedBusiness;
    NSSet* activeOffers=[business getActiveOffers];
    
    Featured* chosenOffer;
    Tag* chosenContextTag;
    Template* chosenTemplate;

    //check if we do have a business object that has active offers
    if(business && activeOffers && activeOffers.count!=0)
    {
        
        //get current contexts (interesting time, day, weather etc.)
        NSArray* activeContextTags=[Context getCurrentContextsForBusiness:business AtLocation:location];
        
        
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
            
            if(contextTagsWithOffers.count>0)
            {
                //multiple active contexts with offers, randomly(with given probabilites) choose the one
                if(contextTagsWithOffers.count>1)
                    chosenContextTag  =[self chooseContextFromArray:contextTagsWithOffers];
                //one actve contexts with offers, choose it
                else
                    chosenContextTag=[contextTagsWithOffers firstObject];

                //choose offer for the active context, if there are more than one - use relevancy score
                NSUInteger keyIndex=[contextTagsWithOffers indexOfObject:chosenContextTag];
                chosenOffer=[self chooseOfferMostlyByRelevancy:[offerArrays objectAtIndex:keyIndex]];
            }
            else
            {
                //no active contexts, choose based on relevancy
                chosenOffer=[self chooseOfferMostlyByRelevancy:activeOffers];
            }
        }
        //no contexts founds
        else
        {
            chosenOffer=[self chooseOfferMostlyByRelevancy:activeOffers];
        }
        
        //choose random template from those that are attaached to the context
        if(chosenContextTag && chosenContextTag.linkedContextTemplates)
        {
            chosenTemplate=[[chosenContextTag.linkedContextTemplates allObjects] objectAtIndex:arc4random_uniform((short)chosenContextTag.linkedContextTemplates.count)];
        }
        //choose template unatached from tags
        else
        {
            NSArray* genericTemplates=[Template getGenericTemplates];
            if(genericTemplates)
                chosenTemplate=genericTemplates[arc4random_uniform((short)genericTemplates.count)];
            else
                NSLog(@"No generic templates found");
        }
        
        if(chosenTemplate)
            return [chosenTemplate generateMessageForOffer:chosenOffer];
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
    Featured* result;

    //get a sum of relevancies
    double sum=0;
    NSMutableArray* offersWithoutRelevancy=[NSMutableArray arrayWithCapacity:offers.count];
    for(Featured* offer in offers)
    {
        if(offer.linkedScore)
            sum+=offer.linkedScore.score.doubleValue;
        else
            [offersWithoutRelevancy addObject:offer];
    }

    //get a value of sum*value from settings for offers with no relevancies
    double minValue=sum*[Model sharedModel].settings.minProb.doubleValue;
    
    //divide minvalue by number of offers with no relevancy
    double bound=minValue/offersWithoutRelevancy.count;
    
    //do a random select from 0 to sum of relevancies
    double random=drand48()*sum+bound;
    double cumulativeProbability = 0.0;
    
    for(Featured* offer in offers)
    {
        cumulativeProbability += offer.linkedScore.score.doubleValue;
        if (random <= cumulativeProbability)
            result=offer;
        //if it fell to the group do a random choice among members of that group
        else if(random<bound)
            result=[offersWithoutRelevancy objectAtIndex:arc4random_uniform((short)offersWithoutRelevancy.count)];
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
