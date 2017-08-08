//
//  ViewController.swift
//  CounterExample
//
//  Created by Omar Abdelhafith on 31/07/2017.
//  Copyright © 2017 Omar Abdelhafith. All rights reserved.
//

import UIKit
import Suas

// First: We define our State.
// The state can be any type:
// - It can be a simple type as Int, Float, Double, etc...
// - It can be a struct or a class. Most often a struct will be used to represent a state
struct Counter {
  var value: Int
}


// Second: Define the action
// Action we will dispatch when we want to increment the value of the counter
struct IncrementAction: Action {
  let incrementValue: Int
}

// Action we will dispatch when we want to decrement the value of the counter
struct DecrementAction: Action {
  let decrementValue: Int
}

// Third: Define the reducer
// The reducer defines two things:
// 1. It define the inital value for a particular state.
// In this example it defines the value of the counter
// 2. It defines a reduce function. This function takes the action (increment/decrement)
// and the current state and it returns a new state.
// -----
// PS: for unknown actions the reducer returns nil. Signifing that the state did not change
// PPS: You can define a reducer in 2 ways. `BlockReducer` to define a reducer inline.
// Or by implementing the `Reducer` protocol.
let counterReducer = BlockReducer(initialState: Counter(value: 0)) { state, action in
  
  // Handle each action
  if let action = action as? IncrementAction {
    var newState = state
    newState.value += action.incrementValue
    return newState
  }
  
  if let action = action as? DecrementAction {
    var newState = state
    newState.value -= action.decrementValue
    return newState
  }
  
  // Important: If action does not affec the state, return ni
  return nil
}

// Fourth: Create a store
// The store is the main item you will be dealing with in your application
let store = Suas.createStore(reducer: counterReducer, middleware: LoggerMiddleware())

class ViewController: UIViewController {
  @IBOutlet weak var counterLabel: UILabel!

  override func viewDidLoad() {
    super.viewDidLoad()
    // Finally: Use the store
    
    self.counterLabel.text = "\(store.state.value(forKeyOfType: Counter.self)!.value)"
    
    // Add a listener to the store
    // Notice the [weak self] so we dont leak listeners
    let subscription = store.addListener(forStateType: Counter.self)  { [weak self] state in
      self?.counterLabel.text = "\(state.value)"
    }

    // When this object is deallocated, the listener will be removed
    // Alternatively, you have to delete it by hand `subscription.removeListener()`
    subscription.linkLifeCycleTo(object: self)
  }

  @IBAction func incrementTapped(_ sender: Any) {
    // Dispatch actions to the store
    store.dispatch(action: IncrementAction(incrementValue: 1))
  }

  @IBAction func decrementTapped(_ sender: Any) {
    // Dispatch actions to the store
    store.dispatch(action: DecrementAction(decrementValue: 1))
  }
}

