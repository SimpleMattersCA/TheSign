//
//  InsightEngine.m
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-05-06.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import "InsightEngine.h"
#import <stdlib.h>

@implementation InsightEngine

int arch4random_uniform();

+(NSString*)generateWelcomeTextForBeaconWithMajor: (NSNumber*)major andMinor:(NSNumber*)minor
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
            
            //1. choose the right offer
            chosenOffer=[self chooseTheRightOfferFrom:featuredOffers];
            
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


+(NSString*)doWeatherMessageForOffer:(Featured*)deal
{
    NSString *result;
    
    
    return result;

}

+(NSString*)doStatisticsMessageForOffer:(Featured*)deal
{
    NSString *result;
    
    
    return result;
    
}


+(NSString*)doFavouritesMessageForOffer:(Featured*)deal
{
    NSString *result;
    
    
    return result;
    
}
    
+(NSString*)doTimeMessageForOffer:(Featured*)deal
{
    NSString *result;
    
    
    
    return result;
    
}

+(NSString*)doDateMessageForOffer:(Featured*)deal
{
    NSString *result;
    
    
    return result;
    
}

//returning the most relevant offer for the client at this moment
+(Featured*)chooseTheRightOfferFrom:(NSArray*)offerArray
{
    Featured *result;
    
    //for now, take randomly
    int offerId=arch4random_uniform()*offerArray.count;
    result=offerArray[offerId];
    
    
    return result;
}

+(NSString*)generateGreeting
{
    NSArray *greetingOptions=[NSArray arrayWithObjects:@"Hi there!",@"Hello stranger!",@"Hi!",@"Hey!", nil];
    int random=arch4random_uniform()*greetingOptions.count;
    return greetingOptions[random];
}





@end
