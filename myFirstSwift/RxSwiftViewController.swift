//
//  ViewController.swift
//  myFirstSwift
//
//  Created by tiennguyen on 11/25/16.
//  Copyright © 2016 tiennguyen. All rights reserved.
//

import UIKit

class RxSwiftViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    let cartButton: UIBarButtonItem = UIBarButtonItem()
    
    let europeanChocolates = Chocolate.ofEurope
    
    //MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Chocolate!!!"
        
        view.addSubview(tableView)
        tableView.register(ChocolateCell.self, forCellReuseIdentifier:ChocolateCell.Identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 111
        tableView.rowHeight = UITableViewAutomaticDimension
        
        cartButton.target = self
        cartButton.action = #selector(gotoStickyHeaderViewController)
    }
    
    func gotoStickyHeaderViewController() {
        navigationController?.pushViewController(StickyCollectionViewController(), animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.rightBarButtonItem = cartButton
        updateCartButton()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        tableView.frame = UIScreen.main.bounds
    }
    
    //MARK: Rx Setup
    
    
    //MARK: Imperative methods
    
    func updateCartButton() {
        cartButton.title = "\(ShoppingCart.sharedCart.chocolates.count) 🍫"
    }
}

// MARK: - Table view data source
extension RxSwiftViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return europeanChocolates.count
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChocolateCell.Identifier, for: indexPath) as? ChocolateCell else {
            //Something went wrong with the identifier.
            return UITableViewCell()
        }
        
        let chocolate = europeanChocolates[indexPath.row]
        cell.configureWithChocolate(chocolate: chocolate)
        
        return cell
    }
}

// MARK: - Table view delegate
extension RxSwiftViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let chocolate = europeanChocolates[indexPath.row]
        ShoppingCart.sharedCart.chocolates.append(chocolate)
        updateCartButton()
    }
}
