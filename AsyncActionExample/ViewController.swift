//
//  ViewController.swift
//  AsyncActionExample
//
//  Created by Omar Abdelhafith on 31/07/2017.
//  Copyright © 2017 Omar Abdelhafith. All rights reserved.
//

import UIKit
import Suas


//: ## First: We define our State.
struct SearchCities {
  var cities: [String]
}


//: ## Second: Define the action
struct FetchCityAsyncAction: AsyncAction {
  var executionBlock: (MiddlewareAPI) -> ()

  init(query: String) {
    executionBlock = { api in
      let url = URL(string: "https://autocomplete.wunderground.com/aq?query=\(query)")!
      URLSession(configuration: .default).dataTask(with: url) { data, response, error in
        let resp = try! JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
        let result = resp["RESULTS"] as! [[String: Any]]

        let cities = result.map({ $0["name"] as! String })
        api.dispatch(CitiesFetchedAction(cities: cities))
        }.resume()
    }
  }
}

struct CitiesFetchedAction: Action {
  let cities: [String]
}

//: ## Third: Define the reducer
struct SearchCitiesReducer: Reducer {
  var initialState = SearchCities(cities: [])

  func reduce(action: Action, state: SearchCities) -> SearchCities? {

    // Handle each action
    if let action = action as? CitiesFetchedAction {
      return SearchCities(cities: action.cities)
    }

    // Important: If action does not affec the state, return nil
    return nil
  }
}

//: ## Fourth: Create a store
let store = Suas.createStore(reducer: SearchCitiesReducer(), middleware: AsyncMiddleware())

class ViewController: UIViewController {

  @IBOutlet weak var resultTextView: UITextView!

  @IBAction func textChanged(_ sender: Any) {
    let textField = sender as! UITextField
    store.dispatch(action: FetchCityAsyncAction(query: textField.text ?? ""))

    store.addListener(withId: "1", stateKey: "SearchCities", type: SearchCities.self, if: { (old, new) in return true }, callback: { state in

    })

    store.addListener(withId: "1", stateKey: "SearchCities", type: SearchCities.self, callback: { state in

    })
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    //: ## Finally: Use the store

    //: Add a listener to the store
    store.addListener(withId: "1", type: SearchCities.self)  { state in
      self.resultTextView.text = state.cities.joined(separator: "\n")
    }
  }
}
