//
//  Stream.h
//  Reactive
//
//  Created by William Green on 2016-01-17.
//  Copyright © 2016 William Green. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EventPool;
@class EventStreamObservation;

/// Stream
///
/// A stream is a series of events that can be observed.
///
/// A stream may be connected to another stream, which forms a "pool" of streams. An event
/// sent to a connected stream will be observed by every stream in that pool.
///
@interface EventStream : NSObject

@property (nonatomic, readonly) EventPool *pool;

- (instancetype)init;

- (void)observeWithBlock:(void (^)(id))block;
- (EventStreamObservation *)observationWithBlock:(void (^)(id))block;
- (void)cancelObservation:(EventStreamObservation *)observation;

- (void)sendEvent:(id)event;

- (void)connectToStream:(EventStream *)stream;
- (void)disconnectFromStream:(EventStream *)stream;

@end
