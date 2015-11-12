//
//  AltTests.swift
//  Alt
//
//  Created by Chan Fai Chong on 12/11/2015.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import XCTest
import Alt

struct MyStoreState {
}

class MyStore : Store {
    typealias State = MyStoreState
    var state : State!
    
    required init() {

    }
    
    static func getInitState() -> State {
        return MyStoreState()
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

    func testRegisterAndGetStore() {
        
    }

}
