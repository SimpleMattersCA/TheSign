//
//  Context.m
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-07-04.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import "Context.h"
#import "Featured.h"
#import "Tag.h"
#import "Model.h"
#import "Location.h"

#define P_NAME (@"name")
#define P_PROBABILITY (@"probability")

#define CD_NAME (@"name")
#define CD_PROBABILITY (@"probability")

@implementation Context

@dynamic pObjectID;
@dynamic name;
@dynamic probability;
@dynamic linkedTags;




#pragma mark - Sign Entity Protocol

@synthesize parseObject=_parseObject;

-(PFObject*)parseObject
{
    if(!_parseObject)
    {
        NSError *error;
        if(!error)
            _parseObject=[PFQuery getObjectOfClass:[Context parseEntityName] objectId:self.pObjectID error:&error];
        else
            NSLog(@"%@",[error localizedDescription]);
    }
    return _parseObject;
}

+(NSString*) entityName {return @"Context";}
+(NSString*) parseEntityName {return @"Context";}

+(Boolean)checkIfParseObjectRight:(PFObject*)object
{
    if(object[P_NAME] && object[P_PROBABILITY])
        return YES;
    else
        return NO;
}

+(Context*) getByID:(NSString*)identifier Context:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[Context entityName]];
    request.predicate=[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@=='%@'", OBJECT_ID, identifier]];
    NSError *error;
    NSArray *result = [context executeFetchRequest:request error:&error];
    
    if(error)
    {
        NSLog(@"%@",[error localizedDescription]);
        return nil;
    }
    else
        return result.firstObject;
}


+ (Boolean)createFromParse:(PFObject *)object Context:(NSManagedObjectContext *)context
{
    if([self checkIfParseObjectRight:object]==NO)
    {
        NSLog(@"%@: The object %@ is missing mandatory fields",[Context entityName],object.objectId);
        return NO;
    }
    
    Boolean complete=YES;

    Context *newContext = [NSEntityDescription insertNewObjectForEntityForName:[Context entityName]
                                             inManagedObjectContext:context];
    newContext.pObjectID=object.objectId;
    newContext.name=object[P_NAME];
    newContext.probability=object[P_PROBABILITY];
    
    return complete;

}

-(Boolean)refreshFromParseForContext:(NSManagedObjectContext *)context
{
    if(!self.parseObject)
    {
        NSLog(@"%@: Couldn't fetch the parse object with id: %@",[Context entityName],self.pObjectID);
        return NO;
    }
    
    if([self.class checkIfParseObjectRight:self.parseObject]==NO)
    {
        NSLog(@"The object %@ is missing mandatory fields",self.parseObject.objectId);
        return NO;
    }
    
    Boolean complete=YES;

    self.name=self.parseObject[P_NAME];
    self.probability=self.parseObject[P_PROBABILITY];
    
    return complete;
}

+(NSInteger)getRowCountForContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[Context entityName]];
    NSError *error;
    NSInteger result = [context countForFetchRequest:request error:&error];
    
    if(error)
    {
        NSLog(@"%@",[error localizedDescription]);
        return 0;
    }
    else
        return result;
}

-(Tag*)getContextTagByName:(NSString*)name;
{
    if(self.linkedTags)
    {
        for(Tag* tag in self.linkedTags)
            if([tag.name isEqualToString:name])
                return tag;
    }
    return nil;
}


+(NSArray*)getCurrentContextsForBusiness:(Business*)business AtLocation:(Location*)location Context:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[Context entityName]];
    NSError *error;
    NSArray *fetchedContexts = [context executeFetchRequest:request error:&error];
    
    if(error)
    {
        NSLog(@"%@",[error localizedDescription]);
        return nil;
    }
    
    NSMutableArray* currentContexts=[NSMutableArray arrayWithCapacity:fetchedContexts.count];
    Tag* contextTag;
    for(Context *context in fetchedContexts)
    {
        if([context.name isEqualToString:@"weather"])
        {
            contextTag=[context getWeatherAtLocation:location];
            if(contextTag)
                [currentContexts addObject:contextTag];
                
        }
        else if([context.name isEqualToString:@"dayOfTheWeek"])
        {
            contextTag=[context getDayOfTheWeek];
            if(contextTag)
                [currentContexts addObject:contextTag];
        }
        else if([context.name isEqualToString:@"time"])
        {
            contextTag=[context getTime];
            if(contextTag)
                [currentContexts addObject:contextTag];
        }
    }
    
    
    return currentContexts;
}

-(Tag*)getWeatherAtLocation:(Location*)location
{
    Tag* contextTagTemp;
    Tag* contextTagWeather;
    NSString* curWeather=[location getWeather];
    NSNumber* curTemperature=[location getTemperature];
    NSDate* weatherTime=[location getWeatherTime];
    NSTimeInterval diff = [weatherTime timeIntervalSinceNow];
    double weatherPoll=[Model sharedModel].weather_poll.doubleValue;
    if(fabs(diff)>weatherPoll)
        return nil;
    
    
    
    if(curTemperature.integerValue < 10)
        contextTagTemp=[self getContextTagByName:@"Cold Weather"];
    else if(curTemperature.integerValue > 22)
        contextTagTemp=[self getContextTagByName:@"Hot Weather"];
    
    if([curWeather isEqualToString:@"wind"])
        contextTagWeather=[self getContextTagByName:@"Wind"];
    else if([curWeather isEqualToString:@"rain"])
        contextTagWeather=[self getContextTagByName:@"Rain"];
    else if([curWeather isEqualToString:@"snow"])
        contextTagWeather=[self getContextTagByName:@"Snow"];
    else if([curWeather isEqualToString:@"fog"])
        contextTagWeather=[self getContextTagByName:@"Fog"];

    if(contextTagTemp && contextTagWeather)
    {
        if(arc4random_uniform(2))
            return contextTagTemp;
        else
            return contextTagWeather;
    }
    else
        return contextTagTemp?contextTagTemp:contextTagWeather;

}



-(Tag*)getDayOfTheWeek
{
    Tag* contextTag;
    NSCalendar *calendar=[NSCalendar currentCalendar];
    NSDate *rightNow=[NSDate date];
    
    NSDateComponents *nowYMD = [calendar components:(NSDayCalendarUnit | NSWeekdayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit)  fromDate:rightNow];
    
    //1-Sunday, 2-Monday..
    NSInteger dayOfWeek=nowYMD.weekday;
    
    switch (dayOfWeek)
    {
        case 1:
            contextTag=[self getContextTagByName:@"Weekend"];
            break;
        case 2:
            contextTag=[self getContextTagByName:@"Monday"];
            break;
        case 6:
            contextTag=[self getContextTagByName:@"Friday"];
        case 7:
            contextTag=[self getContextTagByName:@"Weekend"];
            break;
    }
    
    return contextTag;
}

-(Tag*) getTime
{
    Tag* contextTag;
    //get current time
    NSDateComponents *nowComp = [[NSCalendar currentCalendar] components:(NSHourCalendarUnit)  fromDate:[NSDate date]];
    
    if (nowComp.hour>=7 && nowComp.hour<10)
        contextTag=[self getContextTagByName:@"Morning"];
    else if (nowComp.hour>=12 && nowComp.hour<13)
        contextTag=[self getContextTagByName:@"Lunch"];
    else if (nowComp.hour>=16 && nowComp.hour<20)
        contextTag=[self getContextTagByName:@"Evening"];
    else if (nowComp.hour>=20 && nowComp.hour<23)
        contextTag=[self getContextTagByName:@"Night"];
    
    return contextTag;
}




@end
