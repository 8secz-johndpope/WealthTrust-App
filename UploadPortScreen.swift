//
//  UploadPortScreen.swift
//  WealthTrust
//
//  Created by Hemen Gohil on 11/21/16.
//  Copyright © 2016 Hemen Gohil. All rights reserved.
//

import UIKit

class UploadPortScreen: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var lblPasswordIs: UILabel!
    @IBOutlet weak var viewEmailSubmitted: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewEmailSubmitted.hidden = true
        txtEmail.becomeFirstResponder()
        let allUser = DBManager.getInstance().getAllUser()
        if allUser.count==0
        {
            
        }else{
            
            let objUser = allUser.objectAtIndex(0) as! User
            print(objUser)
            
            self.txtEmail.text = objUser.email
            
            let mobile = objUser.mob
//            let str = String(mobile.characters.prefix(5))//Get First 5character
            lblPasswordIs.text = "You will receive your portfolio statement by email. Password is \(mobile)"
        }
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

    @IBAction func btnBkClicked(sender: AnyObject) {
        _ = self.navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func btnSubmitClicke(sender: AnyObject) {
        
        if (txtEmail.text!.isEmpty) {
            SharedManager.invokeAlertMethod(APP_NAME, strBody: kAlertEmptyEmailId, delegate: nil)
            return;
        }
        if (txtEmail.text!.isValidEmail()) {
        }else{
            SharedManager.invokeAlertMethod(APP_NAME, strBody: kAlertEmailIdIsValidEmail, delegate: nil)
            return;
        }
        txtEmail.resignFirstResponder()

        
        let allUser = DBManager.getInstance().getAllUser()
        if allUser.count==0
        {
            
        }else{
            
            let objUser = allUser.objectAtIndex(0) as! User
            print(objUser)
            
            if objUser.ClientID=="" {
                return
            }
            if objUser.ClientID=="0" {
                return
            }
            
            if (objUser.ClientID != nil) {

                let dicToSend:NSDictionary = [
                    kEmailId : txtEmail.text!,
                    "ClientId" : objUser.ClientID!]
                
                WebManagerHK.postDataToURL(kModegeneratestatement, params: dicToSend, message: "Submitting email id..") { (response) in
                    print("Dic Response : \(response)")
                    
                    if response.objectForKey(kWAPIResponseStatus) is String
                    {
                        let mainResponse = response.objectForKey(kWAPIResponseStatus) as! String
                        print("Response : \(mainResponse)")
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            
                            self.txtEmail.text = ""
                            
//                            let attributeColor = [NSForegroundColorAttributeName: UIColor.blueColor()]
//                            let attribEmail = NSAttributedString(string: "service@wealthtrust.in", attributes: attributeColor)

                            let alertController = UIAlertController(title: "Email ID Submitted", message: "Thank you for providing the details. You'll receive mutual fund statement from CAMS on entered email in few hours. \nForword it to service@wealthtrust.in", preferredStyle: .Alert)
                            
                            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: { (defaultAction1) in
                                
                                for viewController in (self.navigationController?.viewControllers)! {
                                    if viewController.isKindOfClass(PortfolioScreen) {
                                        self.navigationController?.popToViewController(viewController, animated: true)
                                        return
                                    }
                                    if viewController.isKindOfClass(MainViewController) {
                                        self.navigationController?.popToViewController(viewController, animated: true)
                                        return
                                    }
                                }
                            })
                            alertController.addAction(defaultAction)
//                            self.presentViewController(alertController, animated: true, completion: nil)
                            self.view.bringSubviewToFront(self.viewEmailSubmitted)
                            self.viewEmailSubmitted.hidden = false
                        })
                    }
                }
            }
        }
    }
    
    @IBAction func btnOKEmailSubmitedClicked(sender: AnyObject) {
        for viewController in (self.navigationController?.viewControllers)! {
            if viewController.isKindOfClass(PortfolioScreen) {
                self.navigationController?.popToViewController(viewController, animated: true)
                return
            }
            if viewController.isKindOfClass(MainViewController) {
                self.navigationController?.popToViewController(viewController, animated: true)
                return
            }
        }
        self.viewEmailSubmitted.hidden = true
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
        textField.resignFirstResponder();
        return true;
    }
    

    
}
