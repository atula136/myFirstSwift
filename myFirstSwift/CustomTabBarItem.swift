//
//  CustomTabBarItem.swift
//  myFirstSwift
//
//  Created by tiennguyen on 12/22/16.
//  Copyright © 2016 tiennguyen. All rights reserved.
//

import UIKit

class CustomTabBarItem: UIView {
    
    var iconView: UIImageView!
    
    override init (frame : CGRect) {
        super.init(frame : frame)
        
    }
    
    convenience init () {
        self.init(frame:CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(item: UITabBarItem) {
        
        print("-----sfa---", item.title ?? "no title")
        print("-----sfa---", item.image ?? "no image")
        guard let image = item.image else {
            fatalError("add images to tabbar items")
        }
        
        // create imageView centered within a container
        //        iconView = UIImageView(frame: CGRect(x: (self.frame.width-image.size.width)/2, y: (self.frame.height-image.size.height)/2, width: self.frame.width, height: self.frame.height))
        iconView = UIImageView(frame: CGRect(x: 5, y: 5, width: self.frame.width - 10, height: self.frame.height - 10))
        iconView.contentMode = .scaleAspectFill
        
        iconView.image = image
        iconView.tintColor = UIColor.black
        //        iconView.sizeToFit()
        
        self.addSubview(iconView)
    }
    
}
