//
//  Business.m
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-06-19.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import "Business.h"
#import "DiscoveredBusiness.h"
#import "Featured.h"
#import "Link.h"
#import "Model.h"

#define CD_NAME (@"name")
#define CD_LOGO (@"logo")
#define CD_UID (@"uid")
#define CD_WELCOMETEXT (@"welcomeText")
#define CD_TYPE (@"businessType")
#define CD_LATTITUDE (@"locaitonLatt")
#define CD_LONGITUDE (@"locationLong")

#define P_NAME (@"name")
#define P_LOGO (@"logo")
#define P_UID (@"uid")
#define P_WELCOMETEXT (@"welcomeText")
#define P_TYPE (@"businessType")
#define P_LOCATION (@"location")


@implementation Business

@dynamic businessType;
@dynamic locationLatt;
@dynamic locationLong;
@dynamic logo;
@dynamic name;
@dynamic pObjectID;
@dynamic uid;
@dynamic welcomeText;
@dynamic linkedDiscovery;
@dynamic linkedOffers;
@dynamic linkedLinks;

@synthesize parseObject=_parseObject;

+(NSString*) entityName {return @"Business";}
+(NSString*) parseEntityName {return @"Business";}


#warning will be nil after quitting the app. Put it in UserDefaults or manage to squeze into CoreData
///this dictionary contains pairs CLLocation / objectID
static NSMutableDictionary* businessLocations;

//just so I don't have to create another CoreData entity and fuck with the synchronization we gonna store business types in a hashtable. God I love hash tables. They sounds like hash browns..
static NSMutableArray* businessTypes;

+(CLLocation*)getLocationObjectByBusinessID:(NSInteger)identifier
{
    return [businessLocations objectForKey:@(identifier)];
}

+(CLLocation*)getClosestBusinessToLocation:(CLLocation*)location
{
    NSArray* businesses=[self getBusinessesByType:nil];
    
    CLLocationDistance minDistance;
    CLLocation *closestLocation = nil;
    
    for (Business *business in businesses) {
        
        CLLocation* bizlocation=[businessLocations objectForKey:business.pObjectID];
        CLLocationDistance distance = [bizlocation distanceFromLocation:location];
        
        if (distance <= minDistance
            || closestLocation == nil) {
            minDistance = distance;
            closestLocation = bizlocation;
        }
    }
    return closestLocation;
}




+(NSArray*) getBusinessTypes
{
    return [NSArray arrayWithArray:businessTypes];
}

+(NSArray*) getBusinessesByType:(NSString*)type
{
    if(type==nil)
    {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:Business.entityName];
        NSError *error;
        NSArray *business = [[Model sharedModel].managedObjectContext executeFetchRequest:request error:&error];
        
        if(error)
        {
            NSLog(@"%@",[error localizedDescription]);
            return nil;
        }
        
        return business;
    }
    return nil;
}

+(Business*) getBusinessByUID:(NSNumber*)identifier
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:self.entityName];
    request.predicate=[NSPredicate predicateWithFormat: @"%@==%ld", CD_UID, identifier.longValue];
    NSError *error;
    NSArray *result = [[Model sharedModel].managedObjectContext executeFetchRequest:request error:&error];
    
    if(error)
    {
        NSLog(@"%@",[error localizedDescription]);
        return nil;
    }
    else
        return (Business*)result.firstObject;
}


+(Business*) getByID:(NSString*)identifier
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:self.entityName];
    request.predicate=[NSPredicate predicateWithFormat: @"%@=='%@'", OBJECT_ID, identifier];
    NSError *error;
    NSArray *result = [[Model sharedModel].managedObjectContext executeFetchRequest:request error:&error];
    
    if(error)
    {
        NSLog(@"%@",[error localizedDescription]);
        return nil;
    }
    else
        return (Business*)result.firstObject;
}

+(void)createFromParse:(PFObject *)object
{
    NSError *error;
    Business *business = [NSEntityDescription insertNewObjectForEntityForName:self.entityName
                                                       inManagedObjectContext:[Model sharedModel].managedObjectContext];
    business.parseObject=object;
    business.pObjectID=object.objectId;
    if(object[P_NAME]!=nil) business.name=object[P_NAME];
    business.welcomeText=object[P_WELCOMETEXT];
    if(object[P_UID]!=nil) business.uid=object[P_UID];
    business.businessType=object[P_TYPE];
    if(![businessTypes containsObject:business.businessType]) [businessTypes addObject:business.businessType];
    PFGeoPoint *bizLocation=object[P_LOCATION];
    business.locationLong=@(bizLocation.longitude);
    business.locationLatt=@(bizLocation.latitude);
    
    if(!businessLocations) businessLocations=[NSMutableDictionary dictionary];
    CLLocation* location=[[CLLocation alloc] initWithLatitude:business.locationLatt.doubleValue longitude:business.locationLong.doubleValue];
    [businessLocations setObject:location forKey:business.pObjectID];
    
    PFFile *logo=object[P_LOGO];
    NSData *pulledLogo;
    pulledLogo=[logo getData:&error];
    if(!error)
    {
        if(pulledLogo!=nil)
            business.logo=pulledLogo;
        else
            NSLog(@"Business logo is missing");
    }
    else
        NSLog(@"%@",[error localizedDescription]);
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
    
    self.name=self.parseObject[P_NAME];
    self.welcomeText=self.parseObject[P_WELCOMETEXT];
    self.uid=self.parseObject[P_UID];
    self.businessType=self.parseObject[P_TYPE];
    
    PFGeoPoint *bizLocation=self.parseObject[P_LOCATION];
    self.locationLong=@(bizLocation.longitude);
    self.locationLatt=@(bizLocation.latitude);
    
    businessLocations=[NSMutableDictionary dictionary];
    CLLocation* location=[[CLLocation alloc] initWithLatitude:self.locationLatt.doubleValue longitude:self.locationLong.doubleValue];
    [businessLocations setObject:location forKey:self.pObjectID];
    
    PFFile *logo=self.parseObject[P_LOGO];
    
    NSData *pulledLogo;
    pulledLogo=[logo getData:&error];
    if(!error)
    {
        if(pulledLogo!=nil)
            self.logo=pulledLogo;
        else
            NSLog(@"Business logo is missing");
    }
    else
        NSLog(@"%@",[error localizedDescription]);
}



@end
