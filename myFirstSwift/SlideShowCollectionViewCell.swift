//
//  SlideShowCollectionViewCell.swift
//  myFirstSwift
//
//  Created by tiennguyen on 12/8/16.
//  Copyright © 2016 tiennguyen. All rights reserved.
//

import UIKit
import ImageSlideshow

class SlideShowCollectionViewCell: UICollectionViewCell {
    
    let slideshow = ImageSlideshow()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        
        let kingfisherSource = [KingfisherSource(urlString: "https://images.unsplash.com/photo-1432679963831-2dab49187847?w=1080")!, KingfisherSource(urlString: "https://images.unsplash.com/photo-1447746249824-4be4e1b76d66?w=1080")!, KingfisherSource(urlString: "https://images.unsplash.com/photo-1463595373836-6e0b0a8ee322?w=1080")!]
        
        let slideshowHeight: CGFloat = (frame.maxX < frame.maxY) ? frame.maxX : frame.maxY
        slideshow.frame = CGRect(x: 0, y: 0, width: slideshowHeight, height: slideshowHeight)
        slideshow.center = CGPoint(x: center.x, y: slideshow.center.y)
        slideshow.layer.cornerRadius = slideshow.frame.height/2
        self.addSubview(slideshow)
        
        slideshow.backgroundColor = UIColor.clear
        slideshow.slideshowInterval = 3.0
        slideshow.pageControlPosition = PageControlPosition.insideScrollView
        slideshow.pageControl.currentPageIndicatorTintColor = UIColor.lightGray;
        slideshow.pageControl.pageIndicatorTintColor = UIColor.black;
        slideshow.contentScaleMode = UIViewContentMode.scaleAspectFill
        
        // try out other sources such as `afNetworkingSource`, `alamofireSource` or `sdWebImageSource` or `kingfisherSource`
        slideshow.setImageInputs(kingfisherSource)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
        slideshow.addGestureRecognizer(recognizer)
    }
    
    func didTap() {
//        slideshow.presentFullScreenController(from: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func reloadData() {
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
