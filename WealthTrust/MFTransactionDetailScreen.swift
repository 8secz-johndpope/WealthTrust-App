//
//  MFTransactionDetailScreen.swift
//  WealthTrust
//
//  Created by Hemen Gohil on 11/16/16.
//  Copyright © 2016 Hemen Gohil. All rights reserved.
//

import UIKit

class MFTransactionDetailScreen: UIViewController {

    
    
    @IBOutlet weak var lblFundName: UILabel!
    @IBOutlet weak var lblFolio: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    @IBOutlet weak var lblNav: UILabel!
    
    @IBOutlet weak var lblUnits: UILabel!
    
    @IBOutlet weak var imgTrans: UIImageView!
    
    @IBOutlet weak var lblTransName: UILabel!
    
    var objMFAccountDetail = MFAccount()
    var objMFTransactionDetail = MFTransaction()

    var isRedeem = false
    
    @IBOutlet weak var btnRemove: UIButton!
    
    var isFrom = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.lblFundName.text = self.objMFAccountDetail.SchemeName.capitalizedString

        self.lblFolio.text = "Folio - \(self.objMFAccountDetail.FolioNo)"
        if self.objMFAccountDetail.FolioNo=="" {
                self.lblFolio.hidden = true
        }

        let allUnits = (self.objMFTransactionDetail.TxnPurchaseAmount as NSString).doubleValue
        
        let num = NSNumber(double: allUnits)
        let formatr : NSNumberFormatter = NSNumberFormatter()
        formatr.numberStyle = .CurrencyStyle
        formatr.locale = NSLocale(localeIdentifier: "en_IN")
        if let stringDT = formatr.stringFromNumber(num)
        {
            self.lblPrice.text = stringDT
        }

        let un = Double(self.objMFTransactionDetail.TxnpucharseUnits)
        let Units = String(format: "%.3f", un!)
        
        let nv = Double(self.objMFTransactionDetail.TxnpuchaseNAV)
        let Nav = String(format: "%.3f", nv!)

        self.lblNav.text = Nav
        
        self.lblUnits.text = Units
        
        if isRedeem {
            lblTransName.text = "Redeem"
            self.imgTrans.image = UIImage(named : "transactRedeem")
        }else{
            lblTransName.text = "Switch-In"
            self.imgTrans.image = UIImage(named : "transactswitch_icon")

        }
        
