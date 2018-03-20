//
//  ForgotPassword.swift
//  WealthTrust
//
//  Created by Hemen Gohil on 9/15/16.
//  Copyright © 2016 Hemen Gohil. All rights reserved.
//

import UIKit

class ForgotPassword: UIViewController {

    var isFromPassCodeScreen = false

    @IBOutlet weak var btnSubmit: UIButton!
    
    @IBOutlet weak var txtEmail: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SharedManager.addShadow(btnSubmit)
        
        txtEmail .setValue(UIColor.whiteColor(), forKeyPath: "_placeholderLabel.textColor")
        
        // Do any additional setup after loading the view.
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
    @IBAction func btnBackClick(sender: AnyObject) {
        if isFromPassCodeScreen {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        else{
        self.navigationController?.popViewControllerAnimated(true)
        }
    }
    @IBAction func btnSubmitClicked(sender: AnyObject) {
        
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
        
        // Proceed to Call..
        
        // Call API NOW...
        // API Call
        
        let dicToSend:NSDictionary = [
            kEmailId : txtEmail.text!]
        
        WebManagerHK.postDataToURL(kModeClientForgotpassword, params: dicToSend, message: "Validating..") { (response) in
            print("Dic Response : \(response)")
            
            if response.objectForKey(kWAPIResponse) is String
            {
                let mainResponse = response.objectForKey(kWAPIResponse) as! String
                print("Response : \(mainResponse)")
                
                if mainResponse == "true" // ....
                {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        self.txtEmail.text = ""
                        
                        let alert = UIAlertController(title: APP_NAME, message: kAlertEmailSent, preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { action in
                            if self.isFromPassCodeScreen{
                                self.dismissViewControllerAnimated(true, completion: nil)
                            }
                            if let navController = self.navigationController {
                                navController.popViewControllerAnimated(true)
                            }
                        }))
                        self.presentViewController(alert, animated: true, completion: nil)
                        
                    })
                    return
                }
                if mainResponse == "false" // ....
                {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        self.txtEmail.text = ""
                        
                        SharedManager.invokeAlertMethod(APP_NAME, strBody: kAlertEmailIdNotExists, delegate: nil)
                    })
                    return
                }
            }
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
        
        textField.resignFirstResponder();
        return true;
    }

    
}
