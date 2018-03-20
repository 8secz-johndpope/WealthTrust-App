//
//  SmartSavingScreen.swift
//  WealthTrust
//
//  Created by Shree ButBhavani on 11/01/17.
//  Copyright © 2017 Hemen Gohil. All rights reserved.
//

import UIKit

class SmartSavingScreen: UIViewController , UITextFieldDelegate {

    @IBOutlet weak var txtAmountTextField : UITextField!
    @IBOutlet weak var topImage: UIImageView!
    @IBOutlet weak var btnNextBottomConsatrait : NSLayoutConstraint?
    //@IBOutlet weak var btnNextBottomConsatrait: NSLayoutConstraint()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        txtAmountTextField.delegate = self
        topImage.layer.cornerRadius = topImage.frame.height/2
        topImage.layer.masksToBounds = true;
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIKeyboardDidHideNotification, object: nil)
    }

    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        txtAmountTextField.becomeFirstResponder()
    }
    
    
    @IBAction func btnSearchClicked(sender: AnyObject) {
        let objLoginUser = self.storyboard?.instantiateViewControllerWithIdentifier(ksbidSearchScreen)
        self.navigationController?.pushViewController(objLoginUser!, animated: true)
        
    }
    
    @IBAction func btnInfoClicked(sender: AnyObject) {
        let objWebView = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdWebViewController) as! WebViewController
        objWebView.urlLink = NSURL(string:URL_LIQUID_FUND_BETTER_THAN_SAVINGS)!
        objWebView.screenTitle = kTitleKnow_More_Liquid_Funds
        self.navigationController?.pushViewController(objWebView, animated: true)
    }
    
    @IBAction func btnNextClicked(sender: AnyObject)
    {
        if !sharedInstance.isUserLogin()
        {
            SharedManager.invokeAlertMethod(APP_NAME, strBody: "Please do login first", delegate: nil)
            return
        }
        if (Int(self.txtAmountTextField.text!) >= 1000)
        {
            self.callAPIWithInvestmentHorizon("< 3 months")
            return
        }
        
        let alertController = UIAlertController(title: nil, message: "Investment amount should be greater than ₹ 1000", preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: { (defaultAction1) in
            
        })
        
        alertController.addAction(defaultAction)
        self.presentViewController(alertController, animated: true, completion: nil)
        
        
    }
    
    @IBAction func btnBackClicked(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }

    
    
    //API Call
    func callAPIWithInvestmentHorizon(horizon : String) {
        
        let dic = NSMutableDictionary()
        dic["Investment_horizon"] = horizon
        
        WebManagerHK.postDataToURL(kModeGetTopFunds, params: dic, message: "Loading top funds...") { (response) in
            
            if response.objectForKey(kWAPIResponse) is NSDictionary
            {
                let mainResponse = response.objectForKey(kWAPIResponse) as! NSDictionary
                print("Dic Response For TopFunds: \(mainResponse)")
                let arrFnds = mainResponse.valueForKey("TopFunds") as! NSArray
                
                if (Int(self.txtAmountTextField.text!) >= 5000)
                {
                    let dic = arrFnds.objectAtIndex(0) as! NSDictionary
                    let jo = NSMutableDictionary()
                    jo.setValue(dic.valueForKey("Fund_Code"), forKey: "Fund_Code")
                    jo.setValue(dic.valueForKey("NAV"), forKey: "NAV")
                    jo.setValue(dic.valueForKey("NAVDate"), forKey: "NAVDate")
                    
                    jo.setValue(dic.valueForKey("Plan_Name"), forKey: "Plan_Name")
                    jo.setValue(dic.valueForKey("Plan_Opt"), forKey: "Div_Opt")
                    jo.setValue(dic.valueForKey("Scheme_Code"), forKey: "Scheme_Code")
                    jo.setValue(self.txtAmountTextField.text, forKey: "Scheme_Amount")
                    
                    print(jo)
                    sharedInstance.userDefaults.setObject(jo, forKey: kSelectBuyNowScheme)
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        let objBuyScreen = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdBuyScreeen) as! BuyScreeen
                        objBuyScreen.isBuyFrom = kBUY_FROM_SMARTFUND
                        objBuyScreen.isExisting = true
                        self.navigationController?.pushViewController(objBuyScreen, animated: true)
                        
                    })
                    
                }
                else
                {
                    let dic = arrFnds.objectAtIndex(2) as! NSDictionary
                    let jo = NSMutableDictionary()
                    jo.setValue(dic.valueForKey("Fund_Code"), forKey: "Fund_Code")
                    jo.setValue(dic.valueForKey("NAV"), forKey: "NAV")
                    jo.setValue(dic.valueForKey("NAVDate"), forKey: "NAVDate")
                    
                    jo.setValue(dic.valueForKey("Plan_Name"), forKey: "Plan_Name")
                    jo.setValue(dic.valueForKey("Plan_Opt"), forKey: "Div_Opt")
                    jo.setValue(dic.valueForKey("Scheme_Code"), forKey: "Scheme_Code")
                    jo.setValue(self.txtAmountTextField.text, forKey: "Scheme_Amount")
                    
                    print(jo)
                    sharedInstance.userDefaults.setObject(jo, forKey: kSelectBuyNowScheme)
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                        let objBuyScreen = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdBuyScreeen) as! BuyScreeen
                        objBuyScreen.isBuyFrom = kBUY_FROM_SMARTFUND
                        objBuyScreen.isExisting = true
                        self.navigationController?.pushViewController(objBuyScreen, animated: true)
                        
                    })
                    
                }
                
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //UItextfield Delegate
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let currentCharacterCount = textField.text?.characters.count ?? 0
        if (range.length + range.location > currentCharacterCount){
            return false
        }
        let newLength = currentCharacterCount + string.characters.count - range.length
        return newLength <= 10
    }
    
    
    func keyboardWillShow(notification: NSNotification)
    {
        let userInfo:NSDictionary = notification.userInfo!
        let keyboardFrame:NSValue = userInfo.valueForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.CGRectValue()
        let keyboardHeight = keyboardRectangle.height
        
        UIView.animateWithDuration(0.2) {
            
            self.btnNextBottomConsatrait!.constant = keyboardHeight
        }
        
        
//        if let userInfo = notification.userInfo {
//            if let keyboardHeight = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue.size.height {
//                btnNextBottomConsatrait.constant = keyboardHeight;
//            }
//        }
    }
    
    func keyboardWillHide(notification: NSNotification)
    {
        if (notification.userInfo != nil)
        {
            UIView.animateWithDuration(0.2) {
                
                self.btnNextBottomConsatrait!.constant = 0;
            }
            
        }
        //UIView.animateWithDuration(0.2, animations: { btnNextBottomConsatrait.constant = 0; })
        // For some reason adding inset in keyboardWillShow is animated by itself but removing is not, that's why we have to use animateWithDuration here
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
