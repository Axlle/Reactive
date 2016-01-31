//
//  StreamPool.m
//  Reactive
//
//  Created by William Green on 2016-01-17.
//  Copyright © 2016 William Green. All rights reserved.
//

#import "StreamPool+Internal.h"

#import "Stream+Internal.h"

@implementation StreamPool {
    NSPointerArray *_streams;
    NSMutableArray *_connections; // array of sets of indices into _streams
}

- (instancetype)initWithStream:(Stream *)stream1 andStream:(Stream *)stream2 {
    self = [super init];
    if (self) {
        _streams = [NSPointerArray weakObjectsPointerArray];
        _connections = [NSMutableArray array];

        [_streams addPointer:(void *)stream1];
        [_streams addPointer:(void *)stream2];
        [_connections addObject:[NSMutableSet setWithObject:@1]];
        [_connections addObject:[NSMutableSet setWithObject:@0]];
    }
    return self;
}

- (NSArray *)streams {
    // TODO: connections may have died
    return [_streams allObjects];
}

- (void)sendEvent:(id)event {
    // TODO: connections may have died
    for (Stream *stream in _streams) {
        [stream notifyObservers:event];
    }
}

- (void)connectStream:(Stream *)stream1 toStream:(Stream *)stream2 {
    // TODO: connections may have died
}

- (void)disconnectStream:(Stream *)stream1 fromStream:(Stream *)stream2 {
    // TODO: connections may have died
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p>", NSStringFromClass([self class]), self];
}

@end
