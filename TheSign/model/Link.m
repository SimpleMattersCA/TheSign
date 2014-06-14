//
//  Link.m
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-05-24.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import "Link.h"
#import "Business.h"
#import "Model.h"

#define CD_URL (@"url")
#define CD_BUSINESS (@"parentBusiness")

#define P_URL (@"url")
#define P_BUSINESS (@"business")

@implementation Link

@dynamic pObjectID;
@dynamic url;
@dynamic parentBusiness;

@synthesize parseObject=_parseObject;

+(NSString*) entityName {return @"Link";}
+(NSString*) parseEntityName {return @"Links";}

+(Link*) getByID:(NSString*)identifier
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
        return (Link*)result.firstObject;
}


+ (void)createFromParse:(PFObject *)object
{
    Link *link = [NSEntityDescription insertNewObjectForEntityForName:[self entityName]
                                                   inManagedObjectContext:[Model sharedModel].managedObjectContext];
    link.parseObject=object;
    link.pObjectID=object.objectId;
    if(object[P_URL]!=nil) link.url=object[P_URL];
    
    NSError *error;
    PFObject *fromParseBusiness=[object[P_BUSINESS] fetchIfNeeded:&error];
    
    if (!error)
    {
        Business *linkedBusiness=[Business getByID:fromParseBusiness.objectId];
        link.parentBusiness = linkedBusiness;
        [linkedBusiness addLinksObject:link];
    }
    else
        NSLog(@"%@",[error localizedDescription]);
}

-(void)refreshFromParse
{
    NSError *error;
    [self.parseObject refresh:&error];
    if(error)
    {
        NSLog(@"%@",[error localizedDescription]);
        return;
    }
    
    self.url=self.parseObject[P_URL];
    
    PFObject *fromParseBusiness=[self.parseObject[P_BUSINESS] fetchIfNeeded:&error];
    
    if (!error)
    {
        [self.parentBusiness removeLinksObject:self];
        Business *linkedBusiness=[Business getByID:fromParseBusiness.objectId];
        self.parentBusiness = linkedBusiness;
        [linkedBusiness addLinksObject:self];
    }
    else
        NSLog(@"%@",[error localizedDescription]);
}


@end
