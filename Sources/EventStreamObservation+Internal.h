//
//  EventStreamObservation+Internal.h
//  Reactive
//
//  Created by William Green on 2016-01-23.
//  Copyright © 2016 William Green. All rights reserved.
//

#import "EventStreamObservation.h"

@interface EventStreamObservation ()

@property (nonatomic, readonly) void (^block)(id);

- (instancetype)initWithBlock:(void (^)(id))block;

@end