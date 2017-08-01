//
//  State.swift
//  Suas-iOS-SampleApp
//
//  Created by Omar Abdelhafith on 20/07/2017.
//  Copyright © 2017 Omar Abdelhafith. All rights reserved.
//

import Foundation
import SuasMonitorMiddleware

struct TodoItem: SuasEncodable {
  var title: String
  var isCompleted: Bool
}

struct TodoList: SuasEncodable {
  var todos: [TodoItem]
}

#if swift(>=4.0)
  // In swift 4 there is no need to implement `SuasEncodable` as `SuasEncodable` already implements `Encodable`
  //
  // Just implement `SuasEncodable` and thats it, your types are ready to be sent to Suas monitor!
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
