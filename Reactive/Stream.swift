//
//  Stream.swift
//  Reactive
//
//  Created by William Green on 2015-12-28.
//  Copyright © 2015 William Green. All rights reserved.
//

import Foundation

/// Stream
///
/// A stream is a series of events that can be observed.
class Stream<EventType> {

    typealias Observer = EventType -> Void

    // TODO: remove unused observers
    var observers: [Observer] = []

    func send(event: EventType) {
        for observer in self.observers {
            observer(event)
        }
    }

    func addObserver(observer: Observer) {
        self.observers.append(observer)
    }
}