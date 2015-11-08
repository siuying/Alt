//
//  Store.swift
//  Pods
//
//  Created by Chan Fai Chong on 8/11/2015.
//
//

import Foundation

public protocol Store {
    var dispatchToken : String { get }

    func bindAction<T: Action>(actionType: T.Type, handler: (T) -> ())
    
    func listen(handler: (Self) -> (Void))
    
    func unlisten(handler: (Self) -> (Void))
}

public extension Store {
    public func bindAction<T: Action>(actionType: T.Type, handler: (T) -> ()) {
    }
    
    public func listen(handler: (Self) -> (Void)) {
    }
    
    public func unlisten(handler: (Self) -> (Void)) {
    }
}