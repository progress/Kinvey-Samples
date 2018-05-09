//
//  LoginViewController.swift
//  LoginScreen
//
//  Created by Florian Marcu on 1/15/17.
//  Copyright © 2017 iOS App Templates. All rights reserved.
//

import UIKit
import Kinvey

class LoginViewController: UIViewController {


    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!

   @IBAction func didTapLoginButton(_ sender: LoginButton) {
        // Regular login attempt. Add the code to handle the login by email and password.
        guard let email = usernameTextField.text, let pass = passwordTextField.text else {
            // It should never get here
            return
        }
    

    Kinvey.User.login(username: usernameTextField.text!, password: passwordTextField.text!) { user, error in
        
        if let _ = user {
                print("User: \(String(describing: user))")
                self.performSegue(withIdentifier: "navigateToDashboard", sender: sender)
            } else {
                 print("Error: \(String(describing: error))")
                 let alert = UIAlertController(title: "Login Failed", message: "Incorrect username or password", preferredStyle: UIAlertControllerStyle.alert)
                 alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: nil))
                 self.present(alert, animated: true, completion: nil)
            }
        }
    
    }

    @IBAction func didTapFacebookLoginButton(_ sender: FacebookLoginButton) {
        // Facebook login attempt
    }

    @IBAction func didTapTwitterLoginButton(_ sender: TwitterLoginButton) {
        // Twitter login attempt
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }

//    private func didLogin(method: String, info: String) {
    
//        let alert = UIAlertController(title: "Success", message: message, preferredStyle: UIAlertControllerStyle.alert)
//        alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: nil))
//        self.present(alert, animated: true, completion: nil)
//    }
}
