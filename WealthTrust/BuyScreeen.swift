//
//  BuyScreeen.swift
//  WealthTrust
//
//  Created by Hemen Gohil on 9/22/16.
//  Copyright © 2016 Hemen Gohil. All rights reserved.
//

import UIKit

let TAG_DIVIDEND_OPTION_BUY = 103
let TAG_DIVIDEND_OPTION_BUY_SIP = 104


let kBUY_FROM_SELECTED_FUND = "BuyFromSelectedFund"
let kBUY_FROM_FRESH = "BuyFromFresh"
let kBUY_FOR_SIP = "BuyForSIP"
let kBUY_FROM_SMARTFUND = "BuyFromSmartFund"

let TAG_FREQUENCY = 203
let TAG_START_MONTH = 204
let TAG_START_YEAR = 205
let TAG_SIPday = 206
let TAG_END_MONTH = 207
let TAG_END_YEAR = 208


let URL_BUY_HELP = "http://www.wealthtrust.in/faq.html#buy"
let URL_SIP_HELP = "http://www.wealthtrust.in/faq.html#sip"


class BuyScreeen: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate {

    var amont : Int!

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

    var btnReset : UIButton!
    var btnBuyNow : UIButton!

    var txtSchemeName : UITextField!
    var btnSchemeName : UIButton!
    
    var lbltxtSchemeName : UILabel!
    var txtSchemeAmount : RPFloatingPlaceholderTextField!
    var txtSchemeAmountlblNote = UILabel()
    
    var txtDividendOption : UITextField!
    var lblDividendOption : UILabel!
    var enumDividendOption = DividendOptionBUY.Payout
    
    var txtNav : RPFloatingPlaceholderTextField!
    
    var pickerView = UIPickerView()
    
    var isBuyFrom = kBUY_FROM_FRESH
    var isExisting = false
    
    var btnSchemeNameSIP : UIButton!
    var lbltxtSchemeNameSIP : UILabel!
    
    var txtDividendOptionSIP : UITextField!
    var lblDividendOptionSIP : UILabel!

    var txtNavSIP : UITextField!
    
    var txtFrequency : UITextField!
    var enumFrequencySelectedIndex = 0
    var arrFrequency : NSMutableArray = []

    
    var txtSchemeAmountSIP : RPFloatingPlaceholderTextField!
    var txtSchemeAmountSIPlblNote : UILabel!

    var txtNoOfInstallments : RPFloatingPlaceholderTextField!
    var txtNoOfInstallmentslblNotes : UILabel!
    var minimumInstallments = 0

    
    var txtSIPDay : UITextField!
    var enumSIPDaySelectedIndex = 0
    var arrSIPDays : NSMutableArray = []

    
    var txtStartMonth : UITextField!
    var enumStartMonthSelected = MONTH.SELECT
    
    var txtStartYear : UITextField!
    var enumStartYearSelectedIndex = 1
    var arrYears : NSMutableArray = []

    
    var txtEndMonth : UITextField!
    var enumEndMonthSelected = MONTH.SELECT

    var txtEndYear : UITextField!
    var enumEndYearSelectedIndex = 0
    
    var txtSIPAmount = UITextField()
    
    var txtLumpsumBuyAmount : RPFloatingPlaceholderTextField!
    var txtLumpsumBuyAmountLBLNote : UILabel!
    var txtLumpsumBuyAmountLBLLine : UILabel!

    var btnCheckBoxMakeFirstLumpsum : UIButton!
    var btnMakeFirstLumpsum : UIButton!

    var minimumAmount = 0
    var minimumLumpsumAmount = 0

    var arrSIPSoldDetails : NSMutableArray = []

    var isDivAvailable = false
    var isNAVAvailable = false

    var randomVal = sharedInstance.getRandomVal()
    
    
    var multipleAmount = 1
    var arrMultipleAmount : NSMutableArray = []

    let keyboardDoneButtonView = UIToolbar.init()
    var doneButton = UIBarButtonItem.init()
    
    //keyboardDoneButtonView.items = [doneButton]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(BuyScreeen.handleSingleTap(_:)))
        tapRecognizer.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapRecognizer)
        
        self.loadYears()
        
        // Do any additional setup after loading the view, typically from a nib.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIKeyboardDidHideNotification, object: nil)
        
        tblView.sectionHeaderHeight = 155
        
        self.view.backgroundColor = UIColor.defaultAppBackground
        self.tblView.backgroundColor = UIColor.defaultAppBackground

        pickerView.delegate = self
        
//        isBuyFrom = kBUY_FROM_SELECTED_FUND
        
//        self.getFundCategory() // REMOVING NOW
        
//        let keyboardDoneButtonView = UIToolbar.init()
//        keyboardDoneButtonView.sizeToFit()
//        
//        doneButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.Done, target:self, action: Selector (doneClicked()))
////        
//        keyboardDoneButtonView.items = [doneButton]
//        txtLumpsumBuyAmount.inputAccessoryView = keyboardDoneButtonView
//        txtSIPAmount.inputAccessoryView = keyboardDoneButtonView
        
        
        //barButtonSystemItem: UIBarButtonSystemItem.Done, target:self, action:Selector(self.doneClicked())
    }
    
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func doneClicked(sender: AnyObject) {
//        self.view.endEditing(true)
        
       if txtSchemeAmount.editing == true
        {
            btnBuyNow.sendActionsForControlEvents(UIControlEvents .TouchUpInside)
        }
         self.view.endEditing(true)

    }
    
    func addToolBar(textField: UITextField){
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        // toolBar.tintColor = UIColor.blueColor()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: #selector(BuyScreeen.doneClicked))
//        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        toolBar.setItems([doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        toolBar.sizeToFit()
        
        textField.delegate = self
        textField.inputAccessoryView = toolBar
    }

    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        
        let value = UIInterfaceOrientation.Portrait.rawValue
        UIDevice.currentDevice().setValue(value, forKey: "orientation")

        if isBuyFrom==kBUY_FROM_FRESH { // kBUY_FROM_FRESH START
            
            if let BuyNowScheme = sharedInstance.userDefaults.objectForKey(kSelectBuyNowScheme) as? NSDictionary
            {
                print(BuyNowScheme)
                randomVal = sharedInstance.getRandomVal()
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    let myStringDivOpt = BuyNowScheme.valueForKey("Div_Opt")
                    let Div_Opt = myStringDivOpt!.stringByTrimmingCharactersInSet(
                        NSCharacterSet.whitespaceAndNewlineCharacterSet()
                    )
                    if Div_Opt=="NA" { // NA.....
                    }
                    
                    let myStringPlan_Opt = BuyNowScheme.valueForKey("Plan_Opt")
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
                    
                    self.isNAVAvailable = true
                    
                    
                    if let nav = BuyNowScheme.valueForKey("NAV")
                    {
                        if let nav_date = BuyNowScheme.valueForKey("NAVDate")
                        {
                            let twoDecimalPlaces = String(format: "%.2f", nav as! Double)
                            
                            if (self.txtNav != nil)
                            {
                                self.txtNav.text = "\(twoDecimalPlaces) As On \(sharedInstance.getFormatedDate(nav_date as! String))"
                            }
                            
                            if (self.txtNavSIP != nil)
                            {
                                
                                self.txtNavSIP.text = "\(twoDecimalPlaces) As On \(sharedInstance.getFormatedDate(nav_date as! String))"
                                
                            }
                        }
                    }
                    
                    self.tblView.reloadData()

                })
                
                lbltxtSchemeName.text = BuyNowScheme.valueForKey("Plan_Name") as? String
                if (lbltxtSchemeNameSIP != nil) {
                    lbltxtSchemeNameSIP.text = BuyNowScheme.valueForKey("Plan_Name") as? String
                }
                
                let myStringSchem = BuyNowScheme.valueForKey("Scheme_Code")
                let Scheme_Code = myStringSchem!.stringByTrimmingCharactersInSet(
                    NSCharacterSet.whitespaceAndNewlineCharacterSet()
                )
                
                let myStringFund_Code = BuyNowScheme.valueForKey("Fund_Code")
                let Fund_Code = myStringFund_Code!.stringByTrimmingCharactersInSet(
                    NSCharacterSet.whitespaceAndNewlineCharacterSet()
                )
               
                
//                let isExitst = DBManager.getInstance().checkMFAccountAlreadyExistForSchemeCode(Scheme_Code)
                let isExitst = DBManager.getInstance().checkMFAccountAlreadyExistForSchemeCode(Scheme_Code,fundCode: Fund_Code,ClientId: sharedInstance.objLoginUser.ClientID)

                
                var dicToSend = NSDictionary()
                
                if isExitst
                {
                    dicToSend = [
                        "Scheme_Code" : Scheme_Code,
                        "Fund_Code" : Fund_Code,
                        "Txn_Type" : "A"]
                }else{
                    dicToSend = [
                        "Scheme_Code" : Scheme_Code,
                        "Fund_Code" : Fund_Code,
                        "Txn_Type" : "B"]
                }
                
                WebManagerHK.postDataToURL(kModeGetSchemeThresholdDetails, params: dicToSend, message: "") { (response) in
                    
                    if response.objectForKey(kWAPIResponse) is NSArray
                    {
                        let mainResponse = response.objectForKey(kWAPIResponse) as! NSArray
                        print("Dic Response : \(mainResponse)")
                        
                        if mainResponse.count==0
                        {
                            
                        }
                        else{
                            
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in

                                let dicData = mainResponse.objectAtIndex(0) as! NSDictionary
                            
                                self.minimumAmount = dicData.valueForKey("Min_Amt") as! Int
                                self.multipleAmount = dicData.valueForKey("Multiple_Amt") as! Int
                            
                                print("Multiple Amount \(self.multipleAmount)")
                            
                                self.txtSchemeAmountlblNote.text = "Minimum amount : ₹ \(self.minimumAmount)"
                                
                            })
                            
                        }
                    }else
                    {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            
                            self.tblView.reloadData()
                            
                        })
                    }
                }
                
            }
            
            if let BuyNowScheme = sharedInstance.userDefaults.objectForKey(kSelectBuyNowScheme) as? String
            {
                if lbltxtSchemeName != nil {
                    lbltxtSchemeName.text = BuyNowScheme
                }
            }
            
        }
        
        if isBuyFrom==kBUY_FOR_SIP { // kBUY_FOR_SIP START
            
            if let SIPNowScheme = sharedInstance.userDefaults.objectForKey(kSelectBuyNowScheme) as? NSDictionary
            {
                print(SIPNowScheme)

                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    let myStringDivOpt = SIPNowScheme.valueForKey("Div_Opt")
                    let Div_Opt = myStringDivOpt!.stringByTrimmingCharactersInSet(
                        NSCharacterSet.whitespaceAndNewlineCharacterSet()
                    )
                    if Div_Opt=="NA" { // NA.....
                        //                        self.txtDividendOption.hidden = true
                        //                        self.lblDividendOption.hidden = true
                    }
                    
                    let myStringPlan_Opt = SIPNowScheme.valueForKey("Plan_Opt")
                    
                    if myStringPlan_Opt == nil
                    {
                        
                    }
                    else
                    {
                        let Plan_Opt = myStringPlan_Opt!.stringByTrimmingCharactersInSet(
                        NSCharacterSet.whitespaceAndNewlineCharacterSet())
                        
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

                    }
//                    if Plan_Opt=="NA" { // NA.....
//                    }
//                    
//                    
//                    print(Div_Opt)
//                    print(Plan_Opt)
//                    if Plan_Opt == "DIV"
//                    {
//                        if Div_Opt == "BOTH"
//                        {
//                            self.isDivAvailable = true
//                        }else
//                        {
//                            self.isDivAvailable = false
//                        }
//                    }else{
//                        self.isDivAvailable = false
//                    }
                    
                    self.isNAVAvailable = true
                    
                    
                    if let nav = SIPNowScheme.valueForKey("NAV")
                    {
                        if let nav_date = SIPNowScheme.valueForKey("NAVDate")
                        {
                            let twoDecimalPlaces = String(format: "%.2f", nav as! Double)
                            
                            if (self.txtNav != nil)
                            {
                                self.txtNav.text = "\(twoDecimalPlaces) As On \(sharedInstance.getFormatedDate(nav_date as! String))"
                            }
                            
                            if (self.txtNavSIP != nil)
                            {
                                
                                self.txtNavSIP.text = "\(twoDecimalPlaces) As On \(sharedInstance.getFormatedDate(nav_date as! String))"
                                
                            }
                        }
                    }
                    
                    self.randomVal = sharedInstance.getRandomVal()
                    self.tblView.reloadData()
                    
                    // OTHER work...
                    if (self.lbltxtSchemeName != nil) {
                        self.lbltxtSchemeName.text = SIPNowScheme.valueForKey("Plan_Name") as? String
                    }
                    if (self.lbltxtSchemeNameSIP != nil) {
                        self.lbltxtSchemeNameSIP.text = SIPNowScheme.valueForKey("Plan_Name") as? String
                    }
                    
                    let myStringSchem = SIPNowScheme.valueForKey("Scheme_Code")
                    let Scheme_Code = myStringSchem!.stringByTrimmingCharactersInSet(
                        NSCharacterSet.whitespaceAndNewlineCharacterSet()
                    )
                    
                    let myStringFund_Code = SIPNowScheme.valueForKey("Fund_Code")
                    let Fund_Code = myStringFund_Code!.stringByTrimmingCharactersInSet(
                        NSCharacterSet.whitespaceAndNewlineCharacterSet()
                    )
                    //
                    let dicToSend:NSDictionary = [
                        "Scheme_Code" : Scheme_Code,
                        "Fund_Code" : Fund_Code,
                        "Txn_Type" : "V"]
                    print(dicToSend)
                    
                    WebManagerHK.postDataToURL(kModeGetSchemeThresholdDetails, params: dicToSend, message: "") { (response) in
                        
                        print(response)
                        
                        if response.objectForKey(kWAPIResponse) is NSArray
                        {
                            let mainResponse = response.objectForKey(kWAPIResponse) as! NSArray
                            print("Dic Response : \(mainResponse)")
                            if mainResponse.count==0
                            {
                                
                            }
                            else{
                                
//                                self.multipleAmount = mainResponse.valueForKey("Multiple_Amt") as! Int

                                self.arrSIPSoldDetails = mainResponse.mutableCopy() as! NSMutableArray
                                
                                if self.arrFrequency.count==0{
                                }else{
                                    self.arrFrequency.removeAllObjects()
                                }
                                if self.arrMultipleAmount.count==0{
                                }else{
                                    self.arrMultipleAmount.removeAllObjects()
                                }

                                self.arrFrequency.addObject("SELECT")
                                
                                for dicMoreDt in self.arrSIPSoldDetails {
                                    print(dicMoreDt)
                                    self.arrFrequency.addObject(dicMoreDt.valueForKey("Sys_Freq")!)
                                    
                                    self.arrMultipleAmount.addObject(dicMoreDt.valueForKey("Multiple_Amt")!)

                                }
                                print("All Frequency \(self.arrFrequency)")
                                print("All Multiple \(self.arrMultipleAmount)")
                                if self.arrMultipleAmount.count==0{
                                }else{
                                    self.multipleAmount = self.arrMultipleAmount.objectAtIndex(0) as! Int
                                }

                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    self.enumFrequencySelectedIndex = 0
                                    self.txtFrequency.text = self.arrFrequency.objectAtIndex(self.enumFrequencySelectedIndex) as? String
                                    
                                    self.randomVal = sharedInstance.getRandomVal()
                                    self.tblView.reloadData()

                                })
                                
                            }
                        }
                        else
                        {
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                self.randomVal = sharedInstance.getRandomVal()
                                self.tblView.reloadData()
                            })
                        }
                    }
                })
            }
            
            if let BuyNowScheme = sharedInstance.userDefaults.objectForKey(kSelectBuyNowScheme) as? String
            {
                if lbltxtSchemeName != nil {
                    lbltxtSchemeName.text = BuyNowScheme
                }
                if lbltxtSchemeNameSIP != nil {
                    lbltxtSchemeNameSIP.text = BuyNowScheme
                }
            }
        }
        
        if isBuyFrom==kBUY_FROM_SELECTED_FUND { // kBUY_FROM_SELECTED_FUND START
            
            if let BuyNowScheme = sharedInstance.userDefaults.objectForKey(kSelectBuyNowScheme) as? NSDictionary
            {
                print(BuyNowScheme)
                randomVal = sharedInstance.getRandomVal()

                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    if let myStringDivOpt = BuyNowScheme.valueForKey("Div_Opt") //Div_Opt
                    {
                        let Div_Opt = myStringDivOpt.stringByTrimmingCharactersInSet(
                            NSCharacterSet.whitespaceAndNewlineCharacterSet()
                        )
                        if Div_Opt=="NA" { // NA.....
                        }
                    }
                    
                    self.checkDetailsForPreselected(BuyNowScheme)
                    
                    self.isNAVAvailable = true
                    
                    if let nav = BuyNowScheme.valueForKey("NAV")
                    {
                        if let nav_date = BuyNowScheme.valueForKey("NAVDate")
                        {
                            let twoDecimalPlaces = String(format: "%.2f", nav as! Double)
                            
                            if (self.txtNavSIP != nil)
                            {
                                self.txtNav.text = "\(twoDecimalPlaces) As On \(sharedInstance.getFormatedDate(nav_date as! String))"
                            }
                            
                            if (self.txtNavSIP != nil)
                            {
                                self.txtNavSIP.text = "\(twoDecimalPlaces) As On \(sharedInstance.getFormatedDate(nav_date as! String))"
                            }
                        }
                    }
                    
                    self.tblView.reloadData()

                })
                
                if (self.lbltxtSchemeName != nil) {
                    lbltxtSchemeName.text = BuyNowScheme.valueForKey("Plan_Name") as? String
                }
                if (lbltxtSchemeNameSIP != nil) {
                    lbltxtSchemeNameSIP.text = BuyNowScheme.valueForKey("Plan_Name") as? String
                }
                
                let myStringSchem = BuyNowScheme.valueForKey("Scheme_Code")
                let Scheme_Code = myStringSchem!.stringByTrimmingCharactersInSet(
                    NSCharacterSet.whitespaceAndNewlineCharacterSet()
                )
                
                let myStringFund_Code = BuyNowScheme.valueForKey("Fund_Code")
                let Fund_Code = myStringFund_Code!.stringByTrimmingCharactersInSet(
                    NSCharacterSet.whitespaceAndNewlineCharacterSet()
                )
                //

//                let isExitst = DBManager.getInstance().checkMFAccountAlreadyExistForSchemeCode(Scheme_Code)
                let isExitst = DBManager.getInstance().checkMFAccountAlreadyExistForSchemeCode(Scheme_Code,fundCode: Fund_Code,ClientId: sharedInstance.objLoginUser.ClientID)

                var dicToSend = NSDictionary()
                
                if isExitst
                {
                    dicToSend = [
                        "Scheme_Code" : Scheme_Code,
                        "Fund_Code" : Fund_Code,
                        "Txn_Type" : MFU_TXN_TYPE_ADDITIONAL_BUY]
                }else{
                    dicToSend = [
                        "Scheme_Code" : Scheme_Code,
                        "Fund_Code" : Fund_Code,
                        "Txn_Type" : MFU_TXN_TYPE_BUY]
                    
                }

                
                WebManagerHK.postDataToURL(kModeGetSchemeThresholdDetails, params: dicToSend, message: "") { (response) in
                    
                    if response.objectForKey(kWAPIResponse) is NSArray
                    {
                        let mainResponse = response.objectForKey(kWAPIResponse) as! NSArray
                        print("Dic Response : \(mainResponse)")
                        
                        if mainResponse.count==0
                        {
                            
                        }
                        else{
                            
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in

                                let dicData = mainResponse.objectAtIndex(0) as! NSDictionary
                            
                                self.minimumAmount = dicData.valueForKey("Min_Amt") as! Int
                                self.multipleAmount = dicData.valueForKey("Multiple_Amt") as! Int

                                self.txtSchemeAmountlblNote.text = "Minimum amount : ₹ \(self.minimumAmount)"
                                
//                                self.randomVal = sharedInstance.getRandomVal()
//
//                                self.tblView.reloadData()

                            })
                        }
                    }else
                    {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            
                            self.tblView.reloadData()
                            
                        })
                    }
                }
            }
            
            
            if let BuyNowScheme = sharedInstance.userDefaults.objectForKey(kSelectBuyNowScheme) as? String
            {
                if lbltxtSchemeName != nil {
                    lbltxtSchemeName.text = BuyNowScheme
                }
            }
        }
        
        if isBuyFrom == kBUY_FROM_SMARTFUND {
            
            if let BuyNowScheme = sharedInstance.userDefaults.objectForKey(kSelectBuyNowScheme) as? NSDictionary
            {
                print(BuyNowScheme)
                randomVal = sharedInstance.getRandomVal()
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    let myStringDivOpt = BuyNowScheme.valueForKey("Div_Opt") //Div_Opt
                    let Div_Opt = myStringDivOpt!.stringByTrimmingCharactersInSet(
                        NSCharacterSet.whitespaceAndNewlineCharacterSet()
                    )
                    if Div_Opt=="NA" { // NA.....
                    }
                    
                    self.checkDetailsForPreselected(BuyNowScheme)
                    
                    self.isNAVAvailable = true
                    
                    if let nav = BuyNowScheme.valueForKey("NAV")
                    {
                        if let nav_date = BuyNowScheme.valueForKey("NAVDate")
                        {
                            let twoDecimalPlaces = String(format: "%.2f", nav as! Double)
                            
                            if (self.txtNavSIP != nil)
                            {
                                self.txtNav.text = "\(twoDecimalPlaces) As On \(sharedInstance.getFormatedDate(nav_date as! String))"
                            }
                            
                            if (self.txtNavSIP != nil)
                            {
                                self.txtNavSIP.text = "\(twoDecimalPlaces) As On \(sharedInstance.getFormatedDate(nav_date as! String))"
                            }
                        }
                    }
                    
                    self.tblView.reloadData()
                    
                })
                