        if isFrom=="Wealth" {
            self.btnRemove.hidden = true
        }else{
            self.btnRemove.hidden = false
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func btnBkClicked(sender: AnyObject) {
        _ = self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func btnRemoveClicked(sender: AnyObject) {
        
        print("Remove Clicked...")
        
        
        let alertDeleter = UIAlertController(title: "Delete ?", message: "Are you sure, You want to delete transaction?", preferredStyle: UIAlertControllerStyle.Alert)
        
        let btnYes = UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
            print("Yes delete")
            
            let dicToSend:NSDictionary = [
                "AccId" : self.objMFAccountDetail.AccId,
                "ClientId" : self.objMFAccountDetail.clientid,
                "TxnId" : self.objMFTransactionDetail.TxnID]
            
            WebManagerHK.postDataToURL(kModeDeleteManualMFTransaction, params: dicToSend, message: "Deleting transaction..") { (response) in
                print("Dic Response : \(response)")
                
                if response.objectForKey(kWAPIResponse) is NSDictionary
                {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        let dic = response.objectForKey(kWAPIResponse) as! NSDictionary
                        print(dic)
                        
                        //                        let isDeleted = DBManager.getInstance().deleteManualMFTransaction(self.objMFTransactionDetail)
                        //                        if isDeleted
                        //                        {
                        //                            print("Yes Deleted....")
                        //                        }
                        
                        let mfAccountAllDetails = dic
                        
                        //MF Account Details
                        let clientUserDetails = mfAccountAllDetails.valueForKey("mfaccount") as! NSDictionary
                        print(clientUserDetails)
                        
                        ////         UPDATE MFACCOUNT..
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
                        
                        
                        //                        // ADD OR UPDATE..
                        //                        if DBManager.getInstance().checkMFAccountAlreadyExist(mfInfo)
                        //                        {
                        //
                        //                            let isUpdated = DBManager.getInstance().updateMFAccount(mfInfo)
                        //                            if isUpdated {
                        //                                print("MF ACCOUNT DETAILS SYNCHED/UPDATED SUCCESSFULLY!!!!")
                        //                            } else {
                        //                                print("ERROR : MF ACCOUNT DETAILS SYNCHED ERROR!!!!")
                        //                            }
                        //
                        //                        }else{
                        //
                        //                            let isAdded = DBManager.getInstance().addMFAccount(mfInfo)
                        //                            if isAdded {
                        //                                print("MF ACCOUNT DETAILS SYNCHED/ADDED SUCCESSFULLY!!!!")
                        //                            } else {
                        //                                print("ERROR : MF ACCOUNT DETAILS SYNCHED ERROR!!!!")
                        //                            }
                        //
                        //                        }
                        
                        
                        
                        
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
                        let mfTransactions = mfAccountAllDetails.valueForKey("mftransaction") as! NSDictionary
                        print(mfTransactions)
                        
                        let clientUserDetailsTrans = mfTransactions
                        
                        ////         UPDATE MFTRANSACTIONS..
                        let mfInfo1: MFTransaction = MFTransaction()
                        
                        if let theTitle = clientUserDetailsTrans.objectForKey("TxnId") {
                            mfInfo1.TxnID = String(theTitle)
                        }
                        if let theTitle = clientUserDetailsTrans.objectForKey("AccId") {
                            mfInfo1.AccID = String(theTitle)
                        }
                        if let theTitle = clientUserDetailsTrans.objectForKey("OrderId") {
                            mfInfo1.OrderId = String(theTitle)
                        }
                        if let theTitle = clientUserDetailsTrans.objectForKey("ModifiedDateTime") {
                            mfInfo1.TxnOrderDateTime = String(theTitle)
                        }
                        if let theTitle = clientUserDetailsTrans.objectForKey("TxtType") {
                            mfInfo1.TxtType = String(theTitle)
                        }
                        if let theTitle = clientUserDetailsTrans.objectForKey("TxnpucharseUnits") {
                            mfInfo1.TxnpucharseUnits = String(theTitle)
                        }
                        if let theTitle = clientUserDetailsTrans.objectForKey("TxnpuchaseNAV") {
                            mfInfo1.TxnpuchaseNAV = String(theTitle)
                        }
                        if let theTitle = clientUserDetailsTrans.objectForKey("TxnPurchaseAmount") {
                            mfInfo1.TxnPurchaseAmount = String(theTitle)
                        }
                        if let theTitle = clientUserDetailsTrans.objectForKey("ExecutaionDateTime") {
                            mfInfo1.ExecutaionDateTime = String(theTitle)
                        }
                        if let theTitle = clientUserDetailsTrans.objectForKey("IsDeleted") {
                            mfInfo1.isDeleted = String(theTitle)
                        }
                        
                        print("dates \(mfInfo1.ExecutaionDateTime)")
                        
                        //                            // ADD OR UPDATE..
                        //                            if DBManager.getInstance().checkMFTransactionAlreadyExist(mfInfo1)
                        //                            {
                        //                                let isUpdated = DBManager.getInstance().updateMFTransaction(mfInfo1)
                        //                                if isUpdated {
                        //                                    print("MF ACCOUNT TRANSACTIONS SYNCHED/UPDATED SUCCESSFULLY!!!!")
                        //                                } else {
                        //                                    print("ERROR : MF ACCOUNT TRANSACTIONS SYNCHED ERROR!!!!")
                        //                                }
                        //
                        //                            }else{
                        //
                        //                                let isAdded = DBManager.getInstance().addMFTransaction(mfInfo1)
                        //                                if isAdded {
                        //                                    print("MF ACCOUNT TRANSACTIONS SYNCHED/ADDED SUCCESSFULLY!!!!")
                        //                                } else {
                        //                                    print("ERROR : MF ACCOUNT TRANSACTIONS SYNCHED ERROR!!!!")
                        //                                }
                        //
                        //                            }
                        //
                        
                        // ADD OR UPDATE..
                        if DBManager.getInstance().checkManualMFTransactionAlreadyExist(mfInfo1)
                        {
                            let isUpdated = DBManager.getInstance().updateManualMFTransaction(mfInfo1)
                            if isUpdated {
                                print("MF ACCOUNT TRANSACTIONS SYNCHED/UPDATED SUCCESSFULLY!!!!")
                            } else {
                                print("ERROR : MF ACCOUNT TRANSACTIONS SYNCHED ERROR!!!!")
                            }
                            
                        }else{
                            
                            let isAdded = DBManager.getInstance().addManualMFTransaction(mfInfo1)
                            if isAdded {
                                print("MF ACCOUNT TRANSACTIONS SYNCHED/ADDED SUCCESSFULLY!!!!")
                            } else {
                                print("ERROR : MF ACCOUNT TRANSACTIONS SYNCHED ERROR!!!!")
                            }
                            
                        }
                        
                        
                        _ = self.navigationController?.popViewControllerAnimated(true)
                        
                    })
                }
            }
        }
        
        let btnCancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
            print("Cancel")
        }
        
        alertDeleter.addAction(btnYes)
        alertDeleter.addAction(btnCancel)
        self.presentViewController(alertDeleter, animated: true, completion: nil)
        
        
        
    }
    
    
    
    
}
