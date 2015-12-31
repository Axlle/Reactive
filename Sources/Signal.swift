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
public class Signal<T> : NSObject {

    var group: SignalGroup<T> // Underlying value
    var connection: Signal<T>?
    let connectees = NSHashTable.weakObjectsHashTable()
    public let stream = Stream<SignalEvent<T>>()

    public var value: T {
        get {
            return self.group.value
        }
        set {
            self.group.value = newValue
        }
    }

    public init(initialValue iv: T) {
        self.group = SignalGroup(initialValue: iv)
        super.init()
        self.group.signals.addObject(self)
    }

    /// Take theirs policy
    public func connectTo(signal: Signal<T>) {
        guard signal.group != self.group else { return }

        let newGroup = signal.group
        let oldGroup = self.group

        // Move to new group (this will modify self.group)
        for ourSignal in oldGroup.signals.setRepresentation as! Set<Signal<T>> {
            ourSignal.group = newGroup
            newGroup.signals.addObject(self)
        }

        // Post update to our signals
        oldGroup.value = newGroup.value
    }

    public func disconnect() {
        // TODO: implement this
    }

    func sendEvent(event: SignalEvent<T>) {
        self.stream.send(event)
    }

    public override var description: String {
        return "<\(self.dynamicType): \(unsafeAddressOf(self))>"
    }
}

class SignalGroup<T> : NSObject {

    // TODO: use a weak ordered set to ensure determinism?
    let signals = NSHashTable.weakObjectsHashTable()
    var value: T {
        didSet {
            let event = SignalEvent(value: value, oldValue: oldValue)
            self.sendEvent(event)
        }
    }

    init(initialValue iv: T) {
        self.value = iv
    }

    func sendEvent(event: SignalEvent<T>) {
        for signal in self.signals.setRepresentation as! Set<Signal<T>> {
            signal.sendEvent(event)
        }
    }
}

public struct SignalEvent<T> {
    let value: T
    let oldValue: T
}

