//
//  Tag.m
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-06-19.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import "Tag.h"
#import "Like.h"
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

@implementation Tag

@dynamic interest;
@dynamic name;
@dynamic pObjectID;
@dynamic linkedConnectionsFrom;
@dynamic linkedLike;
@dynamic linkedTagSets;
@dynamic linkedConnectionsTo;
@dynamic linkedContext;
@dynamic linkedCategoryTemplates;
@dynamic linkedContextTemplates;




#pragma mark - Sign Entity Protocol

@synthesize parseObject=_parseObject;

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
    tag.parseObject=object;
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
    NSError *error;
    [self.parseObject refresh:&error];
    if(error)
    {
        NSLog(@"%@",[error localizedDescription]);
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
    if(effect>=[Model sharedModel].min_like_level.doubleValue && self.linkedContext==nil)
    {
        [Like changeLikenessForTag:self ByValue:@(effect)];
        for (TagConnection* connection in self.linkedConnectionsFrom)
        {
            if(connection.linkedTagTo && ![*processedTags containsObject:connection.linkedTagTo.pObjectID])
            {
                [*processedTags addObject:connection.linkedTagTo.pObjectID];
                [connection.linkedTagTo processLike:effect*connection.weight.doubleValue AlreadyProcessed:processedTags];
            }
        }
        for (TagConnection* connection in self.linkedConnectionsTo)
        {
            if(connection.linkedTagFrom && ![*processedTags containsObject:connection.linkedTagFrom.pObjectID])
            {
                [*processedTags addObject:connection.linkedTagFrom.pObjectID];
                [connection.linkedTagFrom processLike:effect*connection.weight.doubleValue AlreadyProcessed:processedTags];
            }
        }
    }
}

-(double) calculateRelevancyOnLevel:(NSInteger)depth
{
    double cumulativeScore=0;
    //we go only for a certain levels deep into the tag graph
    if(depth<=[Model sharedModel].relevancyDepth.integerValue)
    {
        if(self.linkedLike && self.linkedContext==nil)
            cumulativeScore=self.linkedLike.likeness.doubleValue;
        
        for (TagConnection* connection in self.linkedConnectionsFrom)
        {
            if(connection.linkedTagTo)
            {
                if(connection.linkedTagTo.linkedLike)
                    cumulativeScore+=connection.linkedTagTo.linkedLike.likeness.doubleValue;
                cumulativeScore+=[connection.linkedTagTo calculateRelevancyOnLevel:depth+1];
            }
        }
        for (TagConnection* connection in self.linkedConnectionsTo)
        {
            if(connection.linkedTagFrom)
            {
                if(connection.linkedTagFrom.linkedLike)
                    cumulativeScore+=connection.linkedTagFrom.linkedLike.likeness.doubleValue;
                cumulativeScore+=[connection.linkedTagFrom calculateRelevancyOnLevel:depth+1];
            }
        }
    }
    return cumulativeScore;
}

@end
