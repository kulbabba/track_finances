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
    
    var expences: [Expences] = []
    var categories: [Categories] = []
    var categiriesWithValue: [Categories] = []
    var dataSource: UICollectionViewDiffableDataSource<Section, String>!
    var chosenDate: Date = Date()
    
    enum Section{
        case main
    }
    
//    override func loadView() {
//        super.loadView()
//
//      let customCalendar: Calendar = {
//          let customNSCalendar = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!
//          customNSCalendar.timeZone = TimeZone(abbreviation: "CEST")!
//          let calendar = customNSCalendar as Calendar
//          return calendar
//      }()
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //saveCategory()
        
        let calendarStyle = setCalendarStyle()
        //dayHeaderView = DayHeaderView(calendar: .autoupdatingCurrent)
        dayHeaderView.updateStyle(calendarStyle)
        dayHeaderView.backgroundColor = #colorLiteral(red: 0.1095174178, green: 0.1127971485, blue: 0.1583940983, alpha: 1).withAlphaComponent(1.0)
        dayHeaderView.delegate = self
        
        let formattedDate = DateFormate.formateDate(date: Date())
        dateLabelValue.setTitle(formattedDate, for: .normal)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        categiriesWithValue = getCategoriesWithValues()
        showChartWithExpenses(categories: categiriesWithValue, date: chosenDate)
        
        
//        let categiriesWithValue = getCategoriesWithValues()
//        var categoryWithCalculatedExpence: [(String, Int)] = []
//        for category in categiriesWithValue {
//            var categoryExpences = 0
//            for expence in category.expence {
//                categoryExpences += Int(expence.price)
//            }
//            if categoryExpences != 0 {
//                categoryWithCalculatedExpence.append((category.categoryName!, categoryExpences ))
//            }
//        }
//
//        customizeChart(dataPoints: categoryWithCalculatedExpence.map{$0.0}, values: categoryWithCalculatedExpence.map{Double($0.1)}
//        )
        
        //setdateLabelValue(date: Date())
        
    }
    
    func customizeChart(dataPoints: [String], values: [Double]) {
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = PieChartDataEntry(value: values[i], label: dataPoints[i], data: dataPoints[i] as AnyObject)
            dataEntries.append(dataEntry)
        }
        
        
        // 2. Set ChartDataSet
        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: nil)
        pieChartDataSet.colors = colorsOfCharts(numbersOfColor: dataPoints.count)
        pieChart.legend.enabled = false
        // 3. Set ChartData
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        let format = NumberFormatter()
        format.numberStyle = .none
        let formatter = DefaultValueFormatter(formatter: format)
        pieChartData.setValueFormatter(formatter)
        // 4. Assign it to the chart’s data
        pieChart.data = pieChartData
        pieChart.holeColor = UIColor.black.withAlphaComponent(0.0)
        pieChart.entryLabelFont = UIFont(name: "BradleyHandITCTT-Bold", size: 12)
        
       // pieChartData.setValueFont(UIFont(name: "BradleyHandITCTT-Bold", size: 12)!)

        pieChart.holeRadiusPercent = 0.52
    }
    
//    func setdateLabelValue(date: Date) {
//        let dateFormat = DateFormatter.dateFormat(fromTemplate: "MMMMdd", options: 0, locale: Locale.current)
//        let formatter = DateFormatter()
//        formatter.dateFormat = dateFormat
//        dateLabelValue.text = formatter.string(from: date)
//
//    }
    
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
    
    @IBOutlet weak var pieChart: PieChartView!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "StatisticsViewController" {
            if let statisticsViewController = segue.destination as? StatisticsViewController {
                if let date = dateLabelValue.titleLabel?.text {
                    statisticsViewController.dateLabelValue = date
                    statisticsViewController.statisticsDate = chosenDate
                }
                
            }
            
        }
        if segue.identifier == "AddNewExpenceViewController" {
            if let addNewExpenceViewController = segue.destination as? AddNewExpenceViewController {
                    addNewExpenceViewController.expenceDate = chosenDate
                
            }
            
        }
            
    }
    
}

