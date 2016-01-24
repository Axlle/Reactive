//
//  Stream.m
//  Reactive
//
//  Created by William Green on 2016-01-17.
//  Copyright © 2016 William Green. All rights reserved.
//

#import "EventStream.h"

@implementation EventStream {
    NSMutableOrderedSet *_observations;
}

- (NSMutableOrderedSet *)observations {
    if (!_observations) {
        _observations = [NSMutableOrderedSet orderedSet];
    }
    return _observations;
}

- (instancetype)init {
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)observeWithBlock:(void (^)(id))block {

}

- (EventStreamObservation *)observationWithBlock:(void (^)(id))block {
    return nil;
}

- (void)removeObservation:(EventStreamObservation *)observation {

}

- (void)sendEvent:(id)event {

}



@end
