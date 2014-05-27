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

+(NSString*) entityName
{
    return LINK;
}


+(Link*) getByID:(NSString*)identifier
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
        return (Link*)result.firstObject;
}

+(NSString*)parseName:(NSString*)coreDataName
{
    if ([coreDataName isEqual:LINK])
        return @"Links";
    if ([coreDataName isEqual:LINK_BUSINESS])
        return @"business";
    return coreDataName;
}

+ (void)createFromParseObject:(PFObject *)object
{
    Link *link = [NSEntityDescription insertNewObjectForEntityForName:[self entityName]
                                                   inManagedObjectContext:[Model sharedModel].managedObjectContext];
    link.pObjectID=object[OBJECT_ID];
    link.url=object[[Link parseName:LINK_URL]];
    
    NSError *error;
    PFObject *retrievedBusiness=[object[[Link parseName:LINK_BUSINESS]] fetchIfNeeded:&error];
    
    if (!error)
    {
        Business *linkedBusiness=[Business getByID:(NSString*)(retrievedBusiness[OBJECT_ID])];
        link.parentBusiness = linkedBusiness;
        [linkedBusiness addLinksObject:link];
    }
    else
        NSLog(@"%@",[error localizedDescription]);
}



@end
