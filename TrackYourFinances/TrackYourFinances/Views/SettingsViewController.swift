//
//  SettingsViewController.swift
//  TrackYourFinances
//
//  Created by Kapitan Kanapka on 18.07.2020.
//  Copyright © 2020 hippo. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var currencyTableView: UITableView!

        var currencies: [Currencies] = []

        override func viewDidLoad() {
            super.viewDidLoad()
            
            currencies = DBActions().getCurrenciesFromDb()
        }
    }

    // MARK: - UITableViewDataSource, UITableViewDelegate

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CurrencyCell = tableView.dequeueReusableCell(withIdentifier: "CurrencyCell", for: indexPath) as! CurrencyCell
        
        let currencyName = currencies[indexPath.row].currencyName
        cell.currencyNameOutlet.text = currencyName
        
        return cell
    }
    }
