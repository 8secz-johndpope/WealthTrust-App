//
//  SharedManager.swift
//  MVCSwift
//
//  Created by Hemen Gohil on 5/6/16.
//  Copyright © 2016 Hemen Gohil. All rights reserved.
//

import UIKit
import SystemConfiguration
import StoreKit


// MARK:
// TODO:
// FIXME:

// MARK: - CONSTANTS..
// DEFAULT CONSTANTS.... DECLARED HERE....

let device = Device();
let IS_IPHONE = device.isPhone
let IS_IPAD = device.isPad
let IS_SIMULATOR = device.isSimulator

let SCREEN_SIZE: CGRect = UIScreen.mainScreen().bounds
let SCREEN_WIDTH = SCREEN_SIZE.width
let SCREEN_HEIGHT = SCREEN_SIZE.height

let opacityButtonTouchEffect:CGFloat = 0.5

let APP_NAME = "WealthTrust"

let APP_URL = "https://itunes.apple.com/app/id1162739380"

let URL_KNOW_MORE = "https://www.wealthtrust.in/blog/switch-to-direct-mutual-fund-plan/"
let URL_LIQUID_FUND_BETTER_THAN_SAVINGS = "https://www.wealthtrust.in/blog/liquid-funds-better-than-savings-account"
let URL_SWITCH_HELP = "http://www.wealthtrust.in/faq.html#switch"
let URL_SELL_HELP = "http://www.wealthtrust.in/faq.html#redeem"
let URL_FOLIO_FIND_HELP = "https://www.wealthtrust.in/blog/where-to-find-folio-number"

let kIsOpenedFirstTime = "IsOpened1Time"

let kTitleKnow_More_Liquid_Funds = "Know More - Liquid Funds"
let kTitleSwitch_Help = "Help"
let kTitleSELL_Help = "Help"
let kTitleFolio_Help = "Where to find Folio Number"

// STORYBOARD IDs DECLARED HERE...
let ksbId = ""
let ksbIdUserLoginSignUp = "UserLoginSignUp"
let ksbIdLoginUser = "LoginUser"
let ksbidSearchScreen = "SearchScreen"
let ksbIdNewUserSignUp = "NewUserSignUp"
let ksbIdPanVerificationScreen = "PanVerificationScreen"
let ksbIdOtherInfo = "OtherInfo"
let ksbIdDocScreen = "DocScreen"
let ksbIdSignatureScreen = "SignatureScreen"
let ksbIdIntroScreen = "IntroScreen"
let ksbIdUserProfile = "UserProfile"
let ksbIdForgotPassword = "ForgotPassword"
let ksbIdBuyScreeen = "BuyScreeen"
let ksbIdRedeemScreen = "RedeemScreen"
let ksbIdSwitchScreen = "SwitchScreen"
let ksbIdTransactScreen = "TransactScreen"
let ksbIdSelectSearchFund = "SelectSearchFund"
let sbIdOrderSummaryScreen = "OrderSummaryScreen"
let sbIdOrderSummaryBUY = "OrderSummaryBUY"
let ksbIdResetScreen = "ResetScreen"
let ksbIdOrderSummaryRedeem = "OrderSummaryRedeem"
let ksbIdPortfolioDetailScreen = "PortfolioDetailScreen"
let ksbIdMFTransactionDetailScreen = "MFTransactionDetailScreen"
let ksbIdTopFundsScreen = "TopFundsScreen"
let ksbIdSchemeDetailsScreen = "SchemeDetailsScreen"
let ksbIdDirectSavingCalcScreen = "DirectSavingCalcScreen"
let ksbIdSmartSavingScreen = "SmartSavingScreen"
let ksbIdWebViewController = "WebViewController" 
let ksbSwiftViewController = "SwiftViewController"
let ksbIdUploadPortfolioInstruScreen = "UploadPortfolioInstruScreen"
let ksbIdUploadPortScreen = "UploadPortScreen"
let ksbIdAddPortfolioManually = "AddPortfolioManually"
let ksbIdMyOrders = "MyOrders"
let ksbIdContactViewController = "ContactViewController"


let kMaxFamilyAccountAllowed = "MaxFamilyAccountAllowed"
let kUploadPortfolioConfig = "UploadPortfolioConfig"



let ksbIdFeedbackScreen = "FeedbackScreen"



// ALL ALERTS MESSAGES DEFINED HERE..
let ALERT_INTERNET = "Uh Oh!  Internet is not available.  Please check your connection and try again."
let kAlertEmptyName = "Please enter name"
let kAlertEmptyMobileNumber = "Please enter mobile number."
let kAlertMobileNumber10Number = "Mobile number should be of 10 digit."

let kAlertEmptyEmailId = "Please enter email id."
let kAlertEmailIdIsValidEmail = "Please enter valid email id."
let kAlertPasswordIsValid = "Please enter valid password."
let kAlertEmptyPassword = "Please enter password."
let kAlertEmptyConfirmPassword = "Please enter confirm password."
let kAlertSamePasswordConfirmPassword = "Password and Confirm password should be same."
let kAlertEmpty4DigitPin = "Please enter 4 digit pin."
let kAlertPin4DigitPin = "Pin must be of 4 digit."

let kAlertPasswordAlphanumeric = "Password must be Alphanumeric."
let kAlertPassword8to12 = "Password must be minimum of 8 and maximum 12 characters"

let kAlertEmailIdAlreadyExist = "Entered Email id is already exists."
let kAlertEmailIdInvalid = "Invalid Email or Password!"
let kAlertEmailIdNotExists = "Email does not exists!"
let kAlertEmailSent = "New password sent via Email please check"

let kAlertFeedback = "Please enter your feedback."



let kEnterSchemeName = "Enter Scheme Name"


let sharedInstance = SharedManager.sharedInstance


class SharedManager: NSObject {
    
    static let sharedInstance = SharedManager() // SHARED OBJECT....
    
    var kIsFilter = Bool()
    var isViewAllCalled = Bool()
    var isSearchedTextCall = Bool()
    var isSearchedSeeMore = Bool()
    var isSearchText = Bool()

    let deviceType = "iOS"
    var deviceToken : String!
    var objLoginUser = User()

    let userDefaults = NSUserDefaults.standardUserDefaults()

    static var appDelegate = AppDelegate()

    override init() {
        deviceToken = "DEVICE_TOKEN"
//        objLoginUser = User() // Logged In user Object....
        
    }
    
    func generateToken() {
        
        print(self.userDefaults.objectForKey(kToken))
        if (self.userDefaults.objectForKey(kToken) != nil) {
            print("Token IS : \(self.userDefaults.objectForKey(kToken))")
            return;
        }
        
        // API Call
        let dicToSend:NSDictionary = [
            kEmailId : tokenEmailId
            ,kPassWord : tokenPassword]
        
        WebManagerHK.postDataToURL(kModeClientlogincheck, params: dicToSend, message: "") { (response) in
            print("Dic Response : \(response)")
            
            let mainResponse = response.objectForKey(kWAPIResponse) as! NSDictionary
            let tokenFetched = mainResponse.objectForKey(kToken) as! String
            self.userDefaults.setObject(tokenFetched, forKey: kToken)
            
        }
    }
    
    func generateUserToken() {
        
//        print(self.userDefaults.objectForKey(kToken))
//        if (self.userDefaults.objectForKey(kToken) != nil) {
//            print("Token IS : \(self.userDefaults.objectForKey(kToken))")
//            return;
//        }
        
        
        if let emailID = self.objLoginUser.email
        {
            if let PaddWordRo = self.objLoginUser.password
            {
             
                // API Call
                let dicToSend:NSDictionary = [
                    kEmailId : emailID
                    ,kPassWord : PaddWordRo]
                
                WebManagerHK.postDataToURL(kModeClientlogincheck, params: dicToSend, message: "") { (response) in
                    print("Dic Response : \(response)")
                    
                    if response.objectForKey(kWAPIResponse) is NSDictionary
                    {
                        let mainResponse = response.objectForKey(kWAPIResponse) as! NSDictionary
                        let tokenFetched = mainResponse.objectForKey(kToken) as! String
                        self.userDefaults.setObject(tokenFetched, forKey: kToken)
                    }
                    
                }

            }
        }
        
    }

