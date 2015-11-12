//
//  TodoStore.swift
//  Alt
//
//  Created by Chan Fai Chong on 8/11/2015.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import Foundation
import Alt

class TodoStore : Store {
    typealias State = [Todo]
    
    var state : State!
    
    required init() {
        self.bindAction(TodoActions.Create.self, handler: self.onCreate)
        self.bindAction(TodoActions.List.self, handler: self.onList)
    }

    private func onCreate(action: TodoActions.Create) {
        self.state.append(Todo(title: action.title))
        self.emitChange()
    }
    
    private func onList(action: TodoActions.List) {
        self.state = action.todos
        self.emitChange()
    }
    
    // MARK: Store

    static func getInitState() -> State {
        return []
    }
}