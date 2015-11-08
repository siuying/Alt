//
//  TodoActions.swift
//  Alt
//
//  Created by Chan Fai Chong on 8/11/2015.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import Foundation
import Alt

struct TodoActions {
    struct List : Action {
        let todos = [Todo(title: "Task 1"), Todo(title: "Task 2"), Todo(title: "Task 3")]
    }

    struct Create : Action {
        let title : String
    }
}