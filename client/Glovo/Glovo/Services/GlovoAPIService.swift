//
//  GlovoAPIService.swift
//  Glovo
//
//  Created by Anıl Sözeri on 26.06.2018.
//  Copyright © 2018 Anıl Sözeri. All rights reserved.
//

import Foundation
import RxSwift
import RxAlamofire
import Alamofire

protocol GlovoAPIServiceType {
  func getCountries() -> Single<[Country]?>
  func getCities() -> Single<[City]?>
}

enum Endpoint: String {
  case countries
  case cities
  
  var url: URL {
    return URL(string: Config.baseURL + self.rawValue)!
  }
}

enum APIError: Int, Error {
  case unauthorized = 401
  case forbidden = 403
  case notFound = 404
  case notAcceptable = 406
  case noContent = 204
  case unknown = -1
}

final class GlovoAPIService: GlovoAPIServiceType {
  private let manager = HTTPManager.shared
  private let headers: [String: String] = ["Content-Type": "application/json"]
  private var encoding = JSONEncoding.default
  
  func getCountries() -> Single<[Country]?> {
    return request(method: .get, url: Endpoint.countries.url)
  }
  
  func getCities() -> Single<[City]?> {
    return request(method: .get, url: Endpoint.cities.url)
  }
  
  private func request<T: Codable>(method: HTTPMethod, url: URL, parameters: [String: AnyObject]? = nil) -> Single<T?> {
    return manager.rx.responseString(method, url, parameters: parameters, encoding: encoding, headers: headers)
      .observeOn(ConcurrentDispatchQueueScheduler(qos: DispatchQoS(qosClass: DispatchQoS.QoSClass.background, relativePriority: 1)))
      .asSingle()
      .flatMap { json -> Single<T?> in
        if json.0.statusCode == 200 {
          let jsonString = json.1
          
          guard let data = jsonString.data(using: .utf8) else { return Single.error(APIError.unknown) }
          
          let response = try JSONDecoder().decode(T.self, from: data)
          
          return Single.just(response)
        }
        
        return Single.error(APIError.unknown)
    }
  }
  
  final class HTTPManager: Alamofire.SessionManager {
    static let shared: HTTPManager = {
      let configuration = URLSessionConfiguration.default
      configuration.timeoutIntervalForRequest = TIME_OUT_INTERVAL
      configuration.timeoutIntervalForResource = TIME_OUT_INTERVAL
      
      let manager = HTTPManager(configuration: configuration)
      return manager
    }()
  }
}
