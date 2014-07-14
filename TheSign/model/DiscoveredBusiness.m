//
//  DiscoveredBusiness.m
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-06-19.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import "DiscoveredBusiness.h"
#import "Business.h"
#import "Model.h"
#import "User.h"

@implementation DiscoveredBusiness

@dynamic date;
@dynamic linkedBusiness;
@dynamic linkedUser;

+(NSString*) entityName {return @"DiscoveredBusiness";}


+(NSArray*)getDiscoveredBusinesses
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:self.entityName];
    NSError *error;
    NSArray *result = [[Model sharedModel].managedObjectContext executeFetchRequest:request error:&error];
    
    if(error)
    {
        NSLog(@"%@",[error localizedDescription]);
        return nil;
    }
    else
        return result;

}

+(void)updateDiscoveryList:(NSNumber*)businessUID
{
    Business *discoveredBusiness=[Business getBusinessByUID:businessUID];
    if(discoveredBusiness!=nil)
    {
        if(discoveredBusiness.linkedDiscovery!=nil)
            discoveredBusiness.linkedDiscovery.date=[NSDate date];
        else
        {
            DiscoveredBusiness *newDiscovery = [NSEntityDescription insertNewObjectForEntityForName:self.entityName
                                                      inManagedObjectContext:[Model sharedModel].managedObjectContext];
            newDiscovery.date=[NSDate date];
            newDiscovery.linkedBusiness=discoveredBusiness;
            newDiscovery.linkedUser=[Model sharedModel].currentUser;
            discoveredBusiness.linkedDiscovery=newDiscovery;
            [newDiscovery.linkedUser addLinkedDiscoveriesObject:newDiscovery];
        }
    }
}

@end
