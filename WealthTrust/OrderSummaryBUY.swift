//
//  OrderSummaryBUY.swift
//  WealthTrust
//
//  Created by Hemen Gohil on 10/14/16.
//  Copyright © 2016 Hemen Gohil. All rights reserved.
//

import UIKit
import SafariServices

class OrderSummaryBUY: UIViewController,UIWebViewDelegate,NSURLConnectionDelegate {

    
    @IBOutlet weak var viewOrderSummary: UIView!
    @IBOutlet weak var lblTitle: UILabel!


    @IBOutlet weak var btnBack: UIButton!

    @IBOutlet weak var lblBuyFundtitle: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblOrderStatus: UILabel!
    @IBOutlet weak var lblOrderId: UILabel!

    @IBOutlet weak var lblAmountTotal: UILabel!
    @IBOutlet weak var btnContinue: UIButton!

    var objOrder : Order = Order()

    @IBOutlet weak var lblLine: UILabel!
    @IBOutlet weak var lbltotal1: UILabel!

    @IBOutlet weak var viewPayment: UIView!
    
    @IBOutlet weak var lblPaymentURL: UILabel!
    
    @IBOutlet weak var webPaymentView: UIWebView!
    
    
    var isFor = "BUY"
    
    var frequency = ""
    var day = ""
    
    var startMonth = ""
    var startYear = ""
    var endMonth = ""
    var endYear = ""
    var firstPaymentAmount = ""
    var firstPaymentFlag = true
    var noOfInstallment = ""
    
    @IBOutlet weak var viewOrderSummarySIP: UIView!
    @IBOutlet weak var lblSIPFundTitle: UILabel!
    @IBOutlet weak var lblSIPAmount: UILabel!
    @IBOutlet weak var lblSIPFrequency: UILabel!
    @IBOutlet weak var lblSIPStartDate: UILabel!
    @IBOutlet weak var lblSIPEndDate: UILabel!
    @IBOutlet weak var lblSIPOrderID: UILabel!
    @IBOutlet weak var lblSIPOrderStatus: UILabel!
    var enumOrderStatus = OrderStatus.Processing
    
    @IBOutlet weak var lblExtra1: UILabel!
    
    
    var groupOrderID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        viewOrderSummary.hidden = true
        viewOrderSummarySIP.hidden = true

        if isFor=="BUY" {
            viewOrderSummary.hidden = false

            SharedManager.addShadowToView(viewOrderSummary)
            
            lblBuyFundtitle.text = objOrder.SrcSchemeName
            
            let num = NSNumber(double: Double(objOrder.Volume)!)
            
            let formatr : NSNumberFormatter = NSNumberFormatter()
            formatr.numberStyle = .CurrencyStyle
            formatr.locale = NSLocale(localeIdentifier: "en_IN")
            if let stringDT = formatr.stringFromNumber(num)
            {
                lblAmount.text = "Purchase Amount : \(stringDT)"
                lblAmountTotal.text = "\(stringDT)"
            }
            
            self.lblOrderId.text = ""
            self.lblOrderStatus.text = ""
            self.lblOrderId.sizeToFit()
            self.lblOrderStatus.sizeToFit()
            self.lblOrderId.hidden = true
            self.lblOrderStatus.hidden = true
            

        }

