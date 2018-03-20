//
//  RootManager.swift
//  WealthTrust
//
//  Created by Hemen Gohil on 2/11/17.
//  Copyright © 2017 Hemen Gohil. All rights reserved.

import Foundation

let shared = RootManager.sharedInstance

class RootManager: NSObject {
    
    static let sharedInstance = RootManager() // SHARED OBJECT....
    
    var isFrom = IS_FROM.Profile
    
    func navigateToScreen(controller: UIViewController, data : NSDictionary) {
        if self.isFrom == .Profile
        {
            
        }
        else if self.isFrom == .SwitchToDirect
        {
            navigateToSwitchScreen(controller)
        }
        else if self.isFrom == .SmartSavings
        {
            navigateToSmartSavingScreen(controller)
        }
        else if self.isFrom == .MyOrders
        {
        }
        else if self.isFrom == .AddManuallyPortfolio
        {
            navigateToAddManuallyScreen(controller)
        }
        else if self.isFrom == .AutoGenerate
        {
            navigateToAutoGeneratePortfolioScreen(controller)
        }
        else if self.isFrom == .Transaction
        {
            
        }
        else if self.isFrom == .BuySIP
        {
            navigateToBuySIPScreenWithData(controller, details: data)
        }
        else if self.isFrom == .BuySIPFromTopFunds
        {
            navigateToBuySIPScreenWithData(controller, details: data)
        }
        else if self.isFrom == .BuySIPFromSearch
        {
            navigateToBuySIPScreenWithData(controller, details: data)
        }
        else if self.isFrom == .BuySIPFromPortfolio
        {
            navigateToBuySIPScreenWithData(controller, details: data)
            //navigateToBuySIPScreenWithDataFromPort(controller, details: data)
        }

    }

    func navigateToSwitchScreen(controller: UIViewController) {
        
        let objUser = DBManager.getInstance().getLoggedInUserDetails()
        if objUser.SignupStatus == nil { //No Signup
            print("Yes Blank....")
            
            let objUserLoginSignYp = controller.storyboard?.instantiateViewControllerWithIdentifier(ksbIdUserLoginSignUp) as! UserLoginSignUp
            objUserLoginSignYp.isFrom = self.isFrom
            controller.navigationController?.pushViewController(objUserLoginSignYp, animated: true)
            
        }
        else
        {
            let allUser = DBManager.getInstance().getAllUser()
            if allUser.count==0
            {
                let objUserLoginSignYp = controller.storyboard?.instantiateViewControllerWithIdentifier(ksbIdUserLoginSignUp) as! UserLoginSignUp
                objUserLoginSignYp.isFrom = self.isFrom
                controller.navigationController?.pushViewController(objUserLoginSignYp, animated: true)

            }else{

                let objUser = allUser.objectAtIndex(0) as! User
                
                if objUser.SignupStatus == "\(SIGNUP_STATUS.PANVERIFICATIONPENDING4.hashValue)" { // Pan Verification Pending...
                    
                    let alertController = UIAlertController(title: "PAN Verification", message: "Please fill the details and upload a PAN card picture for verification. This is necessary for SWITCH order.", preferredStyle: .Alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: { (defaultAction1) in
                        
                        let objDocScreen = controller.storyboard?.instantiateViewControllerWithIdentifier(ksbIdDocScreen) as! DocScreen
                        objDocScreen.isFrom = self.isFrom
                        controller.navigationController?.setNavigationBarHidden(true, animated: true)
                        controller.navigationController?.pushViewController(objDocScreen, animated: true)
                        
                    })
                    alertController.addAction(defaultAction)
                    controller.presentViewController(alertController, animated: true, completion: nil)

                }else{
                    SharedManager.sharedInstance.objLoginUser = objUser
                    
                    SharedManager.sharedInstance.userDefaults .setObject("Select Fund", forKey: kSelectFromFundValue)
                    SharedManager.sharedInstance.userDefaults .setObject("Select Fund", forKey: kSelectToFundValue)
                    
                    let objSwitchScreen = controller.storyboard?.instantiateViewControllerWithIdentifier(ksbIdSwitchScreen) as! SwitchScreen
                    controller.navigationController?.pushViewController(objSwitchScreen, animated: true)
                }
            }
        }
    }
    
