//
//  DateFormatter.swift
//  TrackYourFinances
//
//  Created by Kapitan Kanapka on 11.07.2020.
//  Copyright © 2020 hippo. All rights reserved.
//

import Foundation

 class DateFormate {
    
    static func formateDate (date: Date) -> String {
        let dateFormat = DateFormatter.dateFormat(fromTemplate: "MMMMdd", options: 0, locale: Locale.current)
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        return formatter.string(from: date)
    }
    
    static func formateDateForStatistics (date: Date) -> String {
        let dateFormat = DateFormatter.dateFormat(fromTemplate: "ddMMMMyyyy", options: 0, locale: Locale.current)
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        return formatter.string(from: date)
    }
}
