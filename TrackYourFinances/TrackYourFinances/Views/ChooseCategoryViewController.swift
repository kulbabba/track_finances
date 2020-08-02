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
        categories = DBActions().getCategoriesFromDb()
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
            DBActions().save(nameValue: expenceName, priceValue: expencePrice, categoryValue: category, expenceDate: expenceDate)
        }
        
        navigationController?.popToRootViewController(animated: true)
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
