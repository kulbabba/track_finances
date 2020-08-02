//
//  UserDefaults_isFirstLaunch.swift
//  TrackYourFinances
//
//  Created by Kapitan Kanapka on 07.07.2020.
//  Copyright © 2020 hippo. All rights reserved.
//

import Foundation

extension UserDefaults {
    static func isFirstLaunch() -> Bool {
        let isFirstLaunch = !UserDefaults.standard.bool(forKey: UserDefaultsKeys.hasBeenLaunchedBeforeFlag)
        if (isFirstLaunch) {
            UserDefaults.standard.set(true, forKey: UserDefaultsKeys.hasBeenLaunchedBeforeFlag)
            UserDefaults.standard.synchronize()
        }
        return isFirstLaunch
    }
}
