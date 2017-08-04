//
//  ViewController.swift
//  TodoAppWithSettings
//
//  Created by Omar Abdelhafith on 03/08/2017.
//  Copyright © 2017 Omar Abdelhafith. All rights reserved.
//

import UIKit


class TodoViewController: UIViewController {
  @IBOutlet weak var todoTextField: UITextField!
  @IBOutlet weak var todoItemsTextView: UITextView!

  override func viewDidLoad() {

    let subscription = store.addListener(stateSelector: todoListControllorStateSelector) { [weak self] state in
      self?.todoItemsTextView.text = state.todoString
      self?.todoItemsTextView.textColor = state.textColor
      self?.todoItemsTextView.backgroundColor = state.backgroundColor
    }

    // Alternatively, we can add a listener to the full state
    /*
     let subscription = store.addListener { [weak self] state in

       if let todoList = state.value(forKeyOfType: TodoList.self),
       let settings = state.value(forKeyOfType: TodoSettings.self) {
         self?.todoItemsTextView.text = todoList.todos.joined(separator: "\n")
         self?.todoItemsTextView.textColor = settings.textColor
         self?.todoItemsTextView.backgroundColor = settings.backgroundColor
       }
     }
     */

    subscription.linkLifeCycleTo(object: self)
  }

  @IBAction func addTapped(_ sender: Any) {
    store.dispatch(action: AddTodoAction(content: todoTextField.text ?? ""))
    todoTextField.text = ""
  }
}


class SettingsViewController: UIViewController {

  @IBOutlet weak var backgroundColorView: UIView!
  @IBOutlet weak var textColorView: UIView!

  override func viewDidLoad() {
    super.viewDidLoad()
    
    let subscription = store.addListener(forStateType: TodoSettings.self) { [weak self] state in
      self?.backgroundColorView.backgroundColor = state.backgroundColor
      self?.textColorView.backgroundColor = state.textColor
    }

    subscription.linkLifeCycleTo(object: self)
    subscription.informWithCurrentState()
  }

  @IBAction func redBackgroundColor(_ sender: Any) {
    store.dispatch(action: ChangeBackgroundColorAction(color: UIColor.red))
  }

  @IBAction func blueBackgroundColor(_ sender: Any) {
    store.dispatch(action: ChangeBackgroundColorAction(color: UIColor.blue))
  }

  @IBAction func purpleBackgroundColor(_ sender: Any) {
    store.dispatch(action: ChangeBackgroundColorAction(color: UIColor.purple))
  }

  @IBAction func yellowBackgroundColor(_ sender: Any) {
    store.dispatch(action: ChangeBackgroundColorAction(color: UIColor.yellow))
  }

  @IBAction func redTextColor(_ sender: Any) {
    store.dispatch(action: ChangeTextColorAction(color: UIColor.red))
  }

  @IBAction func blueTextColor(_ sender: Any) {
    store.dispatch(action: ChangeTextColorAction(color: UIColor.blue))
  }

  @IBAction func purpleTextColor(_ sender: Any) {
    store.dispatch(action: ChangeTextColorAction(color: UIColor.purple))
  }

  @IBAction func yellowTextColor(_ sender: Any) {
    store.dispatch(action: ChangeTextColorAction(color: UIColor.yellow))
  }
}
