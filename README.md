# Alt

Another [Flux](https://facebook.github.io/flux/) implementation for Swift. It provides concept of "one-way data flow" with type-safe modules by Swift language.

## Usage

### Step 1: Define Action

- Create struct that implements protocol ``Action``.

```swift
struct TodoActions {
    struct Create : Action {
        let title : String
    }
}
```

### Step 2: Define Store and register action

- Create a Store class, which implement ``Store`` protocol with a ``typealiase State``
- Bind Actions to handers, where the model perform action tasks
- When the action has change model state, invoke ``self.emitChange()``

```swift
class TodoStore : Store<[Todo]> {
    init(state: [Todo]) {
        super.init(state: state)

        self.bindAction(TodoActions.Create.self, handler: self.onCreate)

        // alternatively, bind action with a block
        self.bindAction(TodoActions.Create.self) { [weak self] (action) -> () in
            self?.state.append(Todo(title: action.title))
        }
    }

    private func onCreate(action: TodoActions.Create) {
        self.state.append(Todo(title: action.title))
        self.emitChange()
    }
}
```

### Step 3: Listen store's event at View

- Register listeners to ``store.state`` change by ``Store.listen()``
- Force an store update by calling ``store.emitChange()``

```swift
self.todoStore.listen { (state) -> (Void) in
    self.tableView.reloadData()
}
```

### Step 4: Create and dispatch an Action

```swift
TodoActions.Create(title: "New ToDo").dispatch()
```

## Requirements

- Swift 2.0

## Installation

Alt is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "Alt"
```

## Author

Francis Chong, francis@ignition.hk

## License

Alt is available under the MIT license. See the LICENSE file for more info.