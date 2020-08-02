//
//  ViewController.swift
//  TrackYourFinances
//
//  Created by Kapitan Kanapka on 02.07.2020.
//  Copyright © 2020 hippo. All rights reserved.
//

import UIKit
import Charts
import CoreData
import CalendarKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var dayHeaderView: DayView!
    @IBOutlet weak var dateLabelValue: UIButton!
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var pieChart: PieChartView!
    
    var expences: [Expences] = []
    var categories: [Categories] = []
    var categiriesWithValue: [Categories] = []
    var dataSource: UICollectionViewDiffableDataSource<Section, String>!
    var chosenDate: Date = Date()
    
    enum Section{
        case main
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let calendarStyle = setCalendarStyle()
        dayHeaderView.updateStyle(calendarStyle)
        dayHeaderView.backgroundColor = #colorLiteral(red: 0.1095174178, green: 0.1127971485, blue: 0.1583940983, alpha: 1).withAlphaComponent(1.0)
        dayHeaderView.delegate = self
        let formattedDate = DateFormate.formateDateForStatistics(date: Date(), dateFormateString: Constants.dateFormat)
        dateLabelValue.setTitle(formattedDate, for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        categiriesWithValue = CategoryFilter().filterCategoriesWithValues()
        showChartWithExpenses(categories: categiriesWithValue, date: chosenDate)
    }
    
    @IBAction func settingsButton(_ sender: Any) {
    }
    
    @IBAction func statisticsButton(_ sender: Any) {
    }
    
    @IBAction func addExpensesButton(_ sender: Any) {
    }
    
    private func colorsOfCharts(numbersOfColor: Int) -> [UIColor] {
        var colors: [UIColor] = []
        for _ in 0..<numbersOfColor {
            let red = Double(arc4random_uniform(100))
            let green = Double(arc4random_uniform(100))
            let blue = Double(arc4random_uniform(256))
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 0.7)
            colors.append(color)
        }
        return colors
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == StoryBoardIdentifiersConstants.statisticsViewController {
            if let statisticsViewController = segue.destination as? StatisticsViewController {
                if let date = dateLabelValue.titleLabel?.text {
                    statisticsViewController.dateLabelValue = date
                    statisticsViewController.statisticsDate = chosenDate
                }
            }            
        }
        if segue.identifier == StoryBoardIdentifiersConstants.addNewExpenceViewController {
            if let addNewExpenceViewController = segue.destination as? AddNewExpenceViewController {
                addNewExpenceViewController.expenceDate = chosenDate
            }
        }
    }
}

// MARK: - DayViewDelegate

extension MainViewController: DayViewDelegate {
    func dayViewDidSelectEventView(_ eventView: EventView) {
    }
    
    func dayViewDidLongPressEventView(_ eventView: EventView) {
    }

    func dayView(dayView: DayView, didTapTimelineAt date: Date) {
    }

    func dayView(dayView: DayView, didLongPressTimelineAt date: Date) {
    }

    func dayViewDidBeginDragging(dayView: DayView) {
    }

    func dayView(dayView: DayView, willMoveTo date: Date) {
    }

    func dayView(dayView: DayView, didMoveTo date: Date) {
        chosenDate = date
        let formattedDate = DateFormate.formateDateForStatistics(date: date, dateFormateString: Constants.dateFormat)
        
        dateLabelValue.setTitle(formattedDate, for: .normal)
        showChartWithExpenses(categories: categiriesWithValue, date: chosenDate)
    }

    func dayView(dayView: DayView, didUpdate event: EventDescriptor) {
    }
}

// MARK: - CalendarActions

