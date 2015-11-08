//
//  ViewController.swift
//  Alt
//
//  Created by Francis Chong on 11/08/2015.
//  Copyright (c) 2015 Francis Chong. All rights reserved.
//

import UIKit
import Alt

class ViewController: UITableViewController {
    let todoStore = TodoStore(state: [])

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.todoStore.listen { (state) -> (Void) in
            self.tableView.reloadData()
        }

        Alt.dispatch(TodoActions.List())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.todoStore.state.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TodoCell") as UITableViewCell!
        cell.textLabel!.text = self.todoStore.state[indexPath.row].title
        return cell
    }
    
    @IBAction func createTodo() {
        let count = self.todoStore.state.count
        Alt.dispatch(TodoActions.Create(title: "New ToDo \(count+1)"))
    }
}

