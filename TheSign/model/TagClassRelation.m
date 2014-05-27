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

+(NSString*) entityName
{
    return TAGCLASSRELATION;
}
+(NSString*) parseEntityName
{
    return [self parseName:[self entityName]];
}

+(TagClassRelation*) getByID:(NSString*)identifier
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
        return (TagClassRelation*)result.firstObject;
}

+(NSString*)parseName:(NSString*)coreDataName
{
    if ([coreDataName isEqual:TAGCLASSRELATION_TAG])
        return @"tag";
    if ([coreDataName isEqual:TAGCLASSRELATION_CLASS])
        return @"tagClass";
    return coreDataName;
}


+ (void)createFromParseObject:(PFObject *)object
{
    TagClassRelation *relation = [NSEntityDescription insertNewObjectForEntityForName:[self entityName]
                                             inManagedObjectContext:[Model sharedModel].managedObjectContext];
    relation.pObjectID=object[OBJECT_ID];
    relation.weight=object[[TagClassRelation parseName:TAGCLASSRELATION_WEIGHT]];
    
    NSError *error;
    
    PFObject *retrievedClass=[object[[TagClassRelation parseName:TAGCLASSRELATION_CLASS]] fetchIfNeeded:&error];
    
    if (!error)
    {
        TagClass *linkedClass=[TagClass getByID:(NSString*)(retrievedClass[OBJECT_ID])];
        relation.relatedClass = linkedClass;
        [linkedClass addTagsInClassObject:relation];

    }
    else
        NSLog(@"%@",[error localizedDescription]);
    
    
    PFObject *retrievedTag=[object[[TagClassRelation parseName:TAGCLASSRELATION_TAG]] fetchIfNeeded:&error];
    
    if (!error)
    {
        Tag *linkedTag=[Tag getByID:(NSString*)(retrievedTag[OBJECT_ID])];
        relation.relatedTag = linkedTag;
        [linkedTag addTagClassesObject:relation];

    }
    else
        NSLog(@"%@",[error localizedDescription]);
    
}

@end
