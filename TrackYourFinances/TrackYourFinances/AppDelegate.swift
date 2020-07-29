//
//  AppDelegate.swift
//  TrackYourFinances
//
//  Created by Kapitan Kanapka on 02.07.2020.
//  Copyright © 2020 hippo. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var initialViewController :UIViewController?

     var optionallyStoreTheFirstLaunchFlag = false
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if UserDefaults.isFirstLaunch() {
            
            DBActions().preloadData()
            DBActions().preloadCurrencies()
        }
        
        //setIQKeyboard()
        IQKeyboardManagerSettings.setIQKeyboard()

        //set first viewController
        launchFirstViewController()
       
        
        //delete
        
//        ApiRequestActions().getValue { (response) in
//            switch response {
//            case .success(let result):
//                print("success")
//            case .failure(let error):
//                print("no way!")
//            }
//        }
        
        //end delete
        return true
    }

    // MARK: UISceneSession Lifecycle

//    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//        // Called when a new scene session is being created.
//        // Use this method to select a configuration to create the new scene with.
//        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//    }
//
//    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
//        // Called when the user discards a scene session.
//        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//    }
    
//    func applicationDidFinishLaunching(_ application: UIApplication) {
//        let userDefaults = UserDefaults.standard
//        let defaultValues = ["firstRun" : true]
//        userDefaults.register(defaults: defaultValues)
//
//
//
//    }
    

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "TrackYourFinances")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

