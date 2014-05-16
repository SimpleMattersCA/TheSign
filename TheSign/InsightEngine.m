//
//  InsightEngine.m
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-05-06.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import "InsightEngine.h"

@implementation InsightEngine


+(NSString*)generateWelcomeTextForBeaconWithMajor: (NSNumber*)major andMinor:(NSNumber*)minor
{
    NSString* result=@"";
    NSArray* featuredOffers=[[Model sharedModel] getOffersByMajor:major andMinor:minor];
    
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
            
            //2. prepare the sentence
            
            
        
        }
        //generate "store is closed" message
        else
        {
#pragma mark - of course this should be smarter than this, treat is as a placeholders
            result=[NSString stringWithFormat:@"Sorry but %@ is closed, see you next time!", bTitle];
        }
        
        
    
   
    
    
    return result;
}




@end
