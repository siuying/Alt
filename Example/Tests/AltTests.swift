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
        let store = Alt.getStore(MyStore.self)
        let store2 = Alt.getStore(MyStore.self)
        expect(store === store2).to(beTrue(), description: "be a singleton")
    }
}
