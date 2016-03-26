//
//  AXStreamTests.m
//  Reactive
//
//  Created by William Green on 2016-01-24.
//  Copyright © 2016 William Green. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Reactive/Reactive.h>

@interface AXStreamTests : XCTestCase

@end

@implementation AXStreamTests

- (void)testSimple {
    AXStream *stream = [[AXStream alloc] init];

    __block id observedEvent;
    [stream observeWithBlock:^(id event) {
        XCTAssertNil(observedEvent, @"Observer block should be called once");
        observedEvent = event;
    }];
    XCTAssertNil(observedEvent, @"Observer should not be called during registration");

    id expectedEvent = @5;
    [stream sendEvent:expectedEvent];
    XCTAssertEqualObjects(expectedEvent, observedEvent);
}

- (void)testExplicitObservationCancellation {
    AXStream *stream = [[AXStream alloc] init];

    __block id observedEvent;
    AXStreamObservation *observation = [stream tokenObservationWithBlock:^(id event) {
        XCTAssertNil(observedEvent, @"Observer block should be called once");
        observedEvent = event;
    }];
    XCTAssertNil(observedEvent, @"Observer should not be called during registration");

    id expectedEvent = @5;
    [stream sendEvent:expectedEvent];
    XCTAssertEqualObjects(expectedEvent, observedEvent);

    // Repeat after cancelling the observation
    observedEvent = nil;
    [stream cancelTokenObservation:observation];
    [stream sendEvent:expectedEvent];
    XCTAssertNil(observedEvent);
}

- (void)testImplicitObservationCancellation {
    __block id observedEvent;

    AXStream *stream = [[AXStream alloc] init];
    AXStreamObservation *observation;

    // Create a scope so the observation gets deallocated
    @autoreleasepool {
        observation = [stream tokenObservationWithBlock:^(id event) {
            XCTAssertNil(observedEvent, @"Observer block should be called once");
            observedEvent = event;
        }];
        XCTAssertNil(observedEvent, @"Observer should not be called during registration");

        id expectedEvent = @5;
        [stream sendEvent:expectedEvent];
        XCTAssertEqualObjects(expectedEvent, observedEvent);

        // Repeat after cancelling the observation
        observedEvent = nil;
        observation = nil;
    }
    [stream sendEvent:@5];
    XCTAssertNil(observedEvent);
}

- (void)testUnheldObservation {
    AXStream *stream = [[AXStream alloc] init];
    @autoreleasepool {
        (void)[stream tokenObservationWithBlock:^(id event) {
            XCTFail(@"Observer should never be called");
        }];
    }
    [stream sendEvent:@5];
}

- (void)testModifyingObserversInCallback {
    AXStream *stream = [[AXStream alloc] init];

    __block AXStreamObservation *observation1;
    __block AXStreamObservation *observation2;

    observation1 = [stream tokenObservationWithBlock:^(id event) {
        // Observer #1 called first, observer #2 should not be called
        XCTAssert(observation1 && observation2);
        [stream cancelTokenObservation:observation2];
        observation2 = nil;
    }];
    observation2 = [stream tokenObservationWithBlock:^(id event) {
        // Observer #2 called first, observer #1 should not be called
        XCTAssert(observation1 && observation2);
        [stream cancelTokenObservation:observation1];
        observation1 = nil;
    }];

    // Modifying observers in a callback should not throw an NSFastEnumeration exception
    [stream sendEvent:@5];
    XCTAssert((observation1 == nil) ^ (observation2 == nil));
}

- (void)testConnectionPool2 {
    AXStream *stream1 = [[AXStream alloc] init];
    AXStream *stream2 = [[AXStream alloc] init];

    XCTAssertEqualObjects(stream1.connectedStreams, [NSSet set]);
    XCTAssertEqualObjects(stream2.connectedStreams, [NSSet set]);

    __block id observedEvent1;
    __block id observedEvent2;
    [stream1 tokenObservationWithBlock:^(id event) {
        XCTAssertNil(observedEvent1, @"Observer block should be called once");
        observedEvent1 = event;
    }];
    [stream2 tokenObservationWithBlock:^(id event) {
        XCTAssertNil(observedEvent2, @"Observer block should be called once");
        observedEvent2 = event;
    }];
    XCTAssertNil(observedEvent1, @"Observer should not be called during registration");
    XCTAssertNil(observedEvent2, @"Observer should not be called during registration");

    [stream1 connectToStream:stream2];
    XCTAssertEqualObjects(stream1.connectedStreams, [NSSet setWithObject:stream2]);
    XCTAssertEqualObjects(stream2.connectedStreams, [NSSet setWithObject:stream1]);

    [stream1 sendEvent:@5];
    XCTAssertEqualObjects(@5, observedEvent1);
    XCTAssertEqualObjects(@5, observedEvent2);

    observedEvent1 = nil;
    observedEvent2 = nil;
    [stream2 sendEvent:@6];
    XCTAssertEqualObjects(@6, observedEvent1);
    XCTAssertEqualObjects(@6, observedEvent2);

    [stream2 disconnectFromStream:stream1];
    XCTAssertEqualObjects(stream1.connectedStreams, [NSSet set]);
    XCTAssertEqualObjects(stream2.connectedStreams, [NSSet set]);

    observedEvent1 = nil;
    observedEvent2 = nil;
    [stream2 sendEvent:@7];
    XCTAssertEqualObjects(nil, observedEvent1);
    XCTAssertEqualObjects(@7, observedEvent2);
}

