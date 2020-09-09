//
//  detailViewController.swift
//  lmnc_prod_tracker
//
//  Created by Ryan Gutierrez on 9/6/20.
//  Copyright © 2020 Ryan Gutierrez. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class detailViewController: UIViewController {
    @IBOutlet weak var checkInButton: UIButton!
    @IBOutlet weak var checkOutButton: UIButton!
    
    @IBOutlet weak var brand: UILabel!
    @IBOutlet weak var model: UILabel!
    @IBOutlet weak var modelNumber: UILabel!
    @IBOutlet weak var project: UILabel!
    
    @IBOutlet weak var currentUser: UILabel!
   // @IBOutlet weak var notes: UILabel!
    @IBOutlet weak var notesTextView: UITextView!
    
    @IBOutlet weak var modelNumLabel: UILabel!
    var brandDel = String()
    var modelDel = String()
    
    var db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        modelNumLabel.numberOfLines = 0
        // Do any additional setup after loading the view.
        checkInButton.titleLabel?.adjustsFontForContentSizeCategory = true
        
        print(brandDel)

        db.collection("products").document(brandDel).getDocument { (document, error) in
            if let document = document, document.exists {
                let brand = document.get("brand") as! String
                 let model = document.get("model") as! String
                 //let prod = brand + " " + model
                 let currentUser = document.get("current user") as! String
                let modelNum = document.get("model number") as! String
                let project = document.get("project") as! String
                let notes = document.get("notes") as! String
                 
                self.brand.text = brand
                self.model.text = model
                self.currentUser.text = currentUser
                self.modelNumber.text = modelNum
                self.project.text = project
                self.notesTextView.text = notes
                
            } else {
                print("Document does not exist")
            }
        }
        
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "checkInSegue" {
            let nextVC = segue.destination as? checkInViewController
            
            nextVC!.notes = notesTextView.text!
            nextVC!.brand = brand.text!
            nextVC!.model = model.text!
        }
    }
    
    
    @IBAction func checkout(_ sender: Any) {
        let db = Firestore.firestore()
        
        db.collection("products").document(brandDel).updateData([
            "current user": "available"
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
        /*_ = navigationController?.popViewController(animated: true)*/
        
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
