//
//  ViewController.swift
//  Suas-iOS-SampleApp
//
//  Created by Omar Abdelhafith on 18/07/2017.
//  Copyright © 2017 Omar Abdelhafith. All rights reserved.
//

import UIKit
import Suas

class ViewController: UIViewController {

  @IBOutlet weak var todoTextField: UITextField!
  @IBOutlet weak var addTodoButton: UIButton!
  @IBOutlet weak var todoTableView: UITableView!

  var state: TodoList = TodoReducer().initialState {
    didSet {
      todoTableView.reloadData()
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    store.addListener(type: TodoList.self) { newState in
      self.state = newState
    }.linkLifeCycleTo(object: self)
  }

  @IBAction func addTodoTapped(_ sender: Any) {
    store.dispatch(action: AddTodo(text: todoTextField.text ?? ""))
    todoTextField.text = ""
  }

  @IBAction func editTapped(_ sender: Any) {
    todoTableView.isEditing = !todoTableView.isEditing
  }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: .default, reuseIdentifier: nil)

    let post = state.todos[indexPath.row]
    cell.textLabel?.text = post.title
    cell.textLabel?.textColor = post.isCompleted ? UIColor.gray : UIColor.black

    return cell
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return state.todos.count
  }

  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    store.dispatch(action: RemoveTodo(index: indexPath.row))
  }

  func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    store.dispatch(action: MoveTodo(from: sourceIndexPath.row, to: destinationIndexPath.row))
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    store.dispatch(action: ToggleTodo(index: indexPath.row))
  }

  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }

  func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
    return true
  }
}
