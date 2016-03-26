//
//  StreamPool+Internal.h
//  Reactive
//
//  Created by William Green on 2016-01-23.
//  Copyright © 2016 William Green. All rights reserved.
//

#import "StreamPool.h"

@class Stream;

@interface StreamPool ()

- (instancetype)initWithStream:(Stream *)stream1 andStream:(Stream *)stream2;

- (void)sendEvent:(id)event;

- (NSArray *)streamsConnectedToStream:(Stream *)stream;
- (void)connectStream:(Stream *)stream1 toStream:(Stream *)stream2;
- (void)disconnectStream:(Stream *)stream1 fromStream:(Stream *)stream2;
- (void)removeStream:(Stream *)stream;

@end
