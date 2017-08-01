//
//  Actions.swift
//  Suas-iOS-SampleApp
//
//  Created by Omar Abdelhafith on 20/07/2017.
//  Copyright © 2017 Omar Abdelhafith. All rights reserved.
//

import Foundation
import Suas
import SuasMonitorMiddleware

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


#if swift(>=4.0)
  // In swift 4 there is no need to implement `SuasEncodable` as `SuasEncodable` already implements `Encodable`
  //
  // Just implement `SuasEncodable` and thats it, your types are ready to be sent to Suas monitor!
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
