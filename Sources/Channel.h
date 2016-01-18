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
// The value persists after the source is disconnected.
//
// It acts like a variable except that signals
/// can be connected so they share the same value (like connecting physical wires).
@interface Channel : NSObject <Signal>

@property (nonatomic, weak) id<Signal> source;

- (instancetype)init;
- (instancetype)initWithValue:(id)initialValue;
- (instancetype)initWithSource:(id<Signal>)initialSource;

@end
