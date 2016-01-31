//
//  EventPool+Internal.h
//  Reactive
//
//  Created by William Green on 2016-01-23.
//  Copyright © 2016 William Green. All rights reserved.
//

#import "EventPool.h"

@class EventStream;

@interface EventPool ()

- (instancetype)initWithStream:(EventStream *)stream1 andStream:(EventStream *)stream2;

- (void)sendEvent:(id)event;

- (void)connectStream:(EventStream *)stream1 toStream:(EventStream *)stream2;
- (void)disconnectStream:(EventStream *)stream1 fromStream:(EventStream *)stream2;

@end
