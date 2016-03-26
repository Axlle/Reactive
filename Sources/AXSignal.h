//
//  AXSignal.h
//  Reactive
//
//  Created by William Green on 2016-01-17.
//  Copyright © 2016 William Green. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AXStream;

/// Signal
///
/// A signal is a value that can be observed.
///
@protocol AXSignal <NSObject>

@property (nonatomic, readonly) id value;
@property (nonatomic, readonly) AXStream *changeStream;

@end

