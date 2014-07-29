//
//  Settings.m
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-06-25.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import "Settings.h"
#import "Model.h"



#define P_NAME (@"name")
#define P_PARAM_STR (@"paramStr")
#define P_PARAM_INT (@"paramInt")
#define P_PARAM_FLOAT (@"paramFloat")
#define P_PARAM_BOOL (@"paramBool")

#define P_PARAM_DATE (@"paramDate")



@implementation Settings

@dynamic pObjectID;
@dynamic name;
@dynamic paramStr;
@dynamic paramInt;
@dynamic paramFloat;
@dynamic paramBool;
@dynamic paramDate;


#pragma mark - Sign Entity Protocol

+(NSString*) entityName {return @"Settings";}
+(NSString*) parseEntityName {return @"Settings";}

@synthesize parseObject=_parseObject;

-(PFObject*)parseObject
{
    if(!_parseObject)
    {
        NSError *error;
        if(!error)
            _parseObject=[PFQuery getObjectOfClass:[Settings parseEntityName] objectId:self.pObjectID error:&error];
       // else
        //    NSLog(@"%@",[error localizedDescription]);
    }
    return _parseObject;
}

+(Boolean)checkIfParseObjectRight:(PFObject*)object
{
    if(object[P_NAME] && (object[P_PARAM_STR] || object[P_PARAM_INT] || object[P_PARAM_DATE] || object[P_PARAM_FLOAT] || object[P_PARAM_BOOL]))
        return YES;
    else
        return NO;
}

+(Settings*) getByID:(NSString*)identifier Context:(NSManagedObjectContext*)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[Settings entityName]];
    request.predicate=[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@='%@'", OBJECT_ID, identifier]];
    NSError *error;
    NSArray *result = [context executeFetchRequest:request error:&error];
    
    if(error)
    {
      //  NSLog(@"%@",[error localizedDescription]);
        return nil;
    }
    else
        return result.firstObject;
}



+ (Boolean)createFromParse:(PFObject *)object Context:(NSManagedObjectContext*)context
{
    if([Settings checkIfParseObjectRight:object]==NO)
    {
     //   NSLog(@"%@: The object %@ is missing mandatory fields",[Settings entityName],object.objectId);
        return NO;
    }
    Boolean complete=YES;

    Settings *settings = [NSEntityDescription insertNewObjectForEntityForName:[Settings entityName]
                                                       inManagedObjectContext:context];
    settings.pObjectID=object.objectId;
    settings.name=object[P_NAME];
    settings.paramStr=object[P_PARAM_STR];
    settings.paramInt=object[P_PARAM_INT];
    settings.paramFloat=object[P_PARAM_FLOAT];
    settings.paramBool=object[P_PARAM_BOOL];
    settings.paramDate=object[P_PARAM_DATE];
    
    return complete;
}

-(Boolean)refreshFromParseForContext:(NSManagedObjectContext*)context
{
    if(!self.parseObject)
    {
      //  NSLog(@"%@: Couldn't fetch the parse object with id: %@",[Settings entityName],self.pObjectID);
        return NO;
    }
    Boolean complete=YES;
    
    self.name=self.parseObject[P_NAME];
    self.paramStr=self.parseObject[P_PARAM_STR];
    self.paramInt=self.parseObject[P_PARAM_INT];
    self.paramFloat=self.parseObject[P_PARAM_FLOAT];
    self.paramBool=self.parseObject[P_PARAM_BOOL];
    self.paramDate=self.parseObject[P_PARAM_DATE];
    
    return complete;
}

+(NSInteger)getRowCountForContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[Settings entityName]];
    NSError *error;
    NSInteger result = [context countForFetchRequest:request error:&error];
    
    if(error)
    {
     //   NSLog(@"%@",[error localizedDescription]);
        return 0;
    }
    else
        return result;
}


+(Settings*)getValueForParamName:(NSString*)paramName Context:(NSManagedObjectContext*)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[Settings entityName]];
    request.predicate=[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@='%@'", P_NAME, paramName]];
    NSError *error;
    NSArray *result = [context executeFetchRequest:request error:&error];
    
    if(error)
    {
    //    NSLog(@"%@",[error localizedDescription]);
        return nil;
    }
    else
        return result.firstObject;

}

@end
