//
//  SignalTests.m
//  Reactive
//
//  Created by William Green on 2016-01-30.
//  Copyright © 2016 William Green. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Reactive/Reactive.h>

@interface SignalTests : XCTestCase

@end

@implementation SignalTests

- (void)testInitialValue {
    Channel *channel1 = [[Channel alloc] initWithValue:@5];
    XCTAssertEqualObjects(channel1.value, @5);

    Channel *channel2 = [[Channel alloc] init];
    XCTAssertEqualObjects(channel2.value, nil);

    ChannelSource *source1 = [[ChannelSource alloc] initWithValue:@5];
    XCTAssertEqualObjects(source1.value, @5);

    ChannelSource *source2 = [[ChannelSource alloc] init];
    XCTAssertEqualObjects(source2.value, nil);
}

- (void)testChannelSource {
    ChannelSource *source = [[ChannelSource alloc] initWithValue:@5];

    __block id observedEvent;
    [source.changeStream observeWithBlock:^(id event) {
        XCTAssertNil(observedEvent, @"Observer block should be called once");
        XCTAssert([event isKindOfClass:[SignalDidChangeEvent class]]);
        observedEvent = event;
    }];
    XCTAssertNil(observedEvent, @"Observer should not be called during registration");

    // 5 to 6
    source.value = @6;
    XCTAssertEqualObjects(source.value, @6);
    SignalDidChangeEvent *expectedEvent1 = [[SignalDidChangeEvent alloc] initWithValue:@6 oldValue:@5];
    XCTAssertEqualObjects(expectedEvent1, observedEvent);

    // 6 to nil
    observedEvent = nil;
    source.value = nil;
    XCTAssertNil(source.value);
    SignalDidChangeEvent *expectedEvent2 = [[SignalDidChangeEvent alloc] initWithValue:nil oldValue:@6];
    XCTAssertEqualObjects(expectedEvent2, observedEvent);

    // nil to 6
    observedEvent = nil;
    source.value = @6;
    XCTAssertEqualObjects(source.value, @6);
    SignalDidChangeEvent *expectedEvent3 = [[SignalDidChangeEvent alloc] initWithValue:@6 oldValue:nil];
    XCTAssertEqualObjects(expectedEvent3, observedEvent);

    // 6 to 6
    observedEvent = nil;
    source.value = @6;
    XCTAssertEqualObjects(source.value, @6);
    XCTAssertNil(observedEvent);
}

- (void)testChannel {
    Channel *channel = [[Channel alloc] initWithValue:@5];

    __block id observedEvent;
    [channel.changeStream observeWithBlock:^(id event) {
        XCTAssertNil(observedEvent, @"Observer block should be called once");
        XCTAssert([event isKindOfClass:[SignalDidChangeEvent class]]);
        observedEvent = event;
    }];
    XCTAssertNil(observedEvent, @"Observer should not be called during registration");

    // 5 to 6 -> 5
    ChannelSource *source = [[ChannelSource alloc] initWithValue:@6];
    channel.source = source;
    XCTAssertEqualObjects(channel.value, @6);
    XCTAssertEqualObjects(channel.source, source);
    SignalDidChangeEvent *expectedEvent1 = [[SignalDidChangeEvent alloc] initWithValue:@6 oldValue:@5];
    XCTAssertEqualObjects(expectedEvent1, observedEvent);

    // Disconnect
    observedEvent = nil;
    channel.source = nil;
    XCTAssertEqualObjects(channel.value, @6);
    XCTAssertNil(observedEvent);

    // 6 -> 6
    Channel *intermediateChannel = [[Channel alloc] initWithSource:source];
    XCTAssertEqualObjects(intermediateChannel.value, @6);
    XCTAssertEqualObjects(intermediateChannel.source, source);
    XCTAssertNil(observedEvent);

    // 6 -> 6 to 6 -> 6 -> 6
    channel.source = intermediateChannel;
    XCTAssertEqualObjects(channel.value, @6);
    XCTAssertNil(observedEvent);

    // 6 -> 6 -> 6 to 5 -> 6 -> 6
    source.value = @5;
    XCTAssertEqualObjects(channel.value, @5);
    XCTAssertEqualObjects(channel.source, intermediateChannel);
    XCTAssertEqualObjects(intermediateChannel.value, @5);
    XCTAssertEqualObjects(intermediateChannel.source, source);
    SignalDidChangeEvent *expectedEvent2 = [[SignalDidChangeEvent alloc] initWithValue:@5 oldValue:@6];
    XCTAssertEqualObjects(expectedEvent2, observedEvent);
}

@end
