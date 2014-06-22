//
//  Statistics.m
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-06-19.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import "Statistics.h"
#import "Featured.h"
#import "User.h"
#import "Model.h"
#import "DiscoveredBusiness.h"
#import "Parse/PFObject.h"

#define P_DATE (@"date")
#define P_LIKED (@"liked")
#define P_MAJOR (@"major")
#define P_MINOR (@"minor")
#define P_OPENED (@"wasOpened")
#define P_USER (@"user")
#define P_OFFER (@"deal")
#define P_BEACON (@"byBeacon")

#define CD_DATE (@"date")
#define CD_LIKED (@"liked")
#define CD_MAJOR (@"major")
#define CD_MINOR (@"minor")
#define CD_OPENED (@"wasOpened")
#define CD_USER (@"user")
#define CD_OFFER (@"deal")
#define CD_BEACON (@"byBeacon")

@implementation Statistics

@dynamic date;
@dynamic liked;
@dynamic major;
@dynamic minor;
@dynamic wasOpened;
@dynamic linkedUser;
@dynamic linkedOffer;
@dynamic byBeacon;

+(NSString*) entityName {return @"Statistics";}
+(NSString*) parseEntityName {return @"Statistics";}


+(Statistics*)recordStatisticsFromBeaconMajor:(NSNumber*)major Minor:(NSNumber*)minor
{
    Statistics *newStat = [NSEntityDescription insertNewObjectForEntityForName:self.entityName
                                             inManagedObjectContext:[Model sharedModel].managedObjectContext];
    newStat.byBeacon=@(YES);
    newStat.date=[NSDate date];
    newStat.linkedUser=[User currentUser];
    newStat.major=major;
    newStat.minor=minor;
    [DiscoveredBusiness updateDiscoveryList:major];
    [[Model sharedModel] saveContext];
    return newStat;
}

+(Statistics*)recordStatisticsFromGPS:(NSNumber*)businessUID
{
    Statistics *newStat = [NSEntityDescription insertNewObjectForEntityForName:self.entityName
                                                        inManagedObjectContext:[Model sharedModel].managedObjectContext];
    newStat.byBeacon=@(NO);
    newStat.date=[NSDate date];
    newStat.linkedUser=[User currentUser];
    newStat.major=businessUID;
    [DiscoveredBusiness updateDiscoveryList:businessUID];
    [[Model sharedModel] saveContext];
    return newStat;

}


-(void)sendToCloud
{
    PFObject *newStatistics = [PFObject objectWithClassName:Statistics.parseEntityName];
    newStatistics[P_DATE] = self.date;
    newStatistics[P_LIKED] = self.liked;
    newStatistics[P_MAJOR]=self.major;
    newStatistics[P_MINOR]=self.minor;
    newStatistics[P_OPENED]=self.wasOpened;
    newStatistics[P_BEACON]=self.byBeacon;
    newStatistics[P_OFFER] = [PFObject objectWithoutDataWithClassName:Featured.parseEntityName objectId:self.linkedOffer.pObjectID];
    newStatistics[P_USER] = [PFObject objectWithoutDataWithClassName:User.parseEntityName objectId:self.linkedUser.pObjectID];
    //saving data whenever user gets network connection
    [newStatistics saveEventually];
}

@end
