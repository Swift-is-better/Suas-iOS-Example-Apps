//
//  AppDelegate.swift
//  Suas-iOS-SampleApp
//
//  Created by Omar Abdelhafith on 18/07/2017.
//  Copyright © 2017 Zendesk. All rights reserved.
//

import UIKit
import Suas
import SuasMonitorMiddleware

let store = Suas.createStore(reducer: TodoReducer(),
                             middleware: MonitorMiddleware() + LoggerMiddleware())

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    return true
  }
}

