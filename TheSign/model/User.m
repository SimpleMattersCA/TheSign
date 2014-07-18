//
//  User.m
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-06-20.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import "User.h"
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



#pragma mark - Sign Entity Protocol

@synthesize parseObject=_parseObject;

-(PFUser*)parseObject
{
    if(!_parseObject)
    {
        NSError *error;
        if(!error)
            _parseObject=[PFQuery getUserObjectWithId:self.pObjectID error:&error];
        else
            NSLog(@"%@",[error localizedDescription]);
    }
    return _parseObject;
}

+(NSString*) entityName {return @"User";}
+(NSString*) parseEntityName {return @"User";}

+(Boolean)checkIfParseObjectRight:(PFUser*)object
{
    if(object[P_NAME])
        return YES;
    else
        return NO;
}

+(User*) getByID:(NSString*)identifier Context:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:self.entityName];
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

+(void)createUserFromParse:(PFUser *)user
{
 //   NSError *error;
    User *newUser = [NSEntityDescription insertNewObjectForEntityForName:self.entityName
                                                  inManagedObjectContext:[Model sharedModel].managedObjectContext];
    newUser.pObjectID=user.objectId;
    newUser.isMainUser=@(YES);
    
    if(newUser.fbID==nil && [PFFacebookUtils isLinkedWithUser:user])
    {
        FBRequest *request = [FBRequest requestForMe];
        [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (!error)
            {
                User* currentUser=[self currentUser];
                
                // result is a dictionary with the user's Facebook data
                NSDictionary *userData = (NSDictionary *)result;
                
                currentUser.fbID = userData[@"id"];
                currentUser.name = userData[@"first_name"];
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"MM/dd/yyyy"];
                currentUser.birthdate = [formatter dateFromString: userData[@"birthday"]];
                
                currentUser.gender = userData[@"gender"];
                
                NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", currentUser.fbID]];
                NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:pictureURL
                                                                          cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                                      timeoutInterval:2.0f];
                
                NSURLResponse* response = nil;
                NSError* error;
                NSData *imageData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
                currentUser.pic=imageData;
                
                
                //[[Model sharedModel] saveContext];
             //   [currentUser findFriends];
            }
        }];
    }
    
  /*  if(newUser.twID==nil && [PFTwitterUtils isLinkedWithUser:user])
    {
#warning fill image, name and followers from twitter api
        //fields id, birthday, firs_name,gender,
    }*/
    
}

-(Boolean)refreshFromParse
{
    if(!self.parseObject)
    {
        NSLog(@"%@: Couldn't fetch the parse object with id: %@",[self.class entityName],self.pObjectID);
        return NO;
    }
    
    if([User checkIfParseObjectRight:self.parseObject]==NO)
    {
        NSLog(@"The object %@ is missing mandatory fields",self.parseObject.objectId);
        return NO;
    }
    
    Boolean complete=YES;

    self.name=self.parseObject[P_NAME];
    
    PFFile *pic=self.parseObject[P_PIC];
    NSError* error;
    NSData *pulledImage;
    pulledImage=[pic getData:&error];
    if(!error)
    {
        if(pulledImage!=nil)
            self.pic=pulledImage;
        else
        {
            NSLog(@"Business logo is missing");
            complete=NO;
        }
    }
    else
    {
        NSLog(@"%@",[error localizedDescription]);
        complete=NO;
    }
    
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




+(User*) currentUser
{

    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:self.entityName];
    request.predicate=[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@=%d", CD_MAIN, YES]];
    NSError *error;
    NSArray *result = [[Model sharedModel].managedObjectContext executeFetchRequest:request error:&error];
    
    if(error)
    {
        NSLog(@"%@",[error localizedDescription]);
        return nil;
    }
    
    if(result.count==1)
        return result.firstObject;
    else
    {
        NSLog(@"No current user or more than one current user specified");
        return nil;
    }
    
}

-(void)findFriends
{
    // Issue a Facebook Graph API request to get your user's friend list
    [FBRequestConnection startForMyFriendsWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // result will contain an array with your user's friends in the "data" key
            NSArray *friendObjects = [result objectForKey:@"data"];
            NSMutableArray *friendIds = [NSMutableArray arrayWithCapacity:friendObjects.count];
            // Create a list of friends' Facebook IDs
            for (NSDictionary *friendObject in friendObjects) {
                [friendIds addObject:[friendObject objectForKey:@"id"]];
            }
            
            // Construct a PFUser query that will find friends whose facebook ids
            // are contained in the current user's friend list.
            PFQuery *friendQuery = [PFUser query];
            [friendQuery whereKey:@"fbID" containedIn:friendIds];
            
            // findObjects will return a list of PFUsers that are friends
            // with the current user
            NSArray *friendUsers = [friendQuery findObjects];
            
            for(PFUser* friend in friendUsers)
                [User createUserFromParse:friend];
            
            //clean the friends list
            if(self.linkedFriends)
                [self removeLinkedFriends:self.linkedFriends];
                
            for(User* friend in [User getUsers])
                [self addLinkedFriendsObject:friend];
            
        }
    }];
}


/**
 Returns the list of users excluding the main one.
 */
+(NSArray*)getUsers
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:User.entityName];
    NSError *error;
    request.predicate=[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@=%d", CD_MAIN, NO]];    NSArray *users = [[Model sharedModel].managedObjectContext executeFetchRequest:request error:&error];
    
    if(error)
    {
        NSLog(@"%@",[error localizedDescription]);
        return nil;
    }
    
    return users;
}


@end
