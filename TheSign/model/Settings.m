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
#define P_PARAM_DATE (@"paramDate")



@implementation Settings

@dynamic pObjectID;
@dynamic name;
@dynamic paramStr;
@dynamic paramInt;
@dynamic paramDate;


#pragma mark - Sign Entity Protocol

+(NSString*) entityName {return @"Settings";}
+(NSString*) parseEntityName {return @"Settings";}

@synthesize parseObject=_parseObject;

+(Boolean)checkIfParseObjectRight:(PFObject*)object
{
    if(object[P_NAME] && (object[P_PARAM_STR] || object[P_PARAM_INT] || object[P_PARAM_DATE]))
        return YES;
    else
        return NO;
}

+(Settings*) getByID:(NSString*)identifier
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:Settings.entityName];
    request.predicate=[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@='%@'", OBJECT_ID, identifier]];
    NSError *error;
    NSArray *result = [[Model sharedModel].managedObjectContext executeFetchRequest:request error:&error];
    
    if(error)
    {
        NSLog(@"%@",[error localizedDescription]);
        return nil;
    }
    else
        return (Settings*)result.firstObject;
}



+ (Boolean)createFromParse:(PFObject *)object
{
    if([Settings checkIfParseObjectRight:object]==NO)
    {
        NSLog(@"%@: The object %@ is missing mandatory fields",self.entityName,object.objectId);
        return NO;
    }
    Boolean complete=YES;

    Settings *settings = [NSEntityDescription insertNewObjectForEntityForName:[Settings entityName]
                                                       inManagedObjectContext:[Model sharedModel].managedObjectContext];
    settings.parseObject=object;
    settings.pObjectID=object.objectId;
    settings.name=object[P_NAME];
    settings.paramStr=object[P_PARAM_STR];
    settings.paramInt=object[P_PARAM_INT];
    settings.paramDate=object[P_PARAM_DATE];
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
    Boolean complete=YES;
    
    self.name=self.parseObject[P_NAME];
    self.paramStr=self.parseObject[P_PARAM_STR];
    self.paramInt=self.parseObject[P_PARAM_INT];
    self.paramDate=self.parseObject[P_PARAM_DATE];
    
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


+(Settings*)getValueForParamName:(NSString*)paramName
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:Settings.entityName];
    request.predicate=[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@='%@'", OBJECT_ID, paramName]];
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

@end
