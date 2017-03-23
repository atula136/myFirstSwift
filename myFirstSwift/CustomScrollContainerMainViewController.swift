//
//  CustomScrollContainerMainViewController.swift
//  myFirstSwift
//
//  Created by tiennguyen on 12/23/16.
//  Copyright © 2016 tiennguyen. All rights reserved.
//

import UIKit
import Segmentio

class CustomScrollContainerMainViewController: BaseViewController {
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        return scrollView
    }()
    
    var segmentioView: Segmentio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.frame = self.view.frame
        self.view.addSubview(scrollView)
        
        self.navigationController?.navigationBar.isHidden = true
        
        // segment control
        
        let xPostion:CGFloat = 0
        let yPostion:CGFloat = 77
        let elementWidth:CGFloat = UIScreen.main.bounds.width
        let elementHeight:CGFloat = 50
        
        let segmentioViewRect = CGRect(x: xPostion, y: yPostion, width: elementWidth, height: elementHeight)
        segmentioView = Segmentio(frame: segmentioViewRect)
        view.addSubview(segmentioView)
        
        var content = [SegmentioItem]()
        
        let tornadoItem1 = SegmentioItem(
            title: "Tornado1",
            image: nil
        )
        let tornadoItem2 = SegmentioItem(
            title: "Tornado2",
            image: nil
        )
        let tornadoItem3 = SegmentioItem(
            title: "Tornado3",
            image: nil
        )
        content.append(tornadoItem1)
        content.append(tornadoItem2)
        content.append(tornadoItem3)
        
        let segmentioIndicatorOptions = SegmentioIndicatorOptions(
            type: .bottom,
            ratio: 1,
            height: 5,
            color: .orange
        )
        let segmentioHorizontalSeparatorOptions = SegmentioHorizontalSeparatorOptions(
            type: SegmentioHorizontalSeparatorType.topAndBottom, // Top, Bottom, TopAndBottom
            height: 1,
            color: .gray
        )
        let segmentioVerticalSeparatorOptions = SegmentioVerticalSeparatorOptions(
            ratio: 0.6, // from 0.1 to 1
            color: .gray
        )
        
        let segmentioStates = SegmentioStates(
            defaultState: SegmentioState(
                backgroundColor: .clear,
                titleFont: UIFont.systemFont(ofSize: UIFont.smallSystemFontSize),
                titleTextColor: .black
            ),
            selectedState: SegmentioState(
                backgroundColor: .orange,
                titleFont: UIFont.systemFont(ofSize: UIFont.smallSystemFontSize),
                titleTextColor: .white
            ),
            highlightedState: SegmentioState(
                backgroundColor: UIColor.lightGray.withAlphaComponent(0.6),
                titleFont: UIFont.boldSystemFont(ofSize: UIFont.smallSystemFontSize),
                titleTextColor: .black
            )
        )
        
        let segmentioOptions = SegmentioOptions(
            backgroundColor: UIColor.white,
            maxVisibleItems: 3,
            scrollEnabled: true,
            indicatorOptions: segmentioIndicatorOptions,
            horizontalSeparatorOptions: segmentioHorizontalSeparatorOptions,
            verticalSeparatorOptions: segmentioVerticalSeparatorOptions,
            imageContentMode: UIViewContentMode.center,
            labelTextAlignment: NSTextAlignment.center,
            labelTextNumberOfLines: 1,
            segmentStates: segmentioStates,
            animationDuration: 0.4
        )
        
        segmentioView.setup(
            content: content,
            style: SegmentioStyle.onlyLabel,
//            options: segmentioOptions
            options: nil
        )
        
        segmentioView.selectedSegmentioIndex = 0
        segmentioView.valueDidChange = { segmentio, segmentIndex in
            self.pagingScroll(idx: segmentIndex)
        }
        
        
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
}
