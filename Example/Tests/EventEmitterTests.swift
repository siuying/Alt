//
//  EventEmitterTests.swift
//  Alt
//
//  Created by Chan Fai Chong on 8/11/2015.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import XCTest
import Nimble
import Alt

class EventEmitterTests: XCTestCase {
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testAddListener() {
        let eventType = "someEvent"
        let emitter = EventEmitter()
        expect(emitter.listeners(eventType).count).to(equal(0))
        
        var calledListener = false
        emitter.addListener(eventType) { (object) -> () in
            calledListener = true
        }
        expect(emitter.listeners(eventType).count).to(equal(1))

        emitter.emit(eventType)
        expect(calledListener).toEventually(beTrue())
    }
    
    func testRemoveListener() {
        let eventType = "someEvent"
        let emitter = EventEmitter()
        expect(emitter.listeners(eventType).count).to(equal(0))
        emitter.addListener(eventType) { (object) -> () in }
        expect(emitter.listeners(eventType).count).to(equal(1))
        
        emitter.removeAllListeners(eventType)
        expect(emitter.listeners(eventType).count).to(equal(0))
    }
    
    func testOnce() {
        let eventType = "someEvent"
        let emitter = EventEmitter()
        expect(emitter.listeners(eventType).count).to(equal(0))
        
        var calledListener = false
        emitter.once(eventType) { (object) -> () in
            calledListener = true
        }
        expect(emitter.listeners(eventType).count).to(equal(1))
        
        emitter.emit(eventType)
        expect(calledListener).toEventually(beTrue())
        expect(emitter.listeners(eventType).count).toEventually(equal(0))
    }
    
    func testListeners() {
        let eventType = "someEvent1"
        let emitter = EventEmitter()
        expect(emitter.listeners(eventType).count).to(equal(0))

        emitter.addListener(eventType) { (object) -> () in }
        expect(emitter.listeners(eventType).count).to(equal(1))

        emitter.addListener(eventType) { (object) -> () in }
        expect(emitter.listeners(eventType).count).to(equal(2))

        let eventType2 = "someEvent2"
        expect(emitter.listeners(eventType2).count).to(equal(0))
    }
    
    func testEmit() {
        let eventType = "someEvent1"
        let emitter = EventEmitter()
        var result : AnyObject?
        emitter.addListener(eventType) { (object) -> () in
            result = object
        }
        
        emitter.emit(eventType, object: 1)
        expect(result as? Int).toEventually(equal(1))
    }
    
    func testRemoveCurrentListener() {
        let eventType = "someEvent1"
        let emitter = EventEmitter()
        emitter.addListener(eventType) { [weak emitter] (object) -> () in
            emitter?.removeCurrentListener()
        }
        expect(emitter.listeners(eventType).count).to(equal(1))
        
        emitter.emit(eventType, object: 1)
        expect(emitter.listeners(eventType).count).toEventually(equal(0))
        
    }
    
    
    func testRemoveWithSubscription() {
        let eventType = "someEvent1"
        let emitter = EventEmitter()
        let sub = emitter.addListener(eventType) { [weak emitter] (object) -> () in
            emitter?.removeCurrentListener()
        }
        expect(emitter.listeners(eventType).count).to(equal(1))
        
        emitter.removeListenerWithSubscription(sub)
        expect(emitter.listeners(eventType).count).toEventually(equal(0))
        
    }
}
