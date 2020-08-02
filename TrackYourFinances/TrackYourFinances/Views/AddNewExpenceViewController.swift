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
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        nameTextField.delegate = self
//        priceTextField.delegate = self
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        priceTextField.delegate = self
        
        nameErrorLabel.isHidden = true
        priceErrorLabel.isHidden = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                          action: #selector(self.didTap))

        priceTextField.addDoneOnKeyboardWithTarget(self, action: #selector(didPressOnDoneButton))
        
//        priceTextField.addr
        
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
        validator.registerField(nameTextField,errorLabel: nameErrorLabel, rules: [RequiredRule(message: NSLocalizedString("Text field should not be empty", comment: ""))])
        validator.registerField(priceTextField,errorLabel: priceErrorLabel, rules: [RequiredRule(message: NSLocalizedString("Text field should not be empty", comment: "")),
                                                        PriceRule(message: NSLocalizedString("Only numerics", comment: ""))])
        

        view.addGestureRecognizer(tapGestureRecognizer)
        
        [nameTextField, priceTextField].forEach({ $0.addTarget(self, action: #selector(editingChanged), for: .editingChanged) })
        
        
    }
    
    @IBAction func saveButton(_ sender: Any) {
        saveButtonActions()
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        view.endEditing(true)
//        if segue.identifier == "ChooseCategory" {
//            if let chooseCategoryViewController = segue.destination as? ChooseCategoryViewController {
//                chooseCategoryViewController.expencePrice = Int(newExpencesPrice) ?? 0
//                chooseCategoryViewController.expenceName = newExpencesName
//            }
//            
//        }
//            
//    }
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
//        if textField.text?.count == 1 {
//            if textField.text?.first == " " {
//                textField.text = ""
//                return
//            }
//        }
//        guard
//            let name = nameTextField.text, !name.isEmpty,
//            let price = priceTextField.text, !price.isEmpty
//        else {
//            warniingTextOutlet.isHidden = false
//            saveButtonOutlet.isEnabled = false
//            saveButtonOutlet.alpha = 0.5
//            return
//        }
//        saveButtonOutlet.isEnabled = true
//        saveButtonOutlet.alpha = 1.0
//        warniingTextOutlet.isHidden = true
        

    }
    @objc func didPressOnDoneButton(_ sender: Any) {
       saveButtonActions()
    }
    
//    @objc func keyboardWillShow(sender: NSNotification) {
//         self.saveButtonOutlet.frame.origin.y = +450 // Move view 150 points upward
//    }
//
//    @objc func keyboardWillHide(sender: NSNotification) {
//         //self.saveButtonOutlet.frame.origin.y = 0 // Move view to original position
//    }
    
//     @objc func keyboardWillShow(sender: NSNotification) {
//        if let keyboardSize = (sender.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//                    UIView.animate(withDuration: 0.1, animations: { () -> Void in
//                        self.saveButtonOutlet.frame.origin.y -= keyboardSize.height
//                        self.saveButtonOutlet.layoutIfNeeded()
//                    })
//                }
//            }
//
//    @objc func keyboardWillHide(sender: NSNotification) {
//        if let keyboardSize = (sender.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//                UIView.animate(withDuration: 0.1, animations: { () -> Void in
//                    self.saveButtonOutlet.frame.origin.y += keyboardSize.height
//                    self.saveButtonOutlet.layoutIfNeeded()
//                })
//            }
//        }
    
}

extension AddNewExpenceViewController {
    func saveButtonActions() {
        view.endEditing(true)
        validator.validate(self)
    }
}

extension AddNewExpenceViewController: ValidationDelegate{
    func validationSuccessful() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let chooseCategoryViewController: ChooseCategoryViewController = storyboard.instantiateViewController(withIdentifier: "ChooseCategoryViewController") as! ChooseCategoryViewController
        
        chooseCategoryViewController.expencePrice = Int(newExpencesPrice) ?? 0
        chooseCategoryViewController.expenceName = newExpencesName
        chooseCategoryViewController.expenceDate = expenceDate
        navigationController?.pushViewController(chooseCategoryViewController, animated: true)
    }
    
    func validationFailed(_ errors: [(Validatable, ValidationError)]) {
        for (field, error) in errors {
            if let field = field as? UITextField {
                field.layer.borderColor = #colorLiteral(red: 0.598151967, green: 0.167491116, blue: 0.2818549418, alpha: 0.8676155822).withAlphaComponent(1.0).cgColor
                field.layer.borderWidth = 1.0
            }
            error.errorLabel?.text = error.errorMessage // works if you added labels
            error.errorLabel?.textColor = #colorLiteral(red: 0.598151967, green: 0.167491116, blue: 0.2818549418, alpha: 0.8676155822).withAlphaComponent(1.0)
            error.errorLabel?.isHidden = false
        }
    }
}
