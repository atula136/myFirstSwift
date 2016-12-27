//
//  SegmentioHomeViewController.swift
//  myFirstSwift
//
//  Created by tiennguyen on 12/26/16.
//  Copyright © 2016 tiennguyen. All rights reserved.
//

import UIKit
import Segmentio

class SegmentioHomeViewController: BaseViewController {
    
    fileprivate var currentStyle = SegmentioStyle.onlyImage
    fileprivate var containerViewController: EmbedContainerViewController?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == String(describing: EmbedContainerViewController.self) {
            containerViewController = segue.destination as? EmbedContainerViewController
            containerViewController?.style = currentStyle
        }
    }
    
    // MARK: - Actions
    
    @IBAction func showMenu(_ sender: UIBarButtonItem) {
        SideMenuViewController.create().showSideMenu(
            viewController: self,
            currentStyle: currentStyle,
            sideMenuDidHide: { [weak self] style in
                self?.dismiss(
                    animated: false,
                    completion: {
                        if self?.currentStyle != style {
                            self?.currentStyle = style
                            self?.containerViewController?.swapViewControllers(style)
                        }
                }
                )
            }
        )
    }
    
}