    func navigateToBuySIPScreenWithData(controller: UIViewController, details : NSDictionary)
    {
        
        if details.allKeys.count==0 {
        }else{
            
            let jo = NSMutableDictionary()
            jo.setValue(details.valueForKey("Fund_Code"), forKey: "Fund_Code")
            jo.setValue(details.valueForKey("NAV"), forKey: "NAV")
            jo.setValue(details.valueForKey("NAVDate"), forKey: "NAVDate")
            jo.setValue(details.valueForKey("Plan_Name"), forKey: "Plan_Name")
            jo.setValue(details.valueForKey("Plan_Opt"), forKey: "Div_Opt")
            jo.setValue(details.valueForKey("Scheme_Code"), forKey: "Scheme_Code")
            
            SharedManager.sharedInstance.userDefaults.setObject(jo, forKey: kSelectBuyNowScheme)
 
        }

        if self.isFrom == .BuySIPFromPortfolio{
            
            let allUser = DBManager.getInstance().getAllUser()
            if allUser.count==0
            {
                return;
            }else{
                
                let objUser = allUser.objectAtIndex(0) as! User
                if objUser.InvestmentAofStatus == "\(INVESTMENTAACCOUNT_STATUS.PENDING0.hashValue)"
                {
                    let alertController = UIAlertController(title: "Create Investment Account", message: "Please fill the required details and upload documents to create an Investment account. This is necessary for BUY/SIP order.", preferredStyle: .Alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: { (defaultAction1) in
                        
                        let objDocScreen = controller.storyboard?.instantiateViewControllerWithIdentifier(ksbIdDocScreen) as! DocScreen
                        objDocScreen.isFrom = self.isFrom
                        controller.navigationController?.setNavigationBarHidden(true, animated: true)
                        controller.navigationController?.pushViewController(objDocScreen, animated: true)
                        
                    })
                    alertController.addAction(defaultAction)
                    controller.presentViewController(alertController, animated: true, completion: nil)
                }
                else
                {
                    if details.allKeys.count==0 {
                        SharedManager.sharedInstance.objLoginUser = objUser
                        SharedManager.sharedInstance.userDefaults .setObject(kEnterSchemeName, forKey: kSelectBuyNowScheme)
                        let objBuyScreen = controller.storyboard?.instantiateViewControllerWithIdentifier(ksbIdBuyScreeen) as! BuyScreeen
                        controller.navigationController?.pushViewController(objBuyScreen, animated: true)
                    }else{
                        let objBuyScreen = controller.storyboard?.instantiateViewControllerWithIdentifier(ksbIdBuyScreeen) as! BuyScreeen
                        objBuyScreen.isBuyFrom = kBUY_FROM_SELECTED_FUND
                        objBuyScreen.isExisting = true
                        controller.navigationController?.pushViewController(objBuyScreen, animated: true)
                    }
                }
            }
            return
        }
        
        
        let objUser = DBManager.getInstance().getLoggedInUserDetails()
        if objUser.SignupStatus == nil {
            print("Yes Blank....")
            
            let objUserLoginSignYp = controller.storyboard?.instantiateViewControllerWithIdentifier(ksbIdUserLoginSignUp) as! UserLoginSignUp
            objUserLoginSignYp.isFrom = self.isFrom
            controller.navigationController?.pushViewController(objUserLoginSignYp, animated: true)
        }
        else
        {
            let allUser = DBManager.getInstance().getAllUser()
            if allUser.count==0
            {
                let objUserLoginSignYp = controller.storyboard?.instantiateViewControllerWithIdentifier(ksbIdUserLoginSignUp) as! UserLoginSignUp
                objUserLoginSignYp.isFrom = self.isFrom
                controller.navigationController?.pushViewController(objUserLoginSignYp, animated: true)
                
            }else{
                
                let objUser = allUser.objectAtIndex(0) as! User
                
                if objUser.SignupStatus == "\(SIGNUP_STATUS.PANVERIFICATIONPENDING4.hashValue)" { // Pan Verification Pending...
                    
                    let alertController = UIAlertController(title: "Create Investment Account", message: "Please fill the required details and upload documents to create an Investment account. This is necessary for BUY/SIP order.", preferredStyle: .Alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: { (defaultAction1) in
                        
                        let objDocScreen = controller.storyboard?.instantiateViewControllerWithIdentifier(ksbIdDocScreen) as! DocScreen
                        objDocScreen.isFrom = self.isFrom
                        controller.navigationController?.setNavigationBarHidden(true, animated: true)
                        controller.navigationController?.pushViewController(objDocScreen, animated: true)
                        
                    })
                    alertController.addAction(defaultAction)
                    controller.presentViewController(alertController, animated: true, completion: nil)
                    
                }else{
                    
                    if objUser.InvestmentAofStatus == "\(INVESTMENTAACCOUNT_STATUS.PENDING0.hashValue)"
                    {
                        let alertController = UIAlertController(title: "Create Investment Account", message: "Please fill the required details and upload documents to create an Investment account. This is necessary for BUY/SIP order.", preferredStyle: .Alert)
                        
                        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: { (defaultAction1) in
                            
                            let objDocScreen = controller.storyboard?.instantiateViewControllerWithIdentifier(ksbIdDocScreen) as! DocScreen
                            objDocScreen.isFrom = self.isFrom
                            controller.navigationController?.setNavigationBarHidden(true, animated: true)
                            controller.navigationController?.pushViewController(objDocScreen, animated: true)
                            
                        })
                        alertController.addAction(defaultAction)
                        controller.presentViewController(alertController, animated: true, completion: nil)
                    }
                    else
                    {
                        
                        if details.allKeys.count==0 {
                            SharedManager.sharedInstance.objLoginUser = objUser
                            SharedManager.sharedInstance.userDefaults .setObject(kEnterSchemeName, forKey: kSelectBuyNowScheme)
                            let objBuyScreen = controller.storyboard?.instantiateViewControllerWithIdentifier(ksbIdBuyScreeen) as! BuyScreeen
                            controller.navigationController?.pushViewController(objBuyScreen, animated: true)
                            
                        }else{
                            
                            let objBuyScreen = controller.storyboard?.instantiateViewControllerWithIdentifier(ksbIdBuyScreeen) as! BuyScreeen
                            objBuyScreen.isBuyFrom = kBUY_FROM_SELECTED_FUND
                            objBuyScreen.isExisting = true
                            controller.navigationController?.pushViewController(objBuyScreen, animated: true)

                        }
                    }
                }
                
            }
        }
    }
    

    func navigateToSmartSavingScreen(controller: UIViewController) {
        let objSmartSaving = controller.storyboard?.instantiateViewControllerWithIdentifier(ksbIdSmartSavingScreen) as! SmartSavingScreen
        controller.navigationController!.pushViewController(objSmartSaving, animated: true)
    }
    
    func navigateToDirectSavingCalcScreen(controller: UIViewController) {
        let objDirect = controller.storyboard?.instantiateViewControllerWithIdentifier(ksbIdDirectSavingCalcScreen) as! DirectSavingCalcScreen
        controller.navigationController!.pushViewController(objDirect, animated: true)
    }
    
    func navigateToTopFundScreen(controller: UIViewController) {
        let objTopFunds = controller.storyboard?.instantiateViewControllerWithIdentifier(ksbIdTopFundsScreen) as! TopFundsScreen
        controller.navigationController!.pushViewController(objTopFunds, animated: true)
    }

    
    func navigateToAddManuallyScreen(controller: UIViewController) {
        
        let objUser = DBManager.getInstance().getLoggedInUserDetails()
        if objUser.SignupStatus == nil {
            print("Yes Blank....")
            
            let objUserLoginSignYp = controller.storyboard?.instantiateViewControllerWithIdentifier(ksbIdUserLoginSignUp) as! UserLoginSignUp
            objUserLoginSignYp.isFrom = self.isFrom
            controller.navigationController?.pushViewController(objUserLoginSignYp, animated: true)
            
        }
        else
        {
            
            for viewController in (controller.navigationController?.viewControllers)! {
                
                if viewController.isKindOfClass(AddPortfolioManually) {
                    controller.navigationController?.popToViewController(viewController, animated: true)
                    return
                }
            }
            let objUserProfile = controller.storyboard?.instantiateViewControllerWithIdentifier(ksbIdAddPortfolioManually) as! AddPortfolioManually
            controller.navigationController?.viewControllers.insert(objUserProfile, atIndex: 1)
            print(controller.navigationController?.viewControllers)
            
            for viewController in (controller.navigationController?.viewControllers)! {
                
                if viewController.isKindOfClass(AddPortfolioManually) {
                    controller.navigationController?.popToViewController(viewController, animated: true)
                    return
                }
            }
        }

    }
    
    func navigateToAutoGeneratePortfolioScreen(controller: UIViewController) {
        
        let objUser = DBManager.getInstance().getLoggedInUserDetails()
        if objUser.SignupStatus == nil {
            print("Yes Blank....")
            
            let objUserLoginSignYp = controller.storyboard?.instantiateViewControllerWithIdentifier(ksbIdUserLoginSignUp) as! UserLoginSignUp
            objUserLoginSignYp.isFrom = self.isFrom
            controller.navigationController?.pushViewController(objUserLoginSignYp, animated: true)
            
        }
        else
        {
            for viewController in (controller.navigationController?.viewControllers)! {
                
                if viewController.isKindOfClass(UploadPortfolioInstruScreen) {
                    controller.navigationController?.popToViewController(viewController, animated: true)
                    return
                }
            }
            
            let objUserProfile = controller.storyboard?.instantiateViewControllerWithIdentifier(ksbIdUploadPortfolioInstruScreen) as! UploadPortfolioInstruScreen
            controller.navigationController?.viewControllers.insert(objUserProfile, atIndex: 1)
            print(controller.navigationController?.viewControllers)
            
            for viewController in (controller.navigationController?.viewControllers)! {
                
                if viewController.isKindOfClass(UploadPortfolioInstruScreen) {
                    controller.navigationController?.popToViewController(viewController, animated: true)
                    return
                }
            }
        }
        

    }
    
    
    
    
    //    func navigateToBuySIPScreen(controller: UIViewController) {
    //
    //        let objUser = DBManager.getInstance().getLoggedInUserDetails()
    //        if objUser.SignupStatus == nil {
    //            print("Yes Blank....")
    //
    //            let objUserLoginSignYp = controller.storyboard?.instantiateViewControllerWithIdentifier(ksbIdUserLoginSignUp) as! UserLoginSignUp
    //            objUserLoginSignYp.isFrom = IS_FROM.BuySIP
    //            controller.navigationController?.pushViewController(objUserLoginSignYp, animated: true)
    //        }
    //        else
    //        {
    //
    //            let allUser = DBManager.getInstance().getAllUser()
    //            if allUser.count==0
    //            {
    //                let objUserLoginSignYp = controller.storyboard?.instantiateViewControllerWithIdentifier(ksbIdUserLoginSignUp) as! UserLoginSignUp
    //                objUserLoginSignYp.isFrom = IS_FROM.BuySIP
    //                controller.navigationController?.pushViewController(objUserLoginSignYp, animated: true)
    //
    //            }else{
    //
    //                let objUser = allUser.objectAtIndex(0) as! User
    //
    //                if objUser.SignupStatus == "\(SIGNUP_STATUS.PANVERIFICATIONPENDING4.hashValue)" { // Pan Verification Pending...
    //
    //                    let alertController = UIAlertController(title: "Create Investment Account", message: "Please fill the required details and upload documents to create an Investment account. This is necessary for BUY/SIP order.", preferredStyle: .Alert)
    //
    //                    let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: { (defaultAction1) in
    //
    //                        let objDocScreen = controller.storyboard?.instantiateViewControllerWithIdentifier(ksbIdDocScreen) as! DocScreen
    //                        objDocScreen.isFrom = IS_FROM.BuySIP
    //                        controller.navigationController?.setNavigationBarHidden(true, animated: true)
    //                        controller.navigationController?.pushViewController(objDocScreen, animated: true)
    //
    //                    })
    //                    alertController.addAction(defaultAction)
    //                    controller.presentViewController(alertController, animated: true, completion: nil)
    //
    //                }else{
    //
    //                    if objUser.InvestmentAofStatus == "\(INVESTMENTAACCOUNT_STATUS.PENDING0.hashValue)"
    //                    {
    //                        let alertController = UIAlertController(title: "Create Investment Account", message: "Please fill the required details and upload documents to create an Investment account. This is necessary for BUY/SIP order.", preferredStyle: .Alert)
    //
    //                        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: { (defaultAction1) in
    //
    //                            let objDocScreen = controller.storyboard?.instantiateViewControllerWithIdentifier(ksbIdDocScreen) as! DocScreen
    //                            objDocScreen.isFrom = IS_FROM.BuySIP
    //                            controller.navigationController?.setNavigationBarHidden(true, animated: true)
    //                            controller.navigationController?.pushViewController(objDocScreen, animated: true)
    //
    //                        })
    //                        alertController.addAction(defaultAction)
    //                        controller.presentViewController(alertController, animated: true, completion: nil)
    //                    }
    //                    else
    //                    {
    //                        SharedManager.sharedInstance.objLoginUser = objUser
    //                        SharedManager.sharedInstance.userDefaults .setObject(kEnterSchemeName, forKey: kSelectBuyNowScheme)
    //                        let objBuyScreen = controller.storyboard?.instantiateViewControllerWithIdentifier(ksbIdBuyScreeen) as! BuyScreeen
    //                        controller.navigationController?.pushViewController(objBuyScreen, animated: true)
    //                    }
    //                }
    //                
    //            }
    //        }
    //    }

    
    
    
    
    
    
