//
//  Signal.h
//  Reactive
//
//  Created by William Green on 2016-01-17.
//  Copyright © 2016 William Green. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Stream;

/// Signal
///
/// A signal is a value that can be observed.
///
@protocol Signal <NSObject>

@property (nonatomic, readonly) id value;
@property (nonatomic, readonly) Stream *changeStream;

@end

