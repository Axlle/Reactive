//
//  EventStream+Internal.h
//  Reactive
//
//  Created by William Green on 2016-01-23.
//  Copyright © 2016 William Green. All rights reserved.
//

#import "Stream.h"

@interface Stream ()

@property (nonatomic, readwrite) StreamPool *pool;

- (void)notifyObservers:(id)event;

@end
