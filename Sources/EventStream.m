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
    self = [super init];
    if (self) {

    }
    return self;
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

}

- (void)disconnectFromStream:(EventStream *)stream {
    
}

@end
