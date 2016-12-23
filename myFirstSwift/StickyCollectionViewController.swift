//
//  StickyHeaderViewController.swift
//  myFirstSwift
//
//  Created by tiennguyen on 12/7/16.
//  Copyright © 2016 tiennguyen. All rights reserved.
//

import UIKit

class StickyCollectionViewController: UIViewController {

    let kDemoCell = "primerCell"
    let kCellSizeCoef: CGFloat = 0.8
    let kFirstItemTransform: CGFloat = 0.0
    
    let lessonsArray = ["Create a Hight Quality, High Ranking Search Ad",
                        "Evolve Your Ad Campaigns with Programmatic Buying",
                        "How Remarketing Keeps Customers Coming Back",
                        "Surviving and Thriving on Social Media",
                        "Keep Mobile Users Engaged In and Out of Your App",
                        "Appeal to Searchers and Search Engines with Seo",
                        "Build Your Business Fast with Growth Hacking",
                        "Track Your Acquisitions with Digital Metricks"]
    
    var collectionView: UICollectionView?
    
    
    var layout = StickyCollectionViewFlowLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.view.backgroundColor = UIColor.blue
        
        // Setup Cell
        
        layout.firstItemTransform = kFirstItemTransform
        self.collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: self.layout)
        self.collectionView?.backgroundColor = UIColor.cyan
//        self.collectionView?.alwaysBounceVertical = true
        self.collectionView?.register(SlideShowCollectionViewCell.self, forCellWithReuseIdentifier: "cell1")
        self.collectionView?.register(CollectionViewCell.self, forCellWithReuseIdentifier: "cell2")
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        
        self.view.addSubview(self.collectionView!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let cartButton: UIBarButtonItem = UIBarButtonItem()
        navigationItem.rightBarButtonItem = cartButton
        cartButton.title = "🍫"
        cartButton.target = self
        cartButton.action = #selector(gotoNextViewController)
    }
}

extension StickyCollectionViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell1", for: indexPath) as! SlideShowCollectionViewCell
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell2", for: indexPath) as! CollectionViewCell
            let lesson = lessonsArray[indexPath.row]
            cell.text = lesson
            cell.myDelegate = self
            return cell
        }
    }
}


extension StickyCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0 {
            return CGSize(width: view.bounds.width, height: 222)
        }
        else {
            return CGSize(width: view.bounds.width, height: 333)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: NSInteger) -> CGFloat {
        return 0
    }
}

extension StickyCollectionViewController: GotoNextViewControllerDelegate {
    func gotoNextViewController() {
        let stickyHeaderFlowLayout = CSStickyHeaderFlowLayout()
        let collectionViewController = StickyHeaderCollectionViewController(collectionViewLayout: stickyHeaderFlowLayout)
        navigationController?.pushViewController(collectionViewController, animated: true)
    }
}
