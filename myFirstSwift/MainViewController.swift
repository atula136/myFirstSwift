//
//  MainViewController.swift
//  myFirstSwift
//
//  Created by tiennguyen on 12/13/16.
//  Copyright © 2016 tiennguyen. All rights reserved.
//

import UIKit

class MainViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let tableView = UITableView()
    
    var items = [RxSwiftViewController(),
                 StickyCollectionViewController(),
                 StickyHeaderCollectionViewController(collectionViewLayout: CSStickyHeaderFlowLayout()),
                 ChatInitalTableViewController(),
                 FireChatLoginViewController(),
                 LoginViewController()
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.frame = self.view.frame
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
        else {
            navigationController?.pushViewController(items[indexPath.row], animated: true)
        }
    }
}
