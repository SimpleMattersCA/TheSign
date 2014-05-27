//
//  TagClass.m
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-05-26.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import "TagClass.h"
#import "TagClassConnection.h"
#import "TagClassRelation.h"
#import "Model.h"

@implementation TagClass

@dynamic name;
@dynamic pObjectID;
@dynamic controllClassConnection;
@dynamic relatedClassConnection;
@dynamic tagsInClass;

+(NSString*) entityName
{
    return TAGCLASS;
}

+(NSString*)parseName:(NSString*)coreDataName
{
    //so far Parse names for this class are exactly the same as those for CoreData
    //for cases when they're not, add something like this:
    //if ([coreDataName isEqual:@"Something"])
    //    return @"somethingElse";
    
    return coreDataName;
}

+(TagClass*) getByID:(NSString*)identifier
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
        return (TagClass*)result.firstObject;
}

+(void)createFromParseObject:(PFObject *)object
{
    TagClass *tagclass = [NSEntityDescription insertNewObjectForEntityForName:[self entityName]
                                                       inManagedObjectContext:[Model sharedModel].managedObjectContext];
    tagclass.pObjectID=object[OBJECT_ID];
    tagclass.name=object[[TagClass parseName:TAGCLASS_NAME]];
}

@end
