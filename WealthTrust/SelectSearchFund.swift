//
//  SelectSearchFund.swift
//  WealthTrust
//
//  Created by Hemen Gohil on 9/24/16.
//  Copyright © 2016 Hemen Gohil. All rights reserved.
//

import UIKit

class SelectSearchFund: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate {

    @IBOutlet weak var tblView: UITableView!

    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var txtSearch: UISearchBar!
    
    var selectFor = ""
    
    var arrData : NSMutableArray = []
    
    // BUY NOW DATA
    var isSIPAllowed = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tblView.backgroundColor = UIColor.defaultAppBackground

        if selectFor=="FromFund" {
            self.lblTitle.text = "Select Switch From Fund"
        }
        if selectFor=="ToFund" {
            self.lblTitle.text = "Select Switch To Fund"
        }
        if selectFor=="BuyNowScheme" {
            self.lblTitle.text = "Select Scheme"
        }
        if selectFor=="OneTimeAddPort" {
            self.lblTitle.text = "Select Scheme"
        }

        txtSearch.becomeFirstResponder()
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
    @IBAction func btnDismissClicked(sender: AnyObject) {
        txtSearch.resignFirstResponder()
        
        self.dismissViewControllerAnimated(true) { 
            
        }
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
            var numOfSections: Int = 0
            if (self.arrData.count > 0)
            {
                numOfSections = 1
                tableView.backgroundView = nil
            }
            else
            {
                let lblNotFound = UILabel(frame: CGRect(x: 15 , y: 160, width: (self.view.frame.size.width)-30, height: 50))
                lblNotFound.text = "No Records Found"
                lblNotFound.textColor =  UIColor.blackColor()
                lblNotFound.textAlignment = .Center
                tableView.backgroundView = lblNotFound
                tableView.separatorStyle = .None
            }
            return numOfSections
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let planName = self.arrData.objectAtIndex(indexPath.row).valueForKey("Plan_Name") as! String

        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "CELL_Search_Fund\(planName)_\(self.selectFor)")
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CELL_Search_Fund\(planName)_\(self.selectFor)", forIndexPath: indexPath) as UITableViewCell
        
        let lblSwitchFromFund = UILabel(frame: CGRect(x: 15, y: 5, width: (cell.contentView.frame.size.width)-30, height: 50));

        lblSwitchFromFund.text = planName
        lblSwitchFromFund.textColor = UIColor.blackColor()
        lblSwitchFromFund.font = UIFont.systemFontOfSize(15)
        lblSwitchFromFund.numberOfLines = 2
        lblSwitchFromFund.backgroundColor = UIColor.clearColor()
        cell.contentView.addSubview(lblSwitchFromFund)
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.contentView.backgroundColor = UIColor.clearColor()
        cell.backgroundColor = UIColor.clearColor()
        
        return cell;

    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        txtSearch.resignFirstResponder()

        if selectFor=="FromFund" {
            sharedInstance.userDefaults.setObject(self.arrData.objectAtIndex(indexPath.row), forKey: kSelectFromFundValue)
        }
        if selectFor=="ToFund" {
            sharedInstance.userDefaults.setObject(self.arrData.objectAtIndex(indexPath.row), forKey: kSelectToFundValue)
        }
        if selectFor=="BuyNowScheme" {
            sharedInstance.userDefaults.setObject(self.arrData.objectAtIndex(indexPath.row), forKey: kSelectBuyNowScheme)
        }
        if selectFor=="OneTimeAddPort" {
            sharedInstance.userDefaults.setObject(self.arrData.objectAtIndex(indexPath.row), forKey: kSelectAddExistingScheme)
        }

