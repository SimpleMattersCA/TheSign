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

#import "InsightEngine.h"

@interface AlgorithmTest : XCTestCase

@end

@implementation AlgorithmTest

- (void)setUp {
    [super setUp];
    [[Model sharedModel] checkModel];

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
    
    double currentVal;
    
    Featured* whiteChocolateMocha=[Featured getByID:@"Jasy3NnWGj"];
    currentVal=whiteChocolateMocha.score.doubleValue;
    [whiteChocolateMocha processLike:newLike];
    XCTAssertNotEqual(whiteChocolateMocha.score.doubleValue, currentVal);

    Featured* bananaCrepe=[Featured getByID:@"yACWNUI39G"];
    currentVal=whiteChocolateMocha.score.doubleValue;
    [bananaCrepe processLike:newDisLike];
    XCTAssertNotEqual(bananaCrepe.score.doubleValue, currentVal);
    
    Featured* dressShirt=[Featured getByID:@"sG8HkUF5S6"];
    currentVal=whiteChocolateMocha.score.doubleValue;
    [dressShirt processLike:newNonLike];
    XCTAssertNotEqual(dressShirt.score.doubleValue, currentVal);
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

-(void)testOffersFeed{

    NSArray* discoveredBusinesses=[Business getDiscoveredBusinesses];

    NSMutableArray* offers=[NSMutableArray array];
    
    double minNegScore=[Model sharedModel].min_negativeScore.doubleValue;
    
    for(Business *business in discoveredBusinesses)
    {
        if(business.linkedOffers)
        {
            for(Featured* offer in business.linkedOffers)
            {
                if(offer.active.boolValue)
                {
                    if(offer.score.doubleValue>minNegScore)
                        [offers addObject:offer];
                }
            }
            
        }
    }
    
    NSArray* result=[[Model sharedModel] getDealsForFeed];
    
    XCTAssertEqual(offers.count, result.count);


}

- (void)testPerformanceWelcomeTextGeneration {
    // This is an example of a performance test case.
    [self measureBlock:^{
        NSString* result=[[InsightEngine sharedInsight] generateWelcomeTextForGPSdetectedMajor:@(3)];
        NSLog(@"%@",result);

        // Put the code you want to measure the time of here.
    }];
}

@end
