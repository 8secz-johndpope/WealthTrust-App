//
//  OtherInfo.swift
//  WealthTrust
//
//  Created by Hemen Gohil on 9/4/16.
//  Copyright © 2016 Hemen Gohil. All rights reserved.
//

import UIKit


let TAG_MODEOFHOLDING = 101
let TAG_TAX_STATUS = 102
let TAG_BANK_PROOF = 103
let TAG_ACCOUNT_TYPE = 104
let TAG_SOURCE_OF_WEALTH = 105
let TAG_ADDRESS_TYPE = 106
let TAG_GROSS_ANUAL_INCOME = 107
let TAG_OCCUPATION = 108
let TAG_POLITICAL = 109
let TAG_TAX_RESIDENCY = 110
let TAG_NOMINEE = 111
let TAG_NOMINEE_RELATIONSHIP = 112

let UDKey = "DictOtherInfoAllData"

// User Default Personal Info
let UDKeyModeOfHolding = "ModeOfHolding"
let UDDOB = "DOBFirstStep"
let UDTaxStatus = "TaxStatus"
let UDPersonalInfoDone = "PersonalInfo"

// User Default Bank Detail
let UDBankAccNum = "BankAcNumber"
let UDBankAccType = "BankAccType"
let UDBankProofType = "BankProofType"
let UDBankProofByEmail = "BankProofByEmail"
let UDBankProofData = "BankProofData"
let UDBankIFSC = "BankIFSC"
let UDSIPAmount = "BankSIPAmount"
let UDBankDetailDone = "BankDetail"

// User Default Identity Info
let UDCountryOfBirth = "CountryOfBirth"
let UDPlaceOfBirth = "PlaceOfBirth"
let UDSourceOfWealth = "SourceOfWealth"
let UDSourceOfWealthOther = "SourceOfWealthOther"
let UDAddressType = "AddressType"
let UDGrossAnualIncome = "GrossAnualIncome"
let UDOccupation = "Occupation"
let UDOccupationOther = "OccupationOther"
let UDPoliticallyExposedPerson = "PoliticallyExposedPerson"
let UDTaxResidency = "TaxResidency"
let UDIdentityInfoDone = "IdentityInfo"

// User Default Nominee
let UDNominee = "Nominee"
let UDNomineeName = "NomineeName"
let UDNomineeDOB = "NomineeDOB"
let UDNomineeRelationship = "RelationShip"
let UDNomineeRelationshipOther = "RelationShipOther"
let UDNomineeDone = "NomineeInfo"



