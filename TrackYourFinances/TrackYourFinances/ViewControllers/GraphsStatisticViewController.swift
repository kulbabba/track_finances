//
//  GraphsStatisticViewController.swift
//  TrackYourFinances
//
//  Created by Kapitan Kanapka on 07.07.2020.
//  Copyright © 2020 hippo. All rights reserved.
//

import UIKit
import Charts

class GraphsStatisticViewController: UIViewController {
    
    @IBOutlet weak var fromDateLabel: UIButton!
    @IBOutlet weak var toDateLabel: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var lineChartView: LineChartView!
    
    var fromDateValue = Date()
    var toDateValue = Date()
    var minimumToDate = Date()
    var maximumToDate = Date()
    var fromDatePickerActive = false
    var expensesList: [Expences] = []
    var calculatedExpencesForDateRange: [(date: Date, expenceCounted: Int32)]  = []
    
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
        
        expensesList = DBActions().getExpensesForSpecificDate(startDate: fromDateValue, endDate: toDateValue)
        
        calculatedExpencesForDateRange = getCalculatedExpencesForDateRange(fromDate: fromDateValue, toDate: toDateValue)
        
        updateGraph()
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

// MARK: - ChartActions

extension GraphsStatisticViewController {
    func updateGraph () {
        var lineChartEntry = [ChartDataEntry]()
        
        for expence in calculatedExpencesForDateRange {
            let value = ChartDataEntry(x: expence.date.timeIntervalSince1970 , y: Double(expence.expenceCounted))
            lineChartEntry.append(value)
        }
        
        lineChartView.xAxis.valueFormatter = DateFormate()
        
        var lineChartEntry2 = [ChartDataEntry]()
        let date4 = Date()
        let date3 = date4.addingTimeInterval(TimeInterval(-5.0 * 60.0))
        let date2 = date4.addingTimeInterval(TimeInterval(-15.0 * 60.0))
        let date1 = date4.addingTimeInterval(TimeInterval(-25.0 * 60.0))
        let date0 = date4.addingTimeInterval(TimeInterval(-35.0 * 60.0))
        lineChartEntry2.append(ChartDataEntry(x: date0.timeIntervalSince1970, y: Double(1)))
        lineChartEntry2.append(ChartDataEntry(x: date1.timeIntervalSince1970, y: Double(2)))
        lineChartEntry2.append(ChartDataEntry(x: date2.timeIntervalSince1970, y: Double(5)))
        lineChartEntry2.append(ChartDataEntry(x: date3.timeIntervalSince1970, y: Double(6)))
        lineChartEntry2.append(ChartDataEntry(x: date4.timeIntervalSince1970, y: Double(10)))
        
        let line1 = LineChartDataSet(entries: lineChartEntry)
        line1.drawCirclesEnabled = false
        line1.mode = .cubicBezier
        line1.lineWidth = 3
        line1.setColor(.orange, alpha: 1)
        line1.setDrawHighlightIndicators(false)
        line1.addColor(.orange)    
        line1.colors = [UIColor.blue]
        
        let yAxis = lineChartView.leftAxis
        yAxis.labelTextColor = .white
        yAxis.labelPosition = .outsideChart
        yAxis.labelFont = .boldSystemFont(ofSize: 13)
        yAxis.granularity = 5.0
        yAxis.granularityEnabled = true
        yAxis.drawGridLinesEnabled = false
        yAxis.drawAxisLineEnabled = false
        
        let xAxis = lineChartView.xAxis
        xAxis.labelTextColor = .white
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .boldSystemFont(ofSize: 13)
        xAxis.labelTextColor = .white
        xAxis.drawAxisLineEnabled = false
        xAxis.drawGridLinesEnabled = false
        let numberOfXValues = calculatedExpencesForDateRange.count > 4 ? 4 : calculatedExpencesForDateRange.count + 2
        xAxis.setLabelCount(numberOfXValues, force: true)
        xAxis.yOffset = 20.0
        lineChartView.rightAxis.enabled = false
        lineChartView.legend.enabled = false
        lineChartView.chartDescription?.enabled = false
        lineChartView.animate(xAxisDuration: 2.5)
        let data = LineChartData()
        data.setDrawValues(false)
        data.addDataSet(line1)
        
        lineChartView.data = data
    }
    
    func getCalculatedExpencesForDateRange (fromDate: Date, toDate: Date) ->  [(date: Date, expenceCounted: Int32)] {
        var startingDate = fromDate
        var expencesSortedByDays: [(date: Date, expenceCounted: Int32)] = []
        
        while startingDate < toDate {
            let expenceListForDate = expensesList.filter{$0.epenceDate?.start(of: .day) == startingDate.start(of: .day)}
            var expenceCount: Int32 = 0
            for expence in expenceListForDate {
                expenceCount += expence.price
            }
            if expenceCount != 0 {
                expencesSortedByDays.append((date: startingDate, expenceCounted: expenceCount))
            }
            startingDate = Calendar.current.date(byAdding: .day, value: 1, to: startingDate)!
        }
        
        return expencesSortedByDays
    }
}
