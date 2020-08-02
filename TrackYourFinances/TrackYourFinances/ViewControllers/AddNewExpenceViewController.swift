//
//  AddNewExpenceViewController.swift
//  TrackYourFinances
//
//  Created by Kapitan Kanapka on 06.07.2020.
//  Copyright © 2020 hippo. All rights reserved.
//

import UIKit
import SwiftValidator

class AddNewExpenceViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    
    @IBOutlet weak var priceErrorLabel: UILabel!
    @IBOutlet weak var nameErrorLabel: UILabel!
    @IBOutlet weak var saveButtonOutlet: UIButton!
    
    @IBOutlet weak var saveButtonTopConstraints: NSLayoutConstraint!
    @IBOutlet weak var saveButtonBottomConstraint: NSLayoutConstraint!
    var newExpencesName: String = ""
    var newExpencesPrice: String = ""
    var expenceDate: Date = Date()
    
    let validator = Validator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        priceTextField.delegate = self
        
        nameErrorLabel.isHidden = true
        priceErrorLabel.isHidden = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                          action: #selector(self.didTap))
        
        priceTextField.addDoneOnKeyboardWithTarget(self, action: #selector(didPressOnDoneButton))
        
        validator.registerField(nameTextField,errorLabel: nameErrorLabel, rules: [RequiredRule(message: NSLocalizedString("Text field should not be empty", comment: ""))])
        validator.registerField(priceTextField,errorLabel: priceErrorLabel, rules: [RequiredRule(message: NSLocalizedString("Text field should not be empty", comment: "")),
                                                                                    PriceRule(message: NSLocalizedString("Only numerics", comment: ""))])
        
        
        view.addGestureRecognizer(tapGestureRecognizer)
        
        [nameTextField, priceTextField].forEach({ $0.addTarget(self, action: #selector(editingChanged), for: .editingChanged) })
    }
    
    @IBAction func saveButton(_ sender: Any) {
        saveButtonActions()
    }
}

// MARK: - UITextFieldDelegate

extension AddNewExpenceViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let oldText = textField.text,
            let stringRange = Range(range, in: oldText) else {
                return false
        }
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        return true
    }
    
    func  textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
        saveButtonTopConstraints.priority = UILayoutPriority(rawValue: 1000)
        saveButtonBottomConstraint.priority = UILayoutPriority(rawValue: 800)
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let newText = textField.text {
            if textField == nameTextField {
                newExpencesName = newText
            } else {
                newExpencesPrice = newText
            }
        }
        
        saveButtonTopConstraints.priority = UILayoutPriority(rawValue: 800)
        saveButtonBottomConstraint.priority = UILayoutPriority(rawValue: 1000)
    }
}

// MARK: - Actions

private extension AddNewExpenceViewController {
    @objc func didTap() {
        view.endEditing(true)
    }
    
    @objc func editingChanged(_ textField: UITextField) {
        if textField == nameTextField {
            nameErrorLabel.isHidden = true
            nameTextField.layer.borderWidth = 0.0
        } else {
            priceErrorLabel.isHidden = true
            priceTextField.layer.borderWidth = 0.0
        }
    }
    
    @objc func didPressOnDoneButton(_ sender: Any) {
        saveButtonActions()
    }
}

extension AddNewExpenceViewController {
    func saveButtonActions() {
        view.endEditing(true)
        validator.validate(self)
    }
}

// MARK: - ValidationDelegate

extension AddNewExpenceViewController: ValidationDelegate {
    func validationSuccessful() {
        let storyboard = UIStoryboard(name: AppConstants.storyboardMain, bundle: nil)
        let chooseCategoryViewController: ChooseCategoryViewController = storyboard.instantiateViewController(withIdentifier: "ChooseCategoryViewController") as! ChooseCategoryViewController
        
        chooseCategoryViewController.expencePrice = Int(newExpencesPrice) ?? 0
        chooseCategoryViewController.expenceName = newExpencesName
        chooseCategoryViewController.expenceDate = expenceDate
        navigationController?.pushViewController(chooseCategoryViewController, animated: true)
    }
    
    func validationFailed(_ errors: [(Validatable, ValidationError)]) {
        for (field, error) in errors {
            if let field = field as? UITextField {
                field.layer.borderColor = Constants.redColors.cgColor
                field.layer.borderWidth = 1.0
            }
            error.errorLabel?.text = error.errorMessage
            error.errorLabel?.textColor = Constants.redColors
            error.errorLabel?.isHidden = false
        }
    }
}

private struct Constants {
    static let maxLength = 4
    static let redColors = #colorLiteral(red: 0.598151967, green: 0.167491116, blue: 0.2818549418, alpha: 0.8676155822).withAlphaComponent(1.0)
}
