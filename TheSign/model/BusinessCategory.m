//
//  BusinessCategory.m
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-07-26.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import "BusinessCategory.h"
#import "Business.h"
#import "Model.h"


#define P_ICON (@"iconName")
#define P_NAME (@"name")
#define P_IMAGE (@"iconImage")


@implementation BusinessCategory

@dynamic pObjectID;
@dynamic name;
@dynamic icon;
@dynamic linkedBusinesses;



#pragma mark - Sign Entity Protocol

@synthesize parseObject=_parseObject;

-(PFObject*)parseObject
{
    if(!_parseObject)
    {
        NSError *error;
        if(!error)
            _parseObject=[PFQuery getObjectOfClass:[BusinessCategory parseEntityName] objectId:self.pObjectID error:&error];
        else
            NSLog(@"%@",[error localizedDescription]);
    }
    return _parseObject;
}

+(NSString*) entityName {return @"BusinessCategory";}
+(NSString*) parseEntityName {return @"BusinessCategory";}


+(BusinessCategory*) getByID:(NSString*)identifier Context:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[BusinessCategory entityName]];
    
    request.predicate=[NSPredicate predicateWithFormat: [NSString stringWithFormat:@"%@='%@'", OBJECT_ID, identifier]];
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


+(Boolean)createFromParse:(PFObject *)object Context:(NSManagedObjectContext *)context
{
    if([BusinessCategory checkIfParseObjectRight:object]==NO)
    {
        NSLog(@"%@: The object %@ is missing mandatory fields",[BusinessCategory entityName],object.objectId);
        return NO;
    }
    Boolean complete=YES;
    
    NSError *error;
    BusinessCategory *category = [NSEntityDescription insertNewObjectForEntityForName:[BusinessCategory entityName]
                                                       inManagedObjectContext:context];
    category.pObjectID=object.objectId;
    if(object[P_NAME]) category.name=object[P_NAME];
    if(object[P_IMAGE]!=nil)
    {
        
        PFFile *icon=object[P_IMAGE];
        NSData *pulledIcon;
        pulledIcon=[icon getData:&error];
        if(!error)
        {
            if(pulledIcon!=nil)
                category.icon=pulledIcon;
            else
            {
                NSLog(@"Couldn't pull the icon ");
                complete=NO;
            }
        }
        else
        {
            NSLog(@"%@",[error localizedDescription]);
            complete=NO;
        }
    }
    else
    {
        if(object[P_ICON])
            category.icon=UIImagePNGRepresentation([UIImage imageNamed:object[P_ICON]]);
        else
        {
            NSLog(@"Category icon is missing");
            complete=NO;
        }
    }
    return complete;
}



-(Boolean)refreshFromParseForContext:(NSManagedObjectContext *)context
{
    if(!self.parseObject)
    {
        NSLog(@"%@: Couldn't fetch the parse object with id: %@",[BusinessCategory entityName],self.pObjectID);
        return NO;
    }
    
    if([BusinessCategory checkIfParseObjectRight:self.parseObject]==NO)
    {
        NSLog(@"The object %@ is missing mandatory fields",self.parseObject.objectId);
        return NO;
    }
    
    Boolean complete=YES;
    NSError *error;
    
    if(self.parseObject[P_NAME]) self.name=self.parseObject[P_NAME];
    
    if(self.parseObject[P_IMAGE]!=nil)
    {
        PFFile *icon=self.parseObject[P_IMAGE];
        NSData *pulledIcon;
        pulledIcon=[icon getData:&error];
        if(!error)
        {
            if(pulledIcon!=nil)
                self.icon=pulledIcon;
            else
            {
                NSLog(@"Couldn't pull the icon ");
                complete=NO;
            }
        }
        else
        {
            NSLog(@"%@",[error localizedDescription]);
            complete=NO;
        }
    }
    else
    {
        if(self.parseObject[P_ICON])
            self.icon=UIImagePNGRepresentation([UIImage imageNamed:self.parseObject[P_ICON]]);
        else
        {
            NSLog(@"Category icon is missing");
            complete=NO;
        }
    }
    
    return complete;
}


+(NSInteger)getRowCountForContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[BusinessCategory entityName]];
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



+(NSArray*) getCategoriesForContext:(NSManagedObjectContext*)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[BusinessCategory entityName]];
    NSError *error;
    NSArray *categories = [context executeFetchRequest:request error:&error];
    
    if(error)
    {
        NSLog(@"%@",[error localizedDescription]);
        return nil;
    }
    
    return categories;
}




+(Boolean)checkIfParseObjectRight:(PFObject*)object
{
    if(object[P_NAME] && (object[P_ICON] || object[P_IMAGE]))
        return YES;
    else
        return NO;
}



@end
