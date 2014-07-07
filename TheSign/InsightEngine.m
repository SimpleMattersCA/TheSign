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

    //Choose between sentece types not randomly but based on what could be more relevant
    if(business && activeOffers && activeOffers.count!=0)
    {
        
        //get current contexts (interesting time, day, weather etc.)
        NSArray* activeContexts=[Context getCurrentContextsForBusiness:business AtLocation:location];
        
        
        if(activeContexts && activeContexts.count!=0)
        {
            Tag* chosenContextTag;
            
            if(activeContexts.count>1)
            {
                //roll the dice
                
                //check if there are offers for the chosen context
                
                //if there are more than one offer for context, choose one based on relevancy
                
            }
            else
            {
                chosenContextTag=activeContexts.firstObject;
                //check if there are offers for the chosen context
                
                //if there are more than one offer for context, choose one based on relevancy

            }
            
            if(chosenContextTag)
            {
                //choose template for context tag
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
        return nil;
}


-(Featured*)chooseOfferMostlyByRelevancyFrom:(NSSet*)offers
{
    Featured* result;
    
    
    
    return result;
}



-(NSDictionary*)chooseMessageTypeAndDealForBusiness:(Business*)business
                                       ActiveOffers:(NSSet*)activeOffers
                                        AtLocation:(Location*)location
{
    NSNumber* chosenType;
    Featured* chosenDeal;

    //check the date

    NSString *dayID;
    NSString *timeID;
    NSString *weatherID;
    
    
    NSMutableSet* currentContextTags=[NSMutableSet set];
    
    
    
 
    
    double prefProb=[Model sharedModel].settings.prob_pref.doubleValue;
    
    NSMutableSet* weatherOffers=[NSMutableSet set];
    NSMutableSet* timeOffers=[NSMutableSet set];
    NSMutableSet* dayOffers=[NSMutableSet set];
    
    int random=arc4random_uniform(10);
    
    
    if(random>prefProb && currentContextTags.count!=0)
    {
        //try the context message
        //find active offers suitable for the current context

        for (Featured* offer in activeOffers)
        {
                //TODO: check if checContextTags works better
                
                //find which of the current context tags are connected to the offer
                NSSet* foundTags=[offer findContextTags:currentContextTags];
                
        
        }
        
        
        //if no offers for the context were found
        if (dayOffers.count==0 && timeOffers.count==0 && weatherOffers.count==0)
        {
          
        }
        else
        {
            //we gotta choose the context based on the probability setting
            //we doll the dice and if the chosen context doesn't have offers to show we move to the next one
          
            
            
            
            NSSet* chosenSet;
          
        }
        
    }
    else
    {
        
    }
    
    double p = Math.random();
    double cumulativeProbability = 0.0;
    for (Item item : items) {
        cumulativeProbability += item.probability();
        if (p <= cumulativeProbability) {
            return item;
        }
    }
    
    
  
    
    return [NSDictionary dictionaryWithObjects:@[chosenType,chosenDeal] forKeys:@[@"Type",@"Deal"]];
}








-(NSString*)generateGreeting
{
    NSArray *greetingOptions=[NSArray arrayWithObjects:@"Hi there!",@"Hello stranger!",@"Hi!",@"Hey!", nil];

    int random=arc4random_uniform((short)greetingOptions.count);
    return greetingOptions[random];
}





@end
