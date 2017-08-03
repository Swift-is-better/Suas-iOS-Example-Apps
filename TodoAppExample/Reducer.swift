//
//  Reducer.swift
//  Suas-iOS-SampleApp
//
//  Created by Omar Abdelhafith on 20/07/2017.
//  Copyright © 2017 Omar Abdelhafith. All rights reserved.
//

import Foundation
import Suas

struct TodoSettings {
  var backgroundColor: UIColor
  var textColor: UIColor
}

struct TodoReducer: Reducer {
  var initialState = TodoList(todos: [])
  
  func reduce(state: TodoList, action: Action) -> TodoList? {

    if let action = action as? AddTodo {
      var newState = state
      newState.todos = newState.todos + [TodoItem(title: action.text, isCompleted: false)]
      return newState
    }

    if let action = action as? RemoveTodo {
      var newState = state
      newState.todos.remove(at: action.index)
      return newState
    }

    if let action = action as? MoveTodo {
      var newState = state
      let element = newState.todos.remove(at: action.from)
      newState.todos.insert(element, at: action.to)
      return newState
    }

    if let action = action as? ToggleTodo {
      var newState = state
      var post = newState.todos[action.index]
      post.isCompleted = !post.isCompleted
      newState.todos[action.index] = post
      return newState
    }

    return nil
  }

}


// Alternatively we can define the reducer using the `BlockReducer` struct
// This is helpful when we want to define a reducer inline
//
//let todoReducer = BlockReducer(state: TodoList(todos:[])) { action, state in
//  if let action = action as? AddTodo {
//    var newState = state
//    newState.todos = newState.todos + [TodoItem(title: action.text, isCompleted: false)]
//    return newState
//  }
//
//  if let action = action as? RemoveTodo {
//    var newState = state
//    newState.todos.remove(at: action.index)
//    return newState
//  }
//
//  if let action = action as? MoveTodo {
//    var newState = state
//    let element = newState.todos.remove(at: action.from)
//    newState.todos.insert(element, at: action.to)
//    return newState
//  }
//
//  if let action = action as? ToggleTodo {
//    var newState = state
//    var post = newState.todos[action.index]
//    post.isCompleted = !post.isCompleted
//    newState.todos[action.index] = post
//    return newState
//  }
//
//  return nil
//}

