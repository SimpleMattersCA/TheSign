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

@synthesize parseObject=_parseObject;

+(NSString*) entityName {return @"Context";}
+(NSString*) parseEntityName {return @"Context";}

+(Boolean)checkIfParseObjectRight:(PFObject*)object
{
    if(object[P_NAME] && object[P_PROBABILITY])
        return YES;
    else
        return NO;
}

+(Context*) getByID:(NSString*)identifier
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:self.entityName];
    NSString *predicate = [NSString stringWithFormat: @"%@=='%@'", OBJECT_ID, identifier];
    request.predicate=[NSPredicate predicateWithFormat:predicate];
    NSError *error;
    NSArray *result = [[Model sharedModel].managedObjectContext executeFetchRequest:request error:&error];
    
    if(error)
    {
        NSLog(@"%@",[error localizedDescription]);
        return nil;
    }
    else
        return (Context*)result.firstObject;
}


+ (void)createFromParse:(PFObject *)object
{
    if([self checkIfParseObjectRight:object]==NO)
    {
        NSLog(@"The object %@ is missing mandatory fields",object.objectId);
        return;
    }
    
    Context *context = [NSEntityDescription insertNewObjectForEntityForName:self.entityName
                                             inManagedObjectContext:[Model sharedModel].managedObjectContext];
    context.parseObject=object;
    context.pObjectID=object.objectId;
    context.name=object[P_NAME];
    context.probability=object[P_PROBABILITY];
}

-(void)refreshFromParse
{
    NSError *error;
    [self.parseObject refresh:&error];
    if(error)
    {
        NSLog(@"%@",[error localizedDescription]);
        return;
    }
    
    if([self.class checkIfParseObjectRight:self.parseObject]==NO)
    {
        NSLog(@"The object %@ is missing mandatory fields",self.parseObject.objectId);
        return;
    }
    
    self.name=self.parseObject[P_NAME];
    self.probability=self.parseObject[P_PROBABILITY];
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


+(NSArray*)getCurrentContextsForBusiness:(Business*)business AtLocation:(Location*)location
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:self.entityName];
    NSError *error;
    NSArray *fetchedContexts = [[Model sharedModel].managedObjectContext executeFetchRequest:request error:&error];
    
    if(error)
    {
        NSLog(@"%@",[error localizedDescription]);
        return nil;
    }
    
    NSMutableArray* currentContexts;
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
    
    if(curTemperature.integerValue < 10)
        contextTagTemp=[self getContextTagByName:@"Cold"];
    else if(curTemperature.integerValue > 25)
        contextTagTemp=[self getContextTagByName:@"Hot"];
    
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
    
    if (nowComp.hour>=7 && nowComp.hour<9)
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
