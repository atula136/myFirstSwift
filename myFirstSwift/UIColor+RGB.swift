//
//  UIColor+RGB.swift
//  myFirstSwift
//
//  Created by tiennguyen on 12/27/16.
//  Copyright © 2016 tiennguyen. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(red: CGFloat, green: CGFloat, blue: CGFloat) {
        self.init(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1)
    }
    
}

struct ColorPalette {
    
    static let white = UIColor(red: 255, green: 255, blue: 255)
    static let black = UIColor(red: 3, green: 3, blue: 3)
    static let coral = UIColor(red: 244, green: 111, blue: 96)
    static let whiteSmoke = UIColor(red: 245, green: 245, blue: 245)
    static let grayChateau = UIColor(red: 163, green: 164, blue: 168)
    
}
