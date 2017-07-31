//
//  State.swift
//  Suas-iOS-SampleApp
//
//  Created by Omar Abdelhafith on 20/07/2017.
//  Copyright © 2017 Omar Abdelhafith. All rights reserved.
//

import Foundation
import SuasMonitorMiddleware

#if swift(>=4.0)
  // In swift 4 there is no need to implement `SuasEncodable` as `SuasEncodable` already implements `Encodable`
  struct TodoItem: SuasEncodable {
    var title: String
    var isCompleted: Bool
  }

  struct TodoList: SuasEncodable {
    var todos: [TodoItem]
  }

#else

  struct TodoItem: SuasEncodable {
    var title: String
    var isCompleted: Bool

    func toDictionary() -> [String : Any] {
      return [
        "title": title,
        "isCompleted": isCompleted
      ]
    }
  }

  struct TodoList: SuasEncodable {
    var todos: [TodoItem]

    func toDictionary() -> [String : Any] {
      return [
        "todos": todos.map({ $0.toDictionary() })
      ]
    }
  }

#endif
