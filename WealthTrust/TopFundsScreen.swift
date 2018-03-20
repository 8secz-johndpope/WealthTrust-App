//
//  TopFundsScreen.swift
//  WealthTrust
//
//  Created by Hemen Gohil on 11/26/16.
//  Copyright © 2016 Hemen Gohil. All rights reserved.
//

import UIKit

class TopFundsScreen: UIViewController {

    @IBOutlet weak var viewTopBar: UIView!
    
    @IBOutlet weak var lblInvestmentHori: UILabel!
    
    
    @IBOutlet weak var sliderInvestHori: UISlider!
    
    @IBOutlet weak var lblType: UILabel!
    
    @IBOutlet weak var sliderType: UISlider!
    
    @IBOutlet weak var lblRisk: UILabel!
    
    
    var arrTypes = NSMutableArray()
    var arrTopFunds = NSMutableArray()

    var currentTypeSelected = "Large cap"
    var currentInveSelected = "> 5 years"
    
    @IBOutlet weak var tblView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tblView.tableHeaderView = viewTopBar
        
        self.firstInitialCall()
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
//            self.viewTopBar.frame = CGRect(x: self.viewTopBar.frame.origin.x, y: self.viewTopBar.frame.origin.y, width: self.viewTopBar.frame.size.width, height: 200)
            
