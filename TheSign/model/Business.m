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
#import "BusinessCategory.h"

#define CD_NAME (@"name")
#define CD_ABOUT (@"about")
#define CD_LOGO (@"logo")
#define CD_BACK (@"blurredBack")
#define CD_UID (@"uid")
#define CD_WELCOMETEXT (@"welcomeText")
#define CD_DISCOVERED (@"discovered")

#define P_NAME (@"name")
#define P_ABOUT (@"about")
#define P_LOGO (@"logo")
#define P_BACK (@"blurredBack")
#define P_UID (@"uid")
#define P_WELCOMETEXT (@"welcomeText")
#define P_CATEGORY (@"category")


@implementation Business

@dynamic logo;
@dynamic blurredBack;
@dynamic name;
@dynamic about;
@dynamic pObjectID;
@dynamic uid;
@dynamic welcomeText;
@dynamic discovered;
@dynamic discoveryDate;
@dynamic linkedOffers;
@dynamic linkedLinks;
@dynamic linkedLocations;
@dynamic linkedCategory;



#pragma mark - Sign Entity Protocol

@synthesize parseObject=_parseObject;

-(PFObject*)parseObject
{
    if(!_parseObject)
    {
        NSError *error;
        if(!error)
            _parseObject=[PFQuery getObjectOfClass:[Business parseEntityName] objectId:self.pObjectID error:&error];
       //else
         //   NSLog(@"%@",[error localizedDescription]);
    }
    return _parseObject;
}

+(NSString*) entityName {return @"Business";}
+(NSString*) parseEntityName {return @"Business";}


+(Business*) getByID:(NSString*)identifier Context:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[Business entityName]];
    
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
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[Business entityName]];
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
       // NSLog(@"%@: The object %@ is missing mandatory fields",[Business entityName],object.objectId);
        return NO;
    }
    Boolean complete=YES;

    NSError *error;
    Business *business = [NSEntityDescription insertNewObjectForEntityForName:[Business entityName]
                                                       inManagedObjectContext:context];
    business.pObjectID=object.objectId;
    business.name=object[P_NAME];
    business.welcomeText=object[P_WELCOMETEXT];
    business.uid=object[P_UID];
    business.discovered=@(YES);
    business.about=object[P_ABOUT];
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
        //NSLog(@"%@",[error localizedDescription]);
        complete=NO;
    }
    
    PFFile *background=object[P_BACK];
    NSData *pulledBackground;
    pulledBackground=[background getData:&error];
    if(!error)
    {
        if(pulledBackground!=nil)
            business.blurredBack=pulledBackground;
        else
        {
           // NSLog(@"Business background is missing");
            //complete=NO;
        }
    }
    else
    {
      //  NSLog(@"%@",[error localizedDescription]);
        complete=NO;
    }
    
    if(object[P_CATEGORY]!=nil)
    {
        //careful, incomplete object - only objectId property is there
        PFObject *fromParseCategory=object[P_CATEGORY];
        BusinessCategory *linkedCategory=[BusinessCategory getByID:fromParseCategory.objectId Context:context];
        if (linkedCategory!=nil)
        {
            business.linkedCategory = linkedCategory;
            [linkedCategory addLinkedBusinessesObject:business];
        }
        else
        {
            //NSLog(@"Linked category wasn't found");
            complete=NO;
        }
    }

    
    
    return complete;
}



-(Boolean)refreshFromParseForContext:(NSManagedObjectContext *)context
{
    if(!self.parseObject)
    {
     //   NSLog(@"%@: Couldn't fetch the parse object with id: %@",[Business entityName],self.pObjectID);
        return NO;
    }
    
    if([Business checkIfParseObjectRight:self.parseObject]==NO)
    {
       // NSLog(@"The object %@ is missing mandatory fields",self.parseObject.objectId);
        return NO;
    }
    
    Boolean complete=YES;

    self.name=self.parseObject[P_NAME];
    self.welcomeText=self.parseObject[P_WELCOMETEXT];
    self.uid=self.parseObject[P_UID];
    self.about=self.parseObject[P_ABOUT];
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
          //  NSLog(@"Business logo is missing");
            //complete=NO;
        }
    }
    else
    {
       // NSLog(@"%@",[error localizedDescription]);
        complete=NO;
    }
    
    PFFile *background=self.parseObject[P_BACK];
    NSData *pulledBackground;
    pulledBackground=[background getData:&error];
    if(!error)
    {
        if(pulledBackground!=nil)
            self.blurredBack=pulledBackground;
        else
        {
          //  NSLog(@"Business background is missing");
            //complete=NO;
        }
    }
    else
    {
      //  NSLog(@"%@",[error localizedDescription]);
        complete=NO;
    }
    
    if(self.parseObject[P_CATEGORY]!=nil)
    {
        //careful, incomplete object - only objectId property is there
        PFObject *fromParseCategory=self.parseObject[P_CATEGORY];
        if(self.linkedCategory.pObjectID!=fromParseCategory.objectId)
        {
            [self.linkedCategory removeLinkedBusinessesObject:self];
            BusinessCategory *linkedCategory=[BusinessCategory getByID:fromParseCategory.objectId Context:context];
            if(linkedCategory!=nil)
            {
                self.linkedCategory = linkedCategory;
                [linkedCategory addLinkedBusinessesObject:self];
            }
            else
            {
             //   NSLog(@"Linked category wasn't found");
                complete=NO;
            }
        }
    }

    return complete;
}

+(NSInteger)getRowCountForContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[Business entityName]];
    NSError *error;
    NSInteger result = [context countForFetchRequest:request error:&error];
    
    if(error)
    {
       // NSLog(@"%@",[error localizedDescription]);
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







+(NSArray*) getBusinessesForContext:(NSManagedObjectContext*)context
{
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[Business entityName]];
        NSError *error;
        NSArray *business = [context executeFetchRequest:request error:&error];
        
        if(error)
        {
          //  NSLog(@"%@",[error localizedDescription]);
            return nil;
        }
        
        return business;
}




+(Boolean)checkIfParseObjectRight:(PFObject*)object
{
    if(object[P_UID] && object[P_NAME] && object[P_ABOUT] && object[P_CATEGORY])
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
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[Business entityName]];
    NSError *error;
    request.predicate=[NSPredicate predicateWithFormat: [NSString stringWithFormat:@"%@=%d", CD_DISCOVERED, YES]];
    NSArray *result = [context executeFetchRequest:request error:&error];
    
    if(error)
    {
      //  NSLog(@"%@",[error localizedDescription]);
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

-(UIImage*)getCategoryIcon
{
    if(self.linkedCategory)
    {
        return [UIImage imageWithData:self.linkedCategory.icon];
    }
    else
        return nil;
}

@end
