//
//  AXSignalDidChangeEvent.h
//  Reactive
//
//  Created by William Green on 2016-01-17.
//  Copyright © 2016 William Green. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AXSignalDidChangeEvent : NSObject <NSCopying>

@property (nonatomic, readonly) id value;
@property (nonatomic, readonly) id oldValue;

- (instancetype)initWithValue:(id)value oldValue:(id)oldValue;

@end
