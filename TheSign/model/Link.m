//
//  Link.m
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-06-19.
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
@dynamic icon;
@dynamic linkedBusiness;


@synthesize parseObject=_parseObject;

+(NSString*) entityName {return @"Link";}
+(NSString*) parseEntityName {return @"Links";}

+(Link*) getByID:(NSString*)identifier
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:self.entityName];
    request.predicate=[NSPredicate predicateWithFormat:@"%@=='%@'", OBJECT_ID, identifier];
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
    
    //careful, incomplete object - only objectId property is there
    PFObject *fromParseBusiness=object[P_BUSINESS];
    Business *linkedBusiness=[Business getByID:fromParseBusiness.objectId];
    if (linkedBusiness!=nil)
    {
        link.linkedBusiness = linkedBusiness;
        [linkedBusiness addLinkedLinksObject:link];
    }
    else
        NSLog(@"Linked business wasn't found");
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
    
    //no need to fetch it entirely from parse as we use only objectId property
    PFObject *fromParseBusiness=self.parseObject[P_BUSINESS];
    if (fromParseBusiness.objectId!=self.linkedBusiness.pObjectID)
    {
        [self.linkedBusiness removeLinkedLinksObject:self];
        Business *linkedBusiness=[Business getByID:fromParseBusiness.objectId];
        if (linkedBusiness!=nil)
        {
            self.linkedBusiness = linkedBusiness;
            [linkedBusiness addLinkedLinksObject:self];
        }
        else
            NSLog(@"Linked business wasn't found");
    }
}

@end
