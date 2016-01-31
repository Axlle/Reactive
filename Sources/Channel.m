//
//  Channel.m
//  Reactive
//
//  Created by William Green on 2016-01-17.
//  Copyright © 2016 William Green. All rights reserved.
//

#import "Channel.h"

#import "Stream.h"
#import "StreamObservation.h"
#import "SignalDidChangeEvent.h"

@implementation Channel {
    id _value;
    Stream *_changeStream;
    __weak id<Signal> _source;
    StreamObservation *_sourceObservation;
}

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

- (instancetype)initWithSource:(id<Signal>)initialSource {
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

- (void)setValue:(id)value {
    if (value != _value || (value && _value && ![value isEqual:_value])) {
        id oldValue = _value;
        _value = value;
        if (_changeStream) {
            SignalDidChangeEvent *event = [[SignalDidChangeEvent alloc] initWithValue:_value oldValue:oldValue];
            [_changeStream sendEvent:event];
        }
    }
}

- (Stream *)changeStream {
    if (!_changeStream) {
        _changeStream = [[EventStream alloc] init];
    }
    return _changeStream;
}

- (id<Signal>)source {
    return _source;
}

- (void)setSource:(id<Signal>)source {
    if (source != _source) {
        [self unobserveSource];
        _source = source;
        [self observeSource];

        if (_source) {
            [self setValue:_source.value];
        }
    }
}

- (void)unobserveSource {
    [_source.changeStream cancelObservation:_sourceObservation];
}

- (void)observeSource {
    __weak Channel *weakSelf = self;
    _sourceObservation = [_source.changeStream observationWithBlock:^(SignalDidChangeEvent *event) {
        [weakSelf setValue:event.value];
    }];
}

@end
