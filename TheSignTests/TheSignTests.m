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
    [[Model sharedModel] checkModel];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    
    XCTFail(@"Din't Work");
}

@end
