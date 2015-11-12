//
//  StoreTests.swift
//  Alt
//
//  Created by Chan Fai Chong on 12/11/2015.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import XCTest
import Alt
import Nimble

struct MyActions {
    struct Increment : Action {
        let value : Int
    }
}

struct MyStoreState {
    var count = 0
}

class MyStore : Store {
    typealias State = MyStoreState
    var state : State!
    
    required init() {
        bindAction(MyActions.Increment.self) { (action) -> () in
            self.state.count += action.value
            self.emitChange()
        }
    }
    
    static func getInitState() -> State {
        return MyStoreState(count: 0)
    }
}

class StoreTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testStore() {
        let store = Alt.getStore(MyStore.self)
        var listenerCalled = 0
        store.listen { (state) -> () in
            expect(NSThread.isMainThread()).to(beTrue(), description: "listener should be called in main thread")
            listenerCalled++
        }
        
        expect(store.state.count).to(equal(0))
        
        MyActions.Increment(value: 1).dispatch()
        expect(store.state.count).toEventually(equal(1))

        MyActions.Increment(value: 2).dispatch()
        expect(store.state.count).toEventually(equal(3))

        expect(listenerCalled).to(equal(2), description: "listeners should be called exactly twice")
    }
}
