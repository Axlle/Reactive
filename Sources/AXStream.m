//
//  AXStream.m
//  Reactive
//
//  Created by William Green on 2016-01-17.
//  Copyright © 2016 William Green. All rights reserved.
//

#import "AXStream.h"

#import "StreamObservation.h"

@implementation AXStream {
    NSHashTable *_weakConnections;
    NSMutableArray *_strongObservations;
    NSHashTable *_weakObservations;
    BOOL _inCallback;
}

#pragma mark - Public methods

- (instancetype)init {
    return [super init];
}

- (NSSet *)connectedStreams {
    return _weakConnections ? [_weakConnections setRepresentation] : [NSSet set];
}

- (void)observeWithBlock:(void (^)(id))block {
    AXStreamObservation *observation = [self tokenObservationWithBlock:block];
    [[self strongObservations] addObject:observation];
}

- (AXStreamObservation *)tokenObservationWithBlock:(void (^)(id))block {
    AXStreamObservation *observation = [[AXStreamObservation alloc] initWithBlock:block];
    [[self weakObservations] addObject:observation];
    return observation;
}

- (void)cancelTokenObservation:(AXStreamObservation *)observation {
    [_weakObservations removeObject:observation];
}

- (void)sendEvent:(id)event {
    NSAssert(!_inCallback, @"Stream is not reentrant");
    if (_weakConnections.count > 0) {
        NSMutableSet *visitedNodes = [NSMutableSet set];
        NSMutableSet *nodesToVisit = [NSMutableSet setWithObject:self];
        while (nodesToVisit.count > 0) {
            AXStream *node = [nodesToVisit anyObject];
            [nodesToVisit removeObject:node];
            [visitedNodes addObject:node];

            for (AXStream *edge in node->_weakConnections) {
                if (![visitedNodes containsObject:edge]) {
                    [nodesToVisit addObject:edge];
                }
            }
        }

        for (AXStream *stream in visitedNodes) {
            stream->_inCallback = YES;
        }
        for (AXStream *stream in visitedNodes) {
            [stream notifyObservers:event];
        }
        for (AXStream *stream in visitedNodes) {
            stream->_inCallback = NO;
        }
    } else {
        _inCallback = YES;
        [self notifyObservers:event];
        _inCallback = NO;
    }
}

- (void)connectToStream:(AXStream *)stream {
    NSAssert(!_inCallback, @"Stream is not reentrant");
    [[self weakConnections] addObject:stream];
    [[stream weakConnections] addObject:self];
}

- (void)disconnectFromStream:(AXStream *)stream {
    NSAssert(!_inCallback, @"Stream is not reentrant");
    [_weakConnections removeObject:stream];
    [stream->_weakConnections removeObject:self];
}

#pragma mark - Private methods

- (NSHashTable *)weakConnections {
    if (!_weakConnections) {
        _weakConnections = [NSHashTable weakObjectsHashTable];
    }
    return _weakConnections;
}

- (NSMutableArray *)strongObservations {
    if (!_strongObservations) {
        _strongObservations = [NSMutableArray array];
    }
    return _strongObservations;
}

- (NSHashTable *)weakObservations {
    if (!_weakObservations) {
        _weakObservations = [NSHashTable weakObjectsHashTable];
    }
    return _weakObservations;
}

- (void)notifyObservers:(id)event {
    for (AXStreamObservation *observation in [_weakObservations allObjects]) {
        if ([_weakObservations containsObject:observation]) { // an observer may have been removed by another observer
            observation.block(event);
        }
    }
}

@end
