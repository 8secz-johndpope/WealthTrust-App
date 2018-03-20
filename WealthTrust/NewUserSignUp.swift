//
//  NewUserSignUp.swift
//  WealthTrust
//
//  Created by Hemen Gohil on 9/1/16.
//  Copyright © 2016 Hemen Gohil. All rights reserved.
//

import UIKit

class NewUserSignUp: UIViewController,UITextFieldDelegate,LTHPasscodeViewControllerDelegate {
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var viewAlertSubmit: UIView!
    @IBOutlet weak var btnTermsAndCondi: UIButton!
    @IBOutlet weak var btnAlertSubmitCancel: UIButton!
    @IBOutlet weak var btnAlertSubmitSubmit: UIButton!
    @IBOutlet weak var btnAlertSubmitCheckBox: UIButton!

    var txtName : RPFloatingPlaceholderTextField!
    var txtMobileNumber : RPFloatingPlaceholderTextField!
    var txtEmail : RPFloatingPlaceholderTextField!
    var txtPassword : RPFloatingPlaceholderTextField!
    var txtConfirmPasswor : RPFloatingPlaceholderTextField!
    var txtPin : RPFloatingPlaceholderTextField!
    let objDefault=NSUserDefaults.standardUserDefaults()
    
    var isFrom = IS_FROM.Profile
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIKeyboardDidHideNotification, object: nil)
        
        tblView.sectionHeaderHeight = 110
        
        viewAlertSubmit.hidden = true
