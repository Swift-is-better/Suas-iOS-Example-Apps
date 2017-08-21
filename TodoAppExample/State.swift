//
//  State.swift
//  Suas-iOS-SampleApp
//
//  Created by Omar Abdelhafith on 20/07/2017.
//  Copyright © 2017 Zendesk. All rights reserved.
//

import Foundation
import SuasMonitorMiddleware

// Define the state

struct TodoItem: SuasEncodable {
  var title: String
  var isCompleted: Bool
}

struct TodoList: SuasEncodable {
  var todos: [TodoItem]
}

#if swift(>=3.2)
  // In swift 3.2 there is no need to implement `SuasEncodable``toDictionary`.
  // `SuasEncodable` already implements the `Encodable` protocol.
  //
  // Just implement `SuasEncodable` and thats it, no need to wrie any more code, your types are ready to be sent to Suas monitor!
#else

  extension TodoItem {
    func toDictionary() -> [String : Any] {
      return [
        "title": title,
        "isCompleted": isCompleted
      ]
    }
  }

  extension TodoList {
    func toDictionary() -> [String : Any] {
      return [
        "todos": todos.map({ $0.toDictionary() })
      ]
    }
  }

#endif
