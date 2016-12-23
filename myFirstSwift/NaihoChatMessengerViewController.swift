//
//  NaihoChatMessengerViewController.swift
//  myFirstSwift
//
//  Created by tiennguyen on 12/16/16.
//  Copyright © 2016 tiennguyen. All rights reserved.
//

import UIKit
import Firebase

class NaihoChatMessengerViewController: BaseViewController {
    
    private var ref = FIRDatabase.database().reference()
    private lazy var userChatGroupsRef: FIRDatabaseReference = self.ref.child("/users/\(self.user.id)/chat_groups")
    private var userChatGroupsRefHandle: FIRDatabaseHandle?
    var userChatGroups = [NaihoChatMessengerModel]()
    
    private let tableView = UITableView()
    
    var user = NaihoUserModel(id: "229")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NaihoChatMessengerTableViewCell.self, forCellReuseIdentifier: NaihoChatMessengerTableViewCell.Identifier)
        tableView.frame = self.view.frame
        self.view.addSubview(tableView)
        
        loginAsAnonymously()
    }
    
    deinit {
        if let refHandle = userChatGroupsRefHandle {
            self.userChatGroupsRef.removeObserver(withHandle: refHandle)
        }
    }
    
    func loginAsAnonymously() {
        FIRAuth.auth()?.signInAnonymously(completion: { (user, error) in
            if let err:Error = error {
                print(err.localizedDescription)
                return
            }
            
            self.configureDatabase()
        })
    }
    
    func configureDatabase() {
        self.userChatGroupsRefHandle = self.userChatGroupsRef.observe(.childAdded, with: { [weak self] (snapshot) -> Void in
            guard let strongSelf = self else { return }
            print("----sn:", snapshot)
            strongSelf.userChatGroups.append(NaihoChatMessengerModel(snapshot: snapshot))
            strongSelf.tableView.insertRows(at: [IndexPath(row: strongSelf.userChatGroups.count - 1, section: 0)], with: .automatic)
        })
    }
}

extension NaihoChatMessengerViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userChatGroups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NaihoChatMessengerTableViewCell.Identifier, for: indexPath) as! NaihoChatMessengerTableViewCell
        cell.textLabel?.text = self.userChatGroups[indexPath.row].id
        return cell
    }
}
