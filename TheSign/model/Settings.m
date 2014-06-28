//
//  Settings.m
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-06-25.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import "Settings.h"
#import "Model.h"

@implementation Settings

@dynamic beaconUUID;
@dynamic prob_weather;
@dynamic prob_pref;
@dynamic prob_day;
@dynamic prob_date;
@dynamic relevancyDepth;
@dynamic minLike;
@dynamic lk_none;
@dynamic lk_like;
@dynamic lk_dislike;

+(NSString*) entityName {return @"Settings";}
+(NSString*) parseEntityName {return @"Settings";}


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
    settings.beaconUUID=@"B9407F30-F5F8-466E-AFF9-25556B57FE6D";
    settings.prob_date=@(0.2);
    settings.prob_day=@(0.1);
    settings.prob_pref=@(0.4);
    settings.prob_weather=@(0.3);
    settings.relevancyDepth=@(2);
    settings.minLike=@(0.1);
    settings.lk_none=@(0.1);
    settings.lk_dislike=@(-1);
    settings.lk_like=@(1);
    [[Model sharedModel] saveContext];
    return settings;
}

@end
