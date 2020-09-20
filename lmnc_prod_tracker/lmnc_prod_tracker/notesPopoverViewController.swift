//
//  notesPopoverViewController.swift
//  lmnc_prod_tracker
//
//  Created by Ryan Gutierrez on 9/9/20.
//  Copyright © 2020 Ryan Gutierrez. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

protocol notesPopoverViewControllerDelegate
{
    func saveText(var strText : String)
}

class notesPopoverViewController: UIViewController {
    var db = Firestore.firestore()
    var delegate : notesPopoverViewControllerDelegate?
    @IBOutlet weak var textView: UITextView!
    var notes: String!
    var product: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.textView.becomeFirstResponder()
        // Do any additional setup after loading the view.
        textView.text = notes
    }
    
    @IBAction func done(_ sender: Any) {
        db.collection("products").document(product).updateData([
            "notes": textView.text!
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
        if (self.delegate) != nil
            {
                delegate?.saveText(var: textView.text)
                self.dismiss(animated: true, completion: nil)
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
