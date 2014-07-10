//
//  Settings.m
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-06-25.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import "Settings.h"
#import "Model.h"

#define CD_UUID (@"beaconUUID")
#define CD_PROB_PREF (@"prob_pref")
#define CD_REL_DEPTH (@"relevancyDepth")
#define CD_MINLIKE (@"minLike")
#define CD_LK_NONE (@"lk_none")
#define CD_LK_LIKE (@"lk_like")
#define CD_LK_DISLIKE (@"lk_dislike")
#define CD_MINPROB (@"minProb")

#define P_UUID (@"beaconUUID")
#define P_PROB_PREF (@"prob_pref")
#define P_REL_DEPTH (@"relevancyDepth")
#define P_MINLIKE (@"minLike")
#define P_LK_NONE (@"lk_none")
#define P_LK_LIKE (@"lk_like")
#define P_LK_DISLIKE (@"lk_dislike")
#define P_MINPROB (@"minProb")


@implementation Settings



@dynamic beaconUUID;
@dynamic prob_pref;
@dynamic relevancyDepth;
@dynamic minLike;
@dynamic lk_none;
@dynamic lk_like;
@dynamic lk_dislike;
@dynamic pObjectID;
@dynamic minProb;



#pragma mark - Sign Entity Protocol

+(NSString*) entityName {return @"Settings";}
+(NSString*) parseEntityName {return @"Settings";}

@synthesize parseObject=_parseObject;

+(Boolean)checkIfParseObjectRight:(PFObject*)object
{
    if(object[P_UUID] && object[P_PROB_PREF] && object[P_REL_DEPTH] && object[P_MINLIKE] && object[P_LK_NONE] && object[P_LK_LIKE] && object[P_LK_DISLIKE])
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
    settings.beaconUUID=object[P_UUID];
    settings.prob_pref=object[P_PROB_PREF];
    settings.relevancyDepth=object[P_REL_DEPTH];
    settings.minLike=object[P_MINLIKE];
    settings.lk_none=object[P_LK_NONE];
    settings.lk_dislike=object[P_LK_DISLIKE];
    settings.lk_like=object[P_LK_LIKE];
    settings.minProb=object[P_MINPROB];
    
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

    self.beaconUUID=self.parseObject[P_UUID];
    self.prob_pref=self.parseObject[P_PROB_PREF];
    self.relevancyDepth=self.parseObject[P_REL_DEPTH];
    self.minLike=self.parseObject[P_MINLIKE];
    self.lk_none=self.parseObject[P_LK_NONE];
    self.lk_dislike=self.parseObject[P_LK_DISLIKE];
    self.lk_like=self.parseObject[P_LK_LIKE];
    self.minProb=self.parseObject[P_MINPROB];
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




+(Settings*)getSettingsSet
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:self.entityName];
    NSError *error;
    NSArray *result = [[Model sharedModel].managedObjectContext executeFetchRequest:request error:&error];
    if(error)   
        return [self getDefaultSettingsSet];
    
    else
        return (Settings*)result.firstObject;

}
        
+(Settings*)getDefaultSettingsSet
{
    Settings *settings = [NSEntityDescription insertNewObjectForEntityForName:[self entityName]
                                                       inManagedObjectContext:[Model sharedModel].managedObjectContext];
    //App settings as of launch
    settings.pObjectID=@"SFcitChQaf";
    settings.beaconUUID=@"B9407F30-F5F8-466E-AFF9-25556B57FE6D";
    settings.prob_pref=@(0.5);
    
    settings.relevancyDepth=@(2);
    settings.minLike=@(0.1);
    settings.lk_none=@(0.1);
    settings.lk_dislike=@(-1);
    settings.lk_like=@(1);
    settings.minProb=@(0.1);
    [[Model sharedModel] saveContext];
    return settings;
}



@end
