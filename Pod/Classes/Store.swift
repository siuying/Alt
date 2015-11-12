//
//  Store.swift
//  Pods
//
//  Created by Chan Fai Chong on 8/11/2015.
//
//

import Foundation

let StoreChangeEvent = "CHANGE"

public class Store<State> : NSObject {
    public typealias StoreListener = State -> ()
    private let dispatcher : Dispatcher
    private let eventEmitter : EventEmitter
    private var lastId = 1

    private var actionIds : [String] = []
    private var subscriptions : [String:EventSubscription] = [:]

    /// Queue to run on listeners, by default main queue
    public var listenerQueue : dispatch_queue_t = dispatch_get_main_queue()

    public var state : State {
        didSet {
            self.emitChange()
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

    /// Bind an Action to a Handler
    public func bindAction<T: Action>(actionType: T.Type, handler: (T) -> ()) -> String {
        let id = self.dispatcher.register(actionType, handler: handler)
        self.actionIds.append(id)
        return id
    }

    /// Unbind an Action
    public func unbindAction(identifier: String) {
        self.dispatcher.unregister(identifier)
        if let index = self.actionIds.indexOf(identifier) {
            self.actionIds.removeAtIndex(index)
        }
    }
    
    /// Register StoreListener that listen to changes of this store
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

    /// Unregister StoreListener that listen to changes of this store
    public func unlisten(identifier: String) {
        if let subscription = self.subscriptions[identifier] {
            self.eventEmitter.removeListenerWithSubscription(subscription)
            self.subscriptions.removeValueForKey(identifier)
        } else {
            fatalError("Store: listener with id \(identifier) not found")
        }
    }
    
    /// Emit change to any listeners
    public func emitChange() {
        dispatch_async(listenerQueue) { [weak self] () -> Void in
            self?.eventEmitter.emit(StoreChangeEvent)
        }
    }

    /// Wait for all actions registered in a store
    public func waitFor<T: Action>(actionType: T.Type) {
        self.dispatcher.waitFor(self.actionIds, actionType: actionType)
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