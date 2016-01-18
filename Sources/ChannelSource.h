//
//  ChannelSource.h
//  Reactive
//
//  Created by William Green on 2016-01-17.
//  Copyright © 2016 William Green. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Signal.h"

@interface ChannelSource : NSObject <Signal>

@property (nonatomic, readwrite) id value;

- (instancetype)init;
- (instancetype)initWithValue:(id)initialValue;

@end
