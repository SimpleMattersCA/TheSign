//
//  TagSet.m
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-05-26.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import "TagSet.h"
#import "Featured.h"
#import "Tag.h"
#import "Model.h"

@implementation TagSet

@dynamic weight;
@dynamic pObjectID;
@dynamic taggedFeature;
@dynamic tagInSet;


+(NSString*) entityName
{
    return TAGSET;
}

+(NSString*) parseEntityName
{
    return [self parseName:[self entityName]];
}

+(NSString*)parseName:(NSString*)coreDataName
{
    //so far Parse names for this class are exactly the same as those for CoreData
    //for cases when they're not, add something like this:
    //if ([coreDataName isEqual:@"Something"])
    //    return @"somethingElse";
    
    return coreDataName;
}

+(TagSet*) getByID:(NSString*)identifier
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
        return (TagSet*)result.firstObject;
}

+(void)createFromParseObject:(PFObject *)object
{
    TagSet *tagset = [NSEntityDescription insertNewObjectForEntityForName:[self entityName]
                                                   inManagedObjectContext:[Model sharedModel].managedObjectContext];
    tagset.pObjectID=object[OBJECT_ID];
    tagset.weight=object[[TagSet parseName:TAGSET_WEIGHT]];
}

@end
