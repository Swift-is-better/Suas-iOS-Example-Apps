//
//  ViewController.swift
//  AsyncActionExample
//
//  Created by Omar Abdelhafith on 31/07/2017.
//  Copyright © 2017 Omar Abdelhafith. All rights reserved.
//

import UIKit
import Suas


// First: We define our State.
struct SearchCities {
  var cities: [String]
}


// Second: Define the action
// This async action can be also performed with URLSessionAsyncAction provided from Suas
struct FetchCityAsyncAction: AsyncAction {
  let query: String

  init(query: String) {
    self.query = query
  }

  func execute(getState: @escaping GetStateFunction, dispatch: @escaping DispatchFunction) {
    let url = URL(string: "https://autocomplete.wunderground.com/aq?query=\(query)")!
    // Perform async request
    URLSession(configuration: .default).dataTask(with: url) { data, response, error in

      // When async request is done, dispatch actions
      let resp = try! JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
      let result = resp["RESULTS"] as! [[String: Any]]

      let cities = result.map({ $0["name"] as! String })

      // Dispatch action with parsed data
      dispatch(CitiesFetchedAction(cities: cities))
    }.resume()
  }
}

struct CitiesFetchedAction: Action {
  let cities: [String]
}

// Third: Define the reducer
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

// Fourth: Create a store
// Notice we are using `AsyncMiddleware`
let store = Suas.createStore(reducer: SearchCitiesReducer(),
                             middleware: AsyncMiddleware())

class ViewController: UIViewController {

  @IBOutlet weak var resultTextView: UITextView!
  var listenerSubscription: Subscription<SearchCities>?

  @IBAction func textChanged(_ sender: Any) {
    let textField = sender as! UITextField

    // Dispatch the async action. This action will be intercepted and executed in the AsyncMiddleware
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
    // Fifth: Use the store

    // Add a listener to the store
    // We are using `stateChangedFilter` which will ensure the listener will be notified if the state with type `SearchCities` is changed
    listenerSubscription = store.addListener(forStateType: SearchCities.self,
                      if: stateChangedFilter)  { [weak self] state in
      // Update UI
      self?.resultTextView.text = state.cities.joined(separator: "\n")
    }
  }

  deinit {
    // Remove the listener
    listenerSubscription?.removeListener()
  }
}
