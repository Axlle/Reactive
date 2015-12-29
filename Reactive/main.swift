//
//  main.swift
//  Reactive
//
//  Created by William Green on 2015-12-26.
//  Copyright © 2015 William Green. All rights reserved.
//

import Foundation

var signal: Signal = Signal(initialValue: 5)
//var stream: Stream = Stream()
//
//// MARK: Signal
//
//print("Initial value is \(signal.value)")
signal.updateStream.addObserver() { (event: SignalUpdateEvent<Int>) in
    print("Value is now \(event.value)")
}
//
signal.value = 5

// MARK: - Stream

//var timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue())
//dispatch_source_set_event_handler(timer) {
//    print("Hello, World!")
//}
//dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1 * UInt64(NSEC_PER_SEC), 100 * UInt64(NSEC_PER_MSEC))
//dispatch_resume(timer)
//
//dispatch_main()

