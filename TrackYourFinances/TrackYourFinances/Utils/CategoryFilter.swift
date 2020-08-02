//
//  CategoryFilter.swift
//  TrackYourFinances
//
//  Created by Kapitan Kanapka on 02.08.2020.
//  Copyright © 2020 hippo. All rights reserved.
//

import Foundation

class CategoryFilter {
    func filterCategoriesWithValues() -> [Categories] {
        let actualCategories = DBActions().getCategoriesFromDb()
        return actualCategories.filter {$0.expence.count > 0 }
    }

    func filterCategoryForDate (date: Date, categories: [Categories]) -> [Categories] {
        var categoriesForCurrentDate: [Categories] = []
        categories.forEach { category in
            let expensesForCurrentDate = Array(category.expence).filter {
                $0.epenceDate!.isSameDay(date: date)
            }
            if expensesForCurrentDate.count > 0 {

                categoriesForCurrentDate.append(category)
            }
        }
        return categoriesForCurrentDate
    }

    func filterCategoriesWithCalculatedExpense (categories: [Categories]) -> [(String, Int)] {
        var categoryWithCalculatedExpence: [(String, Int)] = []
        for category in categories {
            var categoryExpences = 0
            for expence in category.expence {
                categoryExpences += Int(expence.price)
            }
            if categoryExpences != 0 {
                categoryWithCalculatedExpence.append((category.categoryName!, categoryExpences ))
            }
        }
        return categoryWithCalculatedExpence
    }
}
