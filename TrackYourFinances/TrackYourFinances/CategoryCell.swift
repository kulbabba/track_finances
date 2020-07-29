//
//  CollectionCell.swift
//  TrackYourFinances
//
//  Created by Kapitan Kanapka on 07.07.2020.
//  Copyright © 2020 hippo. All rights reserved.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryNameTextField: UILabel!
    var category: Categories? = nil
    
    static let reuseIdentifier = String(describing: CategoryCell.self)
    
    override var isSelected: Bool {
        didSet {
            alpha = isSelected ? 0.5 : 1.0
        }
    }
    
//    func toggleSelected ()
//     {
//        if (self.isSelected){
//            self.backgroundColor = UIColor.black
//         }else {
//             self.backgroundColor  = UIColor.white
//         }
//     }
}
