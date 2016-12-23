//
//  StickyHeaderCollectionViewController.swift
//  myFirstSwift
//
//  Created by tiennguyen on 12/8/16.
//  Copyright © 2016 tiennguyen. All rights reserved.
//

import UIKit

class StickyHeaderCollectionViewController: UICollectionViewController {
    
    var items : [String] = ["CSStickyHeaderFlowLayout basic example", "Example to initialize in code", "As well as in Swift", "Please Enjoy"]
    
    fileprivate var layout : CSStickyHeaderFlowLayout? {
        return self.collectionView?.collectionViewLayout as? CSStickyHeaderFlowLayout
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView?.alwaysBounceVertical = true
        self.view.backgroundColor = UIColor.white
        
        // Setup Cell
        self.collectionView?.register(StickyHeaderCollectionViewCell.self, forCellWithReuseIdentifier: StickyHeaderCollectionViewCell.Identifier)
        self.layout?.itemSize = CGSize(width: self.view.frame.size.width, height: 44)
        
        // Setup Header
        self.collectionView?.register(CollectionParallaxHeader.self, forSupplementaryViewOfKind: CSStickyHeaderParallaxHeader, withReuseIdentifier: "parallaxHeader")
        self.layout?.parallaxHeaderReferenceSize = CGSize(width: self.view.frame.size.width, height: 100)
        
        // Setup Section Header
        self.collectionView?.register(CollectionViewSectionHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "sectionHeader")
        self.layout?.headerReferenceSize = CGSize(width: 320, height: 40)
    }
    
    // Cells
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StickyHeaderCollectionViewCell.Identifier, for: indexPath) as! StickyHeaderCollectionViewCell
        cell.text = self.items[indexPath.row]
        return cell
    }
    
    // Parallax Header
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == CSStickyHeaderParallaxHeader {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "parallaxHeader", for: indexPath)
            return view
        } else if kind == UICollectionElementKindSectionHeader {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "sectionHeader", for: indexPath)
            view.backgroundColor = UIColor.lightGray
            return view
        }
        
        return UICollectionReusableView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let cartButton: UIBarButtonItem = UIBarButtonItem()
        navigationItem.rightBarButtonItem = cartButton
        cartButton.title = "🍫"
        cartButton.target = self
        cartButton.action = #selector(gotoNextViewController)
    }
    
    func gotoNextViewController() {
        navigationController?.pushViewController(ChatInitalTableViewController(), animated: true)
    }
    
}
