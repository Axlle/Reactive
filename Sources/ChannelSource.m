//
//  ChannelSource.m
//  Reactive
//
//  Created by William Green on 2016-01-17.
//  Copyright © 2016 William Green. All rights reserved.
//

#import "ChannelSource.h"

#import "EventStream.h"
#import "SignalDidChangeEvent.h"

@implementation ChannelSource {
    id _value;
    EventStream *_changeStream;
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

- (EventStream *)changeStream {
    if (!_changeStream) {
        _changeStream = [[EventStream alloc] init];
    }
    return _changeStream;
}

@end
