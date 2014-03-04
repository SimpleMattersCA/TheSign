//
//  Business.m
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-03-01.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import "Business.h"

@implementation Business

-(NSString*) name
{
    if([_name length]==0)
    {
        NSLog(@"Name is not found");
        _name=@"Default Business";
    }
    return _name;
}

-(NSString*) welcomeText
{
    if([_welcomeText length]==0)
    {
        NSLog(@"Welcome text is not found");
        _welcomeText=@"Default Welcome";
    }
    return _welcomeText;
}

-(NSArray*) beacons
{
    if(!_beacons)
    {
        NSLog(@"No beacons are assigned to the business");
        _beacons=[[NSArray alloc] init];
    }
    return _beacons;
}

-(NSArray*) items
{
    if(!_items)
    {
        NSLog(@"No featured items are found for the business");
        _items=[[NSArray alloc] init];
    }
    return _items;
}




@end
