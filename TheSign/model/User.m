//
//  User.m
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-06-20.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import "User.h"
#import "DiscoveredBusiness.h"
#import "Like.h"
#import "Statistics.h"
#import "User.h"
#import "Model.h"
#import "Parse/Parse.h"


#define CD_MAIN (@"isMainUser")
#define CD_PIC (@"pic")
#define CD_NAME (@"name")

#define P_NAME (@"name")
#define P_PIC (@"pic")
#define P_BIRTHDATE (@"birthdate")
#define P_GENDER (@"gender")
#define P_FBID (@"fbID")
#define P_TWID (@"twID")

@implementation User

@dynamic isMainUser;
@dynamic pic;
@dynamic pObjectID;
@dynamic name;
@dynamic linkedDiscoveries;
@dynamic linkedLikes;
@dynamic linkedStatistics;
@dynamic linkedFriends;
@dynamic linkedUser;
@dynamic linkedScores;
@dynamic fbID;
@dynamic twID;
@dynamic gender;
@dynamic birthdate;
@synthesize parseObject=_parseObject;

static User* _currentUser;

+(NSString*) entityName {return @"User";}
+(NSString*) parseEntityName {return @"User";}

+(Boolean)checkIfParseObjectRight:(PFUser*)object
{
    if(object[P_NAME])
        return YES;
    else
        return NO;
}

+(User*) currentUser
{
    if(!_currentUser)
    {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:self.entityName];
        request.predicate=[NSPredicate predicateWithFormat:@"%@==%d", CD_MAIN, YES];
        NSError *error;
        NSArray *result = [[Model sharedModel].managedObjectContext executeFetchRequest:request error:&error];
        
        if(error)
        {
            NSLog(@"%@",[error localizedDescription]);
            return nil;
        }
        else
            if(result.count!=1)
            {
                NSLog(@"No current user or more than one current user specified");
                return nil;
            }
            else
                _currentUser= (User*)result.firstObject;
            
    }
    return _currentUser;
}

+(User*) getByID:(NSString*)identifier
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:self.entityName];
    request.predicate=[NSPredicate predicateWithFormat:@"%@=='%@'", OBJECT_ID, identifier];
    NSError *error;
    NSArray *result = [[Model sharedModel].managedObjectContext executeFetchRequest:request error:&error];
    
    if(error)
    {
        NSLog(@"%@",[error localizedDescription]);
        return nil;
    }
    else
        return (User*)result.firstObject;
}

+(void)createFromParse:(PFUser *)user
{
 //   NSError *error;
    User *newUser = [NSEntityDescription insertNewObjectForEntityForName:self.entityName
                                                  inManagedObjectContext:[Model sharedModel].managedObjectContext];
    newUser.parseObject=user;
    newUser.pObjectID=user.objectId;
    
    
    if(newUser.fbID==nil && [PFFacebookUtils isLinkedWithUser:user])
    {
        FBRequest *request = [FBRequest requestForMe];
        [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (!error) {
                // result is a dictionary with the user's Facebook data
                NSDictionary *userData = (NSDictionary *)result;
                
                newUser.fbID = userData[@"id"];
                newUser.name = userData[@"first_name"];
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"MM/dd/yyyy"];
                newUser.birthdate = [formatter dateFromString: userData[@"birthday"]];
                
                newUser.gender = userData[@"gender"];
                
                NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", newUser.fbID]];
                NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:pictureURL
                                                                          cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                                      timeoutInterval:2.0f];
                
                NSURLResponse* response = nil;
                NSError* error;
                NSData *imageData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
                newUser.pic=imageData;
                [[Model sharedModel] saveContext];
            }
        }];
#warning find friends in USER table for this facebook account
    }
    
    if(newUser.twID==nil && [PFTwitterUtils isLinkedWithUser:user])
    {
#warning fill image, name and followers from twitter api
        //fields id, birthday, firs_name,gender,
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
    
    if([User checkIfParseObjectRight:self.parseObject]==NO)
    {
        NSLog(@"The object %@ is missing mandatory fields",self.parseObject.objectId);
        return;
    }
    
}


@end
