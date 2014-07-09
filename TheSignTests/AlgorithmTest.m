//
//  AlgorithmTest.m
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-07-09.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "Model.h"
#import "Featured.h"
#import "Business.h"
#import "Link.h"
#import "Statistics.h"
#import "Location.h"
#import "Relevancy.h"

#import "InsightEngine.h"

@interface AlgorithmTest : XCTestCase

@end

@implementation AlgorithmTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testLikeProcessing {
    double newLike=[[Model sharedModel] getLikeValueForAction:LK_Like];
    double newDisLike=[[Model sharedModel] getLikeValueForAction:LK_Dislike];
    double newNonLike=[[Model sharedModel] getLikeValueForAction:LK_None];
    
    Featured* whiteChocolateMocha=[Featured getByID:@"Jasy3NnWGj"];
    [whiteChocolateMocha processLike:newLike];
    XCTAssertNotEqual(whiteChocolateMocha.linkedScore.score.doubleValue, 0);

    Featured* bananaCrepe=[Featured getByID:@"yACWNUI39G"];
    [bananaCrepe processLike:newDisLike];
    XCTAssertNotEqual(bananaCrepe.linkedScore.score.doubleValue, 0);
    
    Featured* dressShirt=[Featured getByID:@"sG8HkUF5S6"];
    [dressShirt processLike:newNonLike];
    XCTAssertNotEqual(dressShirt.linkedScore.score.doubleValue, 0);
}


- (void)testWelcomeTextGeneration {
    
    NSString * starbucksBurnaby=[[InsightEngine sharedInsight] generateWelcomeTextForGPSdetectedMajor:@(4)];
    NSLog(@"Starbucks Burnaby: %@ ",starbucksBurnaby);
    XCTAssertNotNil(starbucksBurnaby);
    
    NSString * starbucksYaletown=[[InsightEngine sharedInsight] generateWelcomeTextForGPSdetectedMajor:@(3)];
    NSLog(@"Starbucks Yaletown: %@ ",starbucksYaletown);
    XCTAssertNotNil(starbucksYaletown);
    
    NSString * bananaBurnaby=[[InsightEngine sharedInsight] generateWelcomeTextForGPSdetectedMajor:@(2)];
    NSLog(@"Banana Republic: %@ ",bananaBurnaby);
    XCTAssertNotNil(bananaBurnaby);
    
    NSString * crepeYaletown=[[InsightEngine sharedInsight] generateWelcomeTextForGPSdetectedMajor:@(1)];
    NSLog(@"Crepes: %@ ",crepeYaletown);
    XCTAssertNotNil(crepeYaletown);

}


- (void)testPerformanceWelcomeTextGeneration {
    // This is an example of a performance test case.
    [self measureBlock:^{
        [[InsightEngine sharedInsight] generateWelcomeTextForGPSdetectedMajor:@(3)];
        // Put the code you want to measure the time of here.
    }];
}

@end