        self.dismissViewControllerAnimated(true) {
            
        }

    }

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
//        let viewWithTag = self.view.viewWithTag(101)
//        viewWithTag?.removeFromSuperview()
        
        print("searchText \(searchText)")
        
        [NSObject .cancelPreviousPerformRequestsWithTarget(self, selector: #selector(SelectSearchFund.getHintsFromTextField), object: searchBar)]

        
//        NSObject.cancelPreviousPerformRequests(
//            withTarget: self,
//            selector: #selector(SelectSearchFund.getHintsFromTextField),
//            object: searchBar)
        
        self.performSelector(
            #selector(SelectSearchFund.getHintsFromTextField),
            withObject: searchBar,
            afterDelay: 0.5)

        
        
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        print("searchText \(searchBar.text)")
//        searchBar.resignFirstResponder()
        
    }
    
    func getHintsFromTextField(searchText: UISearchBar) {
        print("Hints for textField: \(searchText.text)")
        
        if searchText.text!.length>=3 {
            
            arrData.removeAllObjects()
            
            if self.selectFor=="FromFund" {

                let dicToSend:NSDictionary = [
                    "Plan_Name" : searchText.text!,
                    "Switch_Out_Allowed" : "Y"]
                
//                let lblNotFound = UILabel(frame: CGRect(x: 15 , y: 160, width: (self.view.frame.size.width)-30, height: 50))
                
                
//                searchText.resignFirstResponder()
                
                WebManagerHK.postDataToURL(kModeSearchSchemeNameByText, params: dicToSend, message: "Searching...") { (response) in
                    
                    if response.objectForKey(kWAPIResponse) is NSArray
                    {
                        
                        let mainResponse = response.objectForKey(kWAPIResponse) as! NSArray
                        print(mainResponse)
                        
                        self.arrData = mainResponse.mutableCopy() as! NSMutableArray
                        
                        if self.arrData.count == 0
                        {
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                
                                self.tblView.reloadData()
                                
//                                lblNotFound.text = "No Records Found"
//                                lblNotFound.textAlignment = .Center
//                                lblNotFound.tag = 101
//                                self.view.addSubview(lblNotFound)
                            })
                        }
                        else
                        {
                        
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                
//                                let viewWithTag = self.view.viewWithTag(101)
//                                viewWithTag?.removeFromSuperview()
                                
                                self.tblView.reloadData()
    //                            self.txtSearch.becomeFirstResponder()

                            })
                        }
                        
                    }else
                    {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.tblView.reloadData()
//                            self.txtSearch.becomeFirstResponder()

                        })
                        
                    }
                }

            }
            
            if self.selectFor=="ToFund" {
                
                var funCode = ""
                if let fromFundGet = sharedInstance.userDefaults.objectForKey(kSelectFromFundValue) as? NSDictionary
                {
                    print(fromFundGet)
                    funCode = fromFundGet.valueForKey("Fund_Code") as! String
                }
                
                let dicToSend:NSDictionary = [
                    "Plan_Name" : searchText.text!,
                    "Fund_Code" : funCode,
                    "Switch_In_Allowed" : "Y",
                    "Plan_Type":"Dir"]
                
//                let lblNotFound = UILabel(frame: CGRect(x: 15 , y: 160, width: (self.view.frame.size.width)-30, height: 50))
                
//                searchText.resignFirstResponder()

                WebManagerHK.postDataToURL(kModeSearchSchemeNameByText, params: dicToSend, message: "Searching...") { (response) in
                    
                    if response.objectForKey(kWAPIResponse) is NSArray
                    {
                        let mainResponse = response.objectForKey(kWAPIResponse) as! NSArray
                        
                        self.arrData = mainResponse.mutableCopy() as! NSMutableArray
//                        print("Fetched Data : \(self.arrData)")
                        
                        if self.arrData.count == 0
                        {
                        
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                
                                self.tblView.reloadData()
                                
//                                lblNotFound.text = "No Records Found"
//                                lblNotFound.textAlignment = .Center
//                                lblNotFound.tag = 101
//                                self.view.addSubview(lblNotFound)
                            })
                        }
                        else
                        {
                            dispatch_async(dispatch_get_main_queue(), {() -> Void in
                                
//                                let viewWithTag = self.view.viewWithTag(101)
//                                viewWithTag?.removeFromSuperview()
                                
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
            
            
            if self.selectFor=="BuyNowScheme" {
                
//                var funCode = ""
//                if let fromFundGet = sharedInstance.userDefaults.objectForKey(kSelectBuyNowScheme) as? NSDictionary
//                {
//                    print(fromFundGet)
//                    funCode = fromFundGet.valueForKey("Fund_Code") as! String
//                }
                
                var keyisISPAllowed = "SIP_Allowed"
                
                if isSIPAllowed=="Y" {
                    keyisISPAllowed = "SIP_Allowed"
                }else{
                    keyisISPAllowed = "Pur_Allowed"
                }
                
                let dicToSend:NSDictionary = [
                    "Plan_Name" : searchText.text!,
                    "Plan_Type" : "Dir",
//                    "Fund_Code":fundCode,
//                    "Fund_type":fundType,
                    keyisISPAllowed:"Y"]
                
//                 let lblNotFound = UILabel(frame: CGRect(x: 15 , y: 160, width: (self.view.frame.size.width)-30, height: 50))
                
//                searchText.resignFirstResponder()

                WebManagerHK.postDataToURL(kModeSearchSchemeNameByText, params: dicToSend, message: "Searching...") { (response) in
                    print("Dic Response : \(response)")
                    
                    if response.objectForKey(kWAPIResponse) is NSArray
                    {
                        let mainResponse = response.objectForKey(kWAPIResponse) as! NSArray
                        
                        self.arrData = mainResponse.mutableCopy() as! NSMutableArray
//                        print("Fetched Data : \(self.arrData)")
                        
                        if self.arrData.count == 0
                        {
                            
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                
                                self.tblView.reloadData()
                                
//                                lblNotFound.text = "No Records Found"
//                                lblNotFound.textAlignment = .Center
//                                lblNotFound.tag = 101
//                                self.view.addSubview(lblNotFound)
                            })
                        }
                        else
                        {
                            dispatch_async(dispatch_get_main_queue(), {() -> Void in

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
            

            
            if self.selectFor=="OneTimeAddPort" {

//                var keyisISPAllowed = "SIP_Allowed"
                
//                    if isSIPAllowed=="Y" {
//                        keyisISPAllowed = "SIP_Allowed"
//                    }else{
//                        keyisISPAllowed = "Pur_Allowed"
//                    }
                
//                    let dicToSend:NSDictionary = [
//                        "Plan_Name" : searchText.text!,
//                        "Plan_Type" : "Dir",
//                        "Fund_Code":fundCode,
//                        "Fund_type":fundType,
//                        keyisISPAllowed:"Y"]
                
//                let lblNotFound = UILabel(frame: CGRect(x: 15 , y: 160, width: (self.view.frame.size.width)-30, height: 50))
                
                let dicToSend:NSDictionary = [
                    "Plan_Name" : searchText.text!]

//                    searchText.resignFirstResponder()
                
                    WebManagerHK.postDataToURL(kModeSearchSchemeNameByText, params: dicToSend, message: "Searching...") { (response) in
                        print("Dic Response : \(response)")
                        
                        if response.objectForKey(kWAPIResponse) is NSArray
                        {
                            let mainResponse = response.objectForKey(kWAPIResponse) as! NSArray
                            
                            self.arrData = mainResponse.mutableCopy() as! NSMutableArray
                            //                        print("Fetched Data : \(self.arrData)")
                            
                            if self.arrData.count == 0
                            {
                                
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    
                                    self.tblView.reloadData()
                                    
//                                    lblNotFound.text = "No Records Found"
//                                    lblNotFound.textAlignment = .Center
//                                    lblNotFound.tag = 101
//                                    self.view.addSubview(lblNotFound)
                                })
                            }
                            else
                            {
                                dispatch_async(dispatch_get_main_queue(), {() -> Void in
                                    
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
        else
        {
            if searchText.text!.length <= 0 {
                arrData.removeAllObjects()
                self.tblView.reloadData()
            }
        }
        
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {

        print("Scrolling..")
        self.txtSearch.resignFirstResponder()
    }

    

}
