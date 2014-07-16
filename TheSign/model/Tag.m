//
//  Tag.m
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-06-19.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import "Tag.h"
#import "TagConnection.h"
#import "TagSet.h"
#import "Model.h"
#import "Context.h"

#define P_NAME (@"name")
#define P_INTEREST (@"interest")
#define P_CONTEXT (@"context")

#define CD_NAME (@"name")
#define CD_INTEREST (@"interest")
#define CD_CONTEXT (@"context")
#define CD_INTEREST (@"interest")

@implementation Tag

@dynamic interest;
@dynamic name;
@dynamic likeness;
@dynamic pObjectID;
@dynamic linkedConnectionsFrom;
@dynamic linkedTagSets;
@dynamic linkedConnectionsTo;
@dynamic linkedContext;
@dynamic linkedCategoryTemplates;
@dynamic linkedContextTemplates;




#pragma mark - Sign Entity Protocol

@synthesize parseObject=_parseObject;

-(PFObject*)parseObject
{
    if(!_parseObject)
    {
        NSError *error;
        if(!error)
            _parseObject=[PFQuery getObjectOfClass:[self.class parseEntityName] objectId:self.pObjectID error:&error];
        else
            NSLog(@"%@",[error localizedDescription]);
    }
    return _parseObject;
}

+(NSString*) entityName {return @"Tag";}
+(NSString*) parseEntityName {return @"Tag";}

+(Boolean)checkIfParseObjectRight:(PFObject*)object
{
    if(object[P_NAME])
        return YES;
    else
        return NO;
}

+(Tag*) getByID:(NSString*)identifier
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:self.entityName];
    request.predicate=[NSPredicate predicateWithFormat:[NSString stringWithFormat: @"%@='%@'", OBJECT_ID, identifier]];
    NSError *error;
    NSArray *result = [[Model sharedModel].managedObjectContext executeFetchRequest:request error:&error];
    
    if(error)
    {
        NSLog(@"%@",[error localizedDescription]);
        return nil;
    }
    else
        return result.firstObject;
}


+ (Boolean)createFromParse:(PFObject *)object
{
    if([self checkIfParseObjectRight:object]==NO)
    {
        NSLog(@"%@: The object %@ is missing mandatory fields",self.entityName,object.objectId);
        return NO;
    }
    
    Boolean complete=YES;

    Tag *tag = [NSEntityDescription insertNewObjectForEntityForName:self.entityName
                                             inManagedObjectContext:[Model sharedModel].managedObjectContext];
    tag.pObjectID=object.objectId;
    tag.name=object[P_NAME];
    if(object[P_INTEREST]) tag.interest=object[P_INTEREST];
    if(object[P_CONTEXT])
    {
        //careful, incomplete object - only objectId property is there
        PFObject *fromParseContext=object[P_CONTEXT];
        Context *linkedContext=[Context getByID:fromParseContext.objectId];
        if (linkedContext!=nil)
        {
            tag.linkedContext = linkedContext;
            [linkedContext addLinkedTagsObject:tag];
        }
        else
        {
            NSLog(@"Linked context wasn't found");
            complete=NO;
        }
    }
    
    return complete;
}

-(Boolean)refreshFromParse
{
    if(!self.parseObject)
    {
        NSLog(@"%@: Couldn't fetch the parse object with id: %@",[self.class entityName],self.pObjectID);
        return NO;
    }
    
    if([self.class checkIfParseObjectRight:self.parseObject]==NO)
    {
        NSLog(@"The object %@ is missing mandatory fields",self.parseObject.objectId);
        return NO;
    }
    
    Boolean complete=YES;

    self.name=self.parseObject[P_NAME];
    if(self.parseObject[P_INTEREST]) self.interest=self.parseObject[P_INTEREST];
    if(self.parseObject[P_CONTEXT])
    {
        //careful, incomplete object - only objectId property is there
        PFObject *fromParseContext=self.parseObject[P_CONTEXT];
        Context *linkedContext=[Context getByID:fromParseContext.objectId];
        if (linkedContext!=nil)
        {
            self.linkedContext = linkedContext;
            [linkedContext addLinkedTagsObject:self];
        }
        else
        {
            NSLog(@"Linked context wasn't found");
            complete=NO;
        }
    }
    
    return complete;
}

+(NSInteger)getRowCount
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:self.entityName];
    NSError *error;
    NSInteger result = [[Model sharedModel].managedObjectContext countForFetchRequest:request error:&error];
    
    if(error)
    {
        NSLog(@"%@",[error localizedDescription]);
        return 0;
    }
    else
        return result;
}

-(void)processLike:(double)effect AlreadyProcessed:(NSMutableSet**)processedTags
{
    if(self.linkedContext==nil && ![*processedTags containsObject:self.pObjectID] && fabs(effect)>=[Model sharedModel].min_like_level.doubleValue)
    {
        [*processedTags addObject:self.pObjectID];
        [self changeLikenessByValue:@(effect)];
        
        for (TagConnection* connection in self.linkedConnectionsFrom)
        {
            if(connection.linkedTagTo && ![*processedTags containsObject:connection.linkedTagTo.pObjectID])
            {
                [connection.linkedTagTo processLike:effect*connection.weight.doubleValue AlreadyProcessed:processedTags];
            }
        }
        for (TagConnection* connection in self.linkedConnectionsTo)
        {
            if(connection.linkedTagFrom && ![*processedTags containsObject:connection.linkedTagFrom.pObjectID])
            {
                [connection.linkedTagFrom processLike:effect*connection.weight.doubleValue AlreadyProcessed:processedTags];
            }

        }
    }
}

-(double) calculateRelevancyOnLevel:(NSInteger)depth AlreadyProcessed:(NSMutableSet**)processedTags
{
    double cumulativeScore=0;
    //we go only for a certain levels deep into the tag graph
    if(self.linkedContext==nil && ![*processedTags containsObject:self.pObjectID] && depth<=[Model sharedModel].relevancyDepth.integerValue)
    {
        [*processedTags addObject:self.pObjectID];
        cumulativeScore=self.likeness.doubleValue;
        
        for (TagConnection* connection in self.linkedConnectionsFrom)
        {
            if(connection.linkedTagTo && ![*processedTags containsObject:connection.linkedTagTo.pObjectID])
            {
                cumulativeScore+=[connection.linkedTagTo calculateRelevancyOnLevel:depth+1 AlreadyProcessed:processedTags];
            }
        }
        for (TagConnection* connection in self.linkedConnectionsTo)
        {
            if(connection.linkedTagFrom && ![*processedTags containsObject:connection.linkedTagFrom.pObjectID])
            {
                cumulativeScore+=[connection.linkedTagFrom calculateRelevancyOnLevel:depth+1 AlreadyProcessed:processedTags];
            }
        }
    }
    return cumulativeScore;
}


-(void)changeLikenessByValue:(NSNumber*)value
{
    self.likeness=@(self.likeness.doubleValue+value.doubleValue);
}


+(NSArray*)getInterests
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:self.entityName];
    request.predicate=[NSPredicate predicateWithFormat:[NSString stringWithFormat: @"%@=%d", CD_INTEREST, YES]];
    NSError *error;
    NSArray *result = [[Model sharedModel].managedObjectContext executeFetchRequest:request error:&error];
    
    if(error)
    {
        NSLog(@"%@",[error localizedDescription]);
        return nil;
    }
    else
        return result;

}


@end
