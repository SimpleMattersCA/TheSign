//
//  TagClassConnection.m
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-05-24.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import "TagClassConnection.h"
#import "TagClass.h"
#import "Model.h"

@implementation TagClassConnection

@dynamic pObjectID;
@dynamic weight;
@dynamic controllClass;
@dynamic relatedClass;

+(NSString*)parseName:(NSString*)coreDataName
{
    //so far Parse names for this class are exactly the same as those for CoreData
    //for cases when they're not, add something like this:
    //if ([coreDataName isEqual:@"Something"])
    //    return @"somethingElse";
    return coreDataName;
}

+(NSString*) entityName
{
    return TAGCLASSCONNECTION;
}

+(NSString*) parseEntityName
{
    return [self parseName:[self entityName]];
}

+(TagClassConnection*) getByID:(NSString*)identifier
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
        return (TagClassConnection*)result.firstObject;
}

+ (void)createFromParseObject:(PFObject *)object
{
    TagClassConnection *connection = [NSEntityDescription insertNewObjectForEntityForName:[self entityName]
                                                   inManagedObjectContext:[Model sharedModel].managedObjectContext];
    connection.pObjectID=object[OBJECT_ID];
    connection.weight=object[[TagClassConnection parseName:TAGCLASSCONNECTION_WEIGHT]];

    NSError *error;
    
    PFObject *retrievedControlClass=[object[[TagClassConnection parseName:TAGCLASSCONNECTION_CONTROLCLASS]] fetchIfNeeded:&error];
    if (!error)
    {
        TagClass *linkedControlClass=[TagClass getByID:(NSString*)(retrievedControlClass[OBJECT_ID])];
        connection.controllClass=linkedControlClass;
        [linkedControlClass addControllClassConnectionObject:connection];
    }
    else
        NSLog(@"%@",[error localizedDescription]);
    
    PFObject *retrievedRelatedClass=[object[[TagClassConnection parseName:TAGCLASSCONNECTION_RELATEDCLASS]] fetchIfNeeded:&error];
    if (!error)
    {
        TagClass *linkedRelatedClass=[TagClass getByID:(NSString*)(retrievedRelatedClass[OBJECT_ID])];
        connection.relatedClass=linkedRelatedClass;
        [linkedRelatedClass addRelatedClassConnectionObject:connection];
    }
    else
        NSLog(@"%@",[error localizedDescription]);
}



@end
