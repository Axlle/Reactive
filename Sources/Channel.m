//
//  Channel.m
//  Reactive
//
//  Created by William Green on 2016-01-17.
//  Copyright © 2016 William Green. All rights reserved.
//

#import "Channel.h"

#import "EventStream.h"

@implementation Channel {
    id _value;
    EventStream *_stream;
}

- (id)value {
    return _value;
}

- (EventStream *)changeStream {
    if (!_stream) {
        _stream = [[EventStream alloc] init];
    }
    return _stream;
}

- (void)setSource:(id<Signal>)source {

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
        // TODO: set source
    }
    return self;
}

@end
