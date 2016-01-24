//
//  EventPool+Internal.h
//  Reactive
//
//  Created by William Green on 2016-01-23.
//  Copyright © 2016 William Green. All rights reserved.
//

#import "EventPool.h"

@interface EventPool ()

- (instancetype)init;

- (void)sendEvent:(id)event;

@end
