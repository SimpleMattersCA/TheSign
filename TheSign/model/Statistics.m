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

+(NSString*) entityName {return @"Statistics";}
+(NSString*) colMajor {return @"major";}
+(NSString*) colMinor {return @"minor";}
+(NSString*) colDate {return @"date";}




+(NSArray*) getStatisticsFrom:(NSDate*) startDate To:(NSDate*) endDate ForMajor:(NSNumber*) major andMinor:(NSNumber*)minor
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:self.entityName];
    NSString *predicateFromDate = [NSString stringWithFormat: @"%@>='%@'", Statistics.colDate, startDate];
    NSString *predicateToDate = [NSString stringWithFormat: @"%@<='%@'", Statistics.colDate, endDate];
    
    NSMutableArray *subPredicates=[NSMutableArray arrayWithObjects:predicateFromDate,predicateToDate, nil];
    
    if(major!=nil)
    {
        NSString *predicateMajor = [NSString stringWithFormat: @"%@=='%@'", Statistics.colMajor, major];
        [subPredicates addObject:predicateMajor];
    }
    if(minor!=nil)
    {
        NSString *predicateMinor = [NSString stringWithFormat: @"%@=='%@'", Statistics.colMinor, minor];
        [subPredicates addObject:predicateMinor];
    }
    
    request.predicate=[NSCompoundPredicate andPredicateWithSubpredicates:subPredicates];
    
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
