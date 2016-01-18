//
//  Signal.h
//  Reactive
//
//  Created by William Green on 2016-01-17.
//  Copyright © 2016 William Green. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EventStream;

/// Signal
///
/// A signal is a value that can be observed. It acts like a variable except that signals
/// can be connected so they share the same value (like connecting physical wires).
///
@protocol Signal <NSObject>

@property (nonatomic, readonly) id value;
@property (nonatomic, readonly) EventStream *changeStream;

@end

