//
//  ViewController.swift
//  ParseChat
//
//  Created by Guanxin Li on 2/20/18.
//  Copyright © 2018 Guanxin. All rights reserved.
//
import UIKit
import Parse

class ViewController: UIViewController {

    
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var passwordTextView: UITextField!
    @IBOutlet weak var usernameTextView: UITextField!
    @IBAction func loginButton(_ sender: UIButton) {
        sender.isSelected = true
        loginUser()
    }
    @IBAction func signupButton(_ sender: UIButton) {
        sender.isSelected = true
        registerUser()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func registerUser() {
        // initialize a user object
        let newUser = PFUser()
        
        // set user properties
        newUser.username = usernameTextView.text
        newUser.password = passwordTextView.text
        // Check if the username or the password is empty
        if ((newUser.username?.isEmpty)! || (newUser.password?.isEmpty)!) {
            let alertController = UIAlertController(title: "Title", message: "Message", preferredStyle: .alert)
            // create a cancel action
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                self.loginButton.isHighlighted = false
                self.signupButton.isHighlighted = false
            }
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true) {
                print("in here")
                self.loginButton.isHighlighted = false
                self.signupButton.isHighlighted = false
            }
        }
        
        // call sign up function on the object
        newUser.signUpInBackground { (success: Bool, error: Error?) in
            if let error = error {
                
                print(error.localizedDescription)
            } else {
                print("User Registered successfully")
                // manually segue to logged in view
            }
        }
    }
    
    func loginUser() {
        
        let username = usernameTextView.text ?? ""
        let password = passwordTextView.text ?? ""
        
        PFUser.logInWithUsername(inBackground: username, password: password) { (user: PFUser?, error: Error?) in
            if let error = error {
                print ("Error is in here")
                print("User log in failed: \(error.localizedDescription)")
            } else {
                print("User logged in successfully")
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
                // display view controller that needs to shown after successful login
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