            SharedManager.addShadowToView(self.viewTopBar)

        })
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
    }
    @IBAction func btnBBKClicked(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    @IBAction func sliderInvestmentHorizonValueChanged(sender: AnyObject) {
        //Touchup Outside called.
//        let slider = sender as! UISlider
//        let sliderValue = Float(lroundf(slider.value));
//        print(sliderValue)
//
//        slider.setValue(sliderValue, animated: true)
//        
//        
//        self.lblType.hidden = true
//        self.sliderType.hidden = true
//
//        self.viewTopBar.frame = CGRect(x: self.viewTopBar.frame.origin.x, y: self.viewTopBar.frame.origin.y, width: self.viewTopBar.frame.size.width, height: 136)
//        
//        if slider.value==0 {
//            lblInvestmentHori.text = "Investment Horizon : < 3 months"
//            lblRisk.text = "Risk : Low"
//            lblRisk.frame = CGRect(x: lblRisk.frame.origin.x, y: self.sliderInvestHori.frame.origin.y+self.sliderInvestHori.frame.size.height+5, width: lblRisk.frame.size.width, height: lblRisk.frame.size.height)
//            
//            
//        }
//        if slider.value==1 {
//            lblInvestmentHori.text = "Investment Horizon : < 1 year"
//            lblRisk.text = "Risk : Moderately Low"
//            
//            self.viewTopBar.frame = CGRect(x: self.viewTopBar.frame.origin.x, y: self.viewTopBar.frame.origin.y, width: self.viewTopBar.frame.size.width, height: 136)
//
//            lblRisk.frame = CGRect(x: lblRisk.frame.origin.x, y: self.sliderInvestHori.frame.origin.y+self.sliderInvestHori.frame.size.height+5, width: lblRisk.frame.size.width, height: lblRisk.frame.size.height)
//
//
//        }
//        if slider.value==2 {
//            lblInvestmentHori.text = "Investment Horizon : 1-3 years"
//            lblRisk.text = "Risk : Moderate"
//            
//            self.viewTopBar.frame = CGRect(x: self.viewTopBar.frame.origin.x, y: self.viewTopBar.frame.origin.y, width: self.viewTopBar.frame.size.width, height: 136)
//
//            lblRisk.frame = CGRect(x: lblRisk.frame.origin.x, y: self.sliderInvestHori.frame.origin.y+self.sliderInvestHori.frame.size.height+5, width: lblRisk.frame.size.width, height: lblRisk.frame.size.height)
//
//
//        }
//        if slider.value==3 {
//            lblInvestmentHori.text = "Investment Horizon : 3-5 years"
//            lblRisk.text = "Risk : Moderately High"
//            
//            self.viewTopBar.frame = CGRect(x: self.viewTopBar.frame.origin.x, y: self.viewTopBar.frame.origin.y, width: self.viewTopBar.frame.size.width, height: 136)
//
//            lblRisk.frame = CGRect(x: lblRisk.frame.origin.x, y: self.sliderInvestHori.frame.origin.y+self.sliderInvestHori.frame.size.height+5, width: lblRisk.frame.size.width, height: lblRisk.frame.size.height)
//
//        }
//        if slider.value==4 {
//            lblInvestmentHori.text = "Investment Horizon : > 5 years"
//            lblRisk.text = "Risk : Moderately High"
//            
//            self.lblType.hidden = false
//            self.sliderType.hidden = false
//
//            self.viewTopBar.frame = CGRect(x: self.viewTopBar.frame.origin.x, y: self.viewTopBar.frame.origin.y, width: self.viewTopBar.frame.size.width, height: 200)
//
//            lblRisk.frame = CGRect(x: lblRisk.frame.origin.x, y: self.sliderType.frame.origin.y+self.sliderType.frame.size.height+5, width: lblRisk.frame.size.width, height: lblRisk.frame.size.height)
//
//            
//            lblType.text = "Type : Large cap"
//            self.sliderType.value = 3
//
//        }
//
        
//        var rectFrame = self.tblView.frame
//        rectFrame.origin.y = (self.viewTopBar.frame.origin.y) + self.viewTopBar.frame.size.height+5
//        self.tblView.frame = rectFrame

    }
    
    @IBAction func sliderInvestClicked(sender: AnyObject) {
        //Touchup Inside called.
        print("Call API")
        
        
        let slider = sender as! UISlider
        
        let sliderValue = Float(lroundf(slider.value));
        print(sliderValue)
        
        slider.setValue(sliderValue, animated: true)
        
        self.lblType.hidden = true
        self.sliderType.hidden = true
        
        self.viewTopBar.frame = CGRect(x: self.viewTopBar.frame.origin.x, y: self.viewTopBar.frame.origin.y, width: self.viewTopBar.frame.size.width, height: 136)


        if slider.value==0 {
            lblInvestmentHori.text = "Investment Horizon : < 3 months"
            lblRisk.text = "Risk : Low"
            lblRisk.frame = CGRect(x: lblRisk.frame.origin.x, y: self.sliderInvestHori.frame.origin.y+self.sliderInvestHori.frame.size.height+5, width: lblRisk.frame.size.width, height: lblRisk.frame.size.height)
            if currentInveSelected=="< 3 months" {
                return
            }
            self.callAPIWithInvestmentHorizon("< 3 months")
            currentInveSelected = "< 3 months"
        }
        if slider.value==1 {
            lblInvestmentHori.text = "Investment Horizon : < 1 year"
            lblRisk.text = "Risk : Moderately Low"
            
            self.viewTopBar.frame = CGRect(x: self.viewTopBar.frame.origin.x, y: self.viewTopBar.frame.origin.y, width: self.viewTopBar.frame.size.width, height: 136)
            
            lblRisk.frame = CGRect(x: lblRisk.frame.origin.x, y: self.sliderInvestHori.frame.origin.y+self.sliderInvestHori.frame.size.height+5, width: lblRisk.frame.size.width, height: lblRisk.frame.size.height)
            if currentInveSelected=="< 1 year" {
                return
            }

            self.callAPIWithInvestmentHorizon("< 1 year")
            currentInveSelected = "< 1 year"

        }
        if slider.value==2 {
            lblInvestmentHori.text = "Investment Horizon : 1-3 years"
            lblRisk.text = "Risk : Moderate"
            
            self.viewTopBar.frame = CGRect(x: self.viewTopBar.frame.origin.x, y: self.viewTopBar.frame.origin.y, width: self.viewTopBar.frame.size.width, height: 136)
            
            lblRisk.frame = CGRect(x: lblRisk.frame.origin.x, y: self.sliderInvestHori.frame.origin.y+self.sliderInvestHori.frame.size.height+5, width: lblRisk.frame.size.width, height: lblRisk.frame.size.height)
            if currentInveSelected=="1-3 years" {
                return
            }

            self.callAPIWithInvestmentHorizon("1-3 years")
            currentInveSelected = "1-3 years"

        }
        if slider.value==3 {
            lblInvestmentHori.text = "Investment Horizon : 3-5 years"
            lblRisk.text = "Risk : Moderately High"
            
            self.viewTopBar.frame = CGRect(x: self.viewTopBar.frame.origin.x, y: self.viewTopBar.frame.origin.y, width: self.viewTopBar.frame.size.width, height: 136)
            
            lblRisk.frame = CGRect(x: lblRisk.frame.origin.x, y: self.sliderInvestHori.frame.origin.y+self.sliderInvestHori.frame.size.height+5, width: lblRisk.frame.size.width, height: lblRisk.frame.size.height)
            if currentInveSelected=="3-5 years" {
                return
            }

            self.callAPIWithInvestmentHorizon("3-5 years")
            currentInveSelected = "3-5 years"

        }
        if slider.value==4 {
            lblInvestmentHori.text = "Investment Horizon : > 5 years"
            lblRisk.text = "Risk : Moderately High"
            
            self.lblType.hidden = false
            self.sliderType.hidden = false
            
            self.viewTopBar.frame = CGRect(x: self.viewTopBar.frame.origin.x, y: self.viewTopBar.frame.origin.y, width: self.viewTopBar.frame.size.width, height: 200)
            
            lblRisk.frame = CGRect(x: lblRisk.frame.origin.x, y: self.sliderType.frame.origin.y+self.sliderType.frame.size.height+5, width: lblRisk.frame.size.width, height: lblRisk.frame.size.height)
            
            
            lblType.text = "Type : Large cap"
            self.sliderType.value = 3

            if currentInveSelected=="> 5 years" {
                return
            }
            
            self.callAPIWithInvestmentHorizonAndType("> 5 years", type: "Large cap")
            currentInveSelected = "> 5 years"
        }
    }
    
    @IBAction func sliderTypeValueChanged(sender: AnyObject) {
        
        //Touchup Outside called.
        
//        self.viewTopBar.frame = CGRect(x: self.viewTopBar.frame.origin.x, y: self.viewTopBar.frame.origin.y, width: self.viewTopBar.frame.size.width, height: 200)
//
//        let slider = sender as! UISlider
//        let sliderValue = Float(lroundf(slider.value));
//        print(sliderValue)
//        
//        slider.setValue(sliderValue, animated: true)
//        
//        if slider.value==0 {
//            lblType.text = "Type : Small cap"
//        }
//        if slider.value==1 {
//            lblType.text = "Type : Mid cap"
//        }
//        if slider.value==2 {
//            lblType.text = "Type : Multi cap"
//        }
//        if slider.value==3 {
//            lblType.text = "Type : Large cap"
//        }
//        if slider.value==4 {
//            lblType.text = "Type : Tax Saving"
//        }
    }
    
    @IBAction func sliderTypeClicked(sender: AnyObject) {
        //Touchup Inside called.
        print("Call API Type")
        
        self.viewTopBar.frame = CGRect(x: self.viewTopBar.frame.origin.x, y: self.viewTopBar.frame.origin.y, width: self.viewTopBar.frame.size.width, height: 200)

        let slider = sender as! UISlider
        let sliderValue = Float(lroundf(slider.value))
        print(sliderValue)
        
        slider.setValue(sliderValue, animated: true)
        
        if slider.value==0 {
             lblType.text = "Type : Small cap"
            if currentTypeSelected=="Small cap" {
                return
            }
            self.callAPIWithInvestmentHorizonAndType("> 5 years", type: "Small cap")
            currentTypeSelected = "Small cap"
        }
        if slider.value==1 {
            lblType.text = "Type : Mid cap"
            if currentTypeSelected=="Mid cap" {
                return
            }

            self.callAPIWithInvestmentHorizonAndType("> 5 years", type: "Mid cap")
            currentTypeSelected = "Mid cap"
        }
        if slider.value==2 {
            lblType.text = "Type : Multi cap"
            if currentTypeSelected=="Multi cap" {
                return
            }

            self.callAPIWithInvestmentHorizonAndType("> 5 years", type: "Multi cap")
            currentTypeSelected = "Multi cap"
        }
        if slider.value==3 {
            lblType.text = "Type : Large cap"
            if currentTypeSelected=="Large cap" {
                return
            }

            self.callAPIWithInvestmentHorizonAndType("> 5 years", type: "Large cap")
            currentTypeSelected = "Large cap"
        }
        if slider.value==4 {
            lblType.text = "Type : Tax Saving"
            if currentTypeSelected=="Tax Saving" {
                return
            }

            self.callAPIWithInvestmentHorizonAndType("> 5 years", type: "Tax Saving")
            currentTypeSelected = "Tax Saving"
        }

    }
    
    func firstInitialCall() {
        
        let dic = NSMutableDictionary()
        dic["Investment_horizon"] = "> 5 years"
        
        WebManagerHK.postDataToURL(kModeGetTopFunds, params: dic, message: "Loading top funds...") { (response) in
            
            if response.objectForKey(kWAPIResponse) is NSDictionary
            {
                let mainResponse = response.objectForKey(kWAPIResponse) as! NSDictionary
                print("Dic Response For TopFunds: \(mainResponse)")

                let arrType = mainResponse.valueForKey("distinctType") as! NSArray
                self.arrTypes = arrType.mutableCopy() as! NSMutableArray
                
                self.callAPIWithInvestmentHorizonAndType("> 5 years", type: "Large cap")
                
            }
        }
    }
    
    func callAPIWithInvestmentHorizon(horizon : String) {
        
        let dic = NSMutableDictionary()
        dic["Investment_horizon"] = horizon
        
        WebManagerHK.postDataToURL(kModeGetTopFunds, params: dic, message: "Loading top funds...") { (response) in
            
            if response.objectForKey(kWAPIResponse) is NSDictionary
            {
                let mainResponse = response.objectForKey(kWAPIResponse) as! NSDictionary
                print("Dic Response For TopFunds: \(mainResponse)")
                
                
                let arrFnds = mainResponse.valueForKey("TopFunds") as! NSArray
                self.arrTopFunds = arrFnds.mutableCopy() as! NSMutableArray

                print("NEW TOP FUNDs.... \(self.arrTopFunds)")
                
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tblView.reloadData()
                })

            }
        }
    }

    
    func callAPIWithInvestmentHorizonAndType(horizon : String, type : String) {
        
        let dic = NSMutableDictionary()
        dic["Investment_horizon"] = horizon
        dic["type"] = type
        
        WebManagerHK.postDataToURL(kModeGetTopFunds, params: dic, message: "Loading top funds...") { (response) in
            
            if response.objectForKey(kWAPIResponse) is NSDictionary
            {
                let mainResponse = response.objectForKey(kWAPIResponse) as! NSDictionary
                print("Dic Response For TopFunds: \(mainResponse)")
                
                let arrFnds = mainResponse.valueForKey("TopFunds") as! NSArray
                self.arrTopFunds = arrFnds.mutableCopy() as! NSMutableArray
                
                print("NEW TOP FUNDs.... \(self.arrTopFunds)")
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tblView.reloadData()
                })

            }
        }
        
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.arrTopFunds.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        var stringIdentifier = "ALL_SELECTED_DATA_\(indexPath.row)_\(indexPath.section)"

        let dicToUse = self.arrTopFunds.objectAtIndex(indexPath.row)
        if let name = dicToUse.valueForKey("Plan_Name") {
            stringIdentifier = stringIdentifier + (name as! String)
        }else{
            stringIdentifier = stringIdentifier + "SCHEME"
        }

        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: stringIdentifier)
        
        let cell = tableView.dequeueReusableCellWithIdentifier(stringIdentifier, forIndexPath: indexPath) as UITableViewCell
        
        if (cell.contentView.subviews.count==0) {
            
            let viewSquare = UIView(frame: CGRect(x: 10, y: 1, width: (cell.contentView.frame.size.width)-20, height: 96))
            viewSquare.backgroundColor = UIColor.whiteColor()
            cell.contentView.addSubview(viewSquare)
            SharedManager.addShadowToView(viewSquare)
       
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
                lblGR = UILabel(frame: CGRect(x: 10, y: 45, width: 100, height: 20));
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
                lblNAV = UILabel(frame: CGRect(x: 10, y: 65, width: 100, height: 20));
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
            lbl5Y = UILabel(frame: CGRect(x: viewSquare.frame.size.width-110, y: 45, width: 40, height: 20));
            lbl5Y.font = UIFont.systemFontOfSize(13)
            lbl5Y.textColor = UIColor.blackColor().colorWithAlphaComponent(0.54)
            lbl5Y.textAlignment = .Center
            lbl5Y.text = "5Y"
            viewSquare.addSubview(lbl5Y)

            var lbl5YValue : UILabel!
            lbl5YValue = UILabel(frame: CGRect(x: viewSquare.frame.size.width-110, y: 65, width: 40, height: 20));
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
            lbl3Y = UILabel(frame: CGRect(x: viewSquare.frame.size.width-150, y: 45, width: 40, height: 20));
            lbl3Y.font = UIFont.systemFontOfSize(13)
            lbl3Y.textColor = UIColor.blackColor().colorWithAlphaComponent(0.54)
            lbl3Y.textAlignment = .Center
            lbl3Y.text = "3Y"
            viewSquare.addSubview(lbl3Y)
            
            var lbl3YValue : UILabel!
            lbl3YValue = UILabel(frame: CGRect(x: viewSquare.frame.size.width-150, y: 65, width: 40, height: 20));
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
            lbl1Y = UILabel(frame: CGRect(x: viewSquare.frame.size.width-190, y: 45, width: 40, height: 20));
            lbl1Y.font = UIFont.systemFontOfSize(13)
            lbl1Y.textColor = UIColor.darkGrayColor()
            lbl1Y.textAlignment = .Center
            lbl1Y.text = "1Y"
            viewSquare.addSubview(lbl1Y)
            
            var lbl1YValue : UILabel!
            lbl1YValue = UILabel(frame: CGRect(x: viewSquare.frame.size.width-190, y: 65, width: 40, height: 20));
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

            
            
            let btnSubmit = UIButton(frame: CGRect(x: viewSquare.frame.size.width-70, y: 52, width: 66, height: 36))
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
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 97
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        print(self.arrTopFunds.objectAtIndex(indexPath.row))
     
        let details = self.arrTopFunds.objectAtIndex(indexPath.row) as! NSDictionary
        let schemeCode = details.valueForKey("Scheme_Code") as! String
        let fundCode = details.valueForKey("Fund_Code") as! String
        
        let jo = NSMutableDictionary()
        jo.setValue(details.valueForKey("Fund_Code"), forKey: "Fund_Code")
        jo.setValue(details.valueForKey("NAV"), forKey: "NAV")
        jo.setValue(details.valueForKey("NAVDate"), forKey: "NAVDate")
        
        jo.setValue(details.valueForKey("Plan_Name"), forKey: "Plan_Name")
        jo.setValue(details.valueForKey("Plan_Opt"), forKey: "Div_Opt")
        jo.setValue(details.valueForKey("Scheme_Code"), forKey: "Scheme_Code")
        print(jo)
        sharedInstance.userDefaults.setObject(jo, forKey: kSelectBuyNowScheme)

        let objSchemDetails = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdSchemeDetailsScreen) as! SchemeDetailsScreen
        objSchemDetails.schemeCode = schemeCode
        objSchemDetails.fundCode = fundCode
        self.navigationController?.pushViewController(objSchemDetails, animated: true)
    }

    @IBAction func btnBuySIPClicked(sender: AnyObject) {
        
        let btnSender = sender as! UIButton
        if btnSender.titleLabel?.text=="BUY/SIP" {
            let dic = self.arrTopFunds.objectAtIndex(btnSender.tag) as! NSDictionary
            RootManager.sharedInstance.isFrom = IS_FROM.BuySIPFromTopFunds
            RootManager.sharedInstance.navigateToScreen(self, data: dic)
        }
    }
    
    //            let jo = [
    //                "Div_Opt" : "NA",
    //                "Fund_Code" : "2.0"
    //            ]
