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




#pragma mark - Sign Entity Protocol

@synthesize parseObject=_parseObject;

+(NSString*) entityName {return @"Link";}
+(NSString*) parseEntityName {return @"Links";}


+(Boolean)checkIfParseObjectRight:(PFObject*)object
{
    if(object[P_URL] && object[P_BUSINESS])
        return YES;
    else
        return NO;
}


+(Link*) getByID:(NSString*)identifier
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:self.entityName];
    request.predicate=[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@='%@'", OBJECT_ID, identifier]];
    NSError *error;
    NSArray *result = [[Model sharedModel].managedObjectContext executeFetchRequest:request error:&error];
    
    if(error)
    {
        NSLog(@"%@",[error localizedDescription]);
        return nil;
    }
    else
        return result.firstObject;
}


+ (Boolean)createFromParse:(PFObject *)object
{
    if([Link checkIfParseObjectRight:object]==NO)
    {
        NSLog(@"%@: The object %@ is missing mandatory fields",self.entityName,object.objectId);
        return NO;
    }
    
    Boolean complete=YES;

    Link *link = [NSEntityDescription insertNewObjectForEntityForName:Link.entityName
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
    {
        NSLog(@"Linked business wasn't found");
        complete=NO;
    }
    
    return complete;
}

-(Boolean)refreshFromParse
{
    NSError *error;
    [self.parseObject refresh:&error];
    if(error)
    {
        NSLog(@"%@",[error localizedDescription]);
        return NO;
    }
    
    if([Link checkIfParseObjectRight:self.parseObject]==NO)
    {
        NSLog(@"The object %@ is missing mandatory fields",self.parseObject.objectId);
        return NO;
    }
    
    Boolean complete=YES;

    self.url=self.parseObject[P_URL];
    
    //careful, incomplete object - only objectId property is there
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
        {
            NSLog(@"Linked business wasn't found");
            complete=NO;
        }
    }
    
    return complete;
}

+(NSInteger)getRowCount
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:self.entityName];
    NSError *error;
    NSInteger result = [[Model sharedModel].managedObjectContext countForFetchRequest:request error:&error];
    
    if(error)
    {
        NSLog(@"%@",[error localizedDescription]);
        return 0;
    }
    else
        return result;
}

@end
