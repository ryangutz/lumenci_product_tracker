//
//  addProductViewController.swift
//  lmnc_prod_tracker
//
//  Created by Ryan Gutierrez on 9/6/20.
//  Copyright © 2020 Ryan Gutierrez. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class addProductViewController: UIViewController {
    
    @IBOutlet weak var productInfoLabel: UILabel!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var brandTextField: UITextField!
    @IBOutlet weak var modelLabel: UILabel!
    
    //@IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var upperStackView: UIStackView!
    
    @IBOutlet weak var modelNumLabel: UILabel!
    @IBOutlet weak var modelTextField: UITextField!
    @IBOutlet weak var modelNumTextField: UITextField!
    
    
    @IBOutlet weak var projectTextField: UITextField!
    //@IBOutlet weak var addNotesTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    
    var db = Firestore.firestore()
    
    @IBAction func addButton(_ sender: Any) {
        let productID = random()
        
        let date = Date()
        
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .long

        let datetime = formatter.string(from: date)
        
        db.collection("products").document(productID).setData([
            "productID": productID,
            "brand": brandTextField.text!,
            "model": modelTextField.text!,
            "model number": modelNumTextField.text!,
            "project": projectTextField.text!,
            "notes": notesTextView.text!,
            "current user": "available",
            "added": datetime,
            "check-in": ""
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
        
        /*let view = "mainScreen"
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: view)

        window.rootViewController = vc

        let options: UIView.AnimationOptions = .transitionFlipFromLeft

        let duration: TimeInterval = 0.8

        UIView.transition(with: window, duration: duration, options: options, animations: {}, completion:
        { completed in
            // maybe do something on completion here
        })*/
        if self.presentingViewController != nil {
            self.dismiss(animated: false, completion: {
               self.navigationController!.popViewController(animated: true)
            })
        }
        else {
            self.navigationController!.popViewController(animated: true)
        }
        
    }
    
    func random(length: Int = 6) -> String {
        let base = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        var randomString: String = ""

        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.count))
            randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
        }
        return randomString
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        
        view.addGestureRecognizer(tap)

        // Do any additional setup after loading the view.
        
        productInfoLabel.adjustsFontSizeToFitWidth = true
        productInfoLabel.sizeToFit()
        
        //stackView.sizeToFit()
        //upperStackView.sizeToFit()
        
        modelNumLabel.adjustsFontSizeToFitWidth = true
        
        notesTextView.text = ""
        
        //brandLabel.adjustsFontSizeToFitWidth = true
        //brandTextField.adjustsFontSizeToFitWidth = true
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
        
       
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if projectTextField.isEditing || notesTextView.isFirstResponder{
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
