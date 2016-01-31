//
//  StreamTests.m
//  Reactive
//
//  Created by William Green on 2016-01-24.
//  Copyright © 2016 William Green. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Reactive/Reactive.h>

@interface StreamTests : XCTestCase

@end

@implementation StreamTests

- (void)testSimple {
    __block id actualEvent;

    EventStream *stream = [[EventStream alloc] init];
    [stream observeWithBlock:^(id event) {
        actualEvent = event;
    }];

    id expectedEvent = @5;
    [stream sendEvent:expectedEvent];
    XCTAssertEqualObjects(actualEvent, expectedEvent);
}

- (void)testExplicitObservationCancellation {
    __block id actualEvent;

    EventStream *stream = [[EventStream alloc] init];
    EventStreamObservation *observation = [stream observationWithBlock:^(id event) {
        actualEvent = event;
    }];

    id expectedEvent = @5;
    [stream sendEvent:expectedEvent];
    XCTAssertEqualObjects(actualEvent, expectedEvent);

    // Repeat after cancelling the observation
    actualEvent = nil;
    [stream cancelObservation:observation];
    [stream sendEvent:expectedEvent];
    XCTAssertNil(actualEvent);
}

- (void)testImplicitObservationCancellation {
    __block id actualEvent;

    EventStream *stream;
    EventStreamObservation *observation;

    // Create a scope so the observation gets deallocated
    @autoreleasepool {
        stream = [[EventStream alloc] init];
        observation = [stream observationWithBlock:^(id event) {
            actualEvent = event;
        }];

        id expectedEvent = @5;
        [stream sendEvent:expectedEvent];
        XCTAssertEqualObjects(actualEvent, expectedEvent);

        // Repeat after cancelling the observation
        actualEvent = nil;
        observation = nil;
    }
    [stream sendEvent:@5];
    XCTAssertNil(actualEvent);
}



@end
