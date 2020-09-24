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
import FirebaseAuth

extension String {
    func capitalizingFirstLetter() -> String {
      return prefix(1).uppercased() + self.lowercased().dropFirst()
    }

    mutating func capitalizeFirstLetter() {
      self = self.capitalizingFirstLetter()
    }
}

class detailViewController: UIViewController, UIPopoverPresentationControllerDelegate, notesPopoverViewControllerDelegate {
    
    
    @IBOutlet weak var checkInButton: UIButton!
    @IBOutlet weak var checkOutButton: UIButton!
    @IBOutlet weak var company: UILabel!
    @IBOutlet weak var model: UILabel!
    @IBOutlet weak var modelNumber: UILabel!
    @IBOutlet weak var project: UILabel!
    
    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var currentUser: UILabel!
   // @IBOutlet weak var notes: UILabel!
    @IBOutlet weak var notesTextView: UITextView!
    
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var currentUserLabel: UILabel!
    @IBOutlet weak var modelNumLabel: UILabel!
    var id = String()
    
    var db = Firestore.firestore()
    
    @IBAction func editNotesButton(_ sender: UIButton) {
        /*let popController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "notesPopoverViewController")*/
        
        let popController = (storyboard?.instantiateViewController(withIdentifier: "notesPopoverViewController")) as! notesPopoverViewController
        
        popController.delegate = self
        popController.notes = notesTextView.text
        popController.product = id
        // set the presentation style
        popController.modalPresentationStyle = UIModalPresentationStyle.popover
        
        popController.preferredContentSize = CGSize(width: self.view.frame.width * 0.4, height: self.view.frame.height * 0.3)

        // set up the popover presentation controller
        popController.popoverPresentationController?.permittedArrowDirections = .down
        popController.popoverPresentationController?.delegate = self
        popController.popoverPresentationController?.sourceView = sender // button
        /*popController.popoverPresentationController?.sourceRect = CGRect(x:sender.bounds.midX, y:sender.bounds.minY,width: 1,height: 1)*/
        
        // present the popover
        self.present(popController, animated: true, completion: nil)
    }
    
    func saveText(var strText: String) {
        notesTextView.text = strText
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        company.adjustsFontSizeToFitWidth = true
        model.adjustsFontSizeToFitWidth = true
        modelNumber.adjustsFontSizeToFitWidth = true
        
        currentUser.adjustsFontSizeToFitWidth = true
        modelNumLabel.adjustsFontSizeToFitWidth = true
        currentUserLabel.adjustsFontSizeToFitWidth = true
        // Do any additional setup after loading the view.
        //checkInButton.titleLabel?.adjustsFontForContentSizeCategory = true
        
        checkInButton.layer.cornerRadius = 3
        checkOutButton.layer.cornerRadius = 3
        
        productLabel.sizeToFit()
        companyLabel.adjustsFontSizeToFitWidth = true
        
        /*
        TRYING TO ADD LOGO CODE
         
        let navController = navigationController!
        
        let logo = UIImage(named: "lumenci_logo.png")
        let imageView = UIImageView(image: logo)
        imageView.frame = CGRect(x: 0, y: 0, width: navController.navigationBar.frame.width * 0.1, height: navController.navigationBar.frame.height * 0.1)
        self.navigationItem.titleView = imageView*/
        
        
        

        db.collection("products").document(id).getDocument { (document, error) in
            if let document = document, document.exists {
                let company = document.get("company") as! String
                 let model = document.get("model") as! String
                 //let prod = brand + " " + model
                 let currentUser = document.get("current user") as! String
                let modelNum = document.get("model number") as! String
                let project = document.get("project") as! String
                let notes = document.get("notes") as! String
                 
                self.company.text = company
                self.model.text = model
                self.productLabel.text = company + " " + model
                self.currentUser.text = currentUser
                self.modelNumber.text = modelNum
                self.project.text = project
                self.notesTextView.text = notes
                
            } else {
                print("Document does not exist")
            }
        }
        
        
        
    }
    
    
    @IBAction func checkin(_ sender: Any) {
        let date = Date()
        
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .long

        let datetime = formatter.string(from: date)
        
        let user = Auth.auth().currentUser!.email
        
        
        let components = user!.components(separatedBy: "@")
        let nameComponents = components[0].components(separatedBy: ".")
        
        let firstName = nameComponents[0].capitalizingFirstLetter()
        let lastName = nameComponents[1].capitalizingFirstLetter()
        
        let fullUserName = firstName + " " + lastName
        
        db.collection("products").document(id).updateData([
            "notes": notesTextView.text!,
            "current user": fullUserName,
            "check-in": datetime
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
        if self.presentingViewController != nil {
            self.dismiss(animated: false, completion: {
               self.navigationController!.popViewController(animated: true)
            })
        }
        else {
            self.navigationController!.popViewController(animated: true)
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
    }
    
    
    @IBAction func checkout(_ sender: Any) {
        let db = Firestore.firestore()
        
        db.collection("products").document(id).updateData([
            "current user": "available"
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
        
        if self.presentingViewController != nil {
            self.dismiss(animated: false, completion: {
               self.navigationController!.popViewController(animated: true)
            })
        }
        else {
            self.navigationController!.popViewController(animated: true)
        }
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
