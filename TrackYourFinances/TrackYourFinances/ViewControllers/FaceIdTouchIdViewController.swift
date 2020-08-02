//
//  FaceIdTouchIdViewController.swift
//  TrackYourFinances
//
//  Created by Kapitan Kanapka on 22.07.2020.
//  Copyright © 2020 hippo. All rights reserved.
//

import UIKit
import LocalAuthentication

class FaceIdTouchIdViewController: UIViewController {
    override func viewDidLoad() {
        authenticateUser()
    }
}

// MARK: - Authentication

extension FaceIdTouchIdViewController {
    func authenticateUser () {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason: String = AppConstants.touchIdReason
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        let storyboard = UIStoryboard(name: AppConstants.storyboardMain, bundle: nil)
                        let mainViewController: MainViewController = storyboard.instantiateViewController(withIdentifier: StoryBoardIdentifiersConstants.mainViewController) as! MainViewController
                        self?.navigationController?.pushViewController(mainViewController, animated: true)
                    } else {
                        
                        let storyboard = UIStoryboard(name: AppConstants.storyboardMain, bundle: nil)
                        let mainScreenWithPasscode: MainScreenWithPasscode = storyboard.instantiateViewController(withIdentifier: StoryBoardIdentifiersConstants.mainScreenWithPasscode) as! MainScreenWithPasscode
                        self?.navigationController?.pushViewController(mainScreenWithPasscode, animated: true)
                    }
                }
            }
            
        } else {
            let ac = UIAlertController(title: NSLocalizedString("Text field should not be empty", comment: ""),
                                       message: NSLocalizedString("Your device is not configured for biometric authentication.", comment: ""),
                                       preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
                
                let storyboard = UIStoryboard(name: AppConstants.storyboardMain, bundle: nil)
                let mainScreenWithPasscode: MainScreenWithPasscode = storyboard.instantiateViewController(withIdentifier: StoryBoardIdentifiersConstants.mainScreenWithPasscode) as! MainScreenWithPasscode
                self.navigationController?.pushViewController(mainScreenWithPasscode, animated: true)
            }))
            self.present(ac, animated: true)
            
        }
    }
    
    func reportTouchIDError(error: NSError) -> String {
        switch error.code {
        case LAError.authenticationFailed.rawValue:
            return Constants.authenticationFailed
        case LAError.passcodeNotSet.rawValue:
            return Constants.passcodeNotSet
        case LAError.systemCancel.rawValue:
            return Constants.systemCancel
        case LAError.userCancel.rawValue:
            return Constants.userCancel
        case Int(kLAErrorBiometryNotEnrolled):
            return Constants.kLAErrorBiometryNotEnrolled
        case Int(kLAErrorBiometryNotAvailable):
            return Constants.kLAErrorBiometryNotAvailable
        default:
            return error.localizedDescription
        }
    }
}

private struct Constants {
    static let authenticationFailed = "Authentication Failed!"
    static let passcodeNotSet = "Passcode not set!"
    static let systemCancel = "Authentication was cancelled by the system!"
    static let userCancel = "User cancel auth"
    static let kLAErrorBiometryNotEnrolled = "User has not enrolled any finger with touch ID"
    static let kLAErrorBiometryNotAvailable = "Touch ID is not available"
}
