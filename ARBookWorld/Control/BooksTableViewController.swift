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
    
    let bookNames = ["History", "Biology"]
    
    var tableCellIndex: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        logOut()
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
    
    
    // Add this for specific text book.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ViewController
        
        if let index = tableCellIndex {
            destinationVC.navTitle = bookNames[index]
        }
    }
    
    func logOut() {
        do {
            try Auth.auth().signOut()
//
//            navigationController?.popToRootViewController(animated: true)
        }
        catch {
            print("Error: there was a problem  signing out")
        }
    }

}