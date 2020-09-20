//
//  loginViewController.swift
//  lmnc_prod_tracker
//
//  Created by Ryan Gutierrez on 9/9/20.
//  Copyright © 2020 Ryan Gutierrez. All rights reserved.
//

import UIKit
import Firebase

class loginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var pwLabel: UILabel!
    
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var loginButtonOutlet: UIButton!
    
    @IBOutlet weak var logoStackView: UIStackView!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBAction func loginButton(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
           if error == nil{
             self.performSegue(withIdentifier: "loginSegue", sender: self)
                          }
            else{
             let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
             let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                            
              alertController.addAction(defaultAction)
              self.present(alertController, animated: true, completion: nil)
                 }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        
        view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        emailTextField.autocorrectionType = .no
        
        loginButtonOutlet.layer.cornerRadius = 7
        subView.layer.cornerRadius = 10
        
        emailLabel.adjustsFontSizeToFitWidth = true
        pwLabel.adjustsFontSizeToFitWidth = true
        
    
        imageView.frame = CGRect(x: 0, y: 0, width: logoStackView.bounds.width, height: logoStackView.bounds.height)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        emailTextField.text = ""
        passwordTextField.text = ""
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if passwordTextField.isEditing{
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y == 0 {
                    self.view.frame.origin.y -= keyboardSize.height
                }
            }
            
        }
            
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    

    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "skipSegue"{
            Auth.auth().signIn(withEmail: "ryan.gutierrez@lumenci.com", password: "lumen1")
        }
    }*/
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
