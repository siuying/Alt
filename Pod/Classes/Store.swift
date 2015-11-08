//
//  Store.swift
//  Pods
//
//  Created by Chan Fai Chong on 8/11/2015.
//
//

import Foundation

let StoreChangeEvent = "CHANGE"

public class Store<State> {
    public typealias StoreListener = State -> ()
    private let dispatcher : Dispatcher
    private let eventEmitter : EventEmitter
    private var lastId = 1

    private var subscriptions : [String:EventSubscription] = [:]
    private var actionIds : [String] = []

    public var state : State {
        didSet {
            self.eventEmitter.emit(StoreChangeEvent)
        }
    }
    
    deinit {
        self.subscriptions.removeAll()
    }

    public init(state: State, dispatcher: Dispatcher = Alt.dispatcher) {
        self.state = state
        self.dispatcher = dispatcher
        self.eventEmitter = EventEmitter()
    }

    public func bindAction<T: Action>(actionType: T.Type, handler: (T) -> ()) -> String {
        return self.dispatcher.register(actionType, handler: handler)
    }
    
    public func unbindAction(identifier: String) {
        self.dispatcher.unregister(identifier)
    }
    
    public func listen(handler: StoreListener) -> String {
        let id = "event_listener_\(self.dynamicType)_\(lastId++)"
        let subscription = self.eventEmitter.addListener(StoreChangeEvent) { [weak self] (object) -> () in
            if let store = self {
                handler(store.state)
            }
        }
        self.subscriptions[id] = subscription
        return id
    }
    
    public func unlisten(identifier: String) {
        if let subscription = self.subscriptions[identifier] {
            self.eventEmitter.removeListenerWithSubscription(subscription)
        } else {
            fatalError("Store: listener with id \(identifier) not found")
        }
    }
    
    public func unregister() {
        for actionId in self.actionIds {
            self.unbindAction(actionId)
        }
        self.actionIds.removeAll()
        
        for (key, _) in self.subscriptions {
            self.unlisten(key)
        }
        self.subscriptions.removeAll()
    }
}