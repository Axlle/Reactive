//
//  EventStream+Internal.h
//  Reactive
//
//  Created by William Green on 2016-01-23.
//  Copyright © 2016 William Green. All rights reserved.
//

#import "EventStream.h"

@interface EventStream ()

@property (nonatomic, readwrite) EventPool *pool;

- (void)notifyObservers:(id)event;

@end
