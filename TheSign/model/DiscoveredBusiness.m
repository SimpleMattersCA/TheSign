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
            newDiscovery.linkedUser=[User currentUser];
            discoveredBusiness.linkedDiscovery=newDiscovery;
            [newDiscovery.linkedUser addLinkedDiscoveriesObject:newDiscovery];
        }
    }
}

@end
