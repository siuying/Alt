//
//  Alt.swift
//  Pods
//
//  Created by Chan Fai Chong on 8/11/2015.
//
//

import Foundation

public class Alt {
    public static internal(set) var dispatcher = Dispatcher()
    public static internal(set) var eventEmitter = EventEmitter()
    
    static private var stores : [Any] = []
    static private var storeActionIds : [String: [String]] = [:]
    static private var storeSubscriptions : [String: [String:EventSubscription]] = [:]
    static private var lastId = 1
    static private var listenerQueue : dispatch_queue_t = dispatch_get_main_queue()

    public static func getStore<S: Store>(storeType: S.Type) -> S {
        for store in stores where store is S {
            return store as! S
        }

        // initialize the store if needed
        var newStore = storeType.init()
        newStore.state = storeType.getInitialState()
        stores.append(newStore)
        return newStore
    }

    // Reset all global states, should only be used for testing
    public static func reset() {
        stores = []
        storeActionIds = [:]
        storeSubscriptions = [:]
        lastId = 1
        dispatcher = Dispatcher()
        eventEmitter = EventEmitter()
    }

    static func bindAction<S: Store, T: Action>(store: S, actionType: T.Type, handler: T -> ()) -> String {
        let id = self.dispatcher.register(actionType, handler: handler)

        let storeName = store.storeName()
        var actionIds = self.storeActionIds[storeName] ?? []
        actionIds.append(id)
        self.storeActionIds[storeName] = actionIds

        return id
    }
    
    static func unbindAction<S: Store>(store: S, identifier: String) {
        let name = store.storeName()
        self.dispatcher.unregister(identifier)
        if var actionIds = self.storeActionIds[name], let index = actionIds.indexOf(identifier) {
            actionIds.removeAtIndex(index)
            storeActionIds[name] = actionIds
        }
    }

    static func listen<S: Store>(store: S, handler: (S.State -> ())) -> String {
        let id = "event_listener_\(self.dynamicType)_\(lastId++)"
        let subscription = eventEmitter.addListener(store.storeName()) { (object) -> () in
            dispatch_async(listenerQueue, { () -> Void in
                handler(store.state)
            })
        }

        let storeName = store.storeName()
        var subscriptions = self.storeSubscriptions[storeName] ?? [:]
        subscriptions[id] = subscription
        self.storeSubscriptions[storeName] = subscriptions
        
        return id
    }

    static func unlisten<S: Store>(store: S, identifier: String) {
        if var subscriptions = self.storeSubscriptions[store.storeName()] {
            if let subscription = subscriptions[identifier] {
                self.eventEmitter.removeListenerWithSubscription(subscription)
                subscriptions.removeValueForKey(identifier)
                self.storeSubscriptions[store.storeName()] = subscriptions
                return
            }
        }
        fatalError("Store: listener with id \(identifier) not found")
    }
    
    static func waitFor<S: Store, T: Action>(store: S, actionType: T.Type) {
        let actionIds = storeActionIds[store.storeName()] ?? []
        Alt.dispatcher.waitFor(actionIds, actionType: actionType)
    }
}