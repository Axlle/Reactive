//
//  EventPool.m
//  Reactive
//
//  Created by William Green on 2016-01-17.
//  Copyright © 2016 William Green. All rights reserved.
//

#import "EventPool+Internal.h"

#import "EventStream+Internal.h"

@implementation EventPool {
    NSHashTable *_streams;
}

- (instancetype)init {
    self = [super init];
    if (self) {

    }
    return self;
}

- (NSArray *)streams {
    return [_streams allObjects];
}

- (void)sendEvent:(id)event {
    for (EventStream *stream in _streams) {
        [stream notifyObservers:event];
    }
}

@end
