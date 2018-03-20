//
//  DirectSavingCalcScreen.swift
//  WealthTrust
//
//  Created by Hemen Gohil on 11/29/16.
//  Copyright © 2016 Hemen Gohil. All rights reserved.
//

import UIKit

class DirectSavingCalcScreen: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var viewBack: UIView!
    
    
    @IBOutlet weak var txtPrice: UITextField!
    
    @IBOutlet weak var lblYouWillSave: UILabel!
    
    
    @IBOutlet weak var btnInvest: UIButton!
    
    
    @IBOutlet weak var viewGraphInner: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        SharedManager.addShadowToView(self.viewBack)
        
        btnInvest.layer.cornerRadius = 1.5
        btnInvest.layer.borderColor = UIColor.defaultOrangeButton.CGColor
        btnInvest.layer.borderWidth = 1.0

        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.txtPrice.text = "50000"
            self.getDataSet(Double(self.txtPrice.text!)!)

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func btnBLClicked(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func btnKnowMoreClicked(sender: AnyObject) {
        let objWebView = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdWebViewController) as! WebViewController
        
        objWebView.urlLink = NSURL(string:URL_KNOW_MORE)!
        objWebView.screenTitle = "Direct Plan - Savings"
        self.navigationController?.pushViewController(objWebView, animated: true)
        
    }
    @IBAction func btnCalculateExtraSav(sender: AnyObject) {
        
        
        if self.txtPrice.text?.length==0 {
            
        }else{
            self.getDataSet(Double(self.txtPrice.text!)!)
        }
        
        
        self.txtPrice.resignFirstResponder()

    }
    @IBAction func btnSwitchNow(sender: AnyObject) {
        self.txtPrice.resignFirstResponder()

        print("Switch Clicked")
        
        sharedInstance.userDefaults .setObject("Select Fund", forKey: kSelectFromFundValue)
        sharedInstance.userDefaults .setObject("Select Fund", forKey: kSelectToFundValue)
        
        let objSwitchScreen = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdSwitchScreen) as! SwitchScreen
        self.navigationController?.pushViewController(objSwitchScreen, animated: true)
        
        
    }
    @IBAction func btnInvestNowClicked(sender: AnyObject) {
        self.txtPrice.resignFirstResponder()
        
        print("Buy/SIP Clicked")
        
        sharedInstance.userDefaults .setObject(kEnterSchemeName, forKey: kSelectBuyNowScheme)
        
        let objBuyScreen = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdBuyScreeen) as! BuyScreeen
        self.navigationController?.pushViewController(objBuyScreen, animated: true)
        
    }
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        print("TextField did begin editing method called")
        
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
        
        return true;
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        print("TextField should return method called")
        
        textField.resignFirstResponder();
        return true;
    }

    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print("Screen Touch")
        
        self.txtPrice.resignFirstResponder()
    }
    
    
