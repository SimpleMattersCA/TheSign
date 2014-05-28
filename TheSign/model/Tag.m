//
//  Tag.m
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-05-26.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import "Tag.h"
#import "TagClassRelation.h"
#import "TagSet.h"
#import "Model.h"


@implementation Tag

@dynamic details;
@dynamic name;
@dynamic pObjectID;
@dynamic tagClasses;
@dynamic tagSets;

+(NSString*) entityName {return @"Tag";}
+(NSString*) parseEntityName {return @"Tag";}

+(NSString*) colName {return @"name";}
+(NSString*) colDetails {return @"details";}

+(NSString*) pName {return Tag.colName;}
+(NSString*) pDetails {return Tag.colDetails;}


+(Tag*) getByID:(NSString*)identifier
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
        return (Tag*)result.firstObject;
}


+ (void)createFromParseObject:(PFObject *)object
{
    Tag *tag = [NSEntityDescription insertNewObjectForEntityForName:self.entityName
                                             inManagedObjectContext:[Model sharedModel].managedObjectContext];
    tag.pObjectID=object.objectId;
    if(object[Tag.pName]!=nil) tag.name=object[Tag.pName];
    tag.details=object[Tag.pDetails];
}


@end
