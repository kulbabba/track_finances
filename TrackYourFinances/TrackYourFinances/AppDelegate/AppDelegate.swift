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
        if UserDefaults.isFirstLaunch() {
            DBActions().preloadData()
            DBActions().preloadCurrencies()
        }
        IQKeyboardManagerSettings.setIQKeyboard()
        launchFirstViewController()
        
        return true
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TrackYourFinances")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
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
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

extension AppDelegate {
    func launchFirstViewController() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
        
        if UserDefaults.standard.bool(forKey: UserDefaultsKeys.passcodeIsConfigured)  {
            if UserDefaults.standard.bool(forKey: UserDefaultsKeys.faceIdIsConfigured) {
                let storyboard = UIStoryboard.init(name: AppConstants.storyboardMain, bundle: nil)
                let viewController = storyboard.instantiateViewController(withIdentifier: StoryBoardIdentifiersConstants.faceIdTouchIdViewController) as! FaceIdTouchIdViewController
                let navigationController = UINavigationController.init(rootViewController: viewController)
                appDelegate.window?.rootViewController = navigationController
            } else {
                let storyboard = UIStoryboard.init(name: AppConstants.storyboardMain, bundle: nil)
                let viewController = storyboard.instantiateViewController(withIdentifier: StoryBoardIdentifiersConstants.mainScreenWithPasscode) as! MainScreenWithPasscode
                let navigationController = UINavigationController.init(rootViewController: viewController)
                appDelegate.window?.rootViewController = navigationController
            }
        }
        else {
            let storyboard = UIStoryboard.init(name: AppConstants.storyboardMain, bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: StoryBoardIdentifiersConstants.mainViewController) as! MainViewController
            let navigationController = UINavigationController.init(rootViewController: viewController)
            appDelegate.window?.rootViewController = navigationController
        }
        appDelegate.window?.makeKeyAndVisible()
    }
}
