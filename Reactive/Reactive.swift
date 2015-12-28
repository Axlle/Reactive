//
//  Reactive.swift
//  Reactive
//
//  Created by William Green on 2015-12-26.
//  Copyright © 2015 William Green. All rights reserved.
//

import Foundation

// MARK: Signal

/// Signal
///
/// A signal is a value that can be observed. It acts like a variable except that signals
/// can be connected so they share the same value (like connecting physical wires).
///
class Signal<T> {

    typealias Observer = T -> Void

    // TODO: remove unused observers
    // TODO: underlying value (optimization, don't create underlying value container when
    //        signal is disconnected)
    var observers: [Observer] = []
    var value: T {
        didSet {
            for observer in self.observers {
                observer(value)
            }
        }
    }

    init(initialValue iv: T) {
        self.value = iv
    }

    func addObserver(observer: Observer) {
        self.observers.append(observer)
    }
}

// MARK: - Stream

enum StreamState { case Running, Completed, Error, Cancelled }

/// Stream
///
/// A stream is a sequence of events that can be observed.
class Stream<T> {

    typealias NextObserver = T -> Void
    typealias CompletionObserver = () -> Void
    typealias ErrorObserver = ErrorType -> Void
    typealias CancellationObserver = () -> Void

    // TODO: remove unused observers
    var nextObservers: [NextObserver] = []
    var completionObservers: [CompletionObserver] = []
    var errorObservers: [ErrorObserver] = []
    var cancellationObservers: [CancellationObserver] = []
    var state: StreamState = .Running

    var isRunning: Bool   { return self.state == .Running }
    var isCompleted: Bool { return self.state == .Completed }
    var isError: Bool     { return self.state == .Error }
    var isCancelled: Bool { return self.state == .Cancelled }
    var isTerminated: Bool  { return self.isCompleted || self.isError || self.isCancelled }

    func next(value: T) {
        guard self.state == .Running else {
            fatalError()
        }

        for observer in self.nextObservers {
            observer(value)
        }
    }

    func complete() {
        guard self.state == .Running else {
            fatalError()
        }
        self.state == .Completed

        for observer in self.completionObservers {
            observer()
        }
    }

    func fail(error: ErrorType) {
        guard self.state == .Running else {
            fatalError()
        }
        self.state == .Error

        for observer in self.errorObservers {
            observer(error)
        }
    }

    func cancel() {
        guard self.state == .Running else {
            fatalError()
        }
        self.state == .Cancelled

        for observer in self.cancellationObservers {
            observer()
        }
    }

    func addNextObserver(observer: NextObserver) {
        self.nextObservers.append(observer)
    }

    func addCompletionObserver(observer: CompletionObserver) {
        self.completionObservers.append(observer)
    }

    func addErrorObserver(observer: ErrorObserver) {
        self.errorObservers.append(observer)
    }

    func addCancellationObserver(observer: CancellationObserver) {
        self.cancellationObservers.append(observer)
    }
}
