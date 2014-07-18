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
#import "Business.h"
#import "User.h"

#define CD_MESSAGE (@"messageText")
#define CD_CONTEXT (@"linkedContextTag")
#define CD_CATEGORY (@"linkedCategoryTag")

#define P_MESSAGE (@"messageText")
#define P_CONTEXT (@"contextTag")
#define P_CATEGORY (@"categoryTag")


@implementation Template

@dynamic pObjectID;
@dynamic messageText;
@dynamic linkedContextTag;
@dynamic linkedCategoryTag;




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

+(NSString*) entityName {return @"Template";}
+(NSString*) parseEntityName {return @"Templates";}


+(Boolean)checkIfParseObjectRight:(PFObject*)object
{
    if(object[P_MESSAGE])
        return YES;
    else
        return NO;
}

+(Template*) getByID:(NSString*)identifier Context:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:self.entityName];
    request.predicate=[NSPredicate predicateWithFormat:[NSString stringWithFormat: @"%@='%@'", OBJECT_ID, identifier]];
    NSError *error;
    NSArray *result = [context executeFetchRequest:request error:&error];
    
    if(error)
    {
        NSLog(@"%@",[error localizedDescription]);
        return nil;
    }
    else
        return result.firstObject;
}


+ (Boolean)createFromParse:(PFObject *)object Context:(NSManagedObjectContext *)context
{
    if([self checkIfParseObjectRight:object]==NO)
    {
        NSLog(@"%@: The object %@ is missing mandatory fields",self.entityName,object.objectId);
        return NO;
    }
    
    Boolean complete=YES;

    Template *template = [NSEntityDescription insertNewObjectForEntityForName:self.entityName
                                             inManagedObjectContext:context];
    template.pObjectID=object.objectId;
    template.messageText=object[P_MESSAGE];

    if(object[P_CONTEXT])
    {
        //careful, incomplete object - only objectId property is there
        PFObject *fromParseTag=object[P_CONTEXT];
        Tag *linkedTag=[Tag getByID:fromParseTag.objectId Context:context];
        if (linkedTag!=nil)
        {
            template.linkedContextTag = linkedTag;
            [linkedTag addLinkedContextTemplatesObject:template];
        }
        else
        {
            NSLog(@"Linked context tag wasn't found");
            complete=NO;
        }
    }
    
    if(object[P_CATEGORY])
    {
        //careful, incomplete object - only objectId property is there
        PFObject *fromParseTag=object[P_CATEGORY];
        Tag *linkedTag=[Tag getByID:fromParseTag.objectId Context:context];
        if (linkedTag!=nil)
        {
            template.linkedCategoryTag = linkedTag;
            [linkedTag addLinkedCategoryTemplatesObject:template];
        }
        else
        {
            NSLog(@"Linked categoory tag wasn't found");
            complete=NO;
        }
    }
    
    return complete;
}

-(Boolean)refreshFromParseForContext:(NSManagedObjectContext *)context
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

    self.messageText=self.parseObject[P_MESSAGE];
    
    if(self.parseObject[P_CONTEXT])
    {
        //careful, incomplete object - only objectId property is there
        PFObject *fromParseTag=self.parseObject[P_CONTEXT];
        Tag *linkedTag=[Tag getByID:fromParseTag.objectId Context:context];
        if (linkedTag!=nil)
        {
            self.linkedContextTag = linkedTag;
            [linkedTag addLinkedContextTemplatesObject:self];
        }
        else
        {
            NSLog(@"Linked context tag wasn't found");
            complete=NO;
        }
    }
    
    if(self.parseObject[P_CATEGORY])
    {
        //careful, incomplete object - only objectId property is there
        PFObject *fromParseTag=self.parseObject[P_CATEGORY];
        Tag *linkedTag=[Tag getByID:fromParseTag.objectId Context:context];
        if (linkedTag!=nil)
        {
            self.linkedCategoryTag = linkedTag;
            [linkedTag addLinkedCategoryTemplatesObject:self];
        }
        else
        {
            NSLog(@"Linked category tag wasn't found");
            complete=NO;
        }
    }
    
    return complete;
}

+(NSInteger)getRowCountForContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:self.entityName];
    NSError *error;
    NSInteger result = [context countForFetchRequest:request error:&error];
    
    if(error)
    {
        NSLog(@"%@",[error localizedDescription]);
        return 0;
    }
    else
        return result;
}


-(NSString*) generateMessageForOffer:(Featured*)offer
{
    if(offer && self.messageText.length!=0 && offer.title.length!=0)
        return [NSString stringWithFormat:@"%@: %@ %@ %@",offer.linkedBusiness.name,[self generateGreeting], self.messageText,offer.title];
    else
        return nil;
}

+(NSArray*)getGenericTemplatesForContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:self.entityName];
    request.predicate=[NSPredicate predicateWithFormat:[NSString stringWithFormat: @"%@=nil", CD_CONTEXT]];
    NSError *error;
    NSArray *result = [context executeFetchRequest:request error:&error];
    
    if(error)
    {
        NSLog(@"%@",[error localizedDescription]);
        return nil;
    }
    else
        return result;
}

-(NSString*)generateGreeting
{
    NSArray *greetingOptions;
    
    User* currentUser=[User currentUser];


    if(currentUser && currentUser.name && ![currentUser.name isEqualToString:@""])
        greetingOptions=[NSArray arrayWithObjects:
                         [NSString stringWithFormat:@"Hi %@!",currentUser.name],
                         [NSString stringWithFormat:@"Hello %@!",currentUser.name],
                         [NSString stringWithFormat:@"Hey %@!",currentUser.name], nil];
    else
        greetingOptions=[NSArray arrayWithObjects:@"Hi there!",@"Hello!",@"Hi!",@"Hey!", nil];
    
    int random=arc4random_uniform((short)greetingOptions.count);
    return greetingOptions[random];
}



@end
