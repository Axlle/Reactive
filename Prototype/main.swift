//
//  main.swift
//  Reactive
//
//  Created by William Green on 2015-12-26.
//  Copyright © 2015 William Green. All rights reserved.
//

import Foundation

var channel1 = Channel(initialValue: 1.0)
channel1.stream.observe { event in
    print("Stream1 value is now \(event.value)")
}

var channel2 = Channel(initialValue: 1.1)
channel2.stream.observe { event in
    print("Stream2 value is now \(event.value)")
}

channel1.source = channel2

var pin = Pin(initialValue: 1.2)

channel2.source = pin
pin.value = 0.9

channel1.source = nil
channel1.source = Pin(initialValue: 0.333)

print("hello?")

//class Color : NSObject {
//
//}
//
//class View {
//    var tintColor: Channel<Color> = Channel<Color>(initialValue: Color())
//    var calculatedTintColor: Signal<Color> = Pin<Color>(initialValue: Color())
//}


// MARK: - Stream

//var timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue())
//dispatch_source_set_event_handler(timer) {
//    print("Hello, World!")
//}
//dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1 * UInt64(NSEC_PER_SEC), 100 * UInt64(NSEC_PER_MSEC))
//dispatch_resume(timer)
//
//dispatch_main()

