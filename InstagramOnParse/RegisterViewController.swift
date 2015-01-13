//
//  RegisterViewController.swift
//  InstagramOnParse
//
//  Created by Peter Hitchcock on 1/13/15.
//  Copyright (c) 2015 Peter Hitchcock. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate {


    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func registerAccountButtonPressed(sender: AnyObject) {
        var user = PFUser()
        user.email = userEmailTextField.text
        user.username = usernameTextField.text
        user.password = passwordTextField.text

        user.signUpInBackgroundWithBlock { (success: Bool, error: NSError!) -> Void in
            if error != nil {
                println("error")
            } else {
                self.performSegueWithIdentifier("signupSegue", sender: self)
            }
        }

    }

    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        view.endEditing(true)
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        userEmailTextField.resignFirstResponder()
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }

}
