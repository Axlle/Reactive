//
//  Stream.m
//  Reactive
//
//  Created by William Green on 2016-01-17.
//  Copyright © 2016 William Green. All rights reserved.
//

#import "EventStream.h"

@implementation EventStream {
    NSMutableOrderedSet *_observationTokens;
    NSMutableArray *_observers;
}

- (NSMutableOrderedSet *)observationTokens {
    if (!_observationTokens) {
        _observationTokens = [NSMutableOrderedSet orderedSet];
    }
    return _observationTokens;
}

- (NSMutableArray *)observers {
    if (!_observers) {
        _observers = [NSMutableArray array];
    }
    return _observers;
}

- (instancetype)init {
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)sendEvent:(id)event {

}



@end
