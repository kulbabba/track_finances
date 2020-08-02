//
//  DBActions.swift
//  TrackYourFinances
//
//  Created by Kapitan Kanapka on 15.07.2020.
//  Copyright © 2020 hippo. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class DBActions {
    
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
        let contentsOfCsv = getContentFromCSV(fileName: "Categories")
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
        let contentsOfCsv = getContentFromCSV(fileName: "Currencies")
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
    
    func preloadData () {
        //guard let items = parseCSV() else { return }
        guard let items = parseCategoriesCSV() else { return }
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        for item in items {
            let entity =
                NSEntityDescription.entity(forEntityName: "Categories",
                                           in: managedContext)!
            
            let category = Categories(entity: entity,
                                      insertInto: managedContext)
            
            
            category.categoryName = item
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    func preloadCurrencies() {
        guard let items = parseCurrenciesCSV() else { return }
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        for item in items {
            let entity =
                NSEntityDescription.entity(forEntityName: "Currencies",
                                           in: managedContext)!
            
            let currency = Currencies(entity: entity,
                                      insertInto: managedContext)
            
            
            currency.currencyName = item.name
            currency.currencySymbol = item.symbol
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    func save(nameValue: String, priceValue: Int, categoryValue: Categories) {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        
        let entity =
            NSEntityDescription.entity(forEntityName: "Expences",
                                       in: managedContext)!
        
        let expence = Expences(entity: entity,
                               insertInto: managedContext)
        
        expence.name = nameValue
        expence.price = Int32(priceValue)
        expence.category = categoryValue
        
        
        // 4
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func getCategoriesFromDb() -> [Categories] {
        var categoriesList: [Categories] = []
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return categoriesList
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Categories")
        
        do {
            if let categorylist = try managedContext.fetch(fetchRequest) as? [Categories] {
                categoriesList = categorylist
            }
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return categoriesList
    }
    
    func getCurrenciesFromDb() -> [Currencies] {
        var currenciesList: [Currencies] = []
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return currenciesList
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Currencies")
        
        do {
            if let currencies = try managedContext.fetch(fetchRequest) as? [Currencies] {
            currenciesList = currencies
            }
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return currenciesList
    }
    
        func getExpensesForSpecificDate(startDate: Date, endDate: Date) -> [Expences] {
            var expensesList: [Expences] = []
            guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
                    return expensesList
            }
            
            let managedContext =
                appDelegate.persistentContainer.viewContext
            
            let fetchRequest =
                NSFetchRequest<Expences>(entityName: "Expences")

            
            let delete = NSFetchRequest<NSManagedObject>(entityName: "Expences")
            
            fetchRequest.predicate = NSPredicate(format: "(epenceDate >= %@) AND (epenceDate <= %@)", startDate.start(of: .day) as NSDate , endDate.end(of: .day) as NSDate)
            
            do {
                //del
               if let expedddnses = try managedContext.fetch(delete) as? [Expences] {
                    expensesList = expedddnses
                }
                
                
                if let expenses = try managedContext.fetch(fetchRequest) as? [Expences] {
                    expensesList = expenses
                }
                
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
            
            return expensesList
        }
}
