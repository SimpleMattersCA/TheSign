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

typedef NS_ENUM(NSInteger, ContextType) {

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
};


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

/*-(NSDictionary*)getContextTags
{
    if(!_contextTags)
        _contextTags=[NSDictionary dictionaryWithObjectsAndKeys:
                      //weather
                      coldID,@(SW_Cold),
                      hotID, @(SW_Hot),
                      rainID,@(SW_Rain),
                      snowID,@(SW_Snow),
                      windID,@(SW_Wind),
                      fogID,@(SW_Fog),
                      //days
                      mondayID,@(SD_Monday),
                      fridayID,@(SD_Friday),
                      weekendID,@(SD_Weekend),
                      //time
                      morningID,@(ST_Morning),
                      lunchID,@(ST_Lunch),
                      eveniningID,@(ST_Evening),
                      nightID,@(ST_Night),
                      nil];
    return _contextTags;
}


//Weather tags
static NSString* coldID=@"lq53DDaSkx";
static NSString* hotID=@"kapvg3HpLv";
static NSString* rainID=@"CGo2KPmG44";
static NSString* snowID=@"2Vtif88YHS";
static NSString* windID=@"dVcxeUzmdo";
static NSString* fogID=@"mnVoJmYxF4";

//Day tags
static NSString* mondayID=@"X9ahhTB27z";
static NSString* fridayID=@"jjJYKezo8o";
//static NSString* workdayID=@"c5rKtcLi0K";
static NSString* weekendID=@"4cUeoBJRYM";

//Time tags
static NSString* morningID=@"DRZH7qbdS4";
static NSString* lunchID=@"GtjXt8bbfK";
static NSString* eveniningID=@"GwSMXMuCdo";
static NSString* nightID=@"bWzDDLJO5C";


*/

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
    NSString* result=@"";
    
    Business* business=location.linkedBusiness;
    NSSet* activeOffers=[business getActiveOffers];
    //Choose between sentece types not randomly but based on what could be more relevant
    if(business && activeOffers && activeOffers.count!=0)
    {
        
        //1. choose the right sentence type and deal
        NSDictionary* result=[self chooseMessageTypeAndDealForBusiness:business ActiveOffers:activeOffers AtLocation:location];
        Featured* chosenOffer=[result objectForKey:@"Deal"];
        NSNumber* messageType=[result objectForKey:@"Type"];
        
        //2. prepare the sentence
        switch (messageType.integerValue) {
            case SW_Cold:
            
                break;
        
            case SW_Hot:
                
                break;
                
            case SW_Rain:
                
                break;
                
            case SW_Snow:
                
                break;
                
            case SW_Wind:
                
                break;
                
            case SW_Fog:
                
                break;
                
            case ST_Morning:
                
                break;
                
            case ST_Lunch:
                
                break;
                
            case ST_Evening:
                
                break;
                
            case ST_Night:
                
                break;
                
            case SD_Monday:
                
                break;
                
            case SD_Friday:
                
                break;
                
            case SD_Weekend:
                
                break;
             
            case SP_Preference:
                
                break;
                
            default:
                NSLog(@"Unrecognized message type");
        }
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
    
    double weatherProb=[Model sharedModel].settings.prob_weather.doubleValue;
    double timeProb=[Model sharedModel].settings.prob_time.doubleValue;
    double dayProb=[Model sharedModel].settings.prob_date.doubleValue;

    
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
          
            
            //***********   LOOKS UGLY, NEEDS REWRITING ***********//
            
            int contextRandom=arc4random_uniform(100);
            
            if(contextRandom<=weatherProb*100)
                //do weather
            if(contextRandom<=weatherProb+)
            
            //*****************************************************//
            
            
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




-(ContextType) getRelevantTime
{
    ContextType time=No_Context;
    //get current time
    NSDateComponents *nowComp = [[NSCalendar currentCalendar] components:(NSHourCalendarUnit)  fromDate:[NSDate date]];
    
    if (nowComp.hour>=7 && nowComp.hour<9) time=ST_Morning;
    if (nowComp.hour>=12 && nowComp.hour<13) time=ST_Lunch;
    if (nowComp.hour>=16 && nowComp.hour<20) time=ST_Evening;
    if (nowComp.hour>=20 && nowComp.hour<23) time=ST_Night;
    
    return time;
}

-(ContextType) getRelevantWeatherAtLocation:(Location*)location
{
    ContextType weather=No_Context;
    
    //get current weather
    if(location.linkedArea)
    {
        NSString* curWeather=location.linkedArea.currentWeather;
        NSNumber* curTemperature=location.linkedArea.currentTemperature;

        if(curTemperature.integerValue < 10) weather=SW_Cold;
        if(curTemperature.integerValue > 25) weather=SW_Hot;

        if([curWeather isEqualToString:@"wind"]) weather=SW_Wind;
        if([curWeather isEqualToString:@"rain"]) weather=SW_Rain;
        if([curWeather isEqualToString:@"snow"]) weather=SW_Snow;
        if([curWeather isEqualToString:@"fog"]) weather=SW_Fog;
    }
    return weather;
}

-(ContextType) getRelevantDay
{
    ContextType date=No_Context;
    
    NSCalendar *calendar=[NSCalendar currentCalendar];
    NSDate *rightNow=[NSDate date];
    
    NSDateComponents *nowYMD = [calendar components:(NSDayCalendarUnit | NSWeekdayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit)  fromDate:rightNow];
    
    //1-Sunday, 2-Monday..
    NSInteger dayOfWeek=nowYMD.weekday;
    
    switch (dayOfWeek) {
        case 1:
            date=SD_Weekend;
            break;
        case 2:
            date=SD_Monday;
            break;
        case 7:
            date=SD_Weekend;
            break;
    }
 
    
   // if([[nowYMD date] isEqual:self.christmass]) date=SD_ChristmasDay;
   //....
    
    return date;
}




-(NSString*)generateGreeting
{
    NSArray *greetingOptions=[NSArray arrayWithObjects:@"Hi there!",@"Hello stranger!",@"Hi!",@"Hey!", nil];

    int random=arc4random_uniform((short)greetingOptions.count);
    return greetingOptions[random];
}





@end
