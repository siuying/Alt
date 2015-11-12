//
//  AltTests.swift
//  Alt
//
//  Created by Chan Fai Chong on 12/11/2015.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import XCTest
import Alt
import Nimble

struct AltTestsActions {
    struct Increment : Action {
        let value : Int
    }
}

struct AltTestsStoreState {
    var count = -1
}

class AltTestsStore : Store {
    typealias State = AltTestsStoreState
    var state : State!

    required init() {
    }

    static func getInitialState() -> State {
        return AltTestsStoreState(count: 0)
    }
}

class AltTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetStore() {
        let store = Alt.getStore(AltTestsStore.self)
        let store2 = Alt.getStore(AltTestsStore.self)
        expect(store === store2).to(beTrue(), description: "be a singleton")
        
        expect(store.state.count).to(equal(MyStore.getInitialState().count), description: "state should set to initial state")
    }
}
