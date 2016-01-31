//
//  Stream.h
//  Reactive
//
//  Created by William Green on 2016-01-17.
//  Copyright © 2016 William Green. All rights reserved.
//

#import <Foundation/Foundation.h>

@class StreamPool;
@class StreamObservation;

/// Stream
///
/// A stream circulates events to observers.
///
/// A stream may be connected to another stream, which forms a "pool" of streams. An event
/// sent to a connected stream will be observed by every stream in that pool.
///
@interface Stream : NSObject

@property (nonatomic, readonly) StreamPool *pool;
@property (nonatomic, readonly) NSArray *connectedStreams;

- (instancetype)init;

- (void)observeWithBlock:(void (^)(id event))block;
- (StreamObservation *)observationWithBlock:(void (^)(id event))block;
- (void)cancelObservation:(StreamObservation *)observation;

- (void)sendEvent:(id)event;

- (void)connectToStream:(Stream *)stream;
- (void)disconnectFromStream:(Stream *)stream;

@end
