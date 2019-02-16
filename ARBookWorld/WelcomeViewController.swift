//
//  WelcomeViewController.swift
//  ARBookWorld
//
//  Created by Mehmet Sahin on 2/16/19.
//  Copyright © 2019 Mehmet Sahin. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))

        view.addGestureRecognizer(tap)
    }
    

    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        
        // if firebase, then perform segue
        
        performSegue(withIdentifier: "toMyBooks", sender: self)
    }
    
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        
        SVProgressHUD.show()
        
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) {
            (result, error) in
            
            if error != nil {
                print("Error: \(error!)")
            }
            else {
                print("Registration succesful")
                
                SVProgressHUD.dismiss()
                
                self.emailTextField.text = ""
                self.passwordTextField.text = ""
                
                self.performSegue(withIdentifier: "toMyBooks", sender: self)
            }
        }
    }
    
}
