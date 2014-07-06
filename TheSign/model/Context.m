//
//  Context.m
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-07-04.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import "Context.h"
#import "Featured.h"
#import "Tag.h"
#import "Model.h"

#define P_NAME (@"name")
#define P_PROBABILITY (@"probability")

#define CD_NAME (@"name")
#define CD_PROBABILITY (@"probability")

@implementation Context

@dynamic pObjectID;
@dynamic name;
@dynamic probability;
@dynamic linkedTags;
@dynamic linkedOffers;

@synthesize parseObject=_parseObject;

+(NSString*) entityName {return @"Context";}
+(NSString*) parseEntityName {return @"Context";}

+(Boolean)checkIfParseObjectRight:(PFObject*)object
{
    if(object[P_NAME] && object[P_PROBABILITY])
        return YES;
    else
        return NO;
}

+(Context*) getByID:(NSString*)identifier
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
        return (Context*)result.firstObject;
}


+ (void)createFromParse:(PFObject *)object
{
    if([self checkIfParseObjectRight:object]==NO)
    {
        NSLog(@"The object %@ is missing mandatory fields",object.objectId);
        return;
    }
    
    Context *context = [NSEntityDescription insertNewObjectForEntityForName:self.entityName
                                             inManagedObjectContext:[Model sharedModel].managedObjectContext];
    context.parseObject=object;
    context.pObjectID=object.objectId;
    context.name=object[P_NAME];
    context.probability=object[P_PROBABILITY];
}

-(void)refreshFromParse
{
    NSError *error;
    [self.parseObject refresh:&error];
    if(error)
    {
        NSLog(@"%@",[error localizedDescription]);
        return;
    }
    
    if([self.class checkIfParseObjectRight:self.parseObject]==NO)
    {
        NSLog(@"The object %@ is missing mandatory fields",self.parseObject.objectId);
        return;
    }
    
    self.name=self.parseObject[P_NAME];
    self.probability=self.parseObject[P_PROBABILITY];
}


@end
