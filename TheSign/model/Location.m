//
//  Location.m
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-06-25.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import "Location.h"
#import "Business.h"
#import "Model.h"

#define CD_LATITUDE (@"latitude")
#define CD_LONGITUDE (@"longitude")
#define CD_WEATHER (@"currentWeather")
#define CD_TEMPERATURE (@"currentTemperature")
#define CD_TIMESTAMP (@"weatherTimestamp")
#define CD_ADDRESS (@"address")
#define CD_MAJOR (@"major")


#define P_LATITUDE (@"latitude")
#define P_LONGITUDE (@"longitude")
#define P_WEATHER (@"currentWeather")
#define P_TEMPERATURE (@"currentTemperature")
#define P_ADDRESS (@"address")
#define P_BUSINESS (@"business")
#define P_MAJOR (@"major")

@implementation Location

@dynamic pObjectID;
@dynamic latitude;
@dynamic longitude;
@dynamic currentWeather;
@dynamic currentTemperature;
@dynamic weatherTimestamp;
@dynamic linkedBusiness;
@dynamic address;
@dynamic major;

@synthesize parseObject=_parseObject;

+(NSString*) entityName {return @"Location";}
+(NSString*) parseEntityName {return @"Locations";}

+(Boolean)checkIfParseObjectRight:(PFObject*)object
{
    if(object[P_LATITUDE] && object[P_LONGITUDE] && object[P_BUSINESS])
        return YES;
    else
        return NO;
}


+(Location*) getByID:(NSString*)identifier
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:Location.entityName];
    request.predicate=[NSPredicate predicateWithFormat:@"%@=='%@'", OBJECT_ID, identifier];
    NSError *error;
    NSArray *result = [[Model sharedModel].managedObjectContext executeFetchRequest:request error:&error];
    
    if(error)
    {
        NSLog(@"%@",[error localizedDescription]);
        return nil;
    }
    else
        return (Location*)result.firstObject;
}



+ (void)createFromParse:(PFObject *)object
{
    if([Location checkIfParseObjectRight:object]==NO)
    {
        NSLog(@"The object %@ is missing mandatory fields",object.objectId);
        return;
    }
    
    Location *location = [NSEntityDescription insertNewObjectForEntityForName:[Location entityName]
                                               inManagedObjectContext:[Model sharedModel].managedObjectContext];
    location.parseObject=object;
    location.pObjectID=object.objectId;
    location.currentTemperature=object[P_TEMPERATURE];
    location.currentWeather=object[P_WEATHER];
    location.weatherTimestamp=object.updatedAt;
    location.address=object[P_ADDRESS];
    location.longitude=object[P_LONGITUDE];
    location.latitude=object[P_LATITUDE];
    location.major=object[P_MAJOR];
    //careful, incomplete object - only objectId property is there
    PFObject *fromParseBusiness=object[P_BUSINESS];
    Business *linkedBusiness=[Business getByID:fromParseBusiness.objectId];
    if (linkedBusiness!=nil)
    {
        location.linkedBusiness = linkedBusiness;
        [linkedBusiness addLinkedLocationsObject:location];
    }
    else
        NSLog(@"Linked business wasn't found");
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
    
    if([Location checkIfParseObjectRight:self.parseObject]==NO)
    {
        NSLog(@"The object %@ is missing mandatory fields",self.parseObject.objectId);
        return;
    }
    
    self.currentTemperature=self.parseObject[P_TEMPERATURE];
    self.currentWeather=self.parseObject[P_WEATHER];
    self.weatherTimestamp=self.parseObject.updatedAt;
    self.address=self.parseObject[P_ADDRESS];
    self.longitude=self.parseObject[P_LONGITUDE];
    self.latitude=self.parseObject[P_LATITUDE];
    self.major=self.parseObject[P_MAJOR];
    
    //careful, incomplete object - only objectId property is there
    PFObject *fromParseBusiness=self.parseObject[P_BUSINESS];
    if (fromParseBusiness.objectId!=self.linkedBusiness.pObjectID)
    {
        [self.linkedBusiness removeLinkedLocationsObject:self];
        Business *linkedBusiness=[Business getByID:fromParseBusiness.objectId];
        if (linkedBusiness!=nil)
        {
            self.linkedBusiness = linkedBusiness;
            [linkedBusiness addLinkedLocationsObject:self];
        }
        else
            NSLog(@"Linked business wasn't found");

    }
}


+(Business*)getBusinessForLocationMajor:(NSNumber*)major
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
        return ((Location*)result.firstObject).linkedBusiness;
    }
}


@end
