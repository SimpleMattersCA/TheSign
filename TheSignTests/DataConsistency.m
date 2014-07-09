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

/*- (void)testBusinessLink {
    [[Model sharedModel] checkModel];

    NSArray* businesses=[Business getBusinesses];
     for(Business* bus in businesses)
     {
     NSLog(@"%@",bus.pObjectID);
     }
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:Business.entityName];
    
    request.predicate=[NSPredicate predicateWithFormat: @"%K='%@'", @"pObjectID", @"2dIgwcHC3J"];
    //request.predicate=[NSPredicate predicateWithFormat: @"pObjectID='2dIgwcHC3J'"];
    NSError *error;
    NSArray *result = [[Model sharedModel].managedObjectContext executeFetchRequest:request error:&error];
    XCTAssertNotEqual(result.count, 0);
}*/

- (void)testDatabaseRefresh {
    [[Model sharedModel] deleteModel];
    XCTAssertTrue([[Model sharedModel] checkModel]);
}

-(void)testCoreDataRowCounts{
    [[Model sharedModel] deleteModel];
    [[Model sharedModel] checkModel];
 //   NSInteger count=[Business getRowCount];
   // NSLog(@"Count: %d",count);
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
    

    /*NSArray* businesses=[Business getBusinesses];
    for(Business* bus in businesses)
    {
        NSLog(@"%@",bus.pObjectID);
    }*/
    
}
/*- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}*/

@end
