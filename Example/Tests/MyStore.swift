//
//  MyStore.swift
//  Alt
//
//  Created by Chan Fai Chong on 12/11/2015.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import Foundation
import Alt

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