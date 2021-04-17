//
//  LoginViewController.swift
//  On The Map
//
//  Created by Kostas Lei on 05/04/2021.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButtonShape: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loginButtonShape.layer.cornerRadius = 5
        emailTextField.text = ""
        passwordTextField.text = ""        
    }
    
    // LOGIN BUTTON: Uses the login function and the handlerLogin function as a completion handler
    @IBAction func logInButtonAction(_ sender: Any) {
        setLogingIn(true)
        UdacityAPI.login(username: emailTextField.text!, password: passwordTextField.text!, completion: handlerLogin(success:Error:))
    }
    
    // HANDLER_LOGIN FUNC: If the login is success then trasfear modally to the UITabBarController, else
    // pops an allert view which warns the user about the error
    func handlerLogin(success: Bool, Error: Error?) {
        if success {
            setLogingIn(false)
            let vc = (storyboard?.instantiateViewController(identifier: "mainTC"))! as UITabBarController
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
            emailTextField.text = ""
            passwordTextField.text = ""
            UdacityAPI.getUsersData()
        }
        else {
            showLoginFailure(message: Error?.localizedDescription ?? "")
            setLogingIn(false)
        }
    }
    
    // SHOW_LOGIN_FAILURE FUNC: Pops an alert with the error message
    func showLoginFailure(message: String) {
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
    
    // transfear to safari
    @IBAction func signUpButton(_ sender: Any) {
        UIApplication.shared.open(OTMClient.Endpoints.signUp.url, options: [:], completionHandler: nil)
    }
    
    // SET_LOGING_IN FUNC: Starts, stops the activityIndicator and enables/disables the textFields
    func setLogingIn(_ logingIn:Bool) {
        logingIn ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        emailTextField.isEnabled = !logingIn
        passwordTextField.isEnabled = !logingIn
        loginButtonShape.isEnabled = !logingIn
    }
}
