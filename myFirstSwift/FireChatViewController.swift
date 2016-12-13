//
//  FireChatViewController.swift
//  myFirstSwift
//
//  Created by tiennguyen on 12/12/16.
//  Copyright © 2016 tiennguyen. All rights reserved.
//

import UIKit
import SnapKit
import Firebase

class FireChatViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate,
UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var ref: FIRDatabaseReference!
    var messages: [FIRDataSnapshot]! = []
    var msglength: NSNumber = 10
    fileprivate var _refHandle: FIRDatabaseHandle!
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        
        return tableView
    }()
    
    private let txtMessage: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 8
        textField.layer.borderWidth = 1
        textField.placeholder = "Hello world"
        return textField
    }()
    
    private let btnSend: UIButton = {
        let button = UIButton()
        button.setTitle("Send", for: UIControlState.normal)
        button.setTitleColor(UIColor.white, for: UIControlState.normal)
        button.backgroundColor = UIColor.blue
        button.layer.cornerRadius = 8
        return button
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let btnLogout: UIBarButtonItem = UIBarButtonItem()
        navigationItem.rightBarButtonItem = btnLogout
        btnLogout.title = "SignOut"
        btnLogout.target = self
        btnLogout.action = #selector(signOut(_:))
    }
    
    func signOut(_ sender: UIButton) {
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
            AppState.sharedInstance.signedIn = false
            let _ = navigationController?.popViewController(animated: true)
        } catch let signOutError as NSError {
            print ("Error signing out: \(signOutError.localizedDescription)")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.view).offset(44)
            make.left.equalTo(self.view).offset(33)
            make.right.equalTo(self.view).offset(-33)
            make.height.equalTo(333)
        }
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "tableViewCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.view.addSubview(txtMessage)
        txtMessage.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.tableView.snp.bottom).offset(22)
            make.left.equalTo(self.view).offset(33)
            make.right.equalTo(self.view).offset(-133)
            make.height.equalTo(33)
        }
        txtMessage.delegate = self
        
        self.view.addSubview(btnSend)
        btnSend.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.tableView.snp.bottom).offset(22)
            make.left.equalTo(self.txtMessage.snp.right).offset(11)
            make.right.equalTo(self.view).offset(-33)
            make.height.equalTo(33)
        }
        btnSend.addTarget(self, action: #selector(didSendMessage(_:)), for: .touchUpInside)
        
        configureDatabase()
        configureStorage()
        configureRemoteConfig()
        fetchConfig()
        loadAd()
        logViewLoaded()
    }

    deinit {
        self.ref.child("messages").removeObserver(withHandle: _refHandle)
    }
    
    func configureDatabase() {
        ref = FIRDatabase.database().reference()
        // Listen for new messages in the Firebase database
        _refHandle = self.ref.child("messages").observe(.childAdded, with: { [weak self] (snapshot) -> Void in
            guard let strongSelf = self else { return }
            strongSelf.messages.append(snapshot)
            strongSelf.tableView.insertRows(at: [IndexPath(row: strongSelf.messages.count-1, section: 0)], with: .automatic)
        })
    }
    
    func configureStorage() {
    }
    
    func configureRemoteConfig() {
    }
    
    func fetchConfig() {
    }
    
    func didPressFreshConfig(_ sender: AnyObject) {
        fetchConfig()
    }
    
    func didSendMessage(_ sender: UIButton) {
        let _ = textFieldShouldReturn(txtMessage)
    }
    
    func didPressCrash(_ sender: AnyObject) {
        fatalError()
    }
    
    func logViewLoaded() {
    }
    
    func loadAd() {
    }
    
    // UITableViewDataSource protocol methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue cell
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath)
        // Unpack message from Firebase DataSnapshot
        let messageSnapshot: FIRDataSnapshot! = self.messages[indexPath.row]
        let message = messageSnapshot.value as! Dictionary<String, String>
        let name = message[Constants.MessageFields.name] as String!
        let text = message[Constants.MessageFields.text] as String!
        cell.textLabel?.text = name! + ": " + text!
        cell.imageView?.image = UIImage(named: "ic_account_circle")
        if let photoURL = message[Constants.MessageFields.photoURL], let URL = URL(string: photoURL), let data = try? Data(contentsOf: URL) {
            cell.imageView?.image = UIImage(data: data)
        }
        return cell
    }
    
    // UITextViewDelegate protocol methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else { return true }
        textField.text = ""
        view.endEditing(true)
        let data = [Constants.MessageFields.text: text]
        sendMessage(withData: data)
        return true
    }
    
    func sendMessage(withData data: [String: String]) {
        var mdata = data
        mdata[Constants.MessageFields.name] = AppState.sharedInstance.displayName
        if let photoURL = AppState.sharedInstance.photoURL {
            mdata[Constants.MessageFields.photoURL] = photoURL.absoluteString
        }
        // Push data to Firebase Database
        self.ref.child("messages").childByAutoId().setValue(mdata)
    }

}
