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
    
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var stackView1: UIStackView!
    @IBOutlet weak var modelNumLabel: UILabel!
    @IBOutlet weak var modelTextField: UITextField!
    @IBOutlet weak var modelNumTextField: UITextField!
    
    
    @IBOutlet weak var projectTextField: UITextField!
    @IBOutlet weak var addNotesTextField: UITextField!
    
    var db = Firestore.firestore()
    
    @IBAction func addButton(_ sender: Any) {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .long

        let datetime = formatter.string(from: date)
        
        db.collection("products").document(brandTextField.text! + " " + modelTextField.text!).setData([
            "brand": brandTextField.text!,
            "model": modelTextField.text!,
            "model number": modelNumTextField.text!,
            "project": projectTextField.text!,
            "notes": addNotesTextField.text!,
            "current user": "available",
            "added": datetime
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        productInfoLabel.adjustsFontSizeToFitWidth = true
        productInfoLabel.sizeToFit()
        
        mainStackView.sizeToFit()
        
        modelNumLabel.adjustsFontSizeToFitWidth = true
        
        
        
       
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
