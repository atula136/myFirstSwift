//
//  CartViewController.swift
//  myFirstSwift
//
//  Created by tiennguyen on 12/20/16.
//  Copyright © 2016 tiennguyen. All rights reserved.
//

import UIKit
import SnapKit

class CartViewController: BaseViewController {
    let totalItems = UILabel()
    let totalCost  = UILabel()
    let btnCheckOut = UIButton()
    let btnReset = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        totalItems.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .horizontal)
//        btnCheckOut.setContentHuggingResistancePriority(UILayoutPriorityDefaultLow, for: .horizontal)
        
        totalItems.text = "Total Items"
        self.view.addSubview(totalItems)
        totalItems.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.view).offset(10)
            make.left.equalTo(self.view).offset(20)
            make.right.equalTo(self.view).offset(20)
            make.bottom.equalTo(self.btnCheckOut.snp.top).offset(10)
        }
        
        btnCheckOut.setTitle("Check Out", for: .normal)
        self.view.addSubview(btnCheckOut)
        btnCheckOut.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.totalItems.snp.bottom).offset(10)
            make.left.equalTo(self.view).offset(20)
            make.right.equalTo(self.view).offset(20)
            make.bottom.equalTo(self.btnReset.snp.top).offset(8)
            make.left.equalTo(self.btnReset).offset(0)
            make.right.equalTo(self.btnReset).offset(0)
            make.height.equalTo(48)
        }
        
        btnReset.setTitle("Reset", for: .normal)
        self.view.addSubview(btnReset)
        btnReset.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.btnCheckOut.snp.top).offset(8)
            make.left.equalTo(self.btnCheckOut).offset(0)
            make.right.equalTo(self.btnCheckOut).offset(0)
            make.height.equalTo(48)
        }
    }
}
