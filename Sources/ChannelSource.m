//
//  ChannelSource.m
//  Reactive
//
//  Created by William Green on 2016-01-17.
//  Copyright © 2016 William Green. All rights reserved.
//

#import "ChannelSource.h"

@implementation ChannelSource

- (instancetype)init {
    self = [super init];
    if (self) {

    }
    return self;
}

- (instancetype)initWithValue:(id)initialValue {
    self = [super init];
    if (self) {
        _value = initialValue;
    }
    return self;
}

@end
