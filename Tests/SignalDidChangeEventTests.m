//
//  SignalDidChangeEventTests.m
//  Reactive
//
//  Created by William Green on 2016-01-17.
//  Copyright © 2016 William Green. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Reactive/Reactive.h>

@interface SignalDidChangeEventTests : XCTestCase

@end

@implementation SignalDidChangeEventTests

- (void)testHashAndEquals {
    SignalDidChangeEvent *event1 = [[SignalDidChangeEvent alloc] initWithValue:@5 oldValue:@6];
    SignalDidChangeEvent *event2 = [[SignalDidChangeEvent alloc] initWithValue:@5 oldValue:@6];
    XCTAssertEqual([event1 hash], [event2 hash]);
    XCTAssertEqualObjects(event1, event2);

    SignalDidChangeEvent *event3 = [[SignalDidChangeEvent alloc] initWithValue:@6 oldValue:@7];
    XCTAssertNotEqual([event1 hash], [event3 hash]);
    XCTAssertNotEqualObjects(event1, event3);

    SignalDidChangeEvent *event4 = [[SignalDidChangeEvent alloc] initWithValue:@5 oldValue:nil];
    XCTAssertNotEqual([event1 hash], [event4 hash]);
    XCTAssertNotEqualObjects(event1, event4);

    SignalDidChangeEvent *event5 = [[SignalDidChangeEvent alloc] initWithValue:nil oldValue:@6];
    XCTAssertNotEqual([event1 hash], [event5 hash]);
    XCTAssertNotEqualObjects(event1, event5);

    SignalDidChangeEvent *event6 = [[SignalDidChangeEvent alloc] initWithValue:nil oldValue:nil];
    SignalDidChangeEvent *event7 = [[SignalDidChangeEvent alloc] initWithValue:nil oldValue:nil];
    XCTAssertEqual([event6 hash], [event7 hash]);
    XCTAssertEqualObjects(event6, event7);

    // Compare with other objects
    XCTAssertNotEqualObjects(event1, nil);
    XCTAssertNotEqualObjects(event1, [[NSObject alloc] init]);
}

- (void)testCopy {
    SignalDidChangeEvent *event1 = [[SignalDidChangeEvent alloc] initWithValue:@5 oldValue:@6];
    SignalDidChangeEvent *event2 = [event1 copy];
    XCTAssert(event1 != event2);
    XCTAssertEqualObjects(event1, event2);
}

@end