//                if  (self.txtam) {
//                    
//                }
                if (self.lbltxtSchemeName != nil) {
                    lbltxtSchemeName.text = BuyNowScheme.valueForKey("Plan_Name") as? String
                }
                if (lbltxtSchemeNameSIP != nil) {
                    lbltxtSchemeNameSIP.text = BuyNowScheme.valueForKey("Plan_Name") as? String
                }
                
                let myStringSchem = BuyNowScheme.valueForKey("Scheme_Code")
                let Scheme_Code = myStringSchem!.stringByTrimmingCharactersInSet(
                    NSCharacterSet.whitespaceAndNewlineCharacterSet()
                )
                
                let myStringFund_Code = BuyNowScheme.valueForKey("Fund_Code")
                let Fund_Code = myStringFund_Code!.stringByTrimmingCharactersInSet(
                    NSCharacterSet.whitespaceAndNewlineCharacterSet()
                )
                //
                
//                let isExitst = DBManager.getInstance().checkMFAccountAlreadyExistForSchemeCode(Scheme_Code)
                let isExitst = DBManager.getInstance().checkMFAccountAlreadyExistForSchemeCode(Scheme_Code,fundCode: Fund_Code,ClientId: sharedInstance.objLoginUser.ClientID)

                var dicToSend = NSDictionary()
                
                if isExitst
                {
                    dicToSend = [
                        "Scheme_Code" : Scheme_Code,
                        "Fund_Code" : Fund_Code,
                        "Txn_Type" : MFU_TXN_TYPE_ADDITIONAL_BUY]
                }else
                {
                    dicToSend = [
                        "Scheme_Code" : Scheme_Code,
                        "Fund_Code" : Fund_Code,
                        "Txn_Type" : MFU_TXN_TYPE_BUY]
                    
                }
                
                WebManagerHK.postDataToURL(kModeGetSchemeThresholdDetails, params: dicToSend, message: "") { (response) in
                    
                    if response.objectForKey(kWAPIResponse) is NSArray
                    {
                        let mainResponse = response.objectForKey(kWAPIResponse) as! NSArray
                        print("Dic Response : \(mainResponse)")
                        
                        if mainResponse.count==0
                        {
                            
                        }
                        else
                        {
                            
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                
                                let dicData = mainResponse.objectAtIndex(0) as! NSDictionary
                                
                                print(dicData);
                                
                                self.minimumAmount = dicData.valueForKey("Min_Amt") as! Int
                                self.multipleAmount = dicData.valueForKey("Multiple_Amt") as! Int
                                
                                NSLog("%d", self.minimumAmount);
                                self.txtSchemeAmountlblNote.text = "Minimum amount : ₹ \(self.minimumAmount)"
                                
                                self.tblView.reloadData()
                                
                            })
                        }
                    }else
                    {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            
                            self.tblView.reloadData()
                            
                        })
                    }
                }
            }
        }
        
        tblView.reloadData()
        
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

    
    @IBAction func btnHelpClickef(sender: AnyObject) {
        
        let objWebView = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdWebViewController) as! WebViewController
        if self.lblTitle.text=="Buy"
        {
            objWebView.urlLink = NSURL(string:URL_BUY_HELP)!
        }
        else{
            objWebView.urlLink = NSURL(string:URL_SIP_HELP)!
        }
        objWebView.screenTitle = "Help"
        self.navigationController?.pushViewController(objWebView, animated: true)
                
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
        if isBuyFrom==kBUY_FROM_SELECTED_FUND {
            return 4
        }
        if isBuyFrom==kBUY_FROM_FRESH { // kBUY_FROM_FRESH START
            return 4
        }
        if isBuyFrom==kBUY_FOR_SIP { // kBUY_FROM_FRESH START
            return 8
        }
        if isBuyFrom == kBUY_FROM_SMARTFUND {
            return 4
        }
        
        return 6
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        if isBuyFrom==kBUY_FROM_SELECTED_FUND { // kBUY_FROM_SELECTED_FUND START
            
            let planName = "CELL_BUYSIP_SELECTED_FUND_\(indexPath.row)_\(indexPath.section)_\(lblTitle.text)_\(self.isDivAvailable)_\(randomVal)"
            
            let identifier = planName
            
            tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: identifier)
            
            let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as UITableViewCell
            
            cell.selectionStyle = UITableViewCellSelectionStyle.None
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
                    btnOneTimeRadio.addTarget(self, action: #selector(BuyScreeen.btnOneTimeClicked(_:)), forControlEvents: .TouchUpInside)
                    
                    let lblOneTime = UIButton(frame: CGRect(x: 33, y: 5, width: 70, height: 40));
                    lblOneTime.setTitle("One-time", forState: .Normal)
                    lblOneTime.titleLabel?.font = UIFont.systemFontOfSize(14)
                    lblOneTime.setTitleColor(UIColor.blackColor(), forState: .Normal)
                    lblOneTime.addTarget(self, action: #selector(BuyScreeen.btnOneTimeClicked(_:)), forControlEvents: .TouchUpInside)
                    lblOneTime.titleLabel?.textAlignment = .Left
                    lblOneTime.contentHorizontalAlignment = .Left;
                    cell.contentView.addSubview(lblOneTime)
                    
                    
                    btnRoundRadio = UIButton(frame: CGRect(x: 5, y: 5, width: 10, height: 10));
                    btnRoundRadio.layer.cornerRadius = 5
                    btnRoundRadio.layer.borderWidth = 2.0
                    btnRoundRadio.backgroundColor = UIColor.defaultAppColorBlue
                    btnRoundRadio.layer.borderColor = UIColor.defaultAppColorBlue.CGColor
                    btnOneTimeRadio.addSubview(btnRoundRadio)

                    
                    btnSIPRadio = UIButton(frame: CGRect(x: 110, y: 15, width: 20, height: 20));
                    btnSIPRadio.layer.cornerRadius = 10
                    btnSIPRadio.layer.borderWidth = 2.0
                    btnSIPRadio.layer.borderColor = UIColor.lightGrayColor().CGColor
                    cell.contentView.addSubview(btnSIPRadio)
                    btnSIPRadio.addTarget(self, action: #selector(BuyScreeen.btnSIPClicked(_:)), forControlEvents: .TouchUpInside)
                    
                    
                    let lblSIP = UIButton(frame: CGRect(x: 135, y: 5, width: 70, height: 40));
                    lblSIP.setTitle("SIP", forState: .Normal)
                    lblSIP.titleLabel?.font = UIFont.systemFontOfSize(14)
                    lblSIP.setTitleColor(UIColor.blackColor(), forState: .Normal)
                    lblSIP.addTarget(self, action: #selector(BuyScreeen.btnSIPClicked(_:)), forControlEvents: .TouchUpInside)
                    lblSIP.titleLabel?.textAlignment = .Left
                    lblSIP.contentHorizontalAlignment = .Left;
                    cell.contentView.addSubview(lblSIP)
                    
                    return cell;

                case 1:
                    
                    var lblUploadPan : UILabel!
                    lblUploadPan = UILabel(frame: CGRect(x: 10, y: 25, width: (cell.contentView.frame.size.width)-20, height: 25));
//                    lblUploadPan.text = "Enter Scheme Name"
                    lblUploadPan.textColor = UIColor.darkGrayColor()
                    lblUploadPan.font = UIFont.systemFontOfSize(12)
                    cell.contentView.addSubview(lblUploadPan)
                    
                    
                    lbltxtSchemeName = UILabel(frame: CGRect(x: 10, y: 40, width: (cell.contentView.frame.size.width)-50, height: 60));
                    lbltxtSchemeName.text = kEnterSchemeName
                    lbltxtSchemeName.textColor = UIColor.darkGrayColor()
                    lbltxtSchemeName.font = UIFont.systemFontOfSize(16)
                    lbltxtSchemeName.numberOfLines = 2
                    cell.contentView.addSubview(lbltxtSchemeName)
                    
                    
                    print(sharedInstance.userDefaults.objectForKey(kSelectBuyNowScheme))
                    
                    if let BuyFromScheme = sharedInstance.userDefaults.objectForKey(kSelectBuyNowScheme) as? String
                    {
                        print(BuyFromScheme)
                        lbltxtSchemeName.text = BuyFromScheme
                        lbltxtSchemeName.textColor = UIColor(red:0.78, green:0.78, blue:0.78, alpha:1.0)
                    }
                    if let BuyFromScheme = sharedInstance.userDefaults.objectForKey(kSelectBuyNowScheme) as? NSDictionary
                    {
                        print(BuyFromScheme)
                        lblUploadPan.text = "Scheme Name"
                        lbltxtSchemeName.text = BuyFromScheme.valueForKey("Plan_Name") as? String
                        lbltxtSchemeName.textColor = UIColor.blackColor()
                    }
                    
                    
                    btnSchemeName = UIButton(frame: CGRect(x: 10, y: 40, width: (cell.contentView.frame.size.width)-50, height: 60));
                    btnSchemeName.addTarget(self, action: #selector(BuyScreeen.btnBuySchemeNameClicked(_:)), forControlEvents: .TouchUpInside)
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

                    

                    if self.isDivAvailable
                    {
                        
                        // START
                        
                        lblDividendOption = UILabel(frame: CGRect(x: 10, y: 95, width: (cell.contentView.frame.size.width)-20, height: 25));
                        lblDividendOption.text = "Dividend Option"
                        lblDividendOption.textColor = UIColor.darkGrayColor()
                        lblDividendOption.font = UIFont.systemFontOfSize(12)
                        cell.contentView.addSubview(lblDividendOption)
                        
                        txtDividendOption = UITextField(frame: CGRect(x: 10, y: 125, width: 120, height: 35));
                        txtDividendOption.text = DividendOptionBUY.allValues[enumDividendOption.hashValue]
                        txtDividendOption.keyboardType = UIKeyboardType.Default
                        self.applyTextFiledStyle1(txtDividendOption)
                        cell.contentView.addSubview(txtDividendOption)
                        txtDividendOption.inputView = pickerView
                        txtDividendOption.tag = TAG_DIVIDEND_OPTION_BUY
                        txtDividendOption.textColor = UIColor.blackColor()
                        
//                        var imgDownArrowDOP : UIImageView!
//                        imgDownArrowDOP = UIImageView(frame: CGRect(x: 120, y: 125, width: 30, height: 30));
//                        imgDownArrowDOP.image = UIImage(named: "iconDown")
//                        imgDownArrowDOP.backgroundColor = UIColor.clearColor()
//                        cell.contentView.addSubview(imgDownArrowDOP)
                        
                        var lblLineDOP : UILabel!
                        lblLineDOP = UILabel(frame: CGRect(x: 10, y: 155, width: 140, height: 1));
                        lblLineDOP.backgroundColor = UIColor.lightGrayColor()
                        lblLineDOP.alpha = 0.4
                        cell.contentView.addSubview(lblLineDOP)
                        
                        var lblUploadPanNAV : UILabel!
                        lblUploadPanNAV = UILabel(frame: CGRect(x: 10, y: 160, width: (cell.contentView.frame.size.width)-20, height: 25));
                        lblUploadPanNAV.text = "NAV"
                        lblUploadPanNAV.textColor = UIColor.darkGrayColor()
                        lblUploadPanNAV.font = UIFont.systemFontOfSize(12)
                        cell.contentView.addSubview(lblUploadPanNAV)
                        
                        txtNav = RPFloatingPlaceholderTextField(frame: CGRect(x: 6, y: 190, width: (cell.contentView.frame.size.width)-20, height: 35))
//                        UITextField(frame: CGRect(x: 10, y: 190, width: (cell.contentView.frame.size.width)-20, height: 35));
                        txtNav.text = "-"
                        txtNav.keyboardType = UIKeyboardType.Default
                        self.applyTextFiledStyle1(txtNav)
                        cell.contentView.addSubview(txtNav)
                        txtNav.enabled = false
                        txtNav.textColor = UIColor.blackColor()
                        
                        
                        if let BuyFromSchemeInner = sharedInstance.userDefaults.objectForKey(kSelectBuyNowScheme) as? NSDictionary
                        {
                            print(BuyFromSchemeInner)
                            
                            if let nav = BuyFromSchemeInner.valueForKey("NAV")
                            {
                                if let nav_date = BuyFromSchemeInner.valueForKey("NAVDate")
                                {
                                    let twoDecimalPlaces = String(format: "%.2f", nav as! Double)
                                    
                                    if (self.txtNav != nil)
                                    {
                                        self.txtNav.text = "\(twoDecimalPlaces) As On \(sharedInstance.getFormatedDate(nav_date as! String))"
                                    }
                                    
                                    if (self.txtNavSIP != nil)
                                    {
                                        
                                        self.txtNavSIP.text = "\(twoDecimalPlaces) As On \(sharedInstance.getFormatedDate(nav_date as! String))"
                                        
                                    }
                                }
                            }
                        }
                        
                        var lblLineNAV : UILabel!
                        lblLineNAV = UILabel(frame: CGRect(x: 10, y: 225, width: (cell.contentView.frame.size.width)-30, height: 1));
                        lblLineNAV.backgroundColor = UIColor.lightGrayColor()
                        lblLineNAV.alpha = 0.4
                        cell.contentView.addSubview(lblLineNAV)
                        
                        txtSchemeAmount = RPFloatingPlaceholderTextField(frame: CGRect(x: 6, y: 245, width: 200, height: 35))
//                            UITextField(frame: CGRect(x: 10, y: 245, width: 200, height: 35));
                        txtSchemeAmount.text = ""
                        txtSchemeAmount.placeholder = "Enter Amount(₹)"
                        txtSchemeAmount.floatingLabelInactiveTextColor = UIColor.darkGrayColor()
                        txtSchemeAmount.floatingLabelActiveTextColor = UIColor.darkGrayColor()
                        txtSchemeAmount.floatingLabel.font = UIFont.systemFontOfSize(12)
                        txtSchemeAmount.keyboardType = UIKeyboardType.NumberPad
                        addToolBar(txtSchemeAmount)
                        self.applyTextFiledStyle1(txtSchemeAmount)
                        cell.contentView.addSubview(txtSchemeAmount)
                        
                        var lblLine2 : UILabel!
                        lblLine2 = UILabel(frame: CGRect(x: 10, y: 280, width: 200, height: 1));
                        lblLine2.backgroundColor = UIColor.lightGrayColor()
                        lblLine2.alpha = 0.4
                        cell.contentView.addSubview(lblLine2)
                        
                        txtSchemeAmountlblNote = UILabel(frame: CGRect(x: 10, y: 285, width: 200, height: 20));
                        txtSchemeAmountlblNote.text = "Minimum amount : ₹ \(self.minimumAmount)"
                        txtSchemeAmountlblNote.textColor = UIColor.darkGrayColor()
                        txtSchemeAmountlblNote.font = UIFont.italicSystemFontOfSize(11)
                        txtSchemeAmountlblNote.backgroundColor = UIColor.clearColor()
                        txtSchemeAmountlblNote.textAlignment = .Left
                        cell.contentView.addSubview(txtSchemeAmountlblNote)
                        
                        return cell;

                        
                        // END
                    }
                    
                    var lblUploadPanNAV : UILabel!
                    lblUploadPanNAV = UILabel(frame: CGRect(x: 10, y: 100, width: (cell.contentView.frame.size.width)-20, height: 25));
                    lblUploadPanNAV.text = "NAV"
                    lblUploadPanNAV.textColor = UIColor.darkGrayColor()
                    lblUploadPanNAV.font = UIFont.systemFontOfSize(12)
                    cell.contentView.addSubview(lblUploadPanNAV)
                    
                    txtNav = RPFloatingPlaceholderTextField(frame: CGRect(x: 6, y: 125, width: (cell.contentView.frame.size.width)-20, height: 35))
//                        UITextField(frame: CGRect(x: 10, y: 125, width: (cell.contentView.frame.size.width)-20, height: 35));
                    txtNav.text = "-"
                    txtNav.keyboardType = UIKeyboardType.Default
                    self.applyTextFiledStyle1(txtNav)
                    cell.contentView.addSubview(txtNav)
                    txtNav.enabled = false
                    txtNav.textColor = UIColor.blackColor()
                    
                    var lblLineNAV : UILabel!
                    lblLineNAV = UILabel(frame: CGRect(x: 10, y: 160, width: (cell.contentView.frame.size.width)-30, height: 1));
                    lblLineNAV.backgroundColor = UIColor.lightGrayColor()
                    lblLineNAV.alpha = 0.4
                    cell.contentView.addSubview(lblLineNAV)
                    
                    if let BuyNowScheme = sharedInstance.userDefaults.objectForKey(kSelectBuyNowScheme) as? NSDictionary
                    {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            if let nav = BuyNowScheme.valueForKey("NAV")
                            {
                                if let nav_date = BuyNowScheme.valueForKey("NAVDate")
                                {
                                    let twoDecimalPlaces = String(format: "%.2f", nav as! Double)
                                    if (self.txtNav != nil)
                                    {
                                        self.txtNav.text = "\(twoDecimalPlaces) As On \(sharedInstance.getFormatedDate(nav_date as! String))"

                                    }
                                    if (self.txtNavSIP != nil)
                                    {
                                        self.txtNavSIP.text = "\(twoDecimalPlaces) As On \(sharedInstance.getFormatedDate(nav_date as! String))"
                                    }
                                }
                            }
                        })
                    }
                    
                    txtSchemeAmount = RPFloatingPlaceholderTextField(frame: CGRect(x: 6, y: 180, width: 200, height: 35))
//                        UITextField(frame: CGRect(x: 10, y: 170, width: 200, height: 35));
                    txtSchemeAmount.text = ""
                    txtSchemeAmount.placeholder = "Enter Amount(₹)"
                    txtSchemeAmount.floatingLabelInactiveTextColor = UIColor.darkGrayColor()
                    txtSchemeAmount.floatingLabelActiveTextColor = UIColor.darkGrayColor()
                    txtSchemeAmount.floatingLabel.font = UIFont.systemFontOfSize(12)
                    txtSchemeAmount.keyboardType = UIKeyboardType.NumberPad
                    addToolBar(txtSchemeAmount)
                    self.applyTextFiledStyle1(txtSchemeAmount)
                    cell.contentView.addSubview(txtSchemeAmount)
                    
                    var lblLine2 : UILabel!
                    lblLine2 = UILabel(frame: CGRect(x: 10, y: 215, width: 200, height: 1));
                    lblLine2.backgroundColor = UIColor.lightGrayColor()
                    lblLine2.alpha = 0.4
                    cell.contentView.addSubview(lblLine2)
                    
                    txtSchemeAmountlblNote = UILabel(frame: CGRect(x: 10, y: 220, width: 200, height: 20));
                    txtSchemeAmountlblNote.text = "Minimum amount : ₹ \(self.minimumAmount)"
                    txtSchemeAmountlblNote.textColor = UIColor.darkGrayColor()
                    txtSchemeAmountlblNote.font = UIFont.italicSystemFontOfSize(11)
                    txtSchemeAmountlblNote.backgroundColor = UIColor.clearColor()
                    txtSchemeAmountlblNote.textAlignment = .Left
                    cell.contentView.addSubview(txtSchemeAmountlblNote)
                    
                    return cell;
                    
                case 2:
                    
                    var lblLine : UILabel!
                    lblLine = UILabel(frame: CGRect(x: 10, y: 0, width: (cell.contentView.frame.size.width)-20, height: 1));
                    lblLine.backgroundColor = UIColor.lightGrayColor()
                    lblLine.alpha = 0.4
                    cell.contentView.addSubview(lblLine)
                    
                    let txtPan = UILabel(frame: CGRect(x: 10, y: 5, width: (cell.contentView.frame.size.width)-40, height: 35));
                    txtPan.text = "MF investments are subject to market risk. Please read SID carefully before investing."
                    txtPan.textColor = UIColor.darkGrayColor()
                    txtPan.font = UIFont.italicSystemFontOfSize(11)
                    txtPan.backgroundColor = UIColor.clearColor()
                    txtPan.numberOfLines = 2
                    cell.contentView.addSubview(txtPan)
                    
                    return cell;
                    
                case 3:
                    
                    btnBuyNow = UIButton(frame: CGRect(x: cell.contentView.frame.size.width-84, y: 10, width: 76, height: 36))
                    btnBuyNow.setTitle("BUY NOW", forState: .Normal)
                    btnBuyNow.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                    btnBuyNow.backgroundColor = UIColor.defaultOrangeButton
                    btnBuyNow.titleLabel?.font = UIFont.systemFontOfSize(14)
                    btnBuyNow.layer.cornerRadius = 1.5
                    btnBuyNow.addTarget(self, action: #selector(BuyScreeen.btnBuyNowClicked(_:)), forControlEvents: .TouchUpInside)
                    cell.contentView.addSubview(btnBuyNow)
                    
                    btnReset = UIButton(frame: CGRect(x: cell.contentView.frame.size.width-(84*2), y: 10, width: 76, height: 36))
                    btnReset.setTitle("RESET", forState: .Normal)
                    btnReset.setTitleColor(UIColor.defaultOrangeButton, forState: .Normal)
                    btnReset.backgroundColor = UIColor.whiteColor()
                    btnReset.titleLabel?.font = UIFont.systemFontOfSize(14)
                    btnReset.layer.cornerRadius = 1.5
                    btnReset.layer.borderColor = UIColor.defaultOrangeButton.CGColor
                    btnReset.layer.borderWidth = 1.0
                    btnReset.addTarget(self, action: #selector(BuyScreeen.btnResetClicked(_:)), forControlEvents: .TouchUpInside)
                    cell.contentView.addSubview(btnReset)
                    
                    cell.selectionStyle = UITableViewCellSelectionStyle.None
                    cell.contentView.backgroundColor = UIColor.clearColor()
                    cell.backgroundColor = UIColor.clearColor()
                    
                    return cell;
                    
                    
                default:
                    break;
                }
                
            }else{
            }

            
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.contentView.backgroundColor = UIColor.defaultAppBackground
            cell.backgroundColor = UIColor.defaultAppBackground
            
            return cell;

        } // // kBUY_FROM_SELECTED_FUND END

        
        if isBuyFrom==kBUY_FROM_SMARTFUND { // kBUY_FROM_SMART_FUND START
            
            let planName = "CELL_BUYSIP_SELECTED_FUND_\(indexPath.row)_\(indexPath.section)_\(lblTitle.text)_\(self.isDivAvailable)_\(randomVal)"
            
            let identifier = planName
            
            tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: identifier)
            
            let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as UITableViewCell
            
            cell.selectionStyle = .None
            
            if (cell.contentView.subviews.count==0) {
                
                switch indexPath.row {
                case 0:
                    
                    btnOneTimeRadio = UIButton(frame: CGRect(x: 10, y: 15, width: 20, height: 20));
                    btnOneTimeRadio.layer.cornerRadius = 10
                    btnOneTimeRadio.layer.borderWidth = 2.0
                    btnOneTimeRadio.layer.borderColor = UIColor.defaultAppColorBlue.CGColor
                    cell.contentView.addSubview(btnOneTimeRadio)
                    btnOneTimeRadio.addTarget(self, action: #selector(BuyScreeen.btnOneTimeClicked(_:)), forControlEvents: .TouchUpInside)
                    
                    let lblOneTime = UIButton(frame: CGRect(x: 33, y: 5, width: 70, height: 40));
                    lblOneTime.setTitle("One-time", forState: .Normal)
                    lblOneTime.titleLabel?.font = UIFont.systemFontOfSize(14)
                    lblOneTime.setTitleColor(UIColor.blackColor(), forState: .Normal)
                    lblOneTime.addTarget(self, action: #selector(BuyScreeen.btnOneTimeClicked(_:)), forControlEvents: .TouchUpInside)
                    lblOneTime.titleLabel?.textAlignment = .Left
                    lblOneTime.contentHorizontalAlignment = .Left;
                    cell.contentView.addSubview(lblOneTime)
                    
                    
                    btnRoundRadio = UIButton(frame: CGRect(x: 5, y: 5, width: 10, height: 10));
                    btnRoundRadio.layer.cornerRadius = 5
                    btnRoundRadio.layer.borderWidth = 2.0
                    btnRoundRadio.backgroundColor = UIColor.defaultAppColorBlue
                    btnRoundRadio.layer.borderColor = UIColor.defaultAppColorBlue.CGColor
                    btnOneTimeRadio.addSubview(btnRoundRadio)
                    
                    
                    btnSIPRadio = UIButton(frame: CGRect(x: 110, y: 15, width: 20, height: 20));
                    btnSIPRadio.layer.cornerRadius = 10
                    btnSIPRadio.layer.borderWidth = 2.0
                    btnSIPRadio.layer.borderColor = UIColor.lightGrayColor().CGColor
                    cell.contentView.addSubview(btnSIPRadio)
                    btnSIPRadio.addTarget(self, action: #selector(BuyScreeen.btnSIPClicked(_:)), forControlEvents: .TouchUpInside)
                    
                    
                    let lblSIP = UIButton(frame: CGRect(x: 135, y: 5, width: 70, height: 40));
                    lblSIP.setTitle("SIP", forState: .Normal)
                    lblSIP.titleLabel?.font = UIFont.systemFontOfSize(14)
                    lblSIP.setTitleColor(UIColor.blackColor(), forState: .Normal)
                    lblSIP.addTarget(self, action: #selector(BuyScreeen.btnSIPClicked(_:)), forControlEvents: .TouchUpInside)
                    lblSIP.titleLabel?.textAlignment = .Left
                    lblSIP.contentHorizontalAlignment = .Left;
                    cell.contentView.addSubview(lblSIP)
                    
                    return cell;
                    
                case 1:
                    
                    var lblUploadPan : UILabel!
                    lblUploadPan = UILabel(frame: CGRect(x: 10, y: 25, width: (cell.contentView.frame.size.width)-20, height: 25));
//                    lblUploadPan.text = "Enter Scheme Name"
                    lblUploadPan.textColor = UIColor.darkGrayColor()
                    lblUploadPan.font = UIFont.systemFontOfSize(12)
                    cell.contentView.addSubview(lblUploadPan)
                    
                    
                    lbltxtSchemeName = UILabel(frame: CGRect(x: 10, y: 40, width: (cell.contentView.frame.size.width)-50, height: 60));
                    lbltxtSchemeName.text = kEnterSchemeName
                    lbltxtSchemeName.textColor = UIColor.darkGrayColor()
                    lbltxtSchemeName.font = UIFont.systemFontOfSize(16)
                    lbltxtSchemeName.numberOfLines = 2
                    cell.contentView.addSubview(lbltxtSchemeName)
                    
                    
                    print(sharedInstance.userDefaults.objectForKey(kSelectBuyNowScheme))
                    
                    if let BuyFromScheme = sharedInstance.userDefaults.objectForKey(kSelectBuyNowScheme) as? String
                    {
                        print(BuyFromScheme)
                        lbltxtSchemeName.text = BuyFromScheme
                        lbltxtSchemeName.textColor = UIColor(red:0.78, green:0.78, blue:0.78, alpha:1.0)
                    }
                    if let BuyFromScheme = sharedInstance.userDefaults.objectForKey(kSelectBuyNowScheme) as? NSDictionary
                    {
                        print(BuyFromScheme)
                        lblUploadPan.text = "Scheme Name"
                        lbltxtSchemeName.text = BuyFromScheme.valueForKey("Plan_Name") as? String
                        lbltxtSchemeName.textColor = UIColor.blackColor()
                    }
                    
                    
                    btnSchemeName = UIButton(frame: CGRect(x: 10, y: 40, width: (cell.contentView.frame.size.width)-50, height: 60));
                    btnSchemeName.addTarget(self, action: #selector(BuyScreeen.btnBuySchemeNameClicked(_:)), forControlEvents: .TouchUpInside)
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
                    
                    
                    
                    if self.isDivAvailable
                    {
                        
                        // START
                        
                        lblDividendOption = UILabel(frame: CGRect(x: 10, y: 95, width: (cell.contentView.frame.size.width)-20, height: 25));
                        lblDividendOption.text = "Dividend Option"
                        lblDividendOption.textColor = UIColor.darkGrayColor()
                        lblDividendOption.font = UIFont.systemFontOfSize(12)
                        cell.contentView.addSubview(lblDividendOption)
                        
                        txtDividendOption = UITextField(frame: CGRect(x: 10, y: 125, width: 120, height: 35));
                        txtDividendOption.text = DividendOptionBUY.allValues[enumDividendOption.hashValue]
                        txtDividendOption.keyboardType = UIKeyboardType.Default
                        self.applyTextFiledStyle1(txtDividendOption)
                        cell.contentView.addSubview(txtDividendOption)
                        txtDividendOption.inputView = pickerView
                        txtDividendOption.tag = TAG_DIVIDEND_OPTION_BUY
                        txtDividendOption.textColor = UIColor.blackColor()
                        
                        var imgDownArrowDOP : UIImageView!
                        imgDownArrowDOP = UIImageView(frame: CGRect(x: 120, y: 125, width: 30, height: 30));
                        imgDownArrowDOP.image = UIImage(named: "iconDown")
                        imgDownArrowDOP.backgroundColor = UIColor.clearColor()
                        cell.contentView.addSubview(imgDownArrowDOP)
                        
                        var lblLineDOP : UILabel!
                        lblLineDOP = UILabel(frame: CGRect(x: 10, y: 155, width: 140, height: 1));
                        lblLineDOP.backgroundColor = UIColor.lightGrayColor()
                        lblLineDOP.alpha = 0.4
                        cell.contentView.addSubview(lblLineDOP)
                        
                        var lblUploadPanNAV : UILabel!
                        lblUploadPanNAV = UILabel(frame: CGRect(x: 10, y: 160, width: (cell.contentView.frame.size.width)-20, height: 25));
                        lblUploadPanNAV.text = "NAV"
                        lblUploadPanNAV.textColor = UIColor.darkGrayColor()
                        lblUploadPanNAV.font = UIFont.systemFontOfSize(12)
                        cell.contentView.addSubview(lblUploadPanNAV)
                        
                        txtNav = RPFloatingPlaceholderTextField(frame: CGRect(x: 6, y: 190, width: (cell.contentView.frame.size.width)-20, height: 35))
//                            UITextField(frame: CGRect(x: 10, y: 190, width: (cell.contentView.frame.size.width)-20, height: 35));
                        txtNav.text = "-"
                        txtNav.keyboardType = UIKeyboardType.Default
                        self.applyTextFiledStyle1(txtNav)
                        cell.contentView.addSubview(txtNav)
                        txtNav.enabled = false
                        txtNav.textColor = UIColor.blackColor()
                        
                        
                        if let BuyFromSchemeInner = sharedInstance.userDefaults.objectForKey(kSelectBuyNowScheme) as? NSDictionary
                        {
                            print(BuyFromSchemeInner)
                            
                            if let nav = BuyFromSchemeInner.valueForKey("NAV")
                            {
                                if let nav_date = BuyFromSchemeInner.valueForKey("NAVDate")
                                {
                                    let twoDecimalPlaces = String(format: "%.2f", nav as! Double)
                                    
                                    if (self.txtNav != nil)
                                    {
                                        self.txtNav.text = "\(twoDecimalPlaces) As On \(sharedInstance.getFormatedDate(nav_date as! String))"
                                    }
                                    
                                    if (self.txtNavSIP != nil)
                                    {
                                        
                                        self.txtNavSIP.text = "\(twoDecimalPlaces) As On \(sharedInstance.getFormatedDate(nav_date as! String))"
                                        
                                    }
                                }
                            }
                            
                            
                        }
                        
                        var lblLineNAV : UILabel!
                        lblLineNAV = UILabel(frame: CGRect(x: 10, y: 225, width: (cell.contentView.frame.size.width)-30, height: 1));
                        lblLineNAV.backgroundColor = UIColor.lightGrayColor()
                        lblLineNAV.alpha = 0.4
                        cell.contentView.addSubview(lblLineNAV)
                        
                        txtSchemeAmount = RPFloatingPlaceholderTextField(frame: CGRect(x: 6, y: 245, width: 200, height: 35))
//                            UITextField(frame: CGRect(x: 10, y: 245, width: 200, height: 35));
                        txtSchemeAmount.text = sharedInstance.userDefaults.objectForKey(kSelectBuyNowScheme)?.valueForKey("Scheme_Amount") as? String
                        txtSchemeAmount.placeholder = "Enter Amount(₹)"
                        txtSchemeAmount.floatingLabelInactiveTextColor = UIColor.darkGrayColor()
                        txtSchemeAmount.floatingLabelActiveTextColor = UIColor.darkGrayColor()
                        txtSchemeAmount.floatingLabel.font = UIFont.systemFontOfSize(12)
                        txtSchemeAmount.keyboardType = UIKeyboardType.NumberPad
                        addToolBar(txtSchemeAmount)
                        self.applyTextFiledStyle1(txtSchemeAmount)
                        cell.contentView.addSubview(txtSchemeAmount)
                        
                        var lblLine2 : UILabel!
                        lblLine2 = UILabel(frame: CGRect(x: 10, y: 280, width: 200, height: 1));
                        lblLine2.backgroundColor = UIColor.lightGrayColor()
                        lblLine2.alpha = 0.4
                        cell.contentView.addSubview(lblLine2)
                        
                        txtSchemeAmountlblNote = UILabel(frame: CGRect(x: 10, y: 285, width: 200, height: 20));
                        txtSchemeAmountlblNote.text = "Minimum amount : ₹ \(self.minimumAmount)"
                        txtSchemeAmountlblNote.textColor = UIColor.darkGrayColor()
                        txtSchemeAmountlblNote.font = UIFont.italicSystemFontOfSize(11)
                        txtSchemeAmountlblNote.backgroundColor = UIColor.clearColor()
                        txtSchemeAmountlblNote.textAlignment = .Left
                        cell.contentView.addSubview(txtSchemeAmountlblNote)
                        
                        return cell;
                        
                        
                        // END
                    }
                    
                    var lblUploadPanNAV : UILabel!
                    lblUploadPanNAV = UILabel(frame: CGRect(x: 10, y: 100, width: (cell.contentView.frame.size.width)-20, height: 25));
                    lblUploadPanNAV.text = "NAV"
                    lblUploadPanNAV.textColor = UIColor.darkGrayColor()
                    lblUploadPanNAV.font = UIFont.systemFontOfSize(12)
                    cell.contentView.addSubview(lblUploadPanNAV)
                    
                    txtNav = RPFloatingPlaceholderTextField(frame: CGRect(x: 6, y: 125, width: (cell.contentView.frame.size.width)-20, height: 35))
//                        UITextField(frame: CGRect(x: 10, y: 125, width: (cell.contentView.frame.size.width)-20, height: 35));
                    txtNav.text = "-"
                    txtNav.keyboardType = UIKeyboardType.Default
                    self.applyTextFiledStyle1(txtNav)
                    cell.contentView.addSubview(txtNav)
                    txtNav.enabled = false
                    txtNav.textColor = UIColor.blackColor()
                    
                    var lblLineNAV : UILabel!
                    lblLineNAV = UILabel(frame: CGRect(x: 10, y: 160, width: (cell.contentView.frame.size.width)-30, height: 1));
                    lblLineNAV.backgroundColor = UIColor.lightGrayColor()
                    lblLineNAV.alpha = 0.4
                    cell.contentView.addSubview(lblLineNAV)
                    
                    if let BuyNowScheme = sharedInstance.userDefaults.objectForKey(kSelectBuyNowScheme) as? NSDictionary
                    {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            if let nav = BuyNowScheme.valueForKey("NAV")
                            {
                                if let nav_date = BuyNowScheme.valueForKey("NAVDate")
                                {
                                    let twoDecimalPlaces = String(format: "%.2f", nav as! Double)
                                    if (self.txtNav != nil)
                                    {
                                        self.txtNav.text = "\(twoDecimalPlaces) As On \(sharedInstance.getFormatedDate(nav_date as! String))"
                                        
                                    }
                                    if (self.txtNavSIP != nil)
                                    {
                                        self.txtNavSIP.text = "\(twoDecimalPlaces) As On \(sharedInstance.getFormatedDate(nav_date as! String))"
                                    }
                                }
                            }
                        })
                        
                    }
                    
                    
                    txtSchemeAmount = RPFloatingPlaceholderTextField(frame: CGRect(x: 6, y: 180, width: 200, height: 35))
//                        UITextField(frame: CGRect(x: 10, y: 170, width: 200, height: 35));
                    txtSchemeAmount.text = sharedInstance.userDefaults.objectForKey(kSelectBuyNowScheme)?.valueForKey("Scheme_Amount") as? String
                    txtSchemeAmount.placeholder = "Enter Amount(₹)"
                    txtSchemeAmount.floatingLabelInactiveTextColor = UIColor.darkGrayColor()
                    txtSchemeAmount.floatingLabelActiveTextColor = UIColor.darkGrayColor()
                    txtSchemeAmount.floatingLabel.font = UIFont.systemFontOfSize(12)
                    txtSchemeAmount.keyboardType = UIKeyboardType.NumberPad
                    addToolBar(txtSchemeAmount)
                    self.applyTextFiledStyle1(txtSchemeAmount)
                    cell.contentView.addSubview(txtSchemeAmount)
                    
                    var lblLine2 : UILabel!
                    lblLine2 = UILabel(frame: CGRect(x: 10, y: 215, width: 200, height: 1));
                    lblLine2.backgroundColor = UIColor.lightGrayColor()
                    lblLine2.alpha = 0.4
                    cell.contentView.addSubview(lblLine2)
                    
                    txtSchemeAmountlblNote = UILabel(frame: CGRect(x: 10, y: 220, width: 200, height: 20));
                    txtSchemeAmountlblNote.text = "Minimum amount : ₹ \(self.minimumLumpsumAmount)"
                    txtSchemeAmountlblNote.textColor = UIColor.darkGrayColor()
                    txtSchemeAmountlblNote.font = UIFont.italicSystemFontOfSize(11)
                    txtSchemeAmountlblNote.backgroundColor = UIColor.clearColor()
                    txtSchemeAmountlblNote.textAlignment = .Left
                    cell.contentView.addSubview(txtSchemeAmountlblNote)
                    
                    return cell;
                    
                    
                    
                    
                    
                    
                case 2:
                    
                    var lblLine : UILabel!
                    lblLine = UILabel(frame: CGRect(x: 10, y: 0, width: (cell.contentView.frame.size.width)-20, height: 1));
                    lblLine.backgroundColor = UIColor.lightGrayColor()
                    lblLine.alpha = 0.4
                    cell.contentView.addSubview(lblLine)
                    
                    let txtPan = UILabel(frame: CGRect(x: 10, y: 5, width: (cell.contentView.frame.size.width)-40, height: 35));
                    txtPan.text = "MF investments are subject to market risk. Please read SID carefully before investing."
                    txtPan.textColor = UIColor.darkGrayColor()
                    txtPan.font = UIFont.italicSystemFontOfSize(11)
                    txtPan.backgroundColor = UIColor.clearColor()
                    txtPan.numberOfLines = 2
                    cell.contentView.addSubview(txtPan)
                    
                    return cell;
                    
                case 3:
                    
                    btnBuyNow = UIButton(frame: CGRect(x: cell.contentView.frame.size.width-84, y: 10, width: 76, height: 36))
                    btnBuyNow.setTitle("BUY NOW", forState: .Normal)
                    btnBuyNow.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                    btnBuyNow.backgroundColor = UIColor.defaultOrangeButton
                    btnBuyNow.titleLabel?.font = UIFont.systemFontOfSize(14)
                    btnBuyNow.layer.cornerRadius = 1.5
                    btnBuyNow.addTarget(self, action: #selector(BuyScreeen.btnBuyNowClicked(_:)), forControlEvents: .TouchUpInside)
                    cell.contentView.addSubview(btnBuyNow)
                    
                    btnReset = UIButton(frame: CGRect(x: cell.contentView.frame.size.width-(84*2), y: 10, width: 76, height: 36))
                    btnReset.setTitle("RESET", forState: .Normal)
                    btnReset.setTitleColor(UIColor.defaultOrangeButton, forState: .Normal)
                    btnReset.backgroundColor = UIColor.whiteColor()
                    btnReset.titleLabel?.font = UIFont.systemFontOfSize(14)
                    btnReset.layer.cornerRadius = 1.5
                    btnReset.layer.borderColor = UIColor.defaultOrangeButton.CGColor
                    btnReset.layer.borderWidth = 1.0
                    btnReset.addTarget(self, action: #selector(BuyScreeen.btnResetClicked(_:)), forControlEvents: .TouchUpInside)
                    cell.contentView.addSubview(btnReset)
                    
                    cell.selectionStyle = UITableViewCellSelectionStyle.None
                    cell.contentView.backgroundColor = UIColor.clearColor()
                    cell.backgroundColor = UIColor.clearColor()
                    
                    return cell;
                    
                    
                default:
                    break;
                }
                
            }else{
            }
            
            
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.contentView.backgroundColor = UIColor.clearColor()
            cell.backgroundColor = UIColor.clearColor()
            
            return cell;
            
        } // // kBUY_FROM_SMART_FUND END
        
        
        if isBuyFrom==kBUY_FROM_FRESH { // kBUY_FROM_FRESH START


            let planName = "CELL_BUYSIP_\(indexPath.row)_\(indexPath.section)_\(lblTitle.text)_\(self.isDivAvailable)_\(self.isNAVAvailable)_\(randomVal)"
            
            var identifier = planName 
            
            if let BuyFromScheme = sharedInstance.userDefaults.objectForKey(kSelectBuyNowScheme) as? String
            {
                identifier = identifier + BuyFromScheme
            }
            if let BuyFromScheme = sharedInstance.userDefaults.objectForKey(kSelectBuyNowScheme) as? NSDictionary
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
                    btnOneTimeRadio.addTarget(self, action: #selector(BuyScreeen.btnOneTimeClicked(_:)), forControlEvents: .TouchUpInside)
                    
                    let lblOneTime = UIButton(frame: CGRect(x: 33, y: 5, width: 70, height: 40));
                    lblOneTime.setTitle("One-time", forState: .Normal)
                    lblOneTime.titleLabel?.font = UIFont.systemFontOfSize(14)
                    lblOneTime.setTitleColor(UIColor.blackColor(), forState: .Normal)
                    lblOneTime.addTarget(self, action: #selector(BuyScreeen.btnOneTimeClicked(_:)), forControlEvents: .TouchUpInside)
                    lblOneTime.titleLabel?.textAlignment = .Left
                    lblOneTime.contentHorizontalAlignment = .Left;
                    cell.contentView.addSubview(lblOneTime)
                    
                    
                    btnSIPRadio = UIButton(frame: CGRect(x: 110, y: 15, width: 20, height: 20));
                    btnSIPRadio.layer.cornerRadius = 10
                    btnSIPRadio.layer.borderWidth = 2.0
                    btnSIPRadio.layer.borderColor = UIColor.lightGrayColor().CGColor
                    cell.contentView.addSubview(btnSIPRadio)
                    btnSIPRadio.addTarget(self, action: #selector(BuyScreeen.btnSIPClicked(_:)), forControlEvents: .TouchUpInside)
                    
                    let lblSIP = UIButton(frame: CGRect(x: 135, y: 5, width: 70, height: 40));
                    lblSIP.setTitle("SIP", forState: .Normal)
                    lblSIP.titleLabel?.font = UIFont.systemFontOfSize(14)
                    lblSIP.setTitleColor(UIColor.blackColor(), forState: .Normal)
                    lblSIP.addTarget(self, action: #selector(BuyScreeen.btnSIPClicked(_:)), forControlEvents: .TouchUpInside)
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
//                    lblUploadPan.text = "Enter Scheme Name"
                    lblUploadPan.textColor = UIColor.darkGrayColor()
                    lblUploadPan.font = UIFont.systemFontOfSize(12)
                    cell.contentView.addSubview(lblUploadPan)
                    
                    
                    lbltxtSchemeName = UILabel(frame: CGRect(x: 10, y: 40, width: (cell.contentView.frame.size.width)-50, height: 60));
                    lbltxtSchemeName.text = kEnterSchemeName
                    lbltxtSchemeName.textColor = UIColor.darkGrayColor()
                    lbltxtSchemeName.font = UIFont.systemFontOfSize(16)
                    lbltxtSchemeName.numberOfLines = 2
                    cell.contentView.addSubview(lbltxtSchemeName)
                    
                    
                    if let BuyFromScheme = sharedInstance.userDefaults.objectForKey(kSelectBuyNowScheme) as? String
                    {
                        print(BuyFromScheme)
                        lbltxtSchemeName.text = BuyFromScheme
                        lbltxtSchemeName.textColor = UIColor(red:0.78, green:0.78, blue:0.78, alpha:1.0)
                    }
                    if let BuyFromScheme = sharedInstance.userDefaults.objectForKey(kSelectBuyNowScheme) as? NSDictionary
                    {
                        print(BuyFromScheme)
                        lblUploadPan.text = "Enter Scheme Name"
                        lbltxtSchemeName.text = BuyFromScheme.valueForKey("Plan_Name") as? String
                        lbltxtSchemeName.textColor = UIColor.blackColor()
                    }
                    
                    btnSchemeName = UIButton(frame: CGRect(x: 10, y: 40, width: (cell.contentView.frame.size.width)-20, height: 60));
                    btnSchemeName.addTarget(self, action: #selector(BuyScreeen.btnBuySchemeNameClicked(_:)), forControlEvents: .TouchUpInside)
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
                    
                    
                    if self.isDivAvailable {
                        
                        lblDividendOption = UILabel(frame: CGRect(x: 10, y: 95, width: (cell.contentView.frame.size.width)-20, height: 25));
                        lblDividendOption.text = "Dividend Option"
                        lblDividendOption.textColor = UIColor.darkGrayColor()
                        lblDividendOption.font = UIFont.systemFontOfSize(12)
                        cell.contentView.addSubview(lblDividendOption)
                        
                        txtDividendOption = UITextField(frame: CGRect(x: 10, y: 125, width: 120, height: 35));
                        txtDividendOption.text = DividendOptionBUY.allValues[enumDividendOption.hashValue]
                        txtDividendOption.keyboardType = UIKeyboardType.Default
                        self.applyTextFiledStyle1(txtDividendOption)
                        cell.contentView.addSubview(txtDividendOption)
                        txtDividendOption.inputView = pickerView
                        txtDividendOption.tag = TAG_DIVIDEND_OPTION_BUY
                        txtDividendOption.textColor = UIColor.blackColor()
                        
                        var imgDownArrowDOP : UIImageView!
                        imgDownArrowDOP = UIImageView(frame: CGRect(x: 120, y: 125, width: 30, height: 30));
                        imgDownArrowDOP.image = UIImage(named: "iconDown")
                        imgDownArrowDOP.backgroundColor = UIColor.clearColor()
                        cell.contentView.addSubview(imgDownArrowDOP)
                        
                        var lblLineDOP : UILabel!
                        lblLineDOP = UILabel(frame: CGRect(x: 10, y: 155, width: 140, height: 1));
                        lblLineDOP.backgroundColor = UIColor.lightGrayColor()
                        lblLineDOP.alpha = 0.4
                        cell.contentView.addSubview(lblLineDOP)
                        
                        var lblUploadPanNAV : UILabel!
                        lblUploadPanNAV = UILabel(frame: CGRect(x: 10, y: 160, width: (cell.contentView.frame.size.width)-20, height: 25));
                        lblUploadPanNAV.text = "NAV"
                        lblUploadPanNAV.textColor = UIColor.darkGrayColor()
                        lblUploadPanNAV.font = UIFont.systemFontOfSize(12)
                        cell.contentView.addSubview(lblUploadPanNAV)
                        
                        txtNav = RPFloatingPlaceholderTextField(frame: CGRect(x: 6, y: 190, width: (cell.contentView.frame.size.width)-20, height: 35))
//                            UITextField(frame: CGRect(x: 10, y: 190, width: (cell.contentView.frame.size.width)-20, height: 35));
                        txtNav.text = "-"
                        txtNav.keyboardType = UIKeyboardType.Default
                        self.applyTextFiledStyle1(txtNav)
                        cell.contentView.addSubview(txtNav)
                        txtNav.enabled = false
                        txtNav.textColor = UIColor.blackColor()
                        
                        
                        if let BuyFromSchemeInner = sharedInstance.userDefaults.objectForKey(kSelectBuyNowScheme) as? NSDictionary
                        {
                            print(BuyFromSchemeInner)
                            
                            if let nav = BuyFromSchemeInner.valueForKey("NAV")
                            {
                                if let nav_date = BuyFromSchemeInner.valueForKey("NAVDate")
                                {
                                    let twoDecimalPlaces = String(format: "%.2f", nav as! Double)
                                    
                                    if (self.txtNav != nil)
                                    {
                                        self.txtNav.text = "\(twoDecimalPlaces) As On \(sharedInstance.getFormatedDate(nav_date as! String))"
                                    }
                                    
                                    if (self.txtNavSIP != nil)
                                    {
                                        
                                        self.txtNavSIP.text = "\(twoDecimalPlaces) As On \(sharedInstance.getFormatedDate(nav_date as! String))"
                                        
                                    }
                                }
                            }

                        }

                        
                        
                        var lblLineNAV : UILabel!
                        lblLineNAV = UILabel(frame: CGRect(x: 10, y: 225, width: (cell.contentView.frame.size.width)-30, height: 1));
                        lblLineNAV.backgroundColor = UIColor.lightGrayColor()
                        lblLineNAV.alpha = 0.4
                        cell.contentView.addSubview(lblLineNAV)
                        
                        txtSchemeAmount = RPFloatingPlaceholderTextField(frame: CGRect(x: 6, y: 245, width: 200, height: 35))
//                            UITextField(frame: CGRect(x: 10, y: 245, width: 200, height: 35));
                        txtSchemeAmount.text = ""
                        txtSchemeAmount.placeholder = "Enter Amount(₹)"
                        txtSchemeAmount.floatingLabelInactiveTextColor = UIColor.darkGrayColor()
                        txtSchemeAmount.floatingLabelActiveTextColor = UIColor.darkGrayColor()
                        txtSchemeAmount.floatingLabel.font = UIFont.systemFontOfSize(12)
                        txtSchemeAmount.keyboardType = UIKeyboardType.NumberPad
                        addToolBar(txtSchemeAmount)
                        self.applyTextFiledStyle1(txtSchemeAmount)
                        cell.contentView.addSubview(txtSchemeAmount)
                        
                        var lblLine2 : UILabel!
                        lblLine2 = UILabel(frame: CGRect(x: 10, y: 280, width: 200, height: 1));
                        lblLine2.backgroundColor = UIColor.lightGrayColor()
                        lblLine2.alpha = 0.4
                        cell.contentView.addSubview(lblLine2)
                        
                        txtSchemeAmountlblNote = UILabel(frame: CGRect(x: 10, y: 285, width: 200, height: 20));
                        txtSchemeAmountlblNote.text = "Minimum amount : ₹ \(self.minimumAmount)"
                        txtSchemeAmountlblNote.textColor = UIColor.darkGrayColor()
                        txtSchemeAmountlblNote.font = UIFont.italicSystemFontOfSize(11)
                        txtSchemeAmountlblNote.backgroundColor = UIColor.clearColor()
                        txtSchemeAmountlblNote.textAlignment = .Left
                        cell.contentView.addSubview(txtSchemeAmountlblNote)
                        
                        return cell;

                    }
                    
                    if self.isNAVAvailable
                    {
                        var lblUploadPanNAV : UILabel!
                        lblUploadPanNAV = UILabel(frame: CGRect(x: 10, y: 95, width: (cell.contentView.frame.size.width)-20, height: 25));
                        lblUploadPanNAV.text = "NAV"
                        lblUploadPanNAV.textColor = UIColor.darkGrayColor()
                        lblUploadPanNAV.font = UIFont.systemFontOfSize(12)
                        cell.contentView.addSubview(lblUploadPanNAV)
                        
                        txtNav = RPFloatingPlaceholderTextField(frame: CGRect(x: 6, y: 125, width: (cell.contentView.frame.size.width)-20, height: 35))
//                            UITextField(frame: CGRect(x: 10, y: 125, width: (cell.contentView.frame.size.width)-20, height: 35));
                        txtNav.text = "-"
                        txtNav.keyboardType = UIKeyboardType.Default
                        self.applyTextFiledStyle1(txtNav)
                        cell.contentView.addSubview(txtNav)
                        txtNav.enabled = false
                        txtNav.textColor = UIColor.blackColor()
                        
                        if let BuyFromSchemeInner = sharedInstance.userDefaults.objectForKey(kSelectBuyNowScheme) as? NSDictionary
                        {
                            print(BuyFromSchemeInner)
                            
                            if let nav = BuyFromSchemeInner.valueForKey("NAV")
                            {
                                if let nav_date = BuyFromSchemeInner.valueForKey("NAVDate")
                                {
                                    let twoDecimalPlaces = String(format: "%.2f", nav as! Double)
                                    
                                    if (self.txtNav != nil)
                                    {
                                        self.txtNav.text = "\(twoDecimalPlaces) As On \(sharedInstance.getFormatedDate(nav_date as! String))"
                                    }
                                    
                                    if (self.txtNavSIP != nil)
                                    {
                                        
                                        self.txtNavSIP.text = "\(twoDecimalPlaces) As On \(sharedInstance.getFormatedDate(nav_date as! String))"
                                        
                                    }
                                }
                            }
                            
                        }

                        
                        var lblLineNAV : UILabel!
                        lblLineNAV = UILabel(frame: CGRect(x: 10, y: 160, width: (cell.contentView.frame.size.width)-30, height: 1));
                        lblLineNAV.backgroundColor = UIColor.lightGrayColor()
                        lblLineNAV.alpha = 0.4
                        cell.contentView.addSubview(lblLineNAV)
                        
                        txtSchemeAmount = RPFloatingPlaceholderTextField(frame: CGRect(x: 6, y: 180, width: 200, height: 35))
//                            UITextField(frame: CGRect(x: 10, y: 180, width: 200, height: 35));
                        txtSchemeAmount.text = ""
                        txtSchemeAmount.placeholder = "Enter Amount(₹)"
                        txtSchemeAmount.floatingLabelInactiveTextColor = UIColor.darkGrayColor()
                        txtSchemeAmount.floatingLabelActiveTextColor = UIColor.darkGrayColor()
                        txtSchemeAmount.floatingLabel.font = UIFont.systemFontOfSize(12)
                        txtSchemeAmount.keyboardType = UIKeyboardType.NumberPad
                        addToolBar(txtSchemeAmount)
                        self.applyTextFiledStyle1(txtSchemeAmount)
                        cell.contentView.addSubview(txtSchemeAmount)
                        
                        var lblLine2 : UILabel!
                        lblLine2 = UILabel(frame: CGRect(x: 10, y: 215, width: 200, height: 1));
                        lblLine2.backgroundColor = UIColor.lightGrayColor()
                        lblLine2.alpha = 0.4
                        cell.contentView.addSubview(lblLine2)
                        
                        txtSchemeAmountlblNote = UILabel(frame: CGRect(x: 10, y: 220, width: 200, height: 20));
                        txtSchemeAmountlblNote.text = "Minimum amount : ₹ \(self.minimumAmount)"
                        txtSchemeAmountlblNote.textColor = UIColor.darkGrayColor()
                        txtSchemeAmountlblNote.font = UIFont.italicSystemFontOfSize(11)
                        txtSchemeAmountlblNote.backgroundColor = UIColor.clearColor()
                        txtSchemeAmountlblNote.textAlignment = .Left
                        cell.contentView.addSubview(txtSchemeAmountlblNote)
                        
                        return cell;

                    }
                    
//                    var lblUploadPanNAV : UILabel!
//                    lblUploadPanNAV = UILabel(frame: CGRect(x: 10, y: 95, width: (cell.contentView.frame.size.width)-20, height: 25));
//                    lblUploadPanNAV.text = "NAV"
//                    lblUploadPanNAV.textColor = UIColor.darkGrayColor()
//                    lblUploadPanNAV.font = UIFont.systemFontOfSize(12)
//                    cell.contentView.addSubview(lblUploadPanNAV)
//                    
//                    txtNav = UITextField(frame: CGRect(x: 10, y: 125, width: (cell.contentView.frame.size.width)-20, height: 35));
//                    txtNav.text = "-"
//                    txtNav.keyboardType = UIKeyboardType.Default
//                    self.applyTextFiledStyle1(txtNav)
//                    cell.contentView.addSubview(txtNav)
//                    txtNav.enabled = false
//                    txtNav.textColor = UIColor.blackColor()
//                    
//                    var lblLineNAV : UILabel!
//                    lblLineNAV = UILabel(frame: CGRect(x: 10, y: 160, width: (cell.contentView.frame.size.width)-30, height: 1));
//                    lblLineNAV.backgroundColor = UIColor.lightGrayColor()
//                    lblLineNAV.alpha = 0.4
//                    cell.contentView.addSubview(lblLineNAV)
                    
                    txtSchemeAmount = RPFloatingPlaceholderTextField(frame: CGRect(x: 6, y: 105, width: 200, height: 35))
//                        UITextField(frame: CGRect(x: 10, y: 95, width: 200, height: 35));
                    txtSchemeAmount.text = ""
                    txtSchemeAmount.textColor = UIColor.blackColor()
                    txtSchemeAmount.placeholder = "Enter Amount(₹)"
                    txtSchemeAmount.floatingLabelInactiveTextColor = UIColor.darkGrayColor()
                    txtSchemeAmount.floatingLabelActiveTextColor = UIColor.darkGrayColor()
                    txtSchemeAmount.floatingLabel.font = UIFont.systemFontOfSize(12)
                    txtSchemeAmount.keyboardType = UIKeyboardType.NumberPad
                    addToolBar(txtSchemeAmount)
                    self.applyTextFiledStyle1(txtSchemeAmount)
                    cell.contentView.addSubview(txtSchemeAmount)
                    
                    var lblLine2 : UILabel!
                    lblLine2 = UILabel(frame: CGRect(x: 10, y: 140, width: 200, height: 1));
                    lblLine2.backgroundColor = UIColor.lightGrayColor()
                    lblLine2.alpha = 0.4
                    cell.contentView.addSubview(lblLine2)
                    
                    txtSchemeAmountlblNote = UILabel(frame: CGRect(x: 10, y: 145, width: 200, height: 20));
                    txtSchemeAmountlblNote.text = "Minimum amount : ₹ \(self.minimumAmount)"
                    txtSchemeAmountlblNote.textColor = UIColor.darkGrayColor()
                    txtSchemeAmountlblNote.font = UIFont.italicSystemFontOfSize(11)
                    txtSchemeAmountlblNote.backgroundColor = UIColor.clearColor()
                    txtSchemeAmountlblNote.textAlignment = .Left
                    cell.contentView.addSubview(txtSchemeAmountlblNote)
                    
                    return cell;

                    
                    
                case 2:
                    
                    var lblLine : UILabel!
                    lblLine = UILabel(frame: CGRect(x: 10, y: 0, width: (cell.contentView.frame.size.width)-20, height: 1));
                    lblLine.backgroundColor = UIColor.lightGrayColor()
                    lblLine.alpha = 0.4
                    cell.contentView.addSubview(lblLine)
                    
                    let txtPan = UILabel(frame: CGRect(x: 10, y: 5, width: (cell.contentView.frame.size.width)-40, height: 35));
                    txtPan.text = "MF investments are subject to market risk. Please read SID carefully before investing."
                    txtPan.textColor = UIColor.darkGrayColor()
                    txtPan.font = UIFont.italicSystemFontOfSize(11)
                    txtPan.backgroundColor = UIColor.clearColor()
                    txtPan.numberOfLines = 2
                    cell.contentView.addSubview(txtPan)
                    
                    return cell;
                    
                case 3:
                    
                    btnBuyNow = UIButton(frame: CGRect(x: cell.contentView.frame.size.width-84, y: 10, width: 76, height: 36))
                    btnBuyNow.setTitle("BUY NOW", forState: .Normal)
                    btnBuyNow.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                    btnBuyNow.backgroundColor = UIColor.defaultOrangeButton
                    btnBuyNow.titleLabel?.font = UIFont.systemFontOfSize(14)
                    btnBuyNow.layer.cornerRadius = 1.5
                    btnBuyNow.addTarget(self, action: #selector(BuyScreeen.btnBuyNowClicked(_:)), forControlEvents: .TouchUpInside)
                    cell.contentView.addSubview(btnBuyNow)
//                    btnBuyNow.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
                    
                    btnReset = UIButton(frame: CGRect(x: cell.contentView.frame.size.width-(84*2), y: 10, width: 76, height: 36))
                    btnReset.setTitle("RESET", forState: .Normal)
                    btnReset.setTitleColor(UIColor.defaultOrangeButton, forState: .Normal)
                    btnReset.backgroundColor = UIColor.whiteColor()
                    btnReset.titleLabel?.font = UIFont.systemFontOfSize(14)
                    btnReset.layer.cornerRadius = 1.5
                    btnReset.layer.borderColor = UIColor.defaultOrangeButton.CGColor
                    btnReset.layer.borderWidth = 1.0
                    btnReset.addTarget(self, action: #selector(BuyScreeen.btnResetClicked(_:)), forControlEvents: .TouchUpInside)
                    cell.contentView.addSubview(btnReset)
                    
                    cell.selectionStyle = UITableViewCellSelectionStyle.None
                    cell.contentView.backgroundColor = UIColor.defaultAppBackground
                    cell.backgroundColor = UIColor.defaultAppBackground
                    
                    return cell;
                    
                default:
                    break;
                }
                
            }else{
                
                
            }

            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.contentView.backgroundColor = UIColor.clearColor()
            cell.backgroundColor = UIColor.clearColor()
            
            return cell;

        } // kBUY_FROM_FRESH END

       
        if isBuyFrom==kBUY_FOR_SIP { // kBUY_FOR_SIP START
            
            
            
            var planName = "CELL_BUYSIP_FORSIPALL_\(indexPath.row)_\(indexPath.section)_\(lblTitle.text)_\(self.isDivAvailable)_\(self.isNAVAvailable)_\(randomVal)"
            
            if (enumFrequencySelectedIndex>0) {
                planName = "\(txtFrequency.text)_\(planName)_\(enumSIPDaySelectedIndex)"
            }

            var identifier = planName
            
            if let BuyFromScheme = sharedInstance.userDefaults.objectForKey(kSelectBuyNowScheme) as? String
            {
                identifier = identifier + BuyFromScheme
            }
            if let BuyFromScheme = sharedInstance.userDefaults.objectForKey(kSelectBuyNowScheme) as? NSDictionary
            {
                let val = BuyFromScheme.valueForKey("Scheme_Code") as? String
                
                identifier = identifier + val!
            }
            
            tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: identifier)
            
            let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as UITableViewCell
            
            cell.selectionStyle = .None
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.contentView.backgroundColor = UIColor.defaultAppBackground
            cell.backgroundColor = UIColor.defaultAppBackground

            if (cell.contentView.subviews.count==0) {
            
                switch indexPath.row {
                case 0:
                    
                    btnOneTimeRadioSIP = UIButton(frame: CGRect(x: 10, y: 15, width: 20, height: 20));
                    btnOneTimeRadioSIP.layer.cornerRadius = 10
                    btnOneTimeRadioSIP.layer.borderWidth = 2.0
                    btnOneTimeRadioSIP.layer.borderColor = UIColor.lightGrayColor().CGColor
                    cell.contentView.addSubview(btnOneTimeRadioSIP)
                    btnOneTimeRadioSIP.addTarget(self, action: #selector(BuyScreeen.btnOneTimeClicked(_:)), forControlEvents: .TouchUpInside)
                    
                    let lblOneTime = UIButton(frame: CGRect(x: 33, y: 5, width: 70, height: 40));
                    lblOneTime.setTitle("One-time", forState: .Normal)
                    lblOneTime.titleLabel?.font = UIFont.systemFontOfSize(14)
                    lblOneTime.setTitleColor(UIColor.blackColor(), forState: .Normal)
                    lblOneTime.addTarget(self, action: #selector(BuyScreeen.btnOneTimeClicked(_:)), forControlEvents: .TouchUpInside)
                    lblOneTime.titleLabel?.textAlignment = .Left
                    lblOneTime.contentHorizontalAlignment = .Left;
                    cell.contentView.addSubview(lblOneTime)
                    
                    btnSIPRadioSIP = UIButton(frame: CGRect(x: 110, y: 15, width: 20, height: 20));
                    btnSIPRadioSIP.layer.cornerRadius = 10
                    btnSIPRadioSIP.layer.borderWidth = 2.0
                    btnSIPRadioSIP.layer.borderColor = UIColor.defaultAppColorBlue.CGColor
                    cell.contentView.addSubview(btnSIPRadioSIP)
                    btnSIPRadioSIP.addTarget(self, action: #selector(BuyScreeen.btnSIPClicked(_:)), forControlEvents: .TouchUpInside)
                    
                    let lblSIP = UIButton(frame: CGRect(x: 135, y: 5, width: 70, height: 40));
                    lblSIP.setTitle("SIP", forState: .Normal)
                    lblSIP.titleLabel?.font = UIFont.systemFontOfSize(14)
                    lblSIP.setTitleColor(UIColor.blackColor(), forState: .Normal)
                    lblSIP.addTarget(self, action: #selector(BuyScreeen.btnSIPClicked(_:)), forControlEvents: .TouchUpInside)
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
                        
//                        if lblTitle.text=="SIP" {
                        
                            btnOneTimeRadioSIP.layer.borderColor = UIColor.lightGrayColor().CGColor
                            btnSIPRadioSIP.layer.borderColor = UIColor.defaultAppColorBlue.CGColor
                            btnRoundRadioSIP.removeFromSuperview()
                        
                            btnRoundRadioSIP = UIButton(frame: CGRect(x: 5, y: 5, width: 10, height: 10));
                            btnRoundRadioSIP.layer.cornerRadius = 5
                            btnRoundRadioSIP.layer.borderWidth = 2.0
                            btnRoundRadioSIP.backgroundColor = UIColor.defaultAppColorBlue
                            btnRoundRadioSIP.layer.borderColor = UIColor.defaultAppColorBlue.CGColor
                            btnSIPRadioSIP.addSubview(btnRoundRadioSIP)
                            
//                        }else{
//                            
//                            btnOneTimeRadioSIP.layer.borderColor = UIColor.defaultAppColorBlue.CGColor
//                            btnSIPRadioSIP.layer.borderColor = UIColor.lightGrayColor().CGColor
//                            
//                            btnRoundRadioSIP.removeFromSuperview()
//                            btnRoundRadioSIP = UIButton(frame: CGRect(x: 5, y: 5, width: 10, height: 10));
//                            btnRoundRadioSIP.layer.cornerRadius = 5
//                            btnRoundRadioSIP.layer.borderWidth = 2.0
//                            btnRoundRadioSIP.backgroundColor = UIColor.defaultAppColorBlue
//                            btnRoundRadioSIP.layer.borderColor = UIColor.defaultAppColorBlue.CGColor
//                            btnOneTimeRadioSIP.addSubview(btnRoundRadioSIP)
//                            
//                        }
                        
                    }
                    
                    
                    return cell;
                    
                case 1:
                    
                    var lblUploadPan : UILabel!
                    lblUploadPan = UILabel(frame: CGRect(x: 10, y: 25, width: (cell.contentView.frame.size.width)-20, height: 25));
//                    lblUploadPan.text = "Enter Scheme Name"
                    lblUploadPan.textColor = UIColor.darkGrayColor()
                    lblUploadPan.font = UIFont.systemFontOfSize(12)
                    cell.contentView.addSubview(lblUploadPan)
                    
                    lbltxtSchemeNameSIP = UILabel(frame: CGRect(x: 10, y: 40, width: (cell.contentView.frame.size.width)-50, height: 60));
                    lbltxtSchemeNameSIP.text = kEnterSchemeName
                    lbltxtSchemeNameSIP.textColor = UIColor.darkGrayColor()
                    lbltxtSchemeNameSIP.font = UIFont.systemFontOfSize(16)
                    lbltxtSchemeNameSIP.numberOfLines = 2
                    cell.contentView.addSubview(lbltxtSchemeNameSIP)
                    
                    if let BuyFromScheme = sharedInstance.userDefaults.objectForKey(kSelectBuyNowScheme) as? String
                    {
                        print(BuyFromScheme)
                        lbltxtSchemeNameSIP.text = BuyFromScheme
                        lbltxtSchemeNameSIP.textColor = UIColor(red:0.78, green:0.78, blue:0.78, alpha:1.0)
                    }
                    if let BuyFromScheme = sharedInstance.userDefaults.objectForKey(kSelectBuyNowScheme) as? NSDictionary
                    {
                        print(BuyFromScheme)
                        lblUploadPan.text = "Enter Scheme Name"
                        lbltxtSchemeNameSIP.text = BuyFromScheme.valueForKey("Plan_Name") as? String
                        lbltxtSchemeNameSIP.textColor = UIColor.blackColor()
                    }

                    btnSchemeNameSIP = UIButton(frame: CGRect(x: 10, y: 40, width: (cell.contentView.frame.size.width)-20, height: 60));
                    btnSchemeNameSIP.addTarget(self, action: #selector(BuyScreeen.btnBuySchemeNameClicked(_:)), forControlEvents: .TouchUpInside)
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
                    
                    
                    
                    if self.isDivAvailable {
                        
                        
                        lblDividendOptionSIP = UILabel(frame: CGRect(x: 10, y: 95, width: (cell.contentView.frame.size.width)-20, height: 25));
                        lblDividendOptionSIP.text = "Dividend Option"
                        lblDividendOptionSIP.textColor = UIColor.darkGrayColor()
                        lblDividendOptionSIP.font = UIFont.systemFontOfSize(12)
                        cell.contentView.addSubview(lblDividendOptionSIP)
                        
                        txtDividendOptionSIP = UITextField(frame: CGRect(x: 10, y: 125, width: 120, height: 35));
                        txtDividendOptionSIP.text = DividendOptionBUY.allValues[enumDividendOption.hashValue]
                        txtDividendOptionSIP.keyboardType = UIKeyboardType.Default
                        self.applyTextFiledStyle1(txtDividendOptionSIP)
                        cell.contentView.addSubview(txtDividendOptionSIP)
                        txtDividendOptionSIP.inputView = pickerView
                        txtDividendOptionSIP.tag = TAG_DIVIDEND_OPTION_BUY_SIP
                        txtDividendOptionSIP.textColor = UIColor.blackColor()
                        
                        
                        var imgDownArrowDOP : UIImageView!
                        imgDownArrowDOP = UIImageView(frame: CGRect(x: 120, y: 125, width: 30, height: 30));
                        imgDownArrowDOP.image = UIImage(named: "iconDown")
                        imgDownArrowDOP.backgroundColor = UIColor.clearColor()
                        cell.contentView.addSubview(imgDownArrowDOP)
                        
                        var lblLineDOP : UILabel!
                        lblLineDOP = UILabel(frame: CGRect(x: 10, y: 155, width: 140, height: 1));
                        lblLineDOP.backgroundColor = UIColor.lightGrayColor()
                        lblLineDOP.alpha = 0.4
                        cell.contentView.addSubview(lblLineDOP)

                        
                        var lblUploadPanNAV : UILabel!
                        lblUploadPanNAV = UILabel(frame: CGRect(x: 10, y: 160, width: (cell.contentView.frame.size.width)-20, height: 25));
                        lblUploadPanNAV.text = "NAV"
                        lblUploadPanNAV.textColor = UIColor.darkGrayColor()
                        lblUploadPanNAV.font = UIFont.systemFontOfSize(12)
                        cell.contentView.addSubview(lblUploadPanNAV)
                        
                        txtNavSIP = UITextField(frame: CGRect(x: 10, y: 190, width: (cell.contentView.frame.size.width)-20, height: 35));
                        txtNavSIP.text = "-"
                        txtNavSIP.keyboardType = UIKeyboardType.Default
                        self.applyTextFiledStyle1(txtNavSIP)
                        cell.contentView.addSubview(txtNavSIP)
                        txtNavSIP.enabled = false
                        txtNavSIP.textColor = UIColor.blackColor()
                        
                        if let BuyNowScheme = sharedInstance.userDefaults.objectForKey(kSelectBuyNowScheme) as? NSDictionary
                        {
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                if let nav = BuyNowScheme.valueForKey("NAV")
                                {
                                    if let nav_date = BuyNowScheme.valueForKey("NAVDate")
                                    {
                                        let twoDecimalPlaces = String(format: "%.2f", nav as! Double)
                                        if (self.txtNav != nil)
                                        {
                                            self.txtNav.text = "\(twoDecimalPlaces) As On \(sharedInstance.getFormatedDate(nav_date as! String))"
                                            
                                        }
                                        if (self.txtNavSIP != nil)
                                        {
                                            self.txtNavSIP.text = "\(twoDecimalPlaces) As On \(sharedInstance.getFormatedDate(nav_date as! String))"
                                        }
                                    }
                                }
                            })
                        }
                        
                        var lblLineNAV : UILabel!
                        lblLineNAV = UILabel(frame: CGRect(x: 10, y: 230, width: (cell.contentView.frame.size.width)-30, height: 1));
                        lblLineNAV.backgroundColor = UIColor.lightGrayColor()
                        lblLineNAV.alpha = 0.4
                        cell.contentView.addSubview(lblLineNAV)

                        return cell;

                    }
                    
                    if self.isNAVAvailable {
                       
                        var lblUploadPanNAV : UILabel!
                        lblUploadPanNAV = UILabel(frame: CGRect(x: 10, y: 95, width: (cell.contentView.frame.size.width)-20, height: 25));
                        lblUploadPanNAV.text = "NAV"
                        lblUploadPanNAV.textColor = UIColor.darkGrayColor()
                        lblUploadPanNAV.font = UIFont.systemFontOfSize(12)
                        cell.contentView.addSubview(lblUploadPanNAV)
                        
                        txtNavSIP = UITextField(frame: CGRect(x: 10, y: 125, width: (cell.contentView.frame.size.width)-20, height: 35));
                        txtNavSIP.text = "-"
                        txtNavSIP.keyboardType = UIKeyboardType.Default
                        self.applyTextFiledStyle1(txtNavSIP)
                        cell.contentView.addSubview(txtNavSIP)
                        txtNavSIP.enabled = false
                        txtNavSIP.textColor = UIColor.blackColor()
                        
                        if let BuyNowScheme = sharedInstance.userDefaults.objectForKey(kSelectBuyNowScheme) as? NSDictionary
                        {
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                if let nav = BuyNowScheme.valueForKey("NAV")
                                {
                                    if let nav_date = BuyNowScheme.valueForKey("NAVDate")
                                    {
                                        let twoDecimalPlaces = String(format: "%.2f", nav as! Double)
                                        if (self.txtNav != nil)
                                        {
                                            self.txtNav.text = "\(twoDecimalPlaces) As On \(sharedInstance.getFormatedDate(nav_date as! String))"
                                            
                                        }
                                        if (self.txtNavSIP != nil)
                                        {
                                            self.txtNavSIP.text = "\(twoDecimalPlaces) As On \(sharedInstance.getFormatedDate(nav_date as! String))"
                                        }
                                    }
                                }
                            })
                        }
                        
                        var lblLineNAV : UILabel!
                        lblLineNAV = UILabel(frame: CGRect(x: 10, y: 165, width: (cell.contentView.frame.size.width)-30, height: 1));
                        lblLineNAV.backgroundColor = UIColor.lightGrayColor()
                        lblLineNAV.alpha = 0.4
                        cell.contentView.addSubview(lblLineNAV)

                        return cell;

                    }

                    return cell;

                    
                case 2:

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


                    if txtFrequency.text=="Monthly" || txtFrequency.text=="Quarterly" || txtFrequency.text=="Half Yearly" || txtFrequency.text=="Annual" || txtFrequency.text=="Bi Monthly"
                    {
                        var lblnoI : UILabel!
                        lblnoI = UILabel(frame: CGRect(x: 10, y: 65, width: (cell.contentView.frame.size.width)-20, height: 25));
//                        lblnoI.text = "No. of installments"
                        lblnoI.textColor = UIColor.darkGrayColor()
                        lblnoI.font = UIFont.systemFontOfSize(12)
                        cell.contentView.addSubview(lblnoI)

                        txtNoOfInstallments = RPFloatingPlaceholderTextField(frame: CGRect(x: 10, y: 95, width: 200, height: 35))
//                            UITextField(frame: CGRect(x: 10, y: 95, width: 200, height: 35));
                        txtNoOfInstallments.text = ""
                        txtNoOfInstallments.placeholder = "Enter No. of installments"
                        txtNoOfInstallments.floatingLabelInactiveTextColor = UIColor.darkGrayColor()
                        txtNoOfInstallments.floatingLabelActiveTextColor = UIColor.darkGrayColor()
                        txtNoOfInstallments.floatingLabel.font = UIFont.systemFontOfSize(12)
                        txtNoOfInstallments.keyboardType = UIKeyboardType.NumberPad
                        addToolBar(txtNoOfInstallments)
                        self.applyTextFiledStyle1(txtNoOfInstallments)
                        cell.contentView.addSubview(txtNoOfInstallments)
                        
                        
                        
                        var lblLineNoOfI : UILabel!
                        lblLineNoOfI = UILabel(frame: CGRect(x: 10, y: 130, width: 200, height: 1));
                        lblLineNoOfI.backgroundColor = UIColor.lightGrayColor()
                        lblLineNoOfI.alpha = 0.4
                        cell.contentView.addSubview(lblLineNoOfI)

                        txtNoOfInstallmentslblNotes = UILabel(frame: CGRect(x: 10, y: 135, width: 200, height: 20));
                        txtNoOfInstallmentslblNotes.text = "Min. Installments : \(self.minimumInstallments)"
                        txtNoOfInstallmentslblNotes.textColor = UIColor.darkGrayColor()
                        txtNoOfInstallmentslblNotes.font = UIFont.italicSystemFontOfSize(11)
                        txtNoOfInstallmentslblNotes.backgroundColor = UIColor.clearColor()
                        txtNoOfInstallmentslblNotes.textAlignment = .Left
                        cell.contentView.addSubview(txtNoOfInstallmentslblNotes)

                    }
                    else
                    {
                        
                    }

                        return cell;

                case 3:


                    // SIPDay....
                    var lblSIPD : UILabel!
                    lblSIPD = UILabel(frame: CGRect(x: 10, y: 5, width: (cell.contentView.frame.size.width)-20, height: 25));
                    lblSIPD.text = "SIP Day"
                    lblSIPD.textColor = UIColor.darkGrayColor()
                    lblSIPD.font = UIFont.systemFontOfSize(12)
                    cell.contentView.addSubview(lblSIPD)
                    
                    txtSIPDay = UITextField(frame: CGRect(x: 10, y: 30, width: (cell.contentView.frame.size.width)-20, height: 35));

                    if enumSIPDaySelectedIndex<arrSIPDays.count {
                        txtSIPDay.text = arrSIPDays.objectAtIndex(enumSIPDaySelectedIndex) as? String
                    }else{
                        txtSIPDay.text = "SELECT"
                    }
                    
                    txtSIPDay.keyboardType = UIKeyboardType.Default
                    self.applyTextFiledStyle1(txtSIPDay)
                    cell.contentView.addSubview(txtSIPDay)
                    txtSIPDay.inputView = pickerView
                    txtSIPDay.tag = TAG_SIPday
                    txtSIPDay.textColor = UIColor.blackColor()
                    
                    var imgDownArrowFrequency : UIImageView!
                    imgDownArrowFrequency = UIImageView(frame: CGRect(x: (cell.contentView.frame.size.width)-50, y: 30, width: 30, height: 30));
                    imgDownArrowFrequency.image = UIImage(named: "iconDown")
                    imgDownArrowFrequency.backgroundColor = UIColor.clearColor()
                    cell.contentView.addSubview(imgDownArrowFrequency)

                    
                    var lblLineFR : UILabel!
                    lblLineFR = UILabel(frame: CGRect(x: 10, y: 65, width: (cell.contentView.frame.size.width)-30, height: 1));
                    lblLineFR.backgroundColor = UIColor.lightGrayColor()
                    lblLineFR.alpha = 0.4
                    cell.contentView.addSubview(lblLineFR)

                    
                    let widthForHalf = (SCREEN_WIDTH-30)/2
                    
                    var lblStartMonth : UILabel!
                    lblStartMonth = UILabel(frame: CGRect(x: 10, y: 70, width: widthForHalf, height: 30));
                    lblStartMonth.text = "Start Month"
                    lblStartMonth.textColor = UIColor.darkGrayColor()
                    lblStartMonth.font = UIFont.systemFontOfSize(12)
                    cell.contentView.addSubview(lblStartMonth)
                    
                    txtStartMonth = UITextField(frame: CGRect(x: 10, y: 100, width: widthForHalf, height: 35));
                    txtStartMonth.text = MONTH.allValues[enumStartMonthSelected.hashValue]
                    txtStartMonth.keyboardType = UIKeyboardType.Default
                    self.applyTextFiledStyle1(txtStartMonth)
                    cell.contentView.addSubview(txtStartMonth)
                    txtStartMonth.inputView = pickerView
                    txtStartMonth.tag = TAG_START_MONTH
                    txtStartMonth.textColor = UIColor.blackColor()
                    
                    var imgDownArrowStartMonth : UIImageView!
                    imgDownArrowStartMonth = UIImageView(frame: CGRect(x: (widthForHalf+10)-30, y: 100, width: 30, height: 30));
                    imgDownArrowStartMonth.image = UIImage(named: "iconDown")
                    imgDownArrowStartMonth.backgroundColor = UIColor.clearColor()
                    cell.contentView.addSubview(imgDownArrowStartMonth)
                    
                    var lblLineStartM : UILabel!
                    lblLineStartM = UILabel(frame: CGRect(x: 10, y: 135, width: widthForHalf-10, height: 1));
                    lblLineStartM.backgroundColor = UIColor.lightGrayColor()
                    lblLineStartM.alpha = 0.4
                    cell.contentView.addSubview(lblLineStartM)
                    
                    
                    var lblStartYear : UILabel!
                    lblStartYear = UILabel(frame: CGRect(x: (widthForHalf+20), y: 70, width: widthForHalf, height: 30));
                    lblStartYear.text = "Start Year"
                    lblStartYear.textColor = UIColor.darkGrayColor()
                    lblStartYear.font = UIFont.systemFontOfSize(12)
                    cell.contentView.addSubview(lblStartYear)
                    
                    txtStartYear = UITextField(frame: CGRect(x: (widthForHalf+20), y: 100, width: widthForHalf, height: 35));
                    
                    if arrYears.count==0 {
                        txtStartYear.text = "2016"
                    }else{
                        txtStartYear.text = arrYears.objectAtIndex(enumStartYearSelectedIndex) as? String
                    }
                    
                    txtStartYear.keyboardType = UIKeyboardType.Default
                    self.applyTextFiledStyle1(txtStartYear)
                    cell.contentView.addSubview(txtStartYear)
                    txtStartYear.inputView = pickerView
                    txtStartYear.tag = TAG_START_YEAR
                    txtStartYear.textColor = UIColor.blackColor()
                    
                    var imgDownArrowStartYear : UIImageView!
                    imgDownArrowStartYear = UIImageView(frame: CGRect(x: (widthForHalf+widthForHalf+10)-30, y: 100, width: 30, height: 30));
                    imgDownArrowStartYear.image = UIImage(named: "iconDown")
                    imgDownArrowStartYear.backgroundColor = UIColor.clearColor()
                    cell.contentView.addSubview(imgDownArrowStartYear)
                    
                    var lblLineStartY : UILabel!
                    lblLineStartY = UILabel(frame: CGRect(x: (widthForHalf+20), y: 135, width: widthForHalf-10, height: 1));
                    lblLineStartY.backgroundColor = UIColor.lightGrayColor()
                    lblLineStartY.alpha = 0.4
                    cell.contentView.addSubview(lblLineStartY)

                    

                    
                    if txtFrequency.text=="Daily" || txtFrequency.text=="Weekly" || txtFrequency.text=="Fortnightly"
                    {
                        
                        var lblEndMonth : UILabel!
                        lblEndMonth = UILabel(frame: CGRect(x: 10, y: 140, width: widthForHalf, height: 30));
                        lblEndMonth.text = "End Month"
                        lblEndMonth.textColor = UIColor.darkGrayColor()
                        lblEndMonth.font = UIFont.systemFontOfSize(12)
                        cell.contentView.addSubview(lblEndMonth)
                        
                        txtEndMonth = UITextField(frame: CGRect(x: 10, y: 165, width: widthForHalf, height: 35));
                        txtEndMonth.text = MONTH.allValues[enumEndMonthSelected.hashValue]
                        txtEndMonth.keyboardType = UIKeyboardType.Default
                        self.applyTextFiledStyle1(txtEndMonth)
                        cell.contentView.addSubview(txtEndMonth)
                        txtEndMonth.inputView = pickerView
                        txtEndMonth.tag = TAG_START_MONTH
                        txtEndMonth.textColor = UIColor.blackColor()
                        
                        var imgDownArrowEndMonth : UIImageView!
                        imgDownArrowEndMonth = UIImageView(frame: CGRect(x: (widthForHalf+10)-30, y: 165, width: 30, height: 30));
                        imgDownArrowEndMonth.image = UIImage(named: "iconDown")
                        imgDownArrowEndMonth.backgroundColor = UIColor.clearColor()
                        cell.contentView.addSubview(imgDownArrowEndMonth)
                        
                        var lblLineStartM : UILabel!
                        lblLineStartM = UILabel(frame: CGRect(x: 10, y: 200, width: widthForHalf-10, height: 1));
                        lblLineStartM.backgroundColor = UIColor.lightGrayColor()
                        lblLineStartM.alpha = 0.4
                        cell.contentView.addSubview(lblLineStartM)
                        
                        var lblEndYear : UILabel!
                        lblEndYear = UILabel(frame: CGRect(x: (widthForHalf+20), y: 140, width: widthForHalf, height: 30));
                        lblEndYear.text = "End Year"
                        lblEndYear.textColor = UIColor.darkGrayColor()
                        lblEndYear.font = UIFont.systemFontOfSize(12)
                        cell.contentView.addSubview(lblEndYear)
                        
                        txtEndYear = UITextField(frame: CGRect(x: (widthForHalf+20), y: 165, width: widthForHalf, height: 35));
                        
                        if arrYears.count==0 {
                            txtEndYear.text = "2016"
                        }else{
                            txtEndYear.text = arrYears.objectAtIndex(enumEndYearSelectedIndex) as? String
                        }
                        
                        txtEndYear.keyboardType = UIKeyboardType.Default
                        self.applyTextFiledStyle1(txtEndYear)
                        cell.contentView.addSubview(txtEndYear)
                        txtEndYear.inputView = pickerView
                        txtEndYear.tag = TAG_END_YEAR
                        txtEndYear.textColor = UIColor.blackColor()
                        
                        var imgDownArrowStartYear : UIImageView!
                        imgDownArrowStartYear = UIImageView(frame: CGRect(x: (widthForHalf+widthForHalf+10)-30, y: 165, width: 30, height: 30));
                        imgDownArrowStartYear.image = UIImage(named: "iconDown")
                        imgDownArrowStartYear.backgroundColor = UIColor.clearColor()
                        cell.contentView.addSubview(imgDownArrowStartYear)
                        
                        var lblLineStartY : UILabel!
                        lblLineStartY = UILabel(frame: CGRect(x: (widthForHalf+20), y: 200, width: widthForHalf-10, height: 1));
                        lblLineStartY.backgroundColor = UIColor.lightGrayColor()
                        lblLineStartY.alpha = 0.4
                        cell.contentView.addSubview(lblLineStartY)
                        
                    }

                    return cell;

                case 4:
                    
                    txtSchemeAmountSIP = RPFloatingPlaceholderTextField(frame: CGRect(x: 10, y: 15, width: 200, height: 35))
//                        UITextField(frame: CGRect(x: 10, y: 5, width: 200, height: 35));
                    txtSchemeAmountSIP.text = ""
                    txtSchemeAmountSIP.placeholder = "Enter SIP Amount(₹)"
                    txtSchemeAmountSIP.floatingLabelInactiveTextColor = UIColor.darkGrayColor()
                    txtSchemeAmountSIP.floatingLabelActiveTextColor = UIColor.darkGrayColor()
                    txtSchemeAmountSIP.floatingLabel.font = UIFont.systemFontOfSize(12)
                    txtSchemeAmountSIP.keyboardType = UIKeyboardType.NumberPad
                    addToolBar(txtSchemeAmountSIP)
                    self.applyTextFiledStyle1(txtSchemeAmountSIP)
                    cell.contentView.addSubview(txtSchemeAmountSIP)
                    
                    var lblLine2 : UILabel!
                    lblLine2 = UILabel(frame: CGRect(x: 10, y: 45, width: 200, height: 1));
                    lblLine2.backgroundColor = UIColor.lightGrayColor()
                    lblLine2.alpha = 0.4
                    cell.contentView.addSubview(lblLine2)

                    txtSchemeAmountSIPlblNote = UILabel(frame: CGRect(x: 10, y: 50, width: 200, height: 20));
                    txtSchemeAmountSIPlblNote.text = "Minimum amount : ₹ \(self.minimumAmount)"
                    txtSchemeAmountSIPlblNote.textColor = UIColor.darkGrayColor()
                    txtSchemeAmountSIPlblNote.font = UIFont.italicSystemFontOfSize(11)
                    txtSchemeAmountSIPlblNote.backgroundColor = UIColor.clearColor()
                    txtSchemeAmountSIPlblNote.textAlignment = .Left
                    cell.contentView.addSubview(txtSchemeAmountSIPlblNote)


                    return cell;

                case 5:
                    
                    if (btnCheckBoxMakeFirstLumpsum != nil) {
                        
                        cell.contentView.addSubview(btnCheckBoxMakeFirstLumpsum)
                        cell.contentView.addSubview(btnMakeFirstLumpsum)
                        cell.contentView.addSubview(txtLumpsumBuyAmount)
                        cell.contentView.addSubview(txtLumpsumBuyAmountLBLNote)
                        cell.contentView.addSubview(txtLumpsumBuyAmountLBLLine)

                            if btnCheckBoxMakeFirstLumpsum.selected {
                                txtLumpsumBuyAmount.hidden = false
                                txtLumpsumBuyAmountLBLNote.hidden = false
                                txtLumpsumBuyAmountLBLLine.hidden = false
                                
                                if (amont >= minimumLumpsumAmount) {
                                    txtLumpsumBuyAmount.text! = txtSchemeAmountSIP.text!
                                }
                            }else{
                                txtLumpsumBuyAmount.hidden = true
                                txtLumpsumBuyAmountLBLNote.hidden = true
                                txtLumpsumBuyAmountLBLLine.hidden = true
                                
                            }
                        
                    }else{
                        
                        btnCheckBoxMakeFirstLumpsum = UIButton(frame: CGRect(x: 10, y: 5, width: 20, height: 20));
                        cell.contentView.addSubview(btnCheckBoxMakeFirstLumpsum)
                        btnCheckBoxMakeFirstLumpsum.backgroundColor = UIColor.clearColor()
                        btnCheckBoxMakeFirstLumpsum.layer.cornerRadius = 2.0
                        btnCheckBoxMakeFirstLumpsum.layer.borderWidth = 2
                        btnCheckBoxMakeFirstLumpsum.layer.borderColor = UIColor.defaultMenuGray.CGColor
                        //set highlighted image
                        btnCheckBoxMakeFirstLumpsum.setImage(UIImage(named: "iconCheckEmail"), forState: UIControlState.Selected)
                        btnCheckBoxMakeFirstLumpsum.addTarget(self, action: #selector(BuyScreeen.btnCheckBoxMakeFirstLumpsumClicked(_:)), forControlEvents: .TouchUpInside)

                        btnMakeFirstLumpsum = UIButton(frame: CGRect(x: 40, y: 5, width: (cell.contentView.frame.size.width)-55, height: 20));
                        btnMakeFirstLumpsum.setTitle("Make First Lumpsum Buy", forState: .Normal)
                        btnMakeFirstLumpsum.titleLabel?.font = UIFont.systemFontOfSize(14)
                        btnMakeFirstLumpsum.setTitleColor(UIColor.blackColor().colorWithAlphaComponent(0.87), forState: .Normal)
                        btnMakeFirstLumpsum.titleLabel?.textAlignment = .Left
                        btnMakeFirstLumpsum.contentHorizontalAlignment = .Left;
                        cell.contentView.addSubview(btnMakeFirstLumpsum)
                        btnMakeFirstLumpsum.addTarget(self, action: #selector(BuyScreeen.btnCheckBoxMakeFirstLumpsumClicked(_:)), forControlEvents: .TouchUpInside)
                        
                        txtLumpsumBuyAmount = RPFloatingPlaceholderTextField(frame: CGRect(x: 10, y: 45, width: 200, height: 35))
//                            UITextField(frame: CGRect(x: 10, y: 35, width: 200, height: 35));
                        txtLumpsumBuyAmount.text = ""
                        txtLumpsumBuyAmount.placeholder = "Enter Lumpsum Amount (₹)"
                        txtLumpsumBuyAmount.floatingLabelInactiveTextColor = UIColor.darkGrayColor()
                        txtLumpsumBuyAmount.floatingLabelActiveTextColor = UIColor.darkGrayColor()
                        txtLumpsumBuyAmount.floatingLabel.font = UIFont.systemFontOfSize(12)
                        txtLumpsumBuyAmount.keyboardType = UIKeyboardType.NumberPad
                        addToolBar(txtLumpsumBuyAmount)
                        self.applyTextFiledStyle1(txtLumpsumBuyAmount)
                        
                        cell.contentView.addSubview(txtLumpsumBuyAmount)
                        
                        
                        txtLumpsumBuyAmountLBLLine = UILabel(frame: CGRect(x: 10, y: 80, width: 200, height: 1));
                        txtLumpsumBuyAmountLBLLine.backgroundColor = UIColor.lightGrayColor()
                        txtLumpsumBuyAmountLBLLine.alpha = 0.4
                        cell.contentView.addSubview(txtLumpsumBuyAmountLBLLine)
                        
                        txtLumpsumBuyAmountLBLNote = UILabel(frame: CGRect(x: 10, y: 90, width: 200, height: 20));
                        txtLumpsumBuyAmountLBLNote.text = "Minimum first payment : ₹ 5,000"
                        txtLumpsumBuyAmountLBLNote.textColor = UIColor.darkGrayColor()
                        txtLumpsumBuyAmountLBLNote.font = UIFont.italicSystemFontOfSize(11)
                        txtLumpsumBuyAmountLBLNote.backgroundColor = UIColor.clearColor()
                        txtLumpsumBuyAmountLBLNote.textAlignment = .Left
                        cell.contentView.addSubview(txtLumpsumBuyAmountLBLNote)

                        
                        if (btnCheckBoxMakeFirstLumpsum != nil) {
                            if btnCheckBoxMakeFirstLumpsum.selected {
                                txtLumpsumBuyAmount.hidden = false
                                txtLumpsumBuyAmountLBLNote.hidden = false
                                txtLumpsumBuyAmountLBLLine.hidden = false
                                
                                if (amont >= minimumLumpsumAmount) {
                                    txtLumpsumBuyAmount.text! = txtSchemeAmountSIP.text!
                                }
                            }else{
                                txtLumpsumBuyAmount.hidden = true
                                txtLumpsumBuyAmountLBLNote.hidden = true
                                txtLumpsumBuyAmountLBLLine.hidden = true
                                
                            }
                        }

                    }
                    
                    
//                    if (btnCheckBoxMakeFirstLumpsum != nil) {
//                        if btnCheckBoxMakeFirstLumpsum.selected {
//                            if txtSchemeAmountSIP.text=="" {
//                                
//                            }else{
//                                let amountSIP = txtSchemeAmountSIP.text as! NSNumber
//                                
//                            }
//                        }
//                    }
                    
                    return cell;

                case 6:
                    
                    var lblLine : UILabel!
                    lblLine = UILabel(frame: CGRect(x: 10, y: 0, width: (cell.contentView.frame.size.width)-20, height: 1));
                    lblLine.backgroundColor = UIColor.lightGrayColor()
                    lblLine.alpha = 0.4
                    cell.contentView.addSubview(lblLine)
                    
                    let txtPan = UILabel(frame: CGRect(x: 10, y: 5, width: (cell.contentView.frame.size.width)-40, height: 35));
                    txtPan.text = "MF investments are subject to market risk. Please read SID carefully before investing."
                    txtPan.textColor = UIColor.darkGrayColor()
                    txtPan.font = UIFont.italicSystemFontOfSize(11)
                    txtPan.backgroundColor = UIColor.clearColor()
                    txtPan.numberOfLines = 2
                    cell.contentView.addSubview(txtPan)
                    
                    return cell;
                    
                case 7:
                    
                    btnBuyNow = UIButton(frame: CGRect(x: cell.contentView.frame.size.width-84, y: 10, width: 76, height: 36))
                    btnBuyNow.setTitle("SIP NOW", forState: .Normal)
                    btnBuyNow.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                    btnBuyNow.backgroundColor = UIColor.defaultOrangeButton
                    btnBuyNow.titleLabel?.font = UIFont.systemFontOfSize(14)
                    btnBuyNow.layer.cornerRadius = 1.5
                    btnBuyNow.addTarget(self, action: #selector(BuyScreeen.btnBuyNowClicked(_:)), forControlEvents: .TouchUpInside)
                    cell.contentView.addSubview(btnBuyNow)
                    
                    btnReset = UIButton(frame: CGRect(x: cell.contentView.frame.size.width-(84*2), y: 10, width: 76, height: 36))
                    btnReset.setTitle("RESET", forState: .Normal)
                    btnReset.setTitleColor(UIColor.defaultOrangeButton, forState: .Normal)
                    btnReset.backgroundColor = UIColor.whiteColor()
                    btnReset.titleLabel?.font = UIFont.systemFontOfSize(14)
                    btnReset.layer.cornerRadius = 1.5
                    btnReset.layer.borderColor = UIColor.defaultOrangeButton.CGColor
                    btnReset.layer.borderWidth = 1.0
                    btnReset.addTarget(self, action: #selector(BuyScreeen.btnResetClicked(_:)), forControlEvents: .TouchUpInside)
                    cell.contentView.addSubview(btnReset)
                    
                    cell.selectionStyle = UITableViewCellSelectionStyle.None
                    cell.contentView.backgroundColor = UIColor.defaultAppBackground
                    cell.backgroundColor = UIColor.defaultAppBackground
                    
                    return cell;
                    
                    
                default:
                    break;
                }
                
            }else{
                
                if indexPath.row==0 {
                    
                    if btnRoundRadioSIP==nil {
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
                }

                
                if indexPath.row==5 {
                    
                    if (btnCheckBoxMakeFirstLumpsum != nil) {
                        
                        cell.contentView.addSubview(btnCheckBoxMakeFirstLumpsum)
                        cell.contentView.addSubview(btnMakeFirstLumpsum)
                        cell.contentView.addSubview(txtLumpsumBuyAmount)
                        cell.contentView.addSubview(txtLumpsumBuyAmountLBLNote)
                        
                        if btnCheckBoxMakeFirstLumpsum.selected {
                            txtLumpsumBuyAmount.hidden = false
                            txtLumpsumBuyAmountLBLNote.hidden = false
                            
                        }else{
                            txtLumpsumBuyAmount.hidden = true
                            txtLumpsumBuyAmountLBLNote.hidden = true
                            
                        }
                        
                    }
                    
                }
                
            }
        
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.contentView.backgroundColor = UIColor.defaultAppBackground
            cell.backgroundColor = UIColor.defaultAppBackground
            
            return cell;
            
        } // kBUY_FOR_SIP END

        
        
        let planName = "CELL_FIRST"
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: planName)
        let cell = tableView.dequeueReusableCellWithIdentifier(planName, forIndexPath: indexPath) as UITableViewCell
        cell.selectionStyle = .None
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.contentView.backgroundColor = UIColor.defaultAppBackground
        cell.backgroundColor = UIColor.defaultAppBackground
        return cell;
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        
        if isBuyFrom==kBUY_FROM_SELECTED_FUND { // kBUY_FROM_SELECTED_FUND START
            
            if indexPath.row==0 {
                return 50
            }
            if indexPath.row==1 {
                if self.isDivAvailable
                {
                    return 320
                }
                return 260
            }
            if indexPath.row==2 {
                return 80
            }
            if indexPath.row==3 {
                return 45
            }

        } // // kBUY_FROM_SELECTED_FUND END
        
        if isBuyFrom==kBUY_FROM_SMARTFUND { // kkBUY_FROM_SMARTFUND START
            
            if indexPath.row==0 {
                return 50
            }
            if indexPath.row==1 {
                if self.isDivAvailable
                {
                    return 320
                }
                return 260
            }
            if indexPath.row==2 {
                return 80
            }
            if indexPath.row==3 {
                return 45
            }
            
        }
        
        if isBuyFrom==kBUY_FROM_FRESH { // kBUY_FROM_FRESH START
            
            if indexPath.row==0 {
                return 50
            }
            if indexPath.row==1 {
                if self.isDivAvailable {
                    return 320
                }
                if self.isNAVAvailable
                {
                    return 245
                }
                return 180
            }
            if indexPath.row==2 {
                return 45
            }
            return 55

        }
        
        if isBuyFrom==kBUY_FOR_SIP { // kBUY_FOR_SIP START
            
            if indexPath.row==0 {
                return 50
            }
            if indexPath.row==1 {
                if self.isDivAvailable {
                    return 230
                }
                if self.isNAVAvailable {
                    return 165
                }
                
                return 95
            }
            if indexPath.row==2 {
                if (txtFrequency != nil) {
                    if txtFrequency.text=="Monthly" || txtFrequency.text=="Quarterly" || txtFrequency.text=="Half Yearly" || txtFrequency.text=="Annual" || txtFrequency.text=="Bi Monthly"
                    {
                        return 155
                    }
                }
                
                return 65
            }
            if indexPath.row==3 {
                if (txtFrequency != nil) {
                    if txtFrequency.text=="Daily" || txtFrequency.text=="Weekly" || txtFrequency.text=="Fortnightly"
                    {
                        return 205
                    }
                }
                
                return 140
            }
            if indexPath.row==4 {
                return 70
            }
            if indexPath.row==5 {
                
                if (btnCheckBoxMakeFirstLumpsum != nil) {
                    if btnCheckBoxMakeFirstLumpsum.selected {
                        return 110
                    }else{
                        return 50
                    }
                }
                return 110
            }
            if indexPath.row==6 {
                return 40
            }
            if indexPath.row==7 {
                return 50
            }
            return 55
        }
        
        return 55
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        

        let view = UIView(frame: CGRect(x: 10, y: 0, width: tableView.frame.size.width-20, height: 155))
        view.backgroundColor = UIColor.defaultAppBackground
        
        imgHeader = UIImageView(frame: CGRect(x: (view.frame.size.width/2)-45, y: 10, width: 80, height: 80))
        imgHeader.layer.cornerRadius = imgHeader.frame.height/2
        let image = UIImage(named: "transactBuySIP")
        
        imgHeader.image = image
        view.addSubview(imgHeader)
        
        lblTitleHeader = UILabel(frame: CGRect(x: 10, y: 100, width: (view.frame.size.width)-20, height: 30));
        lblTitleHeader.textColor = UIColor.blackColor()
        lblTitleHeader.font = UIFont.systemFontOfSize(19)
        lblTitleHeader.textAlignment = .Center
        view.addSubview(lblTitleHeader)
        
        var lblSwitchToDirect1 : UILabel!
        lblSwitchToDirect1 = UILabel(frame: CGRect(x: 10, y: 130, width: (view.frame.size.width)-20, height: 15));
        lblSwitchToDirect1.text = "Buy Right, Sit Tight"
        lblSwitchToDirect1.textColor = UIColor.darkGrayColor()
        lblSwitchToDirect1.font = UIFont.italicSystemFontOfSize(13)
        lblSwitchToDirect1.textAlignment = .Center
        view.addSubview(lblSwitchToDirect1)
        
        let label = UILabel(frame: CGRect(x: 10, y: view.frame.size.height-1, width: view.frame.size.width, height: 1))
        label.backgroundColor = UIColor.lightGrayColor()
        view.addSubview(label)
        label.alpha = 0.4
        
        
        if isBuyFrom == kBUY_FROM_SELECTED_FUND {
            lblTitleHeader.text = "Buy Now"
        }

        if isBuyFrom == kBUY_FROM_FRESH {
            lblTitleHeader.text = "Buy Now"
        }
        
        if isBuyFrom == kBUY_FOR_SIP {
            lblTitleHeader.text = "SIP Now"
        }

        return view
    }
    
    @IBAction func btnCheckBoxMakeFirstLumpsumClicked(sender: AnyObject) {
        
        if btnCheckBoxMakeFirstLumpsum.selected {
            
            btnCheckBoxMakeFirstLumpsum.selected = false
            btnCheckBoxMakeFirstLumpsum.layer.cornerRadius = 2.0
            btnCheckBoxMakeFirstLumpsum.layer.borderWidth = 2
            btnCheckBoxMakeFirstLumpsum.layer.borderColor = UIColor.defaultMenuGray.CGColor
            
            txtLumpsumBuyAmount.hidden = false
            txtLumpsumBuyAmountLBLNote.hidden = false
            txtLumpsumBuyAmountLBLLine.hidden = false
            txtLumpsumBuyAmount.text! = ""
        }else{
            btnCheckBoxMakeFirstLumpsum.selected = true
            btnCheckBoxMakeFirstLumpsum.layer.cornerRadius = 2.0
            btnCheckBoxMakeFirstLumpsum.layer.borderWidth = 0
            
            minimumLumpsumAmount = 5000
            amont = 0
            
            if (txtSchemeAmountSIP.text!.length > 0)
            {
                amont = Int(txtSchemeAmountSIP.text!)
            }
  
//            amont = txtSchemeAmountSIP.text!
//            if (amont > minimumLumpsumAmount) {
//                txtLumpsumBuyAmount.text! = txtSchemeAmountSIP.text!
//                return
//            }
            
            txtLumpsumBuyAmount.hidden = true
            txtLumpsumBuyAmountLBLNote.hidden = true
            txtLumpsumBuyAmountLBLLine.hidden = true

        }
        
//        tblView.reloadData()
        
        let indexPath = NSIndexPath(forRow: 5, inSection: 0)
        self.tblView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)

    }
    
    
    // UITextField Delegates
    func textFieldDidBeginEditing(textField: UITextField) {
        print("TextField did begin editing method called")
        txtCurrentTextField = textField
        pickerView.selectRow(0, inComponent: 0, animated: true)

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
        
        
        
        if textField == self.txtSchemeAmount
        {
            guard let text = textField.text else { return true }
            
            let newLength = text.characters.count + string.characters.count - range.length
            return newLength <= 10 // Bool

            
        }
        if textField == self.txtSchemeAmountSIP
        {
            guard let text = textField.text else { return true }
            
            let newLength = text.characters.count + string.characters.count - range.length
            return newLength <= 10 // Bool

        }
        if textField == self.txtLumpsumBuyAmount
        {
            guard let text = textField.text else { return true }
            
            let newLength = text.characters.count + string.characters.count - range.length
            return newLength <= 10 // Bool
            
        }
        
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
    
    @IBAction func btnBuyNowClicked(sender: AnyObject)
    {
        print("Buy Now Clicked")
        
        if isBuyFrom==kBUY_FROM_FRESH || isBuyFrom==kBUY_FROM_SELECTED_FUND { // kBUY_FROM_FRESH START
            
            let objOrder : Order = Order()
            
            var schemeName = ""
            if let fromFundGet = sharedInstance.userDefaults.objectForKey(kSelectBuyNowScheme) as? NSDictionary
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
            if let fromFundGet = sharedInstance.userDefaults.objectForKey(kSelectBuyNowScheme) as? String
            {
                print(fromFundGet)
                schemeName = fromFundGet
                
            }
            
            if schemeName==kEnterSchemeName {
                SharedManager.invokeAlertMethod(APP_NAME, strBody: "Please Enter Scheme name!", delegate: nil)
                return;
            }
            
            if txtSchemeAmount.text?.length==0 {
                SharedManager.invokeAlertMethod(APP_NAME, strBody: "Please enter amount!", delegate: nil)
                return;
            }
            
            if Int(txtSchemeAmount.text!)!<minimumAmount {
                SharedManager.invokeAlertMethod(APP_NAME, strBody: "Please enter minimum amount \(minimumAmount)!", delegate: nil)
                return;
            }

            if self.multipleAmount>1 {
                let result = Int(txtSchemeAmount.text!)! % self.multipleAmount
                print("Result \(result)")
                
                if result==0 {
                    
                }else{
                    SharedManager.invokeAlertMethod(APP_NAME, strBody: "Amount should be multiple of \(self.multipleAmount).", delegate: nil)
                    return;
                }
            }
            
            objOrder.Volume = txtSchemeAmount.text

            print(objOrder.description)
            
            if self.isDivAvailable {
                
                let optionText = DividendOptionBUY.allValues[enumDividendOption.hashValue]
                if optionText=="Payout" {
                    objOrder.DividendOption = "N"
                }
                if optionText=="Reinvestment" {
                    objOrder.DividendOption = "Y"
                }
            
            }

            
            
            let objOrderSummary = self.storyboard?.instantiateViewControllerWithIdentifier(sbIdOrderSummaryBUY) as! OrderSummaryBUY
            objOrderSummary.isFor = "BUY"
            objOrderSummary.objOrder = objOrder
            self.navigationController?.pushViewController(objOrderSummary, animated: true)

        }
        
        if isBuyFrom==kBUY_FOR_SIP { // kBUY_FOR_SIP START
            
            let objOrder : Order = Order()
            
            var schemeName = ""
            if let fromFundGet = sharedInstance.userDefaults.objectForKey(kSelectBuyNowScheme) as? NSDictionary
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
            if let fromFundGet = sharedInstance.userDefaults.objectForKey(kSelectBuyNowScheme) as? String
            {
                print(fromFundGet)
                schemeName = fromFundGet
            }
            
            
            if schemeName==kEnterSchemeName {
                SharedManager.invokeAlertMethod(APP_NAME, strBody: "Please select Enter Scheme name!", delegate: nil)
                return;
            }
            
            if txtFrequency.text?.length==0 || txtFrequency.text=="SELECT" {
                SharedManager.invokeAlertMethod(APP_NAME, strBody: "Please select Frequency!", delegate: nil)
                return;
            }
            
            if txtFrequency.text=="Monthly" || txtFrequency.text=="Quarterly" || txtFrequency.text=="Half Yearly" || txtFrequency.text=="Annual" || txtFrequency.text=="Bi Monthly"
            {
                if txtNoOfInstallments.text?.length==0 {
                    SharedManager.invokeAlertMethod(APP_NAME, strBody: "Please enter No. of installments!", delegate: nil)
                    return;
                }
                if Int(txtNoOfInstallments.text!)!<minimumInstallments {
                    SharedManager.invokeAlertMethod(APP_NAME, strBody: "Please enter minimum No. of installments! \(minimumInstallments) !", delegate: nil)
                    return;
                }

            }else{
                
            }
            
            
            if txtSIPDay.text?.length==0 || txtSIPDay.text=="SELECT" {
                SharedManager.invokeAlertMethod(APP_NAME, strBody: "Please select SIP day!", delegate: nil)
                return;
            }
            
            if txtStartMonth.text?.length==0 || txtStartMonth.text=="SELECT"{
                SharedManager.invokeAlertMethod(APP_NAME, strBody: "Please select Start month!", delegate: nil)
                return;
            }
            
            if txtStartYear.text?.length==0 || txtStartYear.text=="SELECT" {
            SharedManager.invokeAlertMethod(APP_NAME, strBody: "Please select Start year!", delegate: nil)
            return;
            }
            let date = NSDate()
            let calendar = NSCalendar.currentCalendar()
            let components = calendar.components([.Month , .Year], fromDate: date)
            
            let year =  components.year
            let month = components.month
            print(enumStartMonthSelected.hashValue)
            print(month)
            if Int(txtStartYear.text!)==year  && enumStartMonthSelected.hashValue < month  {
                SharedManager.invokeAlertMethod(APP_NAME, strBody: "Please select Current or Future Date!", delegate: nil)
                return;
            }
            
            var endMonth = MONTH.SELECT
            var endYear = ""
            
            if txtFrequency.text=="Daily" || txtFrequency.text=="Weekly" || txtFrequency.text=="Fortnightly"
            {
                if txtEndMonth.text?.length==0 || txtEndMonth.text=="SELECT" {
                    SharedManager.invokeAlertMethod(APP_NAME, strBody: "Please select End month!", delegate: nil)
                    return;
                }
                if txtEndYear.text?.length==0 || txtEndYear.text=="SELECT" {
                    SharedManager.invokeAlertMethod(APP_NAME, strBody: "Please select End year!", delegate: nil)
                    return;
                }
                
                let end_Month = txtEndMonth.text!
                endMonth = MONTH.fromHashString(end_Month)
                endYear = txtEndYear.text!

            }else{
                endMonth = MONTH.SELECT
                endYear = ""
            }

            if txtSchemeAmountSIP.text?.length==0 {
                SharedManager.invokeAlertMethod(APP_NAME, strBody: "Please enter SIP amount!", delegate: nil)
                return;
            }
            if Int(txtSchemeAmountSIP.text!)!<minimumAmount {
                SharedManager.invokeAlertMethod(APP_NAME, strBody: "Please enter minimum amount \(minimumAmount)!", delegate: nil)
                return;
            }
            
            if self.multipleAmount>1 {
                let result = Int(txtSchemeAmountSIP.text!)! % self.multipleAmount
                print("Result \(result)")
                
                if result==0 {
                    
                }else{
                    SharedManager.invokeAlertMethod(APP_NAME, strBody: "Amount should be multiple of \(self.multipleAmount).", delegate: nil)
                    return;
                }
            }
            
            objOrder.Volume = txtSchemeAmountSIP.text
            
            if btnCheckBoxMakeFirstLumpsum.selected {
                if txtLumpsumBuyAmount.text?.length<=0 {
                    SharedManager.invokeAlertMethod(APP_NAME, strBody: "Please enter Lumpsum amount!", delegate: nil)
                    return;
                }
                minimumLumpsumAmount = 5000
                if Int(txtLumpsumBuyAmount.text!)!<minimumLumpsumAmount {
                    SharedManager.invokeAlertMethod(APP_NAME, strBody: "Please enter minimum lumpsum buy amount \(minimumLumpsumAmount)!", delegate: nil)
                    return;
                }

            }else{
                
            }
            
            print(objOrder.description)

            let frequencyToSend = sharedInstance.getFrequencyFromFullName(txtFrequency.text!)
            let day = txtSIPDay.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            let start_Month = txtStartMonth.text
            let startMonth = MONTH.fromHashString(start_Month!)
            
            let startYear = txtStartYear.text

            let firstPaymentAmount = txtLumpsumBuyAmount.text

            var firtPaymentFlag = true
            if btnCheckBoxMakeFirstLumpsum.selected {
                firtPaymentFlag = true
            }else{
                firtPaymentFlag = false
            }
            
            var noOfInstallment = ""
            if (txtNoOfInstallments != nil) {
                noOfInstallment = txtNoOfInstallments.text!
            }

            let objOrderSummary = self.storyboard?.instantiateViewControllerWithIdentifier(sbIdOrderSummaryBUY) as! OrderSummaryBUY
            objOrderSummary.isFor = "SIP"
            
            objOrderSummary.frequency = frequencyToSend
            objOrderSummary.day = day!
            objOrderSummary.startMonth = "\(startMonth.hashValue)"
            objOrderSummary.startYear = startYear!
            objOrderSummary.endMonth = "\(endMonth.hashValue)"
            objOrderSummary.endYear = endYear
            objOrderSummary.firstPaymentAmount = firstPaymentAmount!
            objOrderSummary.firstPaymentFlag = firtPaymentFlag
            objOrderSummary.noOfInstallment = noOfInstallment

            if self.isDivAvailable {
                let optionText = DividendOptionBUY.allValues[enumDividendOption.hashValue]
                if optionText=="Payout" {
                    objOrder.DividendOption = "N"
                }
                if optionText=="Reinvestment" {
                    objOrder.DividendOption = "Y"
                }
            }
            objOrderSummary.objOrder = objOrder
            self.navigationController?.pushViewController(objOrderSummary, animated: true)
            
        }
        
    }
    
    @IBAction func btnResetClicked(sender: AnyObject) {
        print("Reset Clicked")

        
        sharedInstance.userDefaults .setObject(kEnterSchemeName, forKey: kSelectBuyNowScheme)
        
        enumDividendOption = DividendOptionBUY.Payout
        enumFrequencySelectedIndex = 0
        minimumInstallments = 0
        enumSIPDaySelectedIndex = 0
        enumStartMonthSelected = MONTH.SELECT
        enumStartYearSelectedIndex = 1
        enumEndMonthSelected = MONTH.SELECT
        enumEndYearSelectedIndex = 0
        minimumAmount = 0
        minimumLumpsumAmount = 0
        
        isDivAvailable = false
        isNAVAvailable = false

        
//        self.randomVal = sharedInstance.getRandomVal()
//        self.tblView.reloadData()
        
        
        if (btnCheckBoxMakeFirstLumpsum != nil) {
            btnCheckBoxMakeFirstLumpsum.selected = false
            btnCheckBoxMakeFirstLumpsum.layer.cornerRadius = 2.0
            btnCheckBoxMakeFirstLumpsum.layer.borderWidth = 2
            btnCheckBoxMakeFirstLumpsum.layer.borderColor = UIColor.defaultMenuGray.CGColor

        }
        if (txtLumpsumBuyAmount.text != nil) {
            txtLumpsumBuyAmount.hidden = false

        }
        
        if (txtLumpsumBuyAmountLBLNote != nil) {
            txtLumpsumBuyAmountLBLNote.hidden = false
        }
        
        self.viewWillAppear(true)
    }
    
    @IBAction func btnBuySchemeNameClicked(sender: AnyObject) {
        print("Scheme Clicked")
        
        if lblTitle.text=="SIP" {
            
            let objSelectFromFund = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdSelectSearchFund) as! SelectSearchFund
            objSelectFromFund.selectFor = "BuyNowScheme"
            objSelectFromFund.isSIPAllowed = "Y"
            
            //Fund_Code
            self.presentViewController(objSelectFromFund, animated: true, completion: nil)

        }else{
            
            let objSelectFromFund = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdSelectSearchFund) as! SelectSearchFund
            objSelectFromFund.selectFor = "BuyNowScheme"
            
            objSelectFromFund.isSIPAllowed = "N"

            self.presentViewController(objSelectFromFund, animated: true, completion: nil)

        }
    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

        if txtCurrentTextField.tag == TAG_DIVIDEND_OPTION_BUY {
            return DividendOptionBUY.allValues.count
        }
        if txtCurrentTextField.tag == TAG_DIVIDEND_OPTION_BUY_SIP {
            return DividendOptionBUY.allValues.count
        }

        if txtCurrentTextField.tag == TAG_FREQUENCY {
            return arrFrequency.count
        }
        if txtCurrentTextField.tag == TAG_START_MONTH {
            return MONTH.allValues.count
        }
        if txtCurrentTextField.tag == TAG_START_YEAR {
            return arrYears.count
        }
        
        if txtCurrentTextField.tag == TAG_END_MONTH {
            return MONTH.allValues.count
        }
        if txtCurrentTextField.tag == TAG_END_YEAR {
            return arrYears.count
        }
        
        if txtCurrentTextField.tag == TAG_SIPday {
            return self.arrSIPDays.count
        }

        return 0
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        if txtCurrentTextField.tag == TAG_DIVIDEND_OPTION_BUY {
            return DividendOptionBUY.allValues[row]
        }
        if txtCurrentTextField.tag == TAG_DIVIDEND_OPTION_BUY_SIP {
            return DividendOptionBUY.allValues[row]
        }

        if txtCurrentTextField.tag == TAG_FREQUENCY {
            return sharedInstance.getFullNameFromFrequency(arrFrequency.objectAtIndex(row) as! String)
        }
        if txtCurrentTextField.tag == TAG_START_MONTH {
            return MONTH.allValues[row]
        }
        if txtCurrentTextField.tag == TAG_START_YEAR {
            return arrYears.objectAtIndex(row) as? String
        }

        if txtCurrentTextField.tag == TAG_END_MONTH {
            return MONTH.allValues[row]
        }
        if txtCurrentTextField.tag == TAG_END_YEAR {
            return arrYears.objectAtIndex(row) as? String
        }

        
        
        if txtCurrentTextField.tag == TAG_SIPday {
            return self.arrSIPDays.objectAtIndex(row) as? String
        }

        return "DefaulyValue"
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
        if txtCurrentTextField.tag == TAG_DIVIDEND_OPTION_BUY {
            txtCurrentTextField.text = DividendOptionBUY.allValues[row]
            enumDividendOption = DividendOptionBUY.fromHashValue(row)
            txtCurrentTextField.resignFirstResponder()
        }

        if txtCurrentTextField.tag == TAG_DIVIDEND_OPTION_BUY_SIP {
            txtCurrentTextField.text = DividendOptionBUY.allValues[row]
            enumDividendOption = DividendOptionBUY.fromHashValue(row)
            txtCurrentTextField.resignFirstResponder()
        }

        if txtCurrentTextField.tag == TAG_FREQUENCY {
            
//            print(sharedInstance.getFullNameFromFrequency((arrFrequency.objectAtIndex(row) as? String)!))
            
            
            if self.arrMultipleAmount.count==0
            {
                
            }
            else{
                print(row)
                if row == 0
                {
                    
                }
                else
                {
                    self.multipleAmount = self.arrMultipleAmount.objectAtIndex(row-1) as! Int
                }
                txtCurrentTextField.text = sharedInstance.getFullNameFromFrequency((arrFrequency.objectAtIndex(row) as? String)!)
            }
//            txtCurrentTextField.text = sharedInstance.getFullNameFromFrequency((arrFrequency.objectAtIndex(row) as? String)!)
            enumFrequencySelectedIndex = row
            txtCurrentTextField.resignFirstResponder()
            
            if row>0 {
                if arrSIPDays.count==0 {
                    
                }else{
                   arrSIPDays.removeAllObjects()
                }
                
                let dicDetails = self.arrSIPSoldDetails.objectAtIndex(row-1)
                print(dicDetails)
                
                if txtFrequency.text=="Monthly" || txtFrequency.text=="Quarterly" || txtFrequency.text=="Half Yearly" || txtFrequency.text=="Annual" || txtFrequency.text=="Bi Monthly"
                {
                    if let minins = dicDetails.valueForKey("Min_Inst")
                    {
                        self.minimumInstallments = minins as! Int
                        
                        if (txtNoOfInstallmentslblNotes != nil) {
                            txtNoOfInstallmentslblNotes.text = "Min. Installments : \(self.minimumInstallments)"
                        }
                    }
                }

                if let minAmou = dicDetails.valueForKey("Min_Amt")
                {
                    self.minimumAmount = minAmou as! Int
                    txtSchemeAmountSIPlblNote.text = "Minimum amount : ₹ \(self.minimumAmount)"
                }
                
                //self.txtNoOfInstallmentslblNotes.text = dicDetails.valueForKey("Min_Inst")
                
                if let Sys_Freq_Opt = dicDetails.valueForKey("Sys_Freq_Opt")
                {
                    print(Sys_Freq_Opt)
                    if Sys_Freq_Opt as! String=="A" // Any date....
                    {
                        // add 1 to 28 manually...
                        arrSIPDays.addObject("SELECT")
                        self.addStaticSIPDays()
                        
                        enumSIPDaySelectedIndex = 0
                        txtSIPDay.text = arrSIPDays.objectAtIndex(enumSIPDaySelectedIndex) as? String
                        
                    }
                    if Sys_Freq_Opt as! String=="S" // Specific Date... Read
                    {
                        if let arrSIPDay = dicDetails.valueForKey("Sys_Dts")
                        {
                            print(arrSIPDay)
                            arrSIPDays = arrSIPDay.mutableCopy() as! NSMutableArray
                            
                            arrSIPDays.insertObject("SELECT", atIndex: 0)

                            enumSIPDaySelectedIndex = 0
                            txtSIPDay.text = arrSIPDays.objectAtIndex(enumSIPDaySelectedIndex) as? String

                        }
                    }
                }
            }
            
            tblView.reloadData()
        }
        
        if txtCurrentTextField.tag == TAG_START_MONTH {
            txtCurrentTextField.text = MONTH.allValues[row]
            enumStartMonthSelected = MONTH.fromHashValue(row)
            txtCurrentTextField.resignFirstResponder()
        }
        if txtCurrentTextField.tag == TAG_START_YEAR {
            txtCurrentTextField.text = arrYears.objectAtIndex(row) as? String
            enumStartYearSelectedIndex = row
            txtCurrentTextField.resignFirstResponder()
        }
        
        if txtCurrentTextField.tag == TAG_END_MONTH {
            txtCurrentTextField.text = MONTH.allValues[row]
            enumEndMonthSelected = MONTH.fromHashValue(row)
            txtCurrentTextField.resignFirstResponder()
        }
        if txtCurrentTextField.tag == TAG_END_YEAR {
            txtCurrentTextField.text = arrYears.objectAtIndex(row) as? String
            enumEndYearSelectedIndex = row
            txtCurrentTextField.resignFirstResponder()
        }

        

        if txtCurrentTextField.tag == TAG_SIPday {
            if row==0
            {
                
            }
            else
            {
                txtCurrentTextField.text = arrSIPDays[row] as? String
            }
//            txtCurrentTextField.text = arrSIPDays[row] as? String
            enumSIPDaySelectedIndex = row
            txtCurrentTextField.resignFirstResponder()
        }

        
    }
    
    func addStaticSIPDays() {
        
        for i in 1...28 {
            arrSIPDays.addObject("\(i)")
        }
    }
    
    @IBAction func btnOneTimeClicked(sender: AnyObject) {
        
        if let BuyNowScheme = sharedInstance.userDefaults.objectForKey(kSelectBuyNowScheme) as? NSDictionary
        {
            print(BuyNowScheme)
            
            let dic = NSMutableDictionary()
            dic["Scheme_Code"] = BuyNowScheme.valueForKey("Scheme_Code")
            dic["Fund_Code"] = BuyNowScheme.valueForKey("Fund_Code")
            
            WebManagerHK.postDataToURL(kModeGetSchemeDetails, params: dic, message: "Checking details...") { (response) in
                
                if response.objectForKey(kWAPIResponse) is NSDictionary
                {
                    let mainResponse = response.objectForKey(kWAPIResponse) as! NSDictionary
                    print("Dic Response For TopFunds: \(mainResponse)")
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in // DISPATCH START...
                        
                        
                        if let Pur_Allowed = mainResponse.valueForKey("Pur_Allowed")
                        {
                            if Pur_Allowed as! String=="Y"
                            {
                                
                                if self.isExisting {
                                    self.isBuyFrom = kBUY_FROM_SELECTED_FUND
                                }else{
                                    self.isBuyFrom = kBUY_FROM_FRESH
                                }
                                
                                self.btnOneTimeRadio.layer.borderColor = UIColor.defaultAppColorBlue.CGColor
                                self.btnSIPRadio.layer.borderColor = UIColor.lightGrayColor().CGColor
                                
                                self.lblTitle.text = "Buy"
                                self.lblTitleHeader.text = "Buy Now"
                                
                                self.btnRoundRadio.removeFromSuperview()
                                self.btnRoundRadio = UIButton(frame: CGRect(x: 5, y: 5, width: 10, height: 10));
                                self.btnRoundRadio.layer.cornerRadius = 5
                                self.btnRoundRadio.layer.borderWidth = 2.0
                                self.btnRoundRadio.backgroundColor = UIColor.defaultAppColorBlue
                                self.btnRoundRadio.layer.borderColor = UIColor.defaultAppColorBlue.CGColor
                                self.btnOneTimeRadio.addSubview(self.btnRoundRadio)
                                
                                if let BuyNowScheme = sharedInstance.userDefaults.objectForKey(kSelectBuyNowScheme) as? NSDictionary
                                {
                                    print(BuyNowScheme)
                                    
                                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                        
                                        let myStringDivOpt = BuyNowScheme.valueForKey("Div_Opt")
                                        let Div_Opt = myStringDivOpt!.stringByTrimmingCharactersInSet(
                                            NSCharacterSet.whitespaceAndNewlineCharacterSet()
                                        )
                                        if Div_Opt=="NA" { // NA.....
                                            //                        self.txtDividendOption.hidden = true
                                            //                        self.lblDividendOption.hidden = true
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
                                        
                                        self.isNAVAvailable = true

                                        
                                        if let nav = BuyNowScheme.valueForKey("NAV")
                                        {
                                            if let nav_date = BuyNowScheme.valueForKey("NAVDate")
                                            {
                                                
                                                let twoDecimalPlaces = String(format: "%.2f", nav as! Double)
                                                
                                                self.txtNav.text = "\(twoDecimalPlaces) As On \(sharedInstance.getFormatedDate(nav_date as! String))"
                                                
                                                if (self.txtNavSIP != nil)
                                                {
                                                    self.txtNavSIP.text = "\(twoDecimalPlaces) As On \(sharedInstance.getFormatedDate(nav_date as! String))"
                                                }
                                            }
                                        }
                                        
                                        if (self.lbltxtSchemeName != nil) {
                                            self.lbltxtSchemeName.text = BuyNowScheme.valueForKey("Plan_Name") as? String
                                        }
                                        if (self.lbltxtSchemeNameSIP != nil) {
                                            self.lbltxtSchemeNameSIP.text = BuyNowScheme.valueForKey("Plan_Name") as? String
                                        }
                                        
                                        self.tblView.reloadData()

                                    })
                                    
                                    self.tblView.reloadData()
                                }
                                
                            }else{
                                // NOT ALLOWRD.....
                                SharedManager.invokeAlertMethod(APP_NAME, strBody: "Purchase Not Allowed in this fund, please choose different fund.", delegate: nil)
                            }
                        }
                        
                        self.tblView.reloadData()

                    }) /// DISPATCH END.........
                }
            }
        }else{
            
            if isExisting {
                isBuyFrom = kBUY_FROM_SELECTED_FUND
            }else{
                isBuyFrom = kBUY_FROM_FRESH
            }
            
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
            
            if let BuyNowScheme = sharedInstance.userDefaults.objectForKey(kSelectBuyNowScheme) as? NSDictionary
            {
                print(BuyNowScheme)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    let myStringDivOpt = BuyNowScheme.valueForKey("Div_Opt")
                    let Div_Opt = myStringDivOpt!.stringByTrimmingCharactersInSet(
                        NSCharacterSet.whitespaceAndNewlineCharacterSet()
                    )
                    if Div_Opt=="NA" { // NA.....
                        //                        self.txtDividendOption.hidden = true
                        //                        self.lblDividendOption.hidden = true
                    }
                    
                    if let nav = BuyNowScheme.valueForKey("NAV")
                    {
                        if let nav_date = BuyNowScheme.valueForKey("NAVDate")
                        {
                            
                            let twoDecimalPlaces = String(format: "%.2f", nav as! Double)
                            self.txtNav.text = "\(twoDecimalPlaces) As On \(sharedInstance.getFormatedDate(nav_date as! String))"
                            
                            if (self.txtNavSIP != nil)
                            {
                                self.txtNavSIP.text = "\(twoDecimalPlaces) As On \(sharedInstance.getFormatedDate(nav_date as! String))"
                            }
                        }
                    }
                    
                    if (self.lbltxtSchemeName != nil) {
                        self.lbltxtSchemeName.text = BuyNowScheme.valueForKey("Plan_Name") as? String
                    }
                    if (self.lbltxtSchemeNameSIP != nil) {
                        self.lbltxtSchemeNameSIP.text = BuyNowScheme.valueForKey("Plan_Name") as? String
                    }
                    
                    self.tblView.reloadData()

                })
            }
        }
        
        
        
        
        
        
//        if isExisting {
//            isBuyFrom = kBUY_FROM_SELECTED_FUND
//        }else{
//            isBuyFrom = kBUY_FROM_FRESH
//        }
//
//        btnOneTimeRadio.layer.borderColor = UIColor.defaultAppColorBlue.CGColor
//        btnSIPRadio.layer.borderColor = UIColor.lightGrayColor().CGColor
//
//        lblTitle.text = "Buy"
//        lblTitleHeader.text = "Buy Now"
//        
//        btnRoundRadio.removeFromSuperview()
//        btnRoundRadio = UIButton(frame: CGRect(x: 5, y: 5, width: 10, height: 10));
//        btnRoundRadio.layer.cornerRadius = 5
//        btnRoundRadio.layer.borderWidth = 2.0
//        btnRoundRadio.backgroundColor = UIColor.defaultAppColorBlue
//        btnRoundRadio.layer.borderColor = UIColor.defaultAppColorBlue.CGColor
//        btnOneTimeRadio.addSubview(btnRoundRadio)
//        
//        if let BuyNowScheme = sharedInstance.userDefaults.objectForKey(kSelectBuyNowScheme) as? NSDictionary
//        {
//            print(BuyNowScheme)
//            
//            dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                
//                let myStringDivOpt = BuyNowScheme.valueForKey("Div_Opt")
//                let Div_Opt = myStringDivOpt!.stringByTrimmingCharactersInSet(
//                    NSCharacterSet.whitespaceAndNewlineCharacterSet()
//                )
//                if Div_Opt=="NA" { // NA.....
//                    //                        self.txtDividendOption.hidden = true
//                    //                        self.lblDividendOption.hidden = true
//                }
//                
//                if let nav = BuyNowScheme.valueForKey("NAV")
//                {
//                    if let nav_date = BuyNowScheme.valueForKey("NAVDate")
//                    {
//                        
//                        let twoDecimalPlaces = String(format: "%.2f", nav as! Double)
//
////                        self.txtNav.text = "\(twoDecimalPlaces) As On \(nav_date.substringWithRange(NSRange(location: 0, length: 10)))"
//                        
//                        self.txtNav.text = "\(twoDecimalPlaces) As On \(sharedInstance.getFormatedDate(nav_date as! String))"
//
//                        if (self.txtNavSIP != nil)
//                        {
////                            self.txtNavSIP.text = "\(twoDecimalPlaces) As On \(nav_date.substringWithRange(NSRange(location: 0, length: 10)))"
//                            
//                            self.txtNavSIP.text = "\(twoDecimalPlaces) As On \(sharedInstance.getFormatedDate(nav_date as! String))"
//
//                        }
//                    }
//                }
//
//                if (self.lbltxtSchemeName != nil) {
//                    self.lbltxtSchemeName.text = BuyNowScheme.valueForKey("Plan_Name") as? String
//                }
//                if (self.lbltxtSchemeNameSIP != nil) {
//                    self.lbltxtSchemeNameSIP.text = BuyNowScheme.valueForKey("Plan_Name") as? String
//                }
//
//            })
//        }
        
        tblView.reloadData()

    }
    
    @IBAction func btnSIPClicked(sender: AnyObject) {


        if let BuyNowScheme = sharedInstance.userDefaults.objectForKey(kSelectBuyNowScheme) as? NSDictionary
        {
            print(BuyNowScheme)
            
            let dic = NSMutableDictionary()
            dic["Scheme_Code"] = BuyNowScheme.valueForKey("Scheme_Code")
            dic["Fund_Code"] = BuyNowScheme.valueForKey("Fund_Code")
            
            WebManagerHK.postDataToURL(kModeGetSchemeDetails, params: dic, message: "Checking details...") { (response) in
                
                if response.objectForKey(kWAPIResponse) is NSDictionary
                {
                    let mainResponse = response.objectForKey(kWAPIResponse) as! NSDictionary
                    print("Dic Response For TopFunds: \(mainResponse)")
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in // DISPATCH START...

                        if let SIP_Allowed = mainResponse.valueForKey("SIP_Allowed")
                        {
                            if SIP_Allowed as! String=="Y"
                            {
                                
                                self.isBuyFrom = kBUY_FOR_SIP
                                
                                if self.btnOneTimeRadioSIP==nil {
                                    
                                }else{
                                   
                                    self.btnOneTimeRadioSIP.layer.borderColor = UIColor.lightGrayColor().CGColor
                                    self.btnSIPRadioSIP.layer.borderColor = UIColor.defaultAppColorBlue.CGColor
                                    
                                    self.lblTitle.text = "SIP"
                                    self.lblTitleHeader.text = "SIP Now"
                                    
                                    self.btnRoundRadioSIP.removeFromSuperview()
                                    self.btnRoundRadioSIP = UIButton(frame: CGRect(x: 5, y: 5, width: 10, height: 10));
                                    self.btnRoundRadioSIP.layer.cornerRadius = 5
                                    self.btnRoundRadioSIP.layer.borderWidth = 2.0
                                    self.btnRoundRadioSIP.backgroundColor = UIColor.defaultAppColorBlue
                                    self.btnRoundRadioSIP.layer.borderColor = UIColor.defaultAppColorBlue.CGColor
                                    self.btnSIPRadioSIP.addSubview(self.btnRoundRadioSIP)

                                }
                                
                                if let BuyNowScheme = sharedInstance.userDefaults.objectForKey(kSelectBuyNowScheme) as? NSDictionary
                                {
                                    print(BuyNowScheme)
                                    
                                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                        
                                        
                                        
                                        let myStringDivOpt = BuyNowScheme.valueForKey("Div_Opt")
                                        let Div_Opt = myStringDivOpt!.stringByTrimmingCharactersInSet(
                                            NSCharacterSet.whitespaceAndNewlineCharacterSet()
                                        )
                                        if Div_Opt=="NA" { // NA.....
                                            //                        self.txtDividendOption.hidden = true
                                            //                        self.lblDividendOption.hidden = true
                                        }
                                        
                                        if let nav = BuyNowScheme.valueForKey("NAV")
                                        {
                                            if let nav_date = BuyNowScheme.valueForKey("NAVDate")
                                            {
                                                let twoDecimalPlaces = String(format: "%.2f", nav as! Double)
                                                
                                                //                            self.txtNav.text = "\(twoDecimalPlaces) As On \(nav_date.substringWithRange(NSRange(location: 0, length: 10)))"
                                                self.txtNav.text = "\(twoDecimalPlaces) As On \(sharedInstance.getFormatedDate(nav_date as! String))"
                                                
                                                if (self.txtNavSIP != nil)
                                                {
                                                    //                                self.txtNavSIP.text = "\(twoDecimalPlaces) As On \(nav_date.substringWithRange(NSRange(location: 0, length: 10)))"
                                                    
                                                    self.txtNavSIP.text = "\(twoDecimalPlaces) As On \(sharedInstance.getFormatedDate(nav_date as! String))"
                                                }
                                            }
                                        }
                                        
                                        if (self.lbltxtSchemeName != nil) {
                                            self.lbltxtSchemeName.text = BuyNowScheme.valueForKey("Plan_Name") as? String
                                        }
                                        if (self.lbltxtSchemeNameSIP != nil) {
                                            self.lbltxtSchemeNameSIP.text = BuyNowScheme.valueForKey("Plan_Name") as? String
                                        }
                                        
                                        let myStringSchem = BuyNowScheme.valueForKey("Scheme_Code")
                                        let Scheme_Code = myStringSchem!.stringByTrimmingCharactersInSet(
                                            NSCharacterSet.whitespaceAndNewlineCharacterSet()
                                        )
                                        
                                        let myStringFund_Code = BuyNowScheme.valueForKey("Fund_Code")
                                        let Fund_Code = myStringFund_Code!.stringByTrimmingCharactersInSet(
                                            NSCharacterSet.whitespaceAndNewlineCharacterSet()
                                        )
                                        //
                                        let dicToSend:NSDictionary = [
                                            "Scheme_Code" : Scheme_Code,
                                            "Fund_Code" : Fund_Code,
                                            "Txn_Type" : "V"]
                                        print(dicToSend)
                                        
                                        WebManagerHK.postDataToURL(kModeGetSchemeThresholdDetails, params: dicToSend, message: "") { (response) in
                                            
                                            print(response)
                                            
                                            if response.objectForKey(kWAPIResponse) is NSArray
                                            {
                                                let mainResponse = response.objectForKey(kWAPIResponse) as! NSArray
                                                print("Dic Response : \(mainResponse)")
                                                if mainResponse.count==0
                                                {
                                                    
                                                }
                                                else{
                                                    
                                                    self.arrSIPSoldDetails = mainResponse.mutableCopy() as! NSMutableArray
                                                    
                                                    if self.arrFrequency.count==0{
                                                    }else{
                                                        self.arrFrequency.removeAllObjects()
                                                    }
                                                    
                                                    self.arrFrequency.addObject("SELECT")
                                                    
                                                    for dicMoreDt in self.arrSIPSoldDetails {
                                                        print(dicMoreDt)
                                                        self.arrFrequency.addObject(dicMoreDt.valueForKey("Sys_Freq")!)
                                                    }
                                                    print("All Frequency \(self.arrFrequency)")
                                                    
                                                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                                        self.enumFrequencySelectedIndex = 0
                                                        self.txtFrequency.text = self.arrFrequency.objectAtIndex(self.enumFrequencySelectedIndex) as? String
                                                        
                                                        self.randomVal = sharedInstance.getRandomVal()
                                                        self.tblView.reloadData()
                                                        
                                                    })
                                                    
                                                    
                                                }
                                            }
                                            else
                                            {
                                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                                    self.randomVal = sharedInstance.getRandomVal()
                                                    self.tblView.reloadData()
                                                })
                                            }
                                        }
                                        
                                        
                                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                            //self.viewWillAppear(true)
                                            
                                            
                                        })
                                        
                                        
                                        
                                    })
                                }
                                
                                self.tblView.reloadData()

                                
                            }else{
                                // NOT ALLOWED.....
                                SharedManager.invokeAlertMethod(APP_NAME, strBody: "SIP Not Allowed in this fund, please choose different fund.", delegate: nil)
                            }
                        }
                        
                        self.tblView.reloadData()
                        
                    }) /// DISPATCH END.........
                }
            }
        }else{
            
            isBuyFrom = kBUY_FOR_SIP
            
            if btnOneTimeRadioSIP==nil {
                lblTitle.text = "SIP"
                
            }else{
                
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
                
                if let BuyNowScheme = sharedInstance.userDefaults.objectForKey(kSelectBuyNowScheme) as? NSDictionary
                {
                    print(BuyNowScheme)
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        let myStringDivOpt = BuyNowScheme.valueForKey("Div_Opt")
                        let Div_Opt = myStringDivOpt!.stringByTrimmingCharactersInSet(
                            NSCharacterSet.whitespaceAndNewlineCharacterSet()
                        )
                        if Div_Opt=="NA" { // NA.....
                            //                        self.txtDividendOption.hidden = true
                            //                        self.lblDividendOption.hidden = true
                        }
                        if let nav = BuyNowScheme.valueForKey("NAV")
                        {
                            if let nav_date = BuyNowScheme.valueForKey("NAVDate")
                            {
                                let twoDecimalPlaces = String(format: "%.2f", nav as! Double)
                                
                                self.txtNav.text = "\(twoDecimalPlaces) As On \(sharedInstance.getFormatedDate(nav_date as! String))"
                                
                                if (self.txtNavSIP != nil)
                                {
                                    self.txtNavSIP.text = "\(twoDecimalPlaces) As On \(sharedInstance.getFormatedDate(nav_date as! String))"
                                }
                            }
                        }
                        
                        if (self.lbltxtSchemeName != nil) {
                            self.lbltxtSchemeName.text = BuyNowScheme.valueForKey("Plan_Name") as? String
                        }
                        if (self.lbltxtSchemeNameSIP != nil) {
                            self.lbltxtSchemeNameSIP.text = BuyNowScheme.valueForKey("Plan_Name") as? String
                        }
                        
                        self.tblView.reloadData()

                    })
                }
                self.tblView.reloadData()
            }
        }
        tblView.reloadData()
    }
    
    
    func loadYears() {
        
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day , .Month , .Year], fromDate: date)
        
        var year =  components.year
        let month = components.month
        let day = components.day
        
        print(year)
        print(month)
        print(day)
        
        arrYears.addObject("SELECT")

        arrYears.addObject("\(year)")
        
        for _ in 1...50 {
            
            year = year + 1
            arrYears.addObject("\(year)")
        }
        
        switch month {
        case 1:
            enumStartMonthSelected = MONTH.JAN
            break
        case 2:
            enumStartMonthSelected = MONTH.FEB
            break
        case 3:
            enumStartMonthSelected = MONTH.MAR
            break
        case 4:
            enumStartMonthSelected = MONTH.APR
            break
        case 5:
            enumStartMonthSelected = MONTH.MAY
            break
        case 6:
            enumStartMonthSelected = MONTH.JUN
            break
        case 7:
            enumStartMonthSelected = MONTH.JUL
            break
        case 8:
            enumStartMonthSelected = MONTH.AUG
            break
        case 9:
            enumStartMonthSelected = MONTH.SEP
            break
        case 10:
            enumStartMonthSelected = MONTH.OCT
            break
        case 11:
            enumStartMonthSelected = MONTH.NOV
            break
        case 12:
            enumStartMonthSelected = MONTH.DEC
            break

        default:
                break
        }
    }
    
    
    
    
    
    
    
    func checkDetailsForPreselected(BuyNowScheme : NSDictionary) {
        
        let dic = NSMutableDictionary()
        dic["Scheme_Code"] = BuyNowScheme.valueForKey("Scheme_Code")
        dic["Fund_Code"] = BuyNowScheme.valueForKey("Fund_Code")
        
        WebManagerHK.postDataToURL(kModeGetSchemeDetails, params: dic, message: "Checking details...") { (response) in
            
            if response.objectForKey(kWAPIResponse) is NSDictionary
            {
                let mainResponse = response.objectForKey(kWAPIResponse) as! NSDictionary
                print("Dic Response For TopFunds: \(mainResponse)")
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in // DISPATCH START...
                    

                    if let Pur_Allowed = mainResponse.valueForKey("Pur_Allowed")
                    {
                        if Pur_Allowed as! String=="Y"
                        {
                            if let BuyNowScheme = sharedInstance.userDefaults.objectForKey(kSelectBuyNowScheme) as? NSDictionary
                            {
                                print(BuyNowScheme)
                                
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    
                                    self.randomVal = sharedInstance.getRandomVal()

                                    var Div_Opt = ""
                                    if let myStringDivOpt = BuyNowScheme.valueForKey("Div_Opt")
                                    {
                                        Div_Opt = myStringDivOpt.stringByTrimmingCharactersInSet(
                                            NSCharacterSet.whitespaceAndNewlineCharacterSet()
                                        )
                                        if Div_Opt=="NA" { // NA.....
                                        }
                                    }
                                    
                                    
                                    if let myStringPlan_Opt = mainResponse.valueForKey("Plan_Opt")
                                    {
                                        print(myStringPlan_Opt)

                                        let Plan_Opt = myStringPlan_Opt.stringByTrimmingCharactersInSet(
                                            NSCharacterSet.whitespaceAndNewlineCharacterSet()
                                        )
                                        if Plan_Opt=="NA" { // NA.....
                                        }
                                        
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
                                        
                                        self.isNAVAvailable = true

                                        self.tblView.reloadData()

                                    }
                                    self.tblView.reloadData()

                                })
                                
                                self.tblView.reloadData()
                            }
                            
                        }
                        
                    }
                    
                    self.tblView.reloadData()
                    
                }) /// DISPATCH END.........
            }
        }

        
    }
}
