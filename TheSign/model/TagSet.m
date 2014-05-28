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


+(NSString*) entityName {return @"TagSet";}
+(NSString*) parseEntityName {return @"TagSet";}

+(NSString*)colWeight {return @"weight";}
+(NSString*)colTaggedFeature {return @"taggedFeature";}
+(NSString*)colTagInSet {return @"tagInSet";}

+(NSString*)pWeight {return TagSet.colWeight;}
+(NSString*)pTaggedFeature {return @"DealID";}
+(NSString*)pTagInSet {return @"TagID";}

+(TagSet*) getByID:(NSString*)identifier
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
        return (TagSet*)result.firstObject;
}

+(void)createFromParseObject:(PFObject *)object
{
    TagSet *tagset = [NSEntityDescription insertNewObjectForEntityForName:self.entityName
                                                   inManagedObjectContext:[Model sharedModel].managedObjectContext];
    tagset.pObjectID=object.objectId;
    tagset.weight=object[TagSet.pWeight];
    
    NSError *error;
    
    PFObject *retrievedFeatured=[object[TagSet.pTaggedFeature] fetchIfNeeded:&error];
    
    if (!error)
    {
        Featured *linkedFeatured=[Featured getByID:(NSString*)(retrievedFeatured.objectId)];
        tagset.taggedFeature = linkedFeatured;
        [linkedFeatured addFeaturedTagSetsObject:tagset];
        
    }
    else
        NSLog(@"%@",[error localizedDescription]);
    
    
    PFObject *retrievedTag=[object[TagSet.pTagInSet] fetchIfNeeded:&error];
    
    if (!error)
    {
        Tag *linkedTag=[Tag getByID:(NSString*)(retrievedTag.objectId)];
        tagset.tagInSet = linkedTag;
        [linkedTag addTagSetsObject:tagset];
    }
    else
        NSLog(@"%@",[error localizedDescription]);
    
}

@end
