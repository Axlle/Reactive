//
//  Stream.m
//  Reactive
//
//  Created by William Green on 2016-01-17.
//  Copyright © 2016 William Green. All rights reserved.
//

#import "EventStream.h"

#import "EventPool+Internal.h"
#import "EventStreamObservation+Internal.h"

@implementation EventStream {
    NSMutableArray *_indefiniteObservers;
    NSHashTable *_observations;
}

- (instancetype)init {
    return [super init];
}

- (NSMutableArray *)indefiniteObservers {
    if (!_indefiniteObservers) {
        _indefiniteObservers = [NSMutableArray array];
    }
    return _indefiniteObservers;
}

- (NSHashTable *)observations {
    if (!_observations) {
        _observations = [NSHashTable weakObjectsHashTable];
    }
    return _observations;
}

- (void)observeWithBlock:(void (^)(id))block {
    [[self indefiniteObservers] addObject:block];
}

- (EventStreamObservation *)observationWithBlock:(void (^)(id))block {
    EventStreamObservation *observation = [[EventStreamObservation alloc] initWithBlock:block];
    [[self observations] addObject:observation];
    return observation;
}

- (void)cancelObservation:(EventStreamObservation *)observation {
    [_observations removeObject:observation];
}

- (void)sendEvent:(id)event {
    if (_pool) {
        [_pool sendEvent:event];
    } else {
        // A pool of one, the loneliest pool
        [self notifyObservers:event];
    }
}

- (void)notifyObservers:(id)event {
    for (void (^block)(id) in _indefiniteObservers) {
        block(event);
    }
    for (EventStreamObservation *observation in _observations) {
        observation.block(event);
    }
}

- (void)connectToStream:(EventStream *)stream {
    if (_pool) {
        [_pool connectStream:self toStream:stream];
    } else if (stream.pool) {
        [stream.pool connectStream:stream toStream:self];
    } else {
        _pool = [[EventPool alloc] initWithStream:self andStream:stream];
    }
}

- (void)disconnectFromStream:(EventStream *)stream {
    [_pool disconnectStream:self fromStream:stream];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p; pool = %@; indefinite observers = %d; cancelleable observers = %d>", NSStringFromClass([self class]), self, _pool ?: @"nil", (int)_indefiniteObservers.count, (int)_observations.count];
}

@end
