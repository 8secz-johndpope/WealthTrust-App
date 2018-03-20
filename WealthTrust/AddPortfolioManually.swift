//
//  AddPortfolioManually.swift
//  WealthTrust
//
//  Created by Hemen Gohil on 11/22/16.
//  Copyright © 2016 Hemen Gohil. All rights reserved.
//

import UIKit

class AddPortfolioManually: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate {
    
    
    var txtCurrentTextField : UITextField!
    
    @IBOutlet weak var lblTitle: UILabel!
    var lblTitleHeader : UILabel!
    var imgHeader : UIImageView!
    
    @IBOutlet weak var tblView: UITableView!
    
    
    var btnOneTimeRadio : UIButton!
    var btnSIPRadio : UIButton!
    var btnRoundRadio : UIButton!
    
    var btnOneTimeRadioSIP : UIButton!
    var btnSIPRadioSIP : UIButton!
    var btnRoundRadioSIP : UIButton!
    
    var btnsaveAddMore : UIButton!
    var btnSubmit : UIButton!
    
    var txtDOBFirstStep : RPFloatingPlaceholderTextField!
    var datePickerViewFirstStep  : UIDatePicker = UIDatePicker()
    
    var txtSchemeName : UITextField!
    var btnSchemeName : UIButton!
    
    var lbltxtSchemeName : UILabel!
    var txtSchemeAmount : RPFloatingPlaceholderTextField!
    //    var txtSchemeAmountlblNote : UILabel!
    
    var txtNav : RPFloatingPlaceholderTextField!
    var txtUnits : RPFloatingPlaceholderTextField!
    var txtFolio : RPFloatingPlaceholderTextField!
    
    var pickerView = UIPickerView()
    
    var isBuyFrom = kBUY_FROM_FRESH
    
    // SIP AMOUNT
    var txtFundCategorySIP : UITextField!
    var enumfundCategorySIPSelectedIndex = 0
    
    
    var txtFundHouseSIP : UITextField!
    var enumfundHouseSelectedSIPIndex = 0
    
    var btnSchemeNameSIP : UIButton!
    var lbltxtSchemeNameSIP : UILabel!
    
    var txtNavSIP : UITextField!
    
    var txtFrequency : UITextField!
    var enumFrequencySelectedIndex = 0
    var arrFrequency : NSMutableArray = []
    
    
    var txtSchemeAmountSIP : RPFloatingPlaceholderTextField!
    
    var txtNoOfInstallments : RPFloatingPlaceholderTextField!
    
    var txtSIPAmount : UITextField!
    
    var arrSIPSoldDetails : NSMutableArray = []
    
    var txtDOBFirstStepSIP : RPFloatingPlaceholderTextField!
    var datePickerViewFirstStepSIP  : UIDatePicker = UIDatePicker()
    var txtFolioSIP : RPFloatingPlaceholderTextField!
    
    var randomVal = sharedInstance.getRandomVal()

