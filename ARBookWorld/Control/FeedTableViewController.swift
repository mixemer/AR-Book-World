//
//  FeedTableViewController.swift
//  ARBookWorld
//
//  Created by Mehmet Sahin on 2/16/19.
//  Copyright © 2019 Mehmet Sahin. All rights reserved.
//

import UIKit
import Firebase

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
            
//            let newFeed = FeedMessage()
//            newFeed.message = textField.text!
//            newFeed.userName = "Test"
//
//            self.feedArray.append(newFeed)
//            self.tableView.reloadData()
            
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

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
