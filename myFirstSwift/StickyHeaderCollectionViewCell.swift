//
//  StickyHeaderCollectionViewCell.swift
//  myFirstSwift
//
//  Created by tiennguyen on 12/8/16.
//  Copyright © 2016 tiennguyen. All rights reserved.
//

import UIKit

class StickyHeaderCollectionViewCell: UICollectionViewCell {
    
    static let Identifier = "StickyHeaderCollectionViewCell"
    
    var text : String? {
        didSet {
            self.reloadData()
        }
    }
    
    fileprivate var textLabel : UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        
        let bounds = CGRect(x: 0, y: 0, width: frame.maxX, height: frame.maxY)
        let label = UILabel(frame: bounds)
        label.autoresizingMask = [UIViewAutoresizing.flexibleHeight, UIViewAutoresizing.flexibleWidth]
        self.textLabel = label
        self.addSubview(label)
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
