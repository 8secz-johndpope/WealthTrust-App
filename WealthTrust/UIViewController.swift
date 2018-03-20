//
//  UIViewControllerExtension.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 1/19/15.
//  Copyright (c) 2015 Yuji Hato. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func setNavigationBarItem() {
        
        self.addLeftBarButtonWithImage(UIImage(named: "ic_menu_black_24dp")!)
        
        
        self.addRightBarButtonWithImage(UIImage(named: "ic_account_circle_white")!,buttonImage2: UIImage(named: "ic_search_white")!)
        
        
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
        self.slideMenuController()?.addLeftGestures()
//        self.slideMenuController()?.addRightGestures()

        
    }
    
    func setNavigationBarItemForWebView() {
        
        self.addLeftBarButtonWithImage(UIImage(named: "ic_menu_black_24dp")!)
        
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
        self.slideMenuController()?.addLeftGestures()

    }

    func setNavigationBarItemLeft() {
        
        self.addLeftBarButtonWithImage(UIImage(named: "ic_menu_black_24dp")!)
        
//        self.addRightBarButtonWithImage(UIImage(named: "ic_account_circle_white")!,buttonImage2: UIImage(named: "ic_search_white")!)
        
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
        self.slideMenuController()?.addLeftGestures()
        //        self.slideMenuController()?.addRightGestures()
        
        
    }

    
    func removeNavigationBarItem() {
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.rightBarButtonItem = nil
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
    }
    func removeNavigationBarItemOnRightSideOnly() {
        self.navigationItem.rightBarButtonItem = nil
        self.slideMenuController()?.removeLeftGestures()
    }
    
    func setNavigationBarItemLeftForTransactScreen() {
        
        self.addLeftBarButtonWithImage(UIImage(named: "ic_menu_black_24dp")!)
        
        self.addRightBarButtonWithImageForTransaction(UIImage(named: "ic_search_white")!)
        
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
        self.slideMenuController()?.addLeftGestures()
        //        self.slideMenuController()?.addRightGestures()
        
        
    }

    func setNavigationBarItemLeftForPortfolioScreen() {
        
        self.addLeftBarButtonWithImage(UIImage(named: "ic_menu_black_24dp")!)
        
        self.addRightBarButtonWithImageForPortfolio(UIImage(named: "ic_search_white")!)
        
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
        self.slideMenuController()?.addLeftGestures()
        
        
    }


}
