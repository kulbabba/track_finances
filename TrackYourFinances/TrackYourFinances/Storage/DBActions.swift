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
    private var managedContext: NSManagedObjectContext? {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return nil
        }
        
        return appDelegate.persistentContainer.viewContext
    }
    
    func preloadData () {
        guard let items = CsvActions().parseCategoriesCSV() else { return }
        guard let managedContext = managedContext else { return }
        
        for item in items {
            let entity =
                NSEntityDescription.entity(forEntityName: DBEntitiesConstants.categoriesEntityName,
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
        guard let managedContext = managedContext else { return }
        
        for item in items {
            let entity =
                NSEntityDescription.entity(forEntityName: DBEntitiesConstants.currenciesEntityName,
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
    
    func save(nameValue: String, priceValue: Int, categoryValue: Categories, expenceDate: Date) {
        guard let managedContext = managedContext else { return }
        
        let entity =
            NSEntityDescription.entity(forEntityName: DBEntitiesConstants.expensesEntityName,
                                       in: managedContext)!
        
        let expence = Expences(entity: entity,
                               insertInto: managedContext)
        
        expence.name = nameValue
        expence.price = Int32(priceValue)
        expence.category = categoryValue
        expence.epenceDate = expenceDate
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func getCategoriesFromDb() -> [Categories] {
        var categoriesList: [Categories] = []
        guard let managedContext = managedContext else { return categoriesList }
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: DBEntitiesConstants.categoriesEntityName)
        
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
        guard let managedContext = managedContext else { return categoriesList }
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: DBEntitiesConstants.categoriesEntityName)
        
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
        guard let managedContext = managedContext else { return currenciesList }
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: DBEntitiesConstants.currenciesEntityName)
        
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
        guard let managedContext = managedContext else { return expensesList }
        
        let fetchRequest =
            NSFetchRequest<Expences>(entityName: DBEntitiesConstants.expensesEntityName)
        
        
        let delete = NSFetchRequest<NSManagedObject>(entityName: DBEntitiesConstants.expensesEntityName)
        
        fetchRequest.predicate = NSPredicate(format: "(epenceDate >= %@) AND (epenceDate <= %@)", startDate.start(of: .day) as NSDate , endDate.end(of: .day) as NSDate)
        
        do {
            if let expedddnses = try managedContext.fetch(delete) as? [Expences] {
                expensesList = expedddnses
            }
                
            if let expenses = try? managedContext.fetch(fetchRequest) {
                expensesList = expenses
            }
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return expensesList
    }
}
