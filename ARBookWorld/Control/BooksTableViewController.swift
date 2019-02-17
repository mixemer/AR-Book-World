//
//  BooksTableViewController.swift
//  ARBookWorld
//
//  Created by Mehmet Sahin on 2/16/19.
//  Copyright © 2019 Mehmet Sahin. All rights reserved.
//

import UIKit
import Firebase

class BooksTableViewController: UITableViewController {
    
    var bookNames = [String]()
    
    var tableCellIndex: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        
        retrieveBookNames()
    }
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookNames.count
    }

    
    // MARK: - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath)

        cell.textLabel?.text = bookNames[indexPath.row]
        cell.textLabel?.font = UIFont.init(name: "Helvetica", size: 22)
        
        return cell
    }
    
    // MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        tableCellIndex = indexPath.row
        
        performSegue(withIdentifier: "toAR", sender: self)
    }
    
    func retrieveBookNames() {
        let bookDB = Database.database().reference().child("books")
        
        bookDB.observe(.childAdded)
        { (snapshot) in
            let value = snapshot.value as! Dictionary<String, String>
            let bookName = value["Name"]!
            
            self.bookNames.append(bookName)
            self.tableView.reloadData()
        }
        
    }
    
    @IBAction func addBarButtonTapped(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) {
            (alertAction) in
            
            let bookNameDB = Database.database().reference().child("books")
            let nameDictionary = ["Name": textField.text!]
            
            bookNameDB.childByAutoId().setValue(nameDictionary) {
                (error, database) in
                
                if error != nil {
                    print("Error: \(error!)")
                }
                else {
                    print("Book name succesful")
                }
                
            }
            
        }
        
        alert.addTextField { (field) in
            textField = field
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    
    // Add this for specific text book.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ViewController
        
        if let index = tableCellIndex {
            destinationVC.navTitle = bookNames[index]
        }
    }
    
    @IBAction func logOutBarButtonTapped(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            tabBarController?.dismiss(animated: true, completion: nil)
        }
        catch {
            print("Error: there was a problem  signing out")
        }
    }
}