//    let cart = ["Div_Opt" : "NA",
//                "Fund_Code" : dic.valueForKey("Fund_Code"),
//                "NAV" : dic.valueForKey("NAV"),
//                "NAVDate" : dic.valueForKey("NAVDate"),
//                "Plan_Name" : dic.valueForKey("Plan_Name"),
//                "Plan_Opt" : dic.valueForKey("Plan_Opt"),
//                "Scheme_Code" : dic.valueForKey("Scheme_Code")]

    //            let allUser = DBManager.getInstance().getAllUser()
    //            if !sharedInstance.isUserLogin()
    //            {
    //                SharedManager.invokeAlertMethod(APP_NAME, strBody: "Please do login first", delegate: nil)
    //
    //            }else{
    //
    //                let objUser = allUser.objectAtIndex(0) as! User
    //                sharedInstance.objLoginUser = objUser
    //
//                    let jo = NSMutableDictionary()
//                    jo.setValue(dic.valueForKey("Fund_Code"), forKey: "Fund_Code")
//                    jo.setValue(dic.valueForKey("NAV"), forKey: "NAV")
//                    jo.setValue(dic.valueForKey("NAVDate"), forKey: "NAVDate")
//    
//                    jo.setValue(dic.valueForKey("Plan_Name"), forKey: "Plan_Name")
//                    jo.setValue(dic.valueForKey("Plan_Opt"), forKey: "Div_Opt")
//                    jo.setValue(dic.valueForKey("Scheme_Code"), forKey: "Scheme_Code")
//    
//                    print(jo)
//                    sharedInstance.userDefaults.setObject(jo, forKey: kSelectBuyNowScheme)
//    
//                    let objBuyScreen = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdBuyScreeen) as! BuyScreeen
//                    objBuyScreen.isBuyFrom = kBUY_FROM_SELECTED_FUND
//                    objBuyScreen.isExisting = true
//                    self.navigationController?.pushViewController(objBuyScreen, animated: true)
    //
    //            }

    
}