//    func getDataSet(directSavingsValue : Double) {
//        
//        let dic = NSMutableDictionary()
//        
//        for index in 1.stride(to: 5, by: 1).reverse()
//        {
//            var j = 1
//            
//            switch index {
//            case 1:
//                j = 1
//                break
//            case 2:
//                j = 10
//                break
//            case 3:
//                j = 20
//                break
//            case 4:
//                j = 30
//                break
//                
//            default:
//                break
//            }
//            
//            let power1 = pow(1.13, Double(j))
//            let power2 = pow(1.12, Double(j))
//            
//            let diffValueByYear = (directSavingsValue * power1) - (directSavingsValue * power2)
//            
//            dic.setValue(diffValueByYear, forKey: "\(index-1)")
//        }
//        
//        print("Generated : \(dic)")
//    }
    
    
    func getDataSet(directSavingsValue : Double) {
        
        let dic = NSMutableDictionary()
        
        
        var totalAll = 0.0
        
        for index in 1.stride(to: 5, by: 1).reverse()
        {
            var j = 1
            
            switch index {
            case 1:
                j = 1
                break
            case 2:
                j = 10
                break
            case 3:
                j = 20
                break
            case 4:
                j = 30
                break
                
            default:
                break
            }
            
            let power1 = pow(1.13, Double(j))
            let power2 = pow(1.12, Double(j))
            
            let diffValueByYear = (directSavingsValue * power1) - (directSavingsValue * power2)
            
            dic.setValue(diffValueByYear, forKey: "\(index-1)")
            
            
            totalAll = totalAll + diffValueByYear
        }
        
        print("Generated : \(dic)")
        print("Total Of All : \(totalAll)")
        
        
        let year1 = ((dic.valueForKey("0")?.doubleValue)!/totalAll)*100
        let year10 = ((dic.valueForKey("1")?.doubleValue)!/totalAll)*100
        let year20 = ((dic.valueForKey("2")?.doubleValue)!/totalAll)*100
        let year30 = ((dic.valueForKey("3")?.doubleValue)!/totalAll)*100
        
        print("1 Year : \(year1)")
        print("10 Year : \(year10)")
        print("20 Year : \(year20)")
        print("30 Year : \(year30)")
        
        
        
        self.viewGraphInner.subviews.forEach({ $0.removeFromSuperview() }) // this gets things done
        
        
        
        let y1Year = Double(self.viewGraphInner.frame.size.height-year1.floatValue)
//        let lbl1Year = UILabel(frame: CGRect(x: 15, y: y1Year, width: 45, height: year1))
        let lbl1Year = UILabel(frame: CGRect(x: 15, y: y1Year+year1, width: 45, height: 0))
        lbl1Year.backgroundColor = UIColor.defaultGreenColor
        self.viewGraphInner.addSubview(lbl1Year)
        
        let lbl1YearCalc = UILabel(frame: CGRect(x: 15, y: y1Year-15, width: 45, height: 10))
        if let val = dic.valueForKey("0") {
            lbl1YearCalc.text = String(format: "%.0f", val as! Double)
        }
        lbl1YearCalc.textAlignment = .Center
        lbl1YearCalc.font = UIFont.systemFontOfSize(9)
        self.viewGraphInner.addSubview(lbl1YearCalc)

        UIView.animateWithDuration(0.8, animations: {
            lbl1Year.frame = CGRect(x: 15, y: y1Year, width: 45, height: year1)
        }) { (true) in
        }

        
        
        let y10Year = Double(self.viewGraphInner.frame.size.height-year10.floatValue)
//        let lbl10Year = UILabel(frame: CGRect(x: 90, y: y10Year, width: 45, height: year10))
        let lbl10Year = UILabel(frame: CGRect(x: 90, y: y10Year+year10, width: 45, height: 0))
        lbl10Year.backgroundColor = UIColor.defaultGreenColor
        
        self.viewGraphInner.addSubview(lbl10Year)
        
        
        let lbl10YearCalc = UILabel(frame: CGRect(x: 90, y: y10Year-15, width: 45, height: 10))
        if let val = dic.valueForKey("1") {
            lbl10YearCalc.text = String(format: "%.0f", val as! Double)
            
        }
        lbl10YearCalc.textAlignment = .Center
        lbl10YearCalc.font = UIFont.systemFontOfSize(9)
        self.viewGraphInner.addSubview(lbl10YearCalc)

        UIView.animateWithDuration(0.8, animations: {
            lbl10Year.frame = CGRect(x: 90, y: y10Year, width: 45, height: year10)
        }) { (true) in
        }

        
        
        let y20Year = Double(self.viewGraphInner.frame.size.height-year20.floatValue)
//        let lbl20Year = UILabel(frame: CGRect(x: 165, y: y20Year, width: 45, height: year20))
        let lbl20Year = UILabel(frame: CGRect(x: 165, y: y20Year+year20, width: 45, height: 0))

        lbl20Year.backgroundColor = UIColor.defaultGreenColor
        self.viewGraphInner.addSubview(lbl20Year)
        
        
        let lbl20YearCalc = UILabel(frame: CGRect(x: 165, y: y20Year-15, width: 45, height: 10))
        if let val = dic.valueForKey("2") {
            lbl20YearCalc.text = String(format: "%.0f", val as! Double)
            
        }
        lbl20YearCalc.textAlignment = .Center
        lbl20YearCalc.font = UIFont.systemFontOfSize(9)
        self.viewGraphInner.addSubview(lbl20YearCalc)
        //        lbl20YearCalc.sizeToFit()
        UIView.animateWithDuration(0.8, animations: {
            lbl20Year.frame = CGRect(x: 165, y: y20Year, width: 45, height: year20)
        }) { (true) in
        }
        
        let y30Year = Double(self.viewGraphInner.frame.size.height-year30.floatValue)
//        let lbl30Year = UILabel(frame: CGRect(x: 240, y: y30Year, width: 45, height: year30))
        let lbl30Year = UILabel(frame: CGRect(x: 240, y: y30Year+year30, width: 45, height: 0))
        lbl30Year.backgroundColor = UIColor.defaultGreenColor
        self.viewGraphInner.addSubview(lbl30Year)
        
        
        let lbl30YearCalc = UILabel(frame: CGRect(x: 240, y: y30Year-15, width: 45, height: 10))
        if let val = dic.valueForKey("3") {
            lbl30YearCalc.text = String(format: "%.0f", val as! Double)
        }
        lbl30YearCalc.textAlignment = .Center
        lbl30YearCalc.font = UIFont.systemFontOfSize(9)
        self.viewGraphInner.addSubview(lbl30YearCalc)
        //        lbl30YearCalc.sizeToFit()
        UIView.animateWithDuration(0.8, animations: {
            lbl30Year.frame = CGRect(x: 240, y: y30Year, width: 45, height: year30)
        }) { (true) in
        }
        

    }

    
}