    func SynchUsedInfo() {
        
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
                
                // API Call
                var dicToSend = NSMutableDictionary()
                if (self.userDefaults.objectForKey(kWAPIServerTimeISTSyncUserAccount) != nil) {
                    print("Exists.....")
                    let lastSyncTime = self.userDefaults.objectForKey(kWAPIServerTimeISTSyncUserAccount) as! String
                    dicToSend = ["ClientId" : objUser.ClientID!,
                                 kSyncFromDateTime : lastSyncTime]
                }else{
                    print("Not Exists.....")
                    dicToSend = ["ClientId" : objUser.ClientID!]
                }
                
                WebManagerHK.postDataToURL(kModeSyncUserAccount, params: dicToSend, message: "") { (response) in
                    print("Dic Response : \(response)")
                    
                    if response.objectForKey(kWAPIResponse) is NSNull
                    {
                        let lastSyncTime = response.objectForKey(kWAPIServerTimeIST) as! String
                        self.userDefaults.setObject(lastSyncTime, forKey: kWAPIServerTimeISTSyncUserAccount)
                        return
                    }
                    
                    let mainResponse = response.objectForKey(kWAPIResponse) as! NSDictionary
                    print(response)
                    
                    let lastSyncTime = response.objectForKey(kWAPIServerTimeIST) as! String
                    self.userDefaults.setObject(lastSyncTime, forKey: kWAPIServerTimeISTSyncUserAccount)

                    let clientUserDetails = mainResponse.objectForKey("clientusermst") as! NSDictionary
                    
                    ////         UPDATE USER..
                    let userInfo: User = User()
                    if let theTitle = clientUserDetails.objectForKey("ClientId") {
                        userInfo.ClientID = String(theTitle)
                    }
                    if let theTitle = clientUserDetails.objectForKey("Name") {
                        userInfo.Name = String(theTitle)
                    }
                    if let theTitle = clientUserDetails.objectForKey("EmailId") {
                        userInfo.email = String(theTitle)
                    }
                    if let theTitle = clientUserDetails.objectForKey("MobileNo") {
                        userInfo.mob = String(theTitle)
                    }
                    if let theTitle = clientUserDetails.objectForKey("PassWord") {
                        userInfo.password = String(theTitle)
                    }
                    if let theTitle = clientUserDetails.objectForKey("CANNO") {
                        userInfo.CAN = String(theTitle)
                    }
                    if let theTitle = clientUserDetails.objectForKey("SignUpStatus") {
                        userInfo.SignupStatus = String(theTitle)
                    }
                    if let theTitle = clientUserDetails.objectForKey("InvestmentAOFStatus") {
                        userInfo.InvestmentAofStatus = String(theTitle)
                        
                        if (userInfo.InvestmentAofStatus as String == "<null>")
                        {
                            userInfo.InvestmentAofStatus = "0" // Means Pending...
                        }
                    }
                    
                    let isUpdated = DBManager.getInstance().updateUser(userInfo)
                    if isUpdated {
                        print("USER DETAILS SYNCHED SUCCESSFULLY!!!!")
                    } else {
                        print("ERROR : USER DETAILS SYNCHED ERROR!!!!")
                    }
                    
                    if userInfo.SignupStatus=="3"
                    {
                        if let array = mainResponse.objectForKey("SignUpStatusArr")
                        {
                            if array.isKindOfClass(NSMutableArray)
                            {
                                let array = mainResponse.objectForKey("SignUpStatusArr") as! NSMutableArray
                                
                                if array.count == 0
                                {
                                }else{
                                    
                                    let SignUpStatusDetails = array.objectAtIndex(0) as! NSMutableDictionary
                                    print(SignUpStatusDetails)
                                    
                                    ////         UPDATE AOF SignUp Details..
                                    let userInfo: AOFStatus = AOFStatus()
                                    
                                    if let theTitle = SignUpStatusDetails.objectForKey("BankAccNoMismatch") {
                                        userInfo.banckaccmismatch = String(theTitle)
                                    }
                                    if let theTitle = SignUpStatusDetails.objectForKey("CheckCopy") {
                                        userInfo.chequecopy = String(theTitle)
                                    }
                                    if let theTitle = SignUpStatusDetails.objectForKey("ClientId") {
                                        userInfo.ClientID = String(theTitle)
                                    }
                                    if let theTitle = SignUpStatusDetails.objectForKey("DOBMismatch") {
                                        userInfo.dobmismatch = String(theTitle)
                                    }
                                    if let theTitle = SignUpStatusDetails.objectForKey("IFSCCodeMismatch") {
                                        userInfo.ifscmismatch = String(theTitle)
                                    }
                                    if let theTitle = SignUpStatusDetails.objectForKey("Id") {
                                        userInfo.idS = String(theTitle)
                                    }
                                    if let theTitle = SignUpStatusDetails.objectForKey("NameMismatch") {
                                        userInfo.namemismatch = String(theTitle)
                                    }
                                    if let theTitle = SignUpStatusDetails.objectForKey("PANNumberMismatch") {
                                        userInfo.pannummismatch = String(theTitle)
                                    }
                                    if let theTitle = SignUpStatusDetails.objectForKey("PanCopy") {
                                        userInfo.pancopy = String(theTitle)
                                    }
                                    if let theTitle = SignUpStatusDetails.objectForKey("Selfie") {
                                        userInfo.selfie = String(theTitle)
                                    }
                                    if let theTitle = SignUpStatusDetails.objectForKey("SignatureMistmatch") {
                                        userInfo.signaturemismatch = String(theTitle)
                                    }
                                    if let theTitle = SignUpStatusDetails.objectForKey("Type") {
                                        userInfo.aoftype = String(theTitle)
                                    }
                                    
                                    // ADD OR UPDATE..
                                    if DBManager.getInstance().checkSignUpStatusAlreadyExist(userInfo)
                                    {
                                        let isUpdated = DBManager.getInstance().updateAOFStatus(userInfo)
                                        if isUpdated {
                                            print("SIGN STATUS UPDATED.....")
                                        } else {
                                            print("ERROR : SIGN STATUS SYNCHED ERROR!!!!")
                                        }
                                        
                                    }else{
                                        
                                        let isUpdated = DBManager.getInstance().addAOFStatus(userInfo)
                                        if isUpdated {
                                            print("SIGN STATUS ADDED.....")
                                        } else {
                                            print("ERROR : SIGN STATUS SYNCHED ERROR!!!!")
                                        }
                                    }
                                    
                                }
                            }else{
                                
                                let SignUpStatusDetails = mainResponse.objectForKey("SignUpStatusArr") as! NSDictionary
                                
                                    ////         UPDATE AOF SignUp Details..
                                    let userInfo: AOFStatus = AOFStatus()
                                    
                                    if let theTitle = SignUpStatusDetails.objectForKey("BankAccNoMismatch") {
                                        userInfo.banckaccmismatch = String(theTitle)
                                    }
                                    if let theTitle = SignUpStatusDetails.objectForKey("CheckCopy") {
                                        userInfo.chequecopy = String(theTitle)
                                    }
                                    if let theTitle = SignUpStatusDetails.objectForKey("ClientId") {
                                        userInfo.ClientID = String(theTitle)
                                    }
                                    if let theTitle = SignUpStatusDetails.objectForKey("DOBMismatch") {
                                        userInfo.dobmismatch = String(theTitle)
                                    }
                                    if let theTitle = SignUpStatusDetails.objectForKey("IFSCCodeMismatch") {
                                        userInfo.ifscmismatch = String(theTitle)
                                    }
                                    if let theTitle = SignUpStatusDetails.objectForKey("Id") {
                                        userInfo.idS = String(theTitle)
                                    }
                                    if let theTitle = SignUpStatusDetails.objectForKey("NameMismatch") {
                                        userInfo.namemismatch = String(theTitle)
                                    }
                                    if let theTitle = SignUpStatusDetails.objectForKey("PANNumberMismatch") {
                                        userInfo.pannummismatch = String(theTitle)
                                    }
                                    if let theTitle = SignUpStatusDetails.objectForKey("PanCopy") {
                                        userInfo.pancopy = String(theTitle)
                                    }
                                    if let theTitle = SignUpStatusDetails.objectForKey("Selfie") {
                                        userInfo.selfie = String(theTitle)
                                    }
                                    if let theTitle = SignUpStatusDetails.objectForKey("SignatureMistmatch") {
                                        userInfo.signaturemismatch = String(theTitle)
                                    }
                                    if let theTitle = SignUpStatusDetails.objectForKey("Type") {
                                        userInfo.aoftype = String(theTitle)
                                    }
                                    
                                    // ADD OR UPDATE..
                                    if DBManager.getInstance().checkSignUpStatusAlreadyExist(userInfo)
                                    {
                                        let isUpdated = DBManager.getInstance().updateAOFStatus(userInfo)
                                        if isUpdated {
                                            print("SIGN STATUS UPDATED.....")
                                        } else {
                                            print("ERROR : SIGN STATUS SYNCHED ERROR!!!!")
                                        }
                                        
                                    }else{
                                        
                                        let isUpdated = DBManager.getInstance().addAOFStatus(userInfo)
                                        if isUpdated {
                                            print("SIGN STATUS ADDED.....")
                                        } else {
                                            print("ERROR : SIGN STATUS SYNCHED ERROR!!!!")
                                        }
                                    }
                            }

                        }
                        
                        
                    }
                    
                    if userInfo.InvestmentAofStatus=="4"
                    {
                        let InvestmentAOFStatusDetails = mainResponse.objectForKey("InvestmentAOFStatusArr") as! NSDictionary
                        print(InvestmentAOFStatusDetails)
                        
                        ////         UPDATE AOF InvestmentAOFStatusDetails Details..
                        let userInfo: AOFStatus = AOFStatus()
                        
                        if let theTitle = InvestmentAOFStatusDetails.objectForKey("BankAccNoMismatch") {
                            userInfo.banckaccmismatch = String(theTitle)
                        }
                        if let theTitle = InvestmentAOFStatusDetails.objectForKey("CheckCopy") {
                            userInfo.chequecopy = String(theTitle)
                        }
                        if let theTitle = InvestmentAOFStatusDetails.objectForKey("ClientId") {
                            userInfo.ClientID = String(theTitle)
                        }
                        if let theTitle = InvestmentAOFStatusDetails.objectForKey("DOBMismatch") {
                            userInfo.dobmismatch = String(theTitle)
                        }
                        if let theTitle = InvestmentAOFStatusDetails.objectForKey("IFSCCodeMismatch") {
                            userInfo.ifscmismatch = String(theTitle)
                        }
                        if let theTitle = InvestmentAOFStatusDetails.objectForKey("Id") {
                            userInfo.idS = String(theTitle)
                        }
                        if let theTitle = InvestmentAOFStatusDetails.objectForKey("NameMismatch") {
                            userInfo.namemismatch = String(theTitle)
                        }
                        if let theTitle = InvestmentAOFStatusDetails.objectForKey("PANNumberMismatch") {
                            userInfo.pannummismatch = String(theTitle)
                        }
                        if let theTitle = InvestmentAOFStatusDetails.objectForKey("PanCopy") {
                            userInfo.pancopy = String(theTitle)
                        }
                        if let theTitle = InvestmentAOFStatusDetails.objectForKey("Selfie") {
                            userInfo.selfie = String(theTitle)
                        }
                        if let theTitle = InvestmentAOFStatusDetails.objectForKey("SignatureMistmatch") {
                            userInfo.signaturemismatch = String(theTitle)
                        }
                        if let theTitle = InvestmentAOFStatusDetails.objectForKey("Type") {
                            userInfo.aoftype = String(theTitle)
                        }
                        
                        
                        if DBManager.getInstance().checkInvetmentAOFAlreadyExist(userInfo)
                        {
                            let isUpdated = DBManager.getInstance().updateAOFStatus(userInfo)
                            if isUpdated {
                                print("InvetmentAOF STATUS UPDATED.....")
                            } else {
                                print("ERROR : InvetmentAOF STATUS SYNCHED ERROR!!!!")
                            }
                            
                        }else{
                            
                            let isUpdated = DBManager.getInstance().addAOFStatus(userInfo)
                            if isUpdated {
                                print("InvetmentAOF STATUS ADDED.....")
                            } else {
                                print("ERROR : InvetmentAOF STATUS SYNCHED ERROR!!!!")
                            }
                        }

                    }
                    
                }

            }
            
        }

    }
    
    
    func SyncAppConf() {
        
        let dicToSend:NSDictionary = [:]

        WebManagerHK.postDataToURL(kModeSyncAppConf, params: dicToSend, message: "") { (response) in
            
            let mainResponse = response.objectForKey(kWAPIResponse) as! NSArray
            print(mainResponse)
            if mainResponse.count == 2
            {
                if mainResponse.objectAtIndex(0) is NSDictionary
                {
                    let mainDic1 = mainResponse.objectAtIndex(0) as! NSDictionary
                    print(mainDic1)
                    
                    self.userDefaults.setObject(mainDic1.valueForKey("ConfigValue"), forKey: kMaxFamilyAccountAllowed)
                    
                    let mainDic2 = mainResponse.objectAtIndex(1) as! NSDictionary
                    print(mainDic2)
                    
                    self.userDefaults.setObject(mainDic2.valueForKey("ConfigValue"), forKey: kUploadPortfolioConfig)

                    print("SyncAppConf SYNCHED SUCCESSFULLY!!!!")
                    
                }
            }
        }

    }
    func SyncMFAccount() {

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
                
                var dicToSend = NSMutableDictionary()
                if (self.userDefaults.objectForKey(kWAPIServerTimeISTSyncMFAccount) != nil) {
                    print("Exists.....")
                    let lastSyncTime = self.userDefaults.objectForKey(kWAPIServerTimeISTSyncMFAccount) as! String
                    dicToSend = ["ClientId" : objUser.ClientID,
                                 kSyncFromDateTime : lastSyncTime]
                }else{
                    print("Not Exists.....")
                    dicToSend = ["ClientId" : objUser.ClientID]
                    
                }

                WebManagerHK.postDataToURL(kModeSyncMFAccount, params: dicToSend, message: "") { (response) in
                    
                    print("SyncMFAccount SYNCHED SUCCESSFULLY!!!!")

                    self.SyncManualTxnx()
                    
                    
                    if response.objectForKey(kWAPIResponse) is NSArray
                    {
                        let mainResponse = response.objectForKey(kWAPIResponse) as! NSArray
                        print("Dic Response : \(response)")
                        
                        let lastSyncTime = response.objectForKey(kWAPIServerTimeIST) as! String
                        self.userDefaults.setObject(lastSyncTime, forKey: kWAPIServerTimeISTSyncMFAccount)

                        if mainResponse.count==0
                        {
                            
                        }else{
                            
                            for dic in mainResponse
                            {
                                print(dic)

                                let mfAccountAllDetails = dic as! NSDictionary
                                
                                //MF Account Details
                                let clientUserDetails = mfAccountAllDetails.valueForKey("mfaccount") as! NSDictionary
                                print(clientUserDetails)
                                
                                ////         UPDATE MFACCOUNT..
                                let mfInfo: MFAccount = MFAccount()
                                
                                if let theTitle = clientUserDetails.objectForKey("AccId") {
                                    mfInfo.AccId = String(theTitle)
                                }
                                if let theTitle = clientUserDetails.objectForKey("clientid") {
                                    mfInfo.clientid = String(theTitle)
                                }
                                if let theTitle = clientUserDetails.objectForKey("FolioNo") {
                                    mfInfo.FolioNo = String(theTitle)
                                }
                                if let theTitle = clientUserDetails.objectForKey("RTAamcCode") {
                                    mfInfo.RTAamcCode = String(theTitle)
                                }
                                if let theTitle = clientUserDetails.objectForKey("AMCName") {
                                    mfInfo.AmcName = String(theTitle)
                                }
                                if let theTitle = clientUserDetails.objectForKey("SchemeCode") {
                                    mfInfo.SchemeCode = String(theTitle)
                                }
                                if let theTitle = clientUserDetails.objectForKey("SchemeName") {
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
                                if DBManager.getInstance().checkMFAccountAlreadyExist(mfInfo)
                                {
                                    
                                    let isUpdated = DBManager.getInstance().updateMFAccount(mfInfo)
                                    if isUpdated {
                                        print("MF ACCOUNT DETAILS SYNCHED/UPDATED SUCCESSFULLY!!!!")
                                    } else {
                                        print("ERROR : MF ACCOUNT DETAILS SYNCHED ERROR!!!!")
                                    }
                                    
                                }else{
                                    
                                    let isAdded = DBManager.getInstance().addMFAccount(mfInfo)
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
                                    print(dic)
                                    
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
                                    if let theTitle = clientUserDetails.objectForKey("TxnOrderDateTime") {
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
                                    
                                    print("dates \(mfInfo.ExecutaionDateTime)")
                                    
                                    // ADD OR UPDATE..
                                    if DBManager.getInstance().checkMFTransactionAlreadyExist(mfInfo)
                                    {
                                        let isUpdated = DBManager.getInstance().updateMFTransaction(mfInfo)
                                        if isUpdated {
                                            print("MF ACCOUNT TRANSACTIONS SYNCHED/UPDATED SUCCESSFULLY!!!!")
                                        } else {
                                            print("ERROR : MF ACCOUNT TRANSACTIONS SYNCHED ERROR!!!!")
                                        }
                                        
                                    }else{
                                        
                                        let isAdded = DBManager.getInstance().addMFTransaction(mfInfo)
                                        if isAdded {
                                            print("MF ACCOUNT TRANSACTIONS SYNCHED/ADDED SUCCESSFULLY!!!!")
                                        } else {
                                            print("ERROR : MF ACCOUNT TRANSACTIONS SYNCHED ERROR!!!!")
                                        }
                                        
                                    }

                                }
                            }
                        }
                        

                    }
                    else
                    {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            
                        })
                    }
                    
                }

            }
        }
    }

    func SyncManualTxnx() {
        
        //        let lastSyncTime = response.objectForKey(kWAPIServerTimeIST) as! String
        //        self.userDefaults.setObject(lastSyncTime, forKey: kWAPIServerTimeISTSyncUserAccount)
        
        
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
                
                
                var dicToSend = NSMutableDictionary()
                if (self.userDefaults.objectForKey(kWAPIServerTimeISTSyncManualTxnx) != nil) {
                    print("Exists.....")
                    let lastSyncTime = self.userDefaults.objectForKey(kWAPIServerTimeISTSyncManualTxnx) as! String
                    dicToSend = ["ClientId" : objUser.ClientID,
                                 kSyncFromDateTime : lastSyncTime]
                }else{
                    print("Not Exists.....")
                    dicToSend = ["ClientId" : objUser.ClientID]
                    
//                                                            let lastSyncTime = response.objectForKey(kWAPIServerTimeIST) as! String
//                                                            self.userDefaults.setObject(lastSyncTime, forKey: kWAPIServerTimeISTSyncMFAccount)
                }

                
                WebManagerHK.postDataToURL(kModeSyncManualTxnx, params: dicToSend, message: "") { (response) in
                    
                    print("SyncManualTxnx SYNCHED SUCCESSFULLY!!!!")
                    self.SyncOrders()

                    if response.objectForKey(kWAPIResponse) is NSArray
                    {
                        let mainResponse = response.objectForKey(kWAPIResponse) as! NSArray
                        print("Dic Response : \(response)")
                        
                        let lastSyncTime = response.objectForKey(kWAPIServerTimeIST) as! String
                        self.userDefaults.setObject(lastSyncTime, forKey: kWAPIServerTimeISTSyncManualTxnx)

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
                                    if let theTitle = clientUserDetails.objectForKey("ModifiedDateTime") {
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
                        
                    }
                }
                
            }
        }
    }

    
    func SyncOrders() {

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
                
                
//                // API Call
//                let dicToSend:NSDictionary = [
//                    "ClientId" : objUser.ClientID!] //objUser.ClientID!
                
                var dicToSend = NSMutableDictionary()
                if (self.userDefaults.objectForKey(kWAPIServerTimeISTSyncOrders) != nil) {
                    print("Exists.....")
                    let lastSyncTime = self.userDefaults.objectForKey(kWAPIServerTimeISTSyncOrders) as! String
                    dicToSend = ["ClientId" : objUser.ClientID,
                                 kSyncFromDateTime : lastSyncTime]
                }else{
                    print("Not Exists.....")
                    dicToSend = ["ClientId" : objUser.ClientID]
                    
//                                                                                let lastSyncTime = response.objectForKey(kWAPIServerTimeIST) as! String
//                                                                                self.userDefaults.setObject(lastSyncTime, forKey: kWAPIServerTimeISTSyncMFAccount)
                }

                WebManagerHK.postDataToURL(kModeSyncOrders, params: dicToSend, message: "") { (response) in
                    if response.objectForKey(kWAPIResponse) is NSArray
                    {
                        
//                        self.SyncPayeezzMandate() // NOT IN USE RIGHT NOW..

                        let mainResponse = response.objectForKey(kWAPIResponse) as! NSArray
                        print("SyncOrders SYNCHED SUCCESSFULLY!!!! \(response)")
                        
                        let lastSyncTime = response.objectForKey(kWAPIServerTimeIST) as! String
                        self.userDefaults.setObject(lastSyncTime, forKey: kWAPIServerTimeISTSyncOrders)

                        
                        if mainResponse.count==0
                        {
                            
                        }else{
                            
                            for dic in mainResponse
                            {
                                print(dic)
                                let orderDetails = dic as! NSDictionary

                                
                                let objOrder : Order = Order()
                                
                                print("Order Details ")
                                if objOrder.AppOrderID==nil {
                                    objOrder.AppOrderID = ""
                                }
                                print("AppOrderID ",objOrder.AppOrderID)
                                if objOrder.ServerOrderID==nil {
                                    if orderDetails.valueForKey("OrderId") is String{
                                        objOrder.ServerOrderID = orderDetails.valueForKey("OrderId") as! String
                                    }else{
                                        objOrder.ServerOrderID = ""
                                    }
                                }
                                print("ServerOrderID ",objOrder.ServerOrderID)
                                
                                objOrder.ClientID = self.objLoginUser.ClientID
                                
                                if objOrder.ClientID==nil {
                                    let allUser = DBManager.getInstance().getAllUser()
                                    if allUser.count==0
                                    {
                                        objOrder.ClientID = ""
                                    }else{
                                        let objUser = allUser.objectAtIndex(0) as! User
                                        self.objLoginUser = objUser
                                        objOrder.ClientID = self.objLoginUser.ClientID
                                    }
                                }
                                print("ClientID ",objOrder.ClientID)
                                
                                if objOrder.FolioNo==nil {
                                    if orderDetails.valueForKey("folioAccNo") is String{
                                        objOrder.FolioNo = orderDetails.valueForKey("folioAccNo") as! String
                                    }else{
                                        objOrder.FolioNo = ""
                                    }
                                }
                                print("FolioNo ",objOrder.FolioNo)
                                
                                if objOrder.FolioCheckDigit==nil {
                                    var findFolickDigit = ""
                                    if objOrder.FolioNo=="" {
                                        findFolickDigit = ""
                                    }else{
                                        
                                        let str = objOrder.FolioNo
                                        let strSplit = str.characters.split("/")
                                        
                                        if let second = strSplit.last {
                                            findFolickDigit = String(second)
                                            
                                            if objOrder.FolioNo==findFolickDigit {
                                                findFolickDigit = ""
                                            }
                                        }
                                    }
                                    
                                    objOrder.FolioCheckDigit = findFolickDigit
                                }
                                print("FolioCheckDigit ",objOrder.FolioCheckDigit)
                                
                                
                                if objOrder.RtaAmcCode==nil {
                                    if orderDetails.valueForKey("rtaAmcCode") is String{
                                        objOrder.RtaAmcCode = orderDetails.valueForKey("rtaAmcCode") as! String
                                    }else{
                                        objOrder.RtaAmcCode = ""
                                    }
                                }
                                print("RtaAmcCode ",objOrder.RtaAmcCode)
                                
                                if objOrder.SrcSchemeCode==nil {
                                    if orderDetails.valueForKey("srcSchemeCode") is String{
                                        objOrder.SrcSchemeCode = orderDetails.valueForKey("srcSchemeCode") as! String
                                    }else{
                                        objOrder.SrcSchemeCode = ""
                                    }
                                }
                                print("SrcSchemeCode ",objOrder.SrcSchemeCode)
                                
                                if objOrder.SrcSchemeName==nil {
                                    if orderDetails.valueForKey("srcSchemeName") is String{
                                        objOrder.SrcSchemeName = orderDetails.valueForKey("srcSchemeName") as! String
                                    }else{
                                        objOrder.SrcSchemeName = ""
                                    }

                                }
                                print("SrcSchemeName ",objOrder.SrcSchemeName)
                                
                                if objOrder.TarSchemeCode==nil {
                                    if orderDetails.valueForKey("tarSchemeCode") is String{
                                        objOrder.TarSchemeCode = orderDetails.valueForKey("tarSchemeCode") as! String
                                    }else{
                                        objOrder.TarSchemeCode = ""
                                    }
                                }
                                print("TarSchemeCode ",objOrder.TarSchemeCode)
                                
                                if objOrder.TarSchemeName==nil {
                                    if orderDetails.valueForKey("tarSchemeName") is String{
                                        objOrder.TarSchemeName = orderDetails.valueForKey("tarSchemeName") as! String
                                    }else{
                                        objOrder.TarSchemeName = ""
                                    }
                                }
                                print("TarSchemeName ",objOrder.TarSchemeName)
                                
                                if objOrder.DividendOption==nil {
                                    if orderDetails.valueForKey("dividendOption") is String{
                                        objOrder.DividendOption = orderDetails.valueForKey("dividendOption") as! String
                                    }else{
                                        objOrder.DividendOption = ""
                                    }
                                }
                                print("DividendOption ",objOrder.DividendOption)
                                
                                
                                if objOrder.VolumeType==nil {
                                    if orderDetails.valueForKey("txnVolumeType") is String{
                                        objOrder.VolumeType = orderDetails.valueForKey("txnVolumeType") as! String
                                    }else{
                                        objOrder.VolumeType = ""
                                    }
                                }
                                print("VolumeType ",objOrder.VolumeType)
                                
                                if objOrder.Volume==nil {
                                    if orderDetails.valueForKey("txnVolume") is String{
                                        objOrder.Volume = orderDetails.valueForKey("txnVolume") as! String
                                    }else{
                                        objOrder.Volume = ""
                                    }
                                }
                                if objOrder.Volume=="" {
                                    objOrder.Volume = "" // Nothing....
                                }
                                print("Volume ",objOrder.Volume)
                                
                                
                                if objOrder.OrderType==nil {
                                    if orderDetails.valueForKey("OrderType") is String{
                                        objOrder.OrderType = orderDetails.valueForKey("OrderType") as! String
                                    }else{
                                        objOrder.OrderType = ""
                                    }
                                }
                                print("OrderType ",objOrder.OrderType)
                                
                                if objOrder.OrderStatus==nil {
                                    if orderDetails.valueForKey("OrderStatus") is String{
                                        objOrder.OrderStatus = orderDetails.valueForKey("OrderStatus") as! String
                                    }else{
                                        objOrder.OrderStatus = ""
                                    }

                                }
                                print("OrderStatus ",objOrder.OrderStatus)
                                
                                if objOrder.AppOrderTimeStamp==nil {
                                    let date = NSDate()
                                    let dateFormatter = NSDateFormatter()
                                    dateFormatter.dateStyle = .MediumStyle
                                    let string = dateFormatter.stringFromDate(date)
                                    
                                    objOrder.AppOrderTimeStamp = string
                                }
                                print("AppOrderTimeStamp ",objOrder.AppOrderTimeStamp)
                                
                                if objOrder.CartFlag==nil {
                                    objOrder.CartFlag = "0" // NotInCart
                                }
                                print("CartFlag ",objOrder.CartFlag)
                                
                                if objOrder.UpdateTime==nil {
                                    let date = NSDate()
                                    let dateFormatter = NSDateFormatter()
                                    dateFormatter.dateStyle = .MediumStyle
                                    let string = dateFormatter.stringFromDate(date)
                                    objOrder.UpdateTime = string
                                }
                                
                                
                                if objOrder.RtaAmcCode==nil {
                                    if orderDetails.valueForKey("rtaAmcCode") is String{
                                        objOrder.RtaAmcCode = orderDetails.valueForKey("rtaAmcCode") as! String
                                    }else{
                                        objOrder.RtaAmcCode = ""
                                    }
                                }

                                objOrder.RtaAmcCode = objOrder.RtaAmcCode.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                                objOrder.SrcSchemeCode = objOrder.SrcSchemeCode.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                                objOrder.TarSchemeCode = objOrder.TarSchemeCode.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                                                                
                                
                                var appOderIdFetched = ""
                                
                                if DBManager.getInstance().checkOrderAlreadyExist(objOrder)
                                {
                                    
                                    // Fetch App Order ID ....MARK: COMMENT
                                    let lastOrder = DBManager.getInstance().getLatestOrder()
                                    if lastOrder.count==0
                                    {
                                    }else{
                                        let objOrderq = lastOrder.objectAtIndex(0) as! Order
                                        objOrder.AppOrderID = objOrderq.AppOrderID
                                        
                                        appOderIdFetched = objOrderq.AppOrderID
                                    }
                                    
                                    let isInserted = DBManager.getInstance().updateOrder(objOrder)
                                    if isInserted {
                                        print("Order Updated... Successfully....")
                                    } else {
                                        //            SharedManager.invokeAlertMethod("", strBody: "Error in saving record.", delegate: nil)
                                    }
                                }
                                else
                                {
                                 
                                    let isInserted = DBManager.getInstance().addOrder(objOrder)
                                    if isInserted {
                                        print("Order Added Successfully....")
                                    } else {
                                        //            SharedManager.invokeAlertMethod("", strBody: "Error in saving record.", delegate: nil)
                                    }

                                    
                                    // Fetch App Order ID ....MARK: COMMENT
                                    let lastOrder = DBManager.getInstance().getLatestOrder()
                                    if lastOrder.count==0
                                    {
                                    }else{
                                        let objOrderq = lastOrder.objectAtIndex(0) as! Order
                                        appOderIdFetched = objOrderq.AppOrderID
                                    }

                                }

                                
                                if objOrder.OrderType=="\(OrderType.BuyPlusSIP.hashValue)"
                                {
                                    print("App ORder ID Fetched : \(appOderIdFetched)")
                                    print("Update Systematic Table...")
                                    
                                    let objOrderSystematic : OrderSystematic = OrderSystematic()
                                    
                                    objOrderSystematic.AppOrderID = appOderIdFetched
                                    
                                    if objOrderSystematic.Frequency==nil {
                                        if orderDetails.valueForKey("frequency") is String{
                                            objOrderSystematic.Frequency = orderDetails.valueForKey("frequency") as! String
                                        }else{
                                            objOrderSystematic.Frequency = ""
                                        }
                                    }
                                    
                                    if objOrderSystematic.Day==nil {
                                        if orderDetails.valueForKey("day") is String{
                                            objOrderSystematic.Day = orderDetails.valueForKey("day") as! String
                                        }else{
                                            objOrderSystematic.Day = ""
                                        }
                                    }

                                    if objOrderSystematic.Start_Month==nil {
                                        if orderDetails.valueForKey("start_Month") is String{
                                            objOrderSystematic.Start_Month = orderDetails.valueForKey("start_Month") as! String
                                        }else{
                                            objOrderSystematic.Start_Month = ""
                                        }
                                    }
                                    
                                    if objOrderSystematic.Start_Year==nil {
                                        if orderDetails.valueForKey("start_Year") is String{
                                            objOrderSystematic.Start_Year = orderDetails.valueForKey("start_Year") as! String
                                        }else{
                                            objOrderSystematic.Start_Year = ""
                                        }
                                    }
                                    
                                    if objOrderSystematic.End_Month==nil {
                                        if orderDetails.valueForKey("end_Month") is String{
                                            objOrderSystematic.End_Month = orderDetails.valueForKey("end_Month") as! String
                                        }else{
                                            objOrderSystematic.End_Month = ""
                                        }
                                    }

                                    if objOrderSystematic.End_Year==nil {
                                        
                                        if orderDetails.valueForKey("end_Year") is String{
                                            
                                            if orderDetails.valueForKey("end_Year") is NSNull
                                            {
                                                objOrderSystematic.End_Year = ""
                                            }else{
                                                objOrderSystematic.End_Year = orderDetails.valueForKey("end_Year") as! String
                                            }
                                        }else{
                                            objOrderSystematic.End_Year = ""
                                        }
                                    }

                                    if objOrderSystematic.NoOfInstallments==nil {
                                        if orderDetails.valueForKey("NoOfInstallments") is String{
                                            objOrderSystematic.NoOfInstallments = orderDetails.valueForKey("NoOfInstallments") as! String
                                        }else{
                                            objOrderSystematic.NoOfInstallments = ""
                                        }
                                    }

                                    if objOrderSystematic.FirstPaymentAmount==nil {
                                        if orderDetails.valueForKey("FirstPaymentAmount") is String{
                                            objOrderSystematic.FirstPaymentAmount = orderDetails.valueForKey("FirstPaymentAmount") as! String
                                        }else{
                                            objOrderSystematic.FirstPaymentAmount = ""
                                        }
                                    }
                                    
                                    if objOrderSystematic.FirstPaymentFlag==nil {
                                        if orderDetails.valueForKey("FirstPaymentFlag") is String{
                                            objOrderSystematic.FirstPaymentFlag = orderDetails.valueForKey("FirstPaymentFlag") as! String
                                        }else{
                                            objOrderSystematic.FirstPaymentFlag = ""
                                        }
                                    }

                                    
                                    if DBManager.getInstance().checkOrderSystematicAlreadyExist(objOrderSystematic)
                                    {
                                        
                                        let isInserted = DBManager.getInstance().updateOrderSystematic(objOrderSystematic)
                                        if isInserted {
                                            print("Order Systematic Updated... Successfully....")
                                        } else {
                                            //            SharedManager.invokeAlertMethod("", strBody: "Error in saving record.", delegate: nil)
                                        }
                                    }
                                    else
                                    {
                                    
                                        let isInserted = DBManager.getInstance().addOrderSystematic(objOrderSystematic)
                                        if isInserted {
                                            print("Order Systematic Added Successfully....")
                                        } else {
                                            //            SharedManager.invokeAlertMethod("", strBody: "Error in saving record.", delegate: nil)
                                        }
                                      
                                    }

                                }
                                
                            }
                            
                        }
                        
                    }
                }
                
            }
        }
    }
    
    func SyncDynamicText() {

//        // API Call
//        let dicToSend:NSDictionary = [:]
        
        var dicToSend = NSMutableDictionary()
        if (self.userDefaults.objectForKey(kWAPIServerTimeISTSyncDynamicText) != nil) {
            print("Exists.....")
            let lastSyncTime = self.userDefaults.objectForKey(kWAPIServerTimeISTSyncDynamicText) as! String
            dicToSend = [kSyncFromDateTime : lastSyncTime]
        }else{
            print("Not Exists.....")
            dicToSend = [:]
            
            self.addDummyDynamictextFirst()
        }
        
        WebManagerHK.postDataToURL(kModeSyncDynamicText, params: dicToSend, message: "") { (response) in
            
            let mainResponse = response.objectForKey(kWAPIResponse) as! NSDictionary
            print(response)
            
            let lastSyncTime = response.objectForKey(kWAPIServerTimeIST) as! String
            self.userDefaults.setObject(lastSyncTime, forKey: kWAPIServerTimeISTSyncDynamicText)

            if mainResponse.objectForKey("dynamicTextOBJ") is NSArray
            {
                let arrData = mainResponse.objectForKey("dynamicTextOBJ") as! NSArray

                for dicToUse in arrData
                {
                    print(dicToUse)
                    let textData = dicToUse as! NSDictionary

                    let objDynamicText : DynamicText = DynamicText()
                    
                    if objDynamicText.text==nil {
                        if textData.valueForKey("Text") is String{
                            objDynamicText.text = textData.valueForKey("Text") as! String
                        }else{
                            objDynamicText.text = ""
                        }
                    }
                    print("text ",objDynamicText.text)
                    
                    if objDynamicText.text_type==nil {
                        if textData.valueForKey("TextType") is String{
                            objDynamicText.text_type = textData.valueForKey("TextType") as! String
                        }else{
                            objDynamicText.text_type = ""
                        }
                    }
                    print("TextType ",objDynamicText.text_type)

                    
                    if objDynamicText.title==nil {
                        if textData.valueForKey("Title") is String{
                            objDynamicText.title = textData.valueForKey("Title") as! String
                        }else{
                            objDynamicText.title = ""
                        }
                    }
                    print("TextType ",objDynamicText.title)

                    
                    
                    if DBManager.getInstance().checkDynamicTextAlreadyExist(objDynamicText)
                    {
                        
                        let isInserted = DBManager.getInstance().updateDynamicText(objDynamicText)
                        if isInserted {
                            print("updateDynamicText Updated... Successfully....")
                        } else {
                            //            SharedManager.invokeAlertMethod("", strBody: "Error in saving record.", delegate: nil)
                        }
                    }
                    else
                    {
                        
                        let isInserted = DBManager.getInstance().addDynamiText(objDynamicText)
                        if isInserted {
                            print("addDynamiText Added Successfully....")
                        } else {
                            //            SharedManager.invokeAlertMethod("", strBody: "Error in saving record.", delegate: nil)
                        }
                        
                    }
                }
            }
            
        }
    }
    
    func addDummyDynamictextFirst()
    {
        
        
//        let arrData = [["":""]]
        
//        var arrData = [[String:Any]]()
//        
//        arrData.append(["Text":"value1","TextType":"value1","Title":"value1"])
        
        
        let item1 = ["TextType":"\(SyncDynamicTextType.SWT_TXN_SUCCESS_DIALOG.hashValue)","Title":"Order Received","Text":"Your switch order has been received. We will process it soon. You can spread the joy of saving upto 1.5% extra by sharing it or rating the app."] // Dictionary
        let item2 = ["TextType":"\(SyncDynamicTextType.SWT_TXN_SUCCESS_SHARE.hashValue)","Title":"","Text":"Finally found a smart, easy and hassle-free way to invest in direct mutual funds. Give #WealthTrust a try - https://itunes.apple.com/app/id1162739380"] // Dictionary
        let item3 = ["TextType":"\(SyncDynamicTextType.BUY_SIP_TXN_SUCCESS_DIALOG.hashValue)","Title":"Order Accepted","Text":"Your order has been accepted. The investment will be reflected in your portfolio once the units are allotted. You can spread the joy of saving upto 1.5% extra by sharing it or rating the app."] // Dictionary
        let item4 = ["TextType":"\(SyncDynamicTextType.BUY_SIP_TXN_SUCCESS_SHARE.hashValue)","Title":"","Text":"Finally found a smart, easy and hassle-free way to invest in direct mutual funds. Give #WealthTrust a try - https://itunes.apple.com/app/id1162739380"] // Dictionary
        let item5 = ["TextType":"\(SyncDynamicTextType.REDEEM_TXN.hashValue)","Title":"Order Received","Text":"We have received your redemption request. The order will be processed in 24 hours."] // Dictionary
        let item6 = ["TextType":"\(SyncDynamicTextType.KYC_PENDING.hashValue)","Title":"KYC Pending","Text":"Sorry, we are currently supporting only  KYC compliant customers. Please complete the KYC process online to start investing."] // Dictionary
        let item7 = ["TextType":"\(SyncDynamicTextType.BUY_ORDER_REDIRECTION.hashValue)","Title":"Payment","Text":"You are being redirected to order payment. The payment goes through 'IndiaIdeas' (BillDesk - Payment gateway). The payment gateway helps in transferring the money to Mutual fund house (AMC)."] // Dictionary
        let item8 = ["TextType":"\(SyncDynamicTextType.SHARE_FROM_DRAWER.hashValue)","Title":"","Text":"Finally found a smart, easy and hassle-free way to invest in direct mutual funds.\nGive #WealthTrust a try - https://itunes.apple.com/app/id1162739380"] // Dictionary
        let item9 = ["TextType":"\(SyncDynamicTextType.SIP_ORDER_INITIATED_BUT_PMRN_NOT_FOUND_IN_SYSTEM.hashValue)","Title":"SIP Mandate not found","Text":"Sorry !!! We cannot process the SIP order right now as your SIP mandate ( Payezz ) is not yet registered. Please contact service@wealthtrust.in for further details"] // Dictionary
        let item10 = ["TextType":"\(SyncDynamicTextType.BUY_PLUS_SIP_TXN_SUCCESS_DIALOG.hashValue)","Title":"Order Accepted","Text":"Thank you for placing the order. Please sign and send 'One-time' SIP mandate which will be sent on your email. This is required to facilitate your further installments. Please ignore if already sent."] // Dictionary
        let item11 = ["TextType":"\(SyncDynamicTextType.BUY_PLUS_SIP_INTIATED.hashValue)","Title":"SIP Order Initiated","Text":"Thank you for placing the order. Please sign and send 'One-time' SIP mandate which will be sent on your email. This is required to facilitate your SIP order. Please ignore if already sent."] // Dictionary
        let item12 = ["TextType":"\(SyncDynamicTextType.SHARE_FROM_DASHBOARD.hashValue)","Title":"","Text":"Finally found a smart, easy and hassle-free way to invest in direct mutual funds.\nGive #WealthTrust a try - https://itunes.apple.com/app/id1162739380"] // Dictionary
        let item13 = ["TextType":"\(SyncDynamicTextType.SHARE_SAVINGS_CALC.hashValue)","Title":"","Text":"Feeling amazed to know that I can save a lot more by switching to direct plan on #WealthTrust . Download now - https://itunes.apple.com/app/id1162739380"] // Dictionary
        let item14 = ["TextType":"\(SyncDynamicTextType.SHARE_TOP_FUNDS.hashValue)","Title":"","Text":"Invest in Top funds suggested by #WealthTrust. Download now - https://itunes.apple.com/app/id1162739380"] // Dictionary
        let item15 = ["TextType":"\(SyncDynamicTextType.SHARE_FROM_MY_PORTFOLIO.hashValue)","Title":"","Text":"You should try Wealthtrust App. It helps me track my mutual funds automatically with just my email Id. You can get Wealthtrust App on - https://itunes.apple.com/app/id1162739380"] // Dictionary
        let item16 = ["TextType":"\(SyncDynamicTextType.BUY_IR_TXN_SUCCESS_DIALOG.hashValue)","Title":"Order Accepted - Share the joy","Text":"The investment will be reflected in your portfolio once the units are allotted. Tell your friends about the smart way of saving more through WealthTrust and spread the joy."] // Dictionary
        let item17 = ["TextType":"\(SyncDynamicTextType.BUY_IR_TXN_SUCCESS_SHARE.hashValue)","Title":"Order Accepted - Share the joy","Text":"You will receive the money in your account in few minutes. Loved this feature? Share the app and spread the joy."] // Dictionary
        let item18 = ["TextType":"\(SyncDynamicTextType.REDEEM_IR_TXN_SUCCESS_DIALOG.hashValue)","Title":"","Text":"Hey, I found WealthTrust App which helps me earn 8% on my excess cash. And the best part is that I get the money in my account in few minutes. Download the app and give it a try.  - https://itunes.apple.com/app/id1162739380"] // Dictionary
        let item19 = ["TextType":"\(SyncDynamicTextType.REDEEM_IR_TXN_SUCCESS_SHARE.hashValue)","Title":"","Text":"IHey, I found WealthTrust App which helps me earn 8% on my excess cash. And the best part is that I get the money in my account in few minutes. Download the app and give it a try.  - https://itunes.apple.com/app/id1162739380"] // Dictionary
        
        
        let arrData = NSArray(objects: item1,item2,item3,item4,item5,item6,item7,item8,item9,item10,item11,item12,item13,item14,item15,item16,item17,item18,item19)
        
        for dicToUse in arrData
        {
            print(dicToUse)
            let textData = dicToUse as! NSDictionary
            
            let objDynamicText : DynamicText = DynamicText()
            
            if objDynamicText.text==nil {
                if textData.valueForKey("Text") is String{
                    objDynamicText.text = textData.valueForKey("Text") as! String
                }else{
                    objDynamicText.text = ""
                }
            }
            print("text ",objDynamicText.text)
            
            if objDynamicText.text_type==nil {
                if textData.valueForKey("TextType") is String{
                    objDynamicText.text_type = textData.valueForKey("TextType") as! String
                }else{
                    objDynamicText.text_type = ""
                }
            }
            print("TextType ",objDynamicText.text_type)
            
            
            if objDynamicText.title==nil {
                if textData.valueForKey("Title") is String{
                    objDynamicText.title = textData.valueForKey("Title") as! String
                }else{
                    objDynamicText.title = ""
                }
            }
            print("TextType ",objDynamicText.title)
            
            
            
            if DBManager.getInstance().checkDynamicTextAlreadyExist(objDynamicText)
            {
                
                let isInserted = DBManager.getInstance().updateDynamicText(objDynamicText)
                if isInserted {
                    print("updateDynamicText Updated... Successfully....")
                } else {
                    //            SharedManager.invokeAlertMethod("", strBody: "Error in saving record.", delegate: nil)
                }
            }
            else
            {
                
                let isInserted = DBManager.getInstance().addDynamiText(objDynamicText)
                if isInserted {
                    print("addDynamiText Added Successfully....")
                } else {
                    //            SharedManager.invokeAlertMethod("", strBody: "Error in saving record.", delegate: nil)
                }
                
            }
        }

        
        
    }
    

    func SyncPayeezzMandate() {
        
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
                
                var dicToSend = NSMutableDictionary()
//                if (self.userDefaults.objectForKey(kWAPIServerTimeISTSyncPayeezzMandate) != nil) {
//                    print("Exists.....")
//                    let lastSyncTime = self.userDefaults.objectForKey(kWAPIServerTimeISTSyncPayeezzMandate) as! String
//                    dicToSend = ["ClientId" : objUser.ClientID!,kSyncFromDateTime : lastSyncTime]
//                }else{
//                    print("Not Exists.....")
//                    dicToSend = ["ClientId" : objUser.ClientID!]
//                }
                
                dicToSend = ["ClientId" : objUser.ClientID!]

                
                WebManagerHK.postDataToURL(kModeSyncPayeezzMandate, params: dicToSend, message: "") { (response) in
                    
                    print("kModeSyncPayeezzMandate SYNCHED SUCCESSFULLY!!!! \(response)")

                    let lastSyncTime = response.objectForKey(kWAPIServerTimeIST) as! String
                    self.userDefaults.setObject(lastSyncTime, forKey: kWAPIServerTimeISTSyncPayeezzMandate)

                    if response.objectForKey(kWAPIResponse) is NSArray
                    {
                        let mainResponse = response.objectForKey(kWAPIResponse) as! NSArray
                        print("Dic Response : \(mainResponse)")
                        
                        
                        if mainResponse.count==0
                        {
                            
                        }else{
                            
                            for dic in mainResponse
                            {
                                print(dic)
                                
                                let mfAccountAllDetails = dic as! NSDictionary
                                
                                ////         UPDATE PayEzzMandate..
                                let mfInfo: PayEzzMandate = PayEzzMandate()
                                
                                if let theTitle = mfAccountAllDetails.objectForKey("MandateID") {
                                    mfInfo.MandateID = String(theTitle)
                                }
                                if let theTitle = mfAccountAllDetails.objectForKey("ClientID") {
                                    mfInfo.clientID = String(theTitle)
                                }
                                if let theTitle = mfAccountAllDetails.objectForKey("subSeq_invAccType") {
                                    mfInfo.subSeq_invAccType = String(theTitle)
                                }
                                if let theTitle = mfAccountAllDetails.objectForKey("subSeq_invAccNo") {
                                    mfInfo.subSeq_invAccNo = String(theTitle)
                                }
                                if let theTitle = mfAccountAllDetails.objectForKey("subSeq_micrNo") {
                                    mfInfo.subSeq_micrNo = String(theTitle)
                                }
                                if let theTitle = mfAccountAllDetails.objectForKey("subSeq_ifscCode") {
                                    mfInfo.subSeq_ifscCode = String(theTitle)
                                }
                                if let theTitle = mfAccountAllDetails.objectForKey("subSeq_bankId") {
                                    mfInfo.subSeq_bankId = String(theTitle)
                                }
                                if let theTitle = mfAccountAllDetails.objectForKey("subSeq_maximumAmount") {
                                    mfInfo.subSeq_maximumAmount = String(theTitle)
                                }
                                if let theTitle = mfAccountAllDetails.objectForKey("subSeq_perpetualFlag") {
                                    mfInfo.subSeq_perpetualFlag = String(theTitle)
                                }
                                if let theTitle = mfAccountAllDetails.objectForKey("subSeq_startDate") {
                                    mfInfo.subSeq_startDate = String(theTitle)
                                }
                                if let theTitle = mfAccountAllDetails.objectForKey("subSeq_endDate") {
                                    mfInfo.subSeq_endDate = String(theTitle)
                                }
                                if let theTitle = mfAccountAllDetails.objectForKey("subSeq_paymentRefNo") {
                                    mfInfo.subSeq_paymentRefNo = String(theTitle)
                                }
                                if let theTitle = mfAccountAllDetails.objectForKey("FilePath") {
                                    mfInfo.FilePath = String(theTitle)
                                }
                                if let theTitle = mfAccountAllDetails.objectForKey("AndroidAppSync") {
                                    mfInfo.AndroidAppSync = String(theTitle)
                                }
                                if let theTitle = mfAccountAllDetails.objectForKey("PayEzzStatus") {
                                    mfInfo.PayEzzStatus = String(theTitle)
                                }

                                // ADD OR UPDATE..
                                if DBManager.getInstance().checkPayEzzMandateAlreadyExist(mfInfo)
                                {
                                    
                                    let isUpdated = DBManager.getInstance().updatePayEzzMandate(mfInfo)
                                    if isUpdated {
                                        print("PayEzzMandate DETAILS SYNCHED/UPDATED SUCCESSFULLY!!!!")
                                    } else {
                                        print("ERROR : PayEzzMandate SYNCHED ERROR!!!!")
                                    }
                                    
                                }else{
                                    
                                    let isAdded = DBManager.getInstance().addPayEzzMandate(mfInfo)
                                    if isAdded {
                                        print("PayEzzMandate DETAILS SYNCHED/ADDED SUCCESSFULLY!!!!")
                                    } else {
                                        print("ERROR : PayEzzMandate DETAILS SYNCHED ERROR!!!!")
                                    }
                                }
                            }
                        }
                    }
                    else
                    {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            
                        })
                    }
                }
            }
        }
    }

    // GENERAL METHODS....
    // Check Internet Connection is Available.
    class func isNetAvailable() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    
    class func getPath(fileName: String) -> String {
        
        let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        let fileURL = documentsURL.URLByAppendingPathComponent(fileName)
        
        return fileURL!.path!
    }

    class func copyFile(fileName: NSString) {
        let dbPath: String = getPath(fileName as String)
        let fileManager = NSFileManager.defaultManager()

        if !fileManager.fileExistsAtPath(dbPath) {
            
            let documentsURL = NSBundle.mainBundle().resourceURL
            let fromPath = documentsURL!.URLByAppendingPathComponent(fileName as String)
            
            var error : NSError?
            
            do {
                try! fileManager.copyItemAtPath(fromPath!.path!, toPath: dbPath)
            } catch let error1 as NSError {
                error = error1
            } catch {
                // Catch any other errors 
            }

            
//            do {
//                
//                try! fileManager.copyItemAtPath(fromPath!.path!, toPath: dbPath)
//            } catch let error1 as NSError {
//                error = error1
//            }
            
//            let alert: UIAlertView = UIAlertView()
            if (error != nil) {
                print("DATABASE ERROR WHEN COPIYING at Path : \(dbPath)")

//                alert.title = "Error Occured"
//                alert.message = error?.localizedDescription
            } else {
                
//                alert.title = "Successfully Copy"
//                alert.message = "Your database copy successfully"
                
                print("DATABASE COPIED at Path : \(dbPath)")

            }
//            alert.delegate = nil
//            alert.addButtonWithTitle("Ok")
//            alert.show()
        }else{
            print("DATABASE ALREADY EXIST Path : \(dbPath)")
        }
    }
    
    class func invokeAlertMethod(strTitle: NSString, strBody: NSString, delegate: AnyObject?) {
        let alert: UIAlertView = UIAlertView()
        alert.message = strBody as String
        alert.title = strTitle as String
        alert.delegate = delegate
        alert.addButtonWithTitle("Ok")
        alert.show()
    }
    
    func isOpenedFirstTime() -> Bool {
        if userDefaults.boolForKey(kIsOpenedFirstTime) {
            return false
        }
        return true
    }
    
    
    class func addShadow(button : UIButton) {
        button.layer.shadowColor = UIColor.blackColor().CGColor;
        button.layer.shadowOpacity = 0.5;
        button.layer.shadowRadius = 1;
        button.layer.shadowOffset = CGSizeMake(0.5, 0.5);
    }
    class func addShadowToView(view : UIView)
    {
        view.layer.shadowColor = UIColor.defaultMenuGray.CGColor;
//        view.layer.shadowOffset = CGSizeMake(0.5, 0.5);
        view.layer.shadowOpacity = 0.7;
        view.layer.shadowRadius = 1.2;
        view.layer.shadowOffset = CGSizeZero

    }

    func getFrequencyFromFullName(sysFreq : String) -> String {

        var result = ""
        
       if (sysFreq=="Daily") {
            result = "D";
        }
        else if (sysFreq=="Weekly") {
            result = "W";
        }
        else if (sysFreq=="Fortnightly") {
            result = "F";
        }
        else if (sysFreq=="Monthly") {
            result = "M";
        }
        else if (sysFreq=="Quarterly") {
            result = "Q";
        }
        else if (sysFreq=="Half Yearly") {
            result = "S";
        }
        else if (sysFreq=="Annual") {
            result = "A";
        }
        else if (sysFreq=="Bi Monthly") {
            result = "B";
        }
        return result
    }

    func getFullNameFromFrequency(sysFreq : String) -> String {
        
        var result = ""
        
        if (sysFreq=="D") {
            result = "Daily";
        }
        else if (sysFreq=="W") {
            result = "Weekly";
        }
        else if (sysFreq=="F") {
            result = "Fortnightly";
        }
        else if (sysFreq=="M") {
            result = "Monthly";
        }
        else if (sysFreq=="Q") {
            result = "Quarterly";
        }
        else if (sysFreq=="S") {
            result = "Half Yearly";
        }
        else if (sysFreq=="A") {
            result = "Annual";
        }
        else if (sysFreq=="B") {
            result = "Bi Monthly";
        }
        else if (sysFreq=="SELECT") {
            result = "SELECT";
        }

        
        return result
    }
    
    func getFormatedDate(date : String) -> String {
        
        let index = date.startIndex.advancedBy(10)
        let dtShort = date.substringToIndex(index)
        print(dtShort)
        
        let formatter  = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.dateFromString(dtShort)!
        
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day , .Month , .Year], fromDate: date)
        
        let year =  components.year
        let month = components.month
        let day = components.day
        
        print(year)
        print(month)
        print(day)
        
        var stringToReturn = ""
        
        let stringYear = String(year)
        let yearToAdd = stringYear.substring(2)
        let stringMonth = MONTH.allValues[month]
        
        stringToReturn = "\(String(day))-\(stringMonth.capitalizedString)-\(yearToAdd)"
        
        return stringToReturn
    }
    func getFormatedDateYYYYMMDD(date : NSDate) -> String {
        
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day , .Month , .Year], fromDate: date)
        
        let year =  components.year
        let month = components.month
        let day = components.day
        
        var stringToReturn = ""
        stringToReturn = "\(year)-\(month)-\(day)"
        return stringToReturn
    }
    func getFormatedDateYYYYMMDDFromCurrentDate() -> String {
        
        let date1 = NSDate()
//        let dateFormatter = NSDateFormatter()
//        dateFormatter.dateStyle = .FullStyle
//        let string = dateFormatter.stringFromDate(date1)
//
//        
//        let formatter  = NSDateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd"
//        let date = formatter.
        
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day , .Month , .Year], fromDate: date1)
        
        let year =  components.year
        let month = components.month
        let day = components.day
        
        var stringToReturn = ""
        stringToReturn = "\(year)-\(month)-\(day)"
        return stringToReturn
    }

    
    func getRandomVal() -> Int {
        
        //let myVar: Int = Int(arc4random())
        let myVar: Int = Int(arc4random_uniform(1000000))

        return myVar
    }
    
    
    func isUserLogin() -> Bool {
        let allUser = DBManager.getInstance().getAllUser()
        if allUser.count==0
        {
            return false
        }
        return true
    }
    
    func uploadUserAction(userActionType: USERACTIONTYPE)
    {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            
            
            let allUser = DBManager.getInstance().getAllUser()
            var emailID: String
            if allUser.count==0
            {
                emailID = UIDevice.currentDevice().identifierForVendor!.UUIDString
            }
            else
            {
                let objUser = allUser.objectAtIndex(0) as! User
                emailID = objUser.email
            }
            let dicToSend = NSMutableDictionary()
            dicToSend["EmailId"] = emailID
            dicToSend["ActionType"] = "\(userActionType.hashValue)"
            
            
            WebManagerHK.postDataToURL(kModeUserActionTracking, params: dicToSend, message: "") { (response) in
                
            }
            
            
        })
        
    }
    
    
    
    func resizeImage(image: UIImage) -> UIImage {
        
        let width: CGFloat = image.size.width
        let height: CGFloat = image.size.height
        var newWidth: CGFloat = width
        var newHeight: CGFloat = height
        let maxValue: CGFloat = 900
        let minValue: CGFloat = 675
        
        if (width > height) {
            if (width > maxValue) {
                newWidth = maxValue;
                newHeight = (newWidth * (height / width));
            }
            if (newHeight > minValue) {
                newHeight = minValue;
                newWidth = (newHeight * (width / height));
            }
        }
        else {
            if (height > maxValue) {
                newHeight = maxValue;
                newWidth = (newHeight * (width / height));
            }
            if (newWidth > minValue) {
                newWidth = minValue;
                newHeight = (newWidth * (height / width));
            }
        }
        
        let newImage = self.resizeImage(image, newWidth: newWidth, newHeight: newHeight)
        
        return newImage
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat, newHeight: CGFloat) -> UIImage {
        
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
        image.drawInRect(CGRectMake(0, 0, newWidth, newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}









