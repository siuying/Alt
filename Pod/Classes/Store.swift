//
//  Store.swift
//  Pods
//
//  Created by Chan Fai Chong on 8/11/2015.
//
//

import Foundation

let StoreChangeEvent = "CHANGE"

public protocol Store {
    typealias State
    
    var state : State! { get set }

    init()

    /// Get the initial state of the store. 
    /// Overriding point.
    static func getInitState() -> State

    /// Store name, by default its the class name
    /// Overriding point.
    func storeName() -> String

    /// Bind an Action to a Handler
    func bindAction<T: Action>(actionType: T.Type, handler: T -> ()) -> String

    /// Unbind an Action
    func unbindAction(identifier: String)

    /// Register a listener to changes of this store
    /// Listener will be called in main thread.
    func listen(handler: State -> ()) -> String

    /// Unregister a listener by its id
    func unlisten(identifier: String)

    /// Wait for a store, for specific action
    func waitFor<T: Action>(actionType: T.Type)

    /// Emit changes to listeners of this Store
    func emitChange()
}

public extension Store {
   
    func storeName() -> String {
        return String(self.dynamicType)
    }

    func bindAction<T: Action>(actionType: T.Type, handler: T -> ()) -> String {
        return Alt.bindAction(self, actionType: actionType, handler: handler)
    }

    func unbindAction(identifier: String) {
        Alt.unbindAction(self, identifier: identifier)
    }

    func listen(handler: State -> ()) -> String {
        return Alt.listen(self, handler: handler)
    }

    func unlisten(identifier: String) {
        Alt.unlisten(self, identifier: identifier)
    }
    
    func waitFor<T: Action>(actionType: T.Type) {
        Alt.waitFor(self, actionType: actionType)
    }
    
    func emitChange() {
        Alt.eventEmitter.emit(self.storeName())
    }
}