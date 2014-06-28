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
#define CD_SYNCED (@"synced")
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
@dynamic synced;

+(NSString*) entityName {return @"Statistics";}
+(NSString*) parseEntityName {return @"Statistics";}

-(void)recordLike:(OfferLike)newLike
{
    self.liked=@(newLike);
    
    //the likeness effect that will go through Tag graph
    double effect;
    switch(newLike)
    {
        case LK_None:effect=[Model sharedModel].settings.lk_none.doubleValue;
            break;
        case LK_Dislike:effect=[Model sharedModel].settings.lk_dislike.doubleValue;
            break;
        case LK_Like:effect=[Model sharedModel].settings.lk_like.doubleValue;
            break;
    }
    [self.linkedOffer processLike:effect];
}

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


+(void)sendToCloud
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setMonth:-1];
    NSDate *monthAgo = [[NSCalendar currentCalendar]  dateByAddingComponents:dateComponents toDate:[NSDate date] options:0];

    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:self.entityName];
    NSString *predicateBound = [NSString stringWithFormat: @"%@>'%@'", CD_DATE, monthAgo];
    NSString *predicateSynced = [NSString stringWithFormat: @"%@==%hhd", CD_SYNCED, NO];
    
    request.predicate=[NSCompoundPredicate andPredicateWithSubpredicates:@[predicateBound,predicateSynced]];
    NSError *error;
    NSArray *stats = [[Model sharedModel].managedObjectContext executeFetchRequest:request error:&error];
    
    if(error)
    {
        NSLog(@"%@",[error localizedDescription]);
    }
    else
    {
        for (Statistics *newStat in stats)
        {
            PFObject *newStatistics = [PFObject objectWithClassName:Statistics.parseEntityName];
            newStatistics[P_DATE] = newStat.date;
            newStatistics[P_LIKED] = newStat.liked;
            newStatistics[P_MAJOR]=newStat.major;
            newStatistics[P_MINOR]=newStat.minor;
            newStatistics[P_OPENED]=newStat.wasOpened;
            newStatistics[P_BEACON]=newStat.byBeacon;
            newStatistics[P_OFFER] = [PFObject objectWithoutDataWithClassName:Featured.parseEntityName objectId:newStat.linkedOffer.pObjectID];
            newStatistics[P_USER] = [PFObject objectWithoutDataWithClassName:User.parseEntityName objectId:newStat.linkedUser.pObjectID];
            //saving data whenever user gets network connection
            [newStatistics saveEventually];
            newStat.synced=@(YES);
        }
    }
}

@end
