//
//  Like.m
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-06-19.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import "Like.h"
#import "Tag.h"
#import "Model.h"
#import "User.h"
@implementation Like

@dynamic likeness;
@dynamic linkedTag;
@dynamic linkedUser;

+(NSString*) entityName {return @"Like";}


+(void)changeLikenessForTag:(Tag*)tag ByValue:(NSNumber*)value
{
    if(tag.linkedLike!=nil)
        tag.linkedLike.likeness=@(tag.linkedLike.likeness.doubleValue+value.doubleValue);
    else
    {
        Like *newLike = [NSEntityDescription insertNewObjectForEntityForName:self.entityName
                                                                         inManagedObjectContext:[Model sharedModel].managedObjectContext];
        newLike.likeness=value;
        newLike.linkedTag=tag;
        newLike.linkedUser=[User currentUser];
        tag.linkedLike=newLike;
    }
}


@end
