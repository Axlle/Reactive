//
//  StreamObservation+Internal.h
//  Reactive
//
//  Created by William Green on 2016-01-23.
//  Copyright © 2016 William Green. All rights reserved.
//

#import "StreamObservation.h"

@interface StreamObservation ()

@property (nonatomic, readonly) void (^block)(id);

- (instancetype)initWithBlock:(void (^)(id))block;

@end