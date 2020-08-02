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

extension FaceIdTouchIdViewController {
    func authenticateUser () {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason: String = "Please use Touch ID to unlock"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let mainViewController: MainViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
                        self?.navigationController?.pushViewController(mainViewController, animated: true)
                    } else {
                        
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let mainScreenWithPasscode: MainScreenWithPasscode = storyboard.instantiateViewController(withIdentifier: "MainScreenWithPasscode") as! MainScreenWithPasscode
                        self?.navigationController?.pushViewController(mainScreenWithPasscode, animated: true)
                    }
                }
            }
            
        } else {
            let ac = UIAlertController(title: "Biometric Authentication Unavailable",
                                       message: "Your device is not configured for biometric authentication.",
                                       preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let mainScreenWithPasscode: MainScreenWithPasscode = storyboard.instantiateViewController(withIdentifier: "MainScreenWithPasscode") as! MainScreenWithPasscode
                self.navigationController?.pushViewController(mainScreenWithPasscode, animated: true)
            }))
            self.present(ac, animated: true)
            
        }
    }
    
    func reportTouchIDError(error: NSError) -> String {
        switch error.code {
        case LAError.authenticationFailed.rawValue:
            return "Authentication Failed!"
        case LAError.passcodeNotSet.rawValue:
            return "Passcode not set!"
        case LAError.systemCancel.rawValue:
            return "Authentication was cancelled by the system!"
        case LAError.userCancel.rawValue:
            return "User cancel auth"
        case Int(kLAErrorBiometryNotEnrolled):
            return "User has not enrolled any finger with touch ID"
        case Int(kLAErrorBiometryNotAvailable):
            return "Touch ID is not available"
        default:
            return error.localizedDescription
        }
    }
}
