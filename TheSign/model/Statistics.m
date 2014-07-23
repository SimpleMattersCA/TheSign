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
#import "Parse/PFObject.h"
#import "Business.h"

#define P_DATE (@"date")
#define P_LIKED (@"liked")
#define P_MAJOR (@"major")
#define P_MINOR (@"minor")
#define P_OPENED (@"wasOpened")
#define P_USER (@"user")
#define P_OFFER (@"deal")
#define P_BUSINESS (@"business")
#define P_TYPE (@"statType")

#define CD_DATE (@"date")
#define CD_LIKED (@"liked")
#define CD_SYNCED (@"synced")
#define CD_MAJOR (@"major")
#define CD_MINOR (@"minor")
#define CD_OPENED (@"wasOpened")
#define CD_USER (@"user")
#define CD_OFFER (@"deal")
#define CD_TYPE (@"statType")

@implementation Statistics

@dynamic date;
@dynamic liked;
@dynamic major;
@dynamic minor;
@dynamic wasOpened;
@dynamic linkedUser;
@dynamic linkedOffer;
@dynamic statType;
@dynamic synced;

+(NSString*) entityName {return @"Statistics";}
+(NSString*) parseEntityName {return @"Statistics";}

-(void)setDeal:(Featured*)offer
{
    self.linkedOffer=offer;
    [offer addLinkedStatsObject:self];
}

+(Statistics*)recordStatisticsFromFeedForContext:(NSManagedObjectContext*)context
{
    
    Statistics *newStat = [NSEntityDescription insertNewObjectForEntityForName:[Statistics entityName]
                                                        inManagedObjectContext:context];
    newStat.statType=@(1);
    newStat.date=[NSDate date];
    newStat.linkedUser=[Model sharedModel].currentUser;
    newStat.statType=@(0);
    
    [[Model sharedModel] saveContext:context];
    return newStat;
}


+(Statistics*)recordStatisticsFromBeaconMajor:(NSNumber*)major Minor:(NSNumber*)minor Context:(NSManagedObjectContext *)context
{
    Statistics *newStat = [NSEntityDescription insertNewObjectForEntityForName:[Statistics entityName]
                                             inManagedObjectContext:context];
    newStat.statType=@(1);
    newStat.date=[NSDate date];
    newStat.linkedUser=[Model sharedModel].currentUser;
    newStat.major=major;
    newStat.minor=minor;
    newStat.statType=@(1);
    [Business discoverBusinessByID:major Context:context];
    
    [[Model sharedModel] saveContext:context];
    return newStat;
}

+(Statistics*)recordStatisticsFromGPS:(NSNumber*)businessUID Context:(NSManagedObjectContext *)context
{
    Statistics *newStat = [NSEntityDescription insertNewObjectForEntityForName:[Statistics entityName]
                                                        inManagedObjectContext:context];
    newStat.statType=@(2);
    newStat.date=[NSDate date];
    newStat.linkedUser=[Model sharedModel].currentUser;
    [Business discoverBusinessByID:businessUID Context:context];
    [[Model sharedModel] saveContext:context];
    return newStat;

}


+(void)sendToCloudForContext:(NSManagedObjectContext *)context
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setMonth:-1];
    NSDate *monthAgo = [[NSCalendar currentCalendar]  dateByAddingComponents:dateComponents toDate:[NSDate date] options:0];

    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[Statistics entityName]];
    NSString *predicateBound = [NSString stringWithFormat: @"%@>'%@'", CD_DATE, monthAgo];
    NSString *predicateSynced = [NSString stringWithFormat: @"%@==%d", CD_SYNCED, NO];
    
    request.predicate=[NSCompoundPredicate andPredicateWithSubpredicates:@[predicateBound,predicateSynced]];
    NSError *error;
    NSArray *stats = [context executeFetchRequest:request error:&error];
    
    if(error)
    {
        NSLog(@"%@",[error localizedDescription]);
    }
    else
    {
        for (Statistics *newStat in stats)
        {
            PFObject *newStatistics = [PFObject objectWithClassName:[Statistics parseEntityName]];
            newStatistics[P_DATE] = newStat.date;
            newStatistics[P_LIKED] = newStat.liked;
            newStatistics[P_MAJOR]=newStat.major;
            newStatistics[P_MINOR]=newStat.minor;
            newStatistics[P_OPENED]=newStat.wasOpened;
            newStatistics[P_TYPE]=newStat.statType;
            if(newStat.linkedOffer)
            {
                newStatistics[P_OFFER] = [PFObject objectWithoutDataWithClassName:[Featured parseEntityName] objectId:newStat.linkedOffer.pObjectID];
                if(newStat.linkedOffer.linkedBusiness)
                    newStatistics[P_BUSINESS] = [PFObject objectWithoutDataWithClassName:[Featured parseEntityName] objectId:newStat.linkedOffer.linkedBusiness.pObjectID];
            }
            
            newStatistics[P_USER] = [PFObject objectWithoutDataWithClassName:[User parseEntityName] objectId:newStat.linkedUser.pObjectID];
            //saving data whenever user gets network connection
            [newStatistics saveEventually];
            newStat.synced=@(YES);
        }
    }
}


@end
