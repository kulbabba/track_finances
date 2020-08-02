//
//  CsvActions.swift
//  TrackYourFinances
//
//  Created by Kapitan Kanapka on 02.08.2020.
//  Copyright © 2020 hippo. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CsvActions {
    let categoriesCsvFileName = "Categories"
    let currenciesCsvFileName = "Currencies"
    
    func openCSV(fileName:String, fileType: String)-> String!{
        guard let filepath = Bundle.main.path(forResource: fileName, ofType: fileType)
            else {
                return nil
        }
        do {
            let contents = try String(contentsOfFile: filepath, encoding: .utf8)
            
            return contents
        } catch {
            print("File Read Error for file \(filepath)")
            return nil
        }
    }
    
    func getContentFromCSV(fileName: String) -> [[String]] {
        let dataString: String! = openCSV(fileName: fileName, fileType: "csv")
        let lines: [String] = dataString.components(separatedBy: NSCharacterSet.newlines) as [String]
        var contentsOfFile: [[String]]  = [[]]
        
        for line in lines {
            var values: [String] = []
            if line != "" {
                if line.range(of: "\"") != nil {
                    var textToScan:String = line
                    var value:String?
                    var textScanner:Scanner = Scanner(string: textToScan)
                    while !textScanner.isAtEnd {
                        if (textScanner.string as NSString).substring(to: 1) == "\"" {
                            
                            
                            textScanner.currentIndex = textScanner.string.index(after: textScanner.currentIndex)
                            
                            value = textScanner.scanUpToString("\"")
                            textScanner.currentIndex = textScanner.string.index(after: textScanner.currentIndex)
                        } else {
                            value = textScanner.scanUpToString(",")
                        }
                        
                        values.append(value! as String)
                        
                        if !textScanner.isAtEnd{
                            let indexPlusOne = textScanner.string.index(after: textScanner.currentIndex)
                            
                            textToScan = String(textScanner.string[indexPlusOne...])
                        } else {
                            textToScan = ""
                        }
                        textScanner = Scanner(string: textToScan)
                    }
                } else  {
                    values = line.components(separatedBy: ",")
                    contentsOfFile.append(values)
                }
            }
        }
        
        return contentsOfFile
    }
    
    func parseCategoriesCSV() -> [String]? {
        let contentsOfCsv = getContentFromCSV(fileName: categoriesCsvFileName)
        var items: [String] = []
        for line in contentsOfCsv {
            if line.count > 0 {
                let item = line[0]
                items.append(item)
            }
            
        }
        return items
    }
    
    func parseCurrenciesCSV() -> [(name: String, symbol:  String)]? {
        let contentsOfCsv = getContentFromCSV(fileName: currenciesCsvFileName)
        var items: [(name: String, symbol:  String)] = []
        for line in contentsOfCsv {
            if line.count > 0 {
                let currencyName = line[0]
                let currencySymbol = line[1]
                let currency:(name: String, symbol:  String) = (name: currencyName, symbol: currencySymbol)
                items.append(currency)
            }
            
        }
        return items
    }
}
