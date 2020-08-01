//
//  MainScreenWithPasscode.swift
//  TrackYourFinances
//
//  Created by Kapitan Kanapka on 22.07.2020.
//  Copyright © 2020 hippo. All rights reserved.
//

import UIKit
import KeychainAccess


class MainScreenWithPasscode: UIViewController, UITextInputTraits {
var keyboardType: UIKeyboardType = .numberPad
    
    @IBOutlet weak var pin_one: UIImageView!
    @IBOutlet weak var pin_two: UIImageView!
    @IBOutlet weak var pin_three: UIImageView!
    @IBOutlet weak var pin_four: UIImageView!
    
    var didFinishedEnterCode:((String)-> Void)?
    var pinList: [UIView] = []
    
    var code: String = "" {
        didSet {
            updateStack(by: code)
            if code.count == maxLength, let didFinishedEnterCode = didFinishedEnterCode {
                self.resignFirstResponder()
                didFinishedEnterCode(code)
                
                verifyPasscodeEntered()
            }
        }
    }
    var maxLength = 4
    
    override func viewDidLoad() {
        pinList = [pin_one, pin_two, pin_three, pin_four]
        self.becomeFirstResponder()
        self.didFinishedEnterCode = {code in
            print("code is:\(code)")
        }
    }
    
    private func updateStack(by code: String) {
        let enteredPinLength = code.count
        
        for pin in pinList {
            if let pinIndex = pinList.firstIndex(of: pin) {
                if pinIndex < enteredPinLength {
                    pin.backgroundColor =  #colorLiteral(red: 0.3238684347, green: 0.8115482234, blue: 0.7658885481, alpha: 0.6133882705).withAlphaComponent(0.61)
                }
                else {
                      pin.backgroundColor =  UIColor.lightGray
                  }
            }
  
        }
    }
}

extension MainScreenWithPasscode: UIKeyInput {
    var hasText: Bool {
        return code.count > 0
    }
    func insertText(_ text: String) {
        if code.count == maxLength {
            return
        }
        code.append(contentsOf: text)
        print(code)
    }
    
    func deleteBackward() {
        if hasText {
            code.removeLast()
        }
        print(code)
    }
    
}


extension MainScreenWithPasscode {
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    private func showKeyboardIfNeeded() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }
    @objc private func showKeyboard() {
        self.becomeFirstResponder()
    }
}

extension MainScreenWithPasscode {
    func verifyPasscodeEntered() {
        let keychain = Keychain(service: "FinanceAPP")
        let passcodeSaved = keychain["Password"]
        if code == passcodeSaved {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainViewController: MainViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
            
            navigationController?.pushViewController(mainViewController, animated: true)
        }
        else {
            code = ""
            self.updateStack(by: code)
            self.becomeFirstResponder()
        }
    }
}
