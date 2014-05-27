//
//  Business.m
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-05-24.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import "Business.h"
#import "Featured.h"

#import "Model.h"


@implementation Business

@dynamic pObjectID;
@dynamic logo;
@dynamic name;
@dynamic uid;
@dynamic welcomeText;
@dynamic workingHoursEnd;
@dynamic workingHoursStart;
@dynamic featuredOffers;
@dynamic links;


+(NSString*) entityName
{
    return BUSINESS;
}
+(NSString*)parseName:(NSString*)coreDataName
{
    //so far Parse names for this class are exactly the same as those for CoreData
    //for cases when they're not, add something like this:
    //if ([coreDataName isEqual:@"Something"])
    //    return @"somethingElse";
    
    return coreDataName;
}


+(Business*) getByID:(NSString*)identifier
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[self entityName]];
    NSString *predicate = [NSString stringWithFormat: @"%@==%@", OBJECT_ID, identifier];
    request.predicate=[NSPredicate predicateWithFormat:predicate];
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

+(NSArray*) getBusinessesByType:(NSString*)type
{
    if([type isEqual:nil])
    {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[self entityName]];
        //NSString *predicate = [NSString stringWithFormat: @"%@==%@", OBJECT_ID, identifier];
        //request.predicate=[NSPredicate predicateWithFormat:predicate];
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

+(NSString*) getBusinessNameByBusinessID:(NSInteger)identifier
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[self entityName]];
    NSString *predicate = [NSString stringWithFormat: @"%@==%ld", BUSINESS_ID, (long)identifier];
    request.predicate=[NSPredicate predicateWithFormat:predicate];
    NSError *error;
    NSArray *business = [[Model sharedModel].managedObjectContext executeFetchRequest:request error:&error];
    
    if(error)
    {
        NSLog(@"%@",[error localizedDescription]);
        return nil;
    }
    
    if(business.count==0)
        return nil;
    else
        return ((Business*)business[0]).name;
}

+(NSString*) getWelcomeTextByBusinessID:(NSInteger)identifier
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[self entityName]];
    NSString *predicate = [NSString stringWithFormat: @"%@==%ld", BUSINESS_ID, (long)identifier];
    request.predicate=[NSPredicate predicateWithFormat:predicate];
    NSError *error;
    NSArray *business = [[Model sharedModel].managedObjectContext executeFetchRequest:request error:&error];
    
    if(!error)
    {
        NSLog(@"%@",[error localizedDescription]);
        return nil;
    }
    
    if(business.count==0)
        return nil;
    else
        return ((Business*)business[0]).welcomeText;
}


+(void)createFromParseObject:(PFObject *)object
{
    Business *business = [NSEntityDescription insertNewObjectForEntityForName:[self entityName]
                                                       inManagedObjectContext:[Model sharedModel].managedObjectContext];
    business.pObjectID=object[OBJECT_ID];
    business.name=object[[Business parseName:BUSINESS_NAME]];
    business.welcomeText=object[[Business parseName:BUSINESS_NAME]];
    business.uid=object[[Business parseName:BUSINESS_ID]];
    
    PFFile *logo=object[[Business parseName:BUSINESS_LOGO]];
    
    NSError *error;
    
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


@end
