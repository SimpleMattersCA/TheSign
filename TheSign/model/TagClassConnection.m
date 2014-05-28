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


+(NSString*) entityName {return @"TagClassConnection";}
+(NSString*) parseEntityName {return @"TagClassConnection";}

+(NSString*)colWeight {return @"weight";}
+(NSString*)colControlClass {return @"controllClass";}
+(NSString*)colRelatedClass {return @"relatedClass";}

+(NSString*)pWeight {return @"weight";}
+(NSString*)pControlClass {return @"ControlClass";}
+(NSString*)pRelatedClass {return @"RelatedClass";}

+(TagClassConnection*) getByID:(NSString*)identifier
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[self entityName]];
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
        return (TagClassConnection*)result.firstObject;
}

+ (void)createFromParseObject:(PFObject *)object
{
    TagClassConnection *connection = [NSEntityDescription insertNewObjectForEntityForName:[self entityName]
                                                   inManagedObjectContext:[Model sharedModel].managedObjectContext];
    connection.pObjectID=object.objectId;
    if(object[TagClassConnection.pWeight]!=nil) connection.weight=object[TagClassConnection.pWeight];

    NSError *error;
    PFObject *retrievedControlClass=[object[TagClassConnection.pControlClass] fetchIfNeeded:&error];
    if (!error)
    {
        TagClass *linkedControlClass=[TagClass getByID:(NSString*)(retrievedControlClass.objectId)];
        connection.controllClass=linkedControlClass;
        [linkedControlClass addControllClassConnectionObject:connection];
    }
    else
        NSLog(@"%@",[error localizedDescription]);
    
    PFObject *retrievedRelatedClass=[object[TagClassConnection.pRelatedClass] fetchIfNeeded:&error];
    if (!error)
    {
        TagClass *linkedRelatedClass=[TagClass getByID:(NSString*)(retrievedRelatedClass.objectId)];
        connection.relatedClass=linkedRelatedClass;
        [linkedRelatedClass addRelatedClassConnectionObject:connection];
    }
    else
        NSLog(@"%@",[error localizedDescription]);
}



@end
