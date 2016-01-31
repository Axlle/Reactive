//
//  StreamObservation.m
//  Reactive
//
//  Created by William Green on 2016-01-17.
//  Copyright © 2016 William Green. All rights reserved.
//

#import "StreamObservation+Internal.h"

@implementation StreamObservation

- (instancetype)initWithBlock:(void (^)(id))block {
    self = [super init];
    if (self) {
        _block = block;
    }
    return self;
}

@end
