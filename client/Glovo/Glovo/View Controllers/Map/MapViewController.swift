//
//  MapViewController.swift
//  Glovo
//
//  Created by Anıl Sözeri on 26.06.2018.
//  Copyright © 2018 Anıl Sözeri. All rights reserved.
//

import UIKit
import SnapKit
import GoogleMaps

final class MapViewController: BaseViewController {
  private var mapView: GMSMapView!
  private var camera: GMSCameraPosition!
  private var myMarker: GMSMarker!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    mapView = GMSMapView(frame: .zero)
    mapView.isMyLocationEnabled = true
    
    view.addSubview(mapView)
    
    mapView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    LocationManager.shared.askPermissionForUsingLocationInformation()
    
    LocationManager.shared.coordinate
      .take(1)
      .subscribe(onNext: { [weak self] coordinate in
        guard let `self` = self else { return }
        
        let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: ZOOM_RATE)
        self.mapView.camera = camera
        self.mapView.setMinZoom(MIN_ZOOM_RATE, maxZoom: MAX_ZOOM_RATE)
      }).disposed(by: disposeBag)
  }
}
