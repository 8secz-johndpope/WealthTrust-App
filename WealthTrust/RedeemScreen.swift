//
//  RedeemScreen.swift
//  WealthTrust
//
//  Created by Hemen Gohil on 9/22/16.
//  Copyright © 2016 Hemen Gohil. All rights reserved.
//

import UIKit

class RedeemScreen: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate
{
    
    @IBOutlet weak var tblView: UITableView!
    
    var lblSwitchFromFund : UILabel!
    var txtSchemeName : UITextField!

    var lblUploadPan = UILabel()
    
    var txtFolioNumber : UITextField!
    var txtNAV : UITextField!
    var txtSwitchBy : UITextField!
    var currentSelectedSwitchBy = "All Units"
    var txtSwitchByValue : UITextField!
    var lblSwitchByValue : UILabel!
    var lblTotal : UILabel!
    var lblUnderLine : UILabel!

    var txtCurrentSelected : UITextField!
    var currentSelectSchemeIndex = 0
    var isNavAvailable = false
    
    var pickerView = UIPickerView()
    
    var arrSchemes = NSMutableArray()
    
    var totalUnits = 0.0 as Float
    var totalAmount = 0.0 as Float
    var minUnits = 0.0 as Float
    var minAmount = 0.0 as Float
    
    
    var isFrom = "Fresh"
    var pickerSelectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        pickerView.delegate = self
        
        // Do any additional setup after loading the view, typically from a nib.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIKeyboardDidHideNotification, object: nil)
        
        tblView.sectionHeaderHeight = 160
        
        self.view.backgroundColor = UIColor.defaultAppBackground
        self.tblView.backgroundColor = UIColor.defaultAppBackground
        
        isNavAvailable = false
        
