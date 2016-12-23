//
//  VC2ViewController.swift
//  myFirstSwift
//
//  Created by tiennguyen on 12/22/16.
//  Copyright © 2016 tiennguyen. All rights reserved.
//

import UIKit

class VC2ViewController: BaseViewController {
    
    let button: UIButton = {
        let button = UIButton()
        button.setTitle("Next", for: .normal)
        button.layer.cornerRadius = 11
        button.backgroundColor = UIColor.black
        button.setTitleColor(UIColor.white, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        button.frame.size = CGSize(width: 77, height: 33)
        button.center = self.view.center
        self.view.addSubview(button)
        button.addTarget(self, action: #selector(self.gotoNextViewController), for: .touchDown)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if  self.navigationController != nil {
            let btnSearch = UIBarButtonItem(title: "Search", style: UIBarButtonItemStyle.done, target: self, action: nil)
            self.navigationItem.rightBarButtonItem = btnSearch
            self.navigationController?.navigationBar.barTintColor = UIColor.red
            self.navigationController?.navigationBar.isTranslucent = false
        }
        
        
        self.view.backgroundColor = UIColor.cyan
    }
    
    func gotoNextViewController() {
        let nextVC = BaseViewController()
        nextVC.view.backgroundColor = UIColor.orange
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}
