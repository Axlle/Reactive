//
//  AXSignalDidChangeEvent.m
//  Reactive
//
//  Created by William Green on 2016-01-17.
//  Copyright © 2016 William Green. All rights reserved.
//

#import "AXSignalDidChangeEvent.h"

@implementation AXSignalDidChangeEvent

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

    AXSignalDidChangeEvent *event = object;
    return (self.value == event.value       || [self.value isEqual:event.value]) &&
           (self.oldValue == event.oldValue || [self.oldValue isEqual:event.oldValue]);
}

@end
