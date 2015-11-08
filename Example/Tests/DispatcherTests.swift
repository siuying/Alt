//
//  DispatcherTests.swift
//  Alt
//
//  Created by Chan Fai Chong on 8/11/2015.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import XCTest
import Alt
import Nimble

struct TestAction : Action {
    let title : String
}
struct TestAction2 : Action {
}

class DispatcherTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testRegister() {
        let dispatcher = Dispatcher()
        
        var result : String?
        dispatcher.register(TestAction.self) { (action) -> Void in
            result = action.title
        }

        dispatcher.dispatch(TestAction(title: "Hello"))
        expect(result).toEventually(equal("Hello"))
    }
    
    func testUnregister() {
        let dispatcher = Dispatcher()
        
        var finished = false
        let token = dispatcher.register(TestAction.self) { (action) -> Void in
            finished = true
        }
        dispatcher.unregister(token)

        dispatcher.dispatch(TestAction(title: "Hello"))
        expect(finished).toNotEventually(beTrue())
    }
    
    func testWaitFor() {
        let dispatcher = Dispatcher()
        
        var states : [Int] = []
        var state = 0

        let token1 = dispatcher.register(TestAction.self) { (action) -> Void in
            state = 1
            states.append(1)
        }

        let token2 = dispatcher.register(TestAction.self) { (action) -> Void in
            dispatcher.waitFor([token1], actionType: TestAction.self)
            state = 2
            states.append(2)
        }
        
        let _ = dispatcher.register(TestAction.self) { (action) -> Void in
            dispatcher.waitFor([token1, token2], actionType: TestAction.self)
            state = 3
            states.append(3)
        }

        // this is not invoked
        let _ = dispatcher.register(TestAction2.self) { (action) -> Void in
            dispatcher.waitFor([token1], actionType: TestAction2.self)
            state = 4
            states.append(4)
        }

        dispatcher.dispatch(TestAction(title: "Hello"))
        expect(state).toEventually(equal(3))
        expect(states).toEventually(equal([1,2,3]))
    }

}