        print("All Schemes \(arrSchemes)")
        
//        if isFrom == "Existing" {
//            txtCurrentSelected = self.txtSchemeName
//            pickerView.selectRow(pickerSelectedIndex, inComponent: 0, animated: true)
//        }
        
    }
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        tblView.reloadData()
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            if self.isFrom == "Existing" {
                self.txtCurrentSelected = self.txtSchemeName
                self.pickerView.selectRow(self.pickerSelectedIndex, inComponent: 0, animated: true)
                self.pickerView(self.pickerView, didSelectRow: self.pickerSelectedIndex, inComponent: 0)
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnBackClick(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
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
        return 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        var planName = "CELL_FIRST_\(indexPath.row)"
        
        let identifier = planName
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: identifier)
        
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as UITableViewCell
        
        if (cell.contentView.subviews.count==0) {
            
            if indexPath.row==3 {
                
                let buttonSubmit = UIButton(frame: CGRect(x: cell.contentView.frame.size.width-80, y: 10, width: 70, height: 36))
                buttonSubmit.setTitle("SUBMIT", forState: .Normal)
                buttonSubmit.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                buttonSubmit.backgroundColor = UIColor.defaultOrangeButton
                buttonSubmit.titleLabel?.font = UIFont.systemFontOfSize(14)
                buttonSubmit.layer.cornerRadius = 1.5
                buttonSubmit.addTarget(self, action: #selector(SwitchScreen.btnNexClicked(_:)), forControlEvents: .TouchUpInside)
                cell.contentView.addSubview(buttonSubmit)
                
                let buttonCancel = UIButton(frame: CGRect(x: cell.contentView.frame.size.width-(80*2), y: 10, width: 70, height: 36))
                buttonCancel.setTitle("CANCEL", forState: .Normal)
                buttonCancel.setTitleColor(UIColor.defaultOrangeButton, forState: .Normal)
                buttonCancel.backgroundColor = UIColor.whiteColor()
                buttonCancel.titleLabel?.font = UIFont.systemFontOfSize(14)
                buttonCancel.layer.cornerRadius = 1.5
                buttonCancel.layer.borderColor = UIColor.defaultOrangeButton.CGColor
                buttonCancel.layer.borderWidth = 1.0
                buttonCancel.addTarget(self, action: #selector(SwitchScreen.btnCancelClicked(_:)), forControlEvents: .TouchUpInside)
                cell.contentView.addSubview(buttonCancel)
                
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                cell.contentView.backgroundColor = UIColor.clearColor()
                cell.backgroundColor = UIColor.clearColor()
                
                return cell;
            }
            
            
            switch indexPath.row {
            case 0:
                
                //var lblUploadPan : UILabel!
                lblUploadPan = UILabel(frame: CGRect(x: 10, y: 5, width: (cell.contentView.frame.size.width)-20, height: 25));
                lblUploadPan.text = ""
                lblUploadPan.textColor = UIColor.darkGrayColor()
                lblUploadPan.font = UIFont.systemFontOfSize(12)
                cell.contentView.addSubview(lblUploadPan)
                
                lblSwitchFromFund = UILabel(frame: CGRect(x: 10, y: 30, width: (cell.contentView.frame.size.width)-40, height: 50));
                lblSwitchFromFund.text = "Select Scheme Name"
                
                lblSwitchFromFund.textColor = UIColor.blackColor()
                lblSwitchFromFund.font = UIFont.systemFontOfSize(15)
                lblSwitchFromFund.numberOfLines = 2
                lblSwitchFromFund.backgroundColor = UIColor.clearColor()
                cell.contentView.addSubview(lblSwitchFromFund)
                
                txtSchemeName = UITextField(frame: CGRect(x: 10, y: 30, width: (cell.contentView.frame.size.width)-40, height: 50));
                self.applyTextFiledStyle1(txtSchemeName)
                txtSchemeName.autocapitalizationType = .AllCharacters
                txtSchemeName.tintColor = UIColor.whiteColor()
                txtSchemeName.text = ""
                txtSchemeName.tag = 101
                txtSchemeName.inputView = pickerView
                txtSchemeName.backgroundColor = UIColor.clearColor()
                cell.contentView.addSubview(txtSchemeName)
                
                var lblLine : UILabel!
                lblLine = UILabel(frame: CGRect(x: 10, y: 80, width: (cell.contentView.frame.size.width)-20, height: 1));
                lblLine.backgroundColor = UIColor.lightGrayColor()
                lblLine.alpha = 0.4
                cell.contentView.addSubview(lblLine)
                
                
                break;
            case 1:
                
                var lblUploadPan : UILabel!
                lblUploadPan = UILabel(frame: CGRect(x: 10, y: 5, width: (cell.contentView.frame.size.width)-20, height: 25));
                lblUploadPan.text = "Folio Number"
                lblUploadPan.textColor = UIColor.darkGrayColor()
                lblUploadPan.font = UIFont.systemFontOfSize(12)
                cell.contentView.addSubview(lblUploadPan)
                
                txtNAV = UITextField(frame: CGRect(x: 10, y: 95, width: (cell.contentView.frame.size.width)-20, height: 35))
                //                txtNAV.text = "127.44 As 22-Sep-16"
//                txtFolioNumber = UITextField(frame: CGRect(x: 10, y: 95, width: (cell.contentView.frame.size.width)-20, height: 35));

                txtNAV.keyboardType = UIKeyboardType.NumberPad
                self.applyTextFiledStyle1(txtNAV)
                txtNAV.autocapitalizationType = .AllCharacters
                txtNAV.userInteractionEnabled = false
                txtNAV.text = "-"
                txtNAV.enabled = false
                cell.contentView.addSubview(txtNAV)

                var lblLine : UILabel!
                lblLine = UILabel(frame: CGRect(x: 10, y: 65, width: (cell.contentView.frame.size.width)-20, height: 1));
                lblLine.backgroundColor = UIColor.lightGrayColor()
                lblLine.alpha = 0.4
                cell.contentView.addSubview(lblLine)
                
                var lblNav : UILabel!
                lblNav = UILabel(frame: CGRect(x: 10, y: 70, width: (cell.contentView.frame.size.width)-20, height: 25));
                lblNav.text = "NAV"
                lblNav.textColor = UIColor.darkGrayColor()
                lblNav.font = UIFont.systemFontOfSize(12)
                cell.contentView.addSubview(lblNav)
                
                if txtFolioNumber==nil {
                    txtFolioNumber = UITextField(frame: CGRect(x: 10, y: 30, width: (cell.contentView.frame.size.width)-20, height: 35))
//                    txtNAV = UITextField(frame: CGRect(x: 10, y: 30, width: (cell.contentView.frame.size.width)-20, height: 35));

                    txtFolioNumber.placeholder = "-"
                    txtFolioNumber.keyboardType = UIKeyboardType.NumberPad
                    self.applyTextFiledStyle1(txtFolioNumber)
                    txtFolioNumber.autocapitalizationType = .AllCharacters
                }
                txtFolioNumber.enabled = false
                cell.contentView.addSubview(txtFolioNumber)


                var lblLine1 : UILabel!
                lblLine1 = UILabel(frame: CGRect(x: 10, y: 135, width: (cell.contentView.frame.size.width)-20, height: 1));
                lblLine1.backgroundColor = UIColor.lightGrayColor()
                lblLine1.alpha = 0.4
                cell.contentView.addSubview(lblLine1)
                
                break;
            case 2:
                
                var lblUploadPan : UILabel!
                lblUploadPan = UILabel(frame: CGRect(x: 10, y: 5, width: (cell.contentView.frame.size.width)-20, height: 25));
                lblUploadPan.text = "Redeem Type"
                lblUploadPan.textColor = UIColor.darkGrayColor()
                lblUploadPan.font = UIFont.systemFontOfSize(12)
                cell.contentView.addSubview(lblUploadPan)
                
                txtSwitchBy = UITextField(frame: CGRect(x: 10, y: 30, width: 120, height: 35));
                txtSwitchBy.text = currentSelectedSwitchBy
                txtSwitchBy.keyboardType = UIKeyboardType.Default
                self.applyTextFiledStyle1(txtSwitchBy)
                cell.contentView.addSubview(txtSwitchBy)
                txtSwitchBy.inputView = pickerView
                txtSwitchBy.tag = 102

                txtSwitchByValue = UITextField(frame: CGRect(x: (cell.contentView.frame.size.width)-160, y: 30, width: 150, height: 35));
                txtSwitchByValue.text = ""
                txtSwitchByValue.placeholder = "Enter Units"
                txtSwitchByValue.keyboardType = UIKeyboardType.NumberPad
                self.applyTextFiledStyle1(txtSwitchByValue)
                cell.contentView.addSubview(txtSwitchByValue)
                txtSwitchByValue.textAlignment = NSTextAlignment.Right
                
                lblUnderLine = UILabel(frame: CGRect(x: (cell.contentView.frame.size.width)-160, y: 60, width: 150, height: 1));
                lblUnderLine.backgroundColor = UIColor.lightGrayColor()
                lblUnderLine.alpha = 0.4
                cell.contentView.addSubview(lblUnderLine)
                
                lblSwitchByValue = UILabel(frame: CGRect(x: (cell.contentView.frame.size.width)-160, y: 60, width: 150, height: 20));
                lblSwitchByValue.text = "Minimum units : 0.0001"
                lblSwitchByValue.textColor = UIColor.darkGrayColor()
                lblSwitchByValue.font = UIFont.italicSystemFontOfSize(11)
                lblSwitchByValue.backgroundColor = UIColor.clearColor()
                lblSwitchByValue.textAlignment = .Right
                cell.contentView.addSubview(lblSwitchByValue)
                
                if currentSelectedSwitchBy=="All Units"
                {
                    txtSwitchByValue.hidden = true
                    lblSwitchByValue.hidden = true
                    lblUnderLine.hidden = true
                }else{
                    if currentSelectedSwitchBy=="Amount"
                    {
                        lblSwitchByValue.text = "Minimum amount : ₹\(minAmount)"
                    }
                    if currentSelectedSwitchBy=="Units"
                    {
                        lblSwitchByValue.text = "Minimum units : \(minUnits)"
                    }
                    txtSwitchByValue.hidden = false
                    lblSwitchByValue.hidden = false
                    lblUnderLine.hidden = false
                }
                
                var imgDownArrow : UIImageView!
                imgDownArrow = UIImageView(frame: CGRect(x: 100, y: 30, width: 30, height: 30));
                imgDownArrow.image = UIImage(named: "iconDown")
                imgDownArrow.backgroundColor = UIColor.clearColor()
                cell.contentView.addSubview(imgDownArrow)
                
                
                lblTotal = UILabel(frame: CGRect(x: 10, y: 60, width: 150, height: 20));
                lblTotal.text = "Total units : 0"
                lblTotal.textColor = UIColor.darkGrayColor()
                lblTotal.font = UIFont.italicSystemFontOfSize(11)
                lblTotal.backgroundColor = UIColor.clearColor()
                lblTotal.textAlignment = .Left
                cell.contentView.addSubview(lblTotal)
                
                if currentSelectedSwitchBy=="All Units"
                {
                    lblTotal.hidden = true
                }else{
                    if currentSelectedSwitchBy=="Amount"
                    {
                        lblTotal.text = "Total amount : ₹\(totalAmount)"
                    }
                    if currentSelectedSwitchBy=="Units"
                    {
                        lblTotal.text = "Total units : \(totalUnits)"
                    }
                    lblTotal.hidden = false
                }
                
                var lblLine : UILabel!
                lblLine = UILabel(frame: CGRect(x: 10, y: 104, width: (cell.contentView.frame.size.width)-20, height: 1));
                lblLine.backgroundColor = UIColor.lightGrayColor()
                lblLine.alpha = 0.4
                cell.contentView.addSubview(lblLine)

                
                let txtPan = UILabel(frame: CGRect(x: 10, y: 110, width: (cell.contentView.frame.size.width)-40, height: 35));
                txtPan.text = "MF investments are subject to market risk. Please read SID carefully before investing."
                txtPan.textColor = UIColor.darkGrayColor()
                txtPan.font = UIFont.italicSystemFontOfSize(11)
                txtPan.backgroundColor = UIColor.clearColor()
                txtPan.numberOfLines = 2
                cell.contentView.addSubview(txtPan)
                
                break;
                
            default:
                break;
            }
            
        }else{
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.contentView.backgroundColor = UIColor.clearColor()
        cell.backgroundColor = UIColor.clearColor()
        
        return cell;
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row==0 {
            return 80
        }
        if indexPath.row==1 {
            return 135
        }
        if indexPath.row==2 {
            return 145
        }
        return 55
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView(frame: CGRect(x: 10, y: 0, width: tableView.frame.size.width-20, height: 160))
        view.backgroundColor = UIColor.defaultAppBackground
        
        let imageProfile = UIImageView(frame: CGRect(x: (view.frame.size.width/2)-45, y: 10, width: 80, height: 80))
        imageProfile.layer.cornerRadius = imageProfile.frame.height/2
        let image = UIImage(named: "transactRedeem")
        imageProfile.image = image
        view.addSubview(imageProfile)
        
        var lblSwitchNow : UILabel!
        lblSwitchNow = UILabel(frame: CGRect(x: 10, y: 100, width: (view.frame.size.width)-20, height: 30));
        lblSwitchNow.text = "Redeeem Now"
        lblSwitchNow.textColor = UIColor.blackColor()
        lblSwitchNow.font = UIFont.systemFontOfSize(19)
        lblSwitchNow.textAlignment = .Center
        view.addSubview(lblSwitchNow)
        
        var lblSwitchToDirect1 : UILabel!
        lblSwitchToDirect1 = UILabel(frame: CGRect(x: 10, y: 130, width: (view.frame.size.width)-20, height: 15));
        lblSwitchToDirect1.text = "Think Long term. Stay invested"
        lblSwitchToDirect1.textColor = UIColor.darkGrayColor()
        lblSwitchToDirect1.font = UIFont.italicSystemFontOfSize(13)
        lblSwitchToDirect1.textAlignment = .Center
        view.addSubview(lblSwitchToDirect1)
        
        let label = UILabel(frame: CGRect(x: 10, y: view.frame.size.height-1, width: view.frame.size.width, height: 1))
        label.backgroundColor = UIColor.lightGrayColor()
        view.addSubview(label)
        label.alpha = 0.4
        
        return view
    }
    
    // UITextField Delegates
    func textFieldDidBeginEditing(textField: UITextField) {
        print("TextField did begin editing method called")
        
        txtCurrentSelected = textField
        txtCurrentSelected = textField
        if (txtCurrentSelected.text == "All Units")
        {
            pickerView.selectRow(0, inComponent: 0, animated: true)
        }
        else if (txtCurrentSelected.text == "Units")
        {
            pickerView.selectRow(1, inComponent: 0, animated: true)
        }
        else if (txtCurrentSelected.text == "Amount")
        {
            pickerView.selectRow(2, inComponent: 0, animated: true)
        }
        //pickerView.selectRow(pickerSelectedIndex, inComponent: 0, animated: true)
        
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
        
        return true;
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        print("TextField should return method called")
        
        if textField.text=="" {
            tblView.reloadData()
            textField.resignFirstResponder();
            return true;
        }
        textField.resignFirstResponder();
        return true;
    }
    
    @IBAction func btnSelectFromFundClicked(sender: AnyObject) {
        print("From Fund Clicked")

        
    }
    
    @IBAction func btnNexClicked(sender: AnyObject) {
        
        var objOrder : Order = Order()
        
        let objMFAccount = arrSchemes.objectAtIndex(currentSelectSchemeIndex) as! MFAccount
        
        objOrder.SrcSchemeName = objMFAccount.SchemeName
        objOrder.SrcSchemeCode = objMFAccount.SchemeCode
        objOrder.RtaAmcCode = objMFAccount.RTAamcCode

        if lblSwitchFromFund.text=="Select Scheme Name" {
            SharedManager.invokeAlertMethod(APP_NAME, strBody: "Please select Scheme!", delegate: nil)
            return;
        }
        
        objOrder.FolioNo = txtFolioNumber.text
        if currentSelectedSwitchBy == "All Units" {
            objOrder.VolumeType = "E"
        }
        if currentSelectedSwitchBy == "Units" {
            objOrder.VolumeType = "U"
            
            if txtSwitchByValue.text?.length==0 {
                SharedManager.invokeAlertMethod(APP_NAME, strBody: "Please enter Units!", delegate: nil)
                return
            }
            
            if (txtSwitchByValue.text! as NSString).floatValue<self.minUnits {
                SharedManager.invokeAlertMethod(APP_NAME, strBody: "Please enter minimum units \(self.minUnits).", delegate: nil)
                return;
            }

        }
        if currentSelectedSwitchBy == "Amount" {
            objOrder.VolumeType = "A"
            
            if txtSwitchByValue.text?.length==0 {
                SharedManager.invokeAlertMethod(APP_NAME, strBody: "Please enter Amount!", delegate: nil)
                return
            }
            
            if (txtSwitchByValue.text! as NSString).floatValue<self.minAmount {
                SharedManager.invokeAlertMethod(APP_NAME, strBody: "Please enter minimum amount \(self.minAmount).", delegate: nil)
                return;
            }

        }
        

        
        objOrder.Volume = txtSwitchByValue.text
        
        let objOrderSummary = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdOrderSummaryRedeem) as! OrderSummaryRedeem
        objOrderSummary.objOrder = objOrder
        self.navigationController?.pushViewController(objOrderSummary, animated: true)
        
    }
    
    @IBAction func btnInfoClicked(sender: AnyObject)
    {
        let objWebView = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdWebViewController) as! WebViewController
        objWebView.urlLink = NSURL(string:URL_SELL_HELP)!
        objWebView.screenTitle = kTitleSELL_Help
        self.navigationController?.pushViewController(objWebView, animated: true)
    }
    
    @IBAction func btnCancelClicked(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if txtCurrentSelected.tag==101 {
            return arrSchemes.count
        }
        if txtCurrentSelected.tag==102 {
            return 3
        }
        return 0
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if txtCurrentSelected.tag==101 {
            let objMFAccount = arrSchemes.objectAtIndex(row) as! MFAccount
            return objMFAccount.SchemeName as String
        }
        if txtCurrentSelected.tag==102 {
            if row==0 {
                return "All Units"
            }
            if row==1 {
                return "Units"
            }
            if row==2 {
                return "Amount"
            }
        }
        return "DefaulyValue"
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        txtCurrentSelected.resignFirstResponder()
        pickerSelectedIndex = row
        
        if txtCurrentSelected.tag==101 {
            currentSelectSchemeIndex = row

            lblUploadPan.text = "Scheme Name"
            let objMFAccount = arrSchemes.objectAtIndex(currentSelectSchemeIndex) as! MFAccount
            lblSwitchFromFund.text = objMFAccount.SchemeName as String
            
//            txtNAV.text = objMFAccount.CurrentNAV
            txtFolioNumber.text = objMFAccount.FolioNo
            
            var nvValue = "" as String
            nvValue = "\(objMFAccount.CurrentNAV) As On \(sharedInstance.getFormatedDate(objMFAccount.NAVDate))"
            txtNAV.text = nvValue

            print(objMFAccount.pucharseUnits)
            print(objMFAccount.CurrentNAV)
            
            let allUnits = (objMFAccount.pucharseUnits as NSString).floatValue
            let currentPrice = (objMFAccount.CurrentNAV as NSString).floatValue

            self.totalUnits = allUnits
            self.totalAmount = allUnits * currentPrice
            
            let dicToSend:NSDictionary = [
                "Scheme_Code" : objMFAccount.SchemeCode,
                "Fund_Code" : objMFAccount.RTAamcCode,
                "Txn_Type" : "R"]
            
            WebManagerHK.postDataToURL(kModeGetSchemeThresholdDetails, params: dicToSend, message: "") { (response) in
                
                if response.objectForKey(kWAPIResponse) is NSArray
                {
                    let mainResponse = response.objectForKey(kWAPIResponse) as! NSArray
                    print("Dic Response : \(mainResponse)")
                    
                    if mainResponse.count==0
                    {
                        
                    }
                    else{
                        let dicData = mainResponse.objectAtIndex(0) as! NSDictionary
                        self.minAmount = dicData.valueForKey("Min_Amt") as! Float
                        self.minUnits = dicData.valueForKey("Min_Units") as! Float
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            if self.currentSelectedSwitchBy=="All Units"
                            {
                                self.txtSwitchByValue.hidden = true
                                self.lblSwitchByValue.hidden = true
                                self.lblTotal.hidden = true
                                
                            }else{
                                if self.currentSelectedSwitchBy=="Amount"
                                {
                                    self.lblSwitchByValue.text = "Minimum amount : ₹\(self.minAmount)"
                                    self.lblTotal.text = "Total amount : ₹\(self.totalAmount)"
                                    
                                }
                                if self.currentSelectedSwitchBy=="Units"
                                {
                                    self.lblSwitchByValue.text = "Minimum units : \(self.minUnits)"
                                    self.lblTotal.text = "Total units : \(self.totalUnits)"
                                }
                                self.txtSwitchByValue.hidden = false
                                self.lblSwitchByValue.hidden = false
                                self.lblTotal.hidden = false
                            }
                            
                        })

                    }

                }else
                {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        self.tblView.reloadData()
                        
                    })
                }
            }

            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if self.currentSelectedSwitchBy=="All Units"
                {
                    self.txtSwitchByValue.hidden = true
                    self.lblSwitchByValue.hidden = true
                    self.lblTotal.hidden = true
                    
                }else{
                    if self.currentSelectedSwitchBy=="Amount"
                    {
                        self.lblSwitchByValue.text = "Minimum amount : ₹\(self.minAmount)"
                        self.lblTotal.text = "Total amount : ₹\(self.totalAmount)"
                        
                    }
                    if self.currentSelectedSwitchBy=="Units"
                    {
                        self.lblSwitchByValue.text = "Minimum units : \(self.minUnits)"
                        self.lblTotal.text = "Total units : \(self.totalUnits)"
                    }
                    self.txtSwitchByValue.hidden = false
                    self.lblSwitchByValue.hidden = false
                    self.lblTotal.hidden = false
                }
                
            })

            
            
            
        }
        if txtCurrentSelected.tag==102 {

            txtSwitchBy.resignFirstResponder()
            if row==0 {
                currentSelectedSwitchBy = "All Units"
            }
            if row==1 {
                currentSelectedSwitchBy = "Units"
            }
            if row==2 {
                currentSelectedSwitchBy = "Amount"
            }
            
            txtSwitchBy.text = currentSelectedSwitchBy
            
            
            if currentSelectedSwitchBy=="All Units"
            {
                txtSwitchByValue.hidden = true
                lblSwitchByValue.hidden = true
                lblTotal.hidden = true
                lblUnderLine.hidden = true

            }else{
                if currentSelectedSwitchBy=="Amount"
                {
                    lblSwitchByValue.text = "Minimum amount : ₹\(minAmount)"
                    lblTotal.text = "Total amount : ₹\(totalAmount)"

                    txtSwitchByValue.placeholder = "Enter Amount"
                }
                if currentSelectedSwitchBy=="Units"
                {
                    txtSwitchByValue.placeholder = "Enter Units"

                    lblSwitchByValue.text = "Minimum units : \(minUnits)"
                    lblTotal.text = "Total units : \(totalUnits)"
                }
                txtSwitchByValue.hidden = false
                lblSwitchByValue.hidden = false
                lblTotal.hidden = false
                lblUnderLine.hidden = false
            }
            
            txtSwitchByValue.text = ""
            
            tblView.reloadData()
        }
        
    }


}
