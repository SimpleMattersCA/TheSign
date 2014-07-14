//
//  Area.m
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-07-04.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import "Area.h"
#import "Location.h"
#import "Model.h"

#define CD_WEATHER (@"currentWeather")
#define CD_TEMPERATURE (@"currentTemperature")
#define CD_TIMESTAMP (@"weatherTimestamp")

#define P_WEATHER (@"currentWeather")
#define P_TEMPERATURE (@"currentTemperature")

@implementation Area

@dynamic pObjectID;
@dynamic currentTemperature;
@dynamic currentWeather;
@dynamic weatherTimestamp;
@dynamic linkedLocations;




#pragma mark - Sign Entity Protocol

@synthesize parseObject=_parseObject;

+(NSString*) entityName {return @"Area";}
+(NSString*) parseEntityName {return @"Area";}

+(Boolean)checkIfParseObjectRight:(PFObject*)object
{
    return YES;

}


+(Area*) getByID:(NSString*)identifier
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:self.entityName];
    request.predicate=[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@='%@'", OBJECT_ID, identifier]];
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
    if([Area checkIfParseObjectRight:object]==NO)
    {
        NSLog(@"%@: The object %@ is missing mandatory fields",self.entityName,object.objectId);
        return NO;
    }
    Boolean complete=YES;

    Area *area = [NSEntityDescription insertNewObjectForEntityForName:[Area entityName]
                                                       inManagedObjectContext:[Model sharedModel].managedObjectContext];
    area.parseObject=object;
    area.pObjectID=object.objectId;
    area.currentTemperature=object[P_TEMPERATURE];
    area.currentWeather=object[P_WEATHER];
    area.weatherTimestamp=object.updatedAt;
    
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
    
    if([Area checkIfParseObjectRight:self.parseObject]==NO)
    {
        NSLog(@"The object %@ is missing mandatory fields",self.parseObject.objectId);
        return NO;
    }
    Boolean complete=YES;

    self.currentTemperature=self.parseObject[P_TEMPERATURE];
    self.currentWeather=self.parseObject[P_WEATHER];
    self.weatherTimestamp=self.parseObject.updatedAt;
    
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



@end
