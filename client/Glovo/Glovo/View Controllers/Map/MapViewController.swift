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
import RxSwift

final class MapViewController: BaseViewController {
  private var mapView: GMSMapView!
  private var camera: GMSCameraPosition!
  private var myMarker: GMSMarker!
  
  private let viewModel = MapViewModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    mapView = GMSMapView(frame: .zero)
    mapView.isMyLocationEnabled = true
    
    view.addSubview(mapView)
    
    mapView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    viewModel.getCities()
    .observeOn(MainScheduler.instance)
      .subscribe(onSuccess: { [weak self] cities in
        guard let `self` = self, let cities = cities else { return }
        
        for city in cities {
          let fillColor = UIColor().randomColor().withAlphaComponent(Style.POLYGON_ALPHA)
          
          for workingArea in city.workingAreas {
            let path = GMSPath(fromEncodedPath: workingArea)
            
            let polygon = GMSPolygon(path: path)
            polygon.map = self.mapView
            polygon.fillColor = fillColor
          }
        }
      }).disposed(by: disposeBag)
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
