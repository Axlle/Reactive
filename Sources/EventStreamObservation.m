//
//  ObservationToken.m
//  Reactive
//
//  Created by William Green on 2016-01-17.
//  Copyright © 2016 William Green. All rights reserved.
//

#import "EventStreamObservation.h"

#import "EventStream.h"

//@interface WeakInDealloc : NSObject
//@property (nonatomic)
//@end

@implementation EventStreamObservation {
    __weak EventStream *_weakStream;
}

- (instancetype)initWithStream:(EventStream *)stream {
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)dealloc {
    
}

@end
