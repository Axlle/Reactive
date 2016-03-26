//
//  AXSignalDidChangeEventTests.m
//  Reactive
//
//  Created by William Green on 2016-01-17.
//  Copyright © 2016 William Green. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Reactive/Reactive.h>

@interface AXSignalDidChangeEventTests : XCTestCase

@end

@implementation AXSignalDidChangeEventTests

- (void)testHashAndEquals {
    AXSignalDidChangeEvent *event1 = [[AXSignalDidChangeEvent alloc] initWithValue:@5 oldValue:@6];
    AXSignalDidChangeEvent *event2 = [[AXSignalDidChangeEvent alloc] initWithValue:@5 oldValue:@6];
    XCTAssertEqual([event1 hash], [event2 hash]);
    XCTAssertEqualObjects(event1, event2);

    AXSignalDidChangeEvent *event3 = [[AXSignalDidChangeEvent alloc] initWithValue:@6 oldValue:@7];
    XCTAssertNotEqual([event1 hash], [event3 hash]);
    XCTAssertNotEqualObjects(event1, event3);

    AXSignalDidChangeEvent *event4 = [[AXSignalDidChangeEvent alloc] initWithValue:@5 oldValue:nil];
    XCTAssertNotEqual([event1 hash], [event4 hash]);
    XCTAssertNotEqualObjects(event1, event4);

    AXSignalDidChangeEvent *event5 = [[AXSignalDidChangeEvent alloc] initWithValue:nil oldValue:@6];
    XCTAssertNotEqual([event1 hash], [event5 hash]);
    XCTAssertNotEqualObjects(event1, event5);

    AXSignalDidChangeEvent *event6 = [[AXSignalDidChangeEvent alloc] initWithValue:nil oldValue:nil];
    AXSignalDidChangeEvent *event7 = [[AXSignalDidChangeEvent alloc] initWithValue:nil oldValue:nil];
    XCTAssertEqual([event6 hash], [event7 hash]);
    XCTAssertEqualObjects(event6, event7);

    // Compare with other objects
    XCTAssertNotEqualObjects(event1, nil);
    XCTAssertNotEqualObjects(event1, [[NSObject alloc] init]);
}

- (void)testCopy {
    AXSignalDidChangeEvent *event1 = [[AXSignalDidChangeEvent alloc] initWithValue:@5 oldValue:@6];
    AXSignalDidChangeEvent *event2 = [event1 copy];
    XCTAssert(event1 != event2);
    XCTAssertEqualObjects(event1, event2);
}

@end
