//
//  FixerResponse.swift
//  TrackYourFinances
//
//  Created by Kapitan Kanapka on 16.07.2020.
//  Copyright © 2020 hippo. All rights reserved.
//

import Foundation

struct FixerResponse: Codable {
    var date: String
//    var timeStamp: Int
    var base: String
    var rates: [String: Double]
    
    enum CodingKeys: String, CodingKey {
        case date
//        case timeStamp
        case base
        case rates
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        date = try container.decode(String.self, forKey: .date)
//        timeStamp = try container.decode(Int.self, forKey: .timeStamp)
        base = try container.decode(String.self, forKey: .base)
        rates = try container.decode([String: Double].self, forKey: .rates)
    }
}
