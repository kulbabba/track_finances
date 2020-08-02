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
    let categoriesEntityName = "Categories"
    let currenciesEntityName = "Currencies"
    let expensesEntityName = "Expences"
    
    func preloadData () {
        guard let items = CsvActions().parseCategoriesCSV() else { return }
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        for item in items {
            let entity =
                NSEntityDescription.entity(forEntityName: categoriesEntityName,
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
        guard let items = CsvActions().parseCurrenciesCSV() else { return }
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        for item in items {
            let entity =
                NSEntityDescription.entity(forEntityName: currenciesEntityName,
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
            NSEntityDescription.entity(forEntityName: expensesEntityName,
                                       in: managedContext)!
        
        let expence = Expences(entity: entity,
                               insertInto: managedContext)
        
        expence.name = nameValue
        expence.price = Int32(priceValue)
        expence.category = categoryValue
        
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
            NSFetchRequest<NSManagedObject>(entityName: categoriesEntityName)
        
        do {
            if let categorylist = try managedContext.fetch(fetchRequest) as? [Categories] {
                categoriesList = categorylist
            }
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return categoriesList
    }
    
    func getCategoriesFromDbForSpecificDateWithExpenses(startDate: Date, endDate: Date) -> [Categories] {
        var categoriesList: [Categories] = []
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return categoriesList
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: categoriesEntityName)
        
        fetchRequest.predicate = NSPredicate(format: "(epenceDate >= %@) AND (epenceDate <= %@) ", startDate.start(of: .day) as NSDate , endDate.end(of: .day) as NSDate)
        
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
            NSFetchRequest<NSManagedObject>(entityName: currenciesEntityName)
        
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
            NSFetchRequest<Expences>(entityName: expensesEntityName)
        
        
        let delete = NSFetchRequest<NSManagedObject>(entityName: expensesEntityName)
        
        fetchRequest.predicate = NSPredicate(format: "(epenceDate >= %@) AND (epenceDate <= %@)", startDate.start(of: .day) as NSDate , endDate.end(of: .day) as NSDate)
        
        do {
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
