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
/*typedef NS_ENUM(NSInteger, ContextType) {

    //days
    SD_Monday,
    SD_Friday,
    SD_Weekend,
    
    //temperature
    SW_Cold,
    SW_Hot,
    //conditions
    SW_Rain,
    SW_Snow,
    SW_Wind,
    SW_Fog,
    
    //time
    ST_Morning,
    ST_Lunch,
    ST_Evening,
    ST_Night,
    
    SP_Preference,
    
    No_Context
};*/


/*
typedef NS_ENUM(NSInteger, SignDay) {
    
    
    
    //stat holidays
     SD_NewYear,
     SD_FamilyDay,
     SD_StPatricsDay,
     SD_Easter,
     SD_VictoriaDay,
     SD_CanadaDay,
     SD_Thanksgiving,
     SD_RemembranceDay,
     SD_LabourDay,
     SD_ChristmasDay,
     SD_BoxingDay,
 
    //Seasons
     SD_FirstDayWinter,
     SD_FirstDayFall,
     SD_FirstDaySummer,
     SD_FirstDaySpring,

};

typedef NS_ENUM(NSInteger, SignWeather) {
   
    
    SW_Average
};

typedef NS_ENUM(NSInteger, SignTime) {

    ST_Average
};

typedef NS_ENUM(NSInteger, SignPreference) {
    //deals are weakly related
    SP_Weak,
    //deals are related
    SP_Strong,
    //deals are matching
    SP_Match
};
*/

@interface InsightEngine()

@property (strong) NSDictionary* contextTags;

/*@property NSDate* nYearsEve;
@property NSDate* familyDay;
@property NSDate* valentinesDay;
@property NSDate* stPatricsDay;
@property NSDate* goodFriday;
@property NSDate* easterMonday;
@property NSDate* mothersDay;
@property NSDate* victoriaDay;
@property NSDate* fathersDay;
@property NSDate* canadaDay;
@property NSDate* labourDay;
@property NSDate* thanksgiving;
@property NSDate* halloween;
@property NSDate* remembrancesDay;
@property NSDate* christmass;
@property NSDate* boxingDay;*/

@end


@implementation InsightEngine


static NSString* errorWelcomingMessage=@"";

/*-(void)initDates
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:2014];
    
    
    
    
    [components setDay:1];
    [components setMonth:1];
    self.nYearsEve=[calendar dateFromComponents:components];
    [components setDay:17];
    [components setMonth:2];
    self.familyDay=[calendar dateFromComponents:components];
    
    [components setDay:25];
    [components setMonth:12];
    self.christmass=[calendar dateFromComponents:components];
    
    

}*/


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
    NSString* result;
    
    Business* business=location.linkedBusiness;
    NSSet* activeOffers=[business getActiveOffers];
    //Choose between sentece types not randomly but based on what could be more relevant
    if(business && activeOffers && activeOffers.count!=0)
    {
        
        
        
        //1. choose the right sentence type and deal
        NSDictionary* result=[self chooseMessageTypeAndDealForBusiness:business ActiveOffers:activeOffers AtLocation:location];
        Featured* chosenOffer=[result objectForKey:@"Deal"];
        NSNumber* messageType=[result objectForKey:@"Type"];
        
        
        
#warning empty template
        Template* template;
        return [template generateMessageForOffer:chosenOffer];
        //2. prepare the sentence
    }
    
    return result;

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
    ContextType day=[self getRelevantDay];
    ContextType time=[self getRelevantTime];
    ContextType weather=[self getRelevantWeatherAtLocation:location];
    
    NSString *dayID;
    NSString *timeID;
    NSString *weatherID;
    
    
    NSMutableSet* currentContextTags=[NSMutableSet set];
    
    
    if(day!=No_Context)
    {
        dayID=[self.contextTags objectForKey:@(day)];
        [currentContextTags addObject:dayID];
    }
    if(time!=No_Context)
    {
        timeID=[self.contextTags objectForKey:@(time)];
        [currentContextTags addObject:timeID];
        
    }
    if(weather!=No_Context)
    {
        weatherID=[self.contextTags objectForKey:@(weather)];
        [currentContextTags addObject:weatherID];
        
    }
    
 
    
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
                
                //add offer to an appropriate list
                if (dayID && [foundTags containsObject:dayID])
                {
                    [dayOffers addObject:offer];
                }
                if (timeID && [foundTags containsObject:timeID])
                {
                    [timeOffers addObject:offer];
                }
                
                if (weatherID && [foundTags containsObject:weatherID])
                {
                    [weatherOffers addObject:offer];
                }
            
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
