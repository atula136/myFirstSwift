//
//  MainViewController.swift
//  myFirstSwift
//
//  Created by tiennguyen on 12/13/16.
//  Copyright © 2016 tiennguyen. All rights reserved.
//

import UIKit
import Alamofire
//import EAIntroView

class MainViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let tableView = UITableView()
    let underEffectView = UIView()
    let visualEffectView = UIVisualEffectView()
    
    var items = [RxSwiftViewController(),
                 StickyCollectionViewController(),
                 StickyHeaderCollectionViewController(collectionViewLayout: CSStickyHeaderFlowLayout()),
                 ChatInitalTableViewController(),
                 FireChatLoginViewController(),
                 LoginViewController(),
                 NaihoChatMessengerViewController(),
                 CustomTabBarMainViewController(),
                 CustomScrollContainerMainViewController(),
                 SegmentioHomeViewController(),
                 MyPullRefreshViewController(),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showWalkThroughView()
        
        title = "NEIT FIRST SWIFT EXE"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.search, target: self, action: nil)
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.bookmarks, target: self, action: nil)
        
        if let navigationBarFrame = self.navigationController?.navigationBar.frame {
            print("old navigation bar frame:", navigationBarFrame)
            self.navigationController?.setValue(NeitNavigationBar(frame: navigationBarFrame), forKeyPath: "navigationBar")
        }
        self.navigationItem.leftBarButtonItem?.setBackgroundVerticalPositionAdjustment(-44, for: UIBarMetrics.default)
        
        self.navigationController?.navigationBar.backgroundColor = UIColor.green
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor.blue
        
        // Do any additional setup after loading the view.
        tableView.frame = self.view.bounds
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MainTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath)
        if indexPath.row == 5 {
            cell.textLabel?.text = "\(indexPath.row) -- Real Time Chat"
        }
        else {
            cell.textLabel?.text = "\(indexPath.row) -- \((String(describing: (items[indexPath.row])).components(separatedBy: ".").last?.components(separatedBy: ":").first)!)"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 5 {
            let rtcViewController = UIStoryboard(name: "RealTimeChat", bundle: Bundle.main).instantiateViewController(withIdentifier: "RTCStoryboard")
            navigationController?.pushViewController(rtcViewController, animated: true)
        }
        else if indexPath.row == 7 {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//            appDelegate.window?.rootViewController = UINavigationController(rootViewController: items[indexPath.row])
            appDelegate.window?.rootViewController = items[indexPath.row]
        }
        else if indexPath.row == 8 {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = items[indexPath.row]
        }
        else if indexPath.row == 9 {
            AppearanceConfigurator.configureNavigationBar()
            let segmentioVC = UIStoryboard(name: "Segmentio", bundle: nil).instantiateViewController(withIdentifier: "SegmentioHomeViewController")
            navigationController?.pushViewController(segmentioVC, animated: true)
        }
        else {
            items[indexPath.row].title = "\((String(describing: (items[indexPath.row])).components(separatedBy: ".").last?.components(separatedBy: ":").first)!)"
            navigationController?.pushViewController(items[indexPath.row], animated: true)
        }
    }
    
    func showWalkThroughView() {
        if let rect = self.navigationController?.view.bounds {
            
            self.navigationController?.isNavigationBarHidden = true
            UIApplication.shared.isStatusBarHidden = true
            
            print("debug: ", rect)
            
            underEffectView.frame = rect
            underEffectView.backgroundColor = .white
            self.navigationController?.view.addSubview(underEffectView)
            
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
            visualEffectView.effect = blurEffect
            visualEffectView.frame = rect
            self.navigationController?.view.addSubview(visualEffectView)
            
            let page1 = EAIntroPage()
            page1.bgColor = UIColor.red
            page1.titleIconView = UIImageView(image: UIImage(named: "tutorial_01"))
            let page2 = EAIntroPage()
            page2.bgColor = UIColor.green
            page2.titleIconView = UIImageView(image: UIImage(named: "tutorial_02"))
            let page3 = EAIntroPage()
            page3.titleIconView = UIImageView(image: UIImage(named: "tutorial_03"))
            let page4 = EAIntroPage()
            page4.titleIconView = UIImageView(image: UIImage(named: "tutorial_04"))
            
            let intro = EAIntroView(frame: rect, andPages: [page1, page2, page3, page4])
            intro?.delegate = self
            
            intro?.pageControl.currentPageIndicatorTintColor = UIColor.gray
            intro?.pageControl.pageIndicatorTintColor = UIColor.lightGray
            intro?.pageControlY = rect.size.height/2208*(2208-1848)

            intro?.skipButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            intro?.skipButton.backgroundColor = UIColor.red
            intro?.skipButton.setTitle("さっそく使ってみる", for: UIControlState.normal)
            intro?.skipButton.setTitleColor(UIColor.white, for: UIControlState.normal)
            intro?.skipButton.layer.cornerRadius = 8
            intro?.skipButtonY = rect.size.height/2208*(2208-2060)

            intro?.show(in: self.navigationController?.view, animateDuration: 0.3)
        }
    }
}

extension MainViewController: EAIntroDelegate {
    
    func introDidFinish(_ introView: EAIntroView) {
        self.visualEffectView.removeFromSuperview()
        self.underEffectView.removeFromSuperview()
        
        self.navigationController?.isNavigationBarHidden = false
        UIApplication.shared.isStatusBarHidden = false
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    func introDidFinish(_ introView: EAIntroView!, wasSkipped: Bool) {
        self.visualEffectView.removeFromSuperview()
        self.underEffectView.removeFromSuperview()
        
        self.navigationController?.isNavigationBarHidden = false
        UIApplication.shared.isStatusBarHidden = false
        UIApplication.shared.statusBarStyle = .lightContent
    }
}
