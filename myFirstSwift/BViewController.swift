//
//  BViewController.swift
//  myFirstSwift
//
//  Created by tiennguyen on 12/23/16.
//  Copyright © 2016 tiennguyen. All rights reserved.
//

import UIKit

class BViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.green
        self.title = "DEF"
        
        let button = UIButton(frame: CGRect(x: 22, y: 111, width: self.view.frame.size.width - 44, height: 44))
        button.backgroundColor = UIColor.blue
        button.setTitle("Press", for: .normal)
        button.addTarget(self, action: #selector(self.btnPressed), for: .touchDown)
        self.view.addSubview(button)
    }
    
    func btnPressed() {
        let vc = BaseViewController()
        vc.view.backgroundColor = UIColor.cyan
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
