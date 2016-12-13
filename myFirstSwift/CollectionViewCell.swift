//
//  CollectionViewCell.swift
//  SwiftDemo
//
//  Created by James Tang on 16/7/15.
//  Copyright © 2015 James Tang. All rights reserved.
//

import UIKit

protocol GotoNextViewControllerDelegate: class {
    func gotoNextViewController()
}

class CollectionViewCell: UICollectionViewCell {

    weak var myDelegate: GotoNextViewControllerDelegate?
    
    var text : String? {
        didSet {
            self.reloadData()
        }
    }
    
    var button = UIButton()

    fileprivate var textLabel : UILabel?

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = UIColor.white
        
        let bounds = CGRect(x: 0, y: 0, width: frame.maxX, height: frame.maxY / 2)
        let label = UILabel(frame: bounds)
        label.autoresizingMask = [UIViewAutoresizing.flexibleHeight, UIViewAutoresizing.flexibleWidth]
        self.textLabel = label
        self.addSubview(label)
        
        button.frame = CGRect(x: 1, y: label.frame.maxY + 11, width: 84, height: 33)
        button.setTitle("Press", for: UIControlState.normal)
        button.addTarget(self, action: #selector(gotoNew), for: .touchDown)
        button.backgroundColor = UIColor.red
        
        addSubview(button)
    }
    
    func gotoNew() {
        myDelegate?.gotoNextViewController()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func reloadData() {
        self.textLabel?.text = self.text
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.textLabel?.frame = self.bounds
    }
}
