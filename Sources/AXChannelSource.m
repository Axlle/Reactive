//
//  AXChannelSource.m
//  Reactive
//
//  Created by William Green on 2016-01-17.
//  Copyright © 2016 William Green. All rights reserved.
//

#import "AXChannelSource.h"

#import "AXStream.h"
#import "AXSignalDidChangeEvent.h"

@implementation AXChannelSource {
    id _value;
    AXStream *_changeStream;
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

- (id)value {
    return _value;
}

- (void)setValue:(id)value {
    NSAssert(!_inCallback, @"ChannelSource is not reentrant");
    if (value != _value || (value && _value && ![value isEqual:_value])) {
        id oldValue = _value;
        _value = value;
        if (_changeStream) {
            AXSignalDidChangeEvent *event = [[AXSignalDidChangeEvent alloc] initWithValue:_value oldValue:oldValue];
            [self sendEvent:event];
        }
    }
}

- (AXStream *)changeStream {
    if (!_changeStream) {
        _changeStream = [[AXStream alloc] init];
    }
    return _changeStream;
}

#pragma mark - Private methods

- (void)sendEvent:(AXSignalDidChangeEvent *)event {
    _inCallback = YES;
    [_changeStream sendEvent:event];
    _inCallback = NO;
}

@end
