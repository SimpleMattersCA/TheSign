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


+(NSString*) entityName {return @"Business";}
+(NSString*) parseEntityName {return @"Business";}

+(NSString*)colName {return @"name";}
+(NSString*)colLogo {return @"logo";}
+(NSString*)colUid {return @"uid";}
+(NSString*)colWelcomeText {return @"welcomeText";}
+(NSString*)colWorkingHoursEnd {return @"workingHoursEnd";}
+(NSString*)colWorkingHoursStart {return @"workingHoursStart";}

+(NSString*)pName {return Business.colName;}
+(NSString*)pLogo {return Business.colLogo;}
+(NSString*)pUid {return Business.colUid;}
+(NSString*)pWelcomeText {return Business.colWelcomeText;}
+(NSString*)pWorkingHoursEnd {return Business.colWorkingHoursEnd;}
+(NSString*)pWorkingHoursStart {return Business.colWorkingHoursStart;}

+(Business*) getByID:(NSString*)identifier
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:self.entityName];
    NSString *predicate = [NSString stringWithFormat: @"%@=='%@'", OBJECT_ID, identifier];
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
    if(type==nil)
    {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:Business.entityName];
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
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:Business.entityName];
    NSString *predicate = [NSString stringWithFormat: @"%@==%ld", Business.colUid, (long)identifier];
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
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:self.entityName];
    NSString *predicate = [NSString stringWithFormat: @"%@==%ld", Business.colUid, (long)identifier];
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
    Business *business = [NSEntityDescription insertNewObjectForEntityForName:self.entityName
                                                       inManagedObjectContext:[Model sharedModel].managedObjectContext];
    business.pObjectID=object.objectId;
    if(object[Business.pName]!=nil) business.name=object[Business.pName];
    business.welcomeText=object[Business.pWelcomeText];
    if(object[Business.pUid]!=nil) business.uid=object[Business.pUid];
    business.workingHoursStart=object[Business.pWorkingHoursStart];
    business.workingHoursEnd=object[Business.pWorkingHoursEnd];
    PFFile *logo=object[Business.pLogo];
    
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
