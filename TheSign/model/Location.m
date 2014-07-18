//
//  Location.m
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-06-25.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import "Location.h"
#import "Business.h"
#import "Area.h"
#import "Model.h"

#define CD_LATITUDE (@"latitude")
#define CD_LONGITUDE (@"longitude")
#define CD_ADDRESS (@"address")
#define CD_MAJOR (@"major")


#define P_LATITUDE (@"latitude")
#define P_LONGITUDE (@"longitude")
#define P_ADDRESS (@"address")
#define P_BUSINESS (@"business")
#define P_AREA (@"area")
#define P_MAJOR (@"major")

@implementation Location

@dynamic pObjectID;
@dynamic latitude;
@dynamic longitude;
@dynamic linkedBusiness;
@dynamic address;
@dynamic major;
@dynamic linkedArea;




#pragma mark - Sign Entity Protocol

@synthesize parseObject=_parseObject;

-(PFObject*)parseObject
{
    if(!_parseObject)
    {
        NSError *error;
        if(!error)
            _parseObject=[PFQuery getObjectOfClass:[self.class parseEntityName] objectId:self.pObjectID error:&error];
        else
            NSLog(@"%@",[error localizedDescription]);
    }
    return _parseObject;
}

+(NSString*) entityName {return @"Location";}
+(NSString*) parseEntityName {return @"Locations";}

+(Boolean)checkIfParseObjectRight:(PFObject*)object
{
    if(object[P_LATITUDE] && object[P_LONGITUDE] && object[P_BUSINESS])
        return YES;
    else
        return NO;
}


+(Location*) getByID:(NSString*)identifier Context:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:self.entityName];
    request.predicate=[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@='%@'", OBJECT_ID, identifier]];

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
    if([Location checkIfParseObjectRight:object]==NO)
    {
        NSLog(@"%@: The object %@ is missing mandatory fields",self.entityName,object.objectId);
        return NO;
    }
    
    Boolean complete=YES;
    
    Location *location = [NSEntityDescription insertNewObjectForEntityForName:[Location entityName]
                                               inManagedObjectContext:context];
    location.pObjectID=object.objectId;
    location.address=object[P_ADDRESS];
    location.longitude=object[P_LONGITUDE];
    location.latitude=object[P_LATITUDE];
    location.major=(NSNumber*)(object[P_MAJOR]);
    //careful, incomplete object - only objectId property is there
    PFObject *fromParseBusiness=object[P_BUSINESS];
    Business *linkedBusiness=[Business getByID:fromParseBusiness.objectId Context:context];
    if (linkedBusiness!=nil)
    {
        location.linkedBusiness = linkedBusiness;
        [linkedBusiness addLinkedLocationsObject:location];
    }
    else
    {
        NSLog(@"Linked business wasn't found");
        complete=NO;
    }
    
    //careful, incomplete object - only objectId property is there
    PFObject *fromParseArea=object[P_AREA];
    Area *linkedArea=[Area getByID:fromParseArea.objectId Context:context];
    if (linkedArea!=nil)
    {
        location.linkedArea = linkedArea;
        [linkedArea addLinkedLocationsObject:location];
    }
    else
    {
        NSLog(@"Linked are wasn't found");
        complete=NO;
    }
    
    return complete;
}

-(Boolean)refreshFromParseForContext:(NSManagedObjectContext *)context
{
    if(!self.parseObject)
    {
        NSLog(@"%@: Couldn't fetch the parse object with id: %@",[self.class entityName],self.pObjectID);
        return NO;
    }
    
    if([Location checkIfParseObjectRight:self.parseObject]==NO)
    {
        NSLog(@"The object %@ is missing mandatory fields",self.parseObject.objectId);
        return NO;
    }
    
    Boolean complete=YES;
    
    self.address=self.parseObject[P_ADDRESS];
    self.longitude=self.parseObject[P_LONGITUDE];
    self.latitude=self.parseObject[P_LATITUDE];
    self.major=self.parseObject[P_MAJOR];
    
    //careful, incomplete object - only objectId property is there
    PFObject *fromParseBusiness=self.parseObject[P_BUSINESS];
    if (fromParseBusiness.objectId!=self.linkedBusiness.pObjectID)
    {
        [self.linkedBusiness removeLinkedLocationsObject:self];
        Business *linkedBusiness=[Business getByID:fromParseBusiness.objectId Context:context];
        if (linkedBusiness!=nil)
        {
            self.linkedBusiness = linkedBusiness;
            [linkedBusiness addLinkedLocationsObject:self];
        }
        else
        {
            NSLog(@"Linked business wasn't found");
            complete=NO;
        }
    }
    
    //careful, incomplete object - only objectId property is there
    PFObject *fromParseArea=self.parseObject[P_AREA];
    if (fromParseArea.objectId!=self.linkedArea.pObjectID)
    {
        //careful, incomplete object - only objectId property is there
        PFObject *fromParseArea=self.parseObject[P_AREA];
        Area *linkedArea=[Area getByID:fromParseArea.objectId Context:context];
        if (linkedArea!=nil)
        {
            self.linkedArea = linkedArea;
            [linkedArea addLinkedLocationsObject:self];
        }
        else
        {
            NSLog(@"Linked are wasn't found");
            complete=NO;
        }
    }
    
    return complete;
}

+(NSInteger)getRowCountForContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:self.entityName];
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



+(Location*)getLocationByMajor:(NSNumber*)major Context:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:Location.entityName];
    request.predicate=[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@=%d", CD_MAJOR, major.intValue]];
    NSError *error;
    NSArray *result = [context executeFetchRequest:request error:&error];
    
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


-(NSString*)getWeather
{
    if(self.linkedArea)
        return self.linkedArea.currentWeather;
    else
        return nil;
}

-(NSNumber*)getTemperature
{
    if(self.linkedArea)
        return self.linkedArea.currentTemperature;
    else
        return nil;
}

-(NSDate*)getWeatherTime
{
    if(self.linkedArea)
        return self.linkedArea.weatherTimestamp;
    else
        return nil;
}
@end