extension MainViewController {
    func setCalendarStyle() -> CalendarStyle{
        let black = #colorLiteral(red: 0.1095174178, green: 0.1127971485, blue: 0.1583940983, alpha: 1).withAlphaComponent(1.0)
        let white = UIColor.white
        
        var selector = DaySelectorStyle()
        selector.activeTextColor = white
        selector.inactiveTextColor = white
        
        selector.selectedBackgroundColor = #colorLiteral(red: 0.598151967, green: 0.167491116, blue: 0.2818549418, alpha: 0.8676155822).withAlphaComponent(1.0)
        selector.inactiveBackgroundColor = #colorLiteral(red: 0.3238684347, green: 0.8115482234, blue: 0.7658885481, alpha: 0.6133882705).withAlphaComponent(0.61)
        
        selector.todayInactiveTextColor = #colorLiteral(red: 0.598151967, green: 0.167491116, blue: 0.2818549418, alpha: 0.8676155822).withAlphaComponent(1.0)
        selector.todayActiveTextColor = white
        selector.todayActiveBackgroundColor = #colorLiteral(red: 0.598151967, green: 0.167491116, blue: 0.2818549418, alpha: 0.8676155822).withAlphaComponent(1.0)
        
        var daySymbols = DaySymbolsStyle()
        daySymbols.weekDayColor = #colorLiteral(red: 0.3238684347, green: 0.8115482234, blue: 0.7658885481, alpha: 0.6133882705).withAlphaComponent(0.61)
        daySymbols.weekendColor = #colorLiteral(red: 0.3238684347, green: 0.8115482234, blue: 0.7658885481, alpha: 0.6133882705).withAlphaComponent(0.61)
        
        var swipeLabel = SwipeLabelStyle()
        swipeLabel.textColor = white
        swipeLabel.font = UIFont(name: Constants.swipeLabelFont, size: Constants.swipeLabelSize)!
        
        var header = DayHeaderStyle()
        header.daySelector = selector
        header.daySymbols = daySymbols
        header.swipeLabel = swipeLabel
        header.backgroundColor = black
        
        var timeline = TimelineStyle()
        timeline.lineColor = black
        timeline.timeColor = black
        timeline.backgroundColor = black
        timeline.allDayStyle.backgroundColor = black
        timeline.allDayStyle.allDayColor = black
        
        var style = CalendarStyle()
        style.header = header
        style.timeline = timeline
        
        return style
    }
    
    func showChartWithExpenses(categories: [Categories], date: Date) {
        let categoriesForCurrentDate = CategoryFilter().filterCategoryForDate(date: date, categories: categories)
        let categoryWithCalculatedExpence = CategoryFilter().filterCategoriesWithCalculatedExpense(categories: categoriesForCurrentDate)
        
        if categoryWithCalculatedExpence.count == 0 {
            pieChart.alpha = 0.0
            noDataLabel.isHidden = false
        }
        else {
            pieChart.alpha = 1.0
            noDataLabel.isHidden = true
        }
        customizeChart(dataPoints: categoryWithCalculatedExpence.map{$0.0}, values: categoryWithCalculatedExpence.map{Double($0.1)}
        )
    }
    
    func customizeChart(dataPoints: [String], values: [Double]) {
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = PieChartDataEntry(value: values[i], label: dataPoints[i], data: dataPoints[i] as AnyObject)
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: nil)
        pieChartDataSet.colors = colorsOfCharts(numbersOfColor: dataPoints.count)
        pieChart.legend.enabled = false
        
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        let format = NumberFormatter()
        format.numberStyle = .none
        let formatter = DefaultValueFormatter(formatter: format)
        pieChartData.setValueFormatter(formatter)
        
        pieChart.data = pieChartData
        pieChart.holeColor = UIColor.black.withAlphaComponent(0.0)
        pieChart.entryLabelFont = UIFont(name: Constants.pieChartLabelFont, size: Constants.pieChartLabelSize)
        
        pieChart.holeRadiusPercent = Constants.holeRadiusPercent
    }    
}

private struct Constants {
    static let holeRadiusPercent: CGFloat = 0.52
    static let pieChartLabelSize: CGFloat = 12
    static let pieChartLabelFont = "BradleyHandITCTT-Bold"
    static let swipeLabelSize: CGFloat = 0.0
    static let swipeLabelFont = "ArialMT"
    static let dateFormat = "MMMMdd"
    
}

