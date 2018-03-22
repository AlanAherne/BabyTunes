//
//  LoginViewController.swift
//  BabyTunes
//
//  Created by Alan Aherne on 04.03.18.
//  Copyright © 2018 CCDimensions. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    
    // MARK: - Properties
    let showDetailSegueIdentifier = "loginSuccessful"
    
    // MARK: - IBOutlets
    @IBOutlet weak var txtUser: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnSignUp: UIButton!
    
    var swipeInteractionController: SwipeInteractionController?
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        
        if let user = PFUser.current(), user.isAuthenticated {
            performSegue(withIdentifier: showDetailSegueIdentifier, sender: self)
        }
        self.initEmitter()
        
        swipeInteractionController = SwipeInteractionController(viewController: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        txtUser.text = ""
        txtPassword.text = ""
    }
    
    func validateUserEntry() -> Bool {
        
        var valid = true
        var message = ""
        if txtUser.text == "" {
            valid = false
            message = "Please enter a username."
        } else if txtPassword.text == "" {
            valid = false
            message = "Please enter a password."
        }
        
        if !valid {
            let alert = UIAlertController(title: "Invalid Login", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
            return false
        }
        
        return true
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = .white
    }
    
    // MARK: - IBActions
    @IBAction func btnLogInPressed(_ sender: UIButton) {
        guard validateUserEntry() else { return }
        
        btnLogin.isEnabled = false
        btnSignUp.isEnabled = false
        PFUser.logInWithUsername(inBackground: txtUser.text!, password:txtPassword.text!) {
            [unowned self]  (user, error) in
            if user != nil {
                self.performSegue(withIdentifier: self.showDetailSegueIdentifier, sender: self)
            } else {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true)
            }
            
            self.btnLogin.isEnabled = true
            self.btnSignUp.isEnabled = true
        }
    }
    
    @IBAction func btnSignUpPressed(_ sender: UIButton) {
        guard validateUserEntry() else { return }
        
        let user = PFUser()
        user.username = txtUser.text
        user.password = txtPassword.text
        
        btnLogin.isEnabled = false
        btnSignUp.isEnabled = false
        user.signUpInBackground { [unowned self] (success, error) in
            if success {
                self.performSegue(withIdentifier: self.showDetailSegueIdentifier, sender: self)
            } else {
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel))
                self.present(alertController, animated: true)
            }
            
            self.btnLogin.isEnabled = true
            self.btnSignUp.isEnabled = true
        }
    }
    
    @IBAction func dismissPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

