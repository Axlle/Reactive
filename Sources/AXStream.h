//
//  AXStream.h
//  Reactive
//
//  Created by William Green on 2016-01-17.
//  Copyright © 2016 William Green. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AXStreamObservation;

/// Stream
///
/// A stream circulates events to observers.
///
/// A stream may be connected to another stream, which forms a "pool" of streams. An event
/// sent to a connected stream will be observed by every stream in that pool.
///
@interface AXStream : NSObject

@property (nonatomic, readonly) NSSet *connectedStreams;

- (instancetype)init;

- (void)observeWithBlock:(void (^)(id event))block;
- (AXStreamObservation *)tokenObservationWithBlock:(void (^)(id event))block;
- (void)cancelTokenObservation:(AXStreamObservation *)observation;

- (void)sendEvent:(id)event;

- (void)connectToStream:(AXStream *)stream;
- (void)disconnectFromStream:(AXStream *)stream;

@end
