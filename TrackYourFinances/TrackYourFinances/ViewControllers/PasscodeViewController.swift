//
//  PasscodeViewController.swift
//  TrackYourFinances
//
//  Created by Kapitan Kanapka on 21.07.2020.
//  Copyright © 2020 hippo. All rights reserved.
//

import UIKit
import SwiftValidator
import KeychainAccess

class PasscodeViewController: UIViewController {
    
    @IBOutlet weak var passcodeSwitch: UISwitch!
    @IBOutlet weak var changePasscodeButtonOutlet: UIButton!
    @IBOutlet weak var confirmPasscodeTextField: UITextField!
    @IBOutlet weak var newPasscoeTextField: UITextField!
    @IBOutlet weak var confirmPasscodeLabel: UILabel!
    @IBOutlet weak var faceIdWarningPasscodeShouldBeConfigured: UITextView!
    @IBOutlet weak var faceIdWarningNotSupported: UITextView!
    @IBOutlet weak var faceIdSwitch: UISwitch!
    @IBOutlet weak var saveButtonOutlet: UIButton!
    
    var passcodeIsConfigured: Bool = false
    var faceIdIsConfigured: Bool = false
    var faceIdCanBeConfigured: Bool = false
    
    let keychain = Keychain(service: "FinanceAPP")
    
    var newPassword: String = ""
    var confirmNewPassword: String = ""
        let validator = Validator()
    
    override func viewDidLoad () {
        super.viewDidLoad()
        passcodeIsConfigured =  UserDefaults.standard.bool(forKey: "passcodeIsConfigured")
        faceIdIsConfigured =  UserDefaults.standard.bool(forKey: "faceIdIsConfigured")
        
        newPasscoeTextField.delegate = self
        confirmPasscodeTextField.delegate = self
        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                          action: #selector(self.didTap))
        
        validator.registerField(confirmPasscodeTextField,errorLabel: confirmPasscodeLabel, rules: [RequiredRule(message: NSLocalizedString("Text field should not be empty", comment: "")),
                                                                                                   ConfirmationRule(confirmField: newPasscoeTextField), MaxLengthRule(length: 4, message: NSLocalizedString("Length should be 4", comment: "")), MinLengthRule(length: 4, message: NSLocalizedString("Length should be 4", comment: ""))])
        

        view.addGestureRecognizer(tapGestureRecognizer)
        
        confirmPasscodeTextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        setupView()
        
    }
        
    @IBAction func changePasscodeButton(_ sender: Any) {
        
    }
    
    @IBAction func saveButtonPasscode(_ sender: Any) {
        if passcodeSwitch.isOn && !newPasscoeTextField.isHidden {
            view.endEditing(true)
            validator.validate(self)
        }

    }
    
    @IBAction func passcodeSwitch(_ sender: Any) {
        if passcodeSwitch.isOn {
            passcodeSwitchIsUpdated(isSwitchedOn: true)
        }
        if !passcodeSwitch.isOn {
            passcodeSwitchIsUpdated(isSwitchedOn: false)
        }
    }
    
    @IBAction func faceIdSwitch(_ sender: Any) {
        if faceIdSwitch.isOn {
            UserDefaults.standard.set(true, forKey: "faceIdIsConfigured")
        }
        if !faceIdSwitch.isOn {
            UserDefaults.standard.set(false, forKey: "faceIdIsConfigured")
        }
    }
    
    func setupView () {
        if passcodeIsConfigured {
            passcodeSwitch.setOn(true, animated: true)
            passcodeSwitch.isOn = true
            changePasscodeButtonOutlet.isHidden = false
            faceIdWarningPasscodeShouldBeConfigured.isHidden = true
            confirmPasscodeTextField.isHidden = true
            newPasscoeTextField.isHidden = true
            
            if faceIdIsConfigured {
                faceIdSwitch.setOn(true, animated: true)
                faceIdSwitch.isOn = true
            }
        } else {
            passcodeSwitch.setOn(false, animated: true)
            faceIdSwitch.setOn(false, animated: true)
            passcodeSwitch.isOn = false
            faceIdSwitch.isOn = false
            faceIdSwitch.isEnabled = false
            changePasscodeButtonOutlet.isHidden = true
            faceIdWarningPasscodeShouldBeConfigured.isHidden = false
            confirmPasscodeTextField.isHidden = true
            newPasscoeTextField.isHidden = true
        }
    }
    
    func passcodeSwitchIsUpdated(isSwitchedOn: Bool) {
        if isSwitchedOn {
            changePasscodeButtonOutlet.isHidden = true
            faceIdWarningPasscodeShouldBeConfigured.isHidden = true
            confirmPasscodeTextField.isHidden = false
            newPasscoeTextField.isHidden = false
        }
        else {
            changePasscodeButtonOutlet.isHidden = true
            faceIdWarningPasscodeShouldBeConfigured.isHidden = true
            confirmPasscodeTextField.isHidden = true
            newPasscoeTextField.isHidden = true
            faceIdSwitch.setOn(false, animated: true)
            faceIdSwitch.isOn = false
            keychain["Password"] = nil
            UserDefaults.standard.set(false, forKey: "faceIdIsConfigured")
            UserDefaults.standard.set(false, forKey: "passcodeIsConfigured")
            
        }
        
    }
}

// MARK: - UITextFieldDelegate

extension PasscodeViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 4
    }
    
    func  textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let newText = textField.text {
            if textField == newPasscoeTextField {
                newPassword = newText
            } else {
                confirmNewPassword = newText
            }
        }
    }
}

// MARK: - Actions

private extension PasscodeViewController {
    @objc func didTap() {
        view.endEditing(true)
    }
    
    @objc func editingChanged(_ textField: UITextField) {
        if textField == newPasscoeTextField {
            newPasscoeTextField.layer.borderWidth = 0.0
        } else {
            confirmPasscodeLabel.isHidden = true
            newPasscoeTextField.layer.borderWidth = 0.0
        }

    }
    
    @objc func didPressOnDoneButton(_ sender: Any) {
       saveButtonActions()
    }
    
}

extension PasscodeViewController {
    func saveButtonActions() {
        view.endEditing(true)
        if passcodeSwitch.isOn && !newPasscoeTextField.isHidden {
            validator.validate(self)
        }
    }
}

extension PasscodeViewController: ValidationDelegate{
    func validationSuccessful() {
         UserDefaults.standard.set(true, forKey: "passcodeIsConfigured")
        newPasscoeTextField.isHidden = true
        confirmPasscodeTextField.isHidden = true
        changePasscodeButtonOutlet.isHidden = false
        
        keychain["Password"] = newPassword
    }
    
    func validationFailed(_ errors: [(Validatable, ValidationError)]) {
        for (field, error) in errors {
            if let field = field as? UITextField {
                field.layer.borderColor = #colorLiteral(red: 0.598151967, green: 0.167491116, blue: 0.2818549418, alpha: 0.8676155822).withAlphaComponent(1.0).cgColor
                field.layer.borderWidth = 1.0
            }
            error.errorLabel?.text = error.errorMessage
            error.errorLabel?.textColor = #colorLiteral(red: 0.598151967, green: 0.167491116, blue: 0.2818549418, alpha: 0.8676155822).withAlphaComponent(1.0)
            error.errorLabel?.isHidden = false
        }
    }
}