extension AppDelegate {
//    func parseCSV (contentsOfURL: URL, encoding: String.Encoding, error: NSErrorPointer) -> [String]? {
//        // Load the CSV file and parse it
//        let delimiter = ","
//        var items:[String]?
//
//        //let content = try! String(contentsOf: contentsOfURL, encoding: encoding)
//        do {
//          var content = try String(contentsOf: contentsOfURL, encoding: encoding)
//
//                   items = []
//            let lines:[String] = content.components(separatedBy: NSCharacterSet.newlines) as [String]
//
//                   for line in lines {
//                       var values:[String] = []
//                       if line != "" {
//                           // For a line with double quotes
//                           // we use NSScanner to perform the parsing
//                           if line.range(of: "\"") != nil {
//                               var textToScan:String = line
//                               var value:NSString?
//                            var textScanner:Scanner = Scanner(string: textToScan)
//                               while textScanner.string != "" {
//
//                                if (textScanner.string as NSString).substring(to: 1) == "\"" {
//                                       textScanner.scanLocation += 1
//                                    textScanner.scanUpTo("\"", into: &value)
//                                       textScanner.scanLocation += 1
//                                   } else {
//                                    textScanner.scanUpTo(delimiter, into: &value)
//                                   }
//
//                                   // Store the value into the values array
//                                   values.append(value as! String)
//
//                 // Retrieve the unscanned remainder of the string
//                                            if textScanner.scanLocation < textScanner.string.count {
//                                               textToScan = (textScanner.string as NSString).substring(from: textScanner.scanLocation + 1)
//                                           } else {
//                                               textToScan = ""
//                                           }
//                                           textScanner = Scanner(string: textToScan)
//                               }
//
//                           // For a line without double quotes, we can simply separate the string
//                           // by using the delimiter (e.g. comma)
//                           } else  {
//                               values = line.components(separatedBy: ",")
//                           }
//
//
//                           let item = values[0]
//                           items?.append(item)
//                       }
//                   }
//        }
//        catch {
//           print(error)
//        }
//
//        return items
//    }
//
//    func preloadData () {
//        // Retrieve data from the source file
//        if let contentsOfURL = Bundle.main.path(forResource: "Categories", ofType: "csv") {
//
//            // Remove all the menu items before preloading
//            removeData()
//
//            var error:NSError?
//            let dataString: String! = openCSV(fileName: "MeislinDemo", fileType: "csv")
//            var items: [String] = []
//            let lines: [String] = dataString.components(separatedBy: NSCharacterSet.newlines) as [String]
//
//
//            //if let items = parseCSV(contentsOfURL: "Categories", encoding: .utf8, error: &error) {
//                // Preload the menu items
//                        guard let appDelegate =
//                    UIApplication.shared.delegate as? AppDelegate else {
//                        return
//                }
//
//                let managedContext =
//                    appDelegate.persistentContainer.viewContext
//                let managedObjectContext = managedContext
//                    for item in items {
//                        let categoryItem = NSEntityDescription.insertNewObject(forEntityName: "Categories", into: managedObjectContext) as! Categories
//                        categoryItem.categoryName = item
//
//                        do {
//                            try managedContext.save()
//                        } catch let error as NSError {
//                            print("Could not save. \(error), \(error.userInfo)")
//                        }
//                    }
//
//            //}
//        }
//    }
//
//    func removeData () {
//        // Remove the existing items
//                guard let appDelegate =
//            UIApplication.shared.delegate as? AppDelegate else {
//                return
//        }
//        let managedContext =
//            appDelegate.persistentContainer.viewContext
//        let managedObjectContext = managedContext
//
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Categories")
//            var e: NSError?
//
//        do {
//            let categoriesItems = try managedObjectContext.fetch(fetchRequest) as! [Categories]
//            for categoryItem in categoriesItems {
//                managedObjectContext.delete(categoryItem)
//            }
//        } catch let error as NSError {
//            print("Could not save. \(error), \(error.userInfo)")
//        }
//
//    }
//
//     func openCSV(fileName:String, fileType: String)-> String!{
//        guard let filepath = Bundle.main.path(forResource: fileName, ofType: fileType)
//            else {
//                return nil
//        }
//        do {
//            let contents = try String(contentsOfFile: filepath, encoding: .utf8)
//
//            return contents
//        } catch {
//            print("File Read Error for file \(filepath)")
//            return nil
//        }
//    }
    
//    func openCSV(fileName:String, fileType: String)-> String!{
//        guard let filepath = Bundle.main.path(forResource: fileName, ofType: fileType)
//            else {
//                return nil
//        }
//        do {
//            let contents = try String(contentsOfFile: filepath, encoding: .utf8)
//
//            return contents
//        } catch {
//            print("File Read Error for file \(filepath)")
//            return nil
//        }
//    }
//
//     func parseCSV() -> [String]? {
//
//        let dataString: String! = openCSV(fileName: "Categories", fileType: "csv")
//        var items: [String] = []
//        let lines: [String] = dataString.components(separatedBy: NSCharacterSet.newlines) as [String]
//
//        for line in lines {
//           var values: [String] = []
//           if line != "" {
//               if line.range(of: "\"") != nil {
//                   var textToScan:String = line
//                   var value:String?
//                   var textScanner:Scanner = Scanner(string: textToScan)
//                while !textScanner.isAtEnd {
//                       if (textScanner.string as NSString).substring(to: 1) == "\"" {
//
//
//                           textScanner.currentIndex = textScanner.string.index(after: textScanner.currentIndex)
//
//                           value = textScanner.scanUpToString("\"")
//                           textScanner.currentIndex = textScanner.string.index(after: textScanner.currentIndex)
//                       } else {
//                           value = textScanner.scanUpToString(",")
//                       }
//
//                        values.append(value! as String)
//
//                    if !textScanner.isAtEnd{
//                            let indexPlusOne = textScanner.string.index(after: textScanner.currentIndex)
//
//                        textToScan = String(textScanner.string[indexPlusOne...])
//                        } else {
//                            textToScan = ""
//                        }
//                        textScanner = Scanner(string: textToScan)
//                   }
//               } else  {
//                   values = line.components(separatedBy: ",")
//               }
//
//               // Put the values into the tuple and add it to the items array
//               let item = values[0]
//               items.append(item)
//               print(item)
//            }
//        }
//
//        return items
//    }
//
//    func preloadData () {
//
//        guard let items = parseCSV() else { return }
//
//        guard let appDelegate =
//            UIApplication.shared.delegate as? AppDelegate else {
//                return
//        }
//
//        let managedContext =
//            appDelegate.persistentContainer.viewContext
//
//        for item in items {
//            let entity =
//                NSEntityDescription.entity(forEntityName: "Categories",
//                                           in: managedContext)!
//
//            let category = Categories(entity: entity,
//                                      insertInto: managedContext)
//
//
//            category.categoryName = item
//            do {
//                try managedContext.save()
//            } catch let error as NSError {
//                print("Could not save. \(error), \(error.userInfo)")
//            }
//        }
//    }
    
//    func setIQKeyboard() {
//        IQKeyboardManager.shared.enable = true
//
//        IQKeyboardManager.shared.overrideKeyboardAppearance = true
//        IQKeyboardManager.shared.keyboardAppearance = .dark
//
////        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "Save"
//        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
//    }
}


extension AppDelegate {
    func launchFirstViewController() {
        if !UserDefaults.standard.bool(forKey: "passcodeIsConfigured")  {
//            initialViewController  = MainViewController(nibName:"PassCodeViewController",bundle:nil)
//
//            let frame = UIScreen.main.bounds
//              window = UIWindow(frame: frame)
//
//              window!.rootViewController = initialViewController
//              window!.makeKeyAndVisible()
//
//              return true
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            
            appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
            
            let launchViewController = PassCodeViewController()
            
            let navigationController = UINavigationController(rootViewController: launchViewController)
            appDelegate.window?.rootViewController = navigationController
            appDelegate.window?.makeKeyAndVisible()
        }
        else {

            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
            let navigationController = UINavigationController.init(rootViewController: viewController)
            self.window?.rootViewController = navigationController

            self.window?.makeKeyAndVisible()
        }
    }
}
