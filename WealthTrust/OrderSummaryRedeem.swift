//
//  OrderSummaryRedeem.swift
//  WealthTrust
//
//  Created by Hemen Gohil on 11/5/16.
//  Copyright © 2016 Hemen Gohil. All rights reserved.
//

import UIKit

class OrderSummaryRedeem: UIViewController {

    @IBOutlet weak var viewOrderSummary: UIView!
    
    @IBOutlet weak var lblSwitchFrom: UILabel!
    
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblFolioNum: UILabel!
    
    @IBOutlet weak var btnBack: UIButton!
    var objOrder : Order = Order()
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnContinue: UIButton!
    
    @IBOutlet weak var lblOrderStatus: UILabel!
    @IBOutlet weak var lblOrderId: UILabel!
    
    var enumOrderStatus = OrderStatus.Processing

    override func viewDidLoad() {
        super.viewDidLoad()

        super.viewDidLoad()
        SharedManager.addShadowToView(viewOrderSummary)
        
        lblSwitchFrom.text = objOrder.SrcSchemeName
        lblFolioNum.text = "Folio Number : \(objOrder.FolioNo)"
        
        if objOrder.VolumeType=="U" { // Units
            lblAmount.text = "Units : \(objOrder.Volume)"
        }
        if objOrder.VolumeType=="A" { // Amount
            
            lblAmount.text = "Amount : ₹\(objOrder.Volume)"
            
            let num = NSNumber(double: Double(objOrder.Volume)!)
            
            let formatr : NSNumberFormatter = NSNumberFormatter()
            formatr.numberStyle = .CurrencyStyle
            formatr.locale = NSLocale(localeIdentifier: "en_IN")
            if let stringDT = formatr.stringFromNumber(num)
            {
                lblAmount.text = "Amount : \(stringDT)"
            }
            
        }
        if objOrder.VolumeType=="E" { // All Units
            lblAmount.text = "Units : All Units"
            
        }
        
        
        //self.viewOrderSummary.frame = CGRect(x: self.viewOrderSummary.frame.origin.x, y: self.viewOrderSummary.frame.origin.y, width: self.viewOrderSummary.frame.size.height, height: 150)
        self.lblOrderId.text = "";
        self.lblOrderStatus.text = "";
        self.lblOrderId.sizeToFit()
        self.lblOrderStatus.sizeToFit()
        self.lblOrderId.hidden = true
        self.lblOrderStatus.hidden = true

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func btnBackeClick(sender: AnyObject) {
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
                if viewController.isKindOfClass(UserProfile) {
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
    
    @IBAction func btnContinClicked(sender: AnyObject)
    {
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
            objOrder.RtaAmcCode = ""
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
            objOrder.DividendOption = "N" // Not Applicable...
        }
        print("DividendOption ",objOrder.DividendOption)
        
        
        if objOrder.VolumeType==nil {
            objOrder.VolumeType = "E" // All Units...
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
            objOrder.OrderType = "0" // SwitchWithOutDocs...
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
        
        let UpdateTime = sharedInstance.getFormatedDateYYYYMMDDFromCurrentDate()
        if objOrder.UpdateTime==nil {
            objOrder.UpdateTime = UpdateTime
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
        
        var investmentAOFStatusCheck = "4"
        let allUser = DBManager.getInstance().getAllUser()
        if allUser.count==0
        {
        }
        else
        {
            let objUser = allUser.objectAtIndex(0) as! User
            if objUser.InvestmentAofStatus=="3"
            {
                investmentAOFStatusCheck = "4" // Redeem without Doc
            }
            else
            {
                investmentAOFStatusCheck = "5"
            }
        }
//        InvestmentAaccountStatus
//        Pending	0
//        Processing	1
//        CanGenerated	2
//        CanVerified	3
//        Invalid	4
        print(investmentAOFStatusCheck)

        
        let dic = NSMutableDictionary()
        dic["ClientId"] = self.objOrder.ClientID
        dic["OrderType"] = investmentAOFStatusCheck
        
        let arrDic : NSMutableArray = []
        
        arrDic.addObject(["AppOrderID" : self.objOrder.AppOrderID,
            "folioAccNo" : self.objOrder.FolioNo,
            "folioCheckDigit" : self.objOrder.FolioCheckDigit,
            "rtaAmcCode" : String(self.objOrder.RtaAmcCode),
            "srcSchemeName" : self.objOrder.SrcSchemeName,
            "srcSchemeCode" : self.objOrder.SrcSchemeCode,
//            "tarSchemeName" : self.objOrder.TarSchemeName,
//            "tarSchemeCode" : self.objOrder.TarSchemeCode,
//            "dividendOption" : "\(self.objOrder.DividendOption) ",
            "txnVolumeType" : "\(self.objOrder.VolumeType)",
            "txnVolume" : self.objOrder.Volume,
            "WealtheeOrderTimeStamp" : objOrder.UpdateTime])
        
        dic["SchemeArr"] = arrDic
        
        WebManagerHK.postDataToURL(kModeOrders, params: dic, message: "Please Wait...") { (response) in
            print("Dic Response For Order: \(response)")
            
            if response.objectForKey(kWAPIResponse) is NSArray
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
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    self.lblTitle.text = "Order Status"
                    self.viewOrderSummary.frame = CGRect(x: self.viewOrderSummary.frame.origin.x, y: self.viewOrderSummary.frame.origin.y, width: self.viewOrderSummary.frame.size.height, height: 170)
                    self.lblOrderId.hidden = false
                    self.lblOrderId.text = "Order id : \(self.objOrder.ServerOrderID)"
                    self.lblOrderStatus.text = "Order Status : \(OrderStatus.allValues[self.enumOrderStatus.hashValue])"
                    self.lblOrderStatus.hidden = false
                    self.btnContinue.hidden = true
                    
                    self.btnBack.setImage(UIImage(named: "iconClose") , forState: .Normal)
                    
                    SharedManager.invokeAlertMethod("Order Received", strBody: "We have received your redemption request. The order will be processed in 24 hours.", delegate: nil)
                })
            }
        }
    }

}