        if isFor=="SIP" {
            
            viewOrderSummarySIP.hidden = false
            SharedManager.addShadowToView(viewOrderSummarySIP)
            lblSIPFundTitle.text = objOrder.SrcSchemeName

            let num = NSNumber(double: Double(objOrder.Volume)!)
            let formatr : NSNumberFormatter = NSNumberFormatter()
            formatr.numberStyle = .CurrencyStyle
            formatr.locale = NSLocale(localeIdentifier: "en_IN")
            if let stringDT = formatr.stringFromNumber(num)
            {
                lblSIPAmount.text = "SIP Amount : \(stringDT)"
                lblAmountTotal.text = "\(stringDT)"
            }
            self.lblSIPOrderID.hidden = true
            self.lblSIPOrderStatus.hidden = true
            self.lblSIPOrderID.text = ""
            self.lblSIPOrderID.sizeToFit()

            if self.firstPaymentFlag
            {
                let amount = NSNumber(double: Double(self.firstPaymentAmount)!)
                if let stringDT = formatr.stringFromNumber(amount)
                {
                    self.lblSIPFrequency.text = "First Payment Amount : \(stringDT)"
                }
                
                let frequencyToSend = sharedInstance.getFullNameFromFrequency(frequency)
                self.lblSIPStartDate.text = "Frequency : \(frequencyToSend)"
                
                if frequencyToSend=="Monthly" || frequencyToSend=="Quarterly" || frequencyToSend=="Half Yearly" || frequencyToSend=="Annual" || frequencyToSend=="Bi Monthly"
                {
                    
                    lblSIPEndDate.text = "Start Date : \(self.day)-\(self.startMonth)-\(self.startYear)"
                    lblSIPEndDate.hidden = false

                    lblSIPOrderID.text = "No of Installments : \(self.noOfInstallment)"
                    lblSIPOrderID.hidden = false

                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.viewOrderSummarySIP.frame = CGRect(x: self.viewOrderSummarySIP.frame.origin.x, y: self.viewOrderSummarySIP.frame.origin.y, width: self.viewOrderSummarySIP.frame.size.width, height: 155)
                    })

                }else{
                    
                    lblSIPEndDate.text = "Start Date : \(self.day)-\(self.startMonth)-\(self.startYear)"
                    lblSIPEndDate.hidden = false
                    
                    lblSIPOrderID.text = "End Date : \(self.endMonth)-\(self.endYear)"
                    lblSIPOrderID.hidden = false

                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        self.viewOrderSummarySIP.frame = CGRect(x: self.viewOrderSummarySIP.frame.origin.x, y: self.viewOrderSummarySIP.frame.origin.y, width: self.viewOrderSummarySIP.frame.size.width, height: 150)
                    })
                }
            }
            else
            {
                let frequencyToSend = sharedInstance.getFullNameFromFrequency(frequency)
                self.lblSIPFrequency.text = "Frequency : \(frequencyToSend)"
                
                if frequencyToSend=="Monthly" || frequencyToSend=="Quarterly" || frequencyToSend=="Half Yearly" || frequencyToSend=="Annual" || frequencyToSend=="Bi Monthly"
                {
                    
                    lblSIPStartDate.text = "Start Date : \(self.day)-\(self.startMonth)-\(self.startYear)"
                    lblSIPEndDate.text = "No of Installments : \(self.noOfInstallment)"
                    lblSIPEndDate.hidden = false
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.viewOrderSummarySIP.frame = CGRect(x: self.viewOrderSummarySIP.frame.origin.x, y: self.viewOrderSummarySIP.frame.origin.y, width: self.viewOrderSummarySIP.frame.size.width, height: 140)
                    })
                }else{
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        self.viewOrderSummarySIP.frame = CGRect(x: self.viewOrderSummarySIP.frame.origin.x, y: self.viewOrderSummarySIP.frame.origin.y, width: self.viewOrderSummarySIP.frame.size.width, height: 135)
                    })
                    lblSIPStartDate.text = "Start Date : \(self.day)-\(self.startMonth)-\(self.startYear)"
                    lblSIPEndDate.text = "End Date : \(self.endMonth)-\(self.endYear)"
                }

            }
            
        }
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
    
