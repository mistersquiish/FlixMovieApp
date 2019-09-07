//
//  LoginViewController.swift
//  MovieLemma
//
//  Created by Henry Vuong on 8/22/19.
//  Copyright © 2019 Henry Vuong. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate  {
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButtonOutlet: UIButton!
    @IBOutlet weak var signupOutlet: UIButton!
    @IBOutlet weak var formFeedbackLabel: UILabel!
    // Contraints for animations
    @IBOutlet weak var TopConstraintLogo: NSLayoutConstraint!
    @IBOutlet weak var BottomConstraintLogo: NSLayoutConstraint!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // UI settings
        formFeedbackLabel.alpha = 0
        emailTextField.layer.masksToBounds = false
        emailTextField.layer.borderWidth = 0.5
        emailTextField.layer.cornerRadius = 12
        emailTextField.clipsToBounds = true
        passwordTextField.layer.masksToBounds = false
        passwordTextField.layer.borderWidth = 0.5
        passwordTextField.layer.cornerRadius = 12
        passwordTextField.clipsToBounds = true
        loginButtonOutlet.layer.masksToBounds = false
        loginButtonOutlet.layer.cornerRadius = 12
        loginButtonOutlet.clipsToBounds = true
        loginButtonOutlet.backgroundColor = ColorScheme.grayColor
        loginButtonOutlet.setTitleColor( ColorScheme.goldColor, for: .normal)
        view.backgroundColor = ColorScheme.grayColor2
        signupOutlet.tintColor = ColorScheme.goldColor
        
        // add oberserver methods to allow keyboard to dismiss
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        // dismiss keyboard if view is tapped
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        // UITextFieldDelegate to dismiss keyboard on return and next textfield
        passwordTextField.delegate = self
        passwordTextField.returnKeyType = .go
        emailTextField.delegate = self
        emailTextField.returnKeyType = .next
        emailTextField.tag = 0
        passwordTextField.tag = 1
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButton(_ sender: Any) {
        if emailTextField.text != "" && passwordTextField.text != "" {
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { [weak self] user, error in
                if error == nil {
                    self!.performSegue(withIdentifier: "HomeSegue", sender: nil)
                } else {
                    // update form feedback. "login failed"
                    self?.formFeedbackLabel.text = "error"
                    self?.formFeedbackLabel.alpha = 1
                }
            }
        }
        
    }
    
    func updateFormFeedback() {

    }
    
    // methods for keyboard
    @objc func keyboardWillShow(notification: NSNotification) {
        self.TopConstraintLogo.constant = 15
        self.BottomConstraintLogo.constant = 15
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 3, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        self.TopConstraintLogo.constant = 60
        self.BottomConstraintLogo.constant = 30
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 3, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        // Try to find next responder
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            passwordTextField.resignFirstResponder()
            // perform login button function
            loginButton(self)
        }
        // Do not add a line break
        return false
    }
    
    
    
}
