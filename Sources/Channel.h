//
//  Channel.h
//  Reactive
//
//  Created by William Green on 2016-01-17.
//  Copyright © 2016 William Green. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Signal.h"


// A channel carries a signal.
// A channel inherits the value of its source. After the source is disconnected, the value persists
// until a new source is connected.
//
// Source of truth.
//
// It acts like a variable except that signals
/// can be connected so they share the same value (like connecting physical wires).
@interface Channel : NSObject <Signal>

@property (nonatomic, weak) id<Signal> source;

- (instancetype)init;
- (instancetype)initWithValue:(id)initialValue;
- (instancetype)initWithSource:(id<Signal>)initialSource;

@end
