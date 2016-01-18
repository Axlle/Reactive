//
//  ObservationToken.m
//  Reactive
//
//  Created by William Green on 2016-01-17.
//  Copyright © 2016 William Green. All rights reserved.
//

#import "EventStreamObservationToken.h"

#import "EventStream.h"

//@interface WeakInDealloc : NSObject
//@property (nonatomic)
//@end

@implementation EventStreamObservationToken {
    weak Stream *_weakStream;
}

- (instancetype)initWithStream:(Stream *)stream {
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)dealloc {
    
}

@end
