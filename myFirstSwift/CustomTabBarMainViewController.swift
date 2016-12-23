//
//  CustomTabBarMainViewController.swift
//  myFirstSwift
//
//  Created by tiennguyen on 12/22/16.
//  Copyright © 2016 tiennguyen. All rights reserved.
//

import UIKit

class CustomTabBarMainViewController: UITabBarController {
    
    static var tabHeight: CGFloat = 0.0
    
    var scrollEnabled: Bool = true
    
    var previousIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        let vc1tabBarItem = UITabBarItem(title: "vc1", image: UIImage(named: "success-baby"), tag: 0)
        let vc2tabBarItem = UITabBarItem(title: "vc2", image: UIImage(named: "success-baby"), tag: 1)
        let vc3tabBarItem = UITabBarItem(title: "vc3", image: UIImage(named: "success-baby"), tag: 2)
        let vc4tabBarItem = UITabBarItem(title: "vc4", image: UIImage(named: "success-baby"), tag: 3)
        let vc5tabBarItem = UITabBarItem(title: "vc5", image: UIImage(named: "success-baby"), tag: 4)
        let vc6tabBarItem = UITabBarItem(title: "vc6", image: UIImage(named: "success-baby"), tag: 6)
        
//        let vc1 = VC1ViewController()
        let vc1 = UINavigationController(rootViewController: VC1ViewController())
        let vc2 = VC2ViewController()
        let vc3 = BaseViewController()
        let vc4 = BaseViewController()
        let vc5 = BaseViewController()
        let vc6 = BaseViewController()
        
        vc1.view.backgroundColor = UIColor.red
        vc2.view.backgroundColor = UIColor.green
        vc3.view.backgroundColor = UIColor.blue
        vc4.view.backgroundColor = UIColor.yellow
        vc5.view.backgroundColor = UIColor.purple
        vc6.view.backgroundColor = UIColor.gray
        
        vc1.tabBarItem = vc1tabBarItem
        vc2.tabBarItem = vc2tabBarItem
        vc3.tabBarItem = vc3tabBarItem
        vc4.tabBarItem = vc4tabBarItem
        vc5.tabBarItem = vc5tabBarItem
        vc6.tabBarItem = vc6tabBarItem
        
//        let controllers = [vc1, vc2, vc3, vc4, vc5, vc6]
        let controllers = [vc1, vc2, vc3, vc4, vc5]
        
        self.viewControllers = controllers
        
        CustomTabBarMainViewController.tabHeight = self.tabBar.frame.size.height
        
        self.tabBar.isHidden = true
        self.selectedIndex = 1
        
//        let customTabBar = CustomTabBar(frame: self.tabBar.frame)
//        let customTabBarY: CGFloat = UINavigationController().navigationBar.frame.height
        let customTabBarY: CGFloat = 64
        
        let customTabBar = CustomTabBar(frame: CGRect(x: 0, y: customTabBarY, width: self.tabBar.frame.width, height: self.tabBar.frame.height))
        self.view.addSubview(customTabBar)
        customTabBar.datasource = self
        customTabBar.delegate = self
        
        customTabBar.setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.navigationController != nil {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
}
extension CustomTabBarMainViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard scrollEnabled else {
            return
        }
        
        guard let index = viewControllers?.index(of: viewController) else {
            return
        }
        
        if index == previousIndex {
            
            DispatchQueue.global(qos: .background).async {
                print("This is run on the background queue")
                guard let scrollView = self.iterateThroughSubviews(self.view) else {
                    return
                }
                
                DispatchQueue.main.async {
                    print("This is run on the main queue, after the previous code in outer block")
                    scrollView.setContentOffset(CGPoint.zero, animated: true)
                }
            }
            
//            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), { [weak self] () in
//            
//                guard let scrollView = self?.iterateThroughSubviews(self?.view) else {
//                    return
//                }
//                
//                dispatch_async(dispatch_get_main_queue(), {
//                    scrollView.setContentOffset(CGPointZero, animated: true)
//                })
//            })
        }
        
        previousIndex = index
    }
    
    private func iterateThroughSubviews(_ parentView: UIView?) -> UIScrollView? {
        guard let view = parentView else {
            return nil
        }
        
        for subview in view.subviews {
            if let scrollView = subview as? UIScrollView, scrollView.scrollsToTop == true {
                return scrollView
            }
            
            if let scrollView = iterateThroughSubviews(subview) {
                return scrollView
            }
        }
        
        return nil
    }
    
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return CustomTabAnimatedTransitioning()
//        return nil
    }
}

extension CustomTabBarMainViewController: CustomTabBarDataSource {
    func tabBarItemsInCustomTabBar(tabBarView: CustomTabBar) -> [UITabBarItem] {
        return self.tabBar.items!
    }
}

extension CustomTabBarMainViewController: CustomTabBarDelegate {
    func didSelectViewController(tabBarView: CustomTabBar, atIndex index: Int) {
        self.selectedIndex = index
    }
}
