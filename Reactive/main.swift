//
//  main.swift
//  Reactive
//
//  Created by William Green on 2015-12-26.
//  Copyright © 2015 William Green. All rights reserved.
//

import Foundation

var signal1 = Signal(initialValue: 1.0)
signal1.stream.addObserver() { event in
    print("Stream1 value is now \(event.value)")
}

var signal2 = Signal(initialValue: 1.1)
signal2.stream.addObserver { event in
    print("Stream2 value is not \(event.value)")
}

signal1.connectTakingTheirs(signal2)

signal2.value = 1.2
signal1.value = 0.9

// MARK: - Stream

//var timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue())
//dispatch_source_set_event_handler(timer) {
//    print("Hello, World!")
//}
//dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1 * UInt64(NSEC_PER_SEC), 100 * UInt64(NSEC_PER_MSEC))
//dispatch_resume(timer)
//
//dispatch_main()

