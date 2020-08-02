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
            // This reason is only for Touch ID, not Face ID
            // The reason for accessing Face ID, is found in Info.plist
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
                        //
                        //                        // Face wasn't detected
//                        if let errror = error {
//                            let ac = UIAlertController(title: "Authetication Failed!",
//                                                       message: error?.localizedDescription,
//                                                       preferredStyle: .alert)
//                            ac.addAction(UIAlertAction(title: "OK", style: .default))
//                            self?.present(ac, animated: true)
//                        }
                        
                        //                        if let err = authenticationError {
                        //
                        //                        switch err._code {
                        //
                        //                        case LAError.Code.systemCancel.rawValue:
                        //                            self?.notifyUser("Session cancelled",
                        //                                            err: err.localizedDescription)
                        //
                        //                        case LAError.Code.userCancel.rawValue:
                        //                            self?.notifyUser("Please try again",
                        //                                            err: err.localizedDescription)
                        //
                        //                        case LAError.Code.userFallback.rawValue:
                        //                            self?.notifyUser("Authentication",
                        //                                            err: "Password option selected")
                        //                            // Custom code to obtain password here
                        //
                        //                        default:
                        //                            self?.notifyUser("Authentication failed",
                        //                                            err: err.localizedDescription)
                        //                            }
                        //                        }
                    }
                }
            }
            
        } else {
            // Biometric is not supported by your iOS device
            let ac = UIAlertController(title: "Biometric Authentication Unavailable",
                                       message: "Your device is not configured for biometric authentication.",
                                       preferredStyle: .alert)
            //ac.addAction(UIAlertAction(title: "OK", style: .default))
            ac.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let mainScreenWithPasscode: MainScreenWithPasscode = storyboard.instantiateViewController(withIdentifier: "MainScreenWithPasscode") as! MainScreenWithPasscode
                self.navigationController?.pushViewController(mainScreenWithPasscode, animated: true)
            }))
            self.present(ac, animated: true)
            
        }
    }
    
    //        func notifyUser(_ msg: String, err: String?) {
    //            let alert = UIAlertController(title: msg,
    //                message: err,
    //                preferredStyle: .alert)
    //
    //            let cancelAction = UIAlertAction(title: "OK",
    //                style: .cancel, handler: nil)
    //
    //            alert.addAction(cancelAction)
    //
    //            self.present(alert, animated: true,
    //                                completion: nil)
    //        }
    
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
