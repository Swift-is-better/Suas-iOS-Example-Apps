//
//  Actions.swift
//  Suas-iOS-SampleApp
//
//  Created by Omar Abdelhafith on 20/07/2017.
//  Copyright © 2017 Zendesk. All rights reserved.
//

import Foundation
import Suas
import SuasMonitorMiddleware

// Defining the actions
struct AddTodo: Action, SuasEncodable {
  let text: String
}

struct RemoveTodo: Action, SuasEncodable {
  let index: Int
}

struct MoveTodo: Action, SuasEncodable  {
  let from: Int
  let to: Int
}

struct ToggleTodo: Action, SuasEncodable {
  let index: Int
}


#if swift(>=3.2)
  // In swift 3.2 there is no need to implement `SuasEncodable``toDictionary`.
  // `SuasEncodable` already implements the `Encodable` protocol.
  //
  // Just implement `SuasEncodable` and thats it, no need to wrie any more code, your types are ready to be sent to Suas monitor!
#else
  extension AddTodo {
    func toDictionary() -> [String : Any] {
      return [
        "text": text
      ]
    }
  }

  extension RemoveTodo {
    func toDictionary() -> [String : Any] {
      return [
        "index": index
      ]
    }
  }

  extension MoveTodo {
    func toDictionary() -> [String : Any] {
      return [
        "from": from,
        "to": to
      ]
    }
  }

  extension ToggleTodo {
    func toDictionary() -> [String : Any] {
      return [
        "index": index
      ]
    }
  }
#endif
