//
//  DataConsistency.m
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-07-08.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "Model.h"
#import "Featured.h"
#import "Business.h"
#import "Tag.h"
#import "TagSet.h"
#import "TagConnection.h"
#import "Link.h"
#import "Statistics.h"
#import "TableTimestamp.h"
#import "Settings.h"
#import "Location.h"
#import "Area.h"
#import "Context.h"
#import "Template.h"
@interface DataConsistency : XCTestCase

@end

@implementation DataConsistency

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSettings {
    NSLog(@"Min prob: %@",[Model sharedModel].prob_no_relev.stringValue);
    NSLog(@"Beacon UUID: %@",[Model sharedModel].beaconUUID);
    NSLog(@"Prob pref: %@",[Model sharedModel].prob_pref.stringValue);
    NSLog(@"Relevancy depth: %@",[Model sharedModel].relevancyDepth.stringValue);
    NSLog(@"Lk none: %@",[Model sharedModel].lk_none.stringValue);
    NSLog(@"Lk like: %@",[Model sharedModel].lk_like.stringValue);
    NSLog(@"Lk dislike: %@",[Model sharedModel].lk_dislike.stringValue);
    NSLog(@"Min neg score: %@",[Model sharedModel].min_negativeScore.stringValue);

}

- (void)testDatabaseRefresh {
    [[Model sharedModel] deleteModel];
    XCTAssertTrue([[Model sharedModel] checkModel]);
}

-(void)testCoreDataRowCounts{
    [[Model sharedModel] deleteModel];
    [[Model sharedModel] checkModel];

    XCTAssertNotEqual([Business getRowCount], 0);
    XCTAssertNotEqual([Featured getRowCount], 0);
    XCTAssertNotEqual([Tag getRowCount], 0);
    XCTAssertNotEqual([TagSet getRowCount], 0);
    XCTAssertNotEqual([TagConnection getRowCount], 0);
    XCTAssertNotEqual([Settings getRowCount], 0);
    XCTAssertNotEqual([Location getRowCount], 0);
    XCTAssertNotEqual([Area getRowCount], 0);
    XCTAssertNotEqual([Context getRowCount], 0);
    XCTAssertNotEqual([Template getRowCount], 0);
    XCTAssertNotEqual([Link getRowCount], 0);
    
}

@end
