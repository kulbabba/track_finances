//
//  ChoseCategoryViewController.swift
//  TrackYourFinances
//
//  Created by Kapitan Kanapka on 07.07.2020.
//  Copyright © 2020 hippo. All rights reserved.
//

import UIKit
import CoreData

class ChooseCategoryViewController: UIViewController {
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Categories>!
    var categories: [Categories] = []
    var expenceName: String = ""
    var expencePrice: Int = 0
    var expenceDate: Date = Date()
    
    enum Section {
        case main
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCategoriesFromDb()
        configureDataSource()
        configureSnapshot()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let selectedIndexPath = IndexPath(item: 0, section: 0)
        categoryCollectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: .left)
    }
    
    @IBAction func saveButton(_ sender: Any) {
        if let collectionView = self.categoryCollectionView,
            let indexPath = collectionView.indexPathsForSelectedItems?.first,
            let cell = collectionView.cellForItem(at: indexPath) as? CategoryCell,
            let category = cell.category {
            save(nameValue: expenceName, priceValue: expencePrice, categoryValue: category)
        }
        
        navigationController?.popToRootViewController(animated: true)
    }
}

extension ChooseCategoryViewController {
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
        expence.epenceDate = expenceDate
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func getCategoriesFromDb() {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Categories")
        
        do {
            if let categorylist = try managedContext.fetch(fetchRequest) as? [Categories] {
                categories = categorylist
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}

// MARK: - Diffable Data Source

extension ChooseCategoryViewController {
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Categories>(collectionView: categoryCollectionView) { (collectionView: UICollectionView, indexPath: IndexPath, categoryOfCell) -> UICollectionViewCell? in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.reuseIdentifier, for: indexPath) as? CategoryCell else { return nil }
            
            cell.categoryNameTextField.text = categoryOfCell.categoryName
            cell.category = categoryOfCell
            
            return cell
        }
    }
    
    func configureSnapshot() {
        var initialSnapshot = NSDiffableDataSourceSnapshot<Section, Categories> ()
        initialSnapshot.appendSections([.main])
        
        let categoriesList = categories
        
        initialSnapshot.appendItems(categoriesList, toSection: .main)
        dataSource.apply(initialSnapshot, animatingDifferences: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }        
    }
}
