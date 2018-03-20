//
//  ResetScreen.swift
//  WealthTrust
//
//  Created by Hemen Gohil on 10/26/16.
//  Copyright © 2016 Hemen Gohil. All rights reserved.
//

import UIKit

class ResetScreen: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var txtConfirm: UITextField!
    
    
    
    @IBOutlet weak var btnReset: UIButton!
    
    var userInfo: User = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        SharedManager.addShadow(btnReset)
        
        txtPassword .setValue(UIColor.whiteColor(), forKeyPath: "_placeholderLabel.textColor")
        txtConfirm .setValue(UIColor.whiteColor(), forKeyPath: "_placeholderLabel.textColor")

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func btnBackClickedd(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }

    @IBAction func btnResetClickef(sender: AnyObject) {
        
        if (txtPassword.text!.isEmpty) {
            SharedManager.invokeAlertMethod(APP_NAME, strBody: kAlertEmptyPassword, delegate: nil)
            return;
        }
        
        if txtPassword.text?.characters.count>7 && txtPassword.text?.characters.count<=12 {
        }else{
            SharedManager.invokeAlertMethod(APP_NAME, strBody: kAlertPassword8to12, delegate: nil)
            return
        }
        
        if (txtPassword.text!.isAlphanumeric()) {
        }else{
            SharedManager.invokeAlertMethod(APP_NAME, strBody: kAlertPasswordAlphanumeric, delegate: nil)
            return;
        }
        
        if (txtConfirm.text!.isEmpty) {
            SharedManager.invokeAlertMethod(APP_NAME, strBody: kAlertEmptyConfirmPassword, delegate: nil)
            return;
        }
        
        if (txtConfirm.text != txtPassword.text) {
            SharedManager.invokeAlertMethod(APP_NAME, strBody: kAlertSamePasswordConfirmPassword, delegate: nil)
            return;
        }

        
        txtPassword.resignFirstResponder()
        txtConfirm.resignFirstResponder()

        let dicToSend:NSDictionary = [
            kEmailId : sharedInstance.objLoginUser.email!,
            kPassWord : txtPassword.text!]
        
        
        WebManagerHK.postDataToURL(kModeClientUpdatePassword, params: dicToSend, message: "Resetting password..") { (response) in
            print("Dic Response : \(response)")
            
            if response.objectForKey(kWAPIResponse) is NSInteger
            {
                let mainResponse = response.objectForKey(kWAPIResponse) as! NSInteger
                print("Response : \(mainResponse)")
                
                if mainResponse == 1 // ....
                {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        if (self.txtPassword.text != nil)
                        {
                            sharedInstance.objLoginUser.password = self.txtPassword.text
                        }
                        self.userInfo.password = sharedInstance.objLoginUser.password
                        print(self.userInfo.password)
                        
                        let isInserted = DBManager.getInstance().addUser(self.userInfo)
                        if isInserted {
                            
                        } else {
                        }

                            sharedInstance.SynchUsedInfo()
                            
                            self.txtPassword.text = ""
                            self.txtConfirm.text = ""
                            self.navigationController?.popToRootViewControllerAnimated(true)

                    })
                    return
                }
                if mainResponse == 0 // ....
                {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        SharedManager.invokeAlertMethod(APP_NAME, strBody: kAlertEmailIdNotExists, delegate: nil)
                    })
                    return
                }
            }
        }

        
    }
}
