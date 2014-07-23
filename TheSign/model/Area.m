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

-(PFObject*)parseObject
{
    if(!_parseObject)
    {
        NSError *error;
        if(!error)
            _parseObject=[PFQuery getObjectOfClass:[Area parseEntityName] objectId:self.pObjectID error:&error];
        else
            NSLog(@"%@",[error localizedDescription]);
    }
    return _parseObject;
}

+(NSString*) entityName {return @"Area";}
+(NSString*) parseEntityName {return @"Area";}

+(Boolean)checkIfParseObjectRight:(PFObject*)object
{
    return YES;

}


+(Area*) getByID:(NSString*)identifier Context:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[Area entityName]];
    request.predicate=[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@='%@'", OBJECT_ID, identifier]];
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
    if([Area checkIfParseObjectRight:object]==NO)
    {
        NSLog(@"%@: The object %@ is missing mandatory fields",[Area entityName],object.objectId);
        return NO;
    }
    Boolean complete=YES;

    Area *area = [NSEntityDescription insertNewObjectForEntityForName:[Area entityName]
                                                       inManagedObjectContext:context];
    area.pObjectID=object.objectId;
    area.currentTemperature=object[P_TEMPERATURE];
    area.currentWeather=object[P_WEATHER];
    area.weatherTimestamp=object.updatedAt;
    
    return complete;
}

-(Boolean)refreshFromParseForContext:(NSManagedObjectContext*)context
{
    if(!self.parseObject)
    {
        NSLog(@"%@: Couldn't fetch the parse object with id: %@",[Area entityName],self.pObjectID);
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

+(NSInteger)getRowCountForContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[Area entityName]];
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



@end
