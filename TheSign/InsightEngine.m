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
    
    //just days
    SD_Monday,
    SD_Friday,
    SD_Weekend,
    SD_Workday,
    SD_Average
};

typedef NS_ENUM(NSInteger, SignWeather) {
    //temperature
    SW_Cold,
    SW_Hot,
    //conditions
    SW_Rain,
    SW_Snow,
    SW_Wind,
    
    SW_Average
};

typedef NS_ENUM(NSInteger, SignTime) {
    ST_Morning,
    ST_Lunch,
    ST_Evening,
    
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


@interface InsightEngine()

@property NSDate* christmass;
@property NSDate* newYear;



@end


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


-(NSString*)generateWelcomeTextForBeaconWithMajor: (NSNumber*)major andMinor:(NSNumber*)minor
{
    NSString* result=@"";
    Featured* chosenOffer;
    NSArray* featuredOffers=[Featured getOffersByMajor:major andMinor:minor];
    
#pragma mark Choose between sentece types not randomly but based on what could be more relevant
    
    if(featuredOffers!=nil && featuredOffers.count!=0)
    {
        //all offers share the same business so we pick the first one just to get its business hours
        NSString *bTitle=((Featured*)featuredOffers[0]).parentBusiness.name;
        NSNumber *bOpen=((Featured*)featuredOffers[0]).parentBusiness.workingHoursStart;
        NSNumber *bClose=((Featured*)featuredOffers[0]).parentBusiness.workingHoursEnd;
        
        NSDate *curDate=[NSDate date];
        #pragma mark - what if the user set monday as the first day in the calendar?
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSWeekCalendarUnit)  fromDate:curDate];
        NSInteger hour = [components hour];
        NSInteger minute = [components minute];
     //   NSInteger day=[components weekday];
        NSInteger curTime=hour*100+minute;
        
        
#pragma mark - this is fucking wrong, we gotta check when do they work, like what if they work on weekends?
        //BOOL isFriday=day==6?YES:NO;
        
        //if the store is open right now
        if (curTime<bClose.integerValue && curTime>=bOpen.integerValue)
        {
            
            //1. choose the right sentence type and deal
            SentenceType type=[self chooseTheRightMessageType:chosenOffer];
            
            //2. prepare the sentence
            
            
            
            
            
        
        }
        //generate "store is closed" message
        else
        {
#pragma mark - of course this should be smarter than this, treat is as a placeholders
            //show working hours
            result=[NSString stringWithFormat:@"Sorry but %@ is closed, see you next time!", bTitle];
        }
        
        
    }
   
    
    
    return result;
}


-(NSString*)doWeatherMessageForOffer:(Featured*)deal
{
    NSString *result;
    
    
    return result;

}


-(NSString*)doPreferencesMessageForOffer:(Featured*)deal
{
    NSString *result;
    
    
    return result;
    
}
    
-(NSString*)doTimeMessageForOffer:(Featured*)deal
{
    NSString *result;
    
    //morning, lunch, evening
    
    return result;
    
}

-(NSString*)doDateMessageForOffer:(Featured*)deal
{
    NSString *result;
    
    
    return result;
    
}


-(SentenceType)chooseTheRightMessageTypeAndDeal:(Featured**)deal
{
    SentenceType type;
    
    
    
    
    NSMutableDictionary *topics=[NSMutableDictionary dictionaryWithObject:@(S_Preference) forKey:@(S_Preference)];
    
    //check the date
    SignDay day=[self getRelevantDay];
    if (day!=SD_Average) [topics addObject:@(day)];
    //check the time
    
    //check the significant weather
    
    
    
    return type;
}

-(SignPreference) getRelevantPreference
{
    //check the preference map the deal

}

-(SignDay) getRelevantDay
{
    SignDay date=SD_Average;
    NSDate *now=[NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *nowComp = [calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit)  fromDate:now];

    NSDateComponents *christmasComp = [[NSDateComponents alloc] init];
    [christmasComp setDay:25];
    [christmasComp setMonth:11];
    [christmasComp setYear:2014];
    
    if([[nowComp date] isEqual:[christmasComp date]])
    {
        date=SD_ChristmasDay;
        NSLog(@"herro");
    }
    return date;
}



//returning the most relevant offer for the client at this moment
/*-(Featured*)chooseTheRightOfferFrom:(NSArray*)offerArray ForType:(SentenceType)type
{
    Featured *result;
    
    //for now, take randomly
    //int offerId=arc4random_uniform(offerArray.count);
    //result=offerArray[offerId];
    //get the preference cloud of tags
    
    //get tags for the offer
    
    
    return result;
}*/

-(NSString*)generateGreeting
{
    NSArray *greetingOptions=[NSArray arrayWithObjects:@"Hi there!",@"Hello stranger!",@"Hi!",@"Hey!", nil];
    int random=arc4random_uniform(greetingOptions.count);
    return greetingOptions[random];
}





@end
