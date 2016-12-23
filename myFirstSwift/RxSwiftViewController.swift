//
//  ViewController.swift
//  myFirstSwift
//
//  Created by tiennguyen on 11/25/16.
//  Copyright © 2016 tiennguyen. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RxSwiftViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    let cartButton: UIBarButtonItem = UIBarButtonItem()
    
//    let europeanChocolates = Chocolate.ofEurope
    let europeanChocolates = Observable.just(Chocolate.ofEurope)
    
    let disposeBag = DisposeBag()
    
    //MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Chocolate!!!"
        
        view.addSubview(tableView)
        tableView.register(ChocolateCell.self, forCellReuseIdentifier:ChocolateCell.Identifier)
//        tableView.dataSource = self
//        tableView.delegate = self
        tableView.estimatedRowHeight = 111
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.frame = UIScreen.main.bounds
        
        cartButton.target = self
        cartButton.action = #selector(gotoStickyHeaderViewController)
        
        setupCartObserver()
        setupCellConfiguration()
        setupCellTapHandling()
    }
    
    func gotoStickyHeaderViewController() {
        navigationController?.pushViewController(CartViewController(), animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.rightBarButtonItem = cartButton
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        tableView.frame = UIScreen.main.bounds
    }
    
    //MARK: Rx Setup
    private func setupCartObserver() {
        //1
        ShoppingCart.sharedCart.chocolates.asObservable()
            .subscribe(onNext: { //2
                chocolates in
                self.cartButton.title = "\(chocolates.count) \u{1f36b}"
            })
            .addDisposableTo(disposeBag) //3
    }
    
    private func setupCellConfiguration() {
        //1 You call bindTo(_:) to associate the europeanChocolates observable with the code that should get executed for each row in the table view.
        europeanChocolates
            .bindTo(tableView
                .rx //2 By calling rx, you are able to access the RxCocoa extensions for whatever class you call it on – in this case, a UITableView.
                .items(cellIdentifier: ChocolateCell.Identifier,
                       cellType: ChocolateCell.self)) { // 3 You call the Rx method items(cellIdentifier:cellType:), passing in the cell identifier and the class of the cell type you want to use. This allows the Rx framework to call the dequeuing methods that would normally be called if your table view still had its original delegates.
                        row, chocolate, cell in
                        cell.configureWithChocolate(chocolate: chocolate) //4 You pass in a block to be executed for each new item. You’ll get back information about the row, the chocolate at that row, and the cell, making it super-easy to configure the cell.
            }
            .addDisposableTo(disposeBag) //5 You take the Disposable returned by bindTo(_:) and add it to the disposeBag.
    }
    
    private func setupCellTapHandling() {
        tableView
            .rx
            .modelSelected(Chocolate.self) //1 You call the table view’s reactive extension’s modelSelected(_:) function, passing in the Chocolate model to get the proper type of item back. This returns an Observable.
            .subscribe(onNext: { //2 Taking that Observable, you call subscribe(onNext:), passing in a trailing closure of what should be done any time a model is selected (i.e., a cell is tapped).
                chocolate in
                ShoppingCart.sharedCart.chocolates.value.append(chocolate) //3 Within the trailing closure passed to subscribe(onNext:), you add the selected chocolate to the cart.
                
                if let selectedRowIndexPath = self.tableView.indexPathForSelectedRow {
                    self.tableView.deselectRow(at: selectedRowIndexPath, animated: true)
                } //4 Also in the closure, you make sure that the tapped row is deselected.
            })
            .addDisposableTo(disposeBag) //5 subscribe(onNext:) returns a Disposable. You add that Disposable to the disposeBag.
    }
}

//// MARK: - Table view data source
//extension RxSwiftViewController: UITableViewDataSource {
//    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return europeanChocolates.count
//    }
//    
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return false
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChocolateCell.Identifier, for: indexPath) as? ChocolateCell else {
//            //Something went wrong with the identifier.
//            return UITableViewCell()
//        }
//        
//        let chocolate = europeanChocolates[indexPath.row]
//        cell.configureWithChocolate(chocolate: chocolate)
//        
//        return cell
//    }
//}
//
//// MARK: - Table view delegate
//extension RxSwiftViewController: UITableViewDelegate {
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        
//        let chocolate = europeanChocolates[indexPath.row]
//        ShoppingCart.sharedCart.chocolates.value.append(chocolate)
//    }
//}
