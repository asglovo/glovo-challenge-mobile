//
//  LocationManager.swift
//  Take It
//
//  Created by Anıl Sözeri on 11/08/2017.
//  Copyright © 2017 Anıl Sözeri. All rights reserved.
//

import Foundation
import CoreLocation
import RxSwift

final class LocationManager: NSObject {
  static let shared = LocationManager()
  
  private let locationManager = CLLocationManager()
  
  let coordinate: PublishSubject<CLLocationCoordinate2D>
  let authorizationDenied: PublishSubject<Void>
  
  fileprivate(set) var currentLocation = CLLocation()
  
  override private init() {
    coordinate = PublishSubject<CLLocationCoordinate2D>()
    authorizationDenied = PublishSubject<Void>()
    
    super.init()
    
    locationManager.delegate = self
    locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
  }
  
  func askPermissionForUsingLocationInformation() {
    if CLLocationManager.authorizationStatus() == .notDetermined {
      locationManager.requestAlwaysAuthorization()
    }
    // 2. authorization were denied
    else if CLLocationManager.authorizationStatus() == .denied {
      print("Location services were previously denied. Please enable location services for this app in Settings.")
      authorizationDenied.onNext(())
    }
    // 3. we do have authorization
    else if CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
      locationManager.startUpdatingLocation()
    }
  }
}

extension LocationManager: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.last else { return }
    
    currentLocation = location
    coordinate.onNext(location.coordinate)
  }
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    switch status {
    case .authorizedAlways, .authorizedWhenInUse:
      manager.startUpdatingLocation()
    default:
      authorizationDenied.onNext(())
    }
  }
}
