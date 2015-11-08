//
//  EventEmitter.swift
//  Pods
//
//  Created by Chan Fai Chong on 8/11/2015.
//
//

import Foundation

public class EventEmitter {
    public typealias Listener = (object: AnyObject?) -> ()

    let subscriber : EventSubscriptionVendor
    var currentSubscription : EventSubscription?

    public init() {
        self.subscriber = EventSubscriptionVendor()
    }

    /// Adds a listener to be invoked when events of the specified type are
    /// emitted. An optional calling context may be provided. The data arguments
    /// emitted will be passed to the listener function.
    public func addListener(eventType: String, listener: Listener) -> EventSubscription {
        return self.subscriber.addSubscription(eventType, subscription: EventSubscription(subscriber: self.subscriber, listener: listener))
    }

    /// Similar to addListener, except that the listener is removed after it is invoked once.
    public func once(eventType: String, listener: Listener) -> EventSubscription {
        let internalListener : Listener = { [weak self] object in
            self?.removeCurrentListener()
            listener(object: object)
        }
        return self.subscriber.addSubscription(eventType, subscription: EventSubscription(subscriber: self.subscriber, listener: internalListener))
    }

    /// Remove listener with the corresponding subscription
    public func removeListenerWithSubscription(subscription: EventSubscription) {
        self.subscriber.removeSubscription(subscription)
    }

    /// Removes all of the registered listeners, including those registered as
    /// listener maps.
    public func removeAllListeners(eventType: String?) {
        self.subscriber.removeAllSubscriptions(eventType)
    }

    /// Provides an API that can be called during an eventing cycle to remove the
    /// last listener that was invoked. This allows a developer to provide an event
    /// object that can remove the listener (or listener map) during the
    /// invocation.
    public func removeCurrentListener() {
        guard let currentSubscription = self.currentSubscription else {
            fatalError("Not in an emitting cycle; there is no current subscription")
        }
        self.subscriber.removeSubscription(currentSubscription)
    }
    
    /// Returns an array of listeners that are currently registered for the given event
    /// @param eventType Name of the event to query
    public func listeners(eventType: String) -> [Listener] {
        let subscriptions = self.subscriber.getSubscriptionForType(eventType)
        return subscriptions.map({ $0.listener })
    }
    
    /// Emits an event of the given type with the given data. All handlers of that
    /// particular type will be notified.
    public func emit(eventType: String, object: AnyObject? = nil) {
        let subscriptions = self.subscriber.getSubscriptionForType(eventType)
        for subscription in subscriptions {
            self.currentSubscription = subscription
            self.emitToSubscription(subscription, object: object)
        }
        self.currentSubscription = nil
    }
    
    private func emitToSubscription(subscription: EventSubscription, object: AnyObject? = nil) {
        subscription.listener(object: object)
    }
}

public class EventSubscription {
    weak var subscriber : EventSubscriptionVendor?
    
    public let listener : EventEmitter.Listener
    public var eventType : String?
    public var key : Int?
    
    init(subscriber: EventSubscriptionVendor, listener: EventEmitter.Listener) {
        self.subscriber = subscriber
        self.listener = listener
    }
    
    public func remove() {
        self.subscriber?.removeSubscription(self)
    }
}

internal class EventSubscriptionVendor {
    var subscriptionsForType : [String: [EventSubscription]] = [:]

    init() {
    }
    
    func addSubscription(type: String, subscription: EventSubscription) -> EventSubscription {
        if self.subscriptionsForType[type] == nil {
            self.subscriptionsForType[type] = []
        }
        let key = self.subscriptionsForType[type]!.count
        self.subscriptionsForType[type]!.append(subscription)
        subscription.eventType = type
        subscription.key = key
        return subscription
    }
    
    func removeSubscription(subscription: EventSubscription) {
        guard let eventType = subscription.eventType, let key = subscription.key else {
            fatalError("missing event type / key")
        }
        
        if self.subscriptionsForType[eventType] != nil {
            self.subscriptionsForType[eventType]?.removeAtIndex(key)
        }
    }
    
    func removeAllSubscriptions(type: String?) {
        if let type = type {
            self.subscriptionsForType.removeValueForKey(type)
        } else {
            self.subscriptionsForType = [:]
        }
    }

    func getSubscriptionForType(eventType: String) -> [EventSubscription] {
        return self.subscriptionsForType[eventType] ?? []
    }
}