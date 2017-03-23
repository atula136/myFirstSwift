//
//  myPullRefreshViewController.swift
//  myFirstSwift
//
//  Created by tiennguyen on 3/23/17.
//  Copyright © 2017 tiennguyen. All rights reserved.
//

import UIKit

final class MyPullRefreshViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell10")
        return tableView
    }()
    
    var items = ["initial"]
    
    var refresh: CarbonSwipeRefresh?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        self.view.addSubview(tableView)
        tableView.frame = self.view.bounds
        
        refresh = CarbonSwipeRefresh.init(scrollView: tableView)
        refresh?.setMarginTop(64)
        self.view.addSubview(refresh!)
        refresh?.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        refresh?.colors = [UIColor.blue, UIColor.red, UIColor.orange, UIColor.green]
        
        //        let refresher = Refresher { [weak self] () -> Void in
        //            self?.updateItems()
        //        }
        //        tableView.srf_addRefresher(refresher)
        
        //        let refresh1 = CarbonSwipeRefresh1(scrollView: tableView)
        //        refresh1.marginTop = -64
        //        self.view.addSubview(refresh1)
        //        refresh1.addTarget(self, action: #selector(self.refresh1(_:)), for: .valueChanged)
        //        refresh1.colors = [UIColor.blue, UIColor.red, UIColor.orange, UIColor.green]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let text = items[indexPath.row]
        let cell: UITableViewCell
        //        if let dequeueCell = tableView.dequeueReusableCell(withIdentifier: "Cell") {
        //            cell = dequeueCell
        //        } else {
        cell = UITableViewCell(style: .default, reuseIdentifier: "Cell10")
        //        }
        cell.textLabel?.text = text
        
        if indexPath.row == items.count-1 {
            let cellRefresh = CarbonSwipeRefresh1()
            cell.addSubview(cellRefresh)
            cellRefresh.startRefreshing()
            cellRefresh.colors = [UIColor.blue, UIColor.red, UIColor.orange, UIColor.green]
        }
        return cell
    }
    
    func updateItems() {
        DispatchQueue.global().async { [weak self] in
            // Time spendig task. Ex. Gettings items from server
            Thread.sleep(forTimeInterval: 3.0)
            
            // Task finished:
            DispatchQueue.main.async { [weak self] in
                guard let s = self else { return }
                let text = "\(NSDate())"
                s.items.append(text)
                s.tableView.reloadData()
                
                s.refresh?.endRefreshing()
                s.tableView.srf_endRefreshing()
            }
        }
    }
    
    func refresh(_ sender: CarbonSwipeRefresh) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(5 * Double(NSEC_PER_SEC)) / Double(NSEC_PER_SEC), execute: {() -> Void in
            let text = "\(NSDate())"
            self.items.append(text)
            self.tableView.reloadData()
            sender.endRefreshing()
        })
    }
    
    func refresh1(_ sender: CarbonSwipeRefresh1) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(5 * Double(NSEC_PER_SEC)) / Double(NSEC_PER_SEC), execute: {() -> Void in
            let text = "\(NSDate())"
            self.items.append(text)
            self.tableView.reloadData()
            sender.endRefreshing()
        })
    }
}
