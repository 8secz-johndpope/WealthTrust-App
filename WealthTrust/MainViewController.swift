//
//  ViewController.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 12/3/14.
//

import UIKit

class MainViewController: UIViewController,LTHPasscodeViewControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var viewWealthPort: UIView!
    
    @IBOutlet weak var viewMyPortfolio: UIView!
    
    var mainContens = ["data1", "data2", "data3", "data4", "data5", "data6", "data7", "data8", "data9", "data10", "data11", "data12", "data13", "data14", "data15"]
    
    @IBOutlet weak var btnAddManually: UIButton!
    
    @IBOutlet weak var lblCurrentVal: UILabel!
    
    @IBOutlet weak var lblWhatYouInvested: UILabel!
    
    @IBOutlet weak var lblWhatYouEarn: UILabel!
    
    
    @IBOutlet weak var imgArrowProfitLoss: UIImageView!
    
    let objDefault=NSUserDefaults.standardUserDefaults()
    
    var viewPortFload: UIView!
    @IBOutlet weak var btnPortFloadAdd: UIButton!
    
    var btnClose: UIButton!
    var btnUploadExisting: UIButton!
    var btnAddExisting: UIButton!
    var lblUploadExisting: UILabel!
    var lblAddExisting: UILabel!

    @IBOutlet weak var viewRateAndShare: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self .passcodeView()
        
        self.tableView.registerCellNib(DataTableViewCell.self)
        
        
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        self.title = "WealthTrust"
        let titleDict: NSDictionary = [NSFontAttributeName: UIFont.boldSystemFontOfSize(18),NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController!.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        
        // Change the navigation bar background color to blue.
        self.navigationController!.navigationBar.barTintColor = UIColor.defaultAppColorBlue

        if (sharedInstance.userDefaults.objectForKey(kToken) != nil) {
            print("Token IS : \(sharedInstance.userDefaults.objectForKey(kToken))")
            sharedInstance.SynchUsedInfo()
        }
        
        
        let systemVersion = UIDevice.currentDevice().systemVersion
        print("iOS \(systemVersion)")
        
        //iPhone or iPad
        let model = UIDevice.currentDevice().model
        print("device type=\(model)")
        
        
        self.generateFlotingMenu()
        
        
        viewRateAndShare.backgroundColor = UIColor(red:27/250, green:129/250, blue:224/250, alpha: 0.7)
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)

        
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: .None)

        self.setNavigationBarItem()
        
        self.updateTotalOnPortMenu()
        
