//
//  SchemeDetailsScreen.swift
//  WealthTrust
//
//  Created by Hemen Gohil on 11/28/16.
//  Copyright © 2016 Hemen Gohil. All rights reserved.
//

import UIKit

class SchemeDetailsScreen: UIViewController {

    @IBOutlet weak var viewGraph: UIView!
    
    @IBOutlet weak var viewFullBack: UIView!
    @IBOutlet weak var btnBupSIpSwith: UIButton!
    
    
    @IBOutlet weak var lblFundName: UILabel!
    
    @IBOutlet weak var lblHorizon: UILabel!
    
    
    @IBOutlet weak var lblRisk: UILabel!
    
    @IBOutlet weak var lblFundCategory: UILabel!
    
    @IBOutlet weak var lblPlanType: UILabel!
    
    
    @IBOutlet weak var lblPlanOption: UILabel!
    
    @IBOutlet weak var lblNav: UILabel!
    
    @IBOutlet weak var lblMinimumSIPInve: UILabel!
    
    @IBOutlet weak var lblMinimumInvestment: UILabel!
    
    
    @IBOutlet weak var txtViewAnalisys: UITextView!
    
    @IBOutlet weak var viewGraphInner: UIView!
    
    
    var schemeCode = ""
    var fundCode = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBarHidden = true
  
        
        if self.schemeCode=="" {
            
        }else{
            if self.fundCode=="" {
                
            }else{
                self.callAPIForSchemeDetails()
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    @IBAction func btnBackClickd(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func btnBuySipSwitchClicked(sender: AnyObject) {
        print("Clicked")
        
        let btnSender = sender as! UIButton

        if btnSender.titleLabel?.text=="BUY/SIP" {
//            let objBuyScreen = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdBuyScreeen) as! BuyScreeen
//            objBuyScreen.isBuyFrom = kBUY_FROM_SELECTED_FUND
//            objBuyScreen.isExisting = true
//            self.navigationController?.pushViewController(objBuyScreen, animated: true)
            if let BuyNowScheme = sharedInstance.userDefaults.objectForKey(kSelectBuyNowScheme) as? NSDictionary
            {
//                let dic = self.arrTopFunds.objectAtIndex(btnSender.tag) as! NSDictionary
                RootManager.sharedInstance.isFrom = IS_FROM.BuySIPFromTopFunds
                RootManager.sharedInstance.navigateToScreen(self, data: BuyNowScheme)
            }
        }else{
        }
    }

    func callAPIForSchemeDetails() {
        //GetSchemeCompleteDetail
        
        let dic = NSMutableDictionary()
        dic["Scheme_Code"] = self.schemeCode
        dic["Fund_Code"] = self.fundCode
        
        WebManagerHK.postDataToURL(kModeGetSchemeCompleteDetail, params: dic, message: "Loading scheme details...") { (response) in
            
            if response.objectForKey(kWAPIResponse) is NSDictionary
            {
                let mainResponse = response.objectForKey(kWAPIResponse) as! NSDictionary
                print("Dic Response For TopFunds: \(mainResponse)")
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    if let name = mainResponse.valueForKey("Plan_Name")
                    {
                        self.lblFundName.text = name as? String
                    }
                    if let name = mainResponse.valueForKey("Horizon")
                    {
                        self.lblHorizon.text = "Horizon : \(name)"
                    }
                    if let name = mainResponse.valueForKey("Risk")
                    {
                        self.lblRisk.text = "Risk : \(name)"
                    }

                    self.lblFundCategory.text = "Fund Category : Debt"
                    
                    if let name = mainResponse.valueForKey("Plan_Type")
                    {
                        self.lblPlanType.text = "Plan Type : \(name)"
                        
                        if name as! String == "DIR"
                        {
                            self.btnBupSIpSwith.setTitle("BUY/SIP", forState: .Normal)
                            
                        }else{
                            self.btnBupSIpSwith.setTitle("SWITCH", forState: .Normal)
                            
                        }
                    }
                    if let name = mainResponse.valueForKey("Plan_Opt")
                    {
                        self.lblPlanOption.text = "Plan Option : \(name)"
                    }
                    if let name = mainResponse.valueForKey("NAV")
                    {
                        self.lblNav.text = "NAV : \(name)"
                    }
                    if let name = mainResponse.valueForKey("Minimum_Investment")
                    {
                        self.lblMinimumInvestment.text = "Minimum Investment : \(name)"
                    }
                    if let name = mainResponse.valueForKey("Minimum_SIP_Investment")
                    {
                        self.lblMinimumSIPInve.text = "Minimum SIP Investment : \(name)"
                    }

                    if let name = mainResponse.valueForKey("Commentary")
                    {
                        self.txtViewAnalisys.text = name as! String
                    }

                    
                    
                    var fiveyearreturn = 0.0
                    
                    if let name = mainResponse.valueForKey("fiveyearreturn")
                    {
                        if name is NSNull
                        {
                            
                        }else{
                            fiveyearreturn = name as! Double
                        }
                        
                    }
                    
                    var oneyearreturn = 0.0
                    
                    if let name = mainResponse.valueForKey("oneyearreturn")
                    {
                        if name is NSNull
                        {
                            
                        }else{
                            oneyearreturn = name as! Double

                        }
                        
                    }
                    
                    var threeyearreturn = 0.0

                    if let name = mainResponse.valueForKey("threeyearreturn")
                    {
                        if name is NSNull
                        {
                            
                        }else{
                            threeyearreturn = name as! Double

                        }
                        
                    }
                    
                    self.getDataSet(oneyearreturn, threeyearreturn: threeyearreturn, fiveyearreturn: fiveyearreturn)
                    
                })
                
            }
        }

    }
    
    
    
    
    
    
    func getDataSet(oneyearreturn : Double,threeyearreturn : Double,fiveyearreturn : Double) {
        
        let dic = NSMutableDictionary()
        
        
        var totalAll = 0.0
        
        dic.setValue(oneyearreturn, forKey: "0")
        totalAll = totalAll + oneyearreturn

        dic.setValue(threeyearreturn, forKey: "1")
        totalAll = totalAll + threeyearreturn

        dic.setValue(fiveyearreturn, forKey: "2")
        totalAll = totalAll + fiveyearreturn


        print("Generated : \(dic)")
        print("Total Of All : \(totalAll)")
        
        
        let year1 = ((dic.valueForKey("0")?.doubleValue)!/totalAll)*100
        let year10 = ((dic.valueForKey("1")?.doubleValue)!/totalAll)*100
        let year20 = ((dic.valueForKey("2")?.doubleValue)!/totalAll)*100
        
        print("1 Year : \(year1)")
        print("10 Year : \(year10)")
        print("20 Year : \(year20)")
        
        self.viewGraphInner.subviews.forEach({ $0.removeFromSuperview() }) // this gets things done
        

        let y1Year = Double(self.viewGraphInner.frame.size.height-year1.floatValue)
//        let lbl1Year = UILabel(frame: CGRect(x: 40, y: y1Year, width: 50, height: year1))
        let lbl1Year = UILabel(frame: CGRect(x: 40, y: y1Year+year1, width: 50, height: 0))
        lbl1Year.backgroundColor = UIColor.defaultGreenColor
        self.viewGraphInner.addSubview(lbl1Year)
        
        let lbl1YearCalc = UILabel(frame: CGRect(x: 40, y: y1Year-15, width: 50, height: 10))
        if let val = dic.valueForKey("0") {
            lbl1YearCalc.text = String(format: "%.0f", val as! Double)
            if (val as! Double)==0 {
                    lbl1YearCalc.text = "NA"
            }
        }
        lbl1YearCalc.textAlignment = .Center
        lbl1YearCalc.font = UIFont.systemFontOfSize(9)
        self.viewGraphInner.addSubview(lbl1YearCalc)

        UIView.animateWithDuration(0.8, animations: {
            lbl1Year.frame = CGRect(x: 40, y: y1Year, width: 50, height: year1)
            }) { (true) in
        }
        
        
        
        
        let y10Year = Double(self.viewGraphInner.frame.size.height-year10.floatValue)
//        let lbl10Year = UILabel(frame: CGRect(x: 125, y: y10Year, width: 50, height: year10))
        let lbl10Year = UILabel(frame: CGRect(x: 125, y: y10Year+y10Year, width: 50, height: 0))
        lbl10Year.backgroundColor = UIColor.defaultGreenColor
        self.viewGraphInner.addSubview(lbl10Year)
        
        
        let lbl10YearCalc = UILabel(frame: CGRect(x: 125, y: y10Year-15, width: 50, height: 10))
        if let val = dic.valueForKey("1") {
            lbl10YearCalc.text = String(format: "%.0f", val as! Double)
            if (val as! Double)==0 {
                lbl10YearCalc.text = "NA"
            }

        }
        lbl10YearCalc.textAlignment = .Center
        lbl10YearCalc.font = UIFont.systemFontOfSize(9)
        self.viewGraphInner.addSubview(lbl10YearCalc)
        UIView.animateWithDuration(0.8, animations: {
            lbl10Year.frame = CGRect(x: 125, y: y10Year, width: 50, height: year10)
        }) { (true) in
        }

        
        
        
        
        
        let y20Year = Double(self.viewGraphInner.frame.size.height-year20.floatValue)
//        let lbl20Year = UILabel(frame: CGRect(x: 210, y: y20Year, width: 50, height: year20))
        let lbl20Year = UILabel(frame: CGRect(x: 210, y: y20Year+y20Year, width: 50, height: 0))
        lbl20Year.backgroundColor = UIColor.defaultGreenColor
        self.viewGraphInner.addSubview(lbl20Year)
        
        
        let lbl20YearCalc = UILabel(frame: CGRect(x: 210, y: y20Year-15, width: 50, height: 10))
        if let val = dic.valueForKey("2") {
            lbl20YearCalc.text = String(format: "%.0f", val as! Double)
            if (val as! Double)==0 {
                lbl20YearCalc.text = "NA"
            }

        }
        
        lbl20YearCalc.textAlignment = .Center
        lbl20YearCalc.font = UIFont.systemFontOfSize(9)
        self.viewGraphInner.addSubview(lbl20YearCalc)
        //        lbl20YearCalc.sizeToFit()
        
        UIView.animateWithDuration(0.8, animations: {
            lbl20Year.frame = CGRect(x: 210, y: y20Year, width: 50, height: year20)
        }) { (true) in
        }

    
        
        
        
    }

    
    
}
