//
//  AXSignalTests.m
//  Reactive
//
//  Created by William Green on 2016-01-30.
//  Copyright © 2016 William Green. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Reactive/Reactive.h>

@interface AXSignalTests : XCTestCase

@end

@implementation AXSignalTests

- (void)testInitialValue {
    AXChannel *channel1 = [[AXChannel alloc] initWithValue:@5];
    XCTAssertEqualObjects(channel1.value, @5);

    AXChannel *channel2 = [[AXChannel alloc] init];
    XCTAssertEqualObjects(channel2.value, nil);

    AXChannelSource *source1 = [[AXChannelSource alloc] initWithValue:@5];
    XCTAssertEqualObjects(source1.value, @5);

    AXChannelSource *source2 = [[AXChannelSource alloc] init];
    XCTAssertEqualObjects(source2.value, nil);
}

- (void)testChannelSource {
    AXChannelSource *source = [[AXChannelSource alloc] initWithValue:@5];

    __block id observedEvent;
    [source.changeStream observeWithBlock:^(id event) {
        XCTAssertNil(observedEvent, @"Observer block should be called once");
        XCTAssert([event isKindOfClass:[AXSignalDidChangeEvent class]]);
        observedEvent = event;
    }];
    XCTAssertNil(observedEvent, @"Observer should not be called during registration");

    // Change 5 to 6
    source.value = @6;
    XCTAssertEqualObjects(source.value, @6);
    AXSignalDidChangeEvent *expectedEvent1 = [[AXSignalDidChangeEvent alloc] initWithValue:@6 oldValue:@5];
    XCTAssertEqualObjects(expectedEvent1, observedEvent);

    // Change 6 to nil
    observedEvent = nil;
    source.value = nil;
    XCTAssertNil(source.value);
    AXSignalDidChangeEvent *expectedEvent2 = [[AXSignalDidChangeEvent alloc] initWithValue:nil oldValue:@6];
    XCTAssertEqualObjects(expectedEvent2, observedEvent);

    // Change nil to 6
    observedEvent = nil;
    source.value = @6;
    XCTAssertEqualObjects(source.value, @6);
    AXSignalDidChangeEvent *expectedEvent3 = [[AXSignalDidChangeEvent alloc] initWithValue:@6 oldValue:nil];
    XCTAssertEqualObjects(expectedEvent3, observedEvent);

    // Change 6 to 6
    observedEvent = nil;
    source.value = @6;
    XCTAssertEqualObjects(source.value, @6);
    XCTAssertNil(observedEvent);
}

- (void)testChannel {
    AXChannel *channel = [[AXChannel alloc] initWithValue:@5];

    __block id observedEvent;
    [channel.changeStream observeWithBlock:^(id event) {
        XCTAssertNil(observedEvent, @"Observer block should be called once");
        XCTAssert([event isKindOfClass:[AXSignalDidChangeEvent class]]);
        observedEvent = event;
    }];
    XCTAssertNil(observedEvent, @"Observer should not be called during registration");

    // Change 5 to 5 -> 5
    AXChannelSource *source = [[AXChannelSource alloc] initWithValue:@6];
    channel.source = source;
    XCTAssertEqualObjects(channel.value, @6);
    XCTAssertEqualObjects(channel.source, source);
    AXSignalDidChangeEvent *expectedEvent1 = [[AXSignalDidChangeEvent alloc] initWithValue:@6 oldValue:@5];
    XCTAssertEqualObjects(expectedEvent1, observedEvent);

    // Disconnect
    observedEvent = nil;
    channel.source = nil;
    XCTAssertEqualObjects(channel.value, @6);
    XCTAssertNil(observedEvent);

    // Create a channel already connected to the source
    AXChannel *intermediateChannel = [[AXChannel alloc] initWithSource:source];
    XCTAssertEqualObjects(intermediateChannel.value, @6);
    XCTAssertEqualObjects(intermediateChannel.source, source);
    XCTAssertNil(observedEvent);

    // Change 6 -> 6 to 6 -> 6 -> 6
    channel.source = intermediateChannel;
    XCTAssertEqualObjects(channel.value, @6);
    XCTAssertNil(observedEvent);

    // Change 6 -> 6 -> 6 to 5 -> 5 -> 5
    source.value = @5;
    XCTAssertEqualObjects(channel.value, @5);
    XCTAssertEqualObjects(channel.source, intermediateChannel);
    XCTAssertEqualObjects(intermediateChannel.value, @5);
    XCTAssertEqualObjects(intermediateChannel.source, source);
    AXSignalDidChangeEvent *expectedEvent2 = [[AXSignalDidChangeEvent alloc] initWithValue:@5 oldValue:@6];
    XCTAssertEqualObjects(expectedEvent2, observedEvent);
}

- (void)testWeakSource {
    AXChannel *channel = [[AXChannel alloc] initWithValue:@5];
    AXChannelSource *source;
    @autoreleasepool {
        source = [[AXChannelSource alloc] initWithValue:@6];
        channel.source = source;
        XCTAssertEqualObjects(channel.source, source);
        XCTAssertEqualObjects(channel.value, @6);
    }
    source = nil;
    XCTAssertEqualObjects(channel.source, nil);
    XCTAssertEqualObjects(channel.value, @6);
}

@end
