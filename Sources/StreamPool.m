////
////  StreamPool.m
////  Reactive
////
////  Created by William Green on 2016-01-17.
////  Copyright © 2016 William Green. All rights reserved.
////
//
//#import "StreamPool+Internal.h"
//
//#import "Stream+Internal.h"
//
//@implementation StreamPool {
//    NSPointerArray *_weakStreams;
//    NSMutableArray *_connections; // array of sets of indices into _streams
//}
//
//- (instancetype)initWithStream:(Stream *)stream1 andStream:(Stream *)stream2 {
//    self = [super init];
//    if (self) {
//        _weakStreams = [NSPointerArray weakObjectsPointerArray];
//        _connections = [NSMutableArray array];
//
//        [_weakStreams addPointer:(void *)stream1];
//        [_weakStreams addPointer:(void *)stream2];
//        [_connections addObject:[NSMutableSet setWithObject:@1]];
//        [_connections addObject:[NSMutableSet setWithObject:@0]];
//
//        NSAssert(stream1.pool == nil && stream2.pool == nil, @"");
//        stream1.pool = self;
//        stream2.pool = self;
//    }
//    return self;
//}
//
//#pragma mark Public methods
//
//- (NSArray *)streams {
//    // Note: don't assert our internal state because this public method can be called
//    // when all the streams have disappeared.
//    return [_weakStreams allObjects];
//}
//
//#pragma mark Internal methods
//
//- (NSArray *)streamsConnectedToStream:(Stream *)stream {
//    // TODO: connections may have died
//    return nil;
//}
//
//- (void)sendEvent:(id)event {
//    // TODO: connections may have died
//    for (Stream *stream in _weakStreams) {
//        [stream notifyObservers:event];
//    }
//}
//
//- (void)connectStream:(Stream *)stream1 toStream:(Stream *)stream2 {
//    NSAssert(stream1.pool == self, @"");
//    // TODO: connections may have died
//    // Note: this may cause at most 2 pools to merge
//}
//
//- (void)disconnectStream:(Stream *)stream1 fromStream:(Stream *)stream2 {
//    NSAssert(stream1.pool == self, @"");
//    NSAssert(stream2.pool == self, @"");
//    // TODO: connections may have died
//    // Note: this may cause at most 2 pools to fork
//}
//
//- (void)removeStream:(Stream *)stream {
//    NSAssert(stream.pool == self, @"");
//    // Note: this may cause 2 or more pools to fork
//}
//
//#pragma mark Private methods
//
//- (void)rebuildGraphForReason:(
//
//- (void)assertInternalState {
//    NSArray *streams = [_weakStreams allObjects];
//    NSAssert(streams.count >= 2, @"Error: not enought streams in pool");
//    NSSet *nonNilSet = [NSSet setWithArray:streams];
//    NSAssert(streams.count == _weakStreams.count, @"Error: nil stream in pool");
//    NSAssert(nonNilSet.count == _streams.count, @"Error: duplicate stream in pool");
//    for (NSSet *edgeSet in _connections) {
//        for (NSNumber *edge in edgeSet) {
//            NSAssert([edge unsignedIntegerValue] < streams.count, @"Error: edge index out of bounds in pool");
//        }
//    }
//    for (Stream *stream in streams) {
//        NSAssert(stream.pool == self, @"Error: stream does not reference its parent pool");
//    }
//    for (int i = 0; i < streams.count; i++) {
//        NSAssert(![_connections[i] containsObject:@(i)], @"Error: stream should not have connection to itself");
//    }
//
//    NSMutableSet *visitedNodes = [NSMutableSet set];
//    NSMutableSet *nodesToVisit = [NSMutableSet setWithObject:@0];
//    while (nodesToVisit.count > 0) {
//        NSNumber *node = [nodesToVisit anyObject];
//        [nodesToVisit removeObject:node];
//        [visitedNodes addObject:node];
//
//        NSSet *edgeSet = _connections[[node unsignedIntegerValue]];
//        NSMutableSet *unvisitedEdges = [edgeSet mutableCopy];
//        [unvisitedEdges minusSet:visitedNodes];
//        [nodesToVisit unionSet:unvisitedEdges];
//    }
//    NSAssert(visitedNodes.count == streams.count, @"Error: pool is not a connected graph");
//}
//
//- (NSString *)description {
//    return [NSString stringWithFormat:@"<%@: %p>", NSStringFromClass([self class]), self];
//}
//
//@end
