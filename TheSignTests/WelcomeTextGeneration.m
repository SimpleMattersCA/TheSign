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
   // [[Model sharedModel] checkModel];

    // Put setup cod=e here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testLikeProcessing {
    Model* model=[Model sharedModel];
    
    double newLike=[model getLikeValueForAction:LK_Like];
    double newDisLike=[model getLikeValueForAction:LK_Dislike];
    double newNonLike=[model getLikeValueForAction:LK_None];
    
    double currentVal;
    
    Featured* whiteChocolateMocha=[Featured getByID:@"Jasy3NnWGj" Context:model.managedObjectContext];
    currentVal=whiteChocolateMocha.score.doubleValue;
    NSLog(@"Mocha: old value:%f",currentVal);
    [whiteChocolateMocha processLike:newLike];
    NSLog(@"Mocha: new value:%f",whiteChocolateMocha.score.doubleValue);
    XCTAssertNotEqual(whiteChocolateMocha.score.doubleValue, currentVal);
/*
    Featured* bananaCrepe=[Featured getByID:@"yACWNUI39G"];
    currentVal=bananaCrepe.score.doubleValue;
    NSLog(@"Crepe: old value:%f",currentVal);
    [bananaCrepe processLike:newDisLike];
    NSLog(@"Crepe: new value:%f",bananaCrepe.score.doubleValue);
    XCTAssertNotEqual(bananaCrepe.score.doubleValue, currentVal);
    
    Featured* dressShirt=[Featured getByID:@"sG8HkUF5S6"];
    currentVal=dressShirt.score.doubleValue;
    NSLog(@"Shirt: old value:%f",currentVal);
    [dressShirt processLike:newNonLike];
    NSLog(@"Shirt: new value:%f",dressShirt.score.doubleValue);
    XCTAssertNotEqual(dressShirt.score.doubleValue, currentVal);*/
}


- (void)testWelcomeTextGeneration {

    NSString * starbucksBurnaby=[[InsightEngine sharedInsight] generateWelcomeTextForGPSdetectedMajor:@(4)];
    NSLog(@"%@",starbucksBurnaby);
    XCTAssertNotNil(starbucksBurnaby);
    
    NSString * starbucksYaletown=[[InsightEngine sharedInsight] generateWelcomeTextForGPSdetectedMajor:@(3)];
    NSLog(@"%@",starbucksYaletown);
    XCTAssertNotNil(starbucksYaletown);
    
    NSString * bananaBurnaby=[[InsightEngine sharedInsight] generateWelcomeTextForGPSdetectedMajor:@(2)];
    NSLog(@"%@",bananaBurnaby);
    XCTAssertNotNil(bananaBurnaby);
    
    NSString * crepeYaletown=[[InsightEngine sharedInsight] generateWelcomeTextForGPSdetectedMajor:@(1)];
    NSLog(@"%@",crepeYaletown);
    XCTAssertNotNil(crepeYaletown);

}

-(void)testOffersFeed{
    Model* model=[Model sharedModel];

    NSArray* discoveredBusinesses=[Business getDiscoveredBusinessesForContext:model.managedObjectContext];

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
    
    NSLog(@"Deals in the feed:");
    for(Featured* deal in result)
        NSLog(@"%@",deal.fullName);
    
    XCTAssertEqual(offers.count, result.count);


}

- (void)testPerformanceWelcomeTextGeneration {
    // This is an example of a performance test case.
    [self measureBlock:^{
        NSString* result=[[InsightEngine sharedInsight] generateWelcomeTextForGPSdetectedMajor:@(4)];
        NSLog(@"%@",result);

        // Put the code you want to measure the time of here.
    }];
}

@end
