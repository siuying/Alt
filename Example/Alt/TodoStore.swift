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

        self.bindAction(TodoActions.Create.self) { [weak self] (action) -> () in
            if let store = self {
                store.state.append(Todo(title: action.title))
            }
        }
        
        self.bindAction(TodoActions.List.self) { [weak self] (action) -> () in
            if let store = self {
                store.state = action.todos
            }
        }
    }
}