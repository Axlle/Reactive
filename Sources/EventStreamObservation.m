//
//  ObservationToken.m
//  Reactive
//
//  Created by William Green on 2016-01-17.
//  Copyright © 2016 William Green. All rights reserved.
//

#import "EventStreamObservation+Internal.h"

@implementation EventStreamObservation

- (instancetype)initWithBlock:(void (^)(id))block {
    self = [super init];
    if (self) {
        _block = block;
    }
    return self;
}

@end
