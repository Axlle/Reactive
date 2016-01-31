//
//  SignalDidChangeEvent.m
//  Reactive
//
//  Created by William Green on 2016-01-17.
//  Copyright © 2016 William Green. All rights reserved.
//

#import "SignalDidChangeEvent.h"

@implementation SignalDidChangeEvent

- (instancetype)initWithValue:(id)value oldValue:(id)oldValue {
    self = [super init];
    if (self) {
        _value = value;
        _oldValue = oldValue;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    return [[[self class] allocWithZone:zone] initWithValue:_value oldValue:_oldValue];
}

- (NSUInteger)hash {
    return [_value hash] ^ [_oldValue hash];
}

- (BOOL)isEqual:(id)object {
    if (![object isMemberOfClass:[self class]]) {
        return NO;
    }

    SignalDidChangeEvent *event = object;
    return ((self.value == nil    && event.value == nil)    || [self.value isEqual:event.value]) &&
           ((self.oldValue == nil && event.oldValue == nil) || [self.oldValue isEqual:event.oldValue]);
}

@end
