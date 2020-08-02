//
//  DateFormatter.swift
//  TrackYourFinances
//
//  Created by Kapitan Kanapka on 11.07.2020.
//  Copyright © 2020 hippo. All rights reserved.
//

import Foundation
import Charts

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
    
    static func formatDateToStringFromeTimeStamp (timeInterval: Double, dateFormateString: String = "MMdd") -> String {
        let date = Date(timeIntervalSince1970: timeInterval)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = dateFormateString
        let strDate = dateFormatter.string(from: date)
        return strDate
    }
}

extension DateFormate: IAxisValueFormatter {
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let dateString = DateFormate.formatDateToStringFromeTimeStamp (timeInterval: value, dateFormateString: "ddMMMM")
        return dateString
    }
}