//    func todaysDateAsString() -> String {
//        
//        let date = NSDate()
//        let dateFormatter = NSDateFormatter()
//        dateFormatter.dateFormat = "dd-MM-yyyy"
//        let str = dateFormatter.stringFromDate(date)
//        return str
//    }
    
    @IBAction func btnBackClick(sender: AnyObject) {
        
        print(self.navigationController?.viewControllers)
        
        if self.lblTitle.text=="Order Summary" {
            self.navigationController?.popViewControllerAnimated(true)
        }
        
        if self.lblTitle.text=="Order Status" {
            
            
            for viewController in (self.navigationController?.viewControllers)! {
                
                if viewController.isKindOfClass(TransactScreen) {
                    self.navigationController?.popToViewController(viewController, animated: true)
                    return
                }
                
                if viewController.isKindOfClass(DirectSavingCalcScreen) {
                    self.navigationController?.popToViewController(viewController, animated: true)
                    return
                }

                if viewController.isKindOfClass(UserProfile) {
                    self.navigationController?.popToViewController(viewController, animated: true)
                    return
                }
                
                
                if viewController.isKindOfClass(MainViewController) {
                    self.navigationController?.popToViewController(viewController, animated: true)
                    return
                }
                
                
                if viewController.isKindOfClass(PortfolioScreen) {
                    self.navigationController?.popToViewController(viewController, animated: true)
                    return
                }

            }
        }
    }
    
    @IBAction func btnContinueClicked(sender: AnyObject) {
        
        
        if isFor=="BUY" { // BUY START...
            
            print("Order Details ")
            if objOrder.AppOrderID==nil {
                objOrder.AppOrderID = ""
            }
            print("AppOrderID ",objOrder.AppOrderID)
            if objOrder.ServerOrderID==nil {
                objOrder.ServerOrderID = ""
            }
            print("ServerOrderID ",objOrder.ServerOrderID)
            
            objOrder.ClientID = sharedInstance.objLoginUser.ClientID
            
            if objOrder.ClientID==nil {
                let allUser = DBManager.getInstance().getAllUser()
                if allUser.count==0
                {
                    objOrder.ClientID = ""
                }else{
                    let objUser = allUser.objectAtIndex(0) as! User
                    sharedInstance.objLoginUser = objUser
                    objOrder.ClientID = sharedInstance.objLoginUser.ClientID
                }
            }
            print("ClientID ",objOrder.ClientID)
            
            if objOrder.FolioNo==nil {
                objOrder.FolioNo = ""
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
                objOrder.RtaAmcCode = "D"
            }
            print("RtaAmcCode ",objOrder.RtaAmcCode)
            
            if objOrder.SrcSchemeCode==nil {
                objOrder.SrcSchemeCode = ""
            }
            print("SrcSchemeCode ",objOrder.SrcSchemeCode)
            
            if objOrder.SrcSchemeName==nil {
                objOrder.SrcSchemeName = ""
            }
            print("SrcSchemeName ",objOrder.SrcSchemeName)
            
            if objOrder.TarSchemeCode==nil {
                objOrder.TarSchemeCode = ""
            }
            print("TarSchemeCode ",objOrder.TarSchemeCode)
            
            if objOrder.TarSchemeName==nil {
                
                objOrder.TarSchemeName = ""
            }
            print("TarSchemeName ",objOrder.TarSchemeName)
            
            if objOrder.DividendOption==nil {
                objOrder.DividendOption = "Z" // Not Applicable...
            }
            print("DividendOption ",objOrder.DividendOption)
            
            if objOrder.VolumeType==nil {
                objOrder.VolumeType = "A" // All Units...
            }
            print("VolumeType ",objOrder.VolumeType)
            
            if objOrder.Volume==nil {
                objOrder.Volume = "" // Nothing....
            }
            if objOrder.Volume=="" {
                objOrder.Volume = "" // Nothing....
            }
            print("Volume ",objOrder.Volume)
            
            if objOrder.OrderType==nil {
                objOrder.OrderType = "\(OrderType.Buy.hashValue)" //
            }
            print("OrderType ",objOrder.OrderType)
            
            if objOrder.OrderStatus==nil {
                objOrder.OrderStatus = "0" // Processing...
            }
            print("OrderStatus ",objOrder.OrderStatus)
            
            let AppOrderTimeStamp = sharedInstance.getFormatedDateYYYYMMDDFromCurrentDate()
            if objOrder.AppOrderTimeStamp==nil {
                objOrder.AppOrderTimeStamp = AppOrderTimeStamp
            }
            print("AppOrderTimeStamp ",objOrder.AppOrderTimeStamp)
            
            if objOrder.CartFlag==nil {
                objOrder.CartFlag = "0" // NotInCart
            }
            print("CartFlag ",objOrder.CartFlag)
            
            if objOrder.UpdateTime==nil {
                objOrder.UpdateTime = AppOrderTimeStamp
            }
            
            let isInserted = DBManager.getInstance().addOrder(objOrder)
            if isInserted {
                print("Order Added Successfully....")
            } else {
                //            SharedManager.invokeAlertMethod("", strBody: "Error in saving record.", delegate: nil)
            }
            
            // Successfully Data Saved in local........... NOW CALL APIs....
            
            
            // Fetch App Order ID ....MARK: COMMENT
            let lastOrder = DBManager.getInstance().getLatestOrder()
            if lastOrder.count==0
            {
            }else{
                let objOrder = lastOrder.objectAtIndex(0) as! Order
                self.objOrder.AppOrderID = objOrder.AppOrderID
            }
            print("NEW APP ORDER ID GENERATED \(self.objOrder.AppOrderID)")
            
            
            self.objOrder.RtaAmcCode = self.objOrder.RtaAmcCode.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            self.objOrder.SrcSchemeCode = self.objOrder.SrcSchemeCode.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            self.objOrder.TarSchemeCode = self.objOrder.TarSchemeCode.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            
            let dic = NSMutableDictionary()
            dic["ClientId"] = self.objOrder.ClientID
            dic["OrderType"] = "\(OrderType.Buy.hashValue)"
            
            let arrDic : NSMutableArray = []
            
            arrDic.addObject(["AppOrderID" : self.objOrder.AppOrderID,
                "folioAccNo" : self.objOrder.FolioNo,
                "rtaAmcCode" : String(self.objOrder.RtaAmcCode),
                "srcSchemeName" : self.objOrder.SrcSchemeName,
                "srcSchemeCode" : self.objOrder.SrcSchemeCode,
                "dividendOption" : "\(self.objOrder.DividendOption)",
                "txnVolume" : self.objOrder.Volume,
                "WealtheeOrderTimeStamp" : objOrder.AppOrderTimeStamp]) // self.objOrder.UpdateTime //"2016-10-15"
            
            dic["SchemeArr"] = arrDic
            
            WebManagerHK.postDataToURL(kModeOrders, params: dic, message: "Please Wait...") { (response) in
                print("Dic Response For Order: \(response)")
                
                if response.objectForKey(kWAPIResponse) is NSArray
                {
                    let mainResponse = response.objectForKey(kWAPIResponse) as! NSArray
                    
                    let oerderID = mainResponse.objectAtIndex(1).valueForKey("OrderId")
                    
                    self.objOrder.ServerOrderID = oerderID as! String
                    print(self.objOrder.ServerOrderID)
                    
                    // UPDATE DB...
                    ////         UPDATE ORDER..
                    print("UPDATE DATA \(self.objOrder)")
                    
                    let isUpdated = DBManager.getInstance().updateOrder(self.objOrder)
                    if isUpdated {
                        print("Updated Recoeds...... Success")
                    } else {
                        print("Failed to Update...")
                    }
                    
                    
                    if let urlToRedirect = mainResponse.objectAtIndex(0).valueForKey("url") as? String
                    {
                        print("Url To Redirect : \(urlToRedirect)")
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            
                            let dt = DBManager.getInstance().getDynamicText(SyncDynamicTextType.BUY_ORDER_REDIRECTION)
                            let alertController = UIAlertController(title: dt.title, message: dt.text, preferredStyle: .Alert)
                            
                            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: { (defaultAction1) in
                                
                                print("YES CAKKKEDDD OKJJJJJJKKKKK")
                                
                                self.viewPayment.hidden = false
                                self.webPaymentView.delegate = self
                                self.lblPaymentURL.text = urlToRedirect
                                
                                if self.verifyUrl(urlToRedirect)
                                {
                                    print("YES Corect")
                                    //                                UIApplication.sharedApplication().openURL(NSURL(string: urlToRedirect)!)
                                    
                                }else{
                                    print("Not Correct")
                                }
                                
                                let url = NSURL (string: urlToRedirect)//where URL = https://203.xxx.xxx.xxx
                                let requestObj = NSURLRequest(URL: url!)
                                let request: NSURLRequest = NSURLRequest(URL: url!)
                                let connection: NSURLConnection = NSURLConnection(request: request, delegate: self, startImmediately: false)!
                                connection.start()
                                self.webPaymentView.loadRequest(requestObj)
                                
//                                self.webPaymentView.loadRequest(NSURLRequest(URL: NSURL(string: urlToRedirect )!))

                                
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    
                                    self.lblTitle.text = "Order Status"
                                    self.viewOrderSummary.frame = CGRect(x: self.viewOrderSummary.frame.origin.x, y: self.viewOrderSummary.frame.origin.y, width: self.viewOrderSummary.frame.size.height, height: 170)
                                    self.lblOrderId.hidden = false
                                    self.lblOrderId.text = "Order id : \(self.objOrder.ServerOrderID)"
                                    self.lblOrderStatus.hidden = false
                                    
                                    self.btnContinue.hidden = true
                                    self.lblAmountTotal.hidden = true
                                    self.lblLine.hidden = true
                                    self.lbltotal1.hidden = true
                                    
                                    self.btnBack.setImage(UIImage(named: "iconClose") , forState: .Normal)
                                    
                                })
                                
                                
                            })
                            
                            alertController.addAction(defaultAction)
                            self.presentViewController(alertController, animated: true, completion: nil)
                            
                        })
                        
                    }
                }
            }

        } // BUY END
        
        if isFor=="SIP" { // SIP START...
            
            print("Order Details ")
            if objOrder.AppOrderID==nil {
                objOrder.AppOrderID = ""
            }
            print("AppOrderID ",objOrder.AppOrderID)
            if objOrder.ServerOrderID==nil {
                objOrder.ServerOrderID = ""
            }
            print("ServerOrderID ",objOrder.ServerOrderID)
            
            objOrder.ClientID = sharedInstance.objLoginUser.ClientID
            
            if objOrder.ClientID==nil {
                let allUser = DBManager.getInstance().getAllUser()
                if allUser.count==0
                {
                    objOrder.ClientID = ""
                }else{
                    let objUser = allUser.objectAtIndex(0) as! User
                    sharedInstance.objLoginUser = objUser
                    objOrder.ClientID = sharedInstance.objLoginUser.ClientID
                }
            }
            print("ClientID ",objOrder.ClientID)
            
            if objOrder.FolioNo==nil {
                objOrder.FolioNo = ""
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
                objOrder.RtaAmcCode = "H"
            }
            print("RtaAmcCode ",objOrder.RtaAmcCode)
            
            if objOrder.SrcSchemeCode==nil {
                objOrder.SrcSchemeCode = ""
            }
            print("SrcSchemeCode ",objOrder.SrcSchemeCode)
            
            if objOrder.SrcSchemeName==nil {
                objOrder.SrcSchemeName = ""
            }
            print("SrcSchemeName ",objOrder.SrcSchemeName)
            
            if objOrder.TarSchemeCode==nil {
                objOrder.TarSchemeCode = ""
            }
            print("TarSchemeCode ",objOrder.TarSchemeCode)
            
            if objOrder.TarSchemeName==nil {
                objOrder.TarSchemeName = ""
            }
            print("TarSchemeName ",objOrder.TarSchemeName)
            
            if objOrder.DividendOption==nil {
                objOrder.DividendOption = "Z" // Not Applicable...
            }
            print("DividendOption ",objOrder.DividendOption)
            
            
            if objOrder.VolumeType==nil {
                objOrder.VolumeType = "A" // Amount...
            }
            print("VolumeType ",objOrder.VolumeType)
            
            if objOrder.Volume==nil {
                objOrder.Volume = "" // Nothing....
            }
            if objOrder.Volume=="" {
                objOrder.Volume = "" // Nothing....
            }
            print("Volume ",objOrder.Volume)
            
            
            if objOrder.OrderType==nil {
                objOrder.OrderType = "\(OrderType.BuyPlusSIP.hashValue)" //
            }
            print("OrderType ",objOrder.OrderType)
            
            if objOrder.OrderStatus==nil {
                objOrder.OrderStatus = "0" // Processing...
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
                let objOrder = lastOrder.objectAtIndex(0) as! Order
                self.objOrder.AppOrderID = objOrder.AppOrderID
            }
            print("NEW APP ORDER ID GENERATED \(self.objOrder.AppOrderID)")
            
            let objSystematicOrder : OrderSystematic = OrderSystematic()
            objSystematicOrder.AppOrderID = self.objOrder.AppOrderID
            objSystematicOrder.Frequency = self.frequency
            objSystematicOrder.Day = self.day
            objSystematicOrder.Start_Month = self.startMonth
            objSystematicOrder.Start_Year = self.startYear
            objSystematicOrder.End_Month = self.endMonth
            objSystematicOrder.End_Year = self.endYear
            objSystematicOrder.NoOfInstallments = self.noOfInstallment
            if self.firstPaymentFlag {
                objSystematicOrder.FirstPaymentFlag = "1"
            }else{
                objSystematicOrder.FirstPaymentFlag = "0"
            }
            objSystematicOrder.FirstPaymentAmount = self.firstPaymentAmount
            
            // Add Data to Systematically.... START
            let isAddedSystematicData = DBManager.getInstance().addOrderSystematic(objSystematicOrder)
            if isAddedSystematicData {
                print("Order Added Systematically Successfully....")
            } else {
            }
            
            //END
            
            // Successfully Data Saved in local........... NOW CALL APIs....
            // Fetch App Order ID ....MARK: COMMENT
//            let lastOrder = DBManager.getInstance().getLatestOrder()
//            if lastOrder.count==0
//            {
//            }else{
//                let objOrder = lastOrder.objectAtIndex(0) as! Order
//                self.objOrder.AppOrderID = objOrder.AppOrderID
//            }
            print("NEW APP ORDER ID GENERATED \(self.objOrder.AppOrderID)")
            
            self.objOrder.RtaAmcCode = self.objOrder.RtaAmcCode.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            self.objOrder.SrcSchemeCode = self.objOrder.SrcSchemeCode.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            self.objOrder.TarSchemeCode = self.objOrder.TarSchemeCode.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            
//            self.objOrder.ClientID = "1"
            
            let dic = NSMutableDictionary()
            dic["ClientId"] = self.objOrder.ClientID
            dic["OrderType"] = "\(OrderType.BuyPlusSIP.hashValue)"
            
            let arrDic : NSMutableArray = []
            
            let WealtheeOrderTimeStamp = sharedInstance.getFormatedDateYYYYMMDDFromCurrentDate()

            arrDic.addObject(["AppOrderID" : self.objOrder.AppOrderID,
                "folioAccNo" : self.objOrder.FolioNo,
                "rtaAmcCode" : String(self.objOrder.RtaAmcCode),
                "srcSchemeName" : self.objOrder.SrcSchemeName,
                "srcSchemeCode" : self.objOrder.SrcSchemeCode,
                "dividendOption" : "\(self.objOrder.DividendOption)",
                "txnVolume" : self.objOrder.Volume,
                "frequency" : self.frequency,
                "day" : self.day,
                "start_Month" : self.startMonth,
                "start_Year" : self.startYear,
                "end_Month" : self.endMonth,
                "end_Year" : self.endYear,
                "FirstPaymentAmount" : self.firstPaymentAmount,
                "FirstPaymentFlag" : self.firstPaymentFlag,
                "NoOfInstallments" : self.noOfInstallment,
                "AndroidAppSync" : "0",
                "WealtheeOrderTimeStamp" : WealtheeOrderTimeStamp])
            
            dic["SchemeArr"] = arrDic
            
            WebManagerHK.postDataToURL(kModeOrders, params: dic, message: "Please Wait...") { (response) in
                print("Dic Response For Order: \(response)")
                
                if response.objectForKey(kWAPIResponse) is NSArray
                {

                    if self.firstPaymentFlag
                    {
                        
                        let mainResponse = response.objectForKey(kWAPIResponse) as! NSArray
                        
                        let oerderID = mainResponse.objectAtIndex(1).valueForKey("OrderId")
                        
                        self.objOrder.ServerOrderID = oerderID as! String
                        print(self.objOrder.ServerOrderID)
                        
                        // UPDATE DB...
                        ////         UPDATE ORDER..
                        print("UPDATE DATA \(self.objOrder)")
                        
                        let isUpdated = DBManager.getInstance().updateOrder(self.objOrder)
                        if isUpdated {
                            print("Updated Recoeds...... Success")
                        } else {
                            print("Failed to Update...")
                        }

                        if let urlToRedirect = mainResponse.objectAtIndex(0).valueForKey("url") as? String
                        {
                            print("Url To Redirect : \(urlToRedirect)")
                            
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                
                                let dt = DBManager.getInstance().getDynamicText(SyncDynamicTextType.BUY_ORDER_REDIRECTION)
                                let alertController = UIAlertController(title: dt.title, message: dt.text, preferredStyle: .Alert)
                                
                                let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: { (defaultAction1) in
                                    
                                    print("YES CAKKKEDDD OKJJJJJJKKKKK")
                                    
                                    self.viewPayment.hidden = false
                                    self.webPaymentView.delegate = self
                                    self.lblPaymentURL.text = urlToRedirect
                                    
                                    if self.verifyUrl(urlToRedirect)
                                    {
                                        print("YES Corect")
                                        //                                UIApplication.sharedApplication().openURL(NSURL(string: urlToRedirect)!)
                                        
                                    }else{
                                        print("Not Correct")
                                    }
                                    
                                    let url = NSURL (string: urlToRedirect)//where URL = https://203.xxx.xxx.xxx
                                    let requestObj = NSURLRequest(URL: url!)
                                    let request: NSURLRequest = NSURLRequest(URL: url!)
                                    let connection: NSURLConnection = NSURLConnection(request: request, delegate: self, startImmediately: false)!
                                    connection.start()
                                    self.webPaymentView.loadRequest(requestObj)
                                    
//                                    self.webPaymentView.loadRequest(NSURLRequest(URL: NSURL(string: urlToRedirect )!))

                                    // SIP
                                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                        
                                        self.lblTitle.text = "Order Status"
                                        self.viewOrderSummarySIP.frame = CGRect(x: self.viewOrderSummarySIP.frame.origin.x, y: self.viewOrderSummarySIP.frame.origin.y, width: self.viewOrderSummarySIP.frame.size.width, height: 170)
                                        self.lblSIPOrderID.hidden = false
                                        self.lblSIPOrderID.text = "Order id : \(self.objOrder.ServerOrderID)"
                                        self.lblSIPOrderStatus.hidden = false
                                        
                                        self.btnContinue.hidden = true
                                        self.lblAmountTotal.hidden = true
                                        self.lblLine.hidden = true
                                        self.lbltotal1.hidden = true
                                        
                                        self.btnBack.setImage(UIImage(named: "iconClose") , forState: .Normal)
                                        
                                    })
                                })
                                
                                alertController.addAction(defaultAction)
                                self.presentViewController(alertController, animated: true, completion: nil)
                                
                            })
                        }
                    }else
                    {
                        
                        let mainResponse = response.objectForKey(kWAPIResponse) as! NSArray
                        
                        let oerderID = mainResponse.objectAtIndex(0).valueForKey("OrderId")
                        
                        self.objOrder.ServerOrderID = oerderID as! String
                        print(self.objOrder.ServerOrderID)
                        
                        // UPDATE DB...
                        ////         UPDATE ORDER..
                        print("UPDATE DATA \(self.objOrder)")
                        
                        let isUpdated = DBManager.getInstance().updateOrder(self.objOrder)
                        if isUpdated {
                            print("Updated Recoeds...... Success")
                        } else {
                            print("Failed to Update...")
                        }
                        
                                    // SIP
                                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                        
                                        self.lblTitle.text = "Order Status"
                                        self.viewOrderSummarySIP.frame = CGRect(x: self.viewOrderSummarySIP.frame.origin.x, y: self.viewOrderSummarySIP.frame.origin.y, width: self.viewOrderSummarySIP.frame.size.width, height: 170)
                                        self.lblSIPOrderID.hidden = false
                                        self.lblSIPOrderID.text = "Order id : \(self.objOrder.ServerOrderID)"
                                        self.lblSIPOrderStatus.hidden = false
                                        
                                        self.btnContinue.hidden = true
                                        self.lblAmountTotal.hidden = true
                                        self.lblLine.hidden = true
                                        self.lbltotal1.hidden = true
                                        
                                        self.btnBack.setImage(UIImage(named: "iconClose") , forState: .Normal)
                                        
                                    })
                        
                    }
                }
            }
        } // SIP END
    }
    
    
    func verifyUrl (urlString: String?) -> Bool {
        //Check for nil
        if let urlString = urlString {
            // create NSURL instance
            if let url = NSURL(string: urlString) {
                // check if your application can open the NSURL instance
                return UIApplication.sharedApplication().canOpenURL(url)
            }
        }
        return false
    }

    @IBAction func btnPaymentBackClicked(sender: AnyObject) {
        
        let alertController = UIAlertController(title: APP_NAME, message: "Do you really want to cancel the payment?", preferredStyle: .Alert)
        
        let btnYes = UIAlertAction(title: "Yes", style: .Default, handler: { (defaultAction1) in
            
            print("YES CAKKKEDDD OKJJJJJJKKKKK")
            self.webPaymentView.stopLoading()
            self.viewPayment.hidden = true

            self.enumOrderStatus = .SENT_TO_MFU
            
            self.updateOrderStatusNow()
            
        })
        
        let btnNo = UIAlertAction(title: "No", style: .Default, handler: { (defaultAction1) in
            print("No CAKKKEDDD OKJJJJJJKKKKK")
        })

        alertController.addAction(btnYes)
        alertController.addAction(btnNo)

        self.presentViewController(alertController, animated: true, completion: nil)

    }
    
    @IBAction func btnPaymentRefreshClicked(sender: AnyObject) {
        self.webPaymentView.reload()
    }
    
    func webView(IciciWebView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool
    {
        //Do whatever you want to do.
        
        print("LOADING REQUEST URL : \(request.URL!.absoluteURL)")
        
//        https://14.141.212.169:4091/common/session.jsp
//        http://api.wealthtrust.in/mfu/sessionout
//        http://api.wealthtrust.in/mfu/error?uniqueID=20161024115143vK2amL&status=cancel
//        http://api.wealthtrust.in/mfu/transactionsuccess?uniqueID=20161024024257wp5AcB&orderStatus=success&orderId=14176AYA01001122
        
        
        let urlString = request.URL!.absoluteString
        
//        // renamed to range(of:"") in Swift 3.0
//        if urlString.rangeOfString("Swift") != nil{
//            print("exists")
//        }
        
        if urlString!.lowercaseString.rangeOfString("mfu/sessionout") != nil {
            print("exists session time out")
            
            webPaymentView.stopLoading()
            viewPayment.hidden = true

            enumOrderStatus = .SessionTimeOut
        }
        if urlString!.lowercaseString.rangeOfString("status=cancel") != nil {
            print("exists cancel")
            
            webPaymentView.stopLoading()
            viewPayment.hidden = true
            
            enumOrderStatus = .Cancelled

        }
        if urlString!.lowercaseString.rangeOfString("status=success") != nil {
            print("exists success")
            
            webPaymentView.stopLoading()
            viewPayment.hidden = true

            enumOrderStatus = .Accepted
            if let queryString = request.URL!.getKeyVals() {
                print(queryString)
                let dicValues = queryString as NSDictionary
                
                if let orderIIDD = dicValues.valueForKey("orderId") {
                    self.groupOrderID = orderIIDD as! String
                }else{
                    self.groupOrderID = ""
                }
            }
        }
        if urlString!.lowercaseString.rangeOfString("status=failed") != nil {
            print("exists failed")
            
            webPaymentView.stopLoading()
            viewPayment.hidden = true

            enumOrderStatus = .Failed
        }
        
        if urlString!.lowercaseString.rangeOfString("status=failure") != nil {
            print("exists failed")
            
            webPaymentView.stopLoading()
            viewPayment.hidden = true
            
            enumOrderStatus = .Failed
            
            
        }

        self.updateOrderStatusNow()

        return true
    }
    
    func updateOrderStatusNow() {
        
        print(enumOrderStatus)
        
        self.objOrder.OrderStatus = "\(enumOrderStatus.hashValue)"
        // Update Table DATA WITH ORDER STATUS...
        let isUpdated = DBManager.getInstance().updateOrder(self.objOrder)
        if isUpdated {
            print("Updated Recoeds...... Success")
        } else {
            print("Failed to Update...")
        }
        
        let dic = NSMutableDictionary()
        dic["ClientId"] = self.objOrder.ClientID

        let arrDic : NSMutableArray = []
        if self.groupOrderID=="" {
            arrDic.addObject(["OrderId" : self.objOrder.ServerOrderID,
                "OrderStatus" : enumOrderStatus.hashValue,
                "AndroidAppSync" : "1"])
        }else{
            arrDic.addObject(["OrderId" : self.objOrder.ServerOrderID,
                "OrderStatus" : enumOrderStatus.hashValue,
                "AndroidAppSync" : "1",
                "GroupOrderId" : self.groupOrderID])
        }
        
        dic["Status"] = arrDic

        print(dic)
        
        WebManagerHK.postDataToURL(kModeUpdateOrderStatus, params: dic, message: "Updating order status...") { (response) in
            print("Dic Response For Order: \(response)")
            
            if response.objectForKey(kWAPIResponse) is NSArray
            {
                let mainResponse = response.objectForKey(kWAPIResponse) as! NSArray
                print(mainResponse)
            }
        }

        if isFor=="BUY" { // BUY START...
            
//            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.lblOrderStatus.text = "Order Status : \(OrderStatus.allValues[self.enumOrderStatus.hashValue])"
//            })

            
        }
        if isFor=="SIP" { // SIP START...
            
            self.lblSIPOrderStatus.text = "Order Status : \(OrderStatus.allValues[enumOrderStatus.hashValue])"

        }
        
    }
    
    func webViewDidStartLoad(webView: UIWebView)
    {
        print("Started Loading...")
//        myActivityIndicator.startAnimating()
    }
    func webViewDidFinishLoad(webView: UIWebView)
    {
//        myActivityIndicator.stopAnimating()
        print("Finished Loading...")
    }
    func webView(webView: UIWebView, didFailLoadWithError error: NSError)
    {
        print("Failed Loading...")
    }
    
    func connection(connection: NSURLConnection, canAuthenticateAgainstProtectionSpace protectionSpace: NSURLProtectionSpace) -> Bool
    {
        print("In canAuthenticateAgainstProtectionSpace");
        
        return true;
    }
    
    func connection(connection: NSURLConnection, willSendRequestForAuthenticationChallenge challenge: NSURLAuthenticationChallenge)
    {
        print("In willSendRequestForAuthenticationChallenge..");
        challenge.sender!.useCredential(NSURLCredential(forTrust: challenge.protectionSpace.serverTrust!), forAuthenticationChallenge: challenge)
        challenge.sender!.continueWithoutCredentialForAuthenticationChallenge(challenge)
        
    }


}
