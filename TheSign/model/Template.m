//
//  Template.m
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-07-05.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import "Template.h"
#import "Tag.h"
#import "Model.h"
#import "Featured.h"
#define P_MESSAGE (@"messageText")
#define P_CONTEXT (@"contextTag")
#define P_CATEGORY (@"categoryTag")


@implementation Template

@dynamic pObjectID;
@dynamic messageText;
@dynamic linkedContextTag;
@dynamic linkedCategoryTag;

@synthesize parseObject=_parseObject;

+(NSString*) entityName {return @"Template";}
+(NSString*) parseEntityName {return @"Templates";}


+(Boolean)checkIfParseObjectRight:(PFObject*)object
{
    if(object[P_MESSAGE])
        return YES;
    else
        return NO;
}

+(Template*) getByID:(NSString*)identifier
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
        return (Template*)result.firstObject;
}


+ (void)createFromParse:(PFObject *)object
{
    if([self checkIfParseObjectRight:object]==NO)
    {
        NSLog(@"The object %@ is missing mandatory fields",object.objectId);
        return;
    }
    
    Template *template = [NSEntityDescription insertNewObjectForEntityForName:self.entityName
                                             inManagedObjectContext:[Model sharedModel].managedObjectContext];
    template.parseObject=object;
    template.pObjectID=object.objectId;
    template.messageText=object[P_MESSAGE];

    if(!object[P_CONTEXT])
    {
        //careful, incomplete object - only objectId property is there
        PFObject *fromParseTag=object[P_CONTEXT];
        Tag *linkedTag=[Tag getByID:fromParseTag.objectId];
        if (linkedTag!=nil)
        {
            template.linkedContextTag = linkedTag;
            [linkedTag addLinkedContextTemplatesObject:template];
        }
        else
            NSLog(@"Linked context tag wasn't found");
    }
    
    if(!object[P_CATEGORY])
    {
        //careful, incomplete object - only objectId property is there
        PFObject *fromParseTag=object[P_CATEGORY];
        Tag *linkedTag=[Tag getByID:fromParseTag.objectId];
        if (linkedTag!=nil)
        {
            template.linkedCategoryTag = linkedTag;
            [linkedTag addLinkedCategoryTemplatesObject:template];
        }
        else
            NSLog(@"Linked categoory tag wasn't found");
    }
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
    
    self.messageText=self.parseObject[P_MESSAGE];
    
    if(!self.parseObject[P_CONTEXT])
    {
        //careful, incomplete object - only objectId property is there
        PFObject *fromParseTag=self.parseObject[P_CONTEXT];
        Tag *linkedTag=[Tag getByID:fromParseTag.objectId];
        if (linkedTag!=nil)
        {
            self.linkedContextTag = linkedTag;
            [linkedTag addLinkedContextTemplatesObject:self];
        }
        else
            NSLog(@"Linked context tag wasn't found");
    }
    
    if(!self.parseObject[P_CATEGORY])
    {
        //careful, incomplete object - only objectId property is there
        PFObject *fromParseTag=self.parseObject[P_CATEGORY];
        Tag *linkedTag=[Tag getByID:fromParseTag.objectId];
        if (linkedTag!=nil)
        {
            self.linkedCategoryTag = linkedTag;
            [linkedTag addLinkedCategoryTemplatesObject:self];
        }
        else
            NSLog(@"Linked category tag wasn't found");
    }
}


-(NSString*) generateMessageForOffer:(Featured*)offer
{
    if(offer && self.messageText.length!=0 && offer.title.length!=0)
        return [NSString stringWithFormat:@"%@ %@",self.messageText,offer.title];
    else
        return nil;
}

@end
