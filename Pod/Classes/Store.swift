//
//  Store.swift
//  Pods
//
//  Created by Chan Fai Chong on 8/11/2015.
//
//

import Foundation

public class Store {
    public init() {
    }

    public func bindAction<T: Action>(actionType: T.Type, handler: (T) -> ()) {
        Alt.dispatcher.register(actionType, handler: handler)
    }
    
    public func listen<T: Store>(handler: (T) -> (Void)) {
    }
    
    public func unlisten<T: Store>(handler: (T) -> (Void)) {
    }
}