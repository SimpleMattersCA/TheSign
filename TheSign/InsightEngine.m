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
    SW_Fog,
    
    SW_Average
};

typedef NS_ENUM(NSInteger, SignTime) {
    ST_Morning,
    ST_Lunch,
    ST_Evening,
    ST_Night,
    
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


@property NSDate* neYearsEve;
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
@property NSDate* boxingDay;

@end


@implementation InsightEngine

static NSString* errorWelcomingMessage=@"";

-(void)initializeDates
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:2014];
    
    
    
    
    [components setDay:1];
    [components setMonth:1];
    self.neYearsEve=[calendar dateFromComponents:components];
    [components setDay:17];
    [components setMonth:2];
    self.familyDay=[calendar dateFromComponents:components];
    
    [components setDay:25];
    [components setMonth:12];
    self.christmass=[calendar dateFromComponents:components];
    
    

}

- (id)init
{
    if (self = [super init])
    {
        [self initializeDates];
        
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
            NSDictionary* result=[self chooseTheRightMessageTypeAndDeal];
            chosenOffer=[result objectForKey:@"Deal"];
            NSNumber* messageType=[result objectForKey:@"Type"];
            NSNumber* messageKind=[result objectForKey:@"Kind"];
            
            //2. prepare the sentence
            switch (messageType.integerValue) {
                case S_Weather:
                    [self doWeatherMessageForOffer:chosenOffer AndConditionType:messageKind.integerValue];
                    break;
                case S_Time:
                    [self doTimeMessageForOffer:chosenOffer AndConditionType:messageKind.integerValue];
                    break;
                case S_Day:
                    [self doDateMessageForOffer:chosenOffer AndConditionType:messageKind.integerValue];
                    break;
                case S_Preference:
                    [self doPreferencesMessageForOffer:chosenOffer AndConditionType:messageKind.integerValue];
                    break;
                default:
                    NSLog(@"Unrecognized message type");
            }
            
        
        }
        //generate "store is closed" message
        else
        {
#warning working hours, days should be accounted
            //show working hours
            result=[NSString stringWithFormat:@"Sorry but %@ is closed, see you next time!", bTitle];
        }
    }
    
    return result;
}


-(NSString*)doWeatherMessageForOffer:(Featured*)deal AndConditionType:(SignWeather)type
{
    switch (type) {
        case SW_Cold:
            return @"";
        case SW_Hot:
            return @"";
        case SW_Rain:
            return @"";
        case SW_Fog:
            return @"";
        case SW_Snow:
            return @"";
        case SW_Wind:
            return @"";
        default:
            return errorWelcomingMessage;
    }
}


-(NSString*)doPreferencesMessageForOffer:(Featured*)deal AndConditionType:(SignPreference)type
{
    NSString *result;
    
    
    return result;
    
}
    
-(NSString*)doTimeMessageForOffer:(Featured*)deal AndConditionType:(SignTime)type
{
    switch (type) {
        case ST_Morning:
            return @"";
        case ST_Lunch:
            return @"";
        case ST_Evening:
            return @"";
        case ST_Night:
            return @"";
        default:
            return errorWelcomingMessage;
    }
}

-(NSString*)doDateMessageForOffer:(Featured*)deal AndConditionType:(SignDay)type
{
    switch (type) {
        case SD_Monday:
            return @"";
        case SD_Friday:
            return @"";
        case SD_Workday:
            return @"";
        case SD_Weekend:
            return @"";
        case SD_ChristmasDay:
            return @"";
        default:
            return errorWelcomingMessage;
    }
}


-(NSDictionary*)chooseTheRightMessageTypeAndDeal
{
    SentenceType type;
    NSInteger chosenMessage;
    Featured* chosenDeal;
    
    
    NSMutableDictionary *topics=[NSMutableDictionary dictionaryWithObject:@(S_Preference) forKey:@(S_Preference)];
    
    //check the date
    SignDay day=[self getRelevantDay];
    if (day!=SD_Average) [topics setObject:@(S_Day) forKey:@(day)];
    
    //check the time
    SignTime time=[self getRelevantTime];
    if (time!=ST_Average) [topics setObject:@(S_Time) forKey:@(time)];
    
    //check the significant weather
    SignWeather weather=[self getRelevantWeather];
    if (weather!=SW_Average) [topics setObject:@(S_Weather) forKey:@(weather)];

    
    int random=arc4random_uniform((short)topics.count);
    
    
    return [NSDictionary dictionaryWithObjects:@[@(type),@(chosenMessage),chosenDeal] forKeys:@[@"Type",@"Kind",@"Deal"]];
}

-(SignTime) getRelevantTime
{
    SignTime time=ST_Average;
    //get current time
    NSDateComponents *nowComp = [[NSCalendar currentCalendar] components:(NSHourCalendarUnit)  fromDate:[NSDate date]];
    
    if (nowComp.hour>=7 && nowComp.hour<9) time=ST_Morning;
    if (nowComp.hour>=12 && nowComp.hour<13) time=ST_Lunch;
    if (nowComp.hour>=16 && nowComp.hour<20) time=ST_Evening;
    if (nowComp.hour>=20 && nowComp.hour<23) time=ST_Night;
    
    return time;
}

-(SignWeather) getRelevantWeather
{
    SignWeather weather=SW_Average;
    
    //get current weather
    NSString* curWeather=[[Model sharedModel] currentWeather];
    NSNumber* curTemperature=[[Model sharedModel] currentTemperature];
    
    if(curTemperature.integerValue < 10) weather=SW_Cold;
    if(curTemperature.integerValue > 25) weather=SW_Hot;
    
    if([curWeather isEqualToString:@"rain"]) weather=SW_Rain;
    if([curWeather isEqualToString:@"wind"]) weather=SW_Wind;
    if([curWeather isEqualToString:@"snow"]) weather=SW_Snow;
    if([curWeather isEqualToString:@"fog"]) weather=SW_Fog;

    return weather;
}


-(SignPreference) getRelevantPreference
{
    SignPreference preference=SP_Weak;
    
    
    
    return preference;
    
}

-(SignDay) getRelevantDay
{
    SignDay date=SD_Average;
    
    NSCalendar *calendar=[NSCalendar currentCalendar];
    NSDate *rightNow=[NSDate date];
    
    NSDateComponents *nowYMD = [calendar components:(NSDayCalendarUnit | NSWeekdayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit)  fromDate:rightNow];
    
    //1-Sunday, 2-Monday..
    NSInteger dayOfWeek=nowYMD.weekday;
    
    if(dayOfWeek==1 || dayOfWeek==7)
        date=SD_Weekend;
    else
        date=dayOfWeek==2?SD_Monday:SD_Workday;
    
    if([[nowYMD date] isEqual:self.christmass]) date=SD_ChristmasDay;
   //....
#warning finish conditions for days

    
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
#warning verify the list of greetings
    int random=arc4random_uniform((short)greetingOptions.count);
    return greetingOptions[random];
}





@end
