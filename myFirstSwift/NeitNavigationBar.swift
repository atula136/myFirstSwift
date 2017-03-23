//
//  NeitNavigationBar.swift
//  myFirstSwift
//
//  Created by tiennguyen on 1/6/17.
//  Copyright © 2017 tiennguyen. All rights reserved.
//

import UIKit

class NeitNavigationBar: UINavigationBar {
    
    init() {
        super.init(frame: CGRect.zero)
        customInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    func customInit() {
        barTintColor = .white
        backgroundColor = .clear
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var customSize = size
        customSize.width = UIScreen.main.bounds.width
        customSize.height = 90
        frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: customSize.width, height: customSize.height)
        print("frame:", frame)
        return customSize
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let kJagHeight: CGFloat = 12
        
        let a = CGPoint(x: 0, y: 0)
        let b = CGPoint(x: 0, y: rect.size.height)
        let c = CGPoint(x: rect.size.width, y: rect.size.height)
        let d = CGPoint(x: rect.size.width, y: 0)
        
        let underPath = UIBezierPath()
        underPath.move(to: a)
        underPath.addLine(to: b)
        
        let mod5: Int32 = Int32(rect.size.width) % (Int32(kJagHeight)*2)
        let drawCount: Int32 = Int32(rect.size.width / CGFloat(kJagHeight*2))
        
        let space: CGFloat = CGFloat((kJagHeight*2 + CGFloat(mod5) / CGFloat(drawCount))/2)
        
        //        let strokeColor = UIColor.lightGray
        
        for t in 0...drawCount*2 {
            let mod = t%2
            if mod == 0 {
                underPath.addLine(to: CGPoint(x: b.x + CGFloat(t)*space, y: b.y))
            }
            else {
                underPath.addLine(to: CGPoint(x: b.x + CGFloat(t)*space, y: b.y - space))
            }
        }
        underPath.addLine(to: c)
        underPath.addLine(to: d)
        underPath.addLine(to: a)
        UIColor.red.setFill()
        underPath.fill()
//        strokeColor.setStroke()
//        
//        underPath.lineWidth = 1.5
//        underPath.stroke()
        
        let jagPath = UIBezierPath()
        jagPath.move(to: b)
        
        for t in 0...drawCount*2 {
            let mod = t%2
            if mod == 0 {
                jagPath.addLine(to: CGPoint(x: b.x + CGFloat(t)*space, y: b.y))
            }
            else {
                jagPath.addLine(to: CGPoint(x: b.x + CGFloat(t)*space, y: b.y - space))
            }
        }
        jagPath.addLine(to: c)
        jagPath.addLine(to: b)
        UIColor.clear.setFill()
        jagPath.fill()
//        strokeColor.setStroke()
//        
//        jagPath.lineWidth = 1.5
//        jagPath.stroke()

    }
}
