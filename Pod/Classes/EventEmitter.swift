//
//  EventEmitter.swift
//  Pods
//
//  Created by Chan Fai Chong on 8/11/2015.
//
//

import Foundation

public class EventEmitter {
    typealias Listener = (object: AnyObject?) -> ()

    let subscriber : EventSubscriptionVendor
    var currentSubscription : EventSubscription?

    init() {
        self.subscriber = EventSubscriptionVendor()
    }

    /// Adds a listener to be invoked when events of the specified type are
    /// emitted. An optional calling context may be provided. The data arguments
    /// emitted will be passed to the listener function.
    func addListener(eventType: String, listener: Listener, context: AnyObject?) -> EventSubscription {
        return self.subscriber.addSubscription(eventType, subscription: EventSubscription(subscriber: self.subscriber, listener: listener, context: context))
    }

    /// Similar to addListener, except that the listener is removed after it is invoked once.
    func once(eventType: String, listener: Listener, context: AnyObject?) -> EventSubscription {
        let internalListener : Listener = { [weak self] object in
            self?.removeCurrentListener()
            listener(object: object)
        }
        return self.subscriber.addSubscription(eventType, subscription: EventSubscription(subscriber: self.subscriber, listener: internalListener, context: context))
    }

    /// Removes all of the registered listeners, including those registered as
    /// listener maps.
    func removeAllListeners(eventType: String?) {
        self.subscriber.removeAllSubscriptions(eventType)
    }

    /// Provides an API that can be called during an eventing cycle to remove the
    /// last listener that was invoked. This allows a developer to provide an event
    /// object that can remove the listener (or listener map) during the
    /// invocation.
    func removeCurrentListener() {
        guard let currentSubscription = self.currentSubscription else {
            fatalError("Not in an emitting cycle; there is no current subscription")
        }
        self.subscriber.removeSubscription(currentSubscription)
    }
    
    func listeners(eventType: String) -> [Listener] {
        let subscriptions = self.subscriber.getSubscriptionForType(eventType)
        return subscriptions.map({ $0.listener })
    }
    
    func emit(eventType: String, object: AnyObject?) {
        let subscriptions = self.subscriber.getSubscriptionForType(eventType)
        for subscription in subscriptions {
            self.currentSubscription = subscription
        }
        self.currentSubscription = nil
    }
    
    private func emitToSubscription(subscription: EventSubscription, object: AnyObject? = nil) {
        subscription.listener(object: object)
    }
}

internal class EventSubscription {
    weak var context : AnyObject?
    weak var subscriber : EventSubscriptionVendor?
    let listener : EventEmitter.Listener
    var eventType : String?
    var key : Int?

    init(subscriber: EventSubscriptionVendor, listener: EventEmitter.Listener, context: AnyObject?) {
        self.subscriber = subscriber
        self.listener = listener
        self.context = context
    }

    func remove() {
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