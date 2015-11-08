//
//  Action.swift
//  Pods
//
//  Created by Chan Fai Chong on 8/11/2015.
//
//

import Foundation

public protocol Action {
    func dispatch()
}

public extension Action {
    public func dispatch() {
        Alt.dispatcher.dispatch(self)
    }
}