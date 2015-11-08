//
//  TodoStore.swift
//  Alt
//
//  Created by Chan Fai Chong on 8/11/2015.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import Foundation
import Alt

class TodoStore : Store<[Todo]> {
    init(state: [Todo]) {
        super.init(state: state)

        self.bindAction(TodoActions.Create.self, handler: self.onCreate)
        self.bindAction(TodoActions.List.self, handler: self.onList)
        
        self.bindAction(TodoActions.Create.self) { [weak self] (action) -> () in
            self?.state.append(Todo(title: action.title))
        }
    }

    private func onCreate(action: TodoActions.Create) {
        self.state.append(Todo(title: action.title))
    }
    
    private func onList(action: TodoActions.List) {
        self.state = action.todos
    }
}