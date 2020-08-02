//
//  SwiftValidatorExtensions.swift
//  TrackYourFinances
//
//  Created by Kapitan Kanapka on 15.07.2020.
//  Copyright © 2020 hippo. All rights reserved.
//

import Foundation
import SwiftValidator

class PriceRule: RegexRule {

     static let regex = "^[0-9]{1,10}([,.][0-9]{1,2})?$"
    
    convenience init(message : String = "Not a valid PriceRule"){
    self.init(regex: PriceRule.regex, message : message)
    }
}
