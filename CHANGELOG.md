## 0.3.0

- Revised Store to be a protocol and extension, now any class can be a Store
- Store are now considered singleton, user of Store should get it using ``Alt.getStore(StoreType.self)``
- Instead of automatically call emitChange() on store, user of Store now responsible to call emitChange()

## 0.2.1

- Revised Store to be a NSObject subclass, such that it can implement Delegate methods

## 0.2.0

- Add a queue to run listeners

## 0.1.0

- init version