//    func navigateToBuySIPScreenWithDataFromPort(controller: UIViewController, details : NSDictionary)
//    {
//        
//        //        if details.allKeys.count==0 {
//        //        }else{
//        //            let jo = NSMutableDictionary()
//        //            jo.setValue(details.valueForKey("Fund_Code"), forKey: "Fund_Code")
//        //            jo.setValue(details.valueForKey("NAV"), forKey: "NAV")
//        //            jo.setValue(details.valueForKey("NAVDate"), forKey: "NAVDate")
//        //            jo.setValue(details.valueForKey("Plan_Name"), forKey: "Plan_Name")
//        //            jo.setValue(details.valueForKey("Plan_Opt"), forKey: "Div_Opt")
//        //            jo.setValue(details.valueForKey("Scheme_Code"), forKey: "Scheme_Code")
//        //
//        //            SharedManager.sharedInstance.userDefaults.setObject(jo, forKey: kSelectBuyNowScheme)
//        //
//        //        }
//        
//        
//        let allUser = DBManager.getInstance().getAllUser()
//        if allUser.count==0
//        {
//            return;
//        }else{
//            
//            let objUser = allUser.objectAtIndex(0) as! User
//            if objUser.InvestmentAofStatus == "\(INVESTMENTAACCOUNT_STATUS.PENDING0.hashValue)"
//            {
//                let alertController = UIAlertController(title: "Create Investment Account", message: "Please fill the required details and upload documents to create an Investment account. This is necessary for BUY/SIP order.", preferredStyle: .Alert)
//                
//                let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: { (defaultAction1) in
//                    
//                    let objDocScreen = controller.storyboard?.instantiateViewControllerWithIdentifier(ksbIdDocScreen) as! DocScreen
//                    objDocScreen.isFrom = self.isFrom
//                    controller.navigationController?.setNavigationBarHidden(true, animated: true)
//                    controller.navigationController?.pushViewController(objDocScreen, animated: true)
//                    
//                })
//                alertController.addAction(defaultAction)
//                controller.presentViewController(alertController, animated: true, completion: nil)
//            }
//            else
//            {
//                
//                if details.allKeys.count==0 {
//                    SharedManager.sharedInstance.objLoginUser = objUser
//                    SharedManager.sharedInstance.userDefaults .setObject(kEnterSchemeName, forKey: kSelectBuyNowScheme)
//                    let objBuyScreen = controller.storyboard?.instantiateViewControllerWithIdentifier(ksbIdBuyScreeen) as! BuyScreeen
//                    controller.navigationController?.pushViewController(objBuyScreen, animated: true)
//                    
//                }else{
//                    
//                    let objBuyScreen = controller.storyboard?.instantiateViewControllerWithIdentifier(ksbIdBuyScreeen) as! BuyScreeen
//                    objBuyScreen.isBuyFrom = kBUY_FROM_SELECTED_FUND
//                    objBuyScreen.isExisting = true
//                    controller.navigationController?.pushViewController(objBuyScreen, animated: true)
//                    
//                }
//            }
//        }
//        
//    }

}
