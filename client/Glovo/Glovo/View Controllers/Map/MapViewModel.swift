//
//  MapViewModel.swift
//  Glovo
//
//  Created by Anıl Sözeri on 26.06.2018.
//  Copyright © 2018 Anıl Sözeri. All rights reserved.
//

import Foundation
import RxSwift
import GoogleMaps

final class MapViewModel: BaseViewModel {
  private let service: GlovoAPIServiceType
  private let countries: Variable<[Country]>
  private var cities: Variable<[City]>
  
  init(service: GlovoAPIServiceType = GlovoAPIService()) {
    self.service = service
    
    countries = Variable<[Country]>([])
    cities = Variable<[City]>([])
    
    super.init()
    
    getCountries()
  }
  
  func getCountries() {
    service.getCountries()
      .subscribe(onSuccess: { [weak self] countries in
        guard let `self` = self, let countries = countries else { return }
        
        self.countries.value = countries
      }).disposed(by: disposeBag)
  }
  
  func getCities() -> Single<[City]?> {
    return service.getCities()
      .do(onSuccess: { [weak self] cities in
        guard let `self` = self, let cities = cities else { return }
        
        self.cities.value = cities
      })
  }
}
