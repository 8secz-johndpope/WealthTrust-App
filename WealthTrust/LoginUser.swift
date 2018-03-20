//
//  LoginUser.swift
//  WealthTrust
//
//  Created by Hemen Gohil on 9/1/16.
//  Copyright © 2016 Hemen Gohil. All rights reserved.
//

import UIKit

@objc class LoginUser: UIViewController,UITextFieldDelegate,LTHPasscodeViewControllerDelegate {
    
    
    @IBOutlet weak var txtPassword: RPFloatingPlaceholderTextField!
    @IBOutlet weak var txtEmail: RPFloatingPlaceholderTextField!
    
    var isFromPassCodeScreen = false
    @IBOutlet weak var btnLogin: UIButton!
    
    var isFrom = IS_FROM.Profile

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        SharedManager.addShadow(btnLogin)
        
        txtPassword.setValue(UIColor.whiteColor(), forKeyPath: "_placeholderLabel.textColor")
        txtEmail.setValue(UIColor.whiteColor(), forKeyPath: "_placeholderLabel.textColor")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnLoginClicked(sender: AnyObject) {
        self.ApiCall()
    }
    
    @IBAction func btnBackClick(sender: AnyObject) {
        if(isFromPassCodeScreen)
        {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        else
        {
        self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    @IBAction func btnForgotClicked(sender: AnyObject) {
        if isFromPassCodeScreen {
          
            let objforgot = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdForgotPassword) as? ForgotPassword
            objforgot!.isFromPassCodeScreen = true
            self.presentViewController(objforgot!, animated:true, completion: nil)
        }
        else{
        let objForgot = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdForgotPassword)
        self.navigationController?.pushViewController(objForgot!, animated: true)
        }
    }
    
    
    // UITextField Delegates
    func textFieldDidBeginEditing(textField: UITextField) {
        print("TextField did begin editing method called")
    }
    func textFieldDidEndEditing(textField: UITextField) {
        
        print("TextField did end editing method called")
        
    }
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        print("TextField should begin editing method called")
        return true;
    }
    func textFieldShouldClear(textField: UITextField) -> Bool {
        print("TextField should clear method called")
        return true;
    }
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        print("TextField should snd editing method called")
        return true;
    }
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        print("While entering the characters this method gets called")
        return true;
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        print("TextField should return method called")
        
        if textField==txtEmail {
            txtPassword.becomeFirstResponder()
            return true;
        }
        
        if textField == txtPassword
        {
            textField.resignFirstResponder();
            self.ApiCall()
        }
        textField.resignFirstResponder();
        
        return true;
    }
    func ApiCall(){
        
        if (txtEmail.text!.isEmpty) {
            SharedManager.invokeAlertMethod(APP_NAME, strBody: kAlertEmptyEmailId, delegate: nil)
            return;
        }
        if (txtEmail.text!.isValidEmail()) {
        }else{
            SharedManager.invokeAlertMethod(APP_NAME, strBody: kAlertEmailIdIsValidEmail, delegate: nil)
            return;
        }
        
        if (txtPassword.text!.isEmpty) {
            SharedManager.invokeAlertMethod(APP_NAME, strBody: kAlertEmptyPassword, delegate: nil)
            return;
        }
        
        txtEmail.resignFirstResponder()
        txtPassword.resignFirstResponder()
        
        if(isFromPassCodeScreen)
        {
            if (txtEmail.text != sharedInstance.objLoginUser.email)
            {
                SharedManager.invokeAlertMethod(APP_NAME, strBody: kAlertEmailIdIsValidEmail, delegate: nil)
                return;
            }
            
            if (txtPassword.text != sharedInstance.objLoginUser.password) {
                SharedManager.invokeAlertMethod(APP_NAME, strBody: kAlertPasswordIsValid, delegate: nil)
                return;
            }
            LTHPasscodeViewController.deletePasscode()

            self.dismissViewControllerAnimated(true, completion: nil)
            
            self.dismissViewControllerAnimated(true, completion: { 
                LTHPasscodeViewController.sharedUser().delegate = self
                LTHPasscodeViewController.sharedUser().showForEnablingPasscodeInViewController(self, asModal: true)
            });
            
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
//                let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
//                let objUserProfile = mainStoryboard.instantiateViewControllerWithIdentifier(ksbIdUserProfile) as! UserProfile
//                let window =  UIWindow(frame: UIScreen.mainScreen().bounds)
//                window.rootViewController = objUserProfile
//
//                self.navigationController?.viewControllers.insert(objUserProfile, atIndex: 1)
//                print(self.navigationController?.viewControllers)
//                
//                for viewController in (self.navigationController?.viewControllers)! {
//                    
//                    if viewController.isKindOfClass(UserProfile) {
//                        self.navigationController?.popToViewController(viewController, animated: true)
//                        return
//                    }
//                }
            })
        }
        else
        {
            // Call API NOW...
            // API Call
            
            let dicToSend:NSDictionary = [
                kEmailId : txtEmail.text!,
                kPassWord : txtPassword.text!]
            
            WebManagerHK.postDataToURL(kModeClientlogincheck, params: dicToSend, message: "Authenticating..") { (response) in
                print("Dic Response : \(response)")
                
                if response.objectForKey(kWAPIResponse) is NSInteger
                {
                    let mainResponse = response.objectForKey(kWAPIResponse) as! NSInteger
                    print("Response : \(mainResponse)")
                    
                    if mainResponse == 0 // Emailid Already Exist....
                    {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            SharedManager.invokeAlertMethod(APP_NAME, strBody: kAlertEmailIdInvalid, delegate: nil)
                        })
                        return
                    }
                }
                
                if response.objectForKey(kWAPIResponse) is NSDictionary
                {
                    let mainResponse = response.objectForKey(kWAPIResponse) as! NSDictionary
                    
                    let isDeletedAll = DBManager.getInstance().deleteAllUser()
                    
                    print("Cliend Id : \(mainResponse)")
                    
                    if self.isFrom == .SwitchToDirect
                    {
                        
                    }else{
                        LTHPasscodeViewController.sharedUser().delegate = self
                        LTHPasscodeViewController.sharedUser().showForEnablingPasscodeInViewController(self, asModal: true)
 
                    }
                    
                    
                    let tokenFetched = mainResponse.valueForKey(kToken) as! String
                    sharedInstance.userDefaults.setObject(tokenFetched, forKey: kToken)
                    
                    sharedInstance.objLoginUser.ClientID = String(mainResponse.valueForKey("ClientId")!)
                    sharedInstance.objLoginUser.Name = String(mainResponse.valueForKey("Name")!)
                    sharedInstance.objLoginUser.email = String(mainResponse.valueForKey("EmailId")!)
                    sharedInstance.objLoginUser.mob = String(mainResponse.valueForKey("MobileNo")!)
                    
                    if (self.txtPassword.text != nil)
                    {
                        sharedInstance.objLoginUser.password = self.txtPassword.text
                    }
                    
                    sharedInstance.objLoginUser.CAN = String(mainResponse.valueForKey("CANNO")!)
                    sharedInstance.objLoginUser.SignupStatus = String(mainResponse.valueForKey("SignUpStatus")!)
                    
                    sharedInstance.objLoginUser.InvestmentAofStatus = String(mainResponse.valueForKey("InvestmentAOFStatus")!)
                    
                    if (sharedInstance.objLoginUser.InvestmentAofStatus == "<null>")
                    {
                        sharedInstance.objLoginUser.InvestmentAofStatus = "0" // Means Pending...
                    }
                    
                    ////         INSERT USER..
                    let userInfo: User = User()
                    userInfo.ClientID = sharedInstance.objLoginUser.ClientID
                    userInfo.Name = sharedInstance.objLoginUser.Name
                    userInfo.email = sharedInstance.objLoginUser.email
                    userInfo.mob = sharedInstance.objLoginUser.mob
                    userInfo.password = sharedInstance.objLoginUser.password
                    userInfo.CAN = sharedInstance.objLoginUser.CAN
                    userInfo.SignupStatus = sharedInstance.objLoginUser.SignupStatus
                    userInfo.InvestmentAofStatus = sharedInstance.objLoginUser.InvestmentAofStatus
                    
                    print("INSERTED DATA \(userInfo)")
                    
                    let ispasswordToReset = mainResponse.valueForKey("PasswordresetFlag") as! String
                    
                    if ispasswordToReset == "true"
                    {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            let objResettPassword = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdResetScreen) as! ResetScreen
                            objResettPassword.userInfo = userInfo
                            self.navigationController?.pushViewController(objResettPassword, animated: true)
                            
                            // Reset Pasword
                        })
                        return
                    }
                    
                    let isInserted = DBManager.getInstance().addUser(userInfo)
                    if isInserted {
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            
                            sharedInstance.SynchUsedInfo()
                            
                            if self.isFrom == .AddManuallyPortfolio
                            || self.isFrom == .AutoGenerate
                            || self.isFrom == .SwitchToDirect
                            || self.isFrom == .BuySIP
                            {
                                RootManager.sharedInstance.isFrom = self.isFrom
                                RootManager.sharedInstance.navigateToScreen(self, data: [:])
                            }
                            else if(self.isFrom == .BuySIPFromTopFunds)
                            {
                                for viewController in (self.navigationController?.viewControllers)! {
                                    
                                    if viewController.isKindOfClass(BuyScreeen) {
                                        let objBuyScreen = viewController as! BuyScreeen
                                        objBuyScreen.isBuyFrom = kBUY_FROM_SELECTED_FUND
                                        objBuyScreen.isExisting = true
                                        self.navigationController?.popToViewController(objBuyScreen, animated: true)
                                        return
                                    }
                                }
                                
                                let objBuyScreen = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdBuyScreeen) as! BuyScreeen
                                objBuyScreen.isBuyFrom = kBUY_FROM_SELECTED_FUND
                                objBuyScreen.isExisting = true
                                self.navigationController?.viewControllers.insert(objBuyScreen, atIndex: 2)
                                print(self.navigationController?.viewControllers)
                                
                                for viewController in (self.navigationController?.viewControllers)! {
                                    if viewController.isKindOfClass(BuyScreeen) {
                                        self.navigationController?.popToViewController(viewController, animated: true)
                                        return
                                    }
                                }
                                
                            }
                            else if(self.isFrom == .BuySIPFromSearch)
                            {
                                for viewController in (self.navigationController?.viewControllers)! {
                                    
                                    if viewController.isKindOfClass(BuyScreeen) {
                                        let objBuyScreen = viewController as! BuyScreeen
                                        objBuyScreen.isBuyFrom = kBUY_FROM_SELECTED_FUND
                                        objBuyScreen.isExisting = true
                                        self.navigationController?.popToViewController(objBuyScreen, animated: true)
                                        return
                                    }
                                }
                                
                                let objBuyScreen = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdBuyScreeen) as! BuyScreeen
                                objBuyScreen.isBuyFrom = kBUY_FROM_SELECTED_FUND
                                objBuyScreen.isExisting = true
                                self.navigationController?.viewControllers.insert(objBuyScreen, atIndex: 2)
                                print(self.navigationController?.viewControllers)
                                
                                for viewController in (self.navigationController?.viewControllers)! {
                                    if viewController.isKindOfClass(BuyScreeen) {
                                        self.navigationController?.popToViewController(viewController, animated: true)
                                        return
                                    }
                                }
                                
                            }
                            else
                            {
                                for viewController in (self.navigationController?.viewControllers)! {
                                    if viewController.isKindOfClass(UserProfile) {
                                        self.navigationController?.popToViewController(viewController, animated: true)
                                        return
                                    }
                                }
                                let objUserProfile = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdUserProfile)
                                self.navigationController?.viewControllers.insert(objUserProfile!, atIndex: 1)
                                print(self.navigationController?.viewControllers)
                                
                                for viewController in (self.navigationController?.viewControllers)! {
                                    
                                    if viewController.isKindOfClass(UserProfile) {
                                        self.navigationController?.popToViewController(viewController, animated: true)
                                        return
                                    }
                                }
                            }
                        })
                    } else {
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        sharedInstance.SyncMFAccount()
                    })
                    
                }
            }
        }
    }
    
}
