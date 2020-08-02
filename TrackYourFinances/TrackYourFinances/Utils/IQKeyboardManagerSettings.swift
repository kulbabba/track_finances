//
//  IQKeyboardManagerSettings.swift
//  TrackYourFinances
//
//  Created by Kapitan Kanapka on 15.07.2020.
//  Copyright © 2020 hippo. All rights reserved.
//

import Foundation
import IQKeyboardManagerSwift

class IQKeyboardManagerSettings {
    static func setIQKeyboard() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.overrideKeyboardAppearance = true
        IQKeyboardManager.shared.keyboardAppearance = .dark
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
    }
}
