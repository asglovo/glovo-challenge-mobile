//
//  AppDelegate.swift
//  Glovo
//
//  Created by Anıl Sözeri on 26.06.2018.
//  Copyright © 2018 Anıl Sözeri. All rights reserved.
//

import UIKit
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // Setup Google Maps
    GMSServices.provideAPIKey(Config.googleMapsAPIKey)
    
    return true
  }
}
