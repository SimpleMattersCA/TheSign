//
//  Business.m
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-06-19.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import "Business.h"
#import "Featured.h"
#import "Link.h"
#import "Model.h"
#import "Location.h"

#define CD_NAME (@"name")
#define CD_LOGO (@"logo")
#define CD_UID (@"uid")
#define CD_WELCOMETEXT (@"welcomeText")
#define CD_TYPE (@"businessType")
#define CD_LATTITUDE (@"locaitonLatt")
#define CD_LONGITUDE (@"locationLong")
#define CD_DISCOVERED (@"discovered")

#define P_NAME (@"name")
#define P_LOGO (@"logo")
#define P_UID (@"uid")
#define P_WELCOMETEXT (@"welcomeText")
#define P_TYPE (@"businessType")
#define P_LOCATION (@"location")


@implementation Business

@dynamic businessType;
@dynamic logo;
@dynamic name;
@dynamic pObjectID;
@dynamic uid;
@dynamic welcomeText;
@dynamic discovered;
@dynamic discoveryDate;
@dynamic linkedOffers;
@dynamic linkedLinks;
@dynamic linkedLocations;




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

+(NSString*) entityName {return @"Business";}
+(NSString*) parseEntityName {return @"Business";}


///this dictionary contains pairs CLLocation / objectID
//static NSDictionary* _businessLocations;

//just so I don't have to create another CoreData entity and fuck with the synchronization we gonna store business types in a hashtable. God I love hash tables. They sounds like hash browns..
static NSArray* _businessTypes;

+(Business*) getByID:(NSString*)identifier Context:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:self.entityName];
    
    request.predicate=[NSPredicate predicateWithFormat: [NSString stringWithFormat:@"%@='%@'", OBJECT_ID, identifier]];
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
+(Business*) getBusinessByUID:(NSNumber*)identifier Context:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:self.entityName];
    request.predicate=[NSPredicate predicateWithFormat: [NSString stringWithFormat:@"%@=%d", CD_UID, identifier.intValue]];
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

+(Boolean)createFromParse:(PFObject *)object Context:(NSManagedObjectContext *)context
{
    if([Business checkIfParseObjectRight:object]==NO)
    {
        NSLog(@"%@: The object %@ is missing mandatory fields",self.entityName,object.objectId);
        return NO;
    }
    Boolean complete=YES;

    NSError *error;
    Business *business = [NSEntityDescription insertNewObjectForEntityForName:Business.entityName
                                                       inManagedObjectContext:context];
    business.pObjectID=object.objectId;
    business.name=object[P_NAME];
    business.welcomeText=object[P_WELCOMETEXT];
    business.uid=object[P_UID];
    business.businessType=object[P_TYPE];
    business.discovered=@(YES);
    PFFile *logo=object[P_LOGO];
    NSData *pulledLogo;
    pulledLogo=[logo getData:&error];
    if(!error)
    {
        if(pulledLogo!=nil)
            business.logo=pulledLogo;
        else
        {
            NSLog(@"Business logo is missing");
            //complete=NO;
        }
    }
    else
    {
        NSLog(@"%@",[error localizedDescription]);
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
    
    if([Business checkIfParseObjectRight:self.parseObject]==NO)
    {
        NSLog(@"The object %@ is missing mandatory fields",self.parseObject.objectId);
        return NO;
    }
    
    Boolean complete=YES;

    self.name=self.parseObject[P_NAME];
    self.welcomeText=self.parseObject[P_WELCOMETEXT];
    self.uid=self.parseObject[P_UID];
    self.businessType=self.parseObject[P_TYPE];
    
    PFFile *logo=self.parseObject[P_LOGO];
    NSError *error;
    NSData *pulledLogo;
    pulledLogo=[logo getData:&error];
    if(!error)
    {
        if(pulledLogo!=nil)
            self.logo=pulledLogo;
        else
        {
            NSLog(@"Business logo is missing");
            //complete=NO;
        }
    }
    else
    {
        NSLog(@"%@",[error localizedDescription]);
        complete=NO;
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


+(Location*)getClosestBusinessToLocation:(CLLocation*)curLocation Context:(NSManagedObjectContext *)context
{
    NSArray* businesses=[self getBusinessesForContext:context];
    CLLocationDistance minDistance;
    CLLocation *closestLocation = nil;
    Location *closestBusinessLocation;
    for (Business *business in businesses) {

        for(Location *location in business.linkedLocations)
        {
            CLLocation* bizlocation=[[CLLocation alloc] initWithLatitude:location.latitude.doubleValue longitude:location.longitude.doubleValue];
            CLLocationDistance distance = [bizlocation distanceFromLocation:curLocation];
            
            if (distance <= minDistance
                || closestLocation == nil) {
                minDistance = distance;
                closestLocation = bizlocation;
                closestBusinessLocation=location;
            }
        
        }
        
       
    }
    return closestBusinessLocation;
}




+(NSArray*) getTypesForContext:(NSManagedObjectContext *)context
{
    if(!_businessTypes)
    {
        NSMutableArray* newTypes=[NSMutableArray array];
        for (Business *business in [Business getBusinessesForContext:context])
        {
            if (![newTypes containsObject:business.businessType])
                [newTypes addObject:business.businessType];
        }
        _businessTypes=newTypes;
    }
    return _businessTypes;
}


+(NSArray*) getBusinessesForContext:(NSManagedObjectContext*)context
{
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:Business.entityName];
        NSError *error;
        NSArray *business = [context executeFetchRequest:request error:&error];
        
        if(error)
        {
            NSLog(@"%@",[error localizedDescription]);
            return nil;
        }
        
        return business;
}

+(NSArray*) getBusinessesByType:(NSString*)type Context:(NSManagedObjectContext *)context
{
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:Business.entityName];
    request.predicate=[NSPredicate predicateWithFormat: [NSString stringWithFormat:@"%@='%@'", CD_TYPE, type]];
    NSError *error;
    NSArray *business = [context executeFetchRequest:request error:&error];
        
    if(error)
    {
        NSLog(@"%@",[error localizedDescription]);
        return nil;
    }
        
    return business;
    
}



+(Boolean)checkIfParseObjectRight:(PFObject*)object
{
    if(object[P_UID] && object[P_NAME] && object[P_LOGO])
        return YES;
    else
        return NO;
}


-(NSSet*) getActiveOffers
{
    if(self.linkedOffers)
        return [self.linkedOffers objectsPassingTest:^(id obj, BOOL *stop) {
            if(((Featured*)obj).active.boolValue)
                return YES;
            else
                return NO;
        }];
    return nil;
}

+(NSArray*)getDiscoveredBusinessesForContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:self.entityName];
    NSError *error;
    request.predicate=[NSPredicate predicateWithFormat: [NSString stringWithFormat:@"%@=%d", CD_DISCOVERED, YES]];
    NSArray *result = [context executeFetchRequest:request error:&error];
    
    if(error)
    {
        NSLog(@"%@",[error localizedDescription]);
        return nil;
    }
    else
        return result;
    
}

+(void)discoverBusinessByID:(NSNumber*)businessUID Context:(NSManagedObjectContext *)context
{
    Business *discoveredBusiness=[Business getBusinessByUID:businessUID Context:context];
    if(discoveredBusiness!=nil)
    {
        discoveredBusiness.discovered=@(YES);
        discoveredBusiness.discoveryDate=[NSDate date];
    }
}


-(NSString*)getLocationAddressForDeal:(Featured*)deal
{
    return ((Location*)self.linkedLocations.anyObject).address;
}

@end
