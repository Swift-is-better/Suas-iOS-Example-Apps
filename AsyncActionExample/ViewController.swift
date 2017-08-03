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
  let query: String

  init(query: String) {
    self.query = query
  }

  func onAction(getState: @escaping GetStateFunction, dispatch: @escaping DispatchFunction) {
    let url = URL(string: "https://autocomplete.wunderground.com/aq?query=\(query)")!
    URLSession(configuration: .default).dataTask(with: url) { data, response, error in
      let resp = try! JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
      let result = resp["RESULTS"] as! [[String: Any]]

      let cities = result.map({ $0["name"] as! String })
      dispatch(CitiesFetchedAction(cities: cities))
    }.resume()
  }
}

struct CitiesFetchedAction: Action {
  let cities: [String]
}

//: ## Third: Define the reducer
struct SearchCitiesReducer: Reducer {
  var initialState = SearchCities(cities: [])

  func reduce(state: SearchCities, action: Action) -> SearchCities? {

    // Handle each action
    if let action = action as? CitiesFetchedAction {
      return SearchCities(cities: action.cities)
    }

    // Important: If action does not affec the state, return nil
    return nil
  }
}

//: ## Fourth: Create a store
let store = Suas.createStore(reducer: SearchCitiesReducer(),
                             middleware: AsyncMiddleware())

class ViewController: UIViewController {

  @IBOutlet weak var resultTextView: UITextView!
  var listenerSubscription: Subscription<SearchCities>?

  @IBAction func textChanged(_ sender: Any) {
    let textField = sender as! UITextField

    store.dispatch(action: FetchCityAsyncAction(query: textField.text ?? ""))

    // Alternatively, you can use `URLSessionAsyncAction` to perform an async URLSession Action
    /*
    let url = URL(string: "https://autocomplete.wunderground.com/aq?query=\(textField.text ?? "")")!
    let action = URLSessionAsyncAction(url: url) { data, _, _, dispatch in
      let resp = try! JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
      let result = resp["RESULTS"] as! [[String: Any]]
    
      let cities = result.map({ $0["name"] as! String })
      dispatch(CitiesFetchedAction(cities: cities))
    }
    
    store.dispatch(action: action)
    */

  }

  override func viewDidLoad() {
    super.viewDidLoad()
    //: ## Fifth: Use the store

    //: Add a listener to the store
    listenerSubscription = store.addListener(forStateType: SearchCities.self,
                      if: stateChangedFilter)  { state in
      self.resultTextView.text = state.cities.joined(separator: "\n")
    }
  }

  deinit {
    //: ## Finally: Use the store
    // Remove the listener
    listenerSubscription?.removeListener()
  }
}
