//
//  EventStreamObservation.h
//  Reactive
//
//  Created by William Green on 2016-01-17.
//  Copyright © 2016 William Green. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EventStream;

// The lifespan of the observer is bound to the lifecycle of this object.
@interface EventStreamObservation : NSObject

@property (nonatomic, readonly, weak) EventStream *stream; // will be `nil` for indefinite observers
@property (nonatomic, readonly) void (^block)(id);

- (instancetype)initWithStream:(EventStream *)stream block:(void (^)(id))block;

@end
