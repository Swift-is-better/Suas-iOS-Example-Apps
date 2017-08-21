//
//  Common.swift
//  TodoAppWithSettingsExample
//
//  Created by Omar Abdelhafith on 03/08/2017.
//  Copyright © 2017 Zendesk. All rights reserved.
//

import UIKit
import Suas

// States
// Todo Items State
struct TodoList {
  var todos: [String]
}

// Todo Settings State
struct TodoSettings {
  var backgroundColor: UIColor
  var textColor: UIColor
}


// Todo list controller settings
struct TodoListControllerSettings {
  var backgroundColor: UIColor
  var textColor: UIColor
  var todoString: String
}

// StateSelector that selects and creates a TodoListControllerSettings from the store full state
let todoListControllorStateSelector: StateSelector<TodoListControllerSettings> = { state in
  // Get state values from the store
  guard
    let todoList = state.value(forKeyOfType: TodoList.self),
    let settings = state.value(forKeyOfType: TodoSettings.self) else {

      // If we can get any of them we return nil
      return nil
  }

  return TodoListControllerSettings(backgroundColor: settings.backgroundColor,
                                    textColor: settings.textColor,
                                    todoString: todoList.todos.joined(separator: "\n"))
}

// Actions

// Todo Items Settings
struct AddTodoAction: Action {
  let content: String
}


// Todo Settings Actions
struct ChangeTextColorAction: Action {
  let color: UIColor
}

struct ChangeBackgroundColorAction: Action {
  let color: UIColor
}

// Reducers

// Reduces todos actions and state only
struct TodoReducer: Reducer {
  var initialState = TodoList(todos: [])

  func reduce(state: TodoList, action: Action) -> TodoList? {
    // Handle todos actions only

    if let action = action as? AddTodoAction {
      // Add the todo item
      return TodoList(todos: state.todos + [action.content])
    }

    // nil if state is not changed
    return nil
  }
}

// Reduces settings actions and state only
struct SettingsReducer: Reducer {
  var initialState = TodoSettings(backgroundColor: .red, textColor: .white)

  func reduce(state: TodoSettings, action: Action) -> TodoSettings? {
    // Handle settings actions only


    if let action = action as? ChangeBackgroundColorAction {
      return TodoSettings(backgroundColor: action.color, textColor: state.textColor)
    }

    if let action = action as? ChangeTextColorAction {
      return TodoSettings(backgroundColor: state.backgroundColor, textColor: action.color)
    }

    // nil if state is not changed
    return nil
  }
}


// Store
let store = Suas.createStore(reducer: TodoReducer() + SettingsReducer())
