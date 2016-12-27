//
//  UIFont+ExampleFonts.swift
//  myFirstSwift
//
//  Created by tiennguyen on 12/27/16.
//  Copyright © 2016 tiennguyen. All rights reserved.
//

import UIKit

extension UIFont {
    
    class func exampleAvenirMedium(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Avenir-Book", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    class func exampleAvenirLight(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Avenir-Light", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
}