extension MainViewController {
    func getCategories() -> [Categories]{
        var categoriesinDb: [Categories] = []
        //1
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return categoriesinDb
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Categories")
        
        //3
        do {
            if let categorylist = try managedContext.fetch(fetchRequest) as? [Categories] {
                categoriesinDb = categorylist
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return categoriesinDb
    }
    
    func getCategoriesWithValues() -> [Categories] {
        //var categoriesWithValuesForCurrentDate: [Categories] = []
        let actualCategories = getCategories()
        // let categoriesWithExpences = actualCategories.filter {$0.expence!.count > 0 }
        //let categoriesWithExpences = actualCategories.filter {$0.expence.count > 0 }
//        categoriesWithExpences.forEach { category in
//            let expenceArrayForCurrentDate = Array(category.expence).filter {
//                $0.epenceDate!.isSameDay(date: chosenDate)
//            }
//            if expenceArrayForCurrentDate.count > 0 {
//
//                categoriesWithValuesForCurrentDate.append(category)
//            }
//        }
        return actualCategories.filter {$0.expence.count > 0 }
    }
    
    func getCategoryForDate (date: Date, categories: [Categories]) -> [Categories] {
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
    
    func getCategoriesWithCalculatedExpense (categories: [Categories]) -> [(String, Int)] {
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
    
//    func saveCategory() {
//
//        if UserDefaults.isFirstLaunch() {
//            guard let appDelegate =
//                UIApplication.shared.delegate as? AppDelegate else {
//                    return
//            }
//
//            let managedContext =
//                appDelegate.persistentContainer.viewContext
//
//
//            let entity =
//                NSEntityDescription.entity(forEntityName: "Categories",
//                                           in: managedContext)!
//
//            let category = Categories(entity: entity,
//                                      insertInto: managedContext)
//
//
//            category.categoryName = "1"
//
//            let category2 = Categories(entity: entity,
//                                               insertInto: managedContext)
//            category2.categoryName = "2"
//
//            do {
//                try managedContext.save()
//            } catch let error as NSError {
//                print("Could not save. \(error), \(error.userInfo)")
//            }
//
//        }
        
        
    //}
    
}

//// MARK: - Diffable Data Source
//
//extension MainViewController {
//    func configureDataSource() {
//        dataSource = UICollectionViewDiffableDataSource<Section, String>(collectionView: dateCollectionView) { (collectionView: UICollectionView, indexPath: IndexPath, day) -> UICollectionViewCell? in
//
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.reuseIdentifier, for: indexPath) as? CategoryCell else { return nil }
//
//
////            cell.categoryNameTextField.text = categoryOfCell.categoryName
////            cell.category = categoryOfCell
//            return cell
//        }
//    }
//
//    func configureSnapshot() {
//        var initialSnapshot = NSDiffableDataSourceSnapshot<Section, String> ()
//        initialSnapshot.appendSections([.main])
//
//        let daysList = ["j"]
////        let cal = NSCalendar.current
////        let numberOfDays: Int = 360
////        let startDate = Date()
////        // start with today
////        var date = cal.today
////
////        var days = [Int]()
////
////        for i in 1 ... 7 {
////            // get day component:
////            let day = cal.component(.DayCalendarUnit, fromDate: date)
////            days.append(day)
////
////            // move back in time by one day:
////            date = cal.dateByAddingUnit(.DayCalendarUnit, value: -1, toDate: date, options: nil)!
////        }
//
//
//        initialSnapshot.appendItems(daysList, toSection: .main)
//        dataSource.apply(initialSnapshot, animatingDifferences: false)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 5
//    }
//}

extension MainViewController: DayViewDelegate {
    func dayViewDidSelectEventView(_ eventView: EventView) {
        print("1")
    }
    
    func dayViewDidLongPressEventView(_ eventView: EventView) {
        print("2")
    }
    
    func dayView(dayView: DayView, didTapTimelineAt date: Date) {
        print("3")
    }
    
    func dayView(dayView: DayView, didLongPressTimelineAt date: Date) {
        print("4")
    }
    
    func dayViewDidBeginDragging(dayView: DayView) {
        print("5")
    }
    
    func dayView(dayView: DayView, willMoveTo date: Date) {
        print("6")
    }
    
    func dayView(dayView: DayView, didMoveTo date: Date) {
        //dateLabelValue.text = DateFormate.formateDate(date: date)
//        let dateFormat = DateFormatter.dateFormat(fromTemplate: "MMMMdd", options: 0, locale: Locale.current)
//        let formatter = DateFormatter()
//        formatter.dateFormat = dateFormat
//        dateLabelValue.text = formatter.string(from: date)
        //setdateLabelValue(date: date)
        
        chosenDate = date
        let formattedDate = DateFormate.formateDate(date: date)
        dateLabelValue.setTitle(formattedDate, for: .normal)
        showChartWithExpenses(categories: categiriesWithValue, date: chosenDate)
    }
    
    func dayView(dayView: DayView, didUpdate event: EventDescriptor) {
        print("8")
    }
    
    
}

extension MainViewController {
    func setCalendarStyle() -> CalendarStyle{
        let black = #colorLiteral(red: 0.1095174178, green: 0.1127971485, blue: 0.1583940983, alpha: 1).withAlphaComponent(1.0)
        let darkGray = UIColor(white: 0.15, alpha: 1)
        let lightGray = UIColor.lightGray
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
        swipeLabel.font = UIFont(name: "ArialMT", size: 0.0)!

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
        
        let categoriesForCurrentDate = getCategoryForDate(date: date, categories: categories)
        let categoryWithCalculatedExpence = getCategoriesWithCalculatedExpense(categories: categoriesForCurrentDate)
        
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
    
}
