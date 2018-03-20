//
//  ViewController.swift
//  SearchDemo
//
//  Created by Chirag_i-Phone13 on 08/12/16.
//  Copyright © 2016 The Infinity. All rights reserved.
//

import UIKit


class SearchScreen: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate{
    
    //    @IBOutlet var txtSearch: UISearchBar!
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    let txtSearch = UITextField()
    let vTestView = UIView()
    var arrViewAllData = NSMutableArray()
    var arrSearchValue = NSMutableArray()
    var isSearched = Bool()
    var isNoValueFound = Bool()
    var isServiceCall = Bool()
    let objDefault=NSUserDefaults.standardUserDefaults()
    var arrHorizon = NSMutableArray()
    var arrPlanOpt = NSMutableArray()
    var arrFundType = NSMutableArray()
    var arrFundName = NSMutableArray()
    var arrRisk = NSMutableArray()
    var indicator = UIActivityIndicatorView()
    var dicSearchParam = NSMutableDictionary()
    @IBOutlet weak var lblFilterOption: UILabel!
    @IBOutlet weak var lblSortOption: UILabel!
    
    @IBOutlet weak var viewBaseline: NSLayoutConstraint!
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet var viewFooter: UIView!
    @IBOutlet var btnFilter: UIButton!
    var timer : NSTimer!
    override func viewDidLoad() {
        
        if objDefault.valueForKey("sortBy") != nil {
            lblSortOption.text = objDefault.valueForKey("sortBy") as? String
        }
        else
        {
            lblSortOption.text = "3Yr Return"
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SearchScreen.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SearchScreen.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        txtSearch.becomeFirstResponder()
        isServiceCall = false
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        vTestView.removeFromSuperview()
        viewBaseline.constant = 0
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        self .UISetup()
        
        if objDefault.valueForKey("Horizon") != nil {
            arrHorizon=objDefault .valueForKey("Horizon")?.mutableCopy() as! NSMutableArray
            arrFundName=objDefault .valueForKey("Fund_Name")?.mutableCopy() as! NSMutableArray
            arrPlanOpt=objDefault .valueForKey("Plan_Opt")?.mutableCopy() as! NSMutableArray
            arrRisk=objDefault .valueForKey("Risk")?.mutableCopy() as! NSMutableArray
            arrFundType=objDefault .valueForKey("Fund_type")?.mutableCopy() as! NSMutableArray
            var str = NSString()
            
            if arrHorizon.count>0 {
                var arrTemp = NSMutableArray()
                arrTemp = self.CheckFilterArray(arrHorizon)
                if arrTemp.count>0 {
                    str = "Horizon"
                }
            }
            if arrFundName.count>0 {
                var arrTemp = NSMutableArray()
                arrTemp = self.CheckFilterArray(arrFundName)
                if arrTemp.count>0 {
                    if str .isEqualToString("") {
                        str = str.stringByAppendingString("Fund House")
                    }
                    else{
                        str = str.stringByAppendingString(", Fund House")
                    }
                }
            }
            if arrPlanOpt.count>0 {
                var arrTemp = NSMutableArray()
                arrTemp = self.CheckFilterArray(arrPlanOpt)
                if arrTemp.count>0 {
                    if str .isEqualToString("") {
                        str = str.stringByAppendingString("Option")
                    }
                    else{
                        str = str.stringByAppendingString(", Option")
                    }
                }
            }
            if arrRisk.count>0 {
                var arrTemp = NSMutableArray()
                arrTemp = self.CheckFilterArray(arrRisk)
                if arrTemp.count>0 {
                    if str .isEqualToString("") {
                        str = str.stringByAppendingString("Risk")
                    }
                    else{
                        str = str.stringByAppendingString(", Risk")
                    }
                }
            }
            if arrFundType.count>0 {
                var arrTemp = NSMutableArray()
                arrTemp = self.CheckFilterArray(arrFundType)
                if arrTemp.count>0 {
                    if str .isEqualToString("") {
                        str = str.stringByAppendingString("Category")
                    }
                    else{
                        str = str.stringByAppendingString(", Category")
                    }
                }
            }
            
            if str .isEqualToString(""){
                str = "None Selected"
            }
            lblFilterOption.text = str as String
        }
            
        else{
            lblFilterOption.text = "Option"
        }
        
        if sharedInstance.kIsFilter == true {
            if isServiceCall {
                
                if sharedInstance.isViewAllCalled==true {
                    sharedInstance.isSearchText = false
                    self.ServiceCall(NSNull)
                }
                else if sharedInstance.isSearchedSeeMore==true{
                    sharedInstance.isSearchText = true
                    self.ServiceCall(NSNull)
                }
                else if sharedInstance.isSearchText==true{
                    self.SearchValueChange(txtSearch)
                }
            }
        }
        print(isSearched)
        isSearched = false
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SearchScreen.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SearchScreen.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - custom Button Events
    
    @IBAction func btnFilterTap(sender: AnyObject) {
        self.navigationController!.pushViewController(self.storyboard!.instantiateViewControllerWithIdentifier("FilterScreen") as UIViewController, animated: true)
    }
    func btnBackTap( sender:AnyObject) {
        self.ClearAllFilter()
        if let navController = self.navigationController {
            navController.popViewControllerAnimated(true)
        }
        print(sender)
    }
    
    @IBAction func btnSortTap(sender: AnyObject) {
        
        let alertController = UIAlertController(title: "Sort By", message: "", preferredStyle: .Alert)
        let oneYearAction = UIAlertAction(title: "1Yr Return", style: .Default) { (action:UIAlertAction!) in
            self.objDefault.setValue("1Yr Return", forKey: "sortBy")
            self.lblSortOption.text = "1Yr Return"
            let sortByName = NSSortDescriptor(key: "oneyearreturn", ascending: false)
            let sortDescriptors = [sortByName]
            let sortedArray = (self.arrViewAllData as NSMutableArray).sortedArrayUsingDescriptors(sortDescriptors) as NSArray
            self.arrViewAllData = sortedArray .mutableCopy() as! NSMutableArray
            self.tblView.reloadData()
        }
        
        alertController.addAction(oneYearAction)
        
        let twoYearAction = UIAlertAction(title: "3Yr Return", style: .Default) { (action:UIAlertAction!) in
            print("3Yr Return")
            self.objDefault.setValue("3Yr Return", forKey: "sortBy")
            self.lblSortOption.text = "3Yr Return"
            let sortByName = NSSortDescriptor(key: "threeyearreturn", ascending: false)
            let sortDescriptors = [sortByName]
            let sortedArray = (self.arrViewAllData as NSMutableArray).sortedArrayUsingDescriptors(sortDescriptors) as NSArray
            self.arrViewAllData = sortedArray .mutableCopy() as! NSMutableArray
            self.tblView.reloadData()
            
        }
        
        alertController.addAction(twoYearAction)
        
        let threeYearAction = UIAlertAction(title: "5Yr Return", style: .Default) { (action:UIAlertAction!) in
            print("5Yr Return")
            self.lblSortOption.text = "5Yr Return"
            self.objDefault.setValue("5Yr Return", forKey: "sortBy")
            
            let sortByName = NSSortDescriptor(key: "fiveyearreturn", ascending: false)
            let sortDescriptors = [sortByName]
            let sortedArray = (self.arrViewAllData as NSMutableArray).sortedArrayUsingDescriptors(sortDescriptors) as NSArray
            self.arrViewAllData = sortedArray .mutableCopy() as! NSMutableArray
            self.tblView.reloadData()
            
        }
        
        alertController.addAction(threeYearAction)
        
        
        self.presentViewController(alertController, animated: true, completion:nil)
    }
    
    @IBAction func btnViewAllTap(sender: AnyObject){
        arrViewAllData.removeAllObjects()
        self.arrSearchValue.removeAllObjects()
        self.txtSearch.endEditing(true)
        sharedInstance.isViewAllCalled = true
        self.isSearched = false
        sharedInstance.isSearchText = false
        self .ServiceCall(NSNull)
        
    }
    func btnSeeMoreTap(sender: AnyObject){
        self.txtSearch.endEditing(true)
        self.isSearched = false
        sharedInstance.isSearchText = true
        arrSearchValue.removeAllObjects()
        arrViewAllData.removeAllObjects()
        tblView.reloadData()
        self .ServiceCall(NSNull)
    }
    
    
    // MARK: - TableView Delegate & DataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearched == true {
            return self.arrSearchValue.count
        }
        else
        {
            return self.arrViewAllData.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        var stringIdentifier = "ALL_SELECTED_DATA_\(indexPath.row)_\(indexPath.section)"
        var dicToUse = NSDictionary()
        if isSearched == true {
            if self.arrSearchValue.count>0 {
                dicToUse = self.arrSearchValue.objectAtIndex(indexPath.row) as! NSDictionary
            }
            
        }
        else{
            if self.arrViewAllData.count>0 {
                dicToUse = self.arrViewAllData.objectAtIndex(indexPath.row) as! NSDictionary
            }
        }
        
        if let name = dicToUse.valueForKey("Plan_Name") {
            stringIdentifier = stringIdentifier + (name as! String)
        }else{
            stringIdentifier = stringIdentifier + "SCHEME"
        }
        
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: stringIdentifier)
        
        let cell = tableView.dequeueReusableCellWithIdentifier(stringIdentifier, forIndexPath: indexPath) as UITableViewCell
        
        if (cell.contentView.subviews.count==0) {
            
            
            if isSearched == true {
                
                let viewSquare = UIView(frame: CGRect(x: 10, y: 1, width: (cell.contentView.frame.size.width)-20, height: 50))
                viewSquare.backgroundColor = UIColor.clearColor()
                cell.contentView.addSubview(viewSquare)
                
                // TO BUY UI..... BUY START
                var lblFundName : UILabel!
                lblFundName = UILabel(frame: CGRect(x: 10, y: 5, width: viewSquare.frame.size.width-20, height: 40));
                
                if let name = dicToUse.valueForKey("Plan_Name") {
                    lblFundName.text = name.capitalizedString
                }else{
                    lblFundName.text = "Scheme Name - N/A"
                }
                lblFundName.font = UIFont.systemFontOfSize(15)
                lblFundName.textColor = UIColor.blackColor().colorWithAlphaComponent(0.87)
                lblFundName.textAlignment = .Left
                lblFundName.numberOfLines = 0
                viewSquare.addSubview(lblFundName)
                
                let lblLine = UILabel(frame: CGRect(x: 15, y: cell.contentView.frame.size.height-1 , width: (cell.contentView.frame.size.width)-10, height: 1))
                lblLine.backgroundColor = UIColor.lightGrayColor()
                cell.contentView.addSubview(lblLine)
            }
            else{
                
                let viewSquare = UIView(frame: CGRect(x: 10, y: 1, width: (cell.contentView.frame.size.width)-20, height: 96))
                viewSquare.backgroundColor = UIColor.clearColor()
                cell.contentView.addSubview(viewSquare)
                
                // TO BUY UI..... BUY START
                var lblFundName : UILabel!
                lblFundName = UILabel(frame: CGRect(x: 10, y: 5, width: viewSquare.frame.size.width-20, height: 40));
                
                if let name = dicToUse.valueForKey("Plan_Name") {
                    lblFundName.text = name.capitalizedString
                }else{
                    lblFundName.text = "Scheme Name - N/A"
                }
                lblFundName.font = UIFont.systemFontOfSize(15)
                lblFundName.textColor = UIColor.blackColor().colorWithAlphaComponent(0.87)
                lblFundName.textAlignment = .Left
                lblFundName.numberOfLines = 0
                viewSquare.addSubview(lblFundName)
                
                
                var lblGR : UILabel!
                lblGR = UILabel(frame: CGRect(x: 10, y: 50, width: 100, height: 20));
                lblGR.text = ""
                if let plnType = dicToUse.valueForKey("Plan_Type") {
                    
                    if let plnOpt = dicToUse.valueForKey("Plan_Opt") {
                        lblGR.text = "\(plnType.uppercaseString)-\(plnOpt.uppercaseString)"
                    }else{
                        lblGR.text = (plnType as? String)?.uppercaseString
                    }
                }else{
                    lblGR.text = "NA"
                }
                lblGR.font = UIFont.systemFontOfSize(13)
                lblGR.textColor = UIColor.blackColor().colorWithAlphaComponent(0.54)
                lblGR.textAlignment = .Left
                viewSquare.addSubview(lblGR)
                
                
                var lblNAV : UILabel!
                lblNAV = UILabel(frame: CGRect(x: 10, y: 70, width: 100, height: 20));
                if let name = dicToUse.valueForKey("NAV") {
                    let Nav = String(format: "%.3f", name as! Double)
                    lblNAV.text = "NAV : \(Nav)"
                }else{
                    lblNAV.text = "NAV : -"
                }
                
                lblNAV.font = UIFont.systemFontOfSize(13)
                lblNAV.textColor = UIColor.blackColor().colorWithAlphaComponent(0.54)
                lblNAV.textAlignment = .Left
                viewSquare.addSubview(lblNAV)
                
                
                
                var lbl5Y : UILabel!
                lbl5Y = UILabel(frame: CGRect(x: viewSquare.frame.size.width-110, y: 50, width: 40, height: 20));
                lbl5Y.font = UIFont.systemFontOfSize(13)
                lbl5Y.textColor = UIColor.blackColor().colorWithAlphaComponent(0.54)
                lbl5Y.textAlignment = .Center
                lbl5Y.text = "5Y"
                viewSquare.addSubview(lbl5Y)
                
                var lbl5YValue : UILabel!
                lbl5YValue = UILabel(frame: CGRect(x: viewSquare.frame.size.width-110, y: 70, width: 40, height: 20));
                lbl5YValue.font = UIFont.systemFontOfSize(13)
                lbl5YValue.textColor = UIColor.blackColor().colorWithAlphaComponent(0.87)
                lbl5YValue.textAlignment = .Center
                if let name = dicToUse.valueForKey("fiveyearreturn") {
                    if name is NSNull {
                        lbl5YValue.text = "NA"
                    }else{
                        let Nav = String(format: "%.1f", name as! Double)
                        lbl5YValue.text = "\(Nav)%"
                    }
                }else{
                    lbl5YValue.text = "NA"
                }
                
                viewSquare.addSubview(lbl5YValue)
                
                
                var lbl3Y : UILabel!
                lbl3Y = UILabel(frame: CGRect(x: viewSquare.frame.size.width-150, y: 50, width: 40, height: 20));
                lbl3Y.font = UIFont.systemFontOfSize(13)
                lbl3Y.textColor = UIColor.blackColor().colorWithAlphaComponent(0.54)
                lbl3Y.textAlignment = .Center
                lbl3Y.text = "3Y"
                viewSquare.addSubview(lbl3Y)
                
                var lbl3YValue : UILabel!
                lbl3YValue = UILabel(frame: CGRect(x: viewSquare.frame.size.width-150, y: 70, width: 40, height: 20));
                lbl3YValue.font = UIFont.systemFontOfSize(13)
                lbl3YValue.textColor = UIColor.blackColor().colorWithAlphaComponent(0.87)
                lbl3YValue.textAlignment = .Center
                if let name = dicToUse.valueForKey("threeyearreturn") {
                    if name is NSNull {
                        lbl3YValue.text = "NA"
                    }else{
                        let Nav = String(format: "%.1f", name as! Double)
                        lbl3YValue.text = "\(Nav)%"
                    }
                }else{
                    lbl3YValue.text = "NA"
                }
                viewSquare.addSubview(lbl3YValue)
                
                var lbl1Y : UILabel!
                lbl1Y = UILabel(frame: CGRect(x: viewSquare.frame.size.width-190, y: 50, width: 40, height: 20));
                lbl1Y.font = UIFont.systemFontOfSize(13)
                lbl1Y.textColor = UIColor.blackColor().colorWithAlphaComponent(0.54)
                lbl1Y.textAlignment = .Center
                lbl1Y.text = "1Y"
                viewSquare.addSubview(lbl1Y)
                
                var lbl1YValue : UILabel!
                lbl1YValue = UILabel(frame: CGRect(x: viewSquare.frame.size.width-190, y: 70, width: 40, height: 20));
                lbl1YValue.font = UIFont.systemFontOfSize(13)
                lbl1YValue.textColor = UIColor.blackColor().colorWithAlphaComponent(0.87)
                lbl1YValue.textAlignment = .Center
                if let name = dicToUse.valueForKey("oneyearreturn") {
                    if name is NSNull {
                        lbl1YValue.text = "NA"
                    }else{
                        let Nav = String(format: "%.1f", name as! Double)
                        lbl1YValue.text = "\(Nav)%"
                    }
                }else{
                    lbl1YValue.text = "NA"
                }
                viewSquare.addSubview(lbl1YValue)
                
                
                
                let btnSubmit = UIButton(frame: CGRect(x: viewSquare.frame.size.width-67, y: 53, width: 66, height: 36))
                btnSubmit.setTitle("BUY/SIP", forState: .Normal)
                
                if let name = dicToUse.valueForKey("Plan_Type")
                {
                    if name as! String == "DIR"
                    {
                        btnSubmit.setTitle("BUY/SIP", forState: .Normal)
                        
                    }else{
                        btnSubmit.setTitle("SWITCH", forState: .Normal)
                    }
                }
                
                
                
                btnSubmit.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                btnSubmit.backgroundColor = UIColor.defaultOrangeButton
                btnSubmit.titleLabel?.font = UIFont.systemFontOfSize(14)
                btnSubmit.layer.cornerRadius = 1.5
                btnSubmit.addTarget(self, action: #selector(TopFundsScreen.btnBuySIPClicked(_:)), forControlEvents: .TouchUpInside)
                viewSquare.addSubview(btnSubmit)
                btnSubmit.tag = indexPath.row
                
                let lblLine = UILabel(frame: CGRect(x: 15, y: cell.contentView.frame.size.height-1 , width: (cell.contentView.frame.size.width)-10, height: 1))
                lblLine.backgroundColor = UIColor.lightGrayColor()
                cell.contentView.addSubview(lblLine)
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.contentView.backgroundColor = UIColor.clearColor()
            cell.backgroundColor = UIColor.clearColor()
            return cell
            
        }
        
        
        let stringIdentifierq = "CELL_BLANK"
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: stringIdentifierq)
        let cell1 = tableView.dequeueReusableCellWithIdentifier(stringIdentifierq, forIndexPath: indexPath) as UITableViewCell
        cell1.selectionStyle = UITableViewCellSelectionStyle.None
        cell1.contentView.backgroundColor = UIColor.clearColor()
        cell1.backgroundColor = UIColor.clearColor()
        
        return cell;
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var schemeCode = NSString()
        var fundCode = NSString()
        
        if isSearched == true {
            
            schemeCode = arrSearchValue.objectAtIndex(indexPath.row).valueForKey("Scheme_Code") as! String
            fundCode = arrSearchValue.objectAtIndex(indexPath.row).valueForKey("Fund_Code") as! String
            
            
            print(self.arrSearchValue.objectAtIndex(indexPath.row))
            
            let details = self.arrSearchValue.objectAtIndex(indexPath.row) as! NSDictionary
            
            let jo = NSMutableDictionary()
            jo.setValue(details.valueForKey("Fund_Code"), forKey: "Fund_Code")
            jo.setValue(details.valueForKey("NAV"), forKey: "NAV")
            jo.setValue(details.valueForKey("NAVDate"), forKey: "NAVDate")
            
            jo.setValue(details.valueForKey("Plan_Name"), forKey: "Plan_Name")
            jo.setValue(details.valueForKey("Plan_Opt"), forKey: "Div_Opt")
            jo.setValue(details.valueForKey("Scheme_Code"), forKey: "Scheme_Code")
            print(jo)
            sharedInstance.userDefaults.setObject(jo, forKey: kSelectBuyNowScheme)

            
        }
        else{
            schemeCode = (arrViewAllData.objectAtIndex(indexPath.row).valueForKey("Scheme_Code")as? String)!
            fundCode = (arrViewAllData.objectAtIndex(indexPath.row).valueForKey("Fund_Code") as? String)!
            
            let details = arrViewAllData.objectAtIndex(indexPath.row) as! NSDictionary
            
            let jo = NSMutableDictionary()
            jo.setValue(details.valueForKey("Fund_Code"), forKey: "Fund_Code")
            jo.setValue(details.valueForKey("NAV"), forKey: "NAV")
            jo.setValue(details.valueForKey("NAVDate"), forKey: "NAVDate")
            
            jo.setValue(details.valueForKey("Plan_Name"), forKey: "Plan_Name")
            jo.setValue(details.valueForKey("Plan_Opt"), forKey: "Div_Opt")
            jo.setValue(details.valueForKey("Scheme_Code"), forKey: "Scheme_Code")
            print(jo)
            sharedInstance.userDefaults.setObject(jo, forKey: kSelectBuyNowScheme)

            
        }
        
        let objSchemDetails = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdSchemeDetailsScreen) as! SchemeDetailsScreen
        objSchemDetails.schemeCode = schemeCode as String
        objSchemDetails.fundCode = fundCode as String
        self.navigationController?.pushViewController(objSchemDetails, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if isSearched == true {
            return 50;
        }
        else
        {
            return 100
        }
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if isSearched == true {
            return 40
        }
        else
        {
            return 0.5
        }
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        if self.arrSearchValue.count>0 && isSearched == true {
            let footerView = UIView()
            footerView.frame = CGRect(x: 0, y: 0 , width:tblView.frame.width , height:60)
            let btnSeeMore = UIButton()
            btnSeeMore.frame = CGRect(x: 20, y: 0 , width: footerView.frame.width-20, height:40)
            btnSeeMore.setTitle("See More Options", forState: UIControlState.Normal)
            btnSeeMore.setTitleColor(UIColor.defaultAppColorBlue, forState: UIControlState.Normal)
            btnSeeMore.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left;
            btnSeeMore.addTarget(self, action: #selector(SearchScreen.btnSeeMoreTap(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            btnSeeMore.titleLabel!.font =  UIFont.systemFontOfSize(13)
            footerView .addSubview(btnSeeMore)
            btnSeeMore.enabled = true
            return footerView
        }
        else if self.arrSearchValue.count<1 && isSearched == true && isNoValueFound == true{
            let footerView = UIView()
            let lblNote = UILabel()
            footerView.frame = CGRect(x: 0, y: 0 , width:tblView.frame.width , height:40)
            lblNote.frame = CGRect(x: 10, y: 5 , width: footerView.frame.width-20, height:40)
            
            lblNote.text = "No Records Found"
            lblNote.textColor = UIColor.blackColor()
            footerView .addSubview(lblNote)
            return footerView
        }
        return nil
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    
    // MARK: - TextField Events
    
    func SearchValueChange(text:UITextField) {
        isNoValueFound = false
        self.arrSearchValue.removeAllObjects()
        if text.text?.length>=3{
            
            self.isSearched = true
            sharedInstance.isSearchText=true
            
            self.tblView.reloadData()
            
            dicSearchParam .setValue(text.text, forKey: "search_text")
            sharedInstance.isSearchedTextCall = true
            sharedInstance.isViewAllCalled = false
            sharedInstance.isSearchedSeeMore = false
            
            if arrHorizon.count>0 {
                var arrTemp = NSMutableArray()
                arrTemp = self.CheckFilterArray(arrHorizon)
                if arrTemp.count>0 {
                    dicSearchParam.setValue(arrTemp, forKey: "Horizon")
                }
            }
            
            if arrFundName.count>0 {
                var arrTemp = NSMutableArray()
                arrTemp = self.CheckFilterArray(arrFundName)
                if arrTemp.count>0 {
                    dicSearchParam.setValue(arrTemp, forKey: "Fund_Name")
                }
            }
            
            if arrPlanOpt.count>0 {
                var arrTemp = NSMutableArray()
                arrTemp = self.CheckFilterArray(arrPlanOpt)
                if arrTemp.count>0 {
                    dicSearchParam.setValue(arrTemp, forKey: "Plan_Opt")
                }
            }
            
            if arrPlanOpt.count<1{
              arrPlanOpt = self.methodForOptionArray(NSNull)
            }
            
            if arrRisk.count>0 {
                var arrTemp = NSMutableArray()
                arrTemp = self.CheckFilterArray(arrRisk)
                if arrTemp.count>0 {
                    dicSearchParam.setValue(arrTemp, forKey: "Risk")
                }
            }
            
            if arrFundType.count>0 {
                var arrTemp = NSMutableArray()
                arrTemp = self.CheckFilterArray(arrFundType)
                if arrTemp.count>0 {
                    dicSearchParam.setValue(arrTemp, forKey: "Fund_type")
                }
            }
            
            txtSearch.clearButtonMode = .Never
            indicator.startAnimating()
            
            
            if timer != nil {
            timer.invalidate()
            }
            timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: false)

           

        }
        else
        {
            self.arrSearchValue.removeAllObjects()
            print(self.arrSearchValue)
            dispatch_async(dispatch_get_main_queue(),{
                self.tblView.reloadData()
            })
            self.isSearched = false
        }
    }
    func methodForOptionArray(val:AnyObject)-> NSMutableArray {
        let arrValues=NSMutableArray()
        
        for index in 0..<3
        {
            let dicTemp=NSMutableDictionary()
            var str = NSString()
            if index==0 {
                str = "BO"
            }
            else if index==1{
                str = "GR"
            }
            else if index==2{
                str = "DIV"
            }
            dicTemp .setValue(str, forKey: "value")
            dicTemp .setValue(index , forKey: "index")
            if index == 1{
                dicTemp .setValue(1, forKey: "isSelected")
            }
            else{
                dicTemp .setValue(0, forKey: "isSelected")
            }
            arrValues .addObject(dicTemp)
            
        }
        
        
        return arrValues
    }
    
    func update()  {
        
        WebManagerHK .postDataToURL(kModeSearchTopSchemeNameByText, params: dicSearchParam, message: "") { (responce) in
            self.isNoValueFound = true
            self.arrSearchValue.removeAllObjects()
            self.arrSearchValue = (responce.valueForKey("WAPIResponse")?.mutableCopy())! as! NSMutableArray
            self.isSearched = true
            print(self.arrSearchValue)
            self.isServiceCall = true
            
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue()) {
                let text = self.dicSearchParam.valueForKey("search_text")
                if text!.length>=3{
                    self.tblView.reloadData()
                    self.txtSearch.clearButtonMode = .WhileEditing
                }
                self.indicator.stopAnimating()
            }
            
            dispatch_async(dispatch_get_main_queue(),{
                
            })
        }

    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        txtSearch.resignFirstResponder()
        return true
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            
            viewBaseline.constant = keyboardSize.height
            print(self.tblView.frame.size.height)
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        viewBaseline.constant = 0
    }
    
    // MARK : - ServiceCall
    
    func ServiceCall(dic:AnyObject) {
        
        let dicToSend = NSMutableDictionary()
        self.isServiceCall = false
        if sharedInstance.isSearchText {
            
            sharedInstance.isSearchedTextCall = false
            sharedInstance.isViewAllCalled = false
            sharedInstance.isSearchedSeeMore = true
            dicToSend .setValue(txtSearch.text, forKey: "search_text")
        }
        else{
            sharedInstance.isSearchedTextCall = false
            sharedInstance.isViewAllCalled = true
            sharedInstance.isSearchedSeeMore = false
            dicToSend .setValue(" ", forKey: "search_text")
        }
        
        
        
        if arrHorizon.count>0 {
            var arrTemp = NSMutableArray()
            arrTemp = self.CheckFilterArray(arrHorizon)
            if arrTemp.count>0 {
                dicToSend.setValue(arrTemp, forKey: "Horizon")
            }
        }
        
        if arrFundName.count>0 {
            var arrTemp = NSMutableArray()
            arrTemp = self.CheckFilterArray(arrFundName)
            if arrTemp.count>0 {
                dicToSend.setValue(arrTemp, forKey: "Fund_Name")
            }
        }
        
        if arrPlanOpt.count>0 {
            var arrTemp = NSMutableArray()
            arrTemp = self.CheckFilterArray(arrPlanOpt)
            if arrTemp.count>0 {
                dicToSend.setValue(arrTemp, forKey: "Plan_Opt")
            }
        }
        if arrPlanOpt.count<1{
            arrPlanOpt = self.methodForOptionArray(NSNull)
        }
        if arrRisk.count>0 {
            var arrTemp = NSMutableArray()
            arrTemp = self.CheckFilterArray(arrRisk)
            if arrTemp.count>0 {
                dicToSend.setValue(arrTemp, forKey: "Risk")
            }
        }
        
        if arrFundType.count>0 {
            var arrTemp = NSMutableArray()
            arrTemp = self.CheckFilterArray(arrFundType)
            if arrTemp.count>0 {
                dicToSend.setValue(arrTemp, forKey: "Fund_type")
            }
        }
        
        print(dicToSend)
        WebManagerHK .postDataToURL(kModeSearchAllSchemeNameByText, params: dicToSend, message: "Please Wait..") { (responce) in
            //            print(responce)
            self.arrViewAllData = (responce.valueForKey("WAPIResponse")?.mutableCopy())! as! NSMutableArray
            var sortByName = NSSortDescriptor()
            if self.objDefault.valueForKey("sortBy") != nil {
                
                var strSort = NSString()
                strSort = (self.objDefault.valueForKey("sortBy") as? NSString)!
                
                if (strSort.isEqualToString("1Yr Return")){
                    sortByName = NSSortDescriptor(key: "oneyearreturn", ascending: false)
                }
                if (strSort.isEqualToString("3Yr Return")){
                    sortByName = NSSortDescriptor(key: "threeyearreturn", ascending: false)
                }
                if (strSort.isEqualToString("5Yr Return")){
                    sortByName = NSSortDescriptor(key: "fiveyearreturn", ascending: false)
                }
            }
            else
            {
                sortByName = NSSortDescriptor(key: "threeyearreturn", ascending: false)
            }
            
            let sortDescriptors = [sortByName]
            let sortedArray = (self.arrViewAllData as NSMutableArray).sortedArrayUsingDescriptors(sortDescriptors) as NSArray
            
            self.arrViewAllData = sortedArray .mutableCopy() as! NSMutableArray
            //            print(self.arrViewAllData)
            self.isServiceCall = true
            dispatch_async(dispatch_get_main_queue(),{
                self.tblView.reloadData()
            })
        }
    }
    
    func UISetup() {
        
        
        vTestView.frame = CGRect(x:0, y:0, width:screenSize.width, height:44)
        
        txtSearch.frame = CGRect(x:60, y:7, width:screenSize.width-60, height:30)
        txtSearch.backgroundColor = UIColor.clearColor()
        txtSearch.autocorrectionType = .No
        txtSearch.delegate = self
        txtSearch.placeholder = "Search for Funds..."
        txtSearch.textColor = UIColor.whiteColor()
        txtSearch.clearButtonMode = .WhileEditing
        txtSearch.addTarget(self, action:#selector(SearchScreen.SearchValueChange(_:)), forControlEvents:.EditingChanged);
        txtSearch.attributedPlaceholder = NSAttributedString(string:"Search for Funds...",
                                                             attributes:[NSForegroundColorAttributeName:UIColor(red:240/250, green:240/250, blue:240/250, alpha: 0.5)])
        
        indicator.frame = CGRect(x: vTestView.frame.size.width - 33, y: 7, width: 30, height: 30)
        indicator.tintColor = UIColor.whiteColor()
        
        let btnBack = UIButton()
        btnBack.frame = CGRect(x:0, y:2, width:40, height:40)
        btnBack.addTarget(self, action: #selector(SearchScreen.btnBackTap(_:)), forControlEvents: .TouchUpInside)
        if let image = UIImage(named: "iconBack") {
            btnBack.setImage(image, forState: .Normal)
        }
        
        vTestView.addSubview(txtSearch)
        vTestView.addSubview(btnBack)
        vTestView.addSubview(indicator)
        
        self.navigationController!.navigationBar.backgroundColor = UIColor.defaultAppColorBlue
        self.navigationController!.navigationBar.addSubview(vTestView)
        
    }
    func CheckFilterArray(arr:NSMutableArray) -> NSMutableArray {
        let arrTemp = NSMutableArray()
        if arr.count>0 {
            for index in 0..<arr.count {
                let isSelected = arr.objectAtIndex(index).valueForKey("isSelected") as! Int
                if isSelected == 1 {
                    arrTemp.addObject((arr.objectAtIndex(index).valueForKey("value"))as! String)
                    
                }
            }
            
            
        }
        
        return arrTemp
    }
    func ClearAllFilter(){
        
        for index in 0..<arrHorizon.count{
            let dic = NSMutableDictionary()
            let strValue = arrHorizon.objectAtIndex(index).valueForKey("value")
            let strIndex = arrHorizon.objectAtIndex(index).valueForKey("index")
            dic .setValue(0, forKey: "isSelected")
            dic .setValue(strIndex, forKey: "index")
            dic .setValue(strValue, forKey: "value")
            arrHorizon .replaceObjectAtIndex(index, withObject: dic)
        }
        for index in 0..<arrRisk.count{
            let dic = NSMutableDictionary()
            let strValue = arrRisk.objectAtIndex(index).valueForKey("value")
            let strIndex = arrRisk.objectAtIndex(index).valueForKey("index")
            dic .setValue(0, forKey: "isSelected")
            dic .setValue(strIndex, forKey: "index")
            dic .setValue(strValue, forKey: "value")
            arrRisk .replaceObjectAtIndex(index, withObject: dic)
        }
        for index in 0..<arrFundName.count{
            let dic = NSMutableDictionary()
            let strValue = arrFundName.objectAtIndex(index).valueForKey("value")
            let strIndex = arrFundName.objectAtIndex(index).valueForKey("index")
            dic .setValue(0, forKey: "isSelected")
            dic .setValue(strIndex, forKey: "index")
            dic .setValue(strValue, forKey: "value")
            arrFundName .replaceObjectAtIndex(index, withObject: dic)
        }
        for index in 0..<arrFundType.count{
            let dic = NSMutableDictionary()
            let strValue = arrFundType.objectAtIndex(index).valueForKey("value")
            let strIndex = arrFundType.objectAtIndex(index).valueForKey("index")
            dic .setValue(0, forKey: "isSelected")
            dic .setValue(strIndex, forKey: "index")
            dic .setValue(strValue, forKey: "value")
            arrFundType .replaceObjectAtIndex(index, withObject: dic)
        }
        for index in 0..<arrPlanOpt.count{
            let dic = NSMutableDictionary()
            let strValue = arrPlanOpt.objectAtIndex(index).valueForKey("value")
            let strIndex = arrPlanOpt.objectAtIndex(index).valueForKey("index")
            
            if strValue!.isEqualToString("GR") {
                dic .setValue(1, forKey: "isSelected")
            }
            else{
                dic .setValue(0, forKey: "isSelected")
            }
            dic .setValue(strIndex, forKey: "index")
            dic .setValue(strValue, forKey: "value")
            arrPlanOpt .replaceObjectAtIndex(index, withObject: dic)
        }
        self.objDefault.setValue("3Yr Return", forKey: "sortBy")
        self.objDefault .setValue(self.arrHorizon, forKey: "Horizon")
        self.objDefault .setValue(self.arrFundName, forKey: "Fund_Name")
        self.objDefault .setValue(self.arrPlanOpt, forKey: "Plan_Opt")
        self.objDefault .setValue(self.arrRisk, forKey: "Risk")
        self.objDefault .setValue(self.arrFundType, forKey: "Fund_type")
        self.objDefault .synchronize()
    }
    @IBAction func btnBuySIPClicked(sender: AnyObject) {
        
        let btnSender = sender as! UIButton
        print("Buy SIP Clicked")
        
        if btnSender.titleLabel?.text=="BUY/SIP" {
            
            print(self.arrViewAllData.objectAtIndex(btnSender.tag))
            
            let dic = self.arrViewAllData.objectAtIndex(btnSender.tag) as! NSDictionary
            print(dic)
            
            //let dic = self.arrTopFunds.objectAtIndex(btnSender.tag) as! NSDictionary
            RootManager.sharedInstance.isFrom = IS_FROM.BuySIPFromSearch
            RootManager.sharedInstance.navigateToScreen(self, data: dic)

            
//            let allUser = DBManager.getInstance().getAllUser()
//            if allUser.count==0
//            {
//                SharedManager.invokeAlertMethod(APP_NAME, strBody: "Please do login first", delegate: nil)
//                
//            }else{
//                
//                let objUser = allUser.objectAtIndex(0) as! User
//                sharedInstance.objLoginUser = objUser
//                
//                let jo = NSMutableDictionary()
//                jo.setValue(dic.valueForKey("Fund_Code"), forKey: "Fund_Code")
//                jo.setValue(dic.valueForKey("NAV"), forKey: "NAV")
//                jo.setValue(dic.valueForKey("NAVDate"), forKey: "NAVDate")
//                
//                jo.setValue(dic.valueForKey("Plan_Name"), forKey: "Plan_Name")
//                jo.setValue(dic.valueForKey("Plan_Opt"), forKey: "Div_Opt")
//                jo.setValue(dic.valueForKey("Scheme_Code"), forKey: "Scheme_Code")
//                
//                print(jo)
//                sharedInstance.userDefaults.setObject(jo, forKey: kSelectBuyNowScheme)
//                
//                let objBuyScreen = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdBuyScreeen) as! BuyScreeen
//                objBuyScreen.isBuyFrom = kBUY_FROM_SELECTED_FUND
//                objBuyScreen.isExisting = true
//                self.navigationController?.pushViewController(objBuyScreen, animated: true)
//            }
            
        }
        else{
            let objSwitchScreen = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdSwitchScreen) as! SwitchScreen
            self.navigationController?.pushViewController(objSwitchScreen, animated: true)
            

        }
        
    }
    
}

