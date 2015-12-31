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
///
/// A stream may be connected to another stream, which forms a "pool" of two streams. An event
/// sent to a connected stream will be observed by every stream in that pool.
///
public class Stream<Event> : NSObject {

    public typealias Observer = Event -> Void

    var unkeyedObservers: [Observer] = []
    var keyedObservers: [String: Observer] = [:]
    var parent: Stream<Event>?
    let children = NSHashTable.weakObjectsHashTable()

    // MARK: - Public

    public func send(event: Event) {
        self.root.sendRecursive(event)
    }

    public func connectTo(stream: Stream<Event>) {
        self.disconnect()
        self.parent = stream
        self.parent?.children.addObject(self)
    }

    public func disconnect() {
        self.parent?.children.removeObject(self)
        self.parent = nil
    }

    public func observe(observer: Observer) {
        self.unkeyedObservers.append(observer)
    }

    public func addKeyedObserver(key: String, observer: Observer) {
        self.keyedObservers[key] = observer
    }

    public func removeObserverForKey(key: String) {
        self.keyedObservers.removeValueForKey(key)
    }

    // MARK: - Private

    var root: Stream<Event> {
        if let parent = self.parent {
            return parent.root
        } else {
            return self
        }
    }

    func sendRecursive(event: Event) {
        for observer in self.unkeyedObservers {
            observer(event)
        }
        for (_, observer) in self.keyedObservers {
            observer(event)
        }

        for child in self.children.setRepresentation as! Set<Stream<Event>> {
            child.sendRecursive(event)
        }
    }
}