    var objOrderToAdd : Order = Order()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIKeyboardDidHideNotification, object: nil)
        
        tblView.sectionHeaderHeight = 140
        
        self.view.backgroundColor = UIColor.defaultAppBackground
        self.tblView.backgroundColor = UIColor.defaultAppBackground
        
        pickerView.delegate = self
        
        self.arrFrequency.addObject("SELECT")
        self.arrFrequency.addObject("W")
        self.arrFrequency.addObject("F")
        self.arrFrequency.addObject("M")
        self.arrFrequency.addObject("B")
        self.arrFrequency.addObject("Q")
        self.arrFrequency.addObject("S")
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        let value = UIInterfaceOrientation.Portrait.rawValue
        UIDevice.currentDevice().setValue(value, forKey: "orientation")
        
        if isBuyFrom==kBUY_FROM_FRESH { // kBUY_FROM_FRESH START
            
            if let BuyNowScheme = sharedInstance.userDefaults.objectForKey(kSelectAddExistingScheme) as? NSDictionary
            {
                print(BuyNowScheme)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if (self.lbltxtSchemeName != nil) {
                        self.lbltxtSchemeName.text = BuyNowScheme.valueForKey("Plan_Name") as? String
                    }
                    if (self.lbltxtSchemeNameSIP != nil) {
                        self.lbltxtSchemeNameSIP.text = BuyNowScheme.valueForKey("Plan_Name") as? String
                    }
                    self.tblView.reloadData()
                })
                
            }
            
            if let BuyNowScheme = sharedInstance.userDefaults.objectForKey(kSelectAddExistingScheme) as? String
            {
                if lbltxtSchemeName != nil {
                    lbltxtSchemeName.text = BuyNowScheme
                }
                self.tblView.reloadData()
            }
            
        }
        
        
        if isBuyFrom==kBUY_FOR_SIP { // kBUY_FOR_SIP START
            
            
            if let BuyNowScheme = sharedInstance.userDefaults.objectForKey(kSelectAddExistingScheme) as? NSDictionary
            {
                print(BuyNowScheme)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.lbltxtSchemeNameSIP.text = BuyNowScheme.valueForKey("Plan_Name") as? String
                    if (self.lbltxtSchemeNameSIP != nil) {
                        self.lbltxtSchemeNameSIP.text = BuyNowScheme.valueForKey("Plan_Name") as? String
                    }
                    self.tblView.reloadData()
                })
                
            }
            
            if let BuyNowScheme = sharedInstance.userDefaults.objectForKey(kSelectAddExistingScheme) as? String
            {
                if lbltxtSchemeNameSIP != nil {
                    lbltxtSchemeNameSIP.text = BuyNowScheme
                }
                 self.tblView.reloadData()
            }
        }
    }
    
    func calculateAndSetUnits() {
        if !(self.txtSchemeAmount.text?.length == 0) {
            if !(self.txtNav.text?.length == 0) {
                let amount = Double(self.txtSchemeAmount.text!)
                let nav = Double(self.txtNav.text!)
                let units = amount!/nav!
                
                let twoDecimalPlaces = String(format: "%.2f", units)
                self.txtUnits.text = twoDecimalPlaces
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addToolBar(textField: UITextField){
        let toolBar = UIToolbar(frame: CGRectMake(0, self.view.frame.size.height/6, self.view.frame.size.width, 40.0))
        
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        
        toolBar.barStyle = UIBarStyle.Default
        
        toolBar.tintColor = UIColor.blackColor()
        
        //        toolBar.backgroundColor = UIColor.grayColor()
        
        let okBarBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: #selector(AddPortfolioManually.donePressed))
        
        toolBar.setItems([okBarBtn], animated: true)
        toolBar.sizeToFit()
        textField.delegate = self
        
        textField.inputAccessoryView = toolBar
        
        //        let toolBar = UIToolbar()
        //        toolBar.barStyle = UIBarStyle.Default
        //        toolBar.translucent = true
        //        // toolBar.tintColor = UIColor.blueColor()
        //        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: #selector(BuyScreeen.doneClicked))
        //        //        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        //        toolBar.setItems([doneButton], animated: false)
        //        toolBar.userInteractionEnabled = true
        //        toolBar.sizeToFit()
        //
        //        textField.delegate = self
        //        textField.inputAccessoryView = toolBar
    }
    
    func donePressed(sender: UIBarButtonItem) {
        
        
        //        if txtDOBFirstStep.text == "" {
        //            txtDOBFirstStep.text = dateFormatter.stringFromDate(NSDate())
        //        }
        txtDOBFirstStep.resignFirstResponder()
        
        if (txtDOBFirstStepSIP != nil) {
            txtDOBFirstStepSIP.resignFirstResponder()
        }
        txtCurrentTextField.resignFirstResponder()
        
        fetchNAV()
        
    }
    
    func fetchNAV()
    {
        if let fromFundGet = sharedInstance.userDefaults.objectForKey(kSelectAddExistingScheme) as? NSDictionary
        {
            print(fromFundGet)
            let SrcSchemeCode = fromFundGet.objectForKey("Scheme_Code") as! String
            
            let RtaAmcCode = fromFundGet.objectForKey("Fund_Code") as! String
            
            if (txtDOBFirstStep != nil) {
                let dateString = txtDOBFirstStep.text! as String
                
                let dateFormatterDDMMMYYYY = NSDateFormatter()
                dateFormatterDDMMMYYYY.dateFormat = "dd-MMM-yy" // dd MMM yyyy
                
                let dateFormatterYYYYMMDD = NSDateFormatter()
                dateFormatterYYYYMMDD.dateFormat = "yyyy-MM-dd"
                
                if dateString != "" {
                    let date = dateFormatterDDMMMYYYY.dateFromString(dateString)
                    let navDate = dateFormatterYYYYMMDD.stringFromDate(date!)
                    
                    var dicToSend = NSMutableDictionary()
                    dicToSend = ["Amc_code" : "\(RtaAmcCode)", "Scheme_code" : "\(SrcSchemeCode)", "Date" : navDate]
                    
                    WebManagerHK.postDataToURL(kModegetLatestNAV, params: dicToSend, message: "") { (response) in
                        print("Dic Response : \(response)")
                        
                        if response.objectForKey(kWAPIResponseStatus) as! String == "OK"
                        {
//                            return
//                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                            let mainObject = response.objectForKey(kWAPIResponse) as! NSDictionary
//                            //                            let navString = mainObject.objectForKey("NAV") as! String
//                            
//                            if let nav = mainObject.valueForKey("NAV")
//                            {
//                                let twoDecimalPlaces = String(format: "%.2f", nav as! Double)
//                                self.txtNav.text? = twoDecimalPlaces
//                                self.calculateAndSetUnits()
//                            }
//                        })
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                
                                let mainObject = response.objectForKey(kWAPIResponse) as! NSDictionary
                                self.randomVal = sharedInstance.getRandomVal()

                                let navString = mainObject.objectForKey("NAV") as! Double
                                print(navString)
                                self.txtNav.text! = (navString: "\(navString)")
                                self.calculateAndSetUnits()
                                
                            })
                        }
                    }
                }
            }
        }
    }
    //    func tappedToolBarBtn(sender: UIBarButtonItem) {
    //
    //        let dateformatter = NSDateFormatter()
    //        dateformatter.dateFormat = "dd-MMM-yy"
    //        txtDOBFirstStep.text = dateformatter.stringFromDate(NSDate())
    //
    //        txtDOBFirstStep.resignFirstResponder()
    //    }
    //
    //    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    //        self.view.endEditing(true)
    //    }
    
    func handleDatePickerr(sender: UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yy" // dd MMM yyyy
        print(dateFormatter.stringFromDate(sender.date))
        
        if (txtDOBFirstStepSIP != nil) {
            txtDOBFirstStepSIP.text = dateFormatter.stringFromDate(sender.date)
        }
        
        txtCurrentTextField.text = dateFormatter.stringFromDate(sender.date)
        
    }
    @IBAction func btnAllBackClicked(sender: AnyObject) {
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
        textField .setValue(UIColor(red:0.78, green:0.78, blue:0.78, alpha:1.0), forKeyPath: "_placeholderLabel.textColor")
        textField.textColor = UIColor.blackColor()
        textField.textAlignment = NSTextAlignment.Left
        textField.font = UIFont.systemFontOfSize(16)
        textField.autocorrectionType = .No
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isBuyFrom==kBUY_FROM_FRESH { // kBUY_FROM_FRESH START
            return 8
        }
        if isBuyFrom==kBUY_FOR_SIP { // kBUY_FOR_SIP START
            return 8
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        if isBuyFrom==kBUY_FROM_FRESH { // kBUY_FROM_FRESH START
            
            let planName = "CELL_BUYSIP_\(randomVal)_\(indexPath.row)_\(indexPath.section)_\(lblTitle.text)"
            
            var identifier = planName
            
            if let BuyFromScheme = sharedInstance.userDefaults.objectForKey(kSelectAddExistingScheme) as? String
            {
                identifier = identifier + BuyFromScheme
            }
            if let BuyFromScheme = sharedInstance.userDefaults.objectForKey(kSelectAddExistingScheme) as? NSDictionary
            {
                let val = BuyFromScheme.valueForKey("Scheme_Code") as? String
                
                identifier = identifier + val!
            }
            
            
            tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: identifier)
            
            let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as UITableViewCell
            
            cell.selectionStyle = .None
            cell.contentView.backgroundColor = UIColor.defaultAppBackground
            cell.backgroundColor = UIColor.defaultAppBackground
            
            if (cell.contentView.subviews.count==0) {
                
                switch indexPath.row {
                case 0:
                    
                    btnOneTimeRadio = UIButton(frame: CGRect(x: 10, y: 15, width: 20, height: 20));
                    btnOneTimeRadio.layer.cornerRadius = 10
                    btnOneTimeRadio.layer.borderWidth = 2.0
                    btnOneTimeRadio.layer.borderColor = UIColor.defaultAppColorBlue.CGColor
                    cell.contentView.addSubview(btnOneTimeRadio)
                    btnOneTimeRadio.addTarget(self, action: #selector(AddPortfolioManually.btnOneTimeClicked(_:)), forControlEvents: .TouchUpInside)
                    
                    let lblOneTime = UIButton(frame: CGRect(x: 33, y: 5, width: 70, height: 40));
                    lblOneTime.setTitle("One-time", forState: .Normal)
                    lblOneTime.titleLabel?.font = UIFont.systemFontOfSize(14)
                    lblOneTime.setTitleColor(UIColor.blackColor(), forState: .Normal)
                    lblOneTime.addTarget(self, action: #selector(AddPortfolioManually.btnOneTimeClicked(_:)), forControlEvents: .TouchUpInside)
                    lblOneTime.titleLabel?.textAlignment = .Left
                    lblOneTime.contentHorizontalAlignment = .Left;
                    cell.contentView.addSubview(lblOneTime)
                    
                    
                    btnSIPRadio = UIButton(frame: CGRect(x: 110, y: 15, width: 20, height: 20));
                    btnSIPRadio.layer.cornerRadius = 10
                    btnSIPRadio.layer.borderWidth = 2.0
                    btnSIPRadio.layer.borderColor = UIColor.lightGrayColor().CGColor
                    cell.contentView.addSubview(btnSIPRadio)
                    btnSIPRadio.addTarget(self, action: #selector(AddPortfolioManually.btnSIPClicked(_:)), forControlEvents: .TouchUpInside)
                    
                    let lblSIP = UIButton(frame: CGRect(x: 135, y: 5, width: 70, height: 40));
                    lblSIP.setTitle("SIP", forState: .Normal)
                    lblSIP.titleLabel?.font = UIFont.systemFontOfSize(14)
                    lblSIP.setTitleColor(UIColor.blackColor(), forState: .Normal)
                    lblSIP.addTarget(self, action: #selector(AddPortfolioManually.btnSIPClicked(_:)), forControlEvents: .TouchUpInside)
                    lblSIP.titleLabel?.textAlignment = .Left
                    lblSIP.contentHorizontalAlignment = .Left;
                    cell.contentView.addSubview(lblSIP)
                    
                    if btnRoundRadio==nil {
                        btnRoundRadio = UIButton(frame: CGRect(x: 5, y: 5, width: 10, height: 10));
                        btnRoundRadio.layer.cornerRadius = 5
                        btnRoundRadio.layer.borderWidth = 2.0
                        btnRoundRadio.backgroundColor = UIColor.defaultAppColorBlue
                        btnRoundRadio.layer.borderColor = UIColor.defaultAppColorBlue.CGColor
                        btnOneTimeRadio.addSubview(btnRoundRadio)
                    }else{
                        
                        if lblTitle.text=="SIP" {
                            
                            btnOneTimeRadio.layer.borderColor = UIColor.lightGrayColor().CGColor
                            btnSIPRadio.layer.borderColor = UIColor.defaultAppColorBlue.CGColor
                            btnRoundRadio.removeFromSuperview()
                            btnRoundRadio = UIButton(frame: CGRect(x: 5, y: 5, width: 10, height: 10));
                            btnRoundRadio.layer.cornerRadius = 5
                            btnRoundRadio.layer.borderWidth = 2.0
                            btnRoundRadio.backgroundColor = UIColor.defaultAppColorBlue
                            btnRoundRadio.layer.borderColor = UIColor.defaultAppColorBlue.CGColor
                            btnSIPRadio.addSubview(btnRoundRadio)
                            
                        }else{
                            
                            btnOneTimeRadio.layer.borderColor = UIColor.defaultAppColorBlue.CGColor
                            btnSIPRadio.layer.borderColor = UIColor.lightGrayColor().CGColor
                            
                            btnRoundRadio.removeFromSuperview()
                            btnRoundRadio = UIButton(frame: CGRect(x: 5, y: 5, width: 10, height: 10));
                            btnRoundRadio.layer.cornerRadius = 5
                            btnRoundRadio.layer.borderWidth = 2.0
                            btnRoundRadio.backgroundColor = UIColor.defaultAppColorBlue
                            btnRoundRadio.layer.borderColor = UIColor.defaultAppColorBlue.CGColor
                            btnOneTimeRadio.addSubview(btnRoundRadio)
                            
                        }
                        
                    }
                    
                    
                    return cell;
                    
                case 1:
                    
                    var lblUploadPan : UILabel!
                    lblUploadPan = UILabel(frame: CGRect(x: 10, y: 25, width: (cell.contentView.frame.size.width)-20, height: 25));
                    //                    lblUploadPan.text = "Scheme Name"
                    lblUploadPan.textColor = UIColor.darkGrayColor()
                    lblUploadPan.font = UIFont.systemFontOfSize(12)
                    lblUploadPan.tag=101
                    cell.contentView.addSubview(lblUploadPan)
                    
                    
                    lbltxtSchemeName = UILabel(frame: CGRect(x: 10, y: 40, width: (cell.contentView.frame.size.width)-50, height: 60));
                    lbltxtSchemeName.text = kEnterSchemeName
                    lbltxtSchemeName.textColor = UIColor.darkGrayColor()
                    lbltxtSchemeName.font = UIFont.systemFontOfSize(16)
                    lbltxtSchemeName.numberOfLines = 2
                    cell.contentView.addSubview(lbltxtSchemeName)
                    
                    if let BuyFromScheme = sharedInstance.userDefaults.objectForKey(kSelectAddExistingScheme) as? String
                    {
                        print(BuyFromScheme)
                        lbltxtSchemeName.text = BuyFromScheme
                        lbltxtSchemeName.textColor = UIColor(red:0.78, green:0.78, blue:0.78, alpha:1.0)
                    }
                    if let BuyFromScheme = sharedInstance.userDefaults.objectForKey(kSelectAddExistingScheme) as? NSDictionary
                    {
                        print(BuyFromScheme)
                        lblUploadPan.text = "Scheme Name"
                        lbltxtSchemeName.text = BuyFromScheme.valueForKey("Plan_Name") as? String
                        lbltxtSchemeName.textColor = UIColor.blackColor()
                    }
                    else
                    {
                        lbltxtSchemeName.textColor = UIColor(red:0.78, green:0.78, blue:0.78, alpha:1.0)
                    }
                    
                    
                    btnSchemeName = UIButton(frame: CGRect(x: 10, y: 40, width: (cell.contentView.frame.size.width)-20, height: 60));
                    btnSchemeName.addTarget(self, action: #selector(AddPortfolioManually.btnBuySchemeNameClicked(_:)), forControlEvents: .TouchUpInside)
                    cell.contentView.addSubview(btnSchemeName)
                    
                    //                    var imgDownArrow : UIImageView!
                    //                    imgDownArrow = UIImageView(frame: CGRect(x: (cell.contentView.frame.size.width)-50, y: 50, width: 30, height: 30));
                    //                    imgDownArrow.image = UIImage(named: "iconDown")
                    //                    imgDownArrow.backgroundColor = UIColor.clearColor()
                    //                    cell.contentView.addSubview(imgDownArrow)
                    
                    var lblLine : UILabel!
                    lblLine = UILabel(frame: CGRect(x: 10, y: 90, width: (cell.contentView.frame.size.width)-30, height: 1));
                    lblLine.backgroundColor = UIColor.lightGrayColor()
                    lblLine.alpha = 0.4
                    cell.contentView.addSubview(lblLine)
                    
                    
                    return cell;
                    
                case 2:
                    
                    txtSchemeAmount = RPFloatingPlaceholderTextField(frame: CGRect(x: 6, y: 15, width: (cell.contentView.frame.size.width)-20, height: 35))
                    //                        UITextField(frame: CGRect(x: 10, y: 10, width: (cell.contentView.frame.size.width)-20, height: 35));
                    txtSchemeAmount.text = ""
                    txtSchemeAmount.placeholder = "Enter Amount(₹)"
                    txtSchemeAmount.floatingLabelActiveTextColor = UIColor.darkGrayColor()
                    txtSchemeAmount.floatingLabelInactiveTextColor = UIColor.darkGrayColor()
                    txtSchemeAmount.floatingLabel.font = UIFont.systemFontOfSize(12)
                    txtSchemeAmount.keyboardType = UIKeyboardType.NumberPad
                    self.applyTextFiledStyle1(txtSchemeAmount)
                    cell.contentView.addSubview(txtSchemeAmount)
                    
                    var lblLine2 : UILabel!
                    lblLine2 = UILabel(frame: CGRect(x: 10, y: 50, width: (cell.contentView.frame.size.width)-20, height: 1));
                    lblLine2.backgroundColor = UIColor.lightGrayColor()
                    lblLine2.alpha = 0.4
                    cell.contentView.addSubview(lblLine2)
                    
                    return cell;
                    
                case 3:
                    
                    // Add Purchase Date here...
                    
                    txtDOBFirstStep = RPFloatingPlaceholderTextField(frame: CGRect(x: 6, y: 15, width: (cell.contentView.frame.size.width)-20, height: 35))
                    //                        UITextField(frame: CGRect(x: 10, y: 10, width: (cell.contentView.frame.size.width)-20, height: 35));
                    txtDOBFirstStep.placeholder = "Purchase Date (DD-MMM-YY)"
                    txtDOBFirstStep.floatingLabelActiveTextColor = UIColor.darkGrayColor()
                    txtDOBFirstStep.floatingLabelInactiveTextColor = UIColor.darkGrayColor()
                    txtDOBFirstStep.floatingLabel.font = UIFont.systemFontOfSize(12)
                    txtDOBFirstStep.keyboardType = UIKeyboardType.Default
                    addToolBar(txtDOBFirstStep)
                    self.applyTextFiledStyle1(txtDOBFirstStep)
                    cell.contentView.addSubview(txtDOBFirstStep)
                    
                    let currentDate: NSDate = NSDate()
                    
                    datePickerViewFirstStep.datePickerMode = UIDatePickerMode.Date
                    datePickerViewFirstStep.maximumDate = currentDate
                    txtDOBFirstStep.inputView = datePickerViewFirstStep
                    datePickerViewFirstStep.addTarget(self, action: #selector(AddPortfolioManually.handleDatePickerr(_:)), forControlEvents: UIControlEvents.ValueChanged)
                    
                    
                    var lblLineNAV : UILabel!
                    lblLineNAV = UILabel(frame: CGRect(x: 10, y: 50, width: (cell.contentView.frame.size.width)-30, height: 1));
                    lblLineNAV.backgroundColor = UIColor.lightGrayColor()
                    lblLineNAV.alpha = 0.4
                    cell.contentView.addSubview(lblLineNAV)
                    
                    
                    return cell;
                    
                case 4:
                    
                    txtNav = RPFloatingPlaceholderTextField(frame: CGRect(x: 6, y: 10, width: (cell.contentView.frame.size.width)-20, height: 35))
                    //                        UITextField(frame: CGRect(x: 10, y: 10, width: (cell.contentView.frame.size.width)-20, height: 35));
                    txtNav.placeholder = "NAV"
                    txtNav.floatingLabelActiveTextColor = UIColor.darkGrayColor()
                    txtNav.floatingLabelInactiveTextColor = UIColor.darkGrayColor()
                    txtNav.floatingLabel.font = UIFont.systemFontOfSize(12)
                    txtNav.keyboardType = UIKeyboardType.NumberPad
                    self.applyTextFiledStyle1(txtNav)
                    cell.contentView.addSubview(txtNav)
                    txtNav.textColor = UIColor.blackColor()
                    
                    var lblLineNAV : UILabel!
                    lblLineNAV = UILabel(frame: CGRect(x: 10, y: 45, width: (cell.contentView.frame.size.width)-30, height: 1));
                    lblLineNAV.backgroundColor = UIColor.lightGrayColor()
                    lblLineNAV.alpha = 0.4
                    cell.contentView.addSubview(lblLineNAV)
                    
                    return cell;
                    
                case 5:
                    
                    txtUnits = RPFloatingPlaceholderTextField(frame: CGRect(x: 6, y: 10, width: (cell.contentView.frame.size.width)-20, height: 35))
                    //                        UITextField(frame: CGRect(x: 10, y: 10, width: (cell.contentView.frame.size.width)-20, height: 35));
                    txtUnits.placeholder = "Units"
                    txtUnits.floatingLabelActiveTextColor = UIColor.darkGrayColor()
                    txtUnits.floatingLabelInactiveTextColor = UIColor.darkGrayColor()
                    txtUnits.floatingLabel.font = UIFont.systemFontOfSize(12)
                    txtUnits.keyboardType = UIKeyboardType.NumberPad
                    self.applyTextFiledStyle1(txtUnits)
                    cell.contentView.addSubview(txtUnits)
                    txtUnits.textColor = UIColor.blackColor()
                    
                    var lblLineNAV : UILabel!
                    lblLineNAV = UILabel(frame: CGRect(x: 10, y: 45, width: (cell.contentView.frame.size.width)-30, height: 1));
                    lblLineNAV.backgroundColor = UIColor.lightGrayColor()
                    lblLineNAV.alpha = 0.4
                    cell.contentView.addSubview(lblLineNAV)
                    
                    
                    return cell;
                case 6:
                    
                    txtFolio = RPFloatingPlaceholderTextField(frame: CGRect(x: 6, y: 15, width: (cell.contentView.frame.size.width)-20, height: 35))
                    //                        UITextField(frame: CGRect(x: 10, y: 10, width: (cell.contentView.frame.size.width)-20, height: 35));
                    txtFolio.placeholder = "Folio Number (Optional)"
                    txtFolio.floatingLabelActiveTextColor = UIColor.darkGrayColor()
                    txtFolio.floatingLabelInactiveTextColor = UIColor.darkGrayColor()
                    txtFolio.floatingLabel.font = UIFont.systemFontOfSize(12)
                    txtFolio.keyboardType = UIKeyboardType.NumberPad
                    self.applyTextFiledStyle1(txtFolio)
                    cell.contentView.addSubview(txtFolio)
                    txtFolio.textColor = UIColor.blackColor()
                    
                    var lblLineNAV : UILabel!
                    lblLineNAV = UILabel(frame: CGRect(x: 10, y: 50, width: (cell.contentView.frame.size.width)-30, height: 1));
                    lblLineNAV.backgroundColor = UIColor.lightGrayColor()
                    lblLineNAV.alpha = 0.4
                    cell.contentView.addSubview(lblLineNAV)
                    
                    return cell;
                    
                case 7:
                    btnSubmit = UIButton(frame: CGRect(x: cell.contentView.frame.size.width-80, y: 10, width: 70, height: 36))
                    btnSubmit.setTitle("Submit", forState: .Normal)
                    btnSubmit.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                    btnSubmit.backgroundColor = UIColor.defaultOrangeButton
                    btnSubmit.titleLabel?.font = UIFont.systemFontOfSize(14)
                    btnSubmit.layer.cornerRadius = 1.5
                    btnSubmit.addTarget(self, action: #selector(AddPortfolioManually.btnSubmitClicked(_:)), forControlEvents: .TouchUpInside)
                    cell.contentView.addSubview(btnSubmit)
                    btnSubmit.tag = 1
                    
                    btnsaveAddMore = UIButton(frame: CGRect(x: cell.contentView.frame.size.width-210, y: 10, width: 120, height: 36))
                    btnsaveAddMore.setTitle("Save & Add more", forState: .Normal)
                    btnsaveAddMore.setTitleColor(UIColor.defaultOrangeButton, forState: .Normal)
                    btnsaveAddMore.backgroundColor = UIColor.whiteColor()
                    btnsaveAddMore.titleLabel?.font = UIFont.systemFontOfSize(14)
                    btnsaveAddMore.layer.cornerRadius = 1.5
                    btnsaveAddMore.layer.borderColor = UIColor.defaultOrangeButton.CGColor
                    btnsaveAddMore.layer.borderWidth = 1.0
                    btnsaveAddMore.addTarget(self, action: #selector(AddPortfolioManually.btnSubmitClicked(_:)), forControlEvents: .TouchUpInside)
                    cell.contentView.addSubview(btnsaveAddMore)
                    btnsaveAddMore.tag = 2
                    
                    cell.selectionStyle = UITableViewCellSelectionStyle.None
                    cell.contentView.backgroundColor = UIColor.clearColor()
                    cell.backgroundColor = UIColor.clearColor()
                    
                    return cell;
                    
                default:
                    break;
                }
                
            }/*else
             {
             if indexPath.row == 1
             {
             
             var lblUploadPan : UILabel!
             //                    lblUploadPan = UILabel(frame: CGRect(x: 10, y: 5, width: (cell.contentView.frame.size.width)-20, height: 25));
             
             //                    lbltxtSchemeName.textColor = UIColor.blackColor()
             if lblUploadPan == self.view.viewWithTag(101)
             {
             lblUploadPan.textColor = UIColor.lightGrayColor()
             }
             else
             {
             lblUploadPan = UILabel(frame: CGRect(x: 10, y: 5, width: (cell.contentView.frame.size.width)-20, height: 25));
             lblUploadPan.textColor = UIColor.darkGrayColor()
             lblUploadPan.font = UIFont.systemFontOfSize(12)
             cell.contentView.addSubview(lblUploadPan)
             lblUploadPan.text = "Scheme Name"
             
             }
             }
             
             }*/
            
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.contentView.backgroundColor = UIColor.clearColor()
            cell.backgroundColor = UIColor.clearColor()
            
            
            return cell;
            
        } // kBUY_FROM_FRESH END
        
        
        if isBuyFrom==kBUY_FOR_SIP { // kBUY_FOR_SIP START
            
            let planName = "CELL_BUYSIP_FORSIPALL_\(randomVal)_\(indexPath.row)_\(indexPath.section)_\(lblTitle.text)"
            
            var identifier = planName
            
            if let BuyFromScheme = sharedInstance.userDefaults.objectForKey(kSelectAddExistingScheme) as? String
            {
                identifier = identifier + BuyFromScheme
            }
            if let BuyFromScheme = sharedInstance.userDefaults.objectForKey(kSelectAddExistingScheme) as? NSDictionary
            {
                let val = BuyFromScheme.valueForKey("Scheme_Code") as? String
                
                identifier = identifier + val!
            }
            
            tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: identifier)
            
            let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as UITableViewCell
            
            cell.selectionStyle = .None
            
            if (cell.contentView.subviews.count==0) {
                
                switch indexPath.row {
                case 0:
                    
                    btnOneTimeRadioSIP = UIButton(frame: CGRect(x: 10, y: 15, width: 20, height: 20));
                    btnOneTimeRadioSIP.layer.cornerRadius = 10
                    btnOneTimeRadioSIP.layer.borderWidth = 2.0
                    btnOneTimeRadioSIP.layer.borderColor = UIColor.lightGrayColor().CGColor
                    cell.contentView.addSubview(btnOneTimeRadioSIP)
                    btnOneTimeRadioSIP.addTarget(self, action: #selector(AddPortfolioManually.btnOneTimeClicked(_:)), forControlEvents: .TouchUpInside)
                    
                    let lblOneTime = UIButton(frame: CGRect(x: 33, y: 5, width: 70, height: 40));
                    lblOneTime.setTitle("One-time", forState: .Normal)
                    lblOneTime.titleLabel?.font = UIFont.systemFontOfSize(14)
                    lblOneTime.setTitleColor(UIColor.blackColor(), forState: .Normal)
                    lblOneTime.addTarget(self, action: #selector(AddPortfolioManually.btnOneTimeClicked(_:)), forControlEvents: .TouchUpInside)
                    lblOneTime.titleLabel?.textAlignment = .Left
                    lblOneTime.contentHorizontalAlignment = .Left;
                    cell.contentView.addSubview(lblOneTime)
                    
                    btnSIPRadioSIP = UIButton(frame: CGRect(x: 110, y: 15, width: 20, height: 20));
                    btnSIPRadioSIP.layer.cornerRadius = 10
                    btnSIPRadioSIP.layer.borderWidth = 2.0
                    btnSIPRadioSIP.layer.borderColor = UIColor.defaultAppColorBlue.CGColor
                    cell.contentView.addSubview(btnSIPRadioSIP)
                    btnSIPRadioSIP.addTarget(self, action: #selector(AddPortfolioManually.btnSIPClicked(_:)), forControlEvents: .TouchUpInside)
                    
                    let lblSIP = UIButton(frame: CGRect(x: 135, y: 5, width: 70, height: 40));
                    lblSIP.setTitle("SIP", forState: .Normal)
                    lblSIP.titleLabel?.font = UIFont.systemFontOfSize(14)
                    lblSIP.setTitleColor(UIColor.blackColor(), forState: .Normal)
                    lblSIP.addTarget(self, action: #selector(AddPortfolioManually.btnSIPClicked(_:)), forControlEvents: .TouchUpInside)
                    lblSIP.titleLabel?.textAlignment = .Left
                    lblSIP.contentHorizontalAlignment = .Left;
                    cell.contentView.addSubview(lblSIP)
                    
                    if btnRoundRadioSIP==nil {
                        btnRoundRadioSIP = UIButton(frame: CGRect(x: 5, y: 5, width: 10, height: 10));
                        btnRoundRadioSIP.layer.cornerRadius = 5
                        btnRoundRadioSIP.layer.borderWidth = 2.0
                        btnRoundRadioSIP.backgroundColor = UIColor.defaultAppColorBlue
                        btnRoundRadioSIP.layer.borderColor = UIColor.defaultAppColorBlue.CGColor
                        btnSIPRadioSIP.addSubview(btnRoundRadioSIP)
                        
                        
                        btnOneTimeRadioSIP.layer.borderColor = UIColor.lightGrayColor().CGColor
                        btnSIPRadioSIP.layer.borderColor = UIColor.defaultAppColorBlue.CGColor
                        
                    }else{
                        
                        btnOneTimeRadioSIP.layer.borderColor = UIColor.lightGrayColor().CGColor
                        btnSIPRadioSIP.layer.borderColor = UIColor.defaultAppColorBlue.CGColor
                        btnRoundRadioSIP.removeFromSuperview()
                        
                        btnRoundRadioSIP = UIButton(frame: CGRect(x: 5, y: 5, width: 10, height: 10));
                        btnRoundRadioSIP.layer.cornerRadius = 5
                        btnRoundRadioSIP.layer.borderWidth = 2.0
                        btnRoundRadioSIP.backgroundColor = UIColor.defaultAppColorBlue
                        btnRoundRadioSIP.layer.borderColor = UIColor.defaultAppColorBlue.CGColor
                        btnSIPRadioSIP.addSubview(btnRoundRadioSIP)
                        
                    }
                    
                    return cell;
                    
                case 1:
                    
                    var lblUploadPan : UILabel!
                    lblUploadPan = UILabel(frame: CGRect(x: 10, y: 25, width: (cell.contentView.frame.size.width)-20, height: 25));
                    //                    lblUploadPan.text = "Enter Scheme Name"
                    lblUploadPan.textColor = UIColor.darkGrayColor()
                    lblUploadPan.font = UIFont.systemFontOfSize(12)
                    lblUploadPan.tag=102
                    cell.contentView.addSubview(lblUploadPan)
                    
                    lbltxtSchemeNameSIP = UILabel(frame: CGRect(x: 10, y: 40, width: (cell.contentView.frame.size.width)-50, height: 60));
                    lbltxtSchemeNameSIP.text = kEnterSchemeName
                    lbltxtSchemeNameSIP.textColor = UIColor.darkGrayColor()
                    lbltxtSchemeNameSIP.font = UIFont.systemFontOfSize(16)
                    lbltxtSchemeNameSIP.numberOfLines = 2
                    cell.contentView.addSubview(lbltxtSchemeNameSIP)
                    
                    if let BuyFromScheme = sharedInstance.userDefaults.objectForKey(kSelectAddExistingScheme) as? String
                    {
                        print(BuyFromScheme)
                        lbltxtSchemeNameSIP.text = BuyFromScheme
                        lbltxtSchemeNameSIP.textColor = UIColor(red:0.78, green:0.78, blue:0.78, alpha:1.0)
                    }
                    if let BuyFromScheme = sharedInstance.userDefaults.objectForKey(kSelectAddExistingScheme) as? NSDictionary
                    {
                        print(BuyFromScheme)
                        lblUploadPan.text = "Scheme Name"
                        lbltxtSchemeNameSIP.text = BuyFromScheme.valueForKey("Plan_Name") as? String
                        lbltxtSchemeNameSIP.textColor = UIColor.blackColor()
                    }
                    else
                    {
                        lbltxtSchemeNameSIP.textColor = UIColor(red:0.78, green:0.78, blue:0.78, alpha:1.0)
                    }
                    
                    
                    btnSchemeNameSIP = UIButton(frame: CGRect(x: 10, y: 40, width: (cell.contentView.frame.size.width)-20, height: 60));
                    btnSchemeNameSIP.addTarget(self, action: #selector(AddPortfolioManually.btnBuySchemeNameClicked(_:)), forControlEvents: .TouchUpInside)
                    cell.contentView.addSubview(btnSchemeNameSIP)
                    
                    //                    var imgDownArrow : UIImageView!
                    //                    imgDownArrow = UIImageView(frame: CGRect(x: (cell.contentView.frame.size.width)-50, y: 50, width: 30, height: 30));
                    //                    imgDownArrow.image = UIImage(named: "iconDown")
                    //                    imgDownArrow.backgroundColor = UIColor.clearColor()
                    //                    cell.contentView.addSubview(imgDownArrow)
                    
                    var lblLine : UILabel!
                    lblLine = UILabel(frame: CGRect(x: 10, y: 90, width: (cell.contentView.frame.size.width)-30, height: 1));
                    lblLine.backgroundColor = UIColor.lightGrayColor()
                    lblLine.alpha = 0.4
                    cell.contentView.addSubview(lblLine)
                    
                    return cell;
                    
                case 2:
                    
                    txtSchemeAmountSIP = RPFloatingPlaceholderTextField(frame: CGRect(x: 6, y: 15, width: (cell.contentView.frame.size.width)-20, height: 35))
                    //                        UITextField(frame: CGRect(x: 10, y: 10, width: (cell.contentView.frame.size.width)-20, height: 35));
                    txtSchemeAmountSIP.text = ""
                    txtSchemeAmountSIP.placeholder = "Enter SIP Amount(₹)"
                    txtSchemeAmountSIP.floatingLabelActiveTextColor = UIColor.darkGrayColor()
                    txtSchemeAmountSIP.floatingLabelInactiveTextColor = UIColor.darkGrayColor()
                    txtSchemeAmountSIP.floatingLabel.font = UIFont.systemFontOfSize(12)
                    txtSchemeAmountSIP.keyboardType = UIKeyboardType.NumberPad
                    self.applyTextFiledStyle1(txtSchemeAmountSIP)
                    cell.contentView.addSubview(txtSchemeAmountSIP)
                    
                    var lblLine2 : UILabel!
                    lblLine2 = UILabel(frame: CGRect(x: 10, y: 50, width: (cell.contentView.frame.size.width)-20, height: 1));
                    lblLine2.backgroundColor = UIColor.lightGrayColor()
                    lblLine2.alpha = 0.4
                    cell.contentView.addSubview(lblLine2)
                    
                    
                    return cell;
                    
                case 3:
                    
                    // Frequency....
                    var lblFrequency : UILabel!
                    lblFrequency = UILabel(frame: CGRect(x: 10, y: 5, width: (cell.contentView.frame.size.width)-20, height: 25));
                    lblFrequency.text = "Frequency"
                    lblFrequency.textColor = UIColor.darkGrayColor()
                    lblFrequency.font = UIFont.systemFontOfSize(12)
                    cell.contentView.addSubview(lblFrequency)
                    
                    
                    txtFrequency = UITextField(frame: CGRect(x: 10, y: 30, width: (cell.contentView.frame.size.width)-20, height: 35));
                    
                    if enumFrequencySelectedIndex<arrFrequency.count {
                        txtFrequency.text = sharedInstance.getFullNameFromFrequency(arrFrequency.objectAtIndex(enumFrequencySelectedIndex) as! String)
                    }else{
                        txtFrequency.text = "SELECT"
                    }
                    
                    txtFrequency.keyboardType = UIKeyboardType.Default
                    self.applyTextFiledStyle1(txtFrequency)
                    cell.contentView.addSubview(txtFrequency)
                    txtFrequency.inputView = pickerView
                    txtFrequency.tag = TAG_FREQUENCY
                    txtFrequency.textColor = UIColor.blackColor()
                    
                    var imgDownArrowFrequency : UIImageView!
                    imgDownArrowFrequency = UIImageView(frame: CGRect(x: (cell.contentView.frame.size.width)-50, y: 30, width: 30, height: 30));
                    imgDownArrowFrequency.image = UIImage(named: "iconDown")
                    imgDownArrowFrequency.backgroundColor = UIColor.clearColor()
                    cell.contentView.addSubview(imgDownArrowFrequency)
                    
                    var lblLineFR : UILabel!
                    lblLineFR = UILabel(frame: CGRect(x: 10, y: 60, width: (cell.contentView.frame.size.width)-30, height: 1));
                    lblLineFR.backgroundColor = UIColor.lightGrayColor()
                    lblLineFR.alpha = 0.4
                    cell.contentView.addSubview(lblLineFR)
                    
                    
                    
                    return cell;
                    
                case 4:
                    
                    txtDOBFirstStepSIP = RPFloatingPlaceholderTextField(frame: CGRect(x: 6, y: 15, width: (cell.contentView.frame.size.width)-20, height: 35))
                    //                        UITextField(frame: CGRect(x: 10, y: 10, width: (cell.contentView.frame.size.width)-20, height: 35));
                    txtDOBFirstStepSIP.placeholder = "Select SIP start date"
                    txtDOBFirstStepSIP.floatingLabelActiveTextColor = UIColor.darkGrayColor()
                    txtDOBFirstStepSIP.floatingLabelInactiveTextColor = UIColor.darkGrayColor()
                    txtDOBFirstStepSIP.floatingLabel.font = UIFont.systemFontOfSize(12)
                    txtDOBFirstStepSIP.keyboardType = UIKeyboardType.Default
                    addToolBar(txtDOBFirstStepSIP)
                    self.applyTextFiledStyle1(txtDOBFirstStepSIP)
                    cell.contentView.addSubview(txtDOBFirstStepSIP)
                    
                    let currentDate: NSDate = NSDate()
                    
                    datePickerViewFirstStepSIP.datePickerMode = UIDatePickerMode.Date
                    datePickerViewFirstStepSIP.maximumDate = currentDate
                    txtDOBFirstStepSIP.inputView = datePickerViewFirstStepSIP
                    datePickerViewFirstStepSIP.addTarget(self, action: #selector(AddPortfolioManually.handleDatePickerr(_:)), forControlEvents: UIControlEvents.ValueChanged)
                    
                    var lblLineNAV : UILabel!
                    lblLineNAV = UILabel(frame: CGRect(x: 10, y: 50, width: (cell.contentView.frame.size.width)-30, height: 1));
                    lblLineNAV.backgroundColor = UIColor.lightGrayColor()
                    lblLineNAV.alpha = 0.4
                    cell.contentView.addSubview(lblLineNAV)
                    
                    
                    return cell;
                    
                case 5:
                    
                    
                    txtNoOfInstallments = RPFloatingPlaceholderTextField(frame: CGRect(x: 6, y: 10, width: (cell.contentView.frame.size.width)-20, height: 35))
                    //                        UITextField(frame: CGRect(x: 10, y: 10, width: (cell.contentView.frame.size.width)-20, height: 35));
                    txtNoOfInstallments.text = ""
                    txtNoOfInstallments.placeholder = "No. of installments"
                    txtNoOfInstallments.floatingLabelActiveTextColor = UIColor.darkGrayColor()
                    txtNoOfInstallments.floatingLabelInactiveTextColor = UIColor.darkGrayColor()
                    txtNoOfInstallments.floatingLabel.font = UIFont.systemFontOfSize(12)
                    txtNoOfInstallments.keyboardType = UIKeyboardType.NumberPad
                    self.applyTextFiledStyle1(txtNoOfInstallments)
                    cell.contentView.addSubview(txtNoOfInstallments)
                    
                    var lblLineNoOfI : UILabel!
                    lblLineNoOfI = UILabel(frame: CGRect(x: 10, y: 45, width: (cell.contentView.frame.size.width)-20, height: 1));
                    lblLineNoOfI.backgroundColor = UIColor.lightGrayColor()
                    lblLineNoOfI.alpha = 0.4
                    cell.contentView.addSubview(lblLineNoOfI)
                    
                    
                    return cell;
                    
                case 6:
                    
                    txtFolioSIP = RPFloatingPlaceholderTextField(frame: CGRect(x: 6, y: 15, width: (cell.contentView.frame.size.width)-20, height: 35))
                    //                        UITextField(frame: CGRect(x: 10, y: 10, width: (cell.contentView.frame.size.width)-20, height: 35));
                    txtFolioSIP.placeholder = "Folio Number (Optional)"
                    txtFolioSIP.floatingLabelActiveTextColor = UIColor.darkGrayColor()
                    txtFolioSIP.floatingLabelInactiveTextColor = UIColor.darkGrayColor()
                    txtFolioSIP.floatingLabel.font = UIFont.systemFontOfSize(12)
                    
                    txtFolioSIP.keyboardType = UIKeyboardType.NumberPad
                    self.applyTextFiledStyle1(txtFolioSIP)
                    cell.contentView.addSubview(txtFolioSIP)
                    txtFolioSIP.textColor = UIColor.blackColor()
                    
                    var lblLineNAV : UILabel!
                    lblLineNAV = UILabel(frame: CGRect(x: 10, y: 50, width: (cell.contentView.frame.size.width)-30, height: 1));
                    lblLineNAV.backgroundColor = UIColor.lightGrayColor()
                    lblLineNAV.alpha = 0.4
                    cell.contentView.addSubview(lblLineNAV)
                    
                    
                    return cell;
                    
                case 7:
                    
                    btnSubmit = UIButton(frame: CGRect(x: cell.contentView.frame.size.width-80, y: 10, width: 70, height: 36))
                    btnSubmit.setTitle("Submit", forState: .Normal)
                    btnSubmit.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                    btnSubmit.backgroundColor = UIColor.defaultOrangeButton
                    btnSubmit.titleLabel?.font = UIFont.systemFontOfSize(14)
                    btnSubmit.layer.cornerRadius = 1.5
                    btnSubmit.addTarget(self, action: #selector(AddPortfolioManually.btnSubmitClicked(_:)), forControlEvents: .TouchUpInside)
                    cell.contentView.addSubview(btnSubmit)
                    btnSubmit.tag = 1
                    
                    btnsaveAddMore = UIButton(frame: CGRect(x: cell.contentView.frame.size.width-210, y: 10, width: 120, height: 36))
                    btnsaveAddMore.setTitle("Save & Add more", forState: .Normal)
                    btnsaveAddMore.setTitleColor(UIColor.defaultOrangeButton, forState: .Normal)
                    btnsaveAddMore.backgroundColor = UIColor.whiteColor()
                    btnsaveAddMore.titleLabel?.font = UIFont.systemFontOfSize(14)
                    btnsaveAddMore.layer.cornerRadius = 1.5
                    btnsaveAddMore.layer.borderColor = UIColor.defaultOrangeButton.CGColor
                    btnsaveAddMore.layer.borderWidth = 1.0
                    btnsaveAddMore.addTarget(self, action: #selector(AddPortfolioManually.btnSubmitClicked(_:)), forControlEvents: .TouchUpInside)
                    cell.contentView.addSubview(btnsaveAddMore)
                    btnsaveAddMore.tag = 2
                    
                    cell.selectionStyle = UITableViewCellSelectionStyle.None
                    cell.contentView.backgroundColor = UIColor.clearColor()
                    cell.backgroundColor = UIColor.clearColor()
                    
                    return cell;
                    
                default:
                    break;
                }
                
            }else{
                
                if indexPath.row==0
                {
                    
                    if btnRoundRadioSIP==nil
                    {
                    }
                    else
                    {
                        
                        
                        btnOneTimeRadioSIP.layer.borderColor = UIColor.lightGrayColor().CGColor
                        btnSIPRadioSIP.layer.borderColor = UIColor.defaultAppColorBlue.CGColor
                        btnRoundRadioSIP.removeFromSuperview()
                        
                        btnRoundRadioSIP = UIButton(frame: CGRect(x: 5, y: 5, width: 10, height: 10));
                        btnRoundRadioSIP.layer.cornerRadius = 5
                        btnRoundRadioSIP.layer.borderWidth = 2.0
                        btnRoundRadioSIP.backgroundColor = UIColor.defaultAppColorBlue
                        btnRoundRadioSIP.layer.borderColor = UIColor.defaultAppColorBlue.CGColor
                        btnSIPRadioSIP.addSubview(btnRoundRadioSIP)
                        
                    }
                }
                /*if indexPath.row == 1
                 {
                 
                 var lblUploadPan : UILabel!
                 //                    lblUploadPan = UILabel(frame: CGRect(x: 10, y: 5, width: (cell.contentView.frame.size.width)-20, height: 25));
                 lbltxtSchemeName.textColor = UIColor.blackColor()
                 if lblUploadPan == self.view.viewWithTag(102)
                 {
                 lblUploadPan.textColor = UIColor.lightGrayColor()
                 }
                 else
                 {
                 lblUploadPan = UILabel(frame: CGRect(x: 10, y: 5, width: (cell.contentView.frame.size.width)-20, height: 25));
                 lblUploadPan.textColor = UIColor.darkGrayColor()
                 lblUploadPan.font = UIFont.systemFontOfSize(12)
                 cell.contentView.addSubview(lblUploadPan)
                 lblUploadPan.text = "Scheme Name"
                 
                 }
                 }*/
                
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.contentView.backgroundColor = UIColor.clearColor()
            cell.backgroundColor = UIColor.clearColor()
            
            return cell;
            
        } // kBUY_FOR_SIP END
        
        
        
        let planName = "CELL_FIRST"
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: planName)
        let cell = tableView.dequeueReusableCellWithIdentifier(planName, forIndexPath: indexPath) as UITableViewCell
        cell.selectionStyle = .None
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.contentView.backgroundColor = UIColor.clearColor()
        cell.backgroundColor = UIColor.clearColor()
        return cell;
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if isBuyFrom==kBUY_FROM_FRESH { // kBUY_FROM_FRESH START
            
            if indexPath.row==0 {
                return 50
            }
            if indexPath.row==1 {
                return 90
            }
            if indexPath.row==2 {
                return 55
            }
            if indexPath.row==3 {
                return 55
            }
            if indexPath.row==4 {
                return 50
            }
            if indexPath.row==5 {
                return 45
            }
            if indexPath.row==6 {
                return 55
            }
            if indexPath.row==7 {
                return 50
            }
            return 60
            
        }
        
        if isBuyFrom==kBUY_FOR_SIP { // kBUY_FOR_SIP START
            
            if indexPath.row==0 {
                return 50
            }
            if indexPath.row==1 {
                return 90
            }
            if indexPath.row==2 {
                return 55
            }
            if indexPath.row==3 {
                return 65
            }
            if indexPath.row==4 {
                return 55
            }
            if indexPath.row==5 {
                return 45
            }
            if indexPath.row==6 {
                return 55
            }
            if indexPath.row==7 {
                return 50
            }
            return 60
        }
        
        
        return 55
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 140))
        view.backgroundColor = UIColor.defaultAppBackground
        
        imgHeader = UIImageView(frame: CGRect(x: (view.frame.size.width/2)-45, y: 10, width: 90, height: 90))
        imgHeader.layer.cornerRadius = 45
        let image = UIImage(named: "wealthtrust_portfolio")
        
        imgHeader.image = image
        imgHeader.backgroundColor = UIColor.defaultAppColorBlue
        view.addSubview(imgHeader)
        
        lblTitleHeader = UILabel(frame: CGRect(x: 10, y: 100, width: (view.frame.size.width)-20, height: 30));
        lblTitleHeader.textColor = UIColor.blackColor()
        lblTitleHeader.font = UIFont.systemFontOfSize(19)
        lblTitleHeader.textAlignment = .Center
        view.addSubview(lblTitleHeader)
        lblTitleHeader.text = "Add Portfolio"
        
        
        let label = UILabel(frame: CGRect(x: 0, y: view.frame.size.height-1, width: view.frame.size.width, height: 1))
        label.backgroundColor = UIColor.lightGrayColor()
        view.addSubview(label)
        label.alpha = 0.4
        
        return view
    }
    
    // UITextField Delegates
    func textFieldDidBeginEditing(textField: UITextField) {
        print("TextField did begin editing method called")
        txtCurrentTextField = textField
        pickerView.selectRow(0, inComponent: 0, animated: true)
        
    }
    func textFieldDidEndEditing(textField: UITextField) {
        
        
        
//        if txtCurrentTextField==self.txtNav ||  txtCurrentTextField==self.txtSchemeAmount{
//            
//            if txtSchemeAmount.text?.length==0
//            {
//                
//            }
//            else
//            {
//                if txtNav.text?.length==0
//                {
//                    
//                }
//                else
//                {
//                    
//                    let amount = Double(txtSchemeAmount.text!)
//                    let nav = Double(self.txtNav.text!)
//                    let units = amount!/nav!
//                    
//                    let twoDecimalPlaces = String(format: "%.2f", units)
//                    self.txtUnits.text = twoDecimalPlaces
//                    
//                }
//            }
//        }
        
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
    
    @IBAction func btnSubmitClicked(sender: AnyObject) {
        
        let btnSender = sender as! UIButton
        
        if isBuyFrom==kBUY_FROM_FRESH { // kBUY_FROM_FRESH START
            
            let objOrder : Order = Order()
            
            var schemeName = ""
            if let fromFundGet = sharedInstance.userDefaults.objectForKey(kSelectAddExistingScheme) as? NSDictionary
            {
                print(fromFundGet)
                schemeName = fromFundGet.objectForKey("Plan_Name") as! String
                
                objOrder.SrcSchemeName = schemeName
                objOrder.SrcSchemeCode = fromFundGet.objectForKey("Scheme_Code") as! String
                
                if let RtaAmcCode = fromFundGet.objectForKey("Fund_Code")
                {
                    objOrder.RtaAmcCode = RtaAmcCode as! String
                }
                
            }
            if let fromFundGet = sharedInstance.userDefaults.objectForKey(kSelectAddExistingScheme) as? String
            {
                print(fromFundGet)
                schemeName = fromFundGet
            }
            
            if schemeName==kEnterSchemeName {
                SharedManager.invokeAlertMethod(APP_NAME, strBody: "Please select Scheme name!", delegate: nil)
                return;
            }
            
            if txtSchemeAmount.text?.length==0 {
                SharedManager.invokeAlertMethod(APP_NAME, strBody: "Please enter amount!", delegate: nil)
                return;
            }
            
            objOrder.Volume = txtSchemeAmount.text
            
            if txtDOBFirstStep.text?.length==0 {
                SharedManager.invokeAlertMethod(APP_NAME, strBody: "Please select Purchase Date!", delegate: nil)
                return;
            }
            
            let dateFormatterDDMMMYYYY = NSDateFormatter()
            dateFormatterDDMMMYYYY.dateFormat = "dd-MMM-yy" // dd MMM yyyy
            
            let dateFormatterYYYYMMDD = NSDateFormatter()
            dateFormatterYYYYMMDD.dateFormat = "yyyy-MM-dd"
            
            let date = dateFormatterDDMMMYYYY.dateFromString(txtDOBFirstStep.text!)
            objOrder.UpdateTime = dateFormatterYYYYMMDD.stringFromDate(date!)
            
            
            if txtNav.text?.length==0 {
                SharedManager.invokeAlertMethod(APP_NAME, strBody: "Please enter NAV!", delegate: nil)
                return;
            }
            
            if txtUnits.text?.length==0 {
                SharedManager.invokeAlertMethod(APP_NAME, strBody: "Please enter Units!", delegate: nil)
                return;
            }
            if txtFolio.text?.length==0 {
                objOrder.FolioNo = ""
            }else{
                objOrder.FolioNo = txtFolio.text
            }
            
            print(objOrder.description)
            
            // ORDER START..........
            
            self.objOrderToAdd = objOrder
            
            
            objOrderToAdd.ClientID = sharedInstance.objLoginUser.ClientID
            
            if objOrderToAdd.ClientID==nil {
                let allUser = DBManager.getInstance().getAllUser()
                if allUser.count==0
                {
                    objOrderToAdd.ClientID = ""
                }else{
                    let objUser = allUser.objectAtIndex(0) as! User
                    sharedInstance.objLoginUser = objUser
                    objOrderToAdd.ClientID = sharedInstance.objLoginUser.ClientID
                }
            }
            print("ClientID ",objOrderToAdd.ClientID)
            
            if objOrderToAdd.FolioNo==nil {
                objOrderToAdd.FolioNo = ""
            }
            print("FolioNo ",objOrderToAdd.FolioNo)
            
            if objOrderToAdd.FolioCheckDigit==nil {
                var findFolickDigit = ""
                if objOrderToAdd.FolioNo=="" {
                    findFolickDigit = ""
                }else{
                    
                    let str = objOrderToAdd.FolioNo
                    let strSplit = str.characters.split("/")
                    
                    if let second = strSplit.last {
                        findFolickDigit = String(second)
                        
                        if objOrderToAdd.FolioNo==findFolickDigit {
                            findFolickDigit = ""
                        }
                    }
                }
                objOrderToAdd.FolioCheckDigit = findFolickDigit
            }
            print("FolioCheckDigit ",objOrderToAdd.FolioCheckDigit)
            
            
            if objOrderToAdd.RtaAmcCode==nil {
                objOrderToAdd.RtaAmcCode = "K"
            }
            print("RtaAmcCode ",objOrderToAdd.RtaAmcCode)
            
            if objOrderToAdd.SrcSchemeCode==nil {
                objOrderToAdd.SrcSchemeCode = ""
            }
            print("SrcSchemeCode ",objOrderToAdd.SrcSchemeCode)
            
            if objOrderToAdd.SrcSchemeName==nil {
                objOrderToAdd.SrcSchemeName = ""
            }
            print("SrcSchemeName ",objOrderToAdd.SrcSchemeName)
            
            if objOrderToAdd.TarSchemeCode==nil {
                objOrderToAdd.TarSchemeCode = ""
            }
            
            if objOrderToAdd.DividendOption==nil {
                objOrderToAdd.DividendOption = "Z" // Not Applicable...
            }
            print("DividendOption ",objOrderToAdd.DividendOption)
            
            
            if objOrderToAdd.VolumeType==nil {
                objOrderToAdd.VolumeType = "A" // All Units...
            }
            print("VolumeType ",objOrderToAdd.VolumeType)
            
            if objOrderToAdd.Volume==nil {
                objOrderToAdd.Volume = "" // Nothing....
            }
            if objOrderToAdd.Volume=="" {
                objOrderToAdd.Volume = "" // Nothing....
            }
            print("Volume ",objOrderToAdd.Volume)
            
            if objOrderToAdd.OrderType==nil {
                objOrderToAdd.OrderType = "\(OrderType.Buy.hashValue)" //
            }
            print("OrderType ",objOrderToAdd.OrderType)
            
            if objOrderToAdd.OrderStatus==nil {
                objOrderToAdd.OrderStatus = "0" // Processing...
            }
            print("OrderStatus ",objOrderToAdd.OrderStatus)
            
            if objOrderToAdd.CartFlag==nil {
                objOrderToAdd.CartFlag = "0" // NotInCart
            }
            print("CartFlag ",objOrderToAdd.CartFlag)
            
            if objOrderToAdd.UpdateTime==nil {
                
                
                let date = NSDate()
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateStyle = .MediumStyle
                let string = dateFormatter.stringFromDate(date)
                objOrderToAdd.UpdateTime = string
            }
            
            
            //            let isInserted = DBManager.getInstance().addOrder(objOrderToAdd)
            //            if isInserted {
            //                print("Order Added Successfully....")
            //            } else {
            //              //            SharedManager.invokeAlertMethod("", strBody: "Error in saving record.", delegate: nil)
            //            }
            //
            //            // Successfully Data Saved in local........... NOW CALL APIs....
            //
            //
            //            // Fetch App Order ID ....MARK: COMMENT
            //            let lastOrder = DBManager.getInstance().getLatestOrder()
            //            if lastOrder.count==0
            //            {
            //            }else{
            //                let objOrderToAdd = lastOrder.objectAtIndex(0) as! Order
            //                self.objOrderToAdd.AppOrderID = objOrderToAdd.AppOrderID
            //            }
            //            print("NEW APP ORDER ID GENERATED \(self.objOrderToAdd.AppOrderID)")
            
            
            self.objOrderToAdd.RtaAmcCode = self.objOrderToAdd.RtaAmcCode.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            self.objOrderToAdd.SrcSchemeCode = self.objOrderToAdd.SrcSchemeCode.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            self.objOrderToAdd.TarSchemeCode = self.objOrderToAdd.TarSchemeCode.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            
            
            let dic = NSMutableDictionary()
            dic["ClientId"] = self.objOrderToAdd.ClientID
            //            dic["OrderType"] = "\(OrderType.Buy.hashValue)"
            
            let arrDic : NSMutableArray = []
            
            
            
            arrDic.addObject(["folioAccNo" : self.objOrderToAdd.FolioNo,
                "folioCheckDigit" : self.objOrderToAdd.FolioCheckDigit,
                "rtaAmcCode" : String(self.objOrderToAdd.RtaAmcCode),
                "srcSchemeCode" : self.objOrderToAdd.SrcSchemeCode,
                "dividendOption" : "\(self.objOrderToAdd.DividendOption) ",
                "txnVolumeType" : "A",
                "txnVolume" : self.objOrderToAdd.Volume,
                "OrderType" : "\(OrderType.Buy.hashValue)",
                "srcSchemeName" : self.objOrderToAdd.SrcSchemeName,
                "ExecutaionDateTime" : self.objOrderToAdd.UpdateTime, //"2016-10-15"
                "AccId" : "",
                "day" : "",
                "start_Month" : "",
                "start_Year" : "",
                "puchaseNAV" : self.txtNav.text!,
                "pucharseUnits" : self.txtUnits.text!,
                "frequency" : "",
                "NoOfInstallments" : ""]) // self.objOrderToAdd.UpdateTime
            
            dic["SchemeArr"] = arrDic
            
            WebManagerHK.postDataToURL(kModeAddManuallyPortfolio, params: dic, message: "Please Wait...") { (response) in
                print("Dic Response For Order: \(response)")
                
                if response.objectForKey(kWAPIResponse) is NSArray
                {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        let mainResponse = response.objectForKey(kWAPIResponse) as! NSArray
                        
                        if mainResponse.count==0
                        {
                            
                        }else{
                            
                            for dic in mainResponse
                            {
                                
                                let mfAccountAllDetails = dic as! NSDictionary
                                
                                //MF Account Details
                                let clientUserDetails = mfAccountAllDetails.valueForKey("mfaccount") as! NSDictionary
                                
                                ////         UPDATE MFManualACCOUNT..
                                let mfInfo: MFAccount = MFAccount()
                                
                                if let theTitle = clientUserDetails.objectForKey("AccId") {
                                    mfInfo.AccId = String(theTitle)
                                }
                                if let theTitle = clientUserDetails.objectForKey("ClientId") {
                                    mfInfo.clientid = String(theTitle)
                                }
                                if let theTitle = clientUserDetails.objectForKey("FolioNo") {
                                    mfInfo.FolioNo = String(theTitle)
                                }
                                if let theTitle = clientUserDetails.objectForKey("rtaAmcCode") {
                                    mfInfo.RTAamcCode = String(theTitle)
                                }
                                if let theTitle = clientUserDetails.objectForKey("AMCName") {
                                    mfInfo.AmcName = String(theTitle)
                                }
                                if let theTitle = clientUserDetails.objectForKey("srcSchemeCode") {
                                    mfInfo.SchemeCode = String(theTitle)
                                }
                                if let theTitle = clientUserDetails.objectForKey("srcSchemeName") {
                                    mfInfo.SchemeName = String(theTitle)
                                }
                                if let theTitle = clientUserDetails.objectForKey("Div_Option") {
                                    mfInfo.DivOption = String(theTitle)
                                }
                                if let theTitle = clientUserDetails.objectForKey("pucharseUnits") {
                                    mfInfo.pucharseUnits = String(theTitle)
                                }
                                if let theTitle = clientUserDetails.objectForKey("puchaseNAV") {
                                    mfInfo.puchaseNAV = String(theTitle)
                                }
                                if let theTitle = clientUserDetails.objectForKey("InvestmentAmount") {
                                    mfInfo.InvestmentAmount = String(theTitle)
                                }
                                if let theTitle = clientUserDetails.objectForKey("currentNAV") {
                                    mfInfo.CurrentNAV = String(theTitle)
                                }
                                if let theTitle = clientUserDetails.objectForKey("lastUpdated") {
                                    mfInfo.NAVDate = String(theTitle)
                                }
                                if let theTitle = clientUserDetails.objectForKey("IsDeleted") {
                                    mfInfo.isDeleted = String(theTitle)
                                }
                                
                                // ADD OR UPDATE..
                                if DBManager.getInstance().checkManualMFAccountAlreadyExist(mfInfo)
                                {
                                    
                                    let isUpdated = DBManager.getInstance().updateManualMFAccount(mfInfo)
                                    if isUpdated {
                                        print("MF ACCOUNT DETAILS SYNCHED/UPDATED SUCCESSFULLY!!!!")
                                    } else {
                                        print("ERROR : MF ACCOUNT DETAILS SYNCHED ERROR!!!!")
                                    }
                                    
                                }else{
                                    
                                    let isAdded = DBManager.getInstance().addManualMFAccount(mfInfo)
                                    if isAdded {
                                        print("MF ACCOUNT DETAILS SYNCHED/ADDED SUCCESSFULLY!!!!")
                                    } else {
                                        print("ERROR : MF ACCOUNT DETAILS SYNCHED ERROR!!!!")
                                    }
                                }
                                
                                //MF Transaction Details
                                let mfTransactions = mfAccountAllDetails.valueForKey("mftransaction") as! NSArray
                                print(mfTransactions)
                                
                                for dic in mfTransactions
                                {
                                    let clientUserDetails = dic as! NSDictionary
                                    
                                    ////         UPDATE MFTRANSACTIONS..
                                    let mfInfo: MFTransaction = MFTransaction()
                                    
                                    if let theTitle = clientUserDetails.objectForKey("TxnId") {
                                        mfInfo.TxnID = String(theTitle)
                                    }
                                    if let theTitle = clientUserDetails.objectForKey("AccId") {
                                        mfInfo.AccID = String(theTitle)
                                    }
                                    if let theTitle = clientUserDetails.objectForKey("OrderId") {
                                        mfInfo.OrderId = String(theTitle)
                                    }
                                    if let theTitle = clientUserDetails.objectForKey("CreatedDateTime") {
                                        mfInfo.TxnOrderDateTime = String(theTitle)
                                    }
                                    if let theTitle = clientUserDetails.objectForKey("TxtType") {
                                        mfInfo.TxtType = String(theTitle)
                                    }
                                    if let theTitle = clientUserDetails.objectForKey("TxnpucharseUnits") {
                                        mfInfo.TxnpucharseUnits = String(theTitle)
                                    }
                                    if let theTitle = clientUserDetails.objectForKey("TxnpuchaseNAV") {
                                        mfInfo.TxnpuchaseNAV = String(theTitle)
                                    }
                                    if let theTitle = clientUserDetails.objectForKey("TxnPurchaseAmount") {
                                        mfInfo.TxnPurchaseAmount = String(theTitle)
                                    }
                                    if let theTitle = clientUserDetails.objectForKey("ExecutaionDateTime") {
                                        mfInfo.ExecutaionDateTime = String(theTitle)
                                    }
                                    if let theTitle = clientUserDetails.objectForKey("IsDeleted") {
                                        mfInfo.isDeleted = String(theTitle)
                                    }
                                    
                                    // ADD OR UPDATE..
                                    if DBManager.getInstance().checkManualMFTransactionAlreadyExist(mfInfo)
                                    {
                                        let isUpdated = DBManager.getInstance().updateManualMFTransaction(mfInfo)
                                        if isUpdated {
                                            print("MF ACCOUNT TRANSACTIONS SYNCHED/UPDATED SUCCESSFULLY!!!!")
                                        } else {
                                            print("ERROR : MF ACCOUNT TRANSACTIONS SYNCHED ERROR!!!!")
                                        }
                                        
                                    }else{
                                        
                                        let isAdded = DBManager.getInstance().addManualMFTransaction(mfInfo)
                                        if isAdded {
                                            print("MF ACCOUNT TRANSACTIONS SYNCHED/ADDED SUCCESSFULLY!!!!")
                                        } else {
                                            print("ERROR : MF ACCOUNT TRANSACTIONS SYNCHED ERROR!!!!")
                                        }
                                        
                                    }
                                    
                                }
                            }
                        }
                        
                        if btnSender.tag==2
                        {
                            
                            sharedInstance.userDefaults .setObject(kEnterSchemeName, forKey: kSelectAddExistingScheme)
                            
                            if let BuyNowScheme = sharedInstance.userDefaults.objectForKey(kSelectAddExistingScheme) as? String
                            {
                                if self.lbltxtSchemeName != nil {
                                    
                                    self.lbltxtSchemeName.text = BuyNowScheme
                                    self.lbltxtSchemeName.textColor = UIColor(red:0.78, green:0.78, blue:0.78, alpha:1.0)
                                    var lblUploadPan : UILabel!
                                    
                                    if lblUploadPan == self.view.viewWithTag(101)
                                    {
                                        lblUploadPan.text = ""
                                    }
                                }
                            }
                            
                            if let lblUploadPan = self.view.viewWithTag(101) as? UILabel {
                                lblUploadPan.text = ""
                            }
                            
                            self.txtSchemeAmount.text = ""
                            self.txtDOBFirstStep.text = ""
                            self.txtNav.text = ""
                            self.txtUnits.text = ""
                            self.txtFolio.text = ""
                            
                            SharedManager.invokeAlertMethod(APP_NAME, strBody: "Scheme added to your portfolio", delegate: nil)
                            
                        }else{
                            
//                            self.navigationController?.popViewControllerAnimated(true)
                            let portfolioScreen = self.storyboard?.instantiateViewControllerWithIdentifier("PortfolioScreen") as? PortfolioScreen
                            portfolioScreen?.isFrom = "AddManuallyPortfolio"
                            self.navigationController?.pushViewController(portfolioScreen!, animated:true)
                            
                        }
                    })
                    
                }
            }
            
            // ORDER END
        }
        
        
        
        if isBuyFrom==kBUY_FOR_SIP { // kBUY_FOR_SIP START
            print("SIP Clicked...")
            
            
            
            
            var objOrder : Order = Order()
            
            var schemeName = ""
            if let fromFundGet = sharedInstance.userDefaults.objectForKey(kSelectAddExistingScheme) as? NSDictionary
            {
                print(fromFundGet)
                schemeName = fromFundGet.objectForKey("Plan_Name") as! String
                
                objOrder.SrcSchemeName = schemeName
                objOrder.SrcSchemeCode = fromFundGet.objectForKey("Scheme_Code") as! String
                
                if let RtaAmcCode = fromFundGet.objectForKey("Fund_Code")
                {
                    objOrder.RtaAmcCode = RtaAmcCode as! String
                }
            }
            if let fromFundGet = sharedInstance.userDefaults.objectForKey(kSelectAddExistingScheme) as? String
            {
                print(fromFundGet)
                schemeName = fromFundGet
            }
            
            if schemeName==kEnterSchemeName {
                SharedManager.invokeAlertMethod(APP_NAME, strBody: "Please select Scheme name!", delegate: nil)
                return;
            }
            
            if txtSchemeAmountSIP.text?.length==0 {
                SharedManager.invokeAlertMethod(APP_NAME, strBody: "Please enter SIP amount!", delegate: nil)
                return;
            }
            
            objOrder.Volume = txtSchemeAmountSIP.text
            
            
            if txtFrequency.text?.length==0 || txtFrequency.text=="SELECT" {
                SharedManager.invokeAlertMethod(APP_NAME, strBody: "Please select Frequency!", delegate: nil)
                return;
            }
            let frequencyToSend = sharedInstance.getFrequencyFromFullName(txtFrequency.text!)
            
            
            if txtDOBFirstStepSIP.text?.length==0 {
                SharedManager.invokeAlertMethod(APP_NAME, strBody: "Please select SIP start Date!", delegate: nil)
                return;
            }
            objOrder.UpdateTime = txtDOBFirstStepSIP.text
            
            
            if txtNoOfInstallments.text?.length==0 {
                SharedManager.invokeAlertMethod(APP_NAME, strBody: "Please enter No. of installments!", delegate: nil)
                return;
            }
            
            if txtFolioSIP.text?.length==0 {
                objOrder.FolioNo = ""
            }else{
                objOrder.FolioNo = txtFolioSIP.text
            }
            
            
            print(objOrder.description)
            
            // ORDER START..........
            
            self.objOrderToAdd = objOrder
            
            print("Order Details ")
            if objOrderToAdd.AppOrderID==nil {
                objOrderToAdd.AppOrderID = ""
            }
            print("AppOrderID ",objOrderToAdd.AppOrderID)
            if objOrderToAdd.ServerOrderID==nil {
                objOrderToAdd.ServerOrderID = ""
            }
            print("ServerOrderID ",objOrderToAdd.ServerOrderID)
            
            objOrderToAdd.ClientID = sharedInstance.objLoginUser.ClientID
            
            if objOrderToAdd.ClientID==nil {
                let allUser = DBManager.getInstance().getAllUser()
                if allUser.count==0
                {
                    objOrderToAdd.ClientID = ""
                }else{
                    let objUser = allUser.objectAtIndex(0) as! User
                    sharedInstance.objLoginUser = objUser
                    objOrderToAdd.ClientID = sharedInstance.objLoginUser.ClientID
                }
            }
            print("ClientID ",objOrderToAdd.ClientID)
            
            if objOrderToAdd.FolioNo==nil {
                objOrderToAdd.FolioNo = ""
            }
            print("FolioNo ",objOrderToAdd.FolioNo)
            
            if objOrderToAdd.FolioCheckDigit==nil {
                var findFolickDigit = ""
                if objOrderToAdd.FolioNo=="" {
                    findFolickDigit = ""
                }else{
                    
                    let str = objOrderToAdd.FolioNo
                    let strSplit = str.characters.split("/")
                    
                    if let second = strSplit.last {
                        findFolickDigit = String(second)
                        
                        if objOrderToAdd.FolioNo==findFolickDigit {
                            findFolickDigit = ""
                        }
                    }
                }
                objOrderToAdd.FolioCheckDigit = findFolickDigit
            }
            print("FolioCheckDigit ",objOrderToAdd.FolioCheckDigit)
            
            
            if objOrderToAdd.RtaAmcCode==nil {
                objOrderToAdd.RtaAmcCode = "P"
            }
            print("RtaAmcCode ",objOrderToAdd.RtaAmcCode)
            
            if objOrderToAdd.SrcSchemeCode==nil {
                objOrderToAdd.SrcSchemeCode = ""
            }
            print("SrcSchemeCode ",objOrderToAdd.SrcSchemeCode)
            
            if objOrderToAdd.SrcSchemeName==nil {
                objOrderToAdd.SrcSchemeName = ""
            }
            print("SrcSchemeName ",objOrderToAdd.SrcSchemeName)
            
            if objOrderToAdd.TarSchemeCode==nil {
                objOrderToAdd.TarSchemeCode = ""
            }
            print("TarSchemeCode ",objOrderToAdd.TarSchemeCode)
            
            if objOrderToAdd.TarSchemeName==nil {
                objOrderToAdd.TarSchemeName = ""
            }
            print("TarSchemeName ",objOrderToAdd.TarSchemeName)
            
            if objOrderToAdd.DividendOption==nil {
                objOrderToAdd.DividendOption = "Z" // Not Applicable...
            }
            print("DividendOption ",objOrderToAdd.DividendOption)
            
            
            if objOrderToAdd.VolumeType==nil {
                objOrderToAdd.VolumeType = "A" // All Units...
            }
            print("VolumeType ",objOrderToAdd.VolumeType)
            
            if objOrderToAdd.Volume==nil {
                objOrderToAdd.Volume = "" // Nothing....
            }
            if objOrderToAdd.Volume=="" {
                objOrderToAdd.Volume = "" // Nothing....
            }
            print("Volume ",objOrderToAdd.Volume)
            
            
            if objOrderToAdd.OrderType==nil {
                objOrderToAdd.OrderType = "\(OrderType.BuyPlusSIP.hashValue)" //
            }
            print("OrderType ",objOrderToAdd.OrderType)
            
            if objOrderToAdd.OrderStatus==nil {
                objOrderToAdd.OrderStatus = "0" // Processing...
            }
            print("OrderStatus ",objOrderToAdd.OrderStatus)
            
            if objOrderToAdd.CartFlag==nil {
                objOrderToAdd.CartFlag = "0" // NotInCart
            }
            print("CartFlag ",objOrderToAdd.CartFlag)
            
            if objOrderToAdd.UpdateTime==nil {
                let date = NSDate()
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateStyle = .MediumStyle
                let string = dateFormatter.stringFromDate(date)
                objOrderToAdd.UpdateTime = string
            }
            
            self.objOrderToAdd.RtaAmcCode = self.objOrderToAdd.RtaAmcCode.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            self.objOrderToAdd.SrcSchemeCode = self.objOrderToAdd.SrcSchemeCode.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            
            let dateFormatterDDMMMYYYY = NSDateFormatter()
            dateFormatterDDMMMYYYY.dateFormat = "dd-MMM-yy" // dd MMM yyyy
            
            let date = dateFormatterDDMMMYYYY.dateFromString(self.objOrderToAdd.UpdateTime)
            let cal = NSCalendar.currentCalendar()
            let year = cal.component(.Year, fromDate: date!)
            let month = cal.component(.Month, fromDate: date!)
            let day = cal.component(.Day, fromDate: date!)
            
            let dic = NSMutableDictionary()
            dic["ClientId"] = self.objOrderToAdd.ClientID
            //            dic["OrderType"] = "\(OrderType.Buy.hashValue)"
            
            let arrDic : NSMutableArray = []
            
            arrDic.addObject(["folioAccNo" : self.objOrderToAdd.FolioNo,
                "folioCheckDigit" : self.objOrderToAdd.FolioCheckDigit,
                "rtaAmcCode" : String(self.objOrderToAdd.RtaAmcCode),
                "srcSchemeCode" : self.objOrderToAdd.SrcSchemeCode,
                "dividendOption" : "\(self.objOrderToAdd.DividendOption) ",
                "txnVolumeType" : "A",
                "txnVolume" : self.objOrderToAdd.Volume,
                "OrderType" : "\(OrderType.BuyPlusSIP.hashValue)",
                "srcSchemeName" : self.objOrderToAdd.SrcSchemeName,
                "ExecutaionDateTime" : "2016-10-15",
                "AccId" : "",
                "day" : "\(day)",
                "start_Month" : "\(month)",
                "start_Year" : "\(year)",
                "puchaseNAV" : "0",
                "pucharseUnits" : "0",
                "frequency" : frequencyToSend,
                "NoOfInstallments" : txtNoOfInstallments.text!]) // self.objOrderToAdd.UpdateTime
            
            dic["SchemeArr"] = arrDic
            
            WebManagerHK.postDataToURL(kModeAddManuallyPortfolio, params: dic, message: "Please Wait...") { (response) in
                print("Dic Response For Order: \(response)")
                
                if response.objectForKey(kWAPIResponse) is NSArray
                {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        let mainResponse = response.objectForKey(kWAPIResponse) as! NSArray
                        
                        if mainResponse.count==0
                        {
                            
                        }else{
                            
                            for dic in mainResponse
                            {
                                
                                let mfAccountAllDetails = dic as! NSDictionary
                                
                                //MF Account Details
                                let clientUserDetails = mfAccountAllDetails.valueForKey("mfaccount") as! NSDictionary
                                
                                ////         UPDATE MFManualACCOUNT..
                                let mfInfo: MFAccount = MFAccount()
                                
                                if let theTitle = clientUserDetails.objectForKey("AccId") {
                                    mfInfo.AccId = String(theTitle)
                                }
                                if let theTitle = clientUserDetails.objectForKey("ClientId") {
                                    mfInfo.clientid = String(theTitle)
                                }
                                if let theTitle = clientUserDetails.objectForKey("FolioNo") {
                                    mfInfo.FolioNo = String(theTitle)
                                }
                                if let theTitle = clientUserDetails.objectForKey("rtaAmcCode") {
                                    mfInfo.RTAamcCode = String(theTitle)
                                }
                                if let theTitle = clientUserDetails.objectForKey("AMCName") {
                                    mfInfo.AmcName = String(theTitle)
                                }
                                if let theTitle = clientUserDetails.objectForKey("srcSchemeCode") {
                                    mfInfo.SchemeCode = String(theTitle)
                                }
                                if let theTitle = clientUserDetails.objectForKey("srcSchemeName") {
                                    mfInfo.SchemeName = String(theTitle)
                                }
                                if let theTitle = clientUserDetails.objectForKey("Div_Option") {
                                    mfInfo.DivOption = String(theTitle)
                                }
                                if let theTitle = clientUserDetails.objectForKey("pucharseUnits") {
                                    mfInfo.pucharseUnits = String(theTitle)
                                }
                                if let theTitle = clientUserDetails.objectForKey("puchaseNAV") {
                                    mfInfo.puchaseNAV = String(theTitle)
                                }
                                if let theTitle = clientUserDetails.objectForKey("InvestmentAmount") {
                                    mfInfo.InvestmentAmount = String(theTitle)
                                }
                                if let theTitle = clientUserDetails.objectForKey("currentNAV") {
                                    mfInfo.CurrentNAV = String(theTitle)
                                }
                                if let theTitle = clientUserDetails.objectForKey("lastUpdated") {
                                    mfInfo.NAVDate = String(theTitle)
                                }
                                if let theTitle = clientUserDetails.objectForKey("IsDeleted") {
                                    mfInfo.isDeleted = String(theTitle)
                                }
                                
                                // ADD OR UPDATE..
                                if DBManager.getInstance().checkManualMFAccountAlreadyExist(mfInfo)
                                {
                                    
                                    let isUpdated = DBManager.getInstance().updateManualMFAccount(mfInfo)
                                    if isUpdated {
                                        print("MF ACCOUNT DETAILS SYNCHED/UPDATED SUCCESSFULLY!!!!")
                                    } else {
                                        print("ERROR : MF ACCOUNT DETAILS SYNCHED ERROR!!!!")
                                    }
                                    
                                }else{
                                    
                                    let isAdded = DBManager.getInstance().addManualMFAccount(mfInfo)
                                    if isAdded {
                                        print("MF ACCOUNT DETAILS SYNCHED/ADDED SUCCESSFULLY!!!!")
                                    } else {
                                        print("ERROR : MF ACCOUNT DETAILS SYNCHED ERROR!!!!")
                                    }
                                }
                                
                                //MF Transaction Details
                                let mfTransactions = mfAccountAllDetails.valueForKey("mftransaction") as! NSArray
                                print(mfTransactions)
                                
                                for dic in mfTransactions
                                {
                                    let clientUserDetails = dic as! NSDictionary
                                    
                                    ////         UPDATE MFTRANSACTIONS..
                                    let mfInfo: MFTransaction = MFTransaction()
                                    
                                    if let theTitle = clientUserDetails.objectForKey("TxnId") {
                                        mfInfo.TxnID = String(theTitle)
                                    }
                                    if let theTitle = clientUserDetails.objectForKey("AccId") {
                                        mfInfo.AccID = String(theTitle)
                                    }
                                    if let theTitle = clientUserDetails.objectForKey("OrderId") {
                                        mfInfo.OrderId = String(theTitle)
                                    }
                                    if let theTitle = clientUserDetails.objectForKey("CreatedDateTime") {
                                        mfInfo.TxnOrderDateTime = String(theTitle)
                                    }
                                    if let theTitle = clientUserDetails.objectForKey("TxtType") {
                                        mfInfo.TxtType = String(theTitle)
                                    }
                                    if let theTitle = clientUserDetails.objectForKey("TxnpucharseUnits") {
                                        mfInfo.TxnpucharseUnits = String(theTitle)
                                    }
                                    if let theTitle = clientUserDetails.objectForKey("TxnpuchaseNAV") {
                                        mfInfo.TxnpuchaseNAV = String(theTitle)
                                    }
                                    if let theTitle = clientUserDetails.objectForKey("TxnPurchaseAmount") {
                                        mfInfo.TxnPurchaseAmount = String(theTitle)
                                    }
                                    if let theTitle = clientUserDetails.objectForKey("ExecutaionDateTime") {
                                        mfInfo.ExecutaionDateTime = String(theTitle)
                                    }
                                    if let theTitle = clientUserDetails.objectForKey("IsDeleted") {
                                        mfInfo.isDeleted = String(theTitle)
                                    }
                                    
                                    // ADD OR UPDATE..
                                    if DBManager.getInstance().checkManualMFTransactionAlreadyExist(mfInfo)
                                    {
                                        let isUpdated = DBManager.getInstance().updateManualMFTransaction(mfInfo)
                                        if isUpdated {
                                            print("MF ACCOUNT TRANSACTIONS SYNCHED/UPDATED SUCCESSFULLY!!!!")
                                        } else {
                                            print("ERROR : MF ACCOUNT TRANSACTIONS SYNCHED ERROR!!!!")
                                        }
                                        
                                    }else{
                                        
                                        let isAdded = DBManager.getInstance().addManualMFTransaction(mfInfo)
                                        if isAdded {
                                            print("MF ACCOUNT TRANSACTIONS SYNCHED/ADDED SUCCESSFULLY!!!!")
                                        } else {
                                            print("ERROR : MF ACCOUNT TRANSACTIONS SYNCHED ERROR!!!!")
                                        }
                                        
                                    }
                                    
                                }
                            }
                        }
                    })
                    
                }
                else
                {
                    let retVal = response.objectForKey(kWAPIResponse) as! String
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        if (retVal == "-1"
                            || retVal == "-2") {
                            let tittle = ""
                            let msg = "Please try after sometime."
                            SharedManager.invokeAlertMethod(tittle, strBody: msg, delegate: nil)
                        }
                        else if (retVal == "-3") {
                            let tittle = "NAV Data Missing"
                            let msg = "Sorry, historical NAV for this scheme is not available with us.\n\nYou can track this SIP order as One-time  by entering total SIP amount, avearge NAV and units in Portfolio."
                            
                            SharedManager.invokeAlertMethod(tittle, strBody: msg, delegate: nil)
                            
                        }
                        else if (retVal == "-4") {
                            let tittle = ""
                            let msg = "First SIP transaction will be updated in your portfolio once NAV is available for selected SIP start date."
                            SharedManager.invokeAlertMethod(tittle, strBody: msg, delegate: nil)
                        }
                    })
                }
            }
            
            //BUY SIP END.....
        }
        
    }
    
    
    @IBAction func btnBuySchemeNameClicked(sender: AnyObject) {
        print("Scheme Clicked")
        
        let objSelectFromFund = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdSelectSearchFund) as! SelectSearchFund
        objSelectFromFund.selectFor = "OneTimeAddPort"
        self.presentViewController(objSelectFromFund, animated: true, completion: nil)
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if txtCurrentTextField.tag == TAG_FREQUENCY {
            return arrFrequency.count
        }
        return 0
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if txtCurrentTextField.tag == TAG_FREQUENCY {
            return sharedInstance.getFullNameFromFrequency(arrFrequency.objectAtIndex(row) as! String)
        }
        return "DefaulyValue"
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if txtCurrentTextField.tag == TAG_FREQUENCY {
            
            print(sharedInstance.getFullNameFromFrequency((arrFrequency.objectAtIndex(row) as? String)!))
            
            txtCurrentTextField.text = sharedInstance.getFullNameFromFrequency((arrFrequency.objectAtIndex(row) as? String)!)
            enumFrequencySelectedIndex = row
            txtCurrentTextField.resignFirstResponder()
            
            tblView.reloadData()
        }
        
    }
    
    
    @IBAction func btnOneTimeClicked(sender: AnyObject) {
        
        isBuyFrom = kBUY_FROM_FRESH
        
        btnOneTimeRadio.layer.borderColor = UIColor.defaultAppColorBlue.CGColor
        btnSIPRadio.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        lblTitle.text = "Buy"
        lblTitleHeader.text = "Buy Now"
        
        btnRoundRadio.removeFromSuperview()
        btnRoundRadio = UIButton(frame: CGRect(x: 5, y: 5, width: 10, height: 10));
        btnRoundRadio.layer.cornerRadius = 5
        btnRoundRadio.layer.borderWidth = 2.0
        btnRoundRadio.backgroundColor = UIColor.defaultAppColorBlue
        btnRoundRadio.layer.borderColor = UIColor.defaultAppColorBlue.CGColor
        btnOneTimeRadio.addSubview(btnRoundRadio)
        
        if let BuyNowScheme = sharedInstance.userDefaults.objectForKey(kSelectAddExistingScheme) as? NSDictionary
        {
            print(BuyNowScheme)
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                if let nav = BuyNowScheme.valueForKey("NAV")
                {
                    if let nav_date = BuyNowScheme.valueForKey("NAVDate")
                    {
                        
                        let twoDecimalPlaces = String(format: "%.2f", nav as! Double)
                        
                        self.txtNav.text = "\(twoDecimalPlaces) As On \(nav_date.substringWithRange(NSRange(location: 0, length: 10)))"
                        if (self.txtNavSIP != nil)
                        {
                            self.txtNavSIP.text = "\(twoDecimalPlaces) As On \(nav_date.substringWithRange(NSRange(location: 0, length: 10)))"
                        }
                    }
                }
                
                if (self.lbltxtSchemeName != nil) {
                    self.lbltxtSchemeName.text = BuyNowScheme.valueForKey("Plan_Name") as? String
                }
                if (self.lbltxtSchemeNameSIP != nil) {
                    self.lbltxtSchemeNameSIP.text = BuyNowScheme.valueForKey("Plan_Name") as? String
                }
            })
        }
        
        tblView.reloadData()
    }
    
    @IBAction func btnSIPClicked(sender: AnyObject) {
        
        isBuyFrom = kBUY_FOR_SIP
        
        if btnOneTimeRadioSIP==nil
        {
            lblTitle.text = "SIP"
            lblTitleHeader.text = "SIP Now"
        }
        else{
            
            btnOneTimeRadioSIP.layer.borderColor = UIColor.lightGrayColor().CGColor
            btnSIPRadioSIP.layer.borderColor = UIColor.defaultAppColorBlue.CGColor
            
            lblTitle.text = "SIP"
            lblTitleHeader.text = "SIP Now"
            
            btnRoundRadioSIP.removeFromSuperview()
            btnRoundRadioSIP = UIButton(frame: CGRect(x: 5, y: 5, width: 10, height: 10));
            btnRoundRadioSIP.layer.cornerRadius = 5
            btnRoundRadioSIP.layer.borderWidth = 2.0
            btnRoundRadioSIP.backgroundColor = UIColor.defaultAppColorBlue
            btnRoundRadioSIP.layer.borderColor = UIColor.defaultAppColorBlue.CGColor
            btnSIPRadioSIP.addSubview(btnRoundRadioSIP)
            
            
            
            if let BuyNowScheme = sharedInstance.userDefaults.objectForKey(kSelectAddExistingScheme) as? NSDictionary
            {
                print(BuyNowScheme)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    
                    if let nav = BuyNowScheme.valueForKey("NAV")
                    {
                        if let nav_date = BuyNowScheme.valueForKey("NAVDate")
                        {
                            let twoDecimalPlaces = String(format: "%.2f", nav as! Double)
                            
                            self.txtNav.text = "\(twoDecimalPlaces) As On \(nav_date.substringWithRange(NSRange(location: 0, length: 10)))"
                            if (self.txtNavSIP != nil)
                            {
                                self.txtNavSIP.text = "\(twoDecimalPlaces) As On \(nav_date.substringWithRange(NSRange(location: 0, length: 10)))"
                            }
                        }
                    }
                    
                    if (self.lbltxtSchemeName != nil) {
                        self.lbltxtSchemeName.text = BuyNowScheme.valueForKey("Plan_Name") as? String
                    }
                    if (self.lbltxtSchemeNameSIP != nil) {
                        self.lbltxtSchemeNameSIP.text = BuyNowScheme.valueForKey("Plan_Name") as? String
                    }
                })
            }
        }
        
        
        tblView.reloadData()
    }
    
}
