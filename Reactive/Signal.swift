//
//  Signal.swift
//  Reactive
//
//  Created by William Green on 2015-12-28.
//  Copyright © 2015 William Green. All rights reserved.
//

import Foundation

/// Signal
///
/// A signal is a value that can be observed. It acts like a variable except that signals
/// can be connected so they share the same value (like connecting physical wires).
///
class Signal<T> : NSObject {

    var group: SignalGroup<T> // Underlying value
    let stream = Stream<SignalEvent<T>>()

    var value: T {
        get {
            return self.group.value
        }
        set {
            self.group.value = newValue
        }
    }

    init(initialValue iv: T) {
        self.group = SignalGroup(initialValue: iv)
        super.init()
        self.group.add(self)
    }

    func connectTakingTheirs(signal: Signal<T>) {
        guard signal.group != self.group else { return }

        let newGroup = signal.group
        let oldGroup = self.group

        // Move to new group (this will modify self.group)
        for ourSignal in oldGroup.signals.allObjects as! [Signal<T>] {
            ourSignal.group = newGroup
            newGroup.add(ourSignal)
        }

        // Post update to our signals
        oldGroup.value = newGroup.value
    }

    func sendEvent(event: SignalEvent<T>) {
        self.stream.send(event)
    }
}

class SignalGroup<T> : NSObject {

    var signals = NSHashTable.weakObjectsHashTable()
    var value: T {
        didSet {
            let event = SignalEvent(value: value, oldValue: oldValue)
            self.sendEvent(event)
        }
    }

    init(initialValue iv: T) {
        self.value = iv
    }

    func add(signal: Signal<T>) {
        self.signals.addObject(signal)
    }

    func remove(signal: Signal<T>) {
        self.signals.removeObject(signal)
    }

    func removeAllSignals() {
        self.signals.removeAllObjects()
    }

    func sendEvent(event: SignalEvent<T>) {
        for object in self.signals.allObjects {
            let signal = object as! Signal<T>
            signal.sendEvent(event)
        }
    }
}

struct SignalEvent<T> {
    let value: T
    let oldValue: T
}

