//
//  TheSignTests.m
//  TheSignTests
//
//  Created by Andrey Chudnovskiy on 2/20/2014.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "InsightEngine.h"
@interface TheSignTests : XCTestCase

@end

@implementation TheSignTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    NSDate *now=[NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *christmasComp = [[NSDateComponents alloc] init];
    [christmasComp setDay:06];
    [christmasComp setMonth:06];
    //[christmasComp setYear:2014];
    NSDate* christmas=[calendar dateFromComponents:christmasComp];

    NSDateComponents *nowComp = [calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit)  fromDate:now];
    

    
    now=[calendar dateFromComponents:nowComp];
    if([now isEqual:christmas])
    {
        NSLog(@"herro");
        return;
    }

    XCTFail(@"Din't Work");
}

@end
