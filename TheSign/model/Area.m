//
//  Area.m
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-07-04.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import "Area.h"
#import "Location.h"
#import "Model.h"

#define CD_WEATHER (@"currentWeather")
#define CD_TEMPERATURE (@"currentTemperature")
#define CD_TIMESTAMP (@"weatherTimestamp")

#define P_WEATHER (@"currentWeather")
#define P_TEMPERATURE (@"currentTemperature")

@implementation Area

@dynamic pObjectID;
@dynamic currentTemperature;
@dynamic currentWeather;
@dynamic weatherTimestamp;
@dynamic linkedLocations;


@synthesize parseObject=_parseObject;

+(NSString*) entityName {return @"Location";}
+(NSString*) parseEntityName {return @"Locations";}

+(Boolean)checkIfParseObjectRight:(PFObject*)object
{
    return YES;

}


+(Area*) getByID:(NSString*)identifier
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:Area.entityName];
    request.predicate=[NSPredicate predicateWithFormat:@"%@=='%@'", OBJECT_ID, identifier];
    NSError *error;
    NSArray *result = [[Model sharedModel].managedObjectContext executeFetchRequest:request error:&error];
    
    if(error)
    {
        NSLog(@"%@",[error localizedDescription]);
        return nil;
    }
    else
        return (Area*)result.firstObject;
}



+ (void)createFromParse:(PFObject *)object
{
    if([Area checkIfParseObjectRight:object]==NO)
    {
        NSLog(@"The object %@ is missing mandatory fields",object.objectId);
        return;
    }
    
    Area *area = [NSEntityDescription insertNewObjectForEntityForName:[Area entityName]
                                                       inManagedObjectContext:[Model sharedModel].managedObjectContext];
    area.parseObject=object;
    area.pObjectID=object.objectId;
    area.currentTemperature=object[P_TEMPERATURE];
    area.currentWeather=object[P_WEATHER];
    area.weatherTimestamp=object.updatedAt;
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
    
    if([Area checkIfParseObjectRight:self.parseObject]==NO)
    {
        NSLog(@"The object %@ is missing mandatory fields",self.parseObject.objectId);
        return;
    }
    
    self.currentTemperature=self.parseObject[P_TEMPERATURE];
    self.currentWeather=self.parseObject[P_WEATHER];
    self.weatherTimestamp=self.parseObject.updatedAt;
}


+(Location*)getLocationByMajor:(NSNumber*)major
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:Location.entityName];
    request.predicate=[NSPredicate predicateWithFormat:@"%@==%d", CD_MAJOR, major.intValue];
    NSError *error;
    NSArray *result = [[Model sharedModel].managedObjectContext executeFetchRequest:request error:&error];
    
    if(error)
    {
        NSLog(@"%@",[error localizedDescription]);
        return nil;
    }
    else
    {
        if(result.count>1)
            NSLog(@"Data inconsitency, more than one location for major %d",major.intValue);
        return (Location*)(result.firstObject);
    }
}

-(CLLocation*)getLocationObject
{
    return [[CLLocation alloc] initWithLatitude:self.latitude.doubleValue longitude:self.longitude.doubleValue];
}



@end
