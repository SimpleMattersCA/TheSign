//
//  TagClassRelation.m
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-05-26.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import "TagClassRelation.h"
#import "Tag.h"
#import "TagClass.h"
#import "Model.h"

@implementation TagClassRelation

@dynamic weight;
@dynamic pObjectID;
@dynamic relatedTag;
@dynamic relatedClass;

+(NSString*) entityName {return @"TagClassRelation";}
+(NSString*) parseEntityName {return @"TagClassRelation";}

+(NSString*) colWeight {return @"weight";}
+(NSString*) colTag {return @"relatedTag";}
+(NSString*) colClass {return @"relatedClass";}

+(NSString*) pWeight {return TagClassRelation.colWeight;}
+(NSString*) pTag {return @"tag";}
+(NSString*) pClass {return @"tagClass";}

+(TagClassRelation*) getByID:(NSString*)identifier
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
        return (TagClassRelation*)result.firstObject;
}


+ (void)createFromParseObject:(PFObject *)object
{
    TagClassRelation *relation = [NSEntityDescription insertNewObjectForEntityForName:[self entityName]
                                             inManagedObjectContext:[Model sharedModel].managedObjectContext];
    relation.pObjectID=object.objectId;
    if(object[TagClassRelation.pWeight]!=nil) relation.weight=object[TagClassRelation.pWeight];
    
    NSError *error;
    
    PFObject *retrievedClass=[object[TagClassRelation.pClass] fetchIfNeeded:&error];
    
    if (!error)
    {
        TagClass *linkedClass=[TagClass getByID:(NSString*)(retrievedClass.objectId)];
        relation.relatedClass = linkedClass;
        [linkedClass addTagsInClassObject:relation];

    }
    else
        NSLog(@"%@",[error localizedDescription]);
    
    
    PFObject *retrievedTag=[object[TagClassRelation.pTag] fetchIfNeeded:&error];
    
    if (!error)
    {
        Tag *linkedTag=[Tag getByID:(NSString*)(retrievedTag.objectId)];
        relation.relatedTag = linkedTag;
        [linkedTag addTagClassesObject:relation];

    }
    else
        NSLog(@"%@",[error localizedDescription]);
    
}

@end
