//
//  ChatLoginViewController.swift
//  myFirstSwift
//
//  Created by tiennguyen on 12/12/16.
//  Copyright © 2016 tiennguyen. All rights reserved.
//

import UIKit
import SnapKit
import Firebase

class FireChatLoginViewController: UIViewController {
    
    private let lbTitle: UILabel = {
        let label = UILabel()
        label.text = "FireChat"
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.1
        label.numberOfLines = 0
//        label.font = UIFont.systemFont(ofSize: 118)
        label.lineBreakMode = NSLineBreakMode.byTruncatingTail
        return label
    }()
    
    private let txtEmail: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 8
        textField.layer.borderWidth = 1
        textField.placeholder = "Email"
        return textField
    }()

    
    private let txtPassword: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 8
        textField.layer.borderWidth = 1
        textField.placeholder = "Password"
        return textField
    }()
    
    private let btnLogin: UIButton = {
        let button = UIButton()
        button.setTitle("Sign In", for: UIControlState.normal)
        button.setTitleColor(UIColor.white, for: UIControlState.normal)
        button.backgroundColor = UIColor.blue
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let btnForgetPassword: UIButton = {
        let button = UIButton()
        button.setTitle("Forget Password", for: UIControlState.normal)
        button.setTitleColor(UIColor.white, for: UIControlState.normal)
        button.backgroundColor = UIColor.clear
        return button
    }()
    
    private let btnRegister: UIButton = {
        let button = UIButton()
        button.setTitle("Create Account", for: UIControlState.normal)
        button.setTitleColor(UIColor.blue, for: UIControlState.normal)
        button.backgroundColor = UIColor.clear
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.orange

        // Do any additional setup after loading the view.
        self.view.addSubview(lbTitle)
        lbTitle.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.view).offset(111)
            make.left.equalTo(self.view).offset(33)
            make.right.equalTo(self.view).offset(-33)
            make.height.equalTo(133)
        }
        lbTitle.backgroundColor = UIColor.gray
        
        self.view.addSubview(txtEmail)
        txtEmail.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(lbTitle.snp.bottom).offset(33)
            make.left.equalTo(self.view).offset(33)
            make.right.equalTo(self.view).offset(-33)
            make.height.equalTo(33)
        }
        
        self.view.addSubview(txtPassword)
        txtPassword.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(txtEmail.snp.bottom).offset(5)
            make.left.equalTo(self.view).offset(33)
            make.right.equalTo(self.view).offset(-33)
            make.height.equalTo(33)
        }
        
        self.view.addSubview(btnLogin)
        btnLogin.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(txtPassword.snp.bottom).offset(33)
            make.left.equalTo(self.view).offset(33)
            make.right.equalTo(self.view).offset(-33)
            make.height.equalTo(33)
        }
        btnLogin.addTarget(self, action: #selector(didTapSignIn(_:)), for: UIControlEvents.touchUpInside)
        
        self.view.addSubview(btnForgetPassword)
        btnForgetPassword.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(btnLogin.snp.bottom).offset(13)
            make.left.equalTo(self.view).offset(33)
            make.right.equalTo(self.view).offset(-33)
            make.height.equalTo(33)
        }
        btnForgetPassword.addTarget(self, action: #selector(didRequestPasswordReset(_:)), for: UIControlEvents.touchUpInside)
        
        self.view.addSubview(btnRegister)
        btnRegister.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(btnForgetPassword.snp.bottom).offset(13)
            make.left.equalTo(self.view).offset(33)
            make.right.equalTo(self.view).offset(-33)
            make.height.equalTo(33)
        }
        btnRegister.addTarget(self, action: #selector(didTapSignUp(_:)), for: UIControlEvents.touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let user = FIRAuth.auth()?.currentUser {
            self.signedIn(user)
        }
    }
    
    func didTapSignIn(_ sender: AnyObject) {
        // Sign In with credentials.
        guard let email = txtEmail.text, let password = txtPassword.text else { return }
        FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            self.signedIn(user!)
        }
    }
    
    func didTapSignUp(_ sender: AnyObject) {
        guard let email = txtEmail.text, let password = txtPassword.text else { return }
        FIRAuth.auth()?.createUser(withEmail: email, password: password) { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            self.setDisplayName(user!)
        }
    }
    
    func setDisplayName(_ user: FIRUser) {
        let changeRequest = user.profileChangeRequest()
        changeRequest.displayName = user.email!.components(separatedBy: "@")[0]
        changeRequest.commitChanges(){ (error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            self.signedIn(FIRAuth.auth()?.currentUser)
        }
    }
    
    func didRequestPasswordReset(_ sender: AnyObject) {
        let prompt = UIAlertController.init(title: nil, message: "Email:", preferredStyle: .alert)
        let okAction = UIAlertAction.init(title: "OK", style: .default) { (action) in
            let userInput = prompt.textFields![0].text
            if (userInput!.isEmpty) {
                return
            }
            FIRAuth.auth()?.sendPasswordReset(withEmail: userInput!) { (error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
            }
        }
        prompt.addTextField(configurationHandler: nil)
        prompt.addAction(okAction)
        present(prompt, animated: true, completion: nil);
    }
    
    func signedIn(_ user: FIRUser?) {
        MeasurementHelper.sendLoginEvent()
        
        AppState.sharedInstance.displayName = user?.displayName ?? user?.email
        AppState.sharedInstance.photoURL = user?.photoURL
        AppState.sharedInstance.signedIn = true
        let notificationName = Notification.Name(rawValue: Constants.NotificationKeys.SignedIn)
        NotificationCenter.default.post(name: notificationName, object: nil, userInfo: nil)
//        performSegue(withIdentifier: Constants.Segues.SignInToFp, sender: nil)
        navigationController?.pushViewController(FireChatViewController(), animated: true)
    }
    
}

struct Constants {
    
    struct NotificationKeys {
        static let SignedIn = "onSignInCompleted"
    }
    
    struct Segues {
        static let SignInToFp = "SignInToFP"
        static let FpToSignIn = "FPToSignIn"
    }
    
    struct MessageFields {
        static let name = "name"
        static let text = "text"
        static let photoURL = "photoURL"
        static let imageURL = "imageURL"
    }
}

class MeasurementHelper: NSObject {
    
    static func sendLoginEvent() {
    }
    
    static func sendLogoutEvent() {
    }
    
    static func sendMessageEvent() {
    }
}

class AppState: NSObject {
    
    static let sharedInstance = AppState()
    
    var signedIn = false
    var displayName: String?
    var photoURL: URL?
}
