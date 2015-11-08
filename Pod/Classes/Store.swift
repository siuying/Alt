//
//  Store.swift
//  Pods
//
//  Created by Chan Fai Chong on 8/11/2015.
//
//

import Foundation

public class Store {
    private let dispatcher : Dispatcher
    let dispatcherToken : String

    public init(dispatcher: Dispatcher = Alt.dispatcher) {
        self.dispatcher = dispatcher
    }

    public func bindAction<T: Action>(actionType: T.Type, handler: (T) -> ()) {
        self.dispatcher.register(handler)
    }
    
    public func listen<T: Store>(handler: (T) -> (Void)) {
    }
    
    public func unlisten<T: Store>(handler: (T) -> (Void)) {
    }
}