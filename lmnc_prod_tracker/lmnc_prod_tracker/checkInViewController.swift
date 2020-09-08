//
//  checkInViewController.swift
//  lmnc_prod_tracker
//
//  Created by Ryan Gutierrez on 9/6/20.
//  Copyright © 2020 Ryan Gutierrez. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class checkInViewController: UIViewController {
    var notes = String()
    var brand = String()
    var model = String()
    
    @IBOutlet weak var notesTextField: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var notesTextView: UITextView!
    
    let db = Firestore.firestore()
    
    @IBAction func checkInButton(_ sender: Any) {
        let date = Date()
        
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .long

        let datetime = formatter.string(from: date)
        
        db.collection("products").document(brand + " " + model).updateData([
            "notes": notesTextView.text!,
            "current user": name.text!,
            "check-in": datetime
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
        let view = "mainScreen"
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
        })
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //notesTextField.text = notes
        // Do any additional setup after loading the view.
        nameLabel.adjustsFontSizeToFitWidth = true
        notesTextView.text = notes
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
