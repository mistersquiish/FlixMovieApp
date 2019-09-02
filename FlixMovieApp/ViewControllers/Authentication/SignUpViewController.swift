//
//  SignUpViewController.swift
//  MovieLemma
//
//  Created by Henry Vuong on 8/22/19.
//  Copyright © 2019 Henry Vuong. All rights reserved.
//

import UIKit
import Firebase

class SignupViewController: UIViewController, UITextFieldDelegate {
    
    
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var signupButtonOutlet: UIButton!
    @IBOutlet weak var formFeedbackLabel: UILabel!
    @IBOutlet weak var signinButtonOutlet: UIButton!
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
        nameTextField.layer.masksToBounds = false
        nameTextField.layer.borderWidth = 0.5
        nameTextField.layer.cornerRadius = 12
        nameTextField.clipsToBounds = true
        signupButtonOutlet.layer.masksToBounds = false
        signupButtonOutlet.layer.cornerRadius = 12
        signupButtonOutlet.clipsToBounds = true
        
        // add oberserver methods to allow keyboard to dismiss
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        // dismiss keyboard if view is tapped
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        // UITextFieldDelegate to dismiss keyboard on return
        passwordTextField.delegate = self
        passwordTextField.returnKeyType = .go
        passwordTextField.tag = 2
        emailTextField.delegate = self
        emailTextField.returnKeyType = .next
        emailTextField.tag = 1
        nameTextField.delegate = self
        nameTextField.returnKeyType = .next
        nameTextField.tag = 0
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // need to add error handling and nil handling
    @IBAction func signupButton(_ sender: Any) {
        if emailTextField.text != "" && passwordTextField.text != "" {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { authResult, error in

                if error == nil {
                    // sign in user
                    Auth.auth().signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) { [weak self] user, error in
                        // update user name
                        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                        changeRequest?.displayName = self!.nameTextField.text!
                        changeRequest?.commitChanges { (error) in
                            // ...
                        }
                        
                        // proceed to next view
                        self!.performSegue(withIdentifier: "InitialReviewSegue", sender: nil)
                    }

                } else {
                    // sign up failed
                }
            }
        }
        
    }
    
    func updateFormFeedback() {
        return
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
    
    // dismiss keyboard when return is hit
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        // Try to find next responder
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            passwordTextField.resignFirstResponder()
            // perform signup button function
            signupButton(self)
        }
        // Do not add a line break
        return false
    }
    
}
