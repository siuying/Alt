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
    var todoStore : TodoStore!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.todoStore = Alt.getStore(TodoStore.self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if App.isTestTarget() {
            return
        }
        
        self.todoStore.listen { (state) -> (Void) in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()                
            })
        }
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
        TodoActions.Create(title: "New ToDo \(count+1)").dispatch()
    }
}

