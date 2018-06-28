//
//  City.swift
//  Glovo
//
//  Created by Anıl Sözeri on 28.06.2018.
//  Copyright © 2018 Anıl Sözeri. All rights reserved.
//

import Foundation

struct City: Codable {
  let countryCode: String
  let code: String
  let name: String
  let workingAreas: [String]
  
  enum CodingKeys: String, CodingKey {
    case countryCode = "country_code"
    case code
    case name
    case workingAreas = "working_area"
  }
}
