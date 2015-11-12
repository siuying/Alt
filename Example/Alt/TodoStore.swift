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

    static func getInitState() -> State {
        return [Todo(title: "Task 1"), Todo(title: "Task 2"), Todo(title: "Task 3")]
    }

    required init() {
        self.bindAction(TodoActions.Create.self, handler: self.onCreate)
    }

    private func onCreate(action: TodoActions.Create) {
        self.state.append(Todo(title: action.title))
        self.emitChange()
    }
}