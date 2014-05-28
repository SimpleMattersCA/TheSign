//
//  Statistics.m
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-05-24.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import "Statistics.h"
#import "Model.h"

@implementation Statistics

@dynamic date;
@dynamic major;
@dynamic minor;

+(NSString*) entityName
{
    return @"Statistics";
}


+(void) recordBeaconDetectedOn:(NSDate*) date withMajor:(NSNumber*) major andMinor: (NSNumber*) minor
{
    Statistics *newStat = [NSEntityDescription insertNewObjectForEntityForName:[self entityName]
                                                        inManagedObjectContext:[Model sharedModel].managedObjectContext];
    newStat.major=major;
    newStat.minor=minor;
    newStat.date=date;
    [[Model sharedModel] saveContext];
    
    /* SINCE WE ARE NOT STORING STATISTICS IN THE CLOUD
    PFObject *newStatistics = [PFObject objectWithClassName:PARSE_STATISTICS];
    newStatistics[PARSE_STATISTICS_MAJOR] = major;
    newStatistics[PARSE_STATISTICS_MINOR] = minor;
    newStatistics[PARSE_STATISTICS_DATE] = date;
    
#pragma mark - do a callback with processing the result of the save
    [newStatistics saveEventually];*/
}


@end
