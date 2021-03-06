//
//  NeitCustomScrollContainerMainViewController.swift
//  myFirstSwift
//
//  Created by tiennguyen on 12/27/16.
//  Copyright © 2016 tiennguyen. All rights reserved.
//

import UIKit

class NeitCustomScrollContainerMainViewController: BaseViewController {
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        return scrollView
    }()
    
    private let mySegmentedControl = UISegmentedControl (items: ["One","Two","Three"])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.frame = self.view.frame
        self.view.addSubview(scrollView)
        
        self.navigationController?.navigationBar.isHidden = true
        
        // segment control
        
        let xPostion:CGFloat = 10
        let yPostion:CGFloat = 77
        let elementWidth:CGFloat = self.view.frame.size.width - 20
        let elementHeight:CGFloat = 30
        
        mySegmentedControl.frame = CGRect(x: xPostion, y: yPostion, width: elementWidth, height: elementHeight)
        
        // Make second segment selected
        mySegmentedControl.selectedSegmentIndex = 0
        
        //Change text color of UISegmentedControl
        mySegmentedControl.tintColor = UIColor.yellow
        
        //Change UISegmentedControl background colour
        mySegmentedControl.backgroundColor = UIColor.black
        
        // Add function to handle Value Changed events
        mySegmentedControl.addTarget(self, action: #selector(self.segmentedValueChanged(_:)), for: .valueChanged)
        
        self.view.addSubview(mySegmentedControl)
        
        
        //        let aViewController = AViewController();
        //        let bViewController = BViewController();
        //        let cViewController = CViewController();
        let aViewController = UINavigationController(rootViewController: AViewController())
        let bViewController = UINavigationController(rootViewController: BViewController())
        let cViewController = UINavigationController(rootViewController: CViewController())
        
        
        let bounds = UIScreen.main.bounds
        let width = bounds.size.width
        let height = bounds.size.height;
        
        scrollView.contentSize = CGSize(width: 3*width, height: height);
        
        let viewControllers = [aViewController, bViewController, cViewController]
        
        var idx:Int = 0;
        
        
        for viewController in viewControllers {
            // index is the index within the array
            // participant is the real object contained in the array
            addChildViewController(viewController);
            let originX:CGFloat = CGFloat(idx) * width;
            viewController.view.frame = CGRect(x: originX, y: 0, width: width, height: height);
            scrollView.addSubview(viewController.view)
            viewController.didMove(toParentViewController: self)
            idx += 1;
        }
    }
    
    func pagingScroll(idx: Int) {
        let rect: CGRect = scrollView.bounds
        scrollView.setContentOffset(CGPoint(x: rect.width * CGFloat(idx), y: 0), animated: true)
    }
    
    func segmentedValueChanged(_ sender: UISegmentedControl)
    {
        pagingScroll(idx: sender.selectedSegmentIndex)
    }
}
