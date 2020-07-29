//
//  Currency.swift
//  TrackYourFinances
//
//  Created by Kapitan Kanapka on 16.07.2020.
//  Copyright © 2020 hippo. All rights reserved.
//

import Foundation

struct Currency: Codable {
  var name:String
  var rate:Double

  enum CodingKeys: String, CodingKey {
    case name
    case rate
  }
    
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(name, forKey: .name)
    try container.encode(rate, forKey: .rate)
  }
    
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    name = try container.decode(String.self, forKey: .name)
    rate = try container.decode(Double.self, forKey: .rate)
  }
}
