//
//  FeedTableViewController.swift
//  ARBookWorld
//
//  Created by Mehmet Sahin on 2/16/19.
//  Copyright © 2019 Mehmet Sahin. All rights reserved.
//

import UIKit
import Firebase
import ChameleonFramework

class FeedTableViewController: UITableViewController {
    
    var feedArray = [FeedMessage]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "CustomFeed", bundle: nil), forCellReuseIdentifier: "customFeedCell")
        configureTableView()
        retrieveMessages()
        
        tableView.separatorStyle = .none
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedArray.count
    }
    
    //TODO: Declare configureTableView here:
    func configureTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 125.0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customFeedCell", for: indexPath) as! CustomFeed
        
        cell.messageBody.text = feedArray[indexPath.row].message
        cell.senderUsername.text = feedArray[indexPath.row].userName
        let color1 = UIColor.flatMint()
        let color2 = UIColor.flatWatermelon()
        
        if cell.senderUsername.text == Auth.auth().currentUser?.email as String! {
            cell.messageBackground.backgroundColor = color1
            cell.avatarImageView.backgroundColor = color1
        }
        else {
            cell.avatarImageView.backgroundColor = color2
            cell.messageBackground.backgroundColor = color2
        }
        
        cell.avatarImageView.image = UIImage(named: "egg")

        return cell
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
    
    
    @IBAction func addBarButtonTapped(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add a new feed", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let feedDB = Database.database().reference().child("Feeds")
            let feedDictonary = ["Sender":Auth.auth().currentUser?.email, "Feed":textField.text!]
            
            feedDB.childByAutoId().setValue(feedDictonary) {
                (error, database) in
                
                if error != nil {
                    print("Error: \(error!)")
                }
                else {
                    print("Feed saved succesfully")
                }
            }
        }
        
        alert.addTextField { (field) in
            textField = field
        }
        
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    func retrieveMessages() {
        let feedDB = Database.database().reference().child("Feeds")
        
        feedDB.observe(.childAdded) {
            (snapshot) in
            let value = snapshot.value as! Dictionary<String, String>
            let feedValue = value["Feed"]!
            let senderValue = value["Sender"]!
            
            let feed = FeedMessage()
            feed.message = feedValue
            feed.userName = senderValue
            
            self.feedArray.append(feed)
            self.configureTableView()
            self.tableView.reloadData()
        }
    }

}