class OtherInfo: UIViewController,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var tblView: UITableView!
    var txtCurrentTextField : UITextField!
    
    var currentMode = InfoMode.PersonalInfoMode
    var enumModeOfHolding = ModeOfHolding.Single
    var enumTaxStatus = TaxStatus.ResidentIndividual
    var enumBankProof = ProofOfAccount.CancelledChequeOrCopy
    var enumAccountType = AccType.Savings
    var enumSourceOfWealth = PrimarySourceOfWealth.Salary
    var enumAddressType = TypeOfAddressGivenAtKra.Residential
    var enumGrossAnualIncome = GrossAnualIncome.OneTo5Lakh
    var enumOccupation = Occupation.Service
    var enumPoliticallyExposedPerson = PoliticallyExposedPerson.NA
    var enumTexResidency = YesNo.No
    var enumNominee = YesNo.Yes
    var enumNomineeRelationship = NomineeRelationship.Wife
    
    @IBOutlet var toolBar: UIToolbar!
    // First Step...
    var txtModeOfHoldings : UITextField!
    var txtDOBFirstStep : RPFloatingPlaceholderTextField!
    var txtTaxStatusFirstStep : UITextField!
    //    var txtContactAddress : UITextField!
    //    var txtPincode : RPFloatingPlaceholderTextField!
    //    var txtCity : RPFloatingPlaceholderTextField!
    //    var txtState : RPFloatingPlaceholderTextField!
    //    var txtCountry : UITextField!
    
    // Second Steps...
    var txtAccountNumber : RPFloatingPlaceholderTextField!
    var txtBankProof : UITextField!
    
    var btnClickPicturePanIcon : UIButton!
    var btnClickPicturePan : UIButton!
    
    var btnUploadPicturePanIcon : UIButton!
    var btnUploadPicturePan : UIButton!
    
    var btnCheckBoxPanEmail : UIButton!
    var btnCheckPanEmail : UIButton!
    
    var txtIFSC : RPFloatingPlaceholderTextField!
    var txtMaximumSIP : RPFloatingPlaceholderTextField!
    
    var lblUploadPanText : UILabel!
    
    
    // Third Step....
    var txtCountryOfBirth : UITextField!
    var txtPlaceOfBirth : RPFloatingPlaceholderTextField!
    var txtTaxResidency : UITextField!
    var txtSourceOfWealth : UITextField!
    var txtSourceOfWealthOther : UITextField!
    var txtSourceOfLine : UILabel!
    
    var txtOccupationOther : UITextField!
    var txtOccupationLine : UILabel!
    
    
    // Fourth Step...
    var txtNominee : UITextField!
    var txtNomineeName : UITextField!
    var txtDOB : UITextField!
    var txtRelationShip : UITextField!
    var txtRelationShipOther : UITextField!
    var txtRelationShipLine:UILabel!
    
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var lbl1: UILabel!
    
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var lbl2: UILabel!
    
    @IBOutlet weak var btn3: UIButton!
    @IBOutlet weak var lbl3: UILabel!
    
    @IBOutlet weak var btn4: UIButton!
    @IBOutlet weak var lbl4: UILabel!
    
    @IBOutlet weak var btn5: UIButton!
    @IBOutlet weak var lbl5: UILabel!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var lblLine1: UILabel!
    @IBOutlet weak var lblLine2: UILabel!
    @IBOutlet weak var lblLine3: UILabel!
    @IBOutlet weak var lblLine4: UILabel!
    
    
    var pickerView = UIPickerView()
    var datePickerViewFirstStep  : UIDatePicker = UIDatePicker()
    var datePickerViewDOB  : UIDatePicker = UIDatePicker()
    
    let picker = UIImagePickerController()
    var imagePicked : UIImage!
    var imageClickedIndex = 0
    var lblImageUploadedRight : UIImageView!
    
    var isFrom = IS_FROM.Profile
    var dictOtherInfoAllData = NSMutableDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        
        // Do any additional setup after loading the view, typically from a nib.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIKeyboardDidHideNotification, object: nil)
        
        tblView.sectionFooterHeight = 40
        
        let view = UIView(frame: CGRect(x: 0, y: self.view.frame.size.height-44, width: self.view.frame.size.width, height: 44))
        view.backgroundColor = UIColor.whiteColor()
        
        let buttonSubmit = UIButton(frame: CGRect(x: view.frame.size.width-80, y: 0, width: 70, height: 36))
        buttonSubmit.setTitle("NEXT", forState: .Normal)
        buttonSubmit.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        buttonSubmit.backgroundColor = UIColor.defaultOrangeButton
        buttonSubmit.titleLabel?.font = UIFont.systemFontOfSize(14)
        buttonSubmit.layer.cornerRadius = 1.5
        buttonSubmit.addTarget(self, action: #selector(OtherInfo.btnNextClicked(_:)), forControlEvents: .TouchUpInside)
        view.addSubview(buttonSubmit)
        
        let buttonCancel = UIButton(frame: CGRect(x: view.frame.size.width-(80*2), y: 0, width: 70, height: 36))
        buttonCancel.setTitle("SKIP", forState: .Normal)
        buttonCancel.setTitleColor(UIColor.defaultOrangeButton, forState: .Normal)
        buttonCancel.backgroundColor = UIColor.whiteColor()
        buttonCancel.titleLabel?.font = UIFont.systemFontOfSize(14)
        buttonCancel.layer.cornerRadius = 1.5
        buttonCancel.layer.borderColor = UIColor.defaultOrangeButton.CGColor
        buttonCancel.layer.borderWidth = 1.0
        buttonCancel.addTarget(self, action: #selector(OtherInfo.btnSkipClicked(_:)), forControlEvents: .TouchUpInside)
        view.addSubview(buttonCancel)
        self.view.addSubview(view)
        
        lblLine1.backgroundColor = UIColor.defaultAppColorBlue
        lblLine2.backgroundColor = UIColor.defaultMenuGray
        lblLine3.backgroundColor = UIColor.defaultMenuGray
        lblLine4.backgroundColor = UIColor.defaultMenuGray
        
        
        picker.delegate = self
        
        if (sharedInstance.userDefaults.valueForKey(UDKey) != nil) {
            dictOtherInfoAllData = (sharedInstance.userDefaults.objectForKey(UDKey)?.mutableCopy())! as! NSMutableDictionary
            
            // Set default values if null
            
            
            
            
            print("dictSaved: \(sharedInstance.userDefaults.valueForKey(UDKey)as! NSMutableDictionary)")
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.hidden = true
        let value = UIInterfaceOrientation.Portrait.rawValue
        UIDevice.currentDevice().setValue(value, forKey: "orientation")
        
        //        tblView.reloadData()
    }
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBar.hidden = false
    }
    @IBAction func btnTollbarDone(sender: AnyObject) {
        view.endEditing(true)
    }
    func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy" // yyyy-mm-dd
        txtDOBFirstStep.text = dateFormatter.stringFromDate(sender.date)
        self.saveDictionaryOtherInfo(UDDOB, value: txtDOBFirstStep.text!)
    }
    func handleDatePickerDOB(sender: UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        txtDOB.text = dateFormatter.stringFromDate(sender.date)
        self.saveDictionaryOtherInfo(UDNomineeDOB, value: txtDOB.text!)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setAllDetails() {
        
        if !self.validateStepPersonalInfo(true) {
            currentMode = .PersonalInfoMode
            lblTitle.text = "PERSONAL INFO"
            tblView.reloadData()
            return
        }
        
        if !self.validateStepBankDetail(true) {
            currentMode = .BankInfoMode
            lblTitle.text = "BANK INFO"
            tblView.reloadData()
            return
        }
        
        if !self.validateStepIdentityInfo(true) {
            currentMode = .IdentitykInfoMode
            lblTitle.text = "IDENTITY INFO"
            tblView.reloadData()
            return
        }
        
        if !self.validateStepNominee(true) {
            currentMode = .NominyInfoMode
            
            lblTitle.text = "NOMINEE INFO"
            tblView.reloadData()
            return
        }
        
        
        let dic = NSMutableDictionary()
        dic["ModeOfHolding"] = dictOtherInfoAllData[UDKeyModeOfHolding] as! Int
        
        // Residential Individual
        if TaxStatus.fromHashValue(dictOtherInfoAllData[UDTaxStatus] as! Int) == TaxStatus.ResidentIndividual {
            dic["InvestorCategory"] = "0"
            dic["ResidentialStatus"] = "0"
        }
            
            // Sole Properiter
        else if  TaxStatus.fromHashValue(dictOtherInfoAllData[UDTaxStatus] as! Int) == TaxStatus.SoleProprietor  {
            dic["InvestorCategory"] = "2"
            dic["ResidentialStatus"] = "0"
        }
        
        dic["ClientId"] = sharedInstance.objLoginUser.ClientID
        dic["RelationshipID"] = sharedInstance.objLoginUser.ClientID
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        
        let stringDOB = sharedInstance.getFormatedDateYYYYMMDD(dateFormatter.dateFromString((dictOtherInfoAllData[UDDOB] as? String)!)!)
        dic["DOB"] = stringDOB
        
        dic["ProofAttached"] = ""
        dic["ProofType"] = dictOtherInfoAllData[UDBankProofType] as! Int
        dic["GurdianPAN"] = ""
        dic["GurdianName"] = ""
        dic["GurdianDOB"] = ""
        dic["PassWord"] = sharedInstance.objLoginUser.password
        dic["RelationshipWithMinor"] = ""
        dic["ProofTypeGuardian"] = ""
        dic["SecondApplicantDOB"] = ""
        dic["SecondApplicantPAN"] = ""
        dic["SeconApplicantName"] = ""
        
        dic["ThiredApplicantDOB"] = ""
        dic["ThiredApplicantPAN"] = ""
        dic["ThiredApplicantName"] = ""
        
        dic["CommunicationAddress"] = ""
        dic["CommunicationCity"] = ""
        dic["CommunicationPinCode"] = ""
        dic["CommunicationState"] = ""
        dic["CommunicationLandLine"] = ""
        dic["CommunicationMobileISD"] = "91"
        dic["CommunicationEmail"] = sharedInstance.objLoginUser.email
        dic["CommunicationSecondLandLine"] = ""
        dic["CommunicationSecondMobile"] = ""
        dic["CommunicationSecondEmail"] = ""
        dic["CommunicationThirdLandLine"] = ""
        dic["CommunicationThirdMobile"] = ""
        dic["CommunicationThirdEmail"] = ""
        dic["GurdianLandLine"] = ""
        dic["GurdianMobile"] = ""
        dic["GurdianEmail"] = ""
        dic["BankAcNumber"] = dictOtherInfoAllData[UDBankAccNum]
        dic["BankAcType"] = dictOtherInfoAllData[UDBankAccType] as! Int
        dic["BankMICR"] = ""
        dic["BankIFSC"] = dictOtherInfoAllData[UDBankIFSC]
        dic["BankName"] = ""
        dic["BankBranchName"] = ""
        dic["Amount"] = dictOtherInfoAllData[UDSIPAmount]
        dic["BankBranchCity"] = ""
        dic["BankProofOfAccount"] = enumAccountType.hashValue
        dic["PayEezzRegistrationForm"] = "0"
        dic["NomineeCheck"] = dictOtherInfoAllData[UDNominee] as! Int
        
        if YesNo.fromHashValue(dictOtherInfoAllData[UDNominee] as! Int) == YesNo.Yes {
            if txtNomineeName.text==nil {
                txtNomineeName.text = ""
            }
            if txtRelationShip.text==nil {
                txtRelationShip.text = ""
            }
            
            dic["NameOfNominee"] = dictOtherInfoAllData[UDNomineeName]
            
            
            if (dictOtherInfoAllData[UDNomineeRelationship] as! Int) == NomineeRelationship.Other.hashValue {
                if (dictOtherInfoAllData[UDNomineeRelationshipOther]) != nil {
                    dic["RelationshipWithNominee"] = dictOtherInfoAllData[UDNomineeRelationshipOther]
                }
            }
            else
            {
                dic["RelationshipWithNominee"] = NomineeRelationship.allValues[dictOtherInfoAllData[UDNomineeRelationship] as! Int]
            }
            
            dic["Proportion"] = "100"
            
            let stringNomiDOB = sharedInstance.getFormatedDateYYYYMMDD(dateFormatter.dateFromString((dictOtherInfoAllData[UDNomineeDOB] as? String)!)!)
            dic["NomineeDOB"] = stringNomiDOB
            
        }else{
            dic["NameOfNominee"] = ""
            dic["RelationshipWithNominee"] = ""
        }
        
        dic["GrossAnnualIncome"] = dictOtherInfoAllData[UDGrossAnualIncome] as! Int
        dic["PrimarySourceOfWealt"] = dictOtherInfoAllData[UDSourceOfWealth] as! Int
        if PrimarySourceOfWealth.fromHashValue(dictOtherInfoAllData[UDSourceOfWealth] as! Int) == PrimarySourceOfWealth.Other
        {
            dic["SourceOfWealthOther"] = dictOtherInfoAllData[UDSourceOfWealthOther]
        }else
        {
            dic["SourceOfWealthOther"] = ""
        }
        
        dic["Occupation"] = dictOtherInfoAllData[UDOccupation] as! Int
        if Occupation.fromHashValue(dictOtherInfoAllData[UDOccupation] as! Int) == Occupation.Other
        {
            dic["OccupationOther"] = dictOtherInfoAllData[UDOccupationOther]
        }else
        {
            dic["OccupationOther"] = ""
        }
        
        
        dic["PoliticallyExposedPerson"] = dictOtherInfoAllData[UDPoliticallyExposedPerson] as! Int
        dic["TypeOfAddress"] = dictOtherInfoAllData[UDAddressType] as! Int
        dic["ResidentialStatusOfGurdian"] = "0"
        dic["SolePOB"] = dictOtherInfoAllData[UDPlaceOfBirth]
        dic["SoleCOB"] = dictOtherInfoAllData[UDCountryOfBirth]
        dic["SoleCOC"] = dictOtherInfoAllData[UDCountryOfBirth]
        dic["SoleCON"] = dictOtherInfoAllData[UDCountryOfBirth]
        dic["SoleNO"] = dictOtherInfoAllData[UDTaxResidency] as! Int
        
        
        var selected = false
        let arrDic : NSMutableArray = []
        if (dictOtherInfoAllData[UDBankProofByEmail] != nil) { //ProofType
            selected = dictOtherInfoAllData[UDBankProofByEmail] as! Bool
            if (!selected)
            {
                if (dictOtherInfoAllData[UDBankProofData] != nil) {
                    arrDic.addObject(["DocumentType" : "\(DocumentType.Bankproof.hashValue)","SendCopyType" : "App","DocumentData" : dictOtherInfoAllData[UDBankProofData] as! String])
                }
            }
            else
            {
                arrDic.addObject(["DocumentType":"\(DocumentType.Bankproof.hashValue)","SendCopyType" : "Email","DocumentData" : ""])
            }
        }
        
        dic["ImageArr"] = arrDic
        
        
        print("All Prepared Data : \(dic)")
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            
            let objSignature = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdSignatureScreen) as! SignatureScreen
            objSignature.isFrom = self.isFrom
            objSignature.dicToSend = dic
            self.navigationController?.pushViewController(objSignature, animated: true)
            
        })
        
    }
    
    func saveDictionaryOtherInfo(key:String, value:AnyObject)  {
        dictOtherInfoAllData.setObject(value, forKey: key)
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
        self.view.endEditing(true)
        sharedInstance.userDefaults.setObject(dictOtherInfoAllData, forKey: UDKey)
        sharedInstance.userDefaults.synchronize()
        print("dictSaved: \(sharedInstance.userDefaults.objectForKey(UDKey)as! NSMutableDictionary)")
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
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if txtCurrentTextField.tag == TAG_MODEOFHOLDING {
            return ModeOfHolding.allValues.count
        }
        if txtCurrentTextField.tag == TAG_TAX_STATUS {
            return TaxStatus.allValues.count
        }
        if txtCurrentTextField.tag == TAG_BANK_PROOF {
            return ProofOfAccount.allValues.count
        }
        if txtCurrentTextField.tag == TAG_ACCOUNT_TYPE {
            return AccType.allValues.count
        }
        if txtCurrentTextField.tag == TAG_SOURCE_OF_WEALTH {
            return PrimarySourceOfWealth.allValues.count
        }
        if txtCurrentTextField.tag == TAG_ADDRESS_TYPE {
            return TypeOfAddressGivenAtKra.allValues.count
        }
        if txtCurrentTextField.tag == TAG_GROSS_ANUAL_INCOME {
            return GrossAnualIncome.allValues.count
        }
        if txtCurrentTextField.tag == TAG_OCCUPATION {
            return Occupation.allValues.count
        }
        if txtCurrentTextField.tag == TAG_POLITICAL {
            return PoliticallyExposedPerson.allValues.count
        }
        
        if txtCurrentTextField.tag == TAG_TAX_RESIDENCY {
            return YesNo.allValues.count
        }
        if txtCurrentTextField.tag == TAG_NOMINEE {
            return YesNo.allValues.count
        }
        if txtCurrentTextField.tag == TAG_NOMINEE_RELATIONSHIP {
            return NomineeRelationship.allValues.count
        }
        
        return 0
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if txtCurrentTextField.tag == TAG_MODEOFHOLDING {
            return ModeOfHolding.allValues[row]
        }
        if txtCurrentTextField.tag == TAG_TAX_STATUS {
            return TaxStatus.allValues[row]
        }
        if txtCurrentTextField.tag == TAG_BANK_PROOF {
            return ProofOfAccount.allValues[row]
        }
        if txtCurrentTextField.tag == TAG_ACCOUNT_TYPE {
            return AccType.allValues[row]
        }
        if txtCurrentTextField.tag == TAG_SOURCE_OF_WEALTH {
            return PrimarySourceOfWealth.allValues[row]
        }
        if txtCurrentTextField.tag == TAG_ADDRESS_TYPE {
            return TypeOfAddressGivenAtKra.allValues[row]
        }
        if txtCurrentTextField.tag == TAG_GROSS_ANUAL_INCOME {
            return GrossAnualIncome.allValues[row]
        }
        if txtCurrentTextField.tag == TAG_OCCUPATION {
            return Occupation.allValues[row]
        }
        if txtCurrentTextField.tag == TAG_POLITICAL {
            return PoliticallyExposedPerson.allValues[row]
        }
        if txtCurrentTextField.tag == TAG_TAX_RESIDENCY {
            return YesNo.allValues[row]
        }
        if txtCurrentTextField.tag == TAG_NOMINEE {
            return YesNo.allValues[row]
        }
        if txtCurrentTextField.tag == TAG_NOMINEE_RELATIONSHIP {
            return NomineeRelationship.allValues[row]
        }
        
        return "DefaulyValue"
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if txtCurrentTextField.tag == TAG_MODEOFHOLDING {
            txtCurrentTextField.text = ModeOfHolding.allValues[row]
            enumModeOfHolding = ModeOfHolding.fromHashValue(row)
            print("Selected : \(enumModeOfHolding) ,Index : \(enumModeOfHolding.hashValue)")
            //self.saveDictionaryOtherInfo(UDKeyModeOfHolding, value: enumModeOfHolding.hashValue)
            //dictOtherInfoAllData.setObject((enumModeOfHolding.hashValue).stringValue, forKey: UDKeyModeOfHolding)
            dictOtherInfoAllData.setObject(NSNumber(integer: enumModeOfHolding.hashValue), forKey: UDKeyModeOfHolding)
            txtCurrentTextField.resignFirstResponder()
        }
        
        if txtCurrentTextField.tag == TAG_TAX_STATUS {
            txtCurrentTextField.text = TaxStatus.allValues[row]
            enumTaxStatus = TaxStatus.fromHashValue(row)
            self.saveDictionaryOtherInfo(UDTaxStatus, value: enumTaxStatus.hashValue)
            txtCurrentTextField.resignFirstResponder()
        }
        
        if txtCurrentTextField.tag == TAG_BANK_PROOF {
            txtCurrentTextField.text = ProofOfAccount.allValues[row]
            enumBankProof = ProofOfAccount.fromHashValue(row)
            self.saveDictionaryOtherInfo(UDBankProofType, value: enumBankProof.hashValue)
            txtCurrentTextField.resignFirstResponder()
            
            lblUploadPanText.text = "Upload \(ProofOfAccount.allValues[row])"
            switch row {
            case 0:
                btnCheckPanEmail.setTitle(" I will send Cancelled Cheque copy by e-mail", forState: .Normal)
                break;
            case 1:
                btnCheckPanEmail.setTitle(" I will send Bank Passbook copy by e-mail", forState: .Normal)
                break;
            case 2:
                btnCheckPanEmail.setTitle(" I will send Bank Statement copy by e-mail", forState: .Normal)
                break;
            case 3:
                btnCheckPanEmail.setTitle(" I will send Latter from the bank copy by e-mail", forState: .Normal)
                break;
                
            default:
                break
            }
            
            //            static let allValues = ["Cancelled Cheque", "Bank Pasbook", "Bank Statement", "Letter From Bank Confirming Account"]
            
        }
        
        if txtCurrentTextField.tag == TAG_ACCOUNT_TYPE {
            txtCurrentTextField.text = AccType.allValues[row]
            enumAccountType = AccType.fromHashValue(row)
            self.saveDictionaryOtherInfo(UDBankAccType, value: enumAccountType.hashValue)
            txtCurrentTextField.resignFirstResponder()
        }
        
        if txtCurrentTextField.tag == TAG_SOURCE_OF_WEALTH {
            txtCurrentTextField.text = PrimarySourceOfWealth.allValues[row]
            enumSourceOfWealth = PrimarySourceOfWealth.fromHashValue(row)
            self.saveDictionaryOtherInfo(UDSourceOfWealth, value: enumSourceOfWealth.hashValue)
            txtCurrentTextField.resignFirstResponder()
            
            if enumSourceOfWealth.hashValue==7 {
                txtSourceOfWealthOther.hidden = false
                txtSourceOfLine.hidden = false
            }else{
                txtSourceOfWealthOther.hidden = true
                txtSourceOfLine.hidden = true
            }
            
            tblView.reloadData()
            
        }
        
        if txtCurrentTextField.tag == TAG_ADDRESS_TYPE {
            print(TypeOfAddressGivenAtKra.allValues[row])
            
            txtCurrentTextField.text = TypeOfAddressGivenAtKra.allValues[row]
            
            enumAddressType = TypeOfAddressGivenAtKra.fromHashValue(row)
            self.saveDictionaryOtherInfo(UDAddressType, value: enumAddressType.hashValue)
            txtCurrentTextField.resignFirstResponder()
            
        }
        
        if txtCurrentTextField.tag == TAG_GROSS_ANUAL_INCOME {
            txtCurrentTextField.text = GrossAnualIncome.allValues[row]
            enumGrossAnualIncome = GrossAnualIncome.fromHashValue(row)
            self.saveDictionaryOtherInfo(UDGrossAnualIncome, value: enumGrossAnualIncome.hashValue)
            txtCurrentTextField.resignFirstResponder()
        }
        
        if txtCurrentTextField.tag == TAG_OCCUPATION {
            txtCurrentTextField.text = Occupation.allValues[row]
            enumOccupation = Occupation.fromHashValue(row)
            self.saveDictionaryOtherInfo(UDOccupation, value: enumOccupation.hashValue)
            txtCurrentTextField.resignFirstResponder()
            
            if enumOccupation.hashValue==12 {
                txtOccupationOther.hidden = false
                txtOccupationLine.hidden = false
            }else{
                txtOccupationOther.hidden = true
                txtOccupationLine.hidden = true
            }
            tblView.reloadData()
        }
        if txtCurrentTextField.tag == TAG_POLITICAL {
            txtCurrentTextField.text = PoliticallyExposedPerson.allValues[row]
            enumPoliticallyExposedPerson = PoliticallyExposedPerson.fromHashValue(row)
            self.saveDictionaryOtherInfo(UDPoliticallyExposedPerson, value: enumPoliticallyExposedPerson.hashValue)
            txtCurrentTextField.resignFirstResponder()
        }
        
        if txtCurrentTextField.tag == TAG_TAX_RESIDENCY {
            txtCurrentTextField.text = YesNo.allValues[row]
            enumTexResidency = YesNo.fromHashValue(row)
            self.saveDictionaryOtherInfo(UDTaxResidency, value: enumTexResidency.hashValue)
            txtCurrentTextField.resignFirstResponder()
        }
        
        if txtCurrentTextField.tag == TAG_NOMINEE {
            txtCurrentTextField.text = YesNo.allValues[row]
            enumNominee = YesNo.fromHashValue(row)
            self.saveDictionaryOtherInfo(UDNominee, value: enumNominee.hashValue)
            txtCurrentTextField.resignFirstResponder()
            
            tblView.reloadData()
        }
        if txtCurrentTextField.tag == TAG_NOMINEE_RELATIONSHIP {
            txtRelationShip.text = NomineeRelationship.allValues[row]
            enumNomineeRelationship = NomineeRelationship.fromHashValue(row)
            self.saveDictionaryOtherInfo(UDNomineeRelationship, value: enumNomineeRelationship.hashValue)
            txtCurrentTextField.resignFirstResponder()
            
            if enumNomineeRelationship.hashValue==NomineeRelationship.Other.hashValue {
                txtRelationShipOther.hidden = false
                txtRelationShipLine.hidden = false
            }else{
                txtRelationShipOther.hidden = true
                txtRelationShipLine.hidden = true
            }
            tblView.reloadData()
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch currentMode {
        case .PersonalInfoMode:
            return 3
        case .BankInfoMode:
            return 6
        case .IdentitykInfoMode:
            return 8
        case .NominyInfoMode:
            
            if (dictOtherInfoAllData[UDNominee] != nil) {
                enumNominee = YesNo.fromHashValue(dictOtherInfoAllData[UDNominee] as! Int)
            }
            if YesNo.allValues[enumNominee.hashValue]=="Yes" {
                return 4
            }
            if YesNo.allValues[enumNominee.hashValue]=="No" {
                return 1
            }
            return 4
            
        case .SignatureInfoMode:
            return 5
        default:
            break;
        }
        return 0
    }
    
    func getDownArrow() -> UIImageView {
        var imgDownArrow : UIImageView!
        imgDownArrow = UIImageView(frame: CGRect(x: (self.view.frame.size.width)-35, y: 23, width: 30, height: 30));
        imgDownArrow.image = UIImage(named: "iconDown")
        imgDownArrow.backgroundColor = UIColor.clearColor()
        
        return imgDownArrow
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        let string = "CELL_ALL_\(currentMode)_\(enumOccupation.hashValue)_\(enumSourceOfWealth.hashValue)"
        print(string)
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: string)
        
        let cell = tableView.dequeueReusableCellWithIdentifier(string, forIndexPath: indexPath) as UITableViewCell
        
        switch currentMode {
        case .PersonalInfoMode:
            
            if (cell.contentView.subviews.count==0) {
                
                switch indexPath.row {
                case 0:
                    
                    var lblMode : UILabel!
                    lblMode = UILabel(frame: CGRect(x: 10, y: 0, width: (cell.contentView.frame.size.width)-20, height: 20));
                    lblMode.text = "Mode Of Holding"
                    lblMode.font = UIFont.systemFontOfSize(12)
                    lblMode.textColor = UIColor.defaultMenuGray
                    cell.contentView.addSubview(lblMode)
                    
                    txtModeOfHoldings = UITextField(frame: CGRect(x: 10, y: 20, width: (cell.contentView.frame.size.width)-20, height: 35));
                    if (dictOtherInfoAllData[UDKeyModeOfHolding] != nil) {
                        enumModeOfHolding = ModeOfHolding.fromHashValue(dictOtherInfoAllData[UDKeyModeOfHolding] as! Int)
                    }
                    txtModeOfHoldings.text = ModeOfHolding.allValues[enumModeOfHolding.hashValue]
                    self.saveDictionaryOtherInfo(UDKeyModeOfHolding, value: enumModeOfHolding.hashValue)
                    
                    txtModeOfHoldings.tag = TAG_MODEOFHOLDING
                    txtModeOfHoldings.keyboardType = UIKeyboardType.Default
                    self.applyTextFiledStyle1(txtModeOfHoldings)
                    cell.contentView.addSubview(txtModeOfHoldings)
                    txtModeOfHoldings.inputView = pickerView
                    
                    var lblLine : UILabel!
                    lblLine = UILabel(frame: CGRect(x: 10, y: 55-3, width: (cell.contentView.frame.size.width)-20, height: 1));
                    lblLine.backgroundColor = UIColor.lightGrayColor()
                    cell.contentView.addSubview(lblLine)
                    cell.contentView.addSubview(self.getDownArrow())
                    
                    return cell;
                    
                case 1:
                    txtDOBFirstStep = RPFloatingPlaceholderTextField(frame: CGRect(x: 10, y: 10, width: (cell.contentView.frame.size.width)-20, height: 35));
                    txtDOBFirstStep.placeholder = "DOB(DD-MMM-YYYY)"
                    txtDOBFirstStep.keyboardType = UIKeyboardType.Default
                    self.applyTextFiledStyle1(txtDOBFirstStep)
                    txtDOBFirstStep.inputAccessoryView = toolBar
                    if (dictOtherInfoAllData[UDDOB] != nil) {
                        txtDOBFirstStep.text = dictOtherInfoAllData[UDDOB]as? String
                    }
                    else {
                        let currentDate: NSDate = NSDate()
                        datePickerViewFirstStep.datePickerMode = UIDatePickerMode.Date
                        datePickerViewFirstStep.maximumDate = currentDate
                        txtDOBFirstStep.inputView = datePickerViewFirstStep
                        datePickerViewFirstStep.addTarget(self, action: #selector(OtherInfo.handleDatePicker(_:)), forControlEvents: UIControlEvents.ValueChanged)
                        
                    }
                    cell.contentView.addSubview(txtDOBFirstStep)
                    break;
                case 2:
                    
                    var lblMode : UILabel!
                    lblMode = UILabel(frame: CGRect(x: 10, y: 0, width: (cell.contentView.frame.size.width)-20, height: 20));
                    lblMode.text = "Tax Status"
                    lblMode.font = UIFont.systemFontOfSize(12)
                    lblMode.textColor = UIColor.defaultMenuGray
                    cell.contentView.addSubview(lblMode)
                    
                    txtTaxStatusFirstStep = UITextField(frame: CGRect(x: 10, y: 20, width: (cell.contentView.frame.size.width)-20, height: 35));
                    if (dictOtherInfoAllData[UDTaxStatus] != nil) {
                        enumTaxStatus = TaxStatus.fromHashValue(dictOtherInfoAllData[UDTaxStatus] as! Int)
                    }
                    txtTaxStatusFirstStep.text = TaxStatus.allValues[enumTaxStatus.hashValue]
                    self.saveDictionaryOtherInfo(UDTaxStatus, value: enumTaxStatus.hashValue)
                    
                    txtTaxStatusFirstStep.tag = TAG_TAX_STATUS
                    txtTaxStatusFirstStep.keyboardType = UIKeyboardType.Default
                    self.applyTextFiledStyle1(txtTaxStatusFirstStep)
                    cell.contentView.addSubview(txtTaxStatusFirstStep)
                    txtTaxStatusFirstStep.inputView = pickerView
                    
                    var lblLine : UILabel!
                    lblLine = UILabel(frame: CGRect(x: 10, y: 55-3, width: (cell.contentView.frame.size.width)-20, height: 1));
                    lblLine.backgroundColor = UIColor.lightGrayColor()
                    cell.contentView.addSubview(lblLine)
                    
                    cell.contentView.addSubview(self.getDownArrow())
                    
                    return cell;
                    
                    
                default:
                    break;
                }
                
                var lblLine : UILabel!
                lblLine = UILabel(frame: CGRect(x: 10, y: 55-13, width: (cell.contentView.frame.size.width)-20, height: 1));
                lblLine.backgroundColor = UIColor.lightGrayColor()
                cell.contentView.addSubview(lblLine)
                
            }
            break;
            
        case .BankInfoMode:
            
            if (cell.contentView.subviews.count==0) {
                
                switch indexPath.row {
                case 0:
                    txtAccountNumber = RPFloatingPlaceholderTextField(frame: CGRect(x: 10, y: 10, width: (cell.contentView.frame.size.width)-20, height: 35));
                    txtAccountNumber.placeholder = "Account Number"
                    txtAccountNumber.keyboardType = UIKeyboardType.NumberPad
                    self.applyTextFiledStyle1(txtAccountNumber)
                    txtAccountNumber.inputAccessoryView = toolBar
                    if (dictOtherInfoAllData[UDBankAccNum] != nil) {
                        txtAccountNumber.text = dictOtherInfoAllData[UDBankAccNum]as? String
                    }
                    cell.contentView.addSubview(txtAccountNumber)
                    break;
                case 1:
                    
                    var lblMode : UILabel!
                    lblMode = UILabel(frame: CGRect(x: 10, y: 0, width: (cell.contentView.frame.size.width)-20, height: 20));
                    lblMode.text = "Bank Proof"
                    lblMode.font = UIFont.systemFontOfSize(12)
                    lblMode.textColor = UIColor.defaultMenuGray
                    cell.contentView.addSubview(lblMode)
                    
                    txtBankProof = UITextField(frame: CGRect(x: 10, y: 20, width: (cell.contentView.frame.size.width)-20, height: 35));
                    
                    if (dictOtherInfoAllData[UDBankProofType] != nil) { //ProofType
                        enumBankProof = ProofOfAccount.fromHashValue(dictOtherInfoAllData[UDBankProofType] as! Int)
                    }
                    txtBankProof.text = ProofOfAccount.allValues[enumBankProof.hashValue]
                    self.saveDictionaryOtherInfo(UDBankProofType, value: enumTaxStatus.hashValue)
                    
                    txtBankProof.tag = TAG_BANK_PROOF
                    txtBankProof.keyboardType = UIKeyboardType.Default
                    self.applyTextFiledStyle1(txtBankProof)
                    cell.contentView.addSubview(txtBankProof)
                    txtBankProof.inputView = pickerView
                    
                    
                    var lblLine : UILabel!
                    lblLine = UILabel(frame: CGRect(x: 10, y: 55-3, width: (cell.contentView.frame.size.width)-20, height: 1));
                    lblLine.backgroundColor = UIColor.lightGrayColor()
                    cell.contentView.addSubview(lblLine)
                    
                    cell.contentView.addSubview(self.getDownArrow())
                    
                    return cell;
                    
                case 2:
                    
                    lblUploadPanText = UILabel(frame: CGRect(x: 10, y: 0, width: (cell.contentView.frame.size.width)-20, height: 30));
                    lblUploadPanText.text = "Upload Cancelled Cheque"
                    lblUploadPanText.textColor = UIColor.blackColor()
                    lblUploadPanText.font = UIFont.systemFontOfSize(16)
                    cell.contentView.addSubview(lblUploadPanText)
                    
                    lblImageUploadedRight = UIImageView(frame: CGRect(x: (cell.contentView.frame.size.width)-40, y: 5, width: 20, height: 20));
                    lblImageUploadedRight.image = UIImage(named: "iconCheckPhotoUpload")
                    cell.contentView.addSubview(lblImageUploadedRight)
                    lblImageUploadedRight.hidden = true
                    
                    
                    var lblOption1 : UILabel!
                    lblOption1 = UILabel(frame: CGRect(x: 10, y: lblUploadPanText.frame.size.height , width: 60, height: 15));
                    lblOption1.text = "Option 1 :"
                    lblOption1.textColor = UIColor.blackColor()
                    lblOption1.font = UIFont.systemFontOfSize(11)
                    cell.contentView.addSubview(lblOption1)
                    
                    btnClickPicturePanIcon = UIButton(frame: CGRect(x: 5, y: lblUploadPanText.frame.size.height + lblOption1.frame.size.height + 3, width: 35, height: 30));
                    btnClickPicturePanIcon.backgroundColor = UIColor.clearColor()
                    btnClickPicturePanIcon.setImage(UIImage(named: "iconCamera"), forState: .Normal)
                    cell.contentView.addSubview(btnClickPicturePanIcon)
                    btnClickPicturePanIcon.alpha = 0.6
                    
                    btnClickPicturePan = UIButton(frame: CGRect(x: 40, y: lblUploadPanText.frame.size.height + lblOption1.frame.size.height + 3, width: (cell.contentView.frame.size.width)-55, height: 30));
                    btnClickPicturePan.setTitle(" Click Picture", forState: .Normal)
                    btnClickPicturePan.titleLabel?.font = UIFont.systemFontOfSize(14)
                    btnClickPicturePan.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
                    btnClickPicturePan.titleLabel?.textAlignment = .Left
                    btnClickPicturePan.contentHorizontalAlignment = .Left;
                    cell.contentView.addSubview(btnClickPicturePan)
                    
                    btnClickPicturePanIcon.addTarget(self, action: #selector(OtherInfo.btnCapturePAN(_:)), forControlEvents: .TouchUpInside)
                    btnClickPicturePan.addTarget(self, action: #selector(OtherInfo.btnCapturePAN(_:)), forControlEvents: .TouchUpInside)
                    
                    var lblOption2 : UILabel!
                    lblOption2 = UILabel(frame: CGRect(x: 10, y: lblUploadPanText.frame.size.height + lblOption1.frame.size.height + btnClickPicturePanIcon.frame.size.height + 10 , width: 60, height: 15));
                    lblOption2.text = "Option 2 :"
                    lblOption2.textColor = UIColor.blackColor()
                    lblOption2.font = UIFont.systemFontOfSize(11)
                    cell.contentView.addSubview(lblOption2)
                    
                    btnUploadPicturePanIcon = UIButton(frame: CGRect(x: 5, y: lblUploadPanText.frame.size.height + lblOption1.frame.size.height + btnClickPicturePanIcon.frame.size.height + lblOption2.frame.size.height + 13, width: 35, height: 30));
                    btnUploadPicturePanIcon.backgroundColor = UIColor.clearColor()
                    btnUploadPicturePanIcon.setImage(UIImage(named: "iconGalary"), forState: .Normal)
                    cell.contentView.addSubview(btnUploadPicturePanIcon)
                    btnUploadPicturePanIcon.alpha = 0.6
                    
                    btnUploadPicturePan = UIButton(frame: CGRect(x: 40, y: lblUploadPanText.frame.size.height + lblOption1.frame.size.height + btnClickPicturePanIcon.frame.size.height + lblOption2.frame.size.height + 13, width: (cell.contentView.frame.size.width)-55, height: 30));
                    btnUploadPicturePan.setTitle(" Upload from Gallery", forState: .Normal)
                    btnUploadPicturePan.titleLabel?.font = UIFont.systemFontOfSize(14)
                    btnUploadPicturePan.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
                    btnUploadPicturePan.titleLabel?.textAlignment = .Left
                    btnUploadPicturePan.contentHorizontalAlignment = .Left;
                    cell.contentView.addSubview(btnUploadPicturePan)
                    
                    btnUploadPicturePanIcon.addTarget(self, action: #selector(OtherInfo.btnUploadPAN(_:)), forControlEvents: .TouchUpInside)
                    btnUploadPicturePan.addTarget(self, action: #selector(OtherInfo.btnUploadPAN(_:)), forControlEvents: .TouchUpInside)
                    
                    var lblOption3 : UILabel!
                    lblOption3 = UILabel(frame: CGRect(x: 10, y: lblUploadPanText.frame.size.height + lblOption1.frame.size.height + btnClickPicturePanIcon.frame.size.height + lblOption2.frame.size.height + btnUploadPicturePan.frame.size.height + 18 , width: 60, height: 15));
                    lblOption3.text = "Option 3 :"
                    lblOption3.textColor = UIColor.blackColor()
                    lblOption3.font = UIFont.systemFontOfSize(11)
                    cell.contentView.addSubview(lblOption3)
                    
                    // 30 + 15 + 30 + 15 + 15 + 30 + 26
                    btnCheckBoxPanEmail = UIButton(frame: CGRect(x: 12, y: 30 + 15 + 30 + 15 + 15 + 30 + 26, width: 20, height: 20));
                    cell.contentView.addSubview(btnCheckBoxPanEmail)
                    
                    btnCheckBoxPanEmail.backgroundColor = UIColor.clearColor()
                    btnCheckBoxPanEmail.layer.cornerRadius = 2.0
                    btnCheckBoxPanEmail.layer.borderWidth = 2
                    btnCheckBoxPanEmail.layer.borderColor = UIColor.defaultMenuGray.CGColor
                    
                    var selected = false
                    if (dictOtherInfoAllData[UDBankProofByEmail] != nil) { //ProofType
                        selected = dictOtherInfoAllData[UDBankProofByEmail] as! Bool
                    }
                    btnCheckBoxPanEmail.selected = selected
                    self.saveDictionaryOtherInfo(UDBankProofByEmail, value: selected)
                    
                    //set highlighted image
                    btnCheckBoxPanEmail.setImage(UIImage(named: "iconCheckEmail"), forState: UIControlState.Selected)
                    
                    
                    btnCheckPanEmail = UIButton(frame: CGRect(x: 40, y: 30 + 15 + 30 + 15 + 15 + 30 + 21, width: (cell.contentView.frame.size.width)-55, height: 30));
                    btnCheckPanEmail.setTitle(" I will send Cancelled Cheque copy by e-mail", forState: .Normal)
                    btnCheckPanEmail.titleLabel?.font = UIFont.systemFontOfSize(14)
                    btnCheckPanEmail.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
                    btnCheckPanEmail.titleLabel?.textAlignment = .Left
                    btnCheckPanEmail.contentHorizontalAlignment = .Left;
                    cell.contentView.addSubview(btnCheckPanEmail)
                    
                    btnCheckBoxPanEmail.addTarget(self, action: #selector(OtherInfo.btnEmailCheckboxClicked(_:)), forControlEvents: .TouchUpInside)
                    btnCheckPanEmail.addTarget(self, action: #selector(OtherInfo.btnEmailCheckboxClicked(_:)), forControlEvents: .TouchUpInside)
                    
                    
                    //                    var lblLine : UILabel!
                    //                    lblLine = UILabel(frame: CGRect(x: 10, y: 189, width: (cell.contentView.frame.size.width)-20, height: 1));
                    //                    lblLine.backgroundColor = UIColor.lightGrayColor()
                    //                    lblLine.alpha = 0.4
                    //                    cell.contentView.addSubview(lblLine)
                    
                    return cell;
                    
                    
                case 3:
                    
                    var lblMode : UILabel!
                    lblMode = UILabel(frame: CGRect(x: 10, y: 0, width: (cell.contentView.frame.size.width)-20, height: 20));
                    lblMode.text = "Account Type"
                    lblMode.font = UIFont.systemFontOfSize(12)
                    lblMode.textColor = UIColor.defaultMenuGray
                    cell.contentView.addSubview(lblMode)
                    
                    let txtAccountType = UITextField(frame: CGRect(x: 10, y: 20, width: (cell.contentView.frame.size.width)-20, height: 35));
                    if (dictOtherInfoAllData[UDBankAccType] != nil) { //BankAcType
                        enumAccountType = AccType.fromHashValue(dictOtherInfoAllData[UDBankAccType] as! Int)
                    }
                    txtAccountType.text = AccType.allValues[enumAccountType.hashValue]
                    self.saveDictionaryOtherInfo(UDBankAccType, value: enumAccountType.hashValue)
                    
                    txtAccountType.tag = TAG_ACCOUNT_TYPE
                    txtAccountType.keyboardType = UIKeyboardType.Default
                    self.applyTextFiledStyle1(txtAccountType)
                    cell.contentView.addSubview(txtAccountType)
                    txtAccountType.inputView = pickerView
                    
                    var lblLine : UILabel!
                    lblLine = UILabel(frame: CGRect(x: 10, y: 55-3, width: (cell.contentView.frame.size.width)-20, height: 1));
                    lblLine.backgroundColor = UIColor.lightGrayColor()
                    cell.contentView.addSubview(lblLine)
                    
                    cell.contentView.addSubview(self.getDownArrow())
                    
                    return cell;
                    
                case 4:
                    txtIFSC = RPFloatingPlaceholderTextField(frame: CGRect(x: 10, y: 10, width: (cell.contentView.frame.size.width)-20, height: 35));
                    txtIFSC.placeholder = "IFSC Code"
                    txtIFSC.keyboardType = UIKeyboardType.Default
                    self.applyTextFiledStyle1(txtIFSC)
                    if (dictOtherInfoAllData[UDBankIFSC] != nil) {
                        txtIFSC.text = dictOtherInfoAllData[UDBankIFSC]as? String
                    }
                    cell.contentView.addSubview(txtIFSC)
                    break;
                case 5:
                    txtMaximumSIP = RPFloatingPlaceholderTextField(frame: CGRect(x: 10, y: 10, width: (cell.contentView.frame.size.width)-20, height: 35));
                    txtMaximumSIP.placeholder = "Maximum SIP Account(Optional)"
                    txtMaximumSIP.keyboardType = UIKeyboardType.Default
                    self.applyTextFiledStyle1(txtMaximumSIP)
                    if (dictOtherInfoAllData[UDSIPAmount] != nil) {
                        txtMaximumSIP.text = dictOtherInfoAllData[UDSIPAmount]as? String
                    }
                    cell.contentView.addSubview(txtMaximumSIP)
                    break;
                    
                default:
                    break;
                }
                
                var lblLine : UILabel!
                lblLine = UILabel(frame: CGRect(x: 10, y: 55-13, width: (cell.contentView.frame.size.width)-20, height: 1));
                lblLine.backgroundColor = UIColor.lightGrayColor()
                cell.contentView.addSubview(lblLine)
                
            }
            break;
        case .IdentitykInfoMode:
            
            if (cell.contentView.subviews.count==0) {
                
                switch indexPath.row {
                case 0:
                    
                    var lblMode : UILabel!
                    lblMode = UILabel(frame: CGRect(x: 10, y: 0, width: (cell.contentView.frame.size.width)-20, height: 20));
                    lblMode.text = "Country Of Birth"
                    lblMode.font = UIFont.systemFontOfSize(12)
                    lblMode.textColor = UIColor.defaultMenuGray
                    cell.contentView.addSubview(lblMode)
                    
                    txtCountryOfBirth = UITextField(frame: CGRect(x: 10, y: 20, width: (cell.contentView.frame.size.width)-20, height: 35));
                    txtCountryOfBirth.text = "India"
                    txtCountryOfBirth.keyboardType = UIKeyboardType.Default
                    self.applyTextFiledStyle1(txtCountryOfBirth)
                    if (dictOtherInfoAllData[UDCountryOfBirth] != nil) {
                        txtCountryOfBirth.text = dictOtherInfoAllData[UDCountryOfBirth]as? String
                    }
                    else
                    {
                        self.saveDictionaryOtherInfo(UDCountryOfBirth, value: "India")
                    }
                    cell.contentView.addSubview(txtCountryOfBirth)
                    
                    
                    var lblLine : UILabel!
                    lblLine = UILabel(frame: CGRect(x: 10, y: 55-3, width: (cell.contentView.frame.size.width)-20, height: 1));
                    lblLine.backgroundColor = UIColor.lightGrayColor()
                    cell.contentView.addSubview(lblLine)
                    
                    
                    return cell;
                    
                case 1:
                    txtPlaceOfBirth = RPFloatingPlaceholderTextField(frame: CGRect(x: 10, y: 10, width: (cell.contentView.frame.size.width)-20, height: 35));
                    txtPlaceOfBirth.placeholder = "Place Of Birth"
                    txtPlaceOfBirth.keyboardType = UIKeyboardType.Default
                    self.applyTextFiledStyle1(txtPlaceOfBirth)
                    if (dictOtherInfoAllData[UDPlaceOfBirth] != nil) {
                        txtPlaceOfBirth.text = dictOtherInfoAllData[UDPlaceOfBirth]as? String
                    }
                    cell.contentView.addSubview(txtPlaceOfBirth)
                    break;
                case 2:
                    
                    var lblMode : UILabel!
                    lblMode = UILabel(frame: CGRect(x: 10, y: 0, width: (cell.contentView.frame.size.width)-20, height: 20));
                    lblMode.text = "Source Of Wealth"
                    lblMode.font = UIFont.systemFontOfSize(12)
                    lblMode.textColor = UIColor.defaultMenuGray
                    cell.contentView.addSubview(lblMode)
                    
                    txtSourceOfWealth = UITextField(frame: CGRect(x: 10, y: 20, width: (cell.contentView.frame.size.width)-20, height: 35));
                    if (dictOtherInfoAllData[UDSourceOfWealth] != nil) {
                        enumSourceOfWealth = PrimarySourceOfWealth.fromHashValue(dictOtherInfoAllData[UDSourceOfWealth] as! Int)
                    }
                    self.saveDictionaryOtherInfo(UDSourceOfWealth, value: enumSourceOfWealth.hashValue)
                    
                    txtSourceOfWealth.text = PrimarySourceOfWealth.allValues[enumSourceOfWealth.hashValue]
                    txtSourceOfWealth.tag = TAG_SOURCE_OF_WEALTH
                    txtSourceOfWealth.keyboardType = UIKeyboardType.Default
                    self.applyTextFiledStyle1(txtSourceOfWealth)
                    cell.contentView.addSubview(txtSourceOfWealth)
                    txtSourceOfWealth.inputView = pickerView
                    
                    var lblLine : UILabel!
                    lblLine = UILabel(frame: CGRect(x: 10, y: 55-3, width: (cell.contentView.frame.size.width)-20, height: 1));
                    lblLine.backgroundColor = UIColor.lightGrayColor()
                    cell.contentView.addSubview(lblLine)
                    
                    cell.contentView.addSubview(self.getDownArrow())
                    
                    txtSourceOfWealthOther = RPFloatingPlaceholderTextField(frame: CGRect(x: 10, y: 65, width: (cell.contentView.frame.size.width)-20, height: 35));
                    txtSourceOfWealthOther.placeholder = "Enter other source of wealth"
                    txtSourceOfWealthOther.keyboardType = UIKeyboardType.Default
                    self.applyTextFiledStyle1(txtSourceOfWealthOther)
                    if (dictOtherInfoAllData[UDSourceOfWealthOther] != nil) {
                        txtSourceOfWealthOther.text = dictOtherInfoAllData[UDSourceOfWealthOther]as? String
                    }
                    cell.contentView.addSubview(txtSourceOfWealthOther)
                    
                    txtSourceOfLine = UILabel(frame: CGRect(x: 10, y: 100-3, width: (cell.contentView.frame.size.width)-20, height: 1));
                    txtSourceOfLine.backgroundColor = UIColor.lightGrayColor()
                    cell.contentView.addSubview(txtSourceOfLine)
                    
                    
                    if enumSourceOfWealth.hashValue == PrimarySourceOfWealth.Other.hashValue {
                        txtSourceOfWealthOther.hidden = false
                        txtSourceOfLine.hidden = false
                    }else{
                        txtSourceOfWealthOther.hidden = true
                        txtSourceOfLine.hidden = true
                    }
                    
                    return cell
                    
                case 3:
                    
                    var lblMode : UILabel!
                    lblMode = UILabel(frame: CGRect(x: 10, y: 0, width: (cell.contentView.frame.size.width)-20, height: 20));
                    lblMode.text = "Address Type"
                    lblMode.font = UIFont.systemFontOfSize(12)
                    lblMode.textColor = UIColor.defaultMenuGray
                    cell.contentView.addSubview(lblMode)
                    
                    let txtAddressType = UITextField(frame: CGRect(x: 10, y: 20, width: (cell.contentView.frame.size.width)-20, height: 35));
                    if (dictOtherInfoAllData[UDAddressType] != nil) {
                        enumAddressType = TypeOfAddressGivenAtKra.fromHashValue(dictOtherInfoAllData[UDAddressType] as! Int)
                    }
                    self.saveDictionaryOtherInfo(UDAddressType, value: enumAddressType.hashValue)
                    txtAddressType.text = TypeOfAddressGivenAtKra.allValues[enumAddressType.hashValue]
                    
                    txtAddressType.tag = TAG_ADDRESS_TYPE
                    txtAddressType.keyboardType = UIKeyboardType.Default
                    self.applyTextFiledStyle1(txtAddressType)
                    cell.contentView.addSubview(txtAddressType)
                    txtAddressType.inputView = pickerView
                    
                    var lblLine : UILabel!
                    lblLine = UILabel(frame: CGRect(x: 10, y: 55-3, width: (cell.contentView.frame.size.width)-20, height: 1));
                    lblLine.backgroundColor = UIColor.lightGrayColor()
                    cell.contentView.addSubview(lblLine)
                    
                    cell.contentView.addSubview(self.getDownArrow())
                    
                    return cell;
                    
                case 4:
                    
                    var lblMode : UILabel!
                    lblMode = UILabel(frame: CGRect(x: 10, y: 0, width: (cell.contentView.frame.size.width)-20, height: 20));
                    lblMode.text = "Gross Anual Income"
                    
                    lblMode.font = UIFont.systemFontOfSize(12)
                    lblMode.textColor = UIColor.defaultMenuGray
                    cell.contentView.addSubview(lblMode)
                    
                    let txtGrossAnualIncome = UITextField(frame: CGRect(x: 10, y: 20, width: (cell.contentView.frame.size.width)-20, height: 35));
                    if (dictOtherInfoAllData[UDGrossAnualIncome] != nil) {
                        enumGrossAnualIncome = GrossAnualIncome.fromHashValue(dictOtherInfoAllData[UDGrossAnualIncome] as! Int)
                    }
                    self.saveDictionaryOtherInfo(UDGrossAnualIncome, value: enumGrossAnualIncome.hashValue)
                    txtGrossAnualIncome.text = GrossAnualIncome.allValues[enumGrossAnualIncome.hashValue]
                    
                    txtGrossAnualIncome.tag = TAG_GROSS_ANUAL_INCOME
                    txtGrossAnualIncome.keyboardType = UIKeyboardType.Default
                    self.applyTextFiledStyle1(txtGrossAnualIncome)
                    cell.contentView.addSubview(txtGrossAnualIncome)
                    txtGrossAnualIncome.inputView = pickerView
                    
                    var lblLine : UILabel!
                    lblLine = UILabel(frame: CGRect(x: 10, y: 55-3, width: (cell.contentView.frame.size.width)-20, height: 1));
                    lblLine.backgroundColor = UIColor.lightGrayColor()
                    cell.contentView.addSubview(lblLine)
                    cell.contentView.addSubview(self.getDownArrow())
                    
                    return cell;
                    
                case 5:
                    
                    var lblMode : UILabel!
                    lblMode = UILabel(frame: CGRect(x: 10, y: 0, width: (cell.contentView.frame.size.width)-20, height: 20));
                    lblMode.text = "Occupation"
                    lblMode.font = UIFont.systemFontOfSize(12)
                    lblMode.textColor = UIColor.defaultMenuGray
                    cell.contentView.addSubview(lblMode)
                    
                    let txtOccupation = UITextField(frame: CGRect(x: 10, y: 20, width: (cell.contentView.frame.size.width)-20, height: 35));
                    if (dictOtherInfoAllData[UDOccupation] != nil) {
                        enumOccupation = Occupation.fromHashValue(dictOtherInfoAllData[UDOccupation] as! Int)
                    }
                    self.saveDictionaryOtherInfo(UDOccupation, value: enumOccupation.hashValue)
                    txtOccupation.text = Occupation.allValues[enumOccupation.hashValue]
                    txtOccupation.tag = TAG_OCCUPATION
                    txtOccupation.keyboardType = UIKeyboardType.Default
                    self.applyTextFiledStyle1(txtOccupation)
                    cell.contentView.addSubview(txtOccupation)
                    txtOccupation.inputView = pickerView
                    
                    var lblLine : UILabel!
                    lblLine = UILabel(frame: CGRect(x: 10, y: 55-3, width: (cell.contentView.frame.size.width)-20, height: 1));
                    lblLine.backgroundColor = UIColor.lightGrayColor()
                    cell.contentView.addSubview(lblLine)
                    cell.contentView.addSubview(self.getDownArrow())
                    
                    txtOccupationOther = RPFloatingPlaceholderTextField(frame: CGRect(x: 10, y: 65, width: (cell.contentView.frame.size.width)-20, height: 35));
                    txtOccupationOther.placeholder = "Enter Occupation Other"
                    txtOccupationOther.keyboardType = UIKeyboardType.Default
                    self.applyTextFiledStyle1(txtOccupationOther)
                    if (dictOtherInfoAllData[UDOccupationOther] != nil) {
                        txtOccupationOther.text = dictOtherInfoAllData[UDOccupationOther]as? String
                    }
                    cell.contentView.addSubview(txtOccupationOther)
                    
                    txtOccupationLine = UILabel(frame: CGRect(x: 10, y: 100-3, width: (cell.contentView.frame.size.width)-20, height: 1));
                    txtOccupationLine.backgroundColor = UIColor.lightGrayColor()
                    cell.contentView.addSubview(txtOccupationLine)
                    
                    if enumOccupation.hashValue == Occupation.Other.hashValue {
                        txtOccupationOther.hidden = false
                        txtOccupationLine.hidden = false
                    }else{
                        txtOccupationOther.hidden = true
                        txtOccupationLine.hidden = true
                    }
                    
                    return cell;
                    
                case 6:
                    
                    var lblMode : UILabel!
                    lblMode = UILabel(frame: CGRect(x: 10, y: 0, width: (cell.contentView.frame.size.width)-20, height: 20));
                    lblMode.text = "Politically exposed person"
                    lblMode.font = UIFont.systemFontOfSize(12)
                    lblMode.textColor = UIColor.defaultMenuGray
                    cell.contentView.addSubview(lblMode)
                    
                    let txtPoliticallyExposedPerson = UITextField(frame: CGRect(x: 10, y: 20, width: (cell.contentView.frame.size.width)-20, height: 35));
                    txtPoliticallyExposedPerson.text = "Not Applicable"
                    if (dictOtherInfoAllData[UDPoliticallyExposedPerson] != nil) {
                        enumPoliticallyExposedPerson = PoliticallyExposedPerson.fromHashValue(dictOtherInfoAllData[UDPoliticallyExposedPerson] as! Int)
                    }
                    self.saveDictionaryOtherInfo(UDPoliticallyExposedPerson, value: enumPoliticallyExposedPerson.hashValue)
                    txtPoliticallyExposedPerson.text = PoliticallyExposedPerson.allValues[enumPoliticallyExposedPerson.hashValue]
                    txtPoliticallyExposedPerson.tag = TAG_POLITICAL
                    
                    txtPoliticallyExposedPerson.keyboardType = UIKeyboardType.Default
                    self.applyTextFiledStyle1(txtPoliticallyExposedPerson)
                    cell.contentView.addSubview(txtPoliticallyExposedPerson)
                    txtPoliticallyExposedPerson.inputView = pickerView
                    
                    var lblLine : UILabel!
                    lblLine = UILabel(frame: CGRect(x: 10, y: 55-3, width: (cell.contentView.frame.size.width)-20, height: 1));
                    lblLine.backgroundColor = UIColor.lightGrayColor()
                    cell.contentView.addSubview(lblLine)
                    
                    cell.contentView.addSubview(self.getDownArrow())
                    
                    return cell;
                    
                case 7:
                    
                    var lblMode : UILabel!
                    lblMode = UILabel(frame: CGRect(x: 10, y: 0, width: (cell.contentView.frame.size.width)-20, height: 20));
                    lblMode.text = "Tax residency-other than india?"
                    lblMode.font = UIFont.systemFontOfSize(12)
                    lblMode.textColor = UIColor.defaultMenuGray
                    cell.contentView.addSubview(lblMode)
                    
                    txtTaxResidency = UITextField(frame: CGRect(x: 10, y: 20, width: (cell.contentView.frame.size.width)-20, height: 35));
                    if (dictOtherInfoAllData[UDTaxResidency] != nil) {
                        enumTexResidency = YesNo.fromHashValue(dictOtherInfoAllData[UDTaxResidency] as! Int)
                    }
                    self.saveDictionaryOtherInfo(UDTaxResidency, value: enumTexResidency.hashValue)
                    txtTaxResidency.text = YesNo.allValues[enumTexResidency.hashValue]
                    txtTaxResidency.tag = TAG_TAX_RESIDENCY
                    
                    txtTaxResidency.keyboardType = UIKeyboardType.Default
                    self.applyTextFiledStyle1(txtTaxResidency)
                    cell.contentView.addSubview(txtTaxResidency)
                    txtTaxResidency.inputView = pickerView
                    
                    var lblLine : UILabel!
                    lblLine = UILabel(frame: CGRect(x: 10, y: 55-3, width: (cell.contentView.frame.size.width)-20, height: 1));
                    lblLine.backgroundColor = UIColor.lightGrayColor()
                    cell.contentView.addSubview(lblLine)
                    
                    cell.contentView.addSubview(self.getDownArrow())
                    
                    return cell;
                    
                default:
                    break;
                }
                
                var lblLine : UILabel!
                lblLine = UILabel(frame: CGRect(x: 10, y: 55-13, width: (cell.contentView.frame.size.width)-20, height: 1));
                lblLine.backgroundColor = UIColor.lightGrayColor()
                cell.contentView.addSubview(lblLine)
                
            }
            break;
        case .NominyInfoMode:
            
            if (cell.contentView.subviews.count==0) {
                
                switch indexPath.row {
                case 0:
                    
                    var lblMode : UILabel!
                    lblMode = UILabel(frame: CGRect(x: 10, y: 0, width: (cell.contentView.frame.size.width)-20, height: 20));
                    lblMode.text = "Do you want to Nominate?"
                    lblMode.font = UIFont.systemFontOfSize(12)
                    lblMode.textColor = UIColor.defaultMenuGray
                    cell.contentView.addSubview(lblMode)
                    
                    txtNominee = UITextField(frame: CGRect(x: 10, y: 20, width: (cell.contentView.frame.size.width)-20, height: 35));
                    txtNominee.keyboardType = UIKeyboardType.Default
                    self.applyTextFiledStyle1(txtNominee)
                    if (dictOtherInfoAllData[UDNominee] != nil) {
                        enumNominee = YesNo.fromHashValue(dictOtherInfoAllData[UDNominee] as! Int)
                    }
                    self.saveDictionaryOtherInfo(UDNominee, value: enumNominee.hashValue)
                    txtNominee.text = YesNo.allValues[enumNominee.hashValue]
                    cell.contentView.addSubview(txtNominee)
                    txtNominee.tag = TAG_NOMINEE
                    txtNominee.inputView = pickerView
                    
                    
                    var lblLine : UILabel!
                    lblLine = UILabel(frame: CGRect(x: 10, y: 55-3, width: (cell.contentView.frame.size.width)-20, height: 1));
                    lblLine.backgroundColor = UIColor.lightGrayColor()
                    cell.contentView.addSubview(lblLine)
                    
                    cell.contentView.addSubview(self.getDownArrow())
                    
                    return cell;
                    
                case 1:
                    txtNomineeName = RPFloatingPlaceholderTextField(frame: CGRect(x: 10, y: 10, width: (cell.contentView.frame.size.width)-20, height: 35));
                    txtNomineeName.placeholder = "Nominee Name"
                    txtNomineeName.keyboardType = UIKeyboardType.Default
                    txtNomineeName.inputAccessoryView = toolBar
                    self.applyTextFiledStyle1(txtNomineeName)
                    if (dictOtherInfoAllData[UDNomineeName] != nil) {
                        txtNomineeName.text = dictOtherInfoAllData[UDNomineeName]as? String
                    }
                    cell.contentView.addSubview(txtNomineeName)
                    break;
                    
                case 2:
                    txtDOB = RPFloatingPlaceholderTextField(frame: CGRect(x: 10, y: 10, width: (cell.contentView.frame.size.width)-20, height: 35));
                    txtDOB.placeholder = "DOB(DD-MMM-YYYY)"
                    txtDOB.keyboardType = UIKeyboardType.Default
                    self.applyTextFiledStyle1(txtDOB)
                    txtDOB.inputAccessoryView = toolBar
                    self.applyTextFiledStyle1(txtDOB)
                    if (dictOtherInfoAllData[UDNomineeDOB] != nil) {
                        txtDOB.text = dictOtherInfoAllData[UDNomineeDOB]as? String
                    }
                    cell.contentView.addSubview(txtDOB)
                    
                    let currentDate: NSDate = NSDate()
                    datePickerViewDOB.datePickerMode = UIDatePickerMode.Date
                    datePickerViewDOB.maximumDate = currentDate
                    txtDOB.inputView = datePickerViewDOB
                    datePickerViewDOB.addTarget(self, action: #selector(OtherInfo.handleDatePickerDOB(_:)), forControlEvents: UIControlEvents.ValueChanged)
                    
                    break;
                case 3:
                    
                    var lblMode : UILabel!
                    lblMode = UILabel(frame: CGRect(x: 10, y: 0, width: (cell.contentView.frame.size.width)-20, height: 20));
                    lblMode.text = "Relationship"
                    lblMode.font = UIFont.systemFontOfSize(12)
                    lblMode.textColor = UIColor.defaultMenuGray
                    cell.contentView.addSubview(lblMode)
                    
                    txtRelationShip = UITextField(frame: CGRect(x: 10, y: 20, width: (cell.contentView.frame.size.width)-20, height: 35));
                    if (dictOtherInfoAllData[UDNomineeRelationship] != nil) {
                        enumNomineeRelationship = NomineeRelationship.fromHashValue(dictOtherInfoAllData[UDNomineeRelationship] as! Int)
                    }
                    self.saveDictionaryOtherInfo(UDNomineeRelationship, value: enumNomineeRelationship.hashValue)
                    txtRelationShip.text = NomineeRelationship.allValues[enumNomineeRelationship.hashValue]
                    txtRelationShip.tag = TAG_NOMINEE_RELATIONSHIP
                    txtRelationShip.keyboardType = UIKeyboardType.Default
                    self.applyTextFiledStyle1(txtRelationShip)
                    cell.contentView.addSubview(txtRelationShip)
                    txtRelationShip.inputView = pickerView
                    
                    var lblLine : UILabel!
                    lblLine = UILabel(frame: CGRect(x: 10, y: 55-3, width: (cell.contentView.frame.size.width)-20, height: 1));
                    lblLine.backgroundColor = UIColor.lightGrayColor()
                    cell.contentView.addSubview(lblLine)
                    cell.contentView.addSubview(self.getDownArrow())
                    
                    
                    txtRelationShipOther = RPFloatingPlaceholderTextField(frame: CGRect(x: 10, y: 65, width: (cell.contentView.frame.size.width)-20, height: 35));
                    txtRelationShipOther.placeholder = "Please enter relationship with nominee"
                    txtRelationShipOther.keyboardType = UIKeyboardType.Default
                    txtRelationShipOther.inputAccessoryView = toolBar
                    self.applyTextFiledStyle1(txtRelationShipOther)
                    if (dictOtherInfoAllData[UDNomineeRelationshipOther] != nil) {
                        txtRelationShipOther.text = dictOtherInfoAllData[UDNomineeRelationshipOther]as? String
                    }
                    cell.contentView.addSubview(txtRelationShipOther)
                    
                    txtRelationShipLine = UILabel(frame: CGRect(x: 10, y: 100-3, width: (cell.contentView.frame.size.width)-20, height: 1));
                    txtRelationShipLine.backgroundColor = UIColor.lightGrayColor()
                    cell.contentView.addSubview(txtRelationShipLine)
                    
                    if enumNomineeRelationship.hashValue == NomineeRelationship.Other.hashValue {
                        txtRelationShipOther.hidden = false
                        txtRelationShipLine.hidden = false
                    }else{
                        txtRelationShipOther.hidden = true
                        txtRelationShipLine.hidden = true
                    }
                    
                    return cell;
                    
                default:
                    break;
                }
                var lblLine : UILabel!
                lblLine = UILabel(frame: CGRect(x: 10, y: 55-13, width: (cell.contentView.frame.size.width)-20, height: 1));
                lblLine.backgroundColor = UIColor.lightGrayColor()
                cell.contentView.addSubview(lblLine)
            }
            break;
            
        default:
            break;
        }
        
        checkValidateStepsGreen()
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.contentView.backgroundColor = UIColor.clearColor()
        cell.backgroundColor = UIColor.clearColor()
        
        return cell;
        
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        switch currentMode {
        case .PersonalInfoMode:
            if indexPath.row==0 || indexPath.row==2 || indexPath.row==6 {
                return 65
            }
            break;
        case .BankInfoMode:
            if indexPath.row==0 || indexPath.row==3{
                return 65
            }
            if indexPath.row==2{
                return 190
            }
            
            break;
        case .IdentitykInfoMode:
            
            if indexPath.row==5 {
                if enumOccupation.hashValue == 12 {
                    return 105
                }else{
                    return 65
                }
            }
            
            if indexPath.row==2 {
                if enumSourceOfWealth.hashValue == 7 {
                    return 105
                }else{
                    return 65
                }
            }
            
            if indexPath.row==0 || indexPath.row==3 || indexPath.row==4 || indexPath.row==6 || indexPath.row==7{
                return 65
            }
            
            break;
        case .NominyInfoMode:
            if indexPath.row==0 || indexPath.row==1 || indexPath.row==2{
                return 65
            }
            if indexPath.row == 3 {
                if enumNomineeRelationship.hashValue == 4{
                    return 105
                }
                else{
                    return 65
                }
            }
            break;
        case .SignatureInfoMode:
            break;
            
        }
        
        return 55
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    //    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    //
    //        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 40))
    //        view.backgroundColor = UIColor.whiteColor()
    //
    //        let buttonSubmit = UIButton(frame: CGRect(x: view.frame.size.width-80, y: 5, width: 70, height: 30))
    //        buttonSubmit.setTitle("NEXT", forState: .Normal)
    //        buttonSubmit.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    //        buttonSubmit.backgroundColor = UIColor.defaultOrangeButton
    //        buttonSubmit.titleLabel?.font = UIFont.systemFontOfSize(14)
    //        buttonSubmit.layer.cornerRadius = 1.5
    //        buttonSubmit.addTarget(self, action: #selector(OtherInfo.btnNextClicked(_:)), forControlEvents: .TouchUpInside)
    //        view.addSubview(buttonSubmit)
    //
    //        let buttonCancel = UIButton(frame: CGRect(x: view.frame.size.width-(80*2), y: 5, width: 70, height: 30))
    //        buttonCancel.setTitle("SKIP", forState: .Normal)
    //        buttonCancel.setTitleColor(UIColor.defaultOrangeButton, forState: .Normal)
    //        buttonCancel.backgroundColor = UIColor.whiteColor()
    //        buttonCancel.titleLabel?.font = UIFont.systemFontOfSize(14)
    //        buttonCancel.layer.cornerRadius = 1.5
    //        buttonCancel.layer.borderColor = UIColor.defaultOrangeButton.CGColor
    //        buttonCancel.layer.borderWidth = 1.0
    //        buttonCancel.addTarget(self, action: #selector(OtherInfo.btnSkipClicked(_:)), forControlEvents: .TouchUpInside)
    //        view.addSubview(buttonCancel)
    //
    //        return view
    //    }
    
    
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
        if currentMode == InfoMode.BankInfoMode {
            if textField == txtAccountNumber {
                self.saveDictionaryOtherInfo(UDBankAccNum, value: txtAccountNumber.text!)
            }
            else if textField == txtIFSC {
                self.saveDictionaryOtherInfo(UDBankIFSC, value: txtIFSC.text!)
            }
            else if textField == txtMaximumSIP{
                self.saveDictionaryOtherInfo(UDSIPAmount, value: txtMaximumSIP.text!)
            }
        }
        else if currentMode == InfoMode.IdentitykInfoMode{
            if textField == txtCountryOfBirth {
                dictOtherInfoAllData.setValue(txtCountryOfBirth.text!, forKey: UDCountryOfBirth)
            }
            else if textField == txtPlaceOfBirth {
                dictOtherInfoAllData.setValue(txtPlaceOfBirth.text!, forKey: UDPlaceOfBirth)
            }
            else if textField == txtSourceOfWealthOther{
                dictOtherInfoAllData.setValue(txtSourceOfWealthOther.text!, forKey: UDSourceOfWealthOther)
            }
            else if textField == txtOccupationOther{
                dictOtherInfoAllData.setValue(txtOccupationOther.text!, forKey: UDOccupationOther)
            }
            
        }
        else if currentMode == InfoMode.NominyInfoMode{
            if enumNominee.hashValue == 1 && txtNomineeName != nil {
                if txtNomineeName != nil {
                    if textField == txtNomineeName{
                        dictOtherInfoAllData.setValue(txtNomineeName.text!, forKey: UDNomineeName)
                    }
                    else if textField == txtRelationShipOther{
                        dictOtherInfoAllData.setValue(txtRelationShipOther.text!, forKey: UDNomineeRelationshipOther)
                    }
                }
            }
        }
        return true;
    }
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        print("While entering the characters this method gets called")
        if currentMode == InfoMode.BankInfoMode {
            if textField == txtMaximumSIP {
                let currentString: NSString = textField.text!
                let newString: NSString = currentString.stringByReplacingCharactersInRange(range, withString: string)
                return newString.length <= 8
            }
        }
        return true;
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        print("TextField should return method called")
        
        
        // STEP 1 START....
        if textField==txtDOBFirstStep {
            txtTaxStatusFirstStep.becomeFirstResponder()
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
    
    
    @IBAction func btnNextClicked(sender: AnyObject) {
        
        switch currentMode {
        case .PersonalInfoMode :
            
            if self.validateStepPersonalInfo(true) {
                currentMode = .BankInfoMode
                lblTitle.text = "BANK INFO"
            }else{
                lblTitle.text = "PERSONAL INFO"
            }
            
            break;
        case .BankInfoMode :
            
            if self.validateStepBankDetail(true) {
                currentMode = .IdentitykInfoMode
                lblTitle.text = "IDENTITY INFO"
            }else{
                lblTitle.text = "BANK INFO"
            }
            
            break;
        case .IdentitykInfoMode :
            
            if self.validateStepIdentityInfo(true) {
                currentMode = .NominyInfoMode
                lblTitle.text = "NOMINEE INFO"
            }else{
                lblTitle.text = "IDENTITY INFO"
            }
            
            break;
        case .NominyInfoMode :
            
            if self.validateStepNominee(true) {
                currentMode = .NominyInfoMode
                lblTitle.text = "NOMINEE INFO"
                
                self.setAllDetails()
            }else{
                
                lblTitle.text = "NOMINEE INFO"
                
            }
            // Open Signrature.......
            break;
            
        default:
            break
        }
        print("Current Mode Is  ... \(currentMode)")
        
        tblView.reloadData()
    }
    
    @IBAction func btnSkipClicked(sender: AnyObject) {
        print("Skip Clicked...")
        switch currentMode {
        case .PersonalInfoMode:
            
            currentMode = .BankInfoMode
            lblTitle.text = "BANK INFO"
            
            break
            
        case .BankInfoMode:
            
            currentMode = .IdentitykInfoMode
            lblTitle.text = "IDENTITY INFO"
            break
            
        case .IdentitykInfoMode:
                        currentMode = .NominyInfoMode
            lblTitle.text = "NOMINEE INFO"
            btn4.backgroundColor = UIColor.defaultAppColorBlue
            lbl4.textColor = UIColor.defaultAppColorBlue
            lblLine4.backgroundColor = UIColor.defaultAppColorBlue
            
            break
        default:
            break
        }
        tblView.reloadData()
    }
    
    
    
    @IBAction func btnPersonalInfoClicked(sender: AnyObject) {
        self.view.endEditing(true)
        
        currentMode = .PersonalInfoMode
        lblTitle.text = "PERSONAL INFO"
        
        tblView.reloadData()
        
    }
    
    @IBAction func btnBankInfoClicked(sender: AnyObject) {
        self.view.endEditing(true)
        
        currentMode = .BankInfoMode
        lblTitle.text = "BANK INFO"
        
        tblView.reloadData()
        
    }
    
    @IBAction func btnIdentityInfoClicked(sender: AnyObject) {
        self.view.endEditing(true)
        
        currentMode = .IdentitykInfoMode
        lblTitle.text = "IDENTITY INFO"
        
        tblView.reloadData()
        
    }
    
    @IBAction func btnNomineeInfoClicked(sender: AnyObject) {
        self.view.endEditing(true)
        
        currentMode = .NominyInfoMode
        lblTitle.text = "NOMINEE INFO"
        
        tblView.reloadData()
    }
    
    func checkValidateStepsGreen() {
        
        if currentMode != .PersonalInfoMode {
            if validateStepPersonalInfo() {
                btn1.backgroundColor = UIColor.defaultGreenColor
                lbl1.textColor = UIColor.defaultGreenColor
                lblLine1.backgroundColor = UIColor.defaultGreenColor
            }
            else {
                btn1.backgroundColor = UIColor.defaultMenuGray
                lbl1.textColor = UIColor.defaultMenuGray
                lblLine1.backgroundColor = UIColor.defaultMenuGray
            }
        }
        else
        {
            btn1.backgroundColor = UIColor.defaultAppColorBlue
            lbl1.textColor = UIColor.defaultAppColorBlue
            lblLine1.backgroundColor = UIColor.defaultAppColorBlue
        }
        
        if currentMode != .BankInfoMode {
            if validateStepBankDetail() {
                btn2.backgroundColor = UIColor.defaultGreenColor
                lbl2.textColor = UIColor.defaultGreenColor
                lblLine2.backgroundColor = UIColor.defaultGreenColor
            }
            else
            {
                btn2.backgroundColor = UIColor.defaultMenuGray
                lbl2.textColor = UIColor.defaultMenuGray
                lblLine2.backgroundColor = UIColor.defaultMenuGray
            }
        }
        else {
            btn2.backgroundColor = UIColor.defaultAppColorBlue
            lbl2.textColor = UIColor.defaultAppColorBlue
            lblLine2.backgroundColor = UIColor.defaultAppColorBlue
        }
        
        
        if currentMode != .IdentitykInfoMode {
            if validateStepIdentityInfo() {
                btn3.backgroundColor = UIColor.defaultGreenColor
                lbl3.textColor = UIColor.defaultGreenColor
                lblLine3.backgroundColor = UIColor.defaultGreenColor
            }
            else
            {
                btn3.backgroundColor = UIColor.defaultMenuGray
                lbl3.textColor = UIColor.defaultMenuGray
                lblLine3.backgroundColor = UIColor.defaultMenuGray
            }
        }else {
            btn3.backgroundColor = UIColor.defaultAppColorBlue
            lbl3.textColor = UIColor.defaultAppColorBlue
            lblLine3.backgroundColor = UIColor.defaultAppColorBlue
        }
        
        if currentMode != .NominyInfoMode {
            if validateStepNominee() {
                btn4.backgroundColor = UIColor.defaultGreenColor
                lbl4.textColor = UIColor.defaultGreenColor
                lblLine4.backgroundColor = UIColor.defaultGreenColor
            }
            else
            {
                btn4.backgroundColor = UIColor.defaultMenuGray
                lbl4.textColor = UIColor.defaultMenuGray
                lblLine4.backgroundColor = UIColor.defaultMenuGray
            }
        }
        else
        {
            btn4.backgroundColor = UIColor.defaultAppColorBlue
            lbl4.textColor = UIColor.defaultAppColorBlue
            lblLine4.backgroundColor = UIColor.defaultAppColorBlue
        }
    }
    
    @IBAction func btnSignatureClicked(sender: AnyObject) {
        self.view.endEditing(true)
        
        self.setAllDetails()
        
        //        dispatch_async(dispatch_get_main_queue(), { () -> Void in
        //            let objSignature = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdSignatureScreen)
        //            self.navigationController?.pushViewController(objSignature!, animated: true)
        //        })
        
        
    }
    
    func validateStepPersonalInfo(showError: Bool = false) -> Bool {
        
        if (dictOtherInfoAllData[UDDOB]) == nil {
            if (showError)
            {
                SharedManager.invokeAlertMethod(APP_NAME, strBody: "Please enter DOB", delegate: nil)
            }
            return false
        }
        
        return true
    }
    
    func validateStepBankDetail(showError: Bool = false) -> Bool {
        
        if (currentMode == .BankInfoMode)
        {
            if txtAccountNumber.text != ""
            {
                self.saveDictionaryOtherInfo(UDBankAccNum, value: txtAccountNumber.text!)
            }
            else
            {
                dictOtherInfoAllData.removeObjectForKey(UDBankAccNum)
            }
            
            if txtIFSC.text != ""
            {
                self.saveDictionaryOtherInfo(UDBankIFSC, value: txtIFSC.text!)
            }
            else
            {
                dictOtherInfoAllData.removeObjectForKey(UDBankIFSC)
            }
            
            if txtMaximumSIP.text != ""
            {
                self.saveDictionaryOtherInfo(UDSIPAmount, value: txtMaximumSIP.text!)
            }
            else
            {
                dictOtherInfoAllData.removeObjectForKey(UDSIPAmount)
            }
        }
        
        if (dictOtherInfoAllData[UDBankAccNum]) == nil || (dictOtherInfoAllData[UDBankAccNum]) as! String == "" {
            if (showError)
            {
                SharedManager.invokeAlertMethod(APP_NAME, strBody: "Please enter Account Number", delegate: nil)
            }
            return false
        }
        
        
        if (dictOtherInfoAllData[UDBankIFSC]) == nil || (dictOtherInfoAllData[UDBankIFSC]) as! String == "" {
            if (showError)
            {
                SharedManager.invokeAlertMethod(APP_NAME, strBody: "Please enter IFSC Code", delegate: nil)
            }
            return false
        }
        
        var selected = false
        if (dictOtherInfoAllData[UDBankProofByEmail] != nil) { //ProofType
            selected = dictOtherInfoAllData[UDBankProofByEmail] as! Bool
            if (!selected)
            {
                if (dictOtherInfoAllData[UDBankProofData] == nil) {
                    if (showError)
                    {
                        SharedManager.invokeAlertMethod(APP_NAME, strBody: "Please take a picture of Bank Proof", delegate: nil)
                    }
                    return false
                }
            }
        }
        
        return true
    }
    
    func validateStepIdentityInfo(showError: Bool = false) -> Bool {
        
        if (currentMode == .IdentitykInfoMode)
        {
            if txtPlaceOfBirth.text != ""
            {
                self.saveDictionaryOtherInfo(UDPlaceOfBirth, value: txtPlaceOfBirth.text!)
            }
            else
            {
                dictOtherInfoAllData.removeObjectForKey(UDPlaceOfBirth)
            }
            
            if txtCountryOfBirth.text != ""
            {
                self.saveDictionaryOtherInfo(UDCountryOfBirth, value: txtCountryOfBirth.text!)
            }
            else
            {
                dictOtherInfoAllData.removeObjectForKey(UDCountryOfBirth)
            }
        }
        
        if (dictOtherInfoAllData[UDPlaceOfBirth]) == nil || (dictOtherInfoAllData[UDPlaceOfBirth]) as! String == "" {
            if (showError)
            {
                SharedManager.invokeAlertMethod(APP_NAME, strBody: "Please enter Place Of Birth", delegate: nil)
            }
            return false
        }
        
        if (dictOtherInfoAllData[UDCountryOfBirth]) == nil || (dictOtherInfoAllData[UDCountryOfBirth]) as! String == "" {
            if (showError)
            {
                SharedManager.invokeAlertMethod(APP_NAME, strBody: "Please enter Country Of Birth", delegate: nil)
            }
            return false
        }
        
        if PrimarySourceOfWealth.fromHashValue(dictOtherInfoAllData[UDSourceOfWealth] as! Int) == PrimarySourceOfWealth.Other
        {
            if (dictOtherInfoAllData[UDSourceOfWealthOther]) == nil {
                if (showError)
                {
                    SharedManager.invokeAlertMethod(APP_NAME, strBody: "Please mention Source of Wealth", delegate: nil)
                }
                return false
            }
        }
        
        if Occupation.fromHashValue(dictOtherInfoAllData[UDOccupation] as! Int) == Occupation.Other
        {
            if (dictOtherInfoAllData[UDOccupationOther]) == nil {
                if (showError)
                {
                    SharedManager.invokeAlertMethod(APP_NAME, strBody: "Please mention Occupation", delegate: nil)
                }
                return false
            }
        }
        
        return true
    }
    
    func validateStepNominee(showError: Bool = false) -> Bool {
        
        if(dictOtherInfoAllData[UDNominee]) != nil {
            if YesNo.fromHashValue(dictOtherInfoAllData[UDNominee] as! Int) == YesNo.Yes {
                if (currentMode == .NominyInfoMode)
                {
                    if txtNomineeName.text != ""
                    {
                        self.saveDictionaryOtherInfo(UDNomineeName, value: txtNomineeName.text!)
                    }
                    else
                    {
                        dictOtherInfoAllData.removeObjectForKey(UDNomineeName)
                    }
                    
                    if (dictOtherInfoAllData[UDNomineeRelationship] as! Int) == NomineeRelationship.Other.hashValue {
                        if txtRelationShipOther.text != ""
                        {
                            self.saveDictionaryOtherInfo(UDNomineeRelationshipOther, value: txtRelationShipOther.text!)
                        }
                        else
                        {
                            dictOtherInfoAllData.removeObjectForKey(UDNomineeRelationshipOther)
                        }
                    }
                }
                
                if (dictOtherInfoAllData[UDNomineeName]) == nil || (dictOtherInfoAllData[UDNomineeName]) as! String == "" {
                    if (showError)
                    {
                        SharedManager.invokeAlertMethod(APP_NAME, strBody: "Please enter Nominee Name", delegate: nil)
                    }
                    return false
                }
                
                if (dictOtherInfoAllData[UDNomineeDOB]) == nil || (dictOtherInfoAllData[UDNomineeDOB]) as! String == "" {
                    if (showError)
                    {
                        SharedManager.invokeAlertMethod(APP_NAME, strBody: "Please enter Nominee DOB", delegate: nil)
                    }
                    return false
                }
                
                if (dictOtherInfoAllData[UDNomineeRelationship] as! Int) == NomineeRelationship.Other.hashValue {
                    if (dictOtherInfoAllData[UDNomineeRelationshipOther]) == nil || (dictOtherInfoAllData[UDNomineeRelationshipOther]) as! String == "" {
                        if (showError)
                        {
                            SharedManager.invokeAlertMethod(APP_NAME, strBody: "Please enter relationship with nominee", delegate: nil)
                        }
                        return false
                    }
                }
                
            }
        }
        else
        {
            return false
        }
        
        return true
    }
    
    
    @IBAction func btnCapturePAN(sender: AnyObject) {
        
        if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil {
            
            imageClickedIndex = 1
            
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerControllerSourceType.Camera
            picker.cameraCaptureMode = .Photo
            presentViewController(picker, animated: true, completion: nil)
        } else {
            noCamera()
        }
    }
    
    @IBAction func btnEmailCheckboxClicked(sender: AnyObject) {
        
        if btnCheckBoxPanEmail.selected {
            
            btnCheckBoxPanEmail.selected = false
            btnCheckBoxPanEmail.layer.cornerRadius = 2.0
            btnCheckBoxPanEmail.layer.borderWidth = 2
            btnCheckBoxPanEmail.layer.borderColor = UIColor.defaultMenuGray.CGColor
            lblImageUploadedRight.hidden = true
        }else{
            lblImageUploadedRight.hidden = false
            btnCheckBoxPanEmail.selected = true
            btnCheckBoxPanEmail.layer.cornerRadius = 2.0
            btnCheckBoxPanEmail.layer.borderWidth = 0
            dictOtherInfoAllData.removeObjectForKey(UDBankProofData)
        }
        self.saveDictionaryOtherInfo(UDBankProofByEmail, value: btnCheckBoxPanEmail.selected)
        
    }
    
    
    @IBAction func btnUploadPAN(sender: AnyObject) {
        
        imageClickedIndex = 2
        picker.allowsEditing = false //2
        picker.sourceType = .PhotoLibrary //3
        presentViewController(picker, animated: true, completion: nil)//4
    }
    
    @IBAction func btnNavHelpClicked(sender: AnyObject) {
        let objWebView = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdWebViewController) as! WebViewController
        
        objWebView.urlLink = NSURL(string:URL_INVESTMENT_HELP)!
        objWebView.screenTitle = "Help"
        self.navigationController?.pushViewController(objWebView, animated: true)
    }
    //MARK: Delegates
    func imagePickerController(
        picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        
        let chosenImage = SharedManager.sharedInstance.resizeImage(selectedImage)
        
        if imageClickedIndex==1 {
            imagePicked = chosenImage
            lblImageUploadedRight.hidden = false
        }
        if imageClickedIndex==2 {
            imagePicked = chosenImage
            lblImageUploadedRight.hidden = false
        }
        
        if(imagePicked != nil)
        {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                let imageData:NSData = UIImagePNGRepresentation(self.imagePicked)!
                let strBase64:String = imageData.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
                let bank64 = "data:image/jpeg;base64,\(strBase64)"
                
                self.saveDictionaryOtherInfo(UDBankProofData, value: bank64)
                
            })
            btnCheckBoxPanEmail.selected = false
        }
        
        
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func noCamera(){
        let alertVC = UIAlertController(
            title: "No Camera",
            message: "Sorry, this device has no camera",
            preferredStyle: .Alert)
        let okAction = UIAlertAction(
            title: "OK",
            style:.Default,
            handler: nil)
        alertVC.addAction(okAction)
        presentViewController(alertVC,
                              animated: true,
                              completion: nil)
    }
}

