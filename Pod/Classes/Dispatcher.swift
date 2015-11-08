//
//  Dispatcher.swift
//  Pods
//
//  Created by Chan Fai Chong on 8/11/2015.
//
//

import Foundation

public class Dispatcher {
    private var callbacks: [String:AnyObject] = [:]
    private var isDispatching = false
    private var isHandled: [String:Bool] = [:]
    private var isPending: [String:Bool] = [:]
    private var lastId = 1

    internal init() {
    }
    
    /// Registers a callback to be invoked with every dispatched payload. Returns
    /// a token that can be used with `waitFor()`.
    public func register<T: Action>(actionType: T.Type, handler: (T) -> Void) -> String {
        let nextDispatchToken = "dispatcher_callback_\(self.lastId++)"
        self.callbacks[nextDispatchToken] = DispatchCallback<T>(actionType: actionType, handler: handler)
        return nextDispatchToken
    }

    /// Removes a callback based on its token.
    public func unregister(token: String) {
        precondition(self.callbacks[token] != nil, "Dispatcher.unregister(...): \(token) does not map to a registered callback.")

        self.callbacks.removeValueForKey(token)
    }

    /// Waits for the callbacks specified to be invoked before continuing execution
    /// of the current callback. This method should only be used by a callback in
    /// response to a dispatched payload.
    public func waitFor<T: Action>(tokens: [String], action: T) {
        precondition(self.isDispatching, "Dispatcher.waitFor(...): Must be invoked while dispatching.")

        for token in tokens {
            if let callback = self.callbacks[token] as? DispatchCallback<T> {
                switch callback.status {
                case .Handled:
                    continue

                case .Pending:
                    fatalError("Dispatcher.waitFor(...): Circular dependency detected while waiting for \(token)")

                case .Waiting:
                    self.invokeCallback(token, action: action)
                }

            } else {
                fatalError("Dispatcher.waitFor(...): \(token) does not map to a registered callback.")
            }
        }
    }
    
    /// Dispatches a payload to all registered callbacks.
    public func dispatch<T: Action>(action: T) {
        precondition(!self.isDispatching, "Dispatch.dispatch(...): Cannot dispatch in the middle of a dispatch.")
        
        startDispatching(action)
        
        for (id, _) in self.callbacks {
            if let pending = self.isPending[id] {
                if pending {
                    continue                    
                }
            }

            self.invokeCallback(id, action: action)
        }

        stopDispatching()
    }

    /// Set up bookkeeping needed when dispatching.
    private func startDispatching(action: Action) {
        for (id, _) in self.callbacks {
            self.isPending[id] = false
            self.isHandled[id] = false
        }
        self.isDispatching = true
    }
    
    /// Clear bookkepping used for dispatching
    private func stopDispatching() {
        self.isDispatching = false
    }

    /// Call the callback stored with the given id. Also do some internal bookkeeping.
    private func invokeCallback<T: Action>(token: String, action: T) {
        if let callback = self.callbacks[token] as? DispatchCallback<T> {
            callback.status = .Pending
            callback.handler(action)
            callback.status = .Handled
        }
    }
}

internal class DispatchCallback<T: Action> {
    let actionType: T.Type
    let handler: (T) -> Void
    var status: DispatchStatus = DispatchStatus.Waiting
    
    init(actionType: T.Type, handler: (T) -> Void) {
        self.actionType = actionType
        self.handler = handler
    }
}

internal enum DispatchStatus {
    case Waiting
    case Pending
    case Handled
}