//
//  ChatViewController.swift
//  ParseChat
//
//  Created by Guanxin Li on 2/22/18.
//  Copyright © 2018 Guanxin. All rights reserved.
//

import UIKit
import Parse

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    


    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    //var chatMessage = PFObject(className: "Message")
    var chatMessage: [PFObject]!
    @IBAction func sendButton(_ sender: UIButton) {
        sender.isSelected = true
        let sendObject = PFObject(className: "Message")
        sendObject["text"] = messageTextField.text ?? ""
        sendObject["user"] = PFUser.current()!
        sendObject.saveInBackground { (success, error) in
            if success {
                print("The message was saved!")
                self.messageTextField.text = ""
                
            } else if let error = error {
                print("Problem saving message: \(error.localizedDescription)")
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ChatViewController.onTimer), userInfo: nil, repeats: true)
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatMessage?.count ?? 0
    }
    
    
    @objc func onTimer() {
        print("In the onTimer method")
        let query = PFQuery(className: "Message")
        query.addDescendingOrder("createdAt")
        
        // fetch data asynchronously
        query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) in
            if let posts = posts {
                self.chatMessage = posts
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else {
                print("\(error?.localizedDescription)")
            }
        }
    }

    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatCell
        let messages = chatMessage[indexPath.row]
        
        if let msgString = messages["text"] as? String {
            print("The message string is: \(msgString)")
            cell.messageLabel.text = msgString
        }
        
        if let user = messages["user"] as? String {
            print("The user is: \(user)")
            cell.usernameLabel.text = user
        } else {
            // No user found, set default username
            cell.usernameLabel.text = "🤖"
        }
        return cell
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

