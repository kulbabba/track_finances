//
//  GraphsStatisticViewController.swift
//  TrackYourFinances
//
//  Created by Kapitan Kanapka on 07.07.2020.
//  Copyright © 2020 hippo. All rights reserved.
//

import UIKit

class GraphsStatisticViewController: UIViewController {
    
    @IBOutlet weak var fromDateLabel: UIButton!
    @IBOutlet weak var toDateLabel: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    var fromDateValue = Date()
    var toDateValue = Date()
    var minimumToDate = Date()
    var maximumToDate = Date()
    var fromDatePickerActive = false
    
    override func viewDidLoad() {
        fromDateLabel.setTitle(DateFormate.formateDateForStatistics(date: fromDateValue), for: .normal)
        toDateLabel.setTitle(DateFormate.formateDateForStatistics(date: toDateValue), for: .normal)
        
        datePicker.setValue(UIColor.white, forKeyPath: "textColor")
        datePicker.alpha = 0.0
        datePicker.maximumDate = maximumToDate
    }
    

    @IBAction func fromDateAction(_ sender: Any) {
        datePicker.alpha = 1.0
        datePicker.setDate(fromDateValue, animated: true)
        datePicker.minimumDate = nil
        fromDatePickerActive = true
    }
    
    @IBAction func toDateAction(_ sender: Any) {
        datePicker.minimumDate = minimumToDate
        datePicker.alpha = 1.0
        datePicker.setDate(toDateValue, animated: true)
        fromDatePickerActive = false
    }
    
    @IBAction func showStatistics(_ sender: Any) {
        datePicker.alpha = 0.0
    }
    
    @IBAction func datePickerAction(_ sender: Any) {
        let newDate = DateFormate.formateDateForStatistics(date: datePicker.date)
        
        if fromDatePickerActive {
            fromDateLabel.setTitle(newDate, for: .normal)
            fromDateValue = datePicker.date
            minimumToDate = fromDateValue
        }
        else {
            toDateLabel.setTitle(newDate, for: .normal)
            toDateValue = datePicker.date
        }
    }
    
}

