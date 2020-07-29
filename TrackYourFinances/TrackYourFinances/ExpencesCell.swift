//
//  ExpencesCell.swift
//  TrackYourFinances
//
//  Created by Kapitan Kanapka on 12.07.2020.
//  Copyright © 2020 hippo. All rights reserved.
//

import UIKit

class ExpencesCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: ExpencesCell.self)
    
    @IBOutlet weak var expenceNameLabel: UILabel!
    @IBOutlet weak var expencePriceLabe: UILabel!
}

