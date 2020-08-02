//
//  StatisticsViewController.swift
//  TrackYourFinances
//
//  Created by Kapitan Kanapka on 06.07.2020.
//  Copyright © 2020 hippo. All rights reserved.
//

import UIKit
import UIKit
import CoreData

class StatisticsViewController: UIViewController {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var expencesTableView: UITableView!
    @IBOutlet weak var noExpenceLabel: UILabel!    
    @IBOutlet weak var noDataIconOutlet: UILabel!
    
    var dateLabelValue: String = ""
    var dataSource: UICollectionViewDiffableDataSource<Categories, Expences>!
    var categories: [Categories] = []
    var categoriesForTableView: [(category: String, expences: [Expences])] = []
    var statisticsDate: Date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categories = DBActions().getCategoriesFromDb()
        
        categories.filter{ $0.expence.count > 0 }.forEach { category in
            let expenceArray = Array(category.expence).sorted { (ex1, ex2) -> Bool in
                return ex1.price > ex2.price
            }
            let expenceArrayForCurrentDate = expenceArray.filter {
                $0.epenceDate!.isSameDay(date: statisticsDate)
            }
            if expenceArrayForCurrentDate.count > 0 {
                let categoryTuple = (category.categoryName!, expenceArrayForCurrentDate)
                
                categoriesForTableView.append(categoryTuple)
            }
            
        }
        if categoriesForTableView.count == 0 {
            showNoExpencesLabels()
        }
        dateLabel.text = dateLabelValue
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension StatisticsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesForTableView[section].1.count
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return categoriesForTableView.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
        headerView.backgroundColor = #colorLiteral(red: 0.3238684347, green: 0.8115482234, blue: 0.7658885481, alpha: 0.6112478596).withAlphaComponent(0.25)
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
        headerView.addSubview(label)
        
        label.text = categoriesForTableView[section].category
        label.textColor = .white
        label.textAlignment = .center
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ExpencesCell = tableView.dequeueReusableCell(withIdentifier: StoryBoardIdentifiersConstants.expenceCellIdentifiew, for: indexPath) as! ExpencesCell
        
        let expence = categoriesForTableView[indexPath.section].expences[indexPath.row]
        cell.expenceNameLabel.text = expence.name
        cell.expencePriceLabe.text = String(expence.price)
        
        return cell
    }
}

extension StatisticsViewController {
//    func getCategoriesFromDb() -> [Categories] {
//        var actualCategoriesList: [Categories] = []
//        guard let appDelegate =
//            UIApplication.shared.delegate as? AppDelegate else {
//                return actualCategoriesList
//        }
//
//        let managedContext =
//            appDelegate.persistentContainer.viewContext
//
//        let fetchRequest =
//            NSFetchRequest<NSManagedObject>(entityName: "Categories")
//
//        do {
//            if let categorylist = try managedContext.fetch(fetchRequest) as? [Categories] {
//                categorylist.forEach { category in
//
//                }
//                actualCategoriesList = categorylist
//            }
//        } catch let error as NSError {
//            print("Could not fetch. \(error), \(error.userInfo)")
//        }
//        return actualCategoriesList
//    }
    
    public func showNoExpencesLabels () {
        noExpenceLabel.isHidden = false
        noExpenceLabel.text = NSLocalizedString("No expences", comment: "")
        noDataIconOutlet.isHidden = false
    }
}
