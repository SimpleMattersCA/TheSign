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

@interface InsightEngine()

@property (strong) NSDictionary* contextTags;



@end


@implementation InsightEngine


static NSString* errorWelcomingMessage=@"";



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
    
    Template* template;

    //check if we do have a business object that has active offers
    if(business && activeOffers && activeOffers.count!=0)
    {
        
        //get current contexts (interesting time, day, weather etc.)
        NSArray* activeContextTags=[Context getCurrentContextsForBusiness:business AtLocation:location];
        
        
        if(activeContextTags && activeContextTags.count!=0)
        {
            Tag* chosenContextTag;
            
            NSMutableDictionary* activeContextsWithOffers=[NSMutableDictionary dictionaryWithCapacity:activeContextTags.count];
            
            //find if there are offers for active contexts, get arrays of those offers
            for(int i=0; i<activeContextTags.count;i++)
            {
                NSSet* offersForContext=[self findOffersFromSet:activeOffers ForContextTag:activeContextTags[i]];
                if(offersForContext.count>0)
                    [activeContextsWithOffers setObject:offersForContext forKey:@(i)];
            }
            
            
            
            if(activeContextsWithOffers.count>0)
            {
                
                if(activeContextsWithOffers.count>1)
                {
                    //choose the more appropriate context based on the probabilites
                }
                else
                {
                    id key = [[activeContextsWithOffers allKeys] objectAtIndex:0];
                    NSSet* offersForContext=[activeContextsWithOffers objectForKey:key];
                    
                    chosenContextTag=activeContextTags[((NSNumber*)key).intValue];
                }
                
                
            }
            else
            {
                //TODO: do the relevancy
            }
            
        
        }
        //no contexts founds
        else
        {
            // choose an active offer based on relevancy
            
        
        }
        
        
        
        if(template)
            return [template generateMessageForOffer:chosenOffer];
        else
            //no template
            return nil;

    }
    else
        //no active offers
        //TODO: show some kind of a default business message, not associated with offers
        return nil;
}


-(Featured*)chooseOfferMostlyByRelevancyFrom:(NSSet*)offers
{
    Featured* result;
    
//create a
    
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

  /*  double p = Math.random();
    double cumulativeProbability = 0.0;
    for (Item item : items) {
        cumulativeProbability += item.probability();
        if (p <= cumulativeProbability) {
            return item;
        }
    }*/
    





@end