//        let allUser = DBManager.getInstance().getAllUser()
//        if allUser.count==0
//        {
//
//            // Not Login....
//            self.viewWealthPort.hidden = true
//            self.viewMyPortfolio.hidden = false
//            
//            btnAddManually.layer.cornerRadius = 1.5
//            btnAddManually.layer.borderColor = UIColor.defaultOrangeButton.CGColor
//            btnAddManually.layer.borderWidth = 1.0
//
//        }else{
//            let objUser = allUser.objectAtIndex(0) as! User
//            sharedInstance.objLoginUser = objUser
//
//            self.viewWealthPort.hidden = false
//            self.viewMyPortfolio.hidden = true
//            
//            self.updateTotalOnPortMenu()
//        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func updateTotalOnPortMenu() {
        
        var arrWealthtrustPortfolio = NSMutableArray()
        var arrExistingPortfolio = NSMutableArray()

        var wealthPortTotal = 0.0
        var wealthPortInveTotal = 0.0
        var existingPortTotal = 0.0
        var existingPortInveTotal = 0.0
        
        
        
        let arrMFAccounts = DBManager.getInstance().getMFAccounts()
        if arrMFAccounts.count==0 {
        }else{
            arrWealthtrustPortfolio = arrMFAccounts
        }
        
        let arrManual = DBManager.getInstance().getManualMFAccounts()
        if arrManual.count==0 {
        }else{
            arrExistingPortfolio = arrManual
        }

        
        
        var portfolioTotal = ("0.0").doubleValue
        var totalInvestment = ("0.0").doubleValue
        
        for objMFAccount in arrWealthtrustPortfolio {
            let objMM = objMFAccount as! MFAccount
            
            let allUnits = (objMM.pucharseUnits as NSString).doubleValue
            let currentPrice = (objMM.CurrentNAV as NSString).doubleValue
            let ttlPurchase = (allUnits * currentPrice)
            
            portfolioTotal = portfolioTotal + ttlPurchase
            
            let allInvest = (objMM.InvestmentAmount as NSString).doubleValue
            totalInvestment = totalInvestment + allInvest
        }
        
        wealthPortTotal = portfolioTotal
        wealthPortInveTotal = totalInvestment
        

        // Existing Port
        var portfolioTotal1 = ("0.0").doubleValue
        var totalInvestment1 = ("0.0").doubleValue
        for objMFAccount in arrExistingPortfolio {
            let objMM = objMFAccount as! MFAccount
            
            let allUnits = (objMM.pucharseUnits as NSString).doubleValue
            let currentPrice = (objMM.CurrentNAV as NSString).doubleValue
            let ttlPurchase = (allUnits * currentPrice)
            
            portfolioTotal1 = portfolioTotal1 + ttlPurchase
            
            let allInvest = (objMM.InvestmentAmount as NSString).doubleValue
            totalInvestment1 = totalInvestment1 + allInvest
        }
        
        existingPortTotal = portfolioTotal1
        existingPortInveTotal = totalInvestment1

        
        
        
        
        let tot = (wealthPortTotal + existingPortTotal)
        let totInve = (wealthPortInveTotal + existingPortInveTotal)
        
        let earnedAmount =  tot - totInve
        print("Earned Amount \(earnedAmount)")
        
        
        
        if totInve==0 {
            
            self.viewWealthPort.hidden = true
            self.viewMyPortfolio.hidden = false
            
            btnAddManually.layer.cornerRadius = 1.5
            btnAddManually.layer.borderColor = UIColor.defaultOrangeButton.CGColor
            btnAddManually.layer.borderWidth = 1.0
            
        }else{
            
            self.viewWealthPort.hidden = false
            self.viewMyPortfolio.hidden = true
            
            let growth = (earnedAmount / totInve) * 100
            print("Growth \(growth)")
            let stringGroth = String(format: "%.1f", (earnedAmount / totInve) * 100)
            
            // GROWTH CALCULATED just need to display...
            self.lblCurrentVal.text = self.getFormatForDoublePrice(wealthPortTotal + existingPortTotal) + " | \(stringGroth)%"
            self.lblWhatYouInvested.text = self.getFormatForDoublePrice(wealthPortInveTotal + existingPortInveTotal)
            
            if earnedAmount>=0
            {
                self.lblWhatYouEarn.text = self.getFormatForDoublePrice(earnedAmount)
            }else{
                self.lblWhatYouEarn.text = "\(self.getFormatForDoublePrice(earnedAmount))"
            }
            
            let dbl = (stringGroth as NSString).doubleValue
            if dbl<0 {
                self.imgArrowProfitLoss.image = UIImage(named: "red_arrow")
            }else{
                self.imgArrowProfitLoss.image = UIImage(named: "green_arrow")
            }
        }
    }
    
    func getFormatForDoublePrice(doublePrice : Double) -> String {
        
        let num = NSNumber(double: doublePrice)
        let formatr : NSNumberFormatter = NSNumberFormatter()
        formatr.numberStyle = .CurrencyStyle
        formatr.locale = NSLocale(localeIdentifier: "en_IN")
        if let stringDT = formatr.stringFromNumber(num)
        {
            return stringDT
        }
        
        return ""
    }

   
    @IBAction func btnShareClicked(sender: AnyObject) {
        SharedManager.sharedInstance.uploadUserAction(USERACTIONTYPE.UA_SHARE_DASHBOARDBOTTOMBAR)
        
//        let img: UIImage = imageToShare
        let img = UIImage()
        let shareItems:Array = [img]
        //        var shareItems:Array = [img]
        let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        
//        activityViewController.excludedActivityTypes = [UIActivityType.postToWeibo, UIActivityType.copyToPasteboard, UIActivityType.addToReadingList, UIActivityType.postToVimeo]
        
        if let wPPC = activityViewController.popoverPresentationController {
            wPPC.sourceView = sender as? UIView
            //  or
            //            wPPC.barButtonItem = some bar button item
        }
        
        //        activityViewController.completionWithItemsHandler = {(activityType, completed:Bool, returnedItems:[AnyObject]?, error: NSError?) in
        //
        //            // Return if cancelled
        //            if (!completed) {
        //                return
        //            }
        //
        //            //activity complete
        //            //some code here
        //            self.createAndLoadInterstitial()
        //            Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(HomeScreen.loadAd), userInfo: nil, repeats: false)
        //        }
        
        self.presentViewController(activityViewController, animated: true) { 
            
        }

        
    }
    @IBAction func btnRateUsClicked(sender: AnyObject) {
        SharedManager.sharedInstance.uploadUserAction(USERACTIONTYPE.UA_RATEUS_DASHBOARDBOTTOMBAR)
        UIApplication.sharedApplication().openURL(NSURL(string: APP_URL)!)
    }


    @IBAction func btnPortFloadClicked(sender: AnyObject) {
        self.viewPortFload.hidden = false
        
    }
    
    @IBAction func btnPortCloseClicked(sender: AnyObject) {
        self.viewPortFload.hidden = true
    }
    
    @IBAction func btnPortUploadExistingClicked(sender: AnyObject) {
        print("AutiGenerate Clicked ")
        self.viewPortFload.hidden = true
        RootManager.sharedInstance.isFrom = IS_FROM.AutoGenerate
        RootManager.sharedInstance.navigateToScreen(self, data: [:])
        
    }
    
    @IBAction func btnPortAddExistingClicked(sender: AnyObject) {
        print("Add Existing Clicked ")
        self.viewPortFload.hidden = true
        
//        RootManager.sharedInstance.isFrom = IS_FROM.AddManuallyPortfolio
//        RootManager.sharedInstance.navigateToScreen(self, data: [:])
        
        let objUser = DBManager.getInstance().getLoggedInUserDetails()
        if objUser.SignupStatus == nil {
            print("Yes Blank....")
            
            let objUserLoginSignYp = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdUserLoginSignUp) as! UserLoginSignUp
            objUserLoginSignYp.isFrom = IS_FROM.AddManuallyPortfolio
            self.navigationController?.pushViewController(objUserLoginSignYp, animated: true)
            
        }
        else
        {
            
            sharedInstance.userDefaults .setObject(kEnterSchemeName, forKey: kSelectAddExistingScheme)
            let objAddPort = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdAddPortfolioManually) as! AddPortfolioManually
            self.navigationController?.pushViewController(objAddPort, animated: true)
        }

    }

    func generateFlotingMenu() {
        
        self.viewPortFload = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        self.viewPortFload.hidden = true
        self.viewPortFload.backgroundColor = UIColor(white: 1, alpha: 0.9)
        let win:UIWindow = UIApplication.sharedApplication().delegate!.window!!
        win.addSubview(self.viewPortFload)
        
        self.btnClose = UIButton(frame: CGRect(x: self.view.frame.size.width-75, y: self.view.frame.size.height-75, width: 50, height: 50))
        self.btnClose.backgroundColor = self.btnPortFloadAdd.backgroundColor
        self.btnClose.layer.cornerRadius = self.btnClose.frame.size.height/2
        self.btnClose.setTitle("X", forState: .Normal)
        self.btnClose.titleLabel?.font = UIFont.systemFontOfSize(15)
        self.btnClose.addTarget(self, action: #selector(self.btnPortCloseClicked(_:)), forControlEvents: .TouchUpInside)
        self.viewPortFload.addSubview(self.btnClose)
        
        self.btnUploadExisting = UIButton(frame: CGRect(x: self.view.frame.size.width-70, y: self.view.frame.size.height-135, width: 40, height: 40))
        self.btnUploadExisting.backgroundColor = UIColor.defaultGreenColor
        self.btnUploadExisting.layer.cornerRadius = self.btnUploadExisting.frame.size.height/2
        self.btnUploadExisting.addTarget(self, action: #selector(self.btnPortUploadExistingClicked(_:)), forControlEvents: .TouchUpInside)
        self.viewPortFload.addSubview(self.btnUploadExisting)
        
        self.btnUploadExisting.setImage(UIImage(named: "ic_file_upload_white"), forState: .Normal)
        
        self.lblUploadExisting = UILabel(frame: CGRect(x: self.view.frame.size.width-270, y: self.view.frame.size.height-135, width: 180, height: 40))
        lblUploadExisting.text = "Auto Generated Portfolio"
        self.lblUploadExisting.font = UIFont.systemFontOfSize(15)
        lblUploadExisting.textAlignment = .Right
        self.lblUploadExisting.backgroundColor = UIColor.whiteColor()
        self.viewPortFload.addSubview(self.lblUploadExisting)
        
        let btnUpExisting = UIButton(frame: CGRect(x: self.view.frame.size.width-270, y: self.view.frame.size.height-135, width: 180, height: 40))
        btnUpExisting.addTarget(self, action: #selector(self.btnPortUploadExistingClicked(_:)), forControlEvents: .TouchUpInside)
        self.viewPortFload.addSubview(btnUpExisting)
        
        self.btnAddExisting = UIButton(frame: CGRect(x: self.view.frame.size.width-70, y: self.view.frame.size.height-195, width: 40, height: 40))
        self.btnAddExisting.backgroundColor = UIColor.defaultAppColorBlue
        self.btnAddExisting.layer.cornerRadius = self.btnAddExisting.frame.size.height/2
        self.btnAddExisting.addTarget(self, action: #selector(self.btnPortAddExistingClicked(_:)), forControlEvents: .TouchUpInside)
        self.viewPortFload.addSubview(self.btnAddExisting)
        self.btnAddExisting.setImage(UIImage(named: "slide_portfolio"), forState: .Normal)
        
        self.lblAddExisting = UILabel(frame: CGRect(x: self.view.frame.size.width-270, y: self.view.frame.size.height-195, width: 180, height: 40))
        lblAddExisting.text = "Add Portfolio"
        self.lblAddExisting.font = UIFont.systemFontOfSize(15)
        lblAddExisting.textAlignment = .Right
        self.lblAddExisting.backgroundColor = UIColor.whiteColor()
        self.viewPortFload.addSubview(self.lblAddExisting)
        
        let btnAdExisting = UIButton(frame: CGRect(x: self.view.frame.size.width-270, y: self.view.frame.size.height-195, width: 180, height: 40))
        btnAdExisting.addTarget(self, action: #selector(self.btnPortAddExistingClicked(_:)), forControlEvents: .TouchUpInside)
        self.viewPortFload.addSubview(btnAdExisting)
        
        
        SharedManager.addShadow(self.btnPortFloadAdd)
        SharedManager.addShadow(self.btnClose)
        SharedManager.addShadow(self.btnUploadExisting)
        SharedManager.addShadow(self.btnAddExisting)

        
    }
    
    @IBAction func btnMyPortfolioClicked(sender: AnyObject) {
//        print("My Port clicked")
        let portfolioController = storyboard!.instantiateViewControllerWithIdentifier("PortfolioScreen") as! PortfolioScreen
        portfolioController.isFrom = "Dashboard"
        self.navigationController?.pushViewController(portfolioController, animated: true)
    }
    
    @IBAction func btnMyOrdersClicked(sender: UIButton) {
        print("My Orders Clicked...")
        sender.backgroundColor = UIColor.clearColor()
        print(self.navigationController)
        print(self.navigationController?.viewControllers)
        
        let allUser = DBManager.getInstance().getAllUser()
        if allUser.count==0
        {
            SharedManager.invokeAlertMethod(APP_NAME, strBody: "Please do login first", delegate: nil)
            
        }else{
            let objUser = allUser.objectAtIndex(0) as! User
            sharedInstance.objLoginUser = objUser
            
            let objMyOrder = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdMyOrders) as! MyOrders
            
            self.navigationController!.pushViewController(objMyOrder, animated: true)
        }
    }
    
//    TopFundsScreen
    
    @IBAction func btnTooFundsClicked(sender: UIButton) {
        sender.backgroundColor = UIColor.clearColor()
        RootManager.sharedInstance.navigateToTopFundScreen(self)
    }
    
    @IBAction func btnSmartSavingClicked(sender: UIButton) {
        sender.backgroundColor = UIColor.clearColor()
        RootManager.sharedInstance.isFrom = IS_FROM.SmartSavings
        RootManager.sharedInstance.navigateToScreen(self, data: [:])
    }
    
    @IBAction func btnDirectSavingCalcClicked(sender: UIButton) {
        sender.backgroundColor = UIColor.clearColor()
        RootManager.sharedInstance.navigateToDirectSavingCalcScreen(self)
    }
    
    
    @IBAction func btnSwitchToDireClicked(sender: UIButton) {
        sender.backgroundColor = UIColor.clearColor()
        RootManager.sharedInstance.isFrom = IS_FROM.SwitchToDirect
        RootManager.sharedInstance.navigateToScreen(self, data: [:])
    }
    
    @IBAction func btnInvestClickef(sender: UIButton) {
        sender.backgroundColor = UIColor.clearColor()
        RootManager.sharedInstance.isFrom = IS_FROM.BuySIP
        RootManager.sharedInstance.navigateToScreen(self, data: [:])
    }
    
    func passcodeView() {
        
        if objDefault.valueForKey("passcode") != nil {
            LTHPasscodeViewController.sharedUser().delegate = self
            LTHPasscodeViewController.sharedUser().showForEnablingPasscodeInViewController(self, asModal: true)
        }
    }
    
    @IBAction func btnTouchDown(sender: UIButton) {
        sender.backgroundColor = UIColor(white: 1, alpha: opacityButtonTouchEffect)
    }
    @IBAction func btnTouchDragEnter(sender: UIButton) {
        sender.backgroundColor = UIColor(white: 1, alpha: opacityButtonTouchEffect)
    }
    @IBAction func btnTouchDragExit(sender: UIButton) {
        sender.backgroundColor = UIColor.clearColor()
    }
    
}


extension MainViewController : UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return DataTableViewCell.height()
    }
}

extension MainViewController : UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mainContens.count
    }
     
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier(DataTableViewCell.identifier) as! DataTableViewCell
        let data = DataTableViewCellData(imageUrl: "dummy", text: mainContens[indexPath.row])
        cell.setData(data)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        let storyboard = UIStoryboard(name: "SubContentsViewController", bundle: nil)
//        let subContentsVC = storyboard.instantiateViewControllerWithIdentifier("SubContentsViewController") as! SubContentsViewController
//        self.navigationController?.pushViewController(subContentsVC, animated: true)
    }
}

extension MainViewController : SlideMenuControllerDelegate {
    
    func leftWillOpen() {
        print("SlideMenuControllerDelegate: leftWillOpen")
    }
    
    func leftDidOpen() {
        print("SlideMenuControllerDelegate: leftDidOpen")
    }
    
    func leftWillClose() {
        print("SlideMenuControllerDelegate: leftWillClose")
    }
    
    func leftDidClose() {
        print("SlideMenuControllerDelegate: leftDidClose")
    }
    
    func rightWillOpen() {
        print("SlideMenuControllerDelegate: rightWillOpen")
    }
    
    func rightDidOpen() {
        print("SlideMenuControllerDelegate: rightDidOpen")
    }
    
    func rightWillClose() {
        print("SlideMenuControllerDelegate: rightWillClose")
    }
    
    func rightDidClose() {
        print("SlideMenuControllerDelegate: rightDidClose")
    }
}




