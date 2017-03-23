//
//  AViewController.swift
//  myFirstSwift
//
//  Created by tiennguyen on 12/23/16.
//  Copyright © 2016 tiennguyen. All rights reserved.
//

import UIKit

class AViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.red
        self.title = "AVC"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Search", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.btnPressed))
        
        let button = UIButton(frame: CGRect(x: 22, y: 111, width: self.view.frame.size.width - 44, height: 44))
        button.backgroundColor = UIColor.blue
        button.setTitle("Press", for: .normal)
        button.addTarget(self, action: #selector(self.btnPressed), for: .touchDown)
        self.view.addSubview(button)
    }
    
    func btnPressed() {
        let vc = BaseViewController()
        vc.view.backgroundColor = UIColor.white
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
