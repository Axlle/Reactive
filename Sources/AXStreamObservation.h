//
//  AXStreamObservation.h
//  Reactive
//
//  Created by William Green on 2016-01-17.
//  Copyright © 2016 William Green. All rights reserved.
//

#import <Foundation/Foundation.h>

// The lifecycle of the observer is determined by the lifespan of this observation object and
// whether the observation has been cancelled by the creating stream.
@interface AXStreamObservation : NSObject

@property (nonatomic, readonly) void (^block)(id);

- (instancetype)initWithBlock:(void (^)(id))block;

@end
