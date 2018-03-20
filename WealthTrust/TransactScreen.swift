//
//  TransactScreen.swift
//  WealthTrust
//
//  Created by Hemen Gohil on 9/24/16.
//  Copyright © 2016 Hemen Gohil. All rights reserved.
//

import UIKit

class TransactScreen: UIViewController {

    
    @IBOutlet weak var view1Switch: UIView!
    
    @IBOutlet weak var view2BuySip: UIView!
    
    @IBOutlet weak var view3Redeem: UIView!
    
    @IBOutlet weak var view4SmartSearch: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        self.title = "Transact"
        let titleDict: NSDictionary = [NSFontAttributeName: UIFont.boldSystemFontOfSize(18),NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController!.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        
        // Change the navigation bar background color to blue.
        self.navigationController!.navigationBar.barTintColor = UIColor.defaultAppColorBlue

        SharedManager.addShadowToView(view1Switch)
        SharedManager.addShadowToView(view2BuySip)
        SharedManager.addShadowToView(view3Redeem)
        SharedManager.addShadowToView(view4SmartSearch)
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)

        
        self.setNavigationBarItemLeftForTransactScreen()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func btnSwitchClicked(sender: UIButton) {
        print("Switch Clicked")
        sender.backgroundColor = UIColor.clearColor()
        RootManager.sharedInstance.isFrom = IS_FROM.SwitchToDirect
        RootManager.sharedInstance.navigateToScreen(self, data: [:])
    }
    
    @IBAction func btnBuySIPClicked(sender: UIButton) {
        print("Buy/SIP Clicked")
        sender.backgroundColor = UIColor.clearColor()
        RootManager.sharedInstance.isFrom = IS_FROM.BuySIP
        RootManager.sharedInstance.navigateToScreen(self, data: [:])
    }
    
    
    @IBAction func btnRedeemClicked(sender: UIButton) {
        print("Redeem Clicked")
        sender.backgroundColor = UIColor.clearColor()

        let allUser = DBManager.getInstance().getAllUser()
        if allUser.count==0
        {
            SharedManager.invokeAlertMethod(APP_NAME, strBody: "Please do login first", delegate: nil)
            
        }else{

            let arrMFAccounts = DBManager.getInstance().getMFAccountsForRedeemCondition()
            if arrMFAccounts.count==0 {
                SharedManager.invokeAlertMethod("No schemes found", strBody: "Currently there are no schemes in your WealthTrust portfolio for redemption.", delegate: nil)
            }else{
                let objRedeem = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdRedeemScreen) as! RedeemScreen
                objRedeem.arrSchemes = arrMFAccounts
                self.navigationController?.pushViewController(objRedeem, animated: true)
            }

        }
    }

    @IBAction func btnSmartSearchClicked(sender: UIButton) {
        print("Smart Clicked")
        sender.backgroundColor = UIColor.clearColor()
        let objSearch = self.storyboard?.instantiateViewControllerWithIdentifier(ksbidSearchScreen) as! SearchScreen
        self.navigationController?.pushViewController(objSearch, animated: true)
    }
    
    @IBAction func btnTouchDown(sender: UIButton) {
        sender.backgroundColor = UIColor(white: 1, alpha: opacityButtonTouchEffect)
    }
    @IBAction func btnTouchDragEnter(sender: UIButton) {
        sender.backgroundColor = UIColor(white: 1, alpha: opacityButtonTouchEffect)
    }
    @IBAction func btnTouchDragExit(sender: UIButton) {
        sender.backgroundColor = UIColor.clearColor()
    }

    
}
