//
//  SwitchScreen.swift
//  WealthTrust
//
//  Created by Hemen Gohil on 9/22/16.
//  Copyright © 2016 Hemen Gohil. All rights reserved.
//

import UIKit

let TAG_DIVIDEND_OPTION_SWTCH = 103

class SwitchScreen: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate {

    @IBOutlet weak var tblView: UITableView!

    var txtCurrentTextField : UITextField!

    var lblUploadPan = UILabel()
    var btnSwitchFromFund : UIButton!
    var btnSwitchToFund : UIButton!
    var lblSwitchFromFund : UILabel!
    var lblSwitchToFund : UILabel!

    var txtFolioNumber : RPFloatingPlaceholderTextField!
    var txtNAV : UITextField!
    var txtSwitchBy : UITextField!
    var currentSelectedSwitchBy = "All Units"
    var txtSwitchByValue : UITextField!
    var lblSwitchByValue : UILabel!
    var lblUnderLine : UILabel!

    var isNavAvailable = false
    var isDivAvailable = false
    var randomVal = sharedInstance.getRandomVal()

    var pickerView = UIPickerView()
    
    var txtDividendOption : UITextField!
    var lblDividendOption : UILabel!
    var enumDividendOption = DividendOptionBUY.Payout

    
    var isFrom = IS_FROM.Transaction

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        pickerView.delegate = self