//        btnAlertSubmitCancel.layer.cornerRadius = 1.5
//        btnAlertSubmitCancel.layer.borderColor = UIColor.defaultOrangeButton.CGColor
//        btnAlertSubmitCancel.layer.borderWidth = 1.0
        btnAlertSubmitCheckBox.layer.cornerRadius = 1.5
        btnAlertSubmitCheckBox.layer.borderColor = UIColor.grayColor().CGColor
        btnAlertSubmitCheckBox.layer.borderWidth = 1.0
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.hidden = true
    }
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBar.hidden = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let keyboardHeight = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue.size.height {
                tblView.contentInset = UIEdgeInsetsMake(0, 0, keyboardHeight, 0)
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        UIView.animateWithDuration(0.2, animations: { self.tblView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0) })
        // For some reason adding inset in keyboardWillShow is animated by itself but removing is not, that's why we have to use animateWithDuration here
    }
    
    
    @IBAction func btnBackClicked(sender: AnyObject) {
        
        //        let allUser = DBManager.getInstance().getAllUser()
        //        if allUser.count==0
        //        {
        self.navigationController?.popViewControllerAnimated(true)
        
        //        }else{
        //
        //            let objUserProfile = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdUserProfile)
        //            self.navigationController?.viewControllers.insert(objUserProfile!, atIndex: 1)
        //            print(self.navigationController?.viewControllers)
        //
        //            for viewController in (self.navigationController?.viewControllers)! {
        //
        //                if viewController.isKindOfClass(UserProfile) {
        //                    self.navigationController?.popToViewController(viewController, animated: true)
        //                    return
        //                }
        //            }
        //        }
    }
    @IBAction func btnHelpClicked(sender: AnyObject) {
        let objWebView = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdWebViewController) as! WebViewController
        
        objWebView.urlLink = NSURL(string:URL_SIGNUP_HELP)!
        objWebView.screenTitle = "Help"
        self.navigationController?.pushViewController(objWebView, animated: true)
    }
    
    
    func applyTextFiledStyle1(textField : UITextField) {
        
        textField.delegate = self;
        textField.returnKeyType = UIReturnKeyType.Next
        textField.tintColor = UIColor.blueColor()
        textField .setValue(UIColor.darkGrayColor(), forKeyPath: "_placeholderLabel.textColor")
        textField.textColor = UIColor.darkGrayColor()
        textField.textAlignment = NSTextAlignment.Left
        textField.font = UIFont.systemFontOfSize(16)
        textField.autocorrectionType = .No
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "CELL_FIRST")
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CELL_FIRST", forIndexPath: indexPath) as UITableViewCell
        
        if (cell.contentView.subviews.count==0) {
            
            if indexPath.row==6 {
                
                let buttonSubmit = UIButton(frame: CGRect(x: cell.contentView.frame.size.width-80, y: 10, width: 70, height: 36))
                buttonSubmit.setTitle("SUBMIT", forState: .Normal)
                buttonSubmit.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                buttonSubmit.backgroundColor = UIColor.defaultOrangeButton
                buttonSubmit.titleLabel?.font = UIFont.systemFontOfSize(14)
                buttonSubmit.layer.cornerRadius = 1.5
                buttonSubmit.addTarget(self, action: #selector(NewUserSignUp.btnSubmitClicked(_:)), forControlEvents: .TouchUpInside)
                cell.contentView.addSubview(buttonSubmit)
                
                
                let buttonCancel = UIButton(frame: CGRect(x: cell.contentView.frame.size.width-(80*2), y: 10, width: 70, height: 36))
                buttonCancel.setTitle("CANCEL", forState: .Normal)
                buttonCancel.setTitleColor(UIColor.defaultOrangeButton, forState: .Normal)
                buttonCancel.backgroundColor = UIColor.whiteColor()
                buttonCancel.titleLabel?.font = UIFont.systemFontOfSize(14)
                buttonCancel.layer.cornerRadius = 1.5
                buttonCancel.layer.borderColor = UIColor.defaultOrangeButton.CGColor
                buttonCancel.layer.borderWidth = 1.0
                buttonCancel.addTarget(self, action: #selector(NewUserSignUp.btnBackClicked(_:)), forControlEvents: .TouchUpInside)
                cell.contentView.addSubview(buttonCancel)
                
                
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                cell.contentView.backgroundColor = UIColor.clearColor()
                cell.backgroundColor = UIColor.clearColor()
                
                return cell;
            }
            
            
            switch indexPath.row {
            case 0:
                txtName = RPFloatingPlaceholderTextField(frame: CGRect(x: 10, y: 10, width: (cell.contentView.frame.size.width)-20, height: 35));
                txtName.placeholder = "Name"
                self.applyTextFiledStyle1(txtName)
                cell.contentView.addSubview(txtName)
                
                break;
            case 1:
                txtMobileNumber = RPFloatingPlaceholderTextField(frame: CGRect(x: 10, y: 10, width: (cell.contentView.frame.size.width)-20, height: 35));
                txtMobileNumber.placeholder = "Mobile Number"
                txtMobileNumber.keyboardType = UIKeyboardType.NumberPad
                addToolBar(txtMobileNumber)
                self.applyTextFiledStyle1(txtMobileNumber)
                
                cell.contentView.addSubview(txtMobileNumber)
                
                break;
            case 2:
                txtEmail = RPFloatingPlaceholderTextField(frame: CGRect(x: 10, y: 10, width: (cell.contentView.frame.size.width)-20, height: 35));
                txtEmail.placeholder = "Email"
                self.applyTextFiledStyle1(txtEmail)
                txtEmail.keyboardType = UIKeyboardType.EmailAddress
                cell.contentView.addSubview(txtEmail)
                
                break;
            case 3:
                txtPassword = RPFloatingPlaceholderTextField(frame: CGRect(x: 10, y: 10, width: (cell.contentView.frame.size.width)-20, height: 35));
                txtPassword.placeholder = "Enter Password"
                txtPassword.secureTextEntry = true
                self.applyTextFiledStyle1(txtPassword)
                cell.contentView.addSubview(txtPassword)
                
                let lblValid = UILabel(frame: CGRect(x: (cell.contentView.frame.size.width)-195, y: 50, width: 195, height: 20))
                lblValid.text = "8-12 characters. AlphaNumberic"
                lblValid.textColor = UIColor.lightGrayColor()
                lblValid.font = UIFont.italicSystemFontOfSize(12)
                cell.contentView.addSubview(lblValid)
                
                break;
            case 4:
                txtConfirmPasswor = RPFloatingPlaceholderTextField(frame: CGRect(x: 10, y: 10, width: (cell.contentView.frame.size.width)-20, height: 35));
                txtConfirmPasswor.placeholder = "Confirm Password"
                txtConfirmPasswor.secureTextEntry = true
                self.applyTextFiledStyle1(txtConfirmPasswor)
                cell.contentView.addSubview(txtConfirmPasswor)
                
                break;
            case 5:
                txtPin = RPFloatingPlaceholderTextField(frame: CGRect(x: 10, y: 10, width: (cell.contentView.frame.size.width)-20, height: 35));
                txtPin.placeholder = "Set 4 digit pin for applock"
                txtPin.secureTextEntry = true
                self.applyTextFiledStyle1(txtPin)
                addToolBar(txtPin)

                txtPin.returnKeyType = UIReturnKeyType.Done
                cell.contentView.addSubview(txtPin)
//                txtPin.keyboardType = .NumbersAndPunctuation
                txtPin.keyboardType = UIKeyboardType.NumberPad
                break;
                
            default:
                break;
            }
            
            var lblLine : UILabel!
            lblLine = UILabel(frame: CGRect(x: 10, y: 55-13, width: (cell.contentView.frame.size.width)-20, height: 1));
            lblLine.backgroundColor = UIColor.lightGrayColor()
            lblLine.tag = indexPath.row
            cell.contentView.addSubview(lblLine)
            
        }else{
        }
        
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.contentView.backgroundColor = UIColor.clearColor()
        cell.backgroundColor = UIColor.clearColor()
        
        return cell;
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
//        if indexPath.row==2 {
//            return 75
//        }
        return 55
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView(frame: CGRect(x: 10, y: 0, width: tableView.frame.size.width-20, height: 110))
        view.backgroundColor = UIColor.whiteColor()
        
        let imageProfile = UIImageView(frame: CGRect(x: (view.frame.size.width/2)-45, y: 10, width: 90, height: 90))
        imageProfile.backgroundColor = UIColor.whiteColor()
        imageProfile.layer.cornerRadius = 42
        let image = UIImage(named: "iconProfile")?.imageWithRenderingMode(.AlwaysTemplate)
        imageProfile.tintColor = UIColor.defaultAppColorBlue
        imageProfile.image = image
        view.addSubview(imageProfile)
        imageProfile.center = view.center
        
        let label = UILabel(frame: CGRect(x: 10, y: view.frame.size.height-1, width: view.frame.size.width, height: 1))
        label.backgroundColor = UIColor.lightGrayColor()
        view.addSubview(label)
        label.alpha = 0.4
        
        return view
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
        if textField == txtPin {
            let currentString: NSString = textField.text!
            let newString: NSString = currentString.stringByReplacingCharactersInRange(range, withString: string)
            return newString.length <= 4
        }
        return true;
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        print("TextField should return method called")
        
        if textField==txtName {
            txtMobileNumber.becomeFirstResponder()
            return true;
        }
        if textField==txtEmail {
            txtPassword.becomeFirstResponder()
            return true;
        }
        if textField==txtPassword {
            txtConfirmPasswor.becomeFirstResponder()
            return true;
        }
        if textField==txtConfirmPasswor {
            txtPin.becomeFirstResponder() // crash at new password return key
        //    textField.resignFirstResponder()
            return true;
        }
        
        if textField.text=="" {
            tblView.reloadData()
            textField.resignFirstResponder();
            return true;
        }
        
        textField.resignFirstResponder();
        return true;
    }
    
    @IBAction func btnSubmitClicked(sender: AnyObject) {
        
        if (txtName.text!.isEmpty) {
            SharedManager.invokeAlertMethod(APP_NAME, strBody: kAlertEmptyName, delegate: nil)
            txtName.becomeFirstResponder()
            return;
        }
        
        if (txtMobileNumber.text!.isEmpty) {
            SharedManager.invokeAlertMethod(APP_NAME, strBody: kAlertEmptyMobileNumber, delegate: nil)
            txtMobileNumber.becomeFirstResponder()
            return;
        }
        if (txtMobileNumber.text?.characters.count != 10) {
            SharedManager.invokeAlertMethod(APP_NAME, strBody: kAlertMobileNumber10Number, delegate: nil)
            txtMobileNumber.becomeFirstResponder()
            return;
        }
        
        if (txtEmail.text!.isEmpty) {
            SharedManager.invokeAlertMethod(APP_NAME, strBody: kAlertEmptyEmailId, delegate: nil)
            txtEmail.becomeFirstResponder()
            return;
        }
        if (txtEmail.text!.isValidEmail()) {
        }else{
            SharedManager.invokeAlertMethod(APP_NAME, strBody: kAlertEmailIdIsValidEmail, delegate: nil)
            txtEmail.becomeFirstResponder()
            return;
        }
        
        if (txtPassword.text!.isEmpty) {
            SharedManager.invokeAlertMethod(APP_NAME, strBody: kAlertEmptyPassword, delegate: nil)
            txtPassword.becomeFirstResponder()
            return;
        }
        
        if txtPassword.text?.characters.count>7 && txtPassword.text?.characters.count<=12 {
        }else{
            SharedManager.invokeAlertMethod(APP_NAME, strBody: kAlertPassword8to12, delegate: nil)
            txtPassword.becomeFirstResponder()
            return
        }
        
        if (txtPassword.text!.isAlphanumeric()) {
        }else{
            SharedManager.invokeAlertMethod(APP_NAME, strBody: kAlertPasswordAlphanumeric, delegate: nil)
            txtPassword.becomeFirstResponder()
            return;
        }
        
        if (txtConfirmPasswor.text!.isEmpty) {
            SharedManager.invokeAlertMethod(APP_NAME, strBody: kAlertEmptyConfirmPassword, delegate: nil)
            txtConfirmPasswor.becomeFirstResponder()
            return;
        }
        
        if (txtConfirmPasswor.text != txtPassword.text) {
            SharedManager.invokeAlertMethod(APP_NAME, strBody: kAlertSamePasswordConfirmPassword, delegate: nil)
            txtConfirmPasswor.becomeFirstResponder()
            return;
        }
        
         if (txtPin.text!.isEmpty) {
            SharedManager.invokeAlertMethod(APP_NAME, strBody: kAlertEmpty4DigitPin, delegate: nil)
            txtPin.becomeFirstResponder()
         return;
         }
         if (txtPin.text?.characters.count==4) {
         }else{
            SharedManager.invokeAlertMethod(APP_NAME, strBody: kAlertPin4DigitPin, delegate: nil)
            txtPin.becomeFirstResponder()
         return;
         }
        viewAlertSubmit.hidden = false
        btnAlertSubmitCheckBox.selected = false
        btnAlertSubmitSubmit.enabled = false

        /*
        // Call API NOW...
        // API Call
        objDefault.setValue(txtPin.text, forKey: "passcode")
        LTHPasscodeViewController.savePasscodeDigit()
        
        let dicToSend:NSDictionary = [
            kEmailId : txtEmail.text!,
            kPassWord : txtPassword.text!,
            kMobileNo : txtMobileNumber.text!,
            kName : txtName.text!]
        
        WebManagerHK.postDataToURL(kModeSignUp, params: dicToSend, message: "Registering your details..") { (response) in
            print("Dic Response : \(response)")
            
            if response.objectForKey(kWAPIResponse) is String
            {
                let mainResponse = response.objectForKey(kWAPIResponse) as! String
                print("Response : \(mainResponse)")
                
                if mainResponse == "-1" // Emailid Already Exist....
                {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        SharedManager.invokeAlertMethod(APP_NAME, strBody: kAlertEmailIdAlreadyExist, delegate: nil)
                    })
                    return
                }
            }
            if response.objectForKey(kWAPIResponse) is NSInteger
            {
                let mainResponse = response.objectForKey(kWAPIResponse) as! NSInteger
                
                if mainResponse == -1 // Emailid Already Exist....
                {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        SharedManager.invokeAlertMethod(APP_NAME, strBody: kAlertEmailIdAlreadyExist, delegate: nil)
                    })
                    return
                }
                else
                {
                    
                }
                let isDeletedAll = DBManager.getInstance().deleteAllUser()
                print("Cliend Id : \(mainResponse)")
                sharedInstance.objLoginUser.ClientID = String(mainResponse)
                sharedInstance.objLoginUser.Name = self.txtName.text
                sharedInstance.objLoginUser.email = self.txtEmail.text
                sharedInstance.objLoginUser.mob = self.txtMobileNumber.text
                sharedInstance.objLoginUser.password = self.txtPassword.text
                sharedInstance.objLoginUser.CAN = ""
                sharedInstance.objLoginUser.SignupStatus = "\(SIGNUP_STATUS.PANVERIFICATIONPENDING4.hashValue)"
                sharedInstance.objLoginUser.InvestmentAofStatus = "\(INVESTMENTAACCOUNT_STATUS.PENDING0.hashValue)"
                
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
                
                let isInserted = DBManager.getInstance().addUser(userInfo)
                if isInserted {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.clearAllFields()
                        if self.isFrom == .AddManuallyPortfolio
                        {
                            let alertController = UIAlertController(title: "Signup Successful", message: "Thanks for signing up. You can add existing portfolio now.", preferredStyle: .Alert)
                            
                            let defaultAction = UIAlertAction(title: "ADD PORTFOLIO", style: .Default, handler: { (defaultAction1) in
                                
                                self.navigateToNextScreen()

                            })
                            alertController.addAction(defaultAction)
                            self.presentViewController(alertController, animated: true, completion: nil)
                        }
                        else if self.isFrom == .AutoGenerate
                        {
                            let alertController = UIAlertController(title: "Signup Successful", message: "Thanks for signing up. You can add existing portfolio now.", preferredStyle: .Alert)
                            
                            let defaultAction = UIAlertAction(title: "AUTO GENERATE", style: .Default, handler: { (defaultAction1) in
                                
                                self.navigateToNextScreen()
                            })
                            alertController.addAction(defaultAction)
                            self.presentViewController(alertController, animated: true, completion: nil)
                        }
                        else if self.isFrom == .SwitchToDirect || self.isFrom == .BuySIP
                        {
                            self.navigateToNextScreen()
                        }
                        else if self.isFrom == .BuySIPFromTopFunds
                        {
                            let objDocScreen = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdDocScreen) as! DocScreen
                            objDocScreen.isFrom = self.isFrom
                            self.navigationController?.pushViewController(objDocScreen, animated: true)
                        }
                        else if self.isFrom == .BuySIPFromSearch
                        {
                            let objDocScreen = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdDocScreen) as! DocScreen
                            objDocScreen.isFrom = self.isFrom
                            self.navigationController?.pushViewController(objDocScreen, animated: true)
                        }
                        else{
                            let objDocScreen = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdDocScreen) as! DocScreen
                            self.navigationController?.pushViewController(objDocScreen, animated: true)
                        }
                    })
                } else {
                    
                    SharedManager.invokeAlertMethod("", strBody: "Error in saving record.", delegate: nil)
                }
            }
        }*/
    }
    
    func navigateToNextScreen() {
        RootManager.sharedInstance.isFrom = self.isFrom
        RootManager.sharedInstance.navigateToScreen(self, data: [:])
    }
    
    
    func clearAllFields() {
        txtName.text = ""
        txtMobileNumber.text = ""
        txtEmail.text = ""
        txtPassword.text = ""
        txtConfirmPasswor.text = ""
        txtPin.text = ""
    }
    func addToolBar(textField: UITextField){
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
       // toolBar.tintColor = UIColor.blueColor()
        let doneButton = UIBarButtonItem(title: "Next", style: UIBarButtonItemStyle.Done, target: self, action: #selector(NewUserSignUp.donePressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        toolBar.sizeToFit()
        
        textField.delegate = self
        textField.inputAccessoryView = toolBar
    }
    func donePressed(){
        if txtMobileNumber.editing == true {
            txtEmail.becomeFirstResponder()
        }
        else if txtPin.editing == true{
            self.btnSubmitClicked(UIButton)
        }
    }
    
    //Alert Buttons Cliecked
    @IBAction func btnAlertSubmitCheckClicked(sender: UIButton) {
        if sender.selected {
            sender.selected = false
            btnAlertSubmitSubmit.enabled = false
        }
        else{
            sender.selected = true
            btnAlertSubmitSubmit.enabled = true
        }
    }
    @IBAction func btnAlertTermsAndCondiClicked(sender: UIButton) {
        sharedInstance.userDefaults.setObject(URL_SIGNUP_TERMS, forKey: kURL_TO_LOAD)
        sharedInstance.userDefaults.setObject("Terms & Conditions", forKey: kTITLE_TO_DISPLAY)
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let swiftViewController = self.storyboard!.instantiateViewControllerWithIdentifier("SwiftViewController") as! SwiftViewController
        swiftViewController.isBackArrow = true
        self.navigationController?.pushViewController(swiftViewController, animated: true)
    }
    
    @IBAction func btnAlertSubmitSubmitClicked(sender: UIButton) {
        if btnAlertSubmitCheckBox.selected == true {
            viewAlertSubmit.hidden = true

            // Call API NOW...
            // API Call
            objDefault.setValue(txtPin.text, forKey: "passcode")
            LTHPasscodeViewController.savePasscodeDigit()
            
            let dicToSend:NSDictionary = [
                kEmailId : txtEmail.text!,
                kPassWord : txtPassword.text!,
                kMobileNo : txtMobileNumber.text!,
                kName : txtName.text!]
            
            WebManagerHK.postDataToURL(kModeSignUp, params: dicToSend, message: "Registering your details..") { (response) in
                print("Dic Response : \(response)")
                
                if response.objectForKey(kWAPIResponse) is String
                {
                    let mainResponse = response.objectForKey(kWAPIResponse) as! String
                    print("Response : \(mainResponse)")
                    
                    if mainResponse == "-1" // Emailid Already Exist....
                    {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            SharedManager.invokeAlertMethod(APP_NAME, strBody: kAlertEmailIdAlreadyExist, delegate: nil)
                        })
                        return
                    }
                }
                if response.objectForKey(kWAPIResponse) is NSInteger
                {
                    let mainResponse = response.objectForKey(kWAPIResponse) as! NSInteger
                    
                    if mainResponse == -1 // Emailid Already Exist....
                    {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            SharedManager.invokeAlertMethod(APP_NAME, strBody: kAlertEmailIdAlreadyExist, delegate: nil)
                        })
                        return
                    }
                    else
                    {
                        
                    }
                    let isDeletedAll = DBManager.getInstance().deleteAllUser()
                    print("Cliend Id : \(mainResponse)")
                    sharedInstance.objLoginUser.ClientID = String(mainResponse)
                    sharedInstance.objLoginUser.Name = self.txtName.text
                    sharedInstance.objLoginUser.email = self.txtEmail.text
                    sharedInstance.objLoginUser.mob = self.txtMobileNumber.text
                    sharedInstance.objLoginUser.password = self.txtPassword.text
                    sharedInstance.objLoginUser.CAN = ""
                    sharedInstance.objLoginUser.SignupStatus = "\(SIGNUP_STATUS.PANVERIFICATIONPENDING4.hashValue)"
                    sharedInstance.objLoginUser.InvestmentAofStatus = "\(INVESTMENTAACCOUNT_STATUS.PENDING0.hashValue)"
                    
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
                    
                    let isInserted = DBManager.getInstance().addUser(userInfo)
                    if isInserted {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.clearAllFields()
                            if self.isFrom == .AddManuallyPortfolio
                            {
                                let alertController = UIAlertController(title: "Signup Successful", message: "Thanks for signing up. You can add existing portfolio now.", preferredStyle: .Alert)
                                
                                let defaultAction = UIAlertAction(title: "ADD PORTFOLIO", style: .Default, handler: { (defaultAction1) in
                                    
                                    self.navigateToNextScreen()
                                    
                                })
                                alertController.addAction(defaultAction)
                                self.presentViewController(alertController, animated: true, completion: nil)
                            }
                            else if self.isFrom == .AutoGenerate
                            {
                                let alertController = UIAlertController(title: "Signup Successful", message: "Thanks for signing up. You can add existing portfolio now.", preferredStyle: .Alert)
                                
                                let defaultAction = UIAlertAction(title: "AUTO GENERATE", style: .Default, handler: { (defaultAction1) in
                                    
                                    self.navigateToNextScreen()
                                })
                                alertController.addAction(defaultAction)
                                self.presentViewController(alertController, animated: true, completion: nil)
                            }
                            else if self.isFrom == .SwitchToDirect || self.isFrom == .BuySIP
                            {
                                self.navigateToNextScreen()
                            }
                            else if self.isFrom == .BuySIPFromTopFunds
                            {
                                let objDocScreen = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdDocScreen) as! DocScreen
                                objDocScreen.isFrom = self.isFrom
                                self.navigationController?.pushViewController(objDocScreen, animated: true)
                            }
                            else if self.isFrom == .BuySIPFromSearch
                            {
                                let objDocScreen = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdDocScreen) as! DocScreen
                                objDocScreen.isFrom = self.isFrom
                                self.navigationController?.pushViewController(objDocScreen, animated: true)
                            }
                            else{
                                let objDocScreen = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdDocScreen) as! DocScreen
                                self.navigationController?.pushViewController(objDocScreen, animated: true)
                            }
                        })
                    } else {
                        
                        SharedManager.invokeAlertMethod("", strBody: "Error in saving record.", delegate: nil)
                    }
                }
            }
        }
    }
    @IBAction func btnAlertSubmitCancelClicked(sender: UIButton) {
        viewAlertSubmit.hidden = true
    }
    
}



