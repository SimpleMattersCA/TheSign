//
//  Item.m
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-03-01.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import "Item.h"

@implementation Item

-(NSString*) title
{
    if([_title length]==0)
    {
        NSLog(@"Title is not found");
        _title=@"Default Item";
    }
    return _title;
}

-(NSString*) description
{
    if([_description length]==0)
    {
        NSLog(@"Description is not found");
        _description=@"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";
    }
    return _description;
}

@end
