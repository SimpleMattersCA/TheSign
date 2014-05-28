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

@implementation Link

@dynamic pObjectID;
@dynamic url;
@dynamic parentBusiness;

+(NSString*) entityName {return @"Link";}
+(NSString*) parseEntityName {return @"Links";}

+(NSString*)colUrl {return @"url";}
+(NSString*)colParentBusiness {return @"parentBusiness";}

+(NSString*)pUrl {return Link.colUrl;}
+(NSString*)pParentBusiness {return @"business";}

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


+ (void)createFromParseObject:(PFObject *)object
{
    Link *link = [NSEntityDescription insertNewObjectForEntityForName:[self entityName]
                                                   inManagedObjectContext:[Model sharedModel].managedObjectContext];
    link.pObjectID=object.objectId;
    if(object[Link.pUrl]!=nil) link.url=object[Link.pUrl];
    
    NSError *error;
    PFObject *retrievedBusiness=[object[Link.pParentBusiness] fetchIfNeeded:&error];
    
    if (!error)
    {
        Business *linkedBusiness=[Business getByID:(NSString*)(retrievedBusiness.objectId)];
        link.parentBusiness = linkedBusiness;
        [linkedBusiness addLinksObject:link];
    }
    else
        NSLog(@"%@",[error localizedDescription]);
}



@end
