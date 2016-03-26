//
//  AXChannel.m
//  Reactive
//
//  Created by William Green on 2016-01-17.
//  Copyright © 2016 William Green. All rights reserved.
//

#import "AXChannel.h"

#import "AXStream.h"
#import "AXStreamObservation.h"
#import "AXSignalDidChangeEvent.h"

@implementation AxChannel {
    id _value;
    AXStream *_changeStream;
    __weak id<AXSignal> _source;
    AXStreamObservation *_sourceObservation;
    BOOL _inCallback;
}

#pragma mark - Public methods

- (instancetype)init {
    return [super init];
}

- (instancetype)initWithValue:(id)initialValue {
    self = [self init];
    if (self) {
        _value = initialValue;
    }
    return self;
}

- (instancetype)initWithSource:(id<AXSignal>)initialSource {
    self = [self initWithValue:initialSource.value];
    if (self) {
        _source = initialSource;
        [self observeSource];
    }
    return self;
}

- (id)value {
    return _value;
}

- (AXStream *)changeStream {
    if (!_changeStream) {
        _changeStream = [[AXStream alloc] init];
    }
    return _changeStream;
}

- (id<AXSignal>)source {
    return _source;
}

- (void)setSource:(id<AXSignal>)source {
    NSAssert(!_inCallback, @"Reactive is not reentrant");
    if (source != _source) {
        [self unobserveSource];
        _source = source;
        [self observeSource];

        if (_source) {
            [self setValue:_source.value];
        }
    }
}

#pragma mark - Private methods

- (void)setValue:(id)value {
    if (value != _value || (value && _value && ![value isEqual:_value])) {
        id oldValue = _value;
        _value = value;
        if (_changeStream) {
            AXSignalDidChangeEvent *event = [[AXSignalDidChangeEvent alloc] initWithValue:_value oldValue:oldValue];
            [_changeStream sendEvent:event];
        }
    }
}

- (void)unobserveSource {
    [_source.changeStream cancelObservation:_sourceObservation];
}

- (void)observeSource {
    __weak AXChannel *weakSelf = self;
    _sourceObservation = [_source.changeStream observationWithBlock:^(AXSignalDidChangeEvent *event) {
        AXChannel *strongSelf = weakSelf;
        strongSelf->_value = event.value;
        [strongSelf sendEvent:event];
    }];
}

- (void)sendEvent:(AXSignalDidChangeEvent *)event {
    _inCallback = YES;
    [_changeStream sendEvent:event];
    _inCallback = NO;
}

@end
