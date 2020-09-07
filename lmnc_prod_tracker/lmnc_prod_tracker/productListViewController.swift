//
//  ViewController.swift
//  lmnc_prod_tracker
//
//  Created by Ryan Gutierrez on 9/5/20.
//  Copyright © 2020 Ryan Gutierrez. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

/*struct RowDisplay{
    var product: String
    var currUser: String
    
    init(product: String, currUser: String) {
        self.product = product
        self.currUser = currUser
    }
}*/


class productListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productListCell", for: indexPath) as! productListTableViewCell
        let row = indexPath.row
        
        cell.product?.text = products[row]
        cell.currUser?.text = users[row]
        
        cell.product.adjustsFontSizeToFitWidth = true
        cell.currUser.adjustsFontSizeToFitWidth = true
        
        
        return cell
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var addButton: UIButton!
    var products = [String]()
    var users = [String]()
    
    var db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        addButton.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
        tableView.delegate = self
        tableView.dataSource = self
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let selectedIndex = tableView.indexPath(for: sender as! UITableViewCell)
        let row = selectedIndex?.row
        if segue.identifier == "detailVCSegue" {
            let nextVC = segue.destination as? detailViewController
            nextVC!.brandDel = products[row!]
            nextVC!.modelDel = users[row!]
        }
    }
    
   
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        db.collection("products").getDocuments(){
             (querySnapshot, err) in
                 if let err = err {
                     print("Error getting documents: \(err)")
                 } else {
                     var product = [String]()
                     var user = [String]()
            
                     for document in querySnapshot!.documents {
                         let brand = document.get("brand") as! String
                         let model = document.get("model") as! String
                         let prod = brand + " " + model
                         let currentUser = document.get("current user") as! String
                         
                         product.append(prod)
                         user.append(currentUser)
                         self.products = product
                         self.users = user
                         self.tableView.reloadData()
                         
                     }
                   
                 }
            
                 }
    }


}

