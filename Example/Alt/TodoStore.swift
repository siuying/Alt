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
    private var todos : [Todo] = []
    
    init() {
        super.init()

        self.bindAction(TodoActions.Create.self) { [weak self] (payload) -> () in
            self?.todos.append(Todo(title: payload.title))
        }
    }
}