        // Do any additional setup after loading the view, typically from a nib.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIKeyboardDidHideNotification, object: nil)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(BuyScreeen.handleSingleTap(_:)))
        tapRecognizer.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapRecognizer)

        
        tblView.sectionHeaderHeight = 180

        self.view.backgroundColor = UIColor.defaultAppBackground
        self.tblView.backgroundColor = UIColor.defaultAppBackground
        
        isNavAvailable = false
        
    }
    
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }

    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        if let fromFundGet = sharedInstance.userDefaults.objectForKey(kSelectFromFundValue) as? NSDictionary
        {
            print(fromFundGet)
            isNavAvailable = true
            
            let srcSchemeCode = fromFundGet.valueForKey("Scheme_Code") as! String
            let rtAmcCode = fromFundGet.valueForKey("Fund_Code") as! String
//
            var dicToSend = NSMutableDictionary()
            
            dicToSend = ["Scheme_Code" : "\(srcSchemeCode)", "Amc_Code" : "\(rtAmcCode)"]
//            let dicToSend:NSDictionary = [
//                "Scheme_Code" : fromFundGet.valueForKey(/("Scheme_Code")) as! String,
//                "Amc_Code" : fromFundGet.valueForKey("Fund_Code") as! String]
            print(dicToSend)
            WebManagerHK.postDataToURL(kModeGetDirectSchemeDetail, params: dicToSend, message: "") { (response) in
                print("Dic Response : \(response)")
                
                if response.objectForKey(kWAPIResponse) is NSDictionary
                {
                    let mainResponse = response.objectForKey(kWAPIResponse) as! NSDictionary
                    
//                    if let fromFundGet = sharedInstance.userDefaults.objectForKey(kSelectToFundValue) as? String
//                    {
                        print(fromFundGet)
                        sharedInstance.userDefaults.setObject(mainResponse, forKey: kSelectToFundValue)
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            
                            self.randomVal = sharedInstance.getRandomVal()
                            
                            let myStringDivOpt = mainResponse.valueForKey("Div_Opt")
                            let Div_Opt = myStringDivOpt!.stringByTrimmingCharactersInSet(
                                NSCharacterSet.whitespaceAndNewlineCharacterSet()
                            )
                            if Div_Opt=="NA" { // NA.....
                            }
                            
                            let myStringPlan_Opt = mainResponse.valueForKey("Plan_Opt")
                            let Plan_Opt = myStringPlan_Opt!.stringByTrimmingCharactersInSet(
                                NSCharacterSet.whitespaceAndNewlineCharacterSet()
                            )
                            if Plan_Opt=="NA" { // NA.....
                            }
                            
                            
                            print(Div_Opt)
                            print(Plan_Opt)
                            if Plan_Opt == "DIV"
                            {
                                if Div_Opt == "BOTH"
                                {
                                    self.isDivAvailable = true
                                }else
                                {
                                    self.isDivAvailable = false
                                }
                            }else{
                                self.isDivAvailable = false
                            }
                            
                            self.tblView.reloadData()
                            
                        })

//                    }
//                    else
//                    {
//                        sharedInstance.userDefaults .setObject("Select Fund", forKey: kSelectToFundValue)
//                        self.lblSwitchToFund.text = "Switch to Fund"
//                        self.btnSwitchToFund.setTitle("Switch to Fund", forState: UIControlState.Normal)
//                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                            
//                            self.tblView.reloadData()
//                            
//                        })
//                    }

                    
                }else
                {
                    sharedInstance.userDefaults .setObject("Select Fund", forKey: kSelectToFundValue)
//                    self.lblSwitchToFund.text = "Switch to Fund"
//                    self.btnSwitchToFund.setTitle("Switch to Fund", forState: UIControlState.Normal)

                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        self.randomVal = sharedInstance.getRandomVal()
                        self.tblView.reloadData()
                    })
                }
            }
        }

        if let fromFundGet = sharedInstance.userDefaults.objectForKey(kSelectFromFundValue) as? String
        {
            print(fromFundGet)
        }
        
        
        if let ToFundGet = sharedInstance.userDefaults.objectForKey(kSelectToFundValue) as? NSDictionary
        {
            print(ToFundGet)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                self.randomVal = sharedInstance.getRandomVal()

                let myStringDivOpt = ToFundGet.valueForKey("Div_Opt")
                let Div_Opt = myStringDivOpt!.stringByTrimmingCharactersInSet(
                    NSCharacterSet.whitespaceAndNewlineCharacterSet()
                )
                if Div_Opt=="NA" { // NA.....
                }
                
                let myStringPlan_Opt = ToFundGet.valueForKey("Plan_Opt")
                let Plan_Opt = myStringPlan_Opt!.stringByTrimmingCharactersInSet(
                    NSCharacterSet.whitespaceAndNewlineCharacterSet()
                )
                if Plan_Opt=="NA" { // NA.....
                }
                
                
                print(Div_Opt)
                print(Plan_Opt)
                if Plan_Opt == "DIV"
                {
                    if Div_Opt == "BOTH"
                    {
                        self.isDivAvailable = true
                    }else
                    {
                        self.isDivAvailable = false
                    }
                }else{
                    self.isDivAvailable = false
                }

                self.tblView.reloadData()
                
            })
            
        }
        if let ToFundGet = sharedInstance.userDefaults.objectForKey(kSelectToFundValue) as? String
        {
            print(ToFundGet)
        }
        self.tblView.reloadData()
        
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

    @IBAction func btnBackClick(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }

    func applyTextFiledStyle1(textField : UITextField) {
        
        textField.delegate = self;
        textField.returnKeyType = UIReturnKeyType.Next
        textField.tintColor = UIColor.blueColor()
        textField .setValue(UIColor.darkGrayColor(), forKeyPath: "_placeholderLabel.textColor")
        textField.textColor = UIColor.blackColor()
        textField.textAlignment = NSTextAlignment.Left
        textField.font = UIFont.systemFontOfSize(16)
        textField.autocorrectionType = .No
    }
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        var planName = "CELL_FIRST_\(randomVal)_\(self.isNavAvailable)_\(self.isDivAvailable)"
        
        if let fromFundGet = sharedInstance.userDefaults.objectForKey(kSelectFromFundValue) as? NSDictionary
        {
            planName = "\(planName)_\(fromFundGet.objectForKey("Plan_Name"))"

        }
        if let fromFundGet = sharedInstance.userDefaults.objectForKey(kSelectFromFundValue) as? String
        {
            planName = "\(planName)_\(fromFundGet)"
        }
        
        if let ToFundGet = sharedInstance.userDefaults.objectForKey(kSelectToFundValue) as? NSDictionary
        {
            planName = "\(planName)_\(ToFundGet.objectForKey("Plan_Name"))"
        }
        if let ToFundGet = sharedInstance.userDefaults.objectForKey(kSelectToFundValue) as? String
        {
            print(ToFundGet)
            planName = "\(planName)_\(ToFundGet)"
        }

        
        let identifier = planName
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: identifier)
        
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as UITableViewCell
        
        if (cell.contentView.subviews.count==0) {
            
            if indexPath.row==4 {
                
                let buttonSubmit = UIButton(frame: CGRect(x: cell.contentView.frame.size.width-80, y: 10, width: 70, height: 36))
                buttonSubmit.setTitle("NEXT", forState: .Normal)
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
                lblUploadPan = UILabel(frame: CGRect(x: 10, y: 20, width: (cell.contentView.frame.size.width)-20, height: 25));
                lblUploadPan.text = ""
                lblUploadPan.textColor = UIColor.darkGrayColor()
                lblUploadPan.font = UIFont.systemFontOfSize(12)
                cell.contentView.addSubview(lblUploadPan)

                lblSwitchFromFund = UILabel(frame: CGRect(x: 10, y: 35, width: (cell.contentView.frame.size.width)-40, height: 50));
                
                if let fromFundGet = sharedInstance.userDefaults.objectForKey(kSelectFromFundValue) as? String
                {
                    print(fromFundGet)
                    lblSwitchFromFund.text = "Switch from Fund" //fromFundGet
                    lblSwitchFromFund.textColor = UIColor(red:0.78, green:0.78, blue:0.78, alpha:1.0)

                }
                if let fromFundGet = sharedInstance.userDefaults.objectForKey(kSelectFromFundValue) as? NSDictionary
                {
                    lblUploadPan.text = "Switch from Fund"
                    print(fromFundGet)
                    lblSwitchFromFund.text = fromFundGet.valueForKey("Plan_Name") as? String
                    lblSwitchFromFund.textColor = UIColor.blackColor()
                }

                lblSwitchFromFund.font = UIFont.systemFontOfSize(15)
                lblSwitchFromFund.numberOfLines = 2
                lblSwitchFromFund.backgroundColor = UIColor.clearColor()
                cell.contentView.addSubview(lblSwitchFromFund)

                btnSwitchFromFund = UIButton(frame: CGRect(x: 10, y: 35, width: (cell.contentView.frame.size.width)-40, height: 50));
                btnSwitchFromFund.backgroundColor = UIColor.clearColor()
                btnSwitchFromFund.addTarget(self, action: #selector(SwitchScreen.btnSelectFromFundClicked(_:)), forControlEvents: .TouchUpInside)
                cell.contentView.addSubview(btnSwitchFromFund)
                
//                var imgDownArrow : UIImageView!
//                imgDownArrow = UIImageView(frame: CGRect(x: (cell.contentView.frame.size.width)-50, y: 45, width: 30, height: 30));
//                imgDownArrow.image = UIImage(named: "iconDown")
//                imgDownArrow.backgroundColor = UIColor.clearColor()
//                cell.contentView.addSubview(imgDownArrow)

                var lblLine : UILabel!
                lblLine = UILabel(frame: CGRect(x: 10, y: 80, width: (cell.contentView.frame.size.width)-20, height: 1));
                lblLine.backgroundColor = UIColor.lightGrayColor()
                lblLine.alpha = 0.4
                cell.contentView.addSubview(lblLine)
                
                break;
            case 1:
                
//                var lblUploadPan : UILabel!
//                lblUploadPan = UILabel(frame: CGRect(x: 10, y: 5, width: (cell.contentView.frame.size.width)-20, height: 25));
//                lblUploadPan.text = "Folio Number"
//                lblUploadPan.textColor = UIColor.darkGrayColor()
//                lblUploadPan.font = UIFont.systemFontOfSize(12)
//                cell.contentView.addSubview(lblUploadPan)
                
                if txtFolioNumber==nil {
                    txtFolioNumber = RPFloatingPlaceholderTextField(frame: CGRect(x: 6, y: 20, width: (cell.contentView.frame.size.width)-20, height: 35));
                    txtFolioNumber.placeholder = "Enter Folio Number"
                    txtFolioNumber.floatingLabelInactiveTextColor = UIColor.darkGrayColor()
                    txtFolioNumber.keyboardType = UIKeyboardType.NumberPad
                    self.applyTextFiledStyle1(txtFolioNumber)
                    txtFolioNumber.autocapitalizationType = .AllCharacters
                    txtFolioNumber.textColor = UIColor.blackColor()
                    txtFolioNumber.floatingLabelActiveTextColor = UIColor.darkGrayColor()
//                        .colorWithAlphaComponent(0.55)
//                    txtFolioNumber.textColor = UIColor(red:0.78, green:0.78, blue:0.78, alpha:1.0)
                    txtFolioNumber.floatingLabel.font = UIFont.systemFontOfSize(12)
                    
//                    txtName = RPFloatingPlaceholderTextField(frame: CGRect(x: 10, y: 10, width: (cell.contentView.frame.size.width)-20, height: 35));
//                    txtName.placeholder = "Name"
//                    self.applyTextFiledStyle1(txtName)
//                    cell.contentView.addSubview(txtName)
                }
                
                if let fromFundGet = sharedInstance.userDefaults.objectForKey(kSelectFromFundValue) as? NSDictionary
                {
                    if let fNo = fromFundGet.valueForKey("FolioNo") as? String
                    {
                        txtFolioNumber.text = fNo
                        txtFolioNumber.enabled = false
                    }else{
                        txtFolioNumber.enabled = true
                    }
                }
                cell.contentView.addSubview(txtFolioNumber)

                var lblLine : UILabel!
                lblLine = UILabel(frame: CGRect(x: 10, y: 55, width: (cell.contentView.frame.size.width)-20, height: 1));
                lblLine.backgroundColor = UIColor.lightGrayColor()
                lblLine.alpha = 0.4
                cell.contentView.addSubview(lblLine)

                let txtPan = UILabel(frame: CGRect(x: 10, y: 60, width: (cell.contentView.frame.size.width)-40, height: 15));
                txtPan.text = "You can find folio number in your mutual fund statements."
                txtPan.textColor = UIColor.darkGrayColor()
                txtPan.font = UIFont.italicSystemFontOfSize(11)
                txtPan.backgroundColor = UIColor.clearColor()
                cell.contentView.addSubview(txtPan)

                
                let KnowMore = UIButton(frame: CGRect(x: 10, y: 72, width: 60, height: 15));
                KnowMore.backgroundColor = UIColor.clearColor()
                KnowMore.setTitle("Know more", forState: .Normal)
                KnowMore.setTitleColor(UIColor.defaultAppColorBlue, forState: .Normal)
                KnowMore.titleLabel?.font = UIFont.italicSystemFontOfSize(11)
                KnowMore.titleLabel?.textAlignment = .Left
                KnowMore.addTarget(self, action: #selector(knowMoreTap), forControlEvents: UIControlEvents.TouchUpInside)
                let attributes = [NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue]
                let attributedText = NSAttributedString(string: KnowMore.currentTitle!, attributes: attributes)
                KnowMore.titleLabel?.attributedText = attributedText
                
                
                cell.contentView.addSubview(KnowMore)

                if self.isNavAvailable
                {
                    var lblNav : UILabel!
                    lblNav = UILabel(frame: CGRect(x: 10, y: 100, width: (cell.contentView.frame.size.width)-20, height: 25));
                    lblNav.text = "NAV"
                    lblNav.textColor = UIColor.darkGrayColor()
                    lblNav.font = UIFont.systemFontOfSize(12)
                    cell.contentView.addSubview(lblNav)
                    
                    txtNAV = UITextField(frame: CGRect(x: 10, y: 125, width: (cell.contentView.frame.size.width)-20, height: 35));
                    //                txtNAV.text = "127.44 As 22-Sep-16"
                    txtNAV.keyboardType = UIKeyboardType.NumberPad
                    self.applyTextFiledStyle1(txtNAV)
                    cell.contentView.addSubview(txtNAV)
                    txtNAV.autocapitalizationType = .AllCharacters
                    txtNAV.userInteractionEnabled = false
                    
                    if let fromFundGet = sharedInstance.userDefaults.objectForKey(kSelectFromFundValue) as? NSDictionary
                    {
                        var nvValue = "" as String
                        
                        print(fromFundGet)
                        if let nav = fromFundGet.valueForKey("NAV")
                        {
                            print(nav)
                            nvValue = String(nav)
                        }
                        
                        if let navDat = fromFundGet.valueForKey("NAVDate")
                        {
//                            var dateStringm = navDat as! NSString
//                            dateStringm = dateStringm.substringWithRange(NSRange(location: 0, length: 10))
//                            
//                            let dateFormatter = NSDateFormatter()
//                            dateFormatter.dateFormat = "dd-MM-yyyy"
//                            //        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
//                            let dateObj = dateFormatter.dateFromString(dateStringm as String)
//                            print(dateObj)
                            
                            
                            
                            nvValue = "\(nvValue) As On \(sharedInstance.getFormatedDate(navDat as! String))"
                        }
                        txtNAV.text = nvValue
                    }
                    
                    var lblLine1 : UILabel!
                    lblLine1 = UILabel(frame: CGRect(x: 10, y: 155, width: (cell.contentView.frame.size.width)-20, height: 1));
                    lblLine1.backgroundColor = UIColor.lightGrayColor()
                    lblLine1.alpha = 0.4
                    cell.contentView.addSubview(lblLine1)
                    
                    cell.selectionStyle = UITableViewCellSelectionStyle.None
                    cell.contentView.backgroundColor = UIColor.clearColor()
                    cell.backgroundColor = UIColor.clearColor()
                    return cell
                    
                }else{
                    
//                    var lblLine1 : UILabel!
//                    lblLine1 = UILabel(frame: CGRect(x: 10, y: 105, width: (cell.contentView.frame.size.width)-20, height: 1));
//                    lblLine1.backgroundColor = UIColor.lightGrayColor()
//                    lblLine1.alpha = 0.4
//                    cell.contentView.addSubview(lblLine1)


                }

                break
            case 2:
                
                var lblUploadPan : UILabel!
                lblUploadPan = UILabel(frame: CGRect(x: 10, y: 20, width: (cell.contentView.frame.size.width)-20, height: 25));
                //lblUploadPan.text = "Switch to Fund"
                lblUploadPan.textColor = UIColor.darkGrayColor()
                lblUploadPan.font = UIFont.systemFontOfSize(12)
                cell.contentView.addSubview(lblUploadPan)
                
                
                lblSwitchToFund = UILabel(frame: CGRect(x: 10, y: 35, width: (cell.contentView.frame.size.width)-40, height: 50));
                if let ToFundGet = sharedInstance.userDefaults.objectForKey(kSelectToFundValue) as? String
                {
                    print(ToFundGet)
                    lblSwitchToFund.text = "Switch to Fund"//ToFundGet
                    lblSwitchToFund.textColor = UIColor(red:0.78, green:0.78, blue:0.78, alpha:1.0)
                    
                }
                if let ToFundGet = sharedInstance.userDefaults.objectForKey(kSelectToFundValue) as? NSDictionary
                {
                    lblUploadPan.text = "Switch to Fund"
                    print(ToFundGet)
                    lblSwitchToFund.text = ToFundGet.valueForKey("Plan_Name") as? String
                    lblSwitchToFund.textColor = UIColor.blackColor()
                }

                lblSwitchToFund.font = UIFont.systemFontOfSize(15)
                lblSwitchToFund.numberOfLines = 2
                lblSwitchToFund.backgroundColor = UIColor.clearColor()
                cell.contentView.addSubview(lblSwitchToFund)
                
                btnSwitchToFund = UIButton(frame: CGRect(x: 10, y: 35, width: (cell.contentView.frame.size.width)-40, height: 50));
                btnSwitchToFund.backgroundColor = UIColor.clearColor()
                cell.contentView.addSubview(btnSwitchToFund)
                btnSwitchToFund.addTarget(self, action: #selector(SwitchScreen.btnSelectToFundClicked(_:)), forControlEvents: .TouchUpInside)
                
//                var imgDownArrow : UIImageView!
//                imgDownArrow = UIImageView(frame: CGRect(x: (cell.contentView.frame.size.width)-50, y: 45, width: 30, height: 30));
//                imgDownArrow.image = UIImage(named: "iconDown")
//                imgDownArrow.backgroundColor = UIColor.clearColor()
//                cell.contentView.addSubview(imgDownArrow)
                
                var lblLine : UILabel!
                lblLine = UILabel(frame: CGRect(x: 10, y: 80, width: (cell.contentView.frame.size.width)-20, height: 1));
                lblLine.backgroundColor = UIColor.lightGrayColor()
                lblLine.alpha = 0.4
                cell.contentView.addSubview(lblLine)
                
                
                
                if self.isDivAvailable {
                    
                    lblDividendOption = UILabel(frame: CGRect(x: 10, y: 85, width: (cell.contentView.frame.size.width)-20, height: 25));
                    lblDividendOption.text = "Dividend Option"
                    lblDividendOption.textColor = UIColor.darkGrayColor()
                    lblDividendOption.font = UIFont.systemFontOfSize(12)
                    cell.contentView.addSubview(lblDividendOption)
                    
                    txtDividendOption = UITextField(frame: CGRect(x: 10, y: 115, width: 120, height: 35));
                    txtDividendOption.text = DividendOptionBUY.allValues[enumDividendOption.hashValue]
                    txtDividendOption.keyboardType = UIKeyboardType.Default
                    self.applyTextFiledStyle1(txtDividendOption)
                    cell.contentView.addSubview(txtDividendOption)
                    txtDividendOption.inputView = pickerView
                    txtDividendOption.tag = TAG_DIVIDEND_OPTION_SWTCH
                    txtDividendOption.textColor = UIColor.blackColor()
                    
                    
                    var imgDownArrowDOP : UIImageView!
                    imgDownArrowDOP = UIImageView(frame: CGRect(x: 120, y: 115, width: 30, height: 30));
                    imgDownArrowDOP.image = UIImage(named: "iconDown")
                    imgDownArrowDOP.backgroundColor = UIColor.clearColor()
                    cell.contentView.addSubview(imgDownArrowDOP)
                    
                    var lblLineDOP : UILabel!
                    lblLineDOP = UILabel(frame: CGRect(x: 10, y: 145, width: 140, height: 1));
                    lblLineDOP.backgroundColor = UIColor.lightGrayColor()
                    lblLineDOP.alpha = 0.4
                    cell.contentView.addSubview(lblLineDOP)

                }
                
                break;
            case 3:
                
                var lblUploadPan : UILabel!
                lblUploadPan = UILabel(frame: CGRect(x: 10, y: 5, width: (cell.contentView.frame.size.width)-20, height: 25));
                lblUploadPan.text = "Switch by:"
                lblUploadPan.textColor = UIColor.darkGrayColor()
                lblUploadPan.font = UIFont.systemFontOfSize(12)
                cell.contentView.addSubview(lblUploadPan)
                
                var lblLine : UILabel!
                lblLine = UILabel(frame: CGRect(x: 10, y: 84, width: (cell.contentView.frame.size.width)-20, height: 1));
                lblLine.backgroundColor = UIColor.lightGrayColor()
                lblLine.alpha = 0.4
                cell.contentView.addSubview(lblLine)
                
                var imgDownArrow : UIImageView!
                imgDownArrow = UIImageView(frame: CGRect(x: 100, y: 30, width: 30, height: 30));
                imgDownArrow.image = UIImage(named: "iconDown")
                imgDownArrow.backgroundColor = UIColor.clearColor()
                cell.contentView.addSubview(imgDownArrow)
                
                txtSwitchBy = UITextField(frame: CGRect(x: 10, y: 30, width: 110, height: 35));
                txtSwitchBy.text = currentSelectedSwitchBy
                txtSwitchBy.keyboardType = UIKeyboardType.Default
                self.applyTextFiledStyle1(txtSwitchBy)
                cell.contentView.addSubview(txtSwitchBy)
                txtSwitchBy.inputView = pickerView

                txtSwitchByValue = UITextField(frame: CGRect(x: (cell.contentView.frame.size.width)-160, y: 30, width: 150, height: 35));
                txtSwitchByValue.text = ""
                //txtSwitchByValue.placeholder = "Enter Value"
                txtSwitchByValue.keyboardType = UIKeyboardType.Default
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
                }
                else
                {
                    if currentSelectedSwitchBy=="Amount"
                    {
                        lblSwitchByValue.text = "Minimum amount : ₹0"
                    }
                    if currentSelectedSwitchBy=="Units"
                    {
                        lblSwitchByValue.text = "Minimum units : 0.0001"
                    }
                    txtSwitchByValue.hidden = false
                    lblSwitchByValue.hidden = false
                    lblUnderLine.hidden = false
                }

                
                let txtPan = UILabel(frame: CGRect(x: 10, y: 90, width: (cell.contentView.frame.size.width)-40, height: 35));
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
            if self.isNavAvailable
            {
                return 160
            }
            return 80
        }
        if indexPath.row==2 {

            if self.isDivAvailable {
                return 145
            }
            return 80
        }
        if indexPath.row==3 {
            return 125
        }
        return 55
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView(frame: CGRect(x: 10, y: 0, width: tableView.frame.size.width-20, height: 180))
        view.backgroundColor = UIColor.defaultAppBackground
        
        let imageProfile = UIImageView(frame: CGRect(x: (view.frame.size.width/2)-45, y: 10, width: 80, height: 80))
        imageProfile.layer.cornerRadius = imageProfile.frame.height/2
        let image = UIImage(named: "transactswitch_icon")
        imageProfile.image = image
        view.addSubview(imageProfile)
        
        var lblSwitchNow : UILabel!
        lblSwitchNow = UILabel(frame: CGRect(x: 10, y: 100, width: (view.frame.size.width)-20, height: 30));
        lblSwitchNow.text = "Switch Now"
        lblSwitchNow.textColor = UIColor.blackColor()
        lblSwitchNow.font = UIFont.systemFontOfSize(19)
        lblSwitchNow.textAlignment = .Center
        view.addSubview(lblSwitchNow)
        
        var lblSwitchToDirect1 : UILabel!
        lblSwitchToDirect1 = UILabel(frame: CGRect(x: 10, y: 130, width: (view.frame.size.width)-20, height: 15));
        lblSwitchToDirect1.text = "Switch to Direct"
        lblSwitchToDirect1.textColor = UIColor.darkGrayColor()
        lblSwitchToDirect1.font = UIFont.italicSystemFontOfSize(13)
        lblSwitchToDirect1.textAlignment = .Center
        view.addSubview(lblSwitchToDirect1)

        var lblSwitchToDirect2 : UILabel!
        lblSwitchToDirect2 = UILabel(frame: CGRect(x: 10, y: 145, width: (view.frame.size.width)-20, height: 15));
        lblSwitchToDirect2.text = "Pay Zero commisions. Earn ~ 1% extra"
        lblSwitchToDirect2.textColor = UIColor.darkGrayColor()
        lblSwitchToDirect2.font = UIFont.italicSystemFontOfSize(13)
        lblSwitchToDirect2.textAlignment = .Center
        view.addSubview(lblSwitchToDirect2)

        var lblSwitchToDirect3 : UILabel!
        lblSwitchToDirect3 = UILabel(frame: CGRect(x: 10, y: 160, width: (view.frame.size.width)-20, height: 15));
        lblSwitchToDirect3.text = "every year."
        lblSwitchToDirect3.textColor = UIColor.darkGrayColor()
        lblSwitchToDirect3.font = UIFont.italicSystemFontOfSize(13)
        lblSwitchToDirect3.textAlignment = .Center
        view.addSubview(lblSwitchToDirect3)

        
        let label = UILabel(frame: CGRect(x: 10, y: view.frame.size.height-1, width: view.frame.size.width, height: 1))
        label.backgroundColor = UIColor.lightGrayColor()
        view.addSubview(label)
        label.alpha = 0.4
        
        return view
    }
    
    // UITextField Delegates
    func textFieldDidBeginEditing(textField: UITextField) {
        print("TextField did begin editing method called")
        txtCurrentTextField = textField
        if (txtCurrentTextField.text == "All Units")
        {
            
            pickerView.selectRow(0, inComponent: 0, animated: true)
        }
        else if (txtCurrentTextField.text == "Units")
        {
            pickerView.selectRow(1, inComponent: 0, animated: true)
        }
        else if (txtCurrentTextField.text == "Amount")
        {
            pickerView.selectRow(2, inComponent: 0, animated: true)
        }
        

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
        let objSelectFromFund = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdSelectSearchFund) as! SelectSearchFund
        objSelectFromFund.selectFor = "FromFund"
        self.presentViewController(objSelectFromFund, animated: true, completion: nil)
    }
    
    @IBAction func btnSelectToFundClicked(sender: AnyObject) {
        print("From To Clicked")
        
        var planFromName = ""
        if let fromFundGet = sharedInstance.userDefaults.objectForKey(kSelectFromFundValue) as? NSDictionary
        {
            print(fromFundGet)
            planFromName = fromFundGet.objectForKey("Plan_Name") as! String
        }
        if let fromFundGet = sharedInstance.userDefaults.objectForKey(kSelectFromFundValue) as? String
        {
            print(fromFundGet)
            planFromName = fromFundGet

        }
        if planFromName=="Select Fund" {
            SharedManager.invokeAlertMethod(APP_NAME, strBody: "Please select Switch From Fund first!", delegate: nil)
            return;
        }
        
        let objSelectFromFund = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdSelectSearchFund) as! SelectSearchFund
        objSelectFromFund.selectFor = "ToFund"
        self.presentViewController(objSelectFromFund, animated: true, completion: nil)

    }

    @IBAction func btnNexClicked(sender: AnyObject) {
        
        var objOrder : Order = Order()

        var planFromName = ""
        if let fromFundGet = sharedInstance.userDefaults.objectForKey(kSelectFromFundValue) as? NSDictionary
        {
            print(fromFundGet)
            planFromName = fromFundGet.objectForKey("Plan_Name") as! String
            
            objOrder.SrcSchemeName = planFromName
            objOrder.SrcSchemeCode = fromFundGet.objectForKey("Scheme_Code") as! String
            
            
            if let RtaAmcCode = fromFundGet.objectForKey("Fund_Code")
            {
                objOrder.RtaAmcCode = RtaAmcCode as! String
            }
            
        }
        if let fromFundGet = sharedInstance.userDefaults.objectForKey(kSelectFromFundValue) as? String
        {
            print(fromFundGet)
            planFromName = fromFundGet
            
        }
        
        if planFromName=="Select Fund" {
            SharedManager.invokeAlertMethod(APP_NAME, strBody: "Please select Switch From Fund first!", delegate: nil)
            return;
        }
        
        if txtFolioNumber.text?.length==0 {
            SharedManager.invokeAlertMethod(APP_NAME, strBody: "Please enter Folio Number!", delegate: nil)
            return;
        }
        
        
        var planToName = ""
        if let fromFundGet = sharedInstance.userDefaults.objectForKey(kSelectToFundValue) as? NSDictionary
        {
            print(fromFundGet)
            planToName = fromFundGet.objectForKey("Plan_Name") as! String
            objOrder.TarSchemeName = planFromName
            objOrder.TarSchemeCode = fromFundGet.objectForKey("Scheme_Code") as! String

        }
        if let fromFundGet = sharedInstance.userDefaults.objectForKey(kSelectToFundValue) as? String
        {
            print(fromFundGet)
            planToName = fromFundGet
            
        }
        if planToName=="Select Fund" {
            SharedManager.invokeAlertMethod(APP_NAME, strBody: "Please select Switch To Fund!", delegate: nil)
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
            
        }
        if currentSelectedSwitchBy == "Amount" {
            objOrder.VolumeType = "A"
            
            if txtSwitchByValue.text?.length==0 {
                SharedManager.invokeAlertMethod(APP_NAME, strBody: "Please enter Amount!", delegate: nil)
                return
            }
        }
        
        if self.isDivAvailable {
            
            let optionText = DividendOptionBUY.allValues[enumDividendOption.hashValue]
            if optionText=="Payout" {
                objOrder.DividendOption = "P"
            }
            if optionText=="Reinvestment" {
                objOrder.DividendOption = "R"
            }
        }
        
        objOrder.Volume = txtSwitchByValue.text

        let objOrderSummary = self.storyboard?.instantiateViewControllerWithIdentifier(sbIdOrderSummaryScreen) as! OrderSummaryScreen
        objOrderSummary.objOrder = objOrder
        self.navigationController?.pushViewController(objOrderSummary, animated: true)
        
    }
    
    
    @IBAction func btnInfoClicked(sender: AnyObject) {
        let objWebView = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdWebViewController) as! WebViewController
        objWebView.urlLink = NSURL(string:URL_SWITCH_HELP)!
        objWebView.screenTitle = kTitleSwitch_Help
        self.navigationController?.pushViewController(objWebView, animated: true)
    }
    
    func knowMoreTap(sender: AnyObject)
    {
        let objWebView = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdWebViewController) as! WebViewController
        objWebView.urlLink = NSURL(string:URL_FOLIO_FIND_HELP)!
        objWebView.screenTitle = kTitleFolio_Help
        self.navigationController?.pushViewController(objWebView, animated: true)
    }
    
    @IBAction func btnCancelClicked(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if txtCurrentTextField.tag == TAG_DIVIDEND_OPTION_BUY {
            return DividendOptionBUY.allValues.count
        }

        return 3
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if txtCurrentTextField.tag == TAG_DIVIDEND_OPTION_BUY {
            return DividendOptionBUY.allValues[row]
        }

        if row==0 {
            return "All Units"
        }
        if row==1 {
            return "Units"
        }
        if row==2 {
            return "Amount"
        }

        return "DefaulyValue"
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
        if txtCurrentTextField.tag == TAG_DIVIDEND_OPTION_BUY {
            txtCurrentTextField.text = DividendOptionBUY.allValues[row]
            enumDividendOption = DividendOptionBUY.fromHashValue(row)
            txtCurrentTextField.resignFirstResponder()
            
            return
        }
        
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
            lblUnderLine.hidden = true
        }else{
            if currentSelectedSwitchBy=="Amount"
            {
                txtSwitchByValue.placeholder = "Enter Amount"
                lblSwitchByValue.text = "Minimum amount : ₹0"
            }
            if currentSelectedSwitchBy=="Units"
            {
                txtSwitchByValue.placeholder = "Enter Units"
                lblSwitchByValue.text = "Minimum units : 0.0001"
            }
            txtSwitchByValue.hidden = false
            lblSwitchByValue.hidden = false
            lblUnderLine.hidden = false
        }

        txtSwitchByValue.text = ""
        
        tblView.reloadData()
    }
    
}