- (void)testConnectionPool3 {
    AXStream *stream1 = [[AXStream alloc] init];
    AXStream *stream2 = [[AXStream alloc] init];
    AXStream *stream3 = [[AXStream alloc] init];

    XCTAssertEqualObjects(stream1.connectedStreams, [NSSet set]);
    XCTAssertEqualObjects(stream2.connectedStreams, [NSSet set]);
    XCTAssertEqualObjects(stream3.connectedStreams, [NSSet set]);

    __block id observedEvent1;
    __block id observedEvent2;
    __block id observedEvent3;
    [stream1 tokenObservationWithBlock:^(id event) {
        XCTAssertNil(observedEvent1, @"Observer block should be called once");
        observedEvent1 = event;
    }];
    [stream2 tokenObservationWithBlock:^(id event) {
        XCTAssertNil(observedEvent2, @"Observer block should be called once");
        observedEvent2 = event;
    }];
    [stream3 tokenObservationWithBlock:^(id event) {
        XCTAssertNil(observedEvent3, @"Observer block should be called once");
        observedEvent3 = event;
    }];
    XCTAssertNil(observedEvent1, @"Observer should not be called during registration");
    XCTAssertNil(observedEvent2, @"Observer should not be called during registration");
    XCTAssertNil(observedEvent3, @"Observer should not be called during registration");

    // 1 <-> 2 <-> 3
    [stream1 connectToStream:stream2];
    [stream2 connectToStream:stream3];
    NSSet *expectedStreams1 = [NSSet setWithObject:stream2];
    NSSet *expectedStreams2 = [NSSet setWithArray:@[stream1, stream3]];
    NSSet *expectedStreams3 = [NSSet setWithObject:stream2];
    XCTAssertEqualObjects(stream1.connectedStreams, expectedStreams1);
    XCTAssertEqualObjects(stream2.connectedStreams, expectedStreams2);
    XCTAssertEqualObjects(stream3.connectedStreams, expectedStreams3);

    [stream1 sendEvent:@5];
    XCTAssertEqualObjects(@5, observedEvent1);
    XCTAssertEqualObjects(@5, observedEvent2);
    XCTAssertEqualObjects(@5, observedEvent3);

    [stream3 connectToStream:stream1];
    expectedStreams1 = [NSSet setWithArray:@[stream2, stream3]];
    expectedStreams3 = [NSSet setWithArray:@[stream2, stream1]];
    XCTAssertEqualObjects(stream1.connectedStreams, expectedStreams1);
    XCTAssertEqualObjects(stream2.connectedStreams, expectedStreams2);
    XCTAssertEqualObjects(stream3.connectedStreams, expectedStreams3);

    observedEvent1 = nil;
    observedEvent2 = nil;
    observedEvent3 = nil;
    [stream1 sendEvent:@6];
    XCTAssertEqualObjects(@6, observedEvent1);
    XCTAssertEqualObjects(@6, observedEvent2);
    XCTAssertEqualObjects(@6, observedEvent3);

    [stream1 disconnectFromStream:stream2];
    expectedStreams1 = [NSSet setWithObject:stream3];
    expectedStreams2 = [NSSet setWithObject:stream3];
    XCTAssertEqualObjects(stream1.connectedStreams, expectedStreams1);
    XCTAssertEqualObjects(stream2.connectedStreams, expectedStreams2);
    XCTAssertEqualObjects(stream3.connectedStreams, expectedStreams3);

    observedEvent1 = nil;
    observedEvent2 = nil;
    observedEvent3 = nil;
    [stream1 sendEvent:@7];
    XCTAssertEqualObjects(@7, observedEvent1);
    XCTAssertEqualObjects(@7, observedEvent2);
    XCTAssertEqualObjects(@7, observedEvent3);

    [stream1 disconnectFromStream:stream3];
    expectedStreams1 = [NSSet set];
    expectedStreams3 = [NSSet setWithObject:stream2];
    XCTAssertEqualObjects(stream1.connectedStreams, expectedStreams1);
    XCTAssertEqualObjects(stream2.connectedStreams, expectedStreams2);
    XCTAssertEqualObjects(stream3.connectedStreams, expectedStreams3);

    observedEvent1 = nil;
    observedEvent2 = nil;
    observedEvent3 = nil;
    [stream1 sendEvent:@8];
    XCTAssertEqualObjects(@8, observedEvent1);
    XCTAssertEqualObjects(nil, observedEvent2);
    XCTAssertEqualObjects(nil, observedEvent3);
}

@end
