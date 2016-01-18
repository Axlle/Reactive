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
/// `protocol Signal<Value>`
public class Signal<Value: Equatable> : NSObject  {
    var _value: Value
    let _stream: Stream<ChangeEvent<Value>> = Stream()

    public internal(set) var value: Value {
        get {
            return _value
        }
        set {
            // TODO: send a ValueWillChangeEvent?
            guard newValue != _value else { return }

            let event = ChangeEvent(value: newValue, oldValue: _value)
            _value = newValue

            _stream.sendEvent(event)
        }
    }

    public var stream: Stream<ChangeEvent<Value>> {
        get {
            return _stream
        }
    }

    init(initialValue: Value) {
        _value = initialValue
    }

    public override var description: String {
        return "<\(self.dynamicType): \(unsafeAddressOf(self))>"
    }
}

public class Channel<Value: Equatable> : Signal<Value> {

    var _source: Signal<Value>?
    var _observationToken: ObservationToken?

    public var source: Signal<Value>? {
        get {
            return _source
        }
        set {
            if let source = _source, let observationToken = _observationToken {
                source.stream.removeObserverForToken(observationToken)
            }

            _source = newValue

            if let source = _source {
                // Register for future values
                _observationToken = source.stream.tokenObserve { [weak self] event in
                    self?.value = event.value
                }
                // Copy current value and send event
                self.value = source.value
            }
        }
    }

    public override init(initialValue: Value) {
        super.init(initialValue: initialValue)
    }

    public convenience init(source: Signal<Value>) {
        self.init(initialValue: source.value)
        self.source = source
    }
}

public class Pin<Value: Equatable> : Signal<Value> {

    public override var value: Value {
        get {
            return super.value
        }
        set {
            super.value = newValue
        }
    }

    public override init(initialValue: Value) {
        super.init(initialValue: initialValue)
    }
}

public struct ChangeEvent<Value> {
    let value: Value
    let oldValue: Value
}

