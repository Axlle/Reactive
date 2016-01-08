//
//  Stream.swift
//  Reactive
//
//  Created by William Green on 2015-12-28.
//  Copyright © 2015 William Green. All rights reserved.
//

import Foundation

public class ObservationToken : NSObject {

}

class TypedObservationToken<Event> : ObservationToken {
    let stream: WeakForDealloc<Stream<Event>>

    init(stream: Stream<Event>) {
        self.stream = WeakForDealloc(reference: stream)
    }

    deinit {
        self.stream.reference?.removeObserverForToken(self)
    }
}

// Allows access to a weak ivar during -dealloc
struct WeakForDealloc<T: AnyObject> {
    weak var reference: T?
}

/// Stream
///
/// A stream is a series of events that can be observed.
///
/// A stream may be connected to another stream, which forms a "pool" of streams. An event
/// sent to a connected stream will be observed by every stream in that pool.
///
public class Stream<Event> : NSObject {

    public typealias Observer = Event -> Void

    // TODO: use a weak ordered set to ensure determinism?
    var observers: [Observer] = []
    var tokenObservers: [ObservationToken: Observer] = [:]
//    var pool: StreamPool<Event>?
//
//    // MARK: - Public
//
//    deinit {
//        self.pool?.remove(self)
//    }
//
    public func sendEvent(event: Event) {
//        if let pool = self.pool {
//            pool.send(event)
//        } else {
        self.notify(event)
//        }
    }
//
//    public func connectTo(stream: Stream<Event>) {
//        let pool = self.pool ?? stream.pool ?? StreamPool(stream: self)
//        pool.connect(self, to: stream)
//    }
//
//    public func disconnectFrom(stream: Stream<Event>) {
//        self.pool?.disconnect(self, from: stream)
//    }
//
    public func observe(observer: Observer) {
        self.observers.append(observer)
    }

    public func tokenObserve(observer: Observer) -> ObservationToken {
        let token = TypedObservationToken<Event>(stream: self)
        self.tokenObservers[token] = observer
        return token
    }

    public func removeObserverForToken(token: ObservationToken) {
        self.tokenObservers.removeValueForKey(token)
    }

    // MARK: - Private

    func notify(event: Event) {
        // TODO: observers might get added, removed or deallocated during these loops
        for observer in self.observers {
            observer(event)
        }
        for (_, observer) in self.tokenObservers {
            observer(event)
        }
    }
}
//
//
///// Implements a connected undirected graph
//class StreamPool<Event> {
//
//    var graph: Graph<Stream<Event>>
//
//    init(stream: Stream<Event>) {
//        self.graph = Graph(initialNode: stream)
//    }
//
//    func remove(stream: Stream<Event>) {
//
//    }
//
//    func connect(stream1: Stream<Event>, to stream2: Stream<Event>) {
//        assert(stream1.pool === self || stream2.pool === self)
//    }
//
//    func disconnect(stream1: Stream<Event>, from stream2: Stream<Event>) {
//
//    }
//
//    func send(event: Event) {
//
//    }
//}
//
//protocol GraphDelegate {
//    typealias T: AnyObject
//
//    func graph(graph: Graph<T>, didConnect node1: T, to node2: T)
//    func graph(graph: Graph<T>, didDisconnect node1: T, from node2: T)
//    func graph(graph: Graph<T>, didSplit
//}
//
//class Graph<T: AnyObject> {
//
//    var nodes: [Unowned<T>] = []
//    var edges: [[Bool]] = [[]]
//
//    init(initialNode: T) {
//        self.nodes.append(Unowned(unownedReference: initialNode))
//    }
//
//    func connect(node1: T, to node2: T) {
//
//    }
//
//    func disconnect(node1: T, from node2: T) {
//
//    }
//
//    func remove(node: T) {
//        // TODO: remove from each
//    }
//}


//struct Unowned<T: AnyObject> {
//    unowned var unownedReference: T
//}