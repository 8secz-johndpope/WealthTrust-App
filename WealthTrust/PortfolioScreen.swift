//
//  PortfolioScreen.swift
//  WealthTrust
//
//  Created by Hemen Gohil on 11/5/16.
//  Copyright © 2016 Hemen Gohil. All rights reserved.
//

import UIKit

class PortfolioScreen: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tblView: UITableView!

    var arrWealthtrustPortfolio = NSMutableArray()
    var arrExistingPortfolio = NSMutableArray()
    
    var isWealthTrustPortfolioAvailable = false
    var isExistingPortfolioAvailable = false
    
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var lblPortfolioGrandTotal: UILabel!
    @IBOutlet weak var lblPortfolioGrandInveTotal: UILabel!
    
    var imageupDown = UIImageView()
    
    var wealthPortTotal = 0.0
    var wealthPortInveTotal = 0.0
    var existingPortTotal = 0.0
    var existingPortInveTotal = 0.0

    @IBOutlet weak var lblMessage: UILabel!
    
    var viewPortFload: UIView!
    @IBOutlet weak var btnPortFloadAdd: UIButton!
    
    var btnClose: UIButton!
    var btnUploadExisting: UIButton!
    var btnAddExisting: UIButton!
    var lblUploadExisting: UILabel!
    var lblAddExisting: UILabel!
    
    
    @IBOutlet weak var btnBackTo: UIButton!
    @IBOutlet weak var btnSearch: UIButton!

    var isFrom = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        self.title = "Portfolio"
        let titleDict: NSDictionary = [NSFontAttributeName: UIFont.boldSystemFontOfSize(18),NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController!.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        
        // Change the navigation bar background color to blue.
        self.navigationController!.navigationBar.barTintColor = UIColor.defaultAppColorBlue

        
        lblPortfolioGrandTotal.text = "\(self.getFormatForDoublePrice(0))"
        lblPortfolioGrandInveTotal.text = "You invested: \(self.getFormatForDoublePrice(0))"

        lblMessage.hidden = true
        
        
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

        
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if isFrom == "AddManuallyPortfolio" {
            self.tblView.setContentOffset(CGPointMake(0, self.tblView.contentSize.height - self.tblView.frame.size.height), animated: true)
            self.tblView.reloadData()
        }
        
    }
    @IBAction func btnBackToClicked(sender: AnyObject) {
        
        if isFrom == "Dashboard" {
            self.navigationController?.popViewControllerAnimated(true)
        }
        else if isFrom == "AddManuallyPortfolio"
        {
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
        else{
            self.slideMenuController()?.openLeft()
        }
        
    }
    
    
    @IBAction func btnSearchClicked(sender: AnyObject) {
        
        let objSearch = self.storyboard?.instantiateViewControllerWithIdentifier(ksbidSearchScreen) as! SearchScreen
        self.navigationController?.pushViewController(objSearch, animated: true)

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
//        tblView.setContentOffset(CGPointMake(0.0, CGFloat(MAXFLOAT)), animated: true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.navigationController!.navigationBar.barTintColor = UIColor.defaultAppColorBlue
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()


        if isFrom == "Dashboard" {
            
//            self.addBackArrowButtonWithImage(UIImage(named: "iconBack")!)
//            
//            self.addRightBarButtonWithImageForPortfolio(UIImage(named: "ic_search_white")!)
//            
//            self.slideMenuController()?.removeLeftGestures()
//            self.slideMenuController()?.removeRightGestures()
//            self.slideMenuController()?.addLeftGestures()

            if let image = UIImage(named: "iconBack") {
                self.btnBackTo.setImage(image, forState: .Normal)
            }
            
            
        }
            else if isFrom == "AddManuallyPortfolio"
        {
            if let image = UIImage(named: "iconBack")
            {
                self.btnBackTo.setImage(image, forState: .Normal)
            }
        }
        else
        {
            
//            if let image = UIImage(named: "ic_menu_black_24dp")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate) {
//                self.btnBackTo.setImage(image, forState: .Normal)
//                self.btnBackTo.tintColor = UIColor.whiteColor()
//
//            }

            
            let image = UIImage(named: "ic_menu_black_24dp")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)

            self.btnBackTo.setImage(image, forState: .Normal)
            self.btnBackTo.tintColor = UIColor.whiteColor()

//            self.setNavigationBarItemLeftForPortfolioScreen()
        }

        
        
//        let image = UIImage(named: "ic_search_white")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
//        self.btnSearch.setImage(image, forState: .Normal)
        
        
        let arrMFAccounts = DBManager.getInstance().getMFAccounts()
        if arrMFAccounts.count==0 {
            isWealthTrustPortfolioAvailable = false
        }else{
            isWealthTrustPortfolioAvailable = true
            arrWealthtrustPortfolio = arrMFAccounts
        }
        
        let arrManual = DBManager.getInstance().getManualMFAccounts()
        if arrManual.count==0 {
            isExistingPortfolioAvailable = false
        }else{
            isExistingPortfolioAvailable = true
            arrExistingPortfolio = arrManual
        }
        
        self.updateTotalWealth()
        self.updateTotalExisting()
        self.updateHeaderTotal()
        
        if arrWealthtrustPortfolio.count==0 && arrExistingPortfolio.count==0 {
//            viewHeader.hidden = true
            lblMessage.hidden = false
            
        }else
        {
            lblMessage.hidden = true
            viewHeader.hidden = false
        }
        
        self.tblView.reloadData()
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

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if isWealthTrustPortfolioAvailable {
            if isExistingPortfolioAvailable {
                return 2
            }else{
                return 1
            }
        }else{
            if isExistingPortfolioAvailable {
                return 1
            }else{
                return 0
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isWealthTrustPortfolioAvailable {
            if isExistingPortfolioAvailable {
                if section==0
                {
                    return arrWealthtrustPortfolio.count
                }else{
                    return arrExistingPortfolio.count
                }
            }else{
                return arrWealthtrustPortfolio.count
            }
        }else{
            if isExistingPortfolioAvailable {
                return arrExistingPortfolio.count
            }else{
                return 0
            }
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "CELL_FOR_\(isWealthTrustPortfolioAvailable)_\(isExistingPortfolioAvailable)_\(arrExistingPortfolio.count)_\(arrWealthtrustPortfolio.count)_\(indexPath.section)_\(indexPath.row)")
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CELL_FOR_\(isWealthTrustPortfolioAvailable)_\(isExistingPortfolioAvailable)_\(arrExistingPortfolio.count)_\(arrWealthtrustPortfolio.count)_\(indexPath.section)_\(indexPath.row)", forIndexPath: indexPath) as UITableViewCell
        
        if isWealthTrustPortfolioAvailable {
            if isExistingPortfolioAvailable {
                
                if indexPath.section==0
                {
                    // Wealthtrust Port Implementation....
                    
                    if (cell.contentView.subviews.count==0) {
                        
                        var lblLineTop : UILabel!
                        lblLineTop = UILabel(frame: CGRect(x: 10, y: 0, width: (cell.contentView.frame.size.width)-20, height: 0.5));
                        lblLineTop.backgroundColor = UIColor.lightGrayColor()
                        cell.contentView.addSubview(lblLineTop)

                        var lblLineLeft : UILabel!
                        lblLineLeft = UILabel(frame: CGRect(x: 10, y: 0, width: 0.5, height: cell.contentView.frame.size.height));
                        lblLineLeft.backgroundColor = UIColor.lightGrayColor()
                        cell.contentView.addSubview(lblLineLeft)

                        var lblLineRigth : UILabel!
                        lblLineRigth = UILabel(frame: CGRect(x: (cell.contentView.frame.size.width)-11, y: 0, width: 0.5, height: cell.contentView.frame.size.height));
                        lblLineRigth.backgroundColor = UIColor.lightGrayColor()
                        cell.contentView.addSubview(lblLineRigth)

                        let objMFAccountDetails = arrWealthtrustPortfolio.objectAtIndex(indexPath.row) as! MFAccount
                        
                        var lblName : UILabel!
                        lblName = UILabel(frame: CGRect(x: 10, y: 5, width: (cell.contentView.frame.size.width)-20, height: 35));
                        
                        let Namee = objMFAccountDetails.AmcName.stringByReplacingOccurrencesOfString("Mutual Fund", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                        lblName.text = Namee
                        lblName.font = UIFont.systemFontOfSize(20)
                        lblName.textColor = UIColor.blackColor()
                        lblName.textAlignment = .Center
                        cell.contentView.addSubview(lblName)
                        
                        
                        let btnMore = UIButton(frame: CGRect(x: (cell.contentView.frame.size.width)-45, y: 5, width: 35, height: 35))
                        btnMore.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                        btnMore.backgroundColor = UIColor.whiteColor()
                        btnMore.titleLabel?.font = UIFont.systemFontOfSize(14)
                        btnMore.setImage(UIImage(named: "more"), forState: .Normal)
                        btnMore.layer.cornerRadius = 1.5
                        btnMore.tag = indexPath.row
                        btnMore.addTarget(self, action: #selector(PortfolioScreen.btnWealthMoreClicked(_:)), forControlEvents: .TouchUpInside)
                        cell.contentView.addSubview(btnMore)
                        
                        var lblPrice : UILabel!
                        lblPrice = UILabel(frame: CGRect(x: 10, y: 40, width: (cell.contentView.frame.size.width)-30, height: 35));
                        
                        let allUnits = (objMFAccountDetails.pucharseUnits as NSString).doubleValue
                        let currentPrice = (objMFAccountDetails.CurrentNAV as NSString).doubleValue

                        let num = NSNumber(double: (allUnits * currentPrice))
                        let formatr : NSNumberFormatter = NSNumberFormatter()
                        formatr.numberStyle = .CurrencyStyle
                        formatr.locale = NSLocale(localeIdentifier: "en_IN")
                        if let stringDT = formatr.stringFromNumber(num)
                        {
                            lblPrice.text = stringDT
                        }

                        lblPrice.font = UIFont.systemFontOfSize(19)
                        lblPrice.textColor = UIColor.defaultGreenColor
                        lblPrice.textAlignment = .Right
                        cell.contentView.addSubview(lblPrice)
                        
                        var lblFundName : UILabel!
                        lblFundName = UILabel(frame: CGRect(x: 15, y: 40, width: (cell.contentView.frame.size.width/2), height: 35));
                        lblFundName.text = objMFAccountDetails.SchemeName
                        lblFundName.font = UIFont.systemFontOfSize(13)
                        lblFundName.textColor = UIColor.darkGrayColor()
                        lblFundName.textAlignment = .Left
                        cell.contentView.addSubview(lblFundName)
                        
                        
                        var lblFolio : UILabel!
                        lblFolio = UILabel(frame: CGRect(x: 15, y: 75, width: 90, height: 20));
                        let last4 = String(objMFAccountDetails.FolioNo.characters.suffix(4))
                        lblFolio.text = "Folio: X- \(last4)"
                        lblFolio.font = UIFont.systemFontOfSize(13)
                        lblFolio.textColor = UIColor.darkGrayColor()
                        lblFolio.textAlignment = .Left
                        
                        if last4=="" {
                        }else{
                            cell.contentView.addSubview(lblFolio)
                        }

                        
                        var lblasOn : UILabel!
                        lblasOn = UILabel(frame: CGRect(x: 105, y: 75, width: (cell.contentView.frame.size.width)-145, height: 20));
                        if let dt = objMFAccountDetails.NAVDate {
                            if dt == "<null>" {
                                
                            }else{
                                
                                let currentNav = (objMFAccountDetails.CurrentNAV as NSString).doubleValue
                                let purchaseNav = (objMFAccountDetails.puchaseNAV as NSString).doubleValue
                                let growth = ((currentNav/purchaseNav)-1) * 100
                                var twoDecimalPlaces = String(format: "%.1f", growth)

                                var imgArrow : UIImageView!
                                imgArrow = UIImageView(frame: CGRect(x: (cell.contentView.frame.size.width)-35, y: 75, width:20 , height: 20));
                                
                                let dbl = (twoDecimalPlaces as NSString).doubleValue
                                if dbl<0 {
                                    imgArrow.image = UIImage(named: "red_arrow")
                                    
                                    twoDecimalPlaces = String(format: "%.1f", (dbl*(-1)))
                                }else{
                                    imgArrow.image = UIImage(named: "green_arrow")
                                    
                                }
                                cell.contentView.addSubview(imgArrow)

                                
                                lblasOn.text = "As on: \(sharedInstance.getFormatedDate(objMFAccountDetails.NAVDate)) | \(twoDecimalPlaces) %"
                                
                                
                            }
                        }
                        lblasOn.font = UIFont.systemFontOfSize(13)
                        lblasOn.textColor = UIColor.darkGrayColor()
                        lblasOn.textAlignment = .Right
                        cell.contentView.addSubview(lblasOn)
                        
                        cell.selectionStyle = UITableViewCellSelectionStyle.None
                        return cell
                    }
                    
                }else{
                    
                    // Existing Port Implementation....
                    if (cell.contentView.subviews.count==0) {
                        
                        var lblLineTop : UILabel!
                        lblLineTop = UILabel(frame: CGRect(x: 10, y: 0, width: (cell.contentView.frame.size.width)-20, height: 0.5));
                        lblLineTop.backgroundColor = UIColor.lightGrayColor()
                        cell.contentView.addSubview(lblLineTop)
                        
                        var lblLineLeft : UILabel!
                        lblLineLeft = UILabel(frame: CGRect(x: 10, y: 0, width: 0.5, height: cell.contentView.frame.size.height));
                        lblLineLeft.backgroundColor = UIColor.lightGrayColor()
                        cell.contentView.addSubview(lblLineLeft)
                        
                        var lblLineRigth : UILabel!
                        lblLineRigth = UILabel(frame: CGRect(x: (cell.contentView.frame.size.width)-11, y: 0, width: 0.5, height: cell.contentView.frame.size.height));
                        lblLineRigth.backgroundColor = UIColor.lightGrayColor()
                        cell.contentView.addSubview(lblLineRigth)
                        
                        
                        let objMFAccountDetails = arrExistingPortfolio.objectAtIndex(indexPath.row) as! MFAccount
                        
                        var lblName : UILabel!
                        lblName = UILabel(frame: CGRect(x: 10, y: 5, width: (cell.contentView.frame.size.width)-20, height: 35));
                        
                        let Namee = objMFAccountDetails.AmcName.stringByReplacingOccurrencesOfString("Mutual Fund", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                        lblName.text = Namee
                        lblName.font = UIFont.systemFontOfSize(20)
                        lblName.textColor = UIColor.blackColor()
                        lblName.textAlignment = .Center
                        cell.contentView.addSubview(lblName)
                        
                        
                        let btnMore = UIButton(frame: CGRect(x: (cell.contentView.frame.size.width)-45, y: 5, width: 35, height: 35))
                        btnMore.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                        btnMore.backgroundColor = UIColor.whiteColor()
                        btnMore.titleLabel?.font = UIFont.systemFontOfSize(14)
                        btnMore.setImage(UIImage(named: "more"), forState: .Normal)
                        btnMore.layer.cornerRadius = 1.5
                        btnMore.tag = indexPath.row
                        btnMore.addTarget(self, action: #selector(PortfolioScreen.btnExistingMoreClicked(_:)), forControlEvents: .TouchUpInside)
                        cell.contentView.addSubview(btnMore)

                        
                        var lblPrice : UILabel!
                        lblPrice = UILabel(frame: CGRect(x: 10, y: 40, width: (cell.contentView.frame.size.width)-30, height: 35));
                        
                        let allUnits = (objMFAccountDetails.pucharseUnits as NSString).doubleValue
                        let currentPrice = (objMFAccountDetails.CurrentNAV as NSString).doubleValue
                        
                        let num = NSNumber(double: (allUnits * currentPrice))
                        let formatr : NSNumberFormatter = NSNumberFormatter()
                        formatr.numberStyle = .CurrencyStyle
                        formatr.locale = NSLocale(localeIdentifier: "en_IN")
                        if let stringDT = formatr.stringFromNumber(num)
                        {
                            lblPrice.text = stringDT
                        }
                        
                        lblPrice.font = UIFont.systemFontOfSize(19)
                        lblPrice.textColor = UIColor.defaultGreenColor
                        lblPrice.textAlignment = .Right
                        cell.contentView.addSubview(lblPrice)
                        
                        
                        var lblFundName : UILabel!
                        lblFundName = UILabel(frame: CGRect(x: 15, y: 40, width: (cell.contentView.frame.size.width/2), height: 35));
                        lblFundName.text = objMFAccountDetails.SchemeName
                        lblFundName.font = UIFont.systemFontOfSize(13)
                        lblFundName.textColor = UIColor.darkGrayColor()
                        lblFundName.textAlignment = .Left
                        cell.contentView.addSubview(lblFundName)
                        
                        var lblFolio : UILabel!
                        lblFolio = UILabel(frame: CGRect(x: 15, y: 75, width: 90, height: 20));
                        let last4 = String(objMFAccountDetails.FolioNo.characters.suffix(4))
                        lblFolio.text = "Folio: X- \(last4)"
                        lblFolio.font = UIFont.systemFontOfSize(13)
                        lblFolio.textColor = UIColor.darkGrayColor()
                        lblFolio.textAlignment = .Left
                        if last4=="" {
                        }else{
                            cell.contentView.addSubview(lblFolio)
                        }

                        
                        var lblasOn : UILabel!
                        lblasOn = UILabel(frame: CGRect(x: 105, y: 75, width: (cell.contentView.frame.size.width)-145, height: 20));
                        
                        if let dt = objMFAccountDetails.NAVDate {

                            if dt == "<null>" {
                            }
                            else
                            {
                                let currentNav = (objMFAccountDetails.CurrentNAV as NSString).doubleValue
                                let purchaseNav = (objMFAccountDetails.puchaseNAV as NSString).doubleValue
                                let growth = ((currentNav/purchaseNav)-1) * 100
                                var twoDecimalPlaces = String(format: "%.1f", growth)
                                
                                var imgArrow : UIImageView!
                                imgArrow = UIImageView(frame: CGRect(x: (cell.contentView.frame.size.width)-35, y: 75, width:20 , height: 20));
                                
                                let dbl = (twoDecimalPlaces as NSString).doubleValue
                                if dbl<0 {
                                    imgArrow.image = UIImage(named: "red_arrow")
                                    
                                    twoDecimalPlaces = String(format: "%.1f", (dbl*(-1)))

                                }else{
                                    imgArrow.image = UIImage(named: "green_arrow")
                                }
                                cell.contentView.addSubview(imgArrow)
                                
                                lblasOn.text = "As on: \(sharedInstance.getFormatedDate(objMFAccountDetails.NAVDate)) | \(twoDecimalPlaces) %"

                            }
                            
                        }
                        
                        lblasOn.font = UIFont.systemFontOfSize(13)
                        lblasOn.textColor = UIColor.darkGrayColor()
                        lblasOn.textAlignment = .Right
                        cell.contentView.addSubview(lblasOn)

                        cell.selectionStyle = UITableViewCellSelectionStyle.None
                        return cell

                    }
                }

            }else{
                // Wealthtrust Port Implementation....

                if (cell.contentView.subviews.count==0) {
                    
                    var lblLineTop : UILabel!
                    lblLineTop = UILabel(frame: CGRect(x: 10, y: 0, width: (cell.contentView.frame.size.width)-20, height: 0.5));
                    lblLineTop.backgroundColor = UIColor.lightGrayColor()
                    cell.contentView.addSubview(lblLineTop)
                    
                    var lblLineLeft : UILabel!
                    lblLineLeft = UILabel(frame: CGRect(x: 10, y: 0, width: 0.5, height: cell.contentView.frame.size.height));
                    lblLineLeft.backgroundColor = UIColor.lightGrayColor()
                    cell.contentView.addSubview(lblLineLeft)
                    
                    var lblLineRigth : UILabel!
                    lblLineRigth = UILabel(frame: CGRect(x: (cell.contentView.frame.size.width)-11, y: 0, width: 0.5, height: cell.contentView.frame.size.height));
                    lblLineRigth.backgroundColor = UIColor.lightGrayColor()
                    cell.contentView.addSubview(lblLineRigth)
                    
                    let objMFAccountDetails = arrWealthtrustPortfolio.objectAtIndex(indexPath.row) as! MFAccount
                    
                    var lblName : UILabel!
                    lblName = UILabel(frame: CGRect(x: 10, y: 5, width: (cell.contentView.frame.size.width)-20, height: 35));
                    
                    let Namee = objMFAccountDetails.AmcName.stringByReplacingOccurrencesOfString("Mutual Fund", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                    lblName.text = Namee
                    lblName.font = UIFont.systemFontOfSize(20)
                    lblName.textColor = UIColor.blackColor()
                    lblName.textAlignment = .Center
                    cell.contentView.addSubview(lblName)
                    
                    
                    let btnMore = UIButton(frame: CGRect(x: (cell.contentView.frame.size.width)-45, y: 5, width: 35, height: 35))
                    btnMore.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                    btnMore.backgroundColor = UIColor.whiteColor()
                    btnMore.titleLabel?.font = UIFont.systemFontOfSize(14)
                    btnMore.setImage(UIImage(named: "more"), forState: .Normal)
                    btnMore.layer.cornerRadius = 1.5
                    btnMore.addTarget(self, action: #selector(PortfolioScreen.btnWealthMoreClicked(_:)), forControlEvents: .TouchUpInside)
                    cell.contentView.addSubview(btnMore)
                    
                    var lblPrice : UILabel!
                    lblPrice = UILabel(frame: CGRect(x: 10, y: 40, width: (cell.contentView.frame.size.width)-30, height: 35));
                    
                    let allUnits = (objMFAccountDetails.pucharseUnits as NSString).doubleValue
                    let currentPrice = (objMFAccountDetails.CurrentNAV as NSString).doubleValue
                    
                    let num = NSNumber(double: (allUnits * currentPrice))
                    let formatr : NSNumberFormatter = NSNumberFormatter()
                    formatr.numberStyle = .CurrencyStyle
                    formatr.locale = NSLocale(localeIdentifier: "en_IN")
                    if let stringDT = formatr.stringFromNumber(num)
                    {
                        lblPrice.text = stringDT
                    }
                    
                    lblPrice.font = UIFont.systemFontOfSize(19)
                    lblPrice.textColor = UIColor.defaultGreenColor
                    lblPrice.textAlignment = .Right
                    cell.contentView.addSubview(lblPrice)
                    
                    var lblFundName : UILabel!
                    lblFundName = UILabel(frame: CGRect(x: 15, y: 40, width: (cell.contentView.frame.size.width/2), height: 35));
                    lblFundName.text = objMFAccountDetails.SchemeName
                    lblFundName.font = UIFont.systemFontOfSize(13)
                    lblFundName.textColor = UIColor.darkGrayColor()
                    lblFundName.textAlignment = .Left
                    cell.contentView.addSubview(lblFundName)
                    
                    
                    var lblFolio : UILabel!
                    lblFolio = UILabel(frame: CGRect(x: 15, y: 75, width: 90, height: 20));
                    let last4 = String(objMFAccountDetails.FolioNo.characters.suffix(4))
                    lblFolio.text = "Folio: X- \(last4)"
                    lblFolio.font = UIFont.systemFontOfSize(13)
                    lblFolio.textColor = UIColor.darkGrayColor()
                    lblFolio.textAlignment = .Left
                    if last4=="" {
                    }else{
                        cell.contentView.addSubview(lblFolio)
                    }

                    
                    var lblasOn : UILabel!
                    lblasOn = UILabel(frame: CGRect(x: 105, y: 75, width: (cell.contentView.frame.size.width)-145, height: 20));
                    if let dt = objMFAccountDetails.NAVDate {
                        if dt == "<null>" {
                            
                        }else{
                            
                            let currentNav = (objMFAccountDetails.CurrentNAV as NSString).doubleValue
                            let purchaseNav = (objMFAccountDetails.puchaseNAV as NSString).doubleValue
                            let growth = ((currentNav/purchaseNav)-1) * 100
                            var twoDecimalPlaces = String(format: "%.1f", growth)
                            
                            var imgArrow : UIImageView!
                            imgArrow = UIImageView(frame: CGRect(x: (cell.contentView.frame.size.width)-35, y: 75, width:20 , height: 20));
                            
                            let dbl = (twoDecimalPlaces as NSString).doubleValue
                            if dbl<0 {
                                imgArrow.image = UIImage(named: "red_arrow")
                                
                                twoDecimalPlaces = String(format: "%.1f", (dbl*(-1)))
                            }else{
                                imgArrow.image = UIImage(named: "green_arrow")
                                
                            }
                            cell.contentView.addSubview(imgArrow)
                            
                            
                            lblasOn.text = "As on: \(sharedInstance.getFormatedDate(objMFAccountDetails.NAVDate)) | \(twoDecimalPlaces) %"
                            
                            
                        }
                    }
                    lblasOn.font = UIFont.systemFontOfSize(13)
                    lblasOn.textColor = UIColor.darkGrayColor()
                    lblasOn.textAlignment = .Right
                    cell.contentView.addSubview(lblasOn)
                    
                    cell.selectionStyle = UITableViewCellSelectionStyle.None
                    return cell
                }


            }
            
        }else{
            
            if isExistingPortfolioAvailable {
                
                // Existing Port Implementation....
                if (cell.contentView.subviews.count==0) {
                    
                    var lblLineTop : UILabel!
                    lblLineTop = UILabel(frame: CGRect(x: 10, y: 0, width: (cell.contentView.frame.size.width)-20, height: 0.5));
                    lblLineTop.backgroundColor = UIColor.lightGrayColor()
                    cell.contentView.addSubview(lblLineTop)
                    
                    var lblLineLeft : UILabel!
                    lblLineLeft = UILabel(frame: CGRect(x: 10, y: 0, width: 0.5, height: cell.contentView.frame.size.height));
                    lblLineLeft.backgroundColor = UIColor.lightGrayColor()
                    cell.contentView.addSubview(lblLineLeft)
                    
                    var lblLineRigth : UILabel!
                    lblLineRigth = UILabel(frame: CGRect(x: (cell.contentView.frame.size.width)-11, y: 0, width: 0.5, height: cell.contentView.frame.size.height));
                    lblLineRigth.backgroundColor = UIColor.lightGrayColor()
                    cell.contentView.addSubview(lblLineRigth)
                    
                    
                    let objMFAccountDetails = arrExistingPortfolio.objectAtIndex(indexPath.row) as! MFAccount
                    
                    var lblName : UILabel!
                    lblName = UILabel(frame: CGRect(x: 10, y: 5, width: (cell.contentView.frame.size.width)-20, height: 35));
                    
                    let Namee = objMFAccountDetails.AmcName.stringByReplacingOccurrencesOfString("Mutual Fund", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                    lblName.text = Namee
                    lblName.font = UIFont.systemFontOfSize(20)
                    lblName.textColor = UIColor.blackColor()
                    lblName.textAlignment = .Center
                    cell.contentView.addSubview(lblName)
                    
                    
                    let btnMore = UIButton(frame: CGRect(x: (cell.contentView.frame.size.width)-45, y: 5, width: 35, height: 35))
                    btnMore.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                    btnMore.backgroundColor = UIColor.whiteColor()
                    btnMore.titleLabel?.font = UIFont.systemFontOfSize(14)
                    btnMore.setImage(UIImage(named: "more"), forState: .Normal)
                    btnMore.layer.cornerRadius = 1.5
                    btnMore.tag = indexPath.row
                    btnMore.addTarget(self, action: #selector(PortfolioScreen.btnExistingMoreClicked(_:)), forControlEvents: .TouchUpInside)
                    cell.contentView.addSubview(btnMore)
                    
                    
                    var lblPrice : UILabel!
                    lblPrice = UILabel(frame: CGRect(x: 10, y: 40, width: (cell.contentView.frame.size.width)-30, height: 35));
                    
                    let allUnits = (objMFAccountDetails.pucharseUnits as NSString).doubleValue
                    let currentPrice = (objMFAccountDetails.CurrentNAV as NSString).doubleValue
                    
                    let num = NSNumber(double: (allUnits * currentPrice))
                    let formatr : NSNumberFormatter = NSNumberFormatter()
                    formatr.numberStyle = .CurrencyStyle
                    formatr.locale = NSLocale(localeIdentifier: "en_IN")
                    if let stringDT = formatr.stringFromNumber(num)
                    {
                        lblPrice.text = stringDT
                    }
                    
                    lblPrice.font = UIFont.systemFontOfSize(19)
                    lblPrice.textColor = UIColor.defaultGreenColor
                    lblPrice.textAlignment = .Right
                    cell.contentView.addSubview(lblPrice)
                    
                    
                    var lblFundName : UILabel!
                    lblFundName = UILabel(frame: CGRect(x: 15, y: 40, width: (cell.contentView.frame.size.width/2), height: 35));
                    lblFundName.text = objMFAccountDetails.SchemeName
                    lblFundName.font = UIFont.systemFontOfSize(13)
                    lblFundName.textColor = UIColor.darkGrayColor()
                    lblFundName.textAlignment = .Left
                    cell.contentView.addSubview(lblFundName)
                    
                    var lblFolio : UILabel!
                    lblFolio = UILabel(frame: CGRect(x: 15, y: 75, width: 90, height: 20));
                    let last4 = String(objMFAccountDetails.FolioNo.characters.suffix(4))
                    lblFolio.text = "Folio: X- \(last4)"
                    lblFolio.font = UIFont.systemFontOfSize(13)
                    lblFolio.textColor = UIColor.darkGrayColor()
                    lblFolio.textAlignment = .Left
                    if last4=="" {
                    }else{
                        cell.contentView.addSubview(lblFolio)
                    }

                    
                    var lblasOn : UILabel!
                    lblasOn = UILabel(frame: CGRect(x: 105, y: 75, width: (cell.contentView.frame.size.width)-145, height: 20));
                    
                    if let dt = objMFAccountDetails.NAVDate {
                        
                        if dt == "<null>" {
                        }
                        else
                        {
                            let currentNav = (objMFAccountDetails.CurrentNAV as NSString).doubleValue
                            let purchaseNav = (objMFAccountDetails.puchaseNAV as NSString).doubleValue
                            let growth = ((currentNav/purchaseNav)-1) * 100
                            var twoDecimalPlaces = String(format: "%.1f", growth)
                            
                            var imgArrow : UIImageView!
                            imgArrow = UIImageView(frame: CGRect(x: (cell.contentView.frame.size.width)-35, y: 75, width:20 , height: 20));
                            
                            let dbl = (twoDecimalPlaces as NSString).doubleValue
                            if dbl<0 {
                                imgArrow.image = UIImage(named: "red_arrow")
                                
                                twoDecimalPlaces = String(format: "%.1f", (dbl*(-1)))
                                
                            }else{
                                imgArrow.image = UIImage(named: "green_arrow")
                            }
                            cell.contentView.addSubview(imgArrow)
                            
                            lblasOn.text = "As on: \(sharedInstance.getFormatedDate(objMFAccountDetails.NAVDate)) | \(twoDecimalPlaces) %"
                            
                        }
                        
                    }
                    
                    lblasOn.font = UIFont.systemFontOfSize(13)
                    lblasOn.textColor = UIColor.darkGrayColor()
                    lblasOn.textAlignment = .Right
                    cell.contentView.addSubview(lblasOn)
                    
                    cell.selectionStyle = UITableViewCellSelectionStyle.None
                    return cell
                    
                }
                
            }
            
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.contentView.backgroundColor = UIColor.clearColor()
        cell.backgroundColor = UIColor.whiteColor()
        
        return cell;
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if isWealthTrustPortfolioAvailable {
            if isExistingPortfolioAvailable
            {
                if indexPath.section==0
                {
                    return 100
                }else{
                    return 100
                }
            }else{
                return 100
            }
        }else{
            if isExistingPortfolioAvailable {
                return 100
            }else{
                return 0
            }
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var sectionToLoad = 0
        if isWealthTrustPortfolioAvailable
        {
            if isExistingPortfolioAvailable
            {
                if section==0
                {
                    sectionToLoad = 0 // For Wealth
                }else{
                    sectionToLoad = 1 // For Existing
                }
            }else{
                sectionToLoad = 0 // For Wealth
            }
        }else{
            if isExistingPortfolioAvailable {
                sectionToLoad = 1 // For Existing
            }else{
                return UIView()
            }
        }

        if sectionToLoad==0 {
            
            let view = UIView(frame: CGRect(x: 10, y: 0, width: tableView.frame.size.width-20, height: 50))
            view.backgroundColor = UIColor.whiteColor()
            
            var lblLineTop : UILabel!
            lblLineTop = UILabel(frame: CGRect(x: 10, y: 0, width: (tableView.frame.size.width)-20, height: 0.5));
            lblLineTop.backgroundColor = UIColor.lightGrayColor()
            view.addSubview(lblLineTop)
            
            var lblLineLeft : UILabel!
            lblLineLeft = UILabel(frame: CGRect(x: 10, y: 0, width: 0.5, height: tableView.frame.size.height));
            lblLineLeft.backgroundColor = UIColor.lightGrayColor()
            view.addSubview(lblLineLeft)
            
            var lblLineRigth : UILabel!
            lblLineRigth = UILabel(frame: CGRect(x: (tableView.frame.size.width)-11, y: 0, width: 0.5, height: tableView.frame.size.height));
            lblLineRigth.backgroundColor = UIColor.lightGrayColor()
            view.addSubview(lblLineRigth)
            
            var lblWalthTrustPort : UILabel!
            lblWalthTrustPort = UILabel(frame: CGRect(x: 10, y: 5, width: (tableView.frame.size.width)-20, height: 35));
            lblWalthTrustPort.text = "WealthTrust Portfolio"
            lblWalthTrustPort.font = UIFont.systemFontOfSize(22)
            lblWalthTrustPort.textColor = UIColor.defaultAppColorBlue
            lblWalthTrustPort.textAlignment = .Center
            view.addSubview(lblWalthTrustPort)
            
            var lblWalthTrustPortTotal : UILabel!
            lblWalthTrustPortTotal = UILabel(frame: CGRect(x: 10, y: 40, width: (tableView.frame.size.width)-30, height: 35));
            
            self.updateTotalWealth()
            
            lblWalthTrustPortTotal.text = self.getFormatForDoublePrice(wealthPortTotal)

            lblWalthTrustPortTotal.font = UIFont.systemFontOfSize(22)
            lblWalthTrustPortTotal.textColor = UIColor.defaultGreenColor
            lblWalthTrustPortTotal.textAlignment = .Right
            view.addSubview(lblWalthTrustPortTotal)
            
            var lblWalthTrustyouinve : UILabel!
            lblWalthTrustyouinve = UILabel(frame: CGRect(x: 10, y: 75, width: (tableView.frame.size.width)-30, height: 20));
            lblWalthTrustyouinve.text = "You invested: \(self.getFormatForDoublePrice(wealthPortInveTotal))"
            lblWalthTrustyouinve.font = UIFont.systemFontOfSize(13)
            lblWalthTrustyouinve.textColor = UIColor.darkGrayColor()
            lblWalthTrustyouinve.textAlignment = .Right
            view.addSubview(lblWalthTrustyouinve)
            
            self.updateHeaderTotal()
            
            self.tblView.tableHeaderView = view
            return view

        }
        if sectionToLoad==1 {
            
            let view = UIView(frame: CGRect(x: 10, y: 0, width: tableView.frame.size.width-20, height: 100))
            view.backgroundColor = UIColor.whiteColor()
            
            var lblLineTop : UILabel!
            lblLineTop = UILabel(frame: CGRect(x: 10, y: 0, width: (tableView.frame.size.width)-20, height: 0.5));
            lblLineTop.backgroundColor = UIColor.lightGrayColor()
            view.addSubview(lblLineTop)
            
            var lblLineLeft : UILabel!
            lblLineLeft = UILabel(frame: CGRect(x: 10, y: 0, width: 0.5, height: tableView.frame.size.height));
            lblLineLeft.backgroundColor = UIColor.lightGrayColor()
            view.addSubview(lblLineLeft)
            
            var lblLineRigth : UILabel!
            lblLineRigth = UILabel(frame: CGRect(x: (tableView.frame.size.width)-11, y: 0, width: 0.5, height: tableView.frame.size.height));
            lblLineRigth.backgroundColor = UIColor.lightGrayColor()
            view.addSubview(lblLineRigth)
            
            var lblExistPort : UILabel!
            lblExistPort = UILabel(frame: CGRect(x: 10, y: 5, width: (tableView.frame.size.width)-20, height: 35));
            lblExistPort.text = "Existing Portfolio"
            lblExistPort.font = UIFont.systemFontOfSize(22)
            lblExistPort.textColor = UIColor.defaultAppColorBlue
            lblExistPort.textAlignment = .Center
            view.addSubview(lblExistPort)
            
            var lbllblExistPortTotal : UILabel!
            lbllblExistPortTotal = UILabel(frame: CGRect(x: 10, y: 40, width: (tableView.frame.size.width)-30, height: 35));


            self.updateTotalExisting()
            
            lbllblExistPortTotal.text = self.getFormatForDoublePrice(existingPortTotal)
            lbllblExistPortTotal.font = UIFont.systemFontOfSize(22)
            lbllblExistPortTotal.textColor = UIColor.defaultGreenColor
            lbllblExistPortTotal.textAlignment = .Right
            view.addSubview(lbllblExistPortTotal)
            
            var lblExistPortTotalyouinve : UILabel!
            lblExistPortTotalyouinve = UILabel(frame: CGRect(x: 10, y: 75, width: (tableView.frame.size.width)-30, height: 20));
            lblExistPortTotalyouinve.text = "You invested: \(self.getFormatForDoublePrice(existingPortInveTotal))"
            lblExistPortTotalyouinve.font = UIFont.systemFontOfSize(13)
            lblExistPortTotalyouinve.textColor = UIColor.darkGrayColor()
            lblExistPortTotalyouinve.textAlignment = .Right
            view.addSubview(lblExistPortTotalyouinve)
            
            self.updateHeaderTotal()
//            self.tblView.tableHeaderView = view
            return view
        }

        return UIView()
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        if section == 0 {
//            return 50
//        }
//        else
//        {
//            return 100
//        }
        
        if isWealthTrustPortfolioAvailable
        {
            if isExistingPortfolioAvailable
            {
                if section==0
                {
                    return 50// For Wealth
                }else{
                    return 100// For Existing
                }
            }else{
                return 50// For Wealth
            }
        }else{
            if isExistingPortfolioAvailable {
                return 100 // For Existing
            }else{
                return 100
            }
        }

    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if isWealthTrustPortfolioAvailable {
            if isExistingPortfolioAvailable {
                if indexPath.section==0
                {
                    let objMFAccount = self.arrWealthtrustPortfolio.objectAtIndex(indexPath.row) as! MFAccount
                    print("Walth \(objMFAccount.SchemeName)")
                    print("Walth \(objMFAccount.AmcName)")
                    
                    

                    let objPortDetail = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdPortfolioDetailScreen) as! PortfolioDetailScreen
                    objPortDetail.objMFAccountDetail = objMFAccount
                    objPortDetail.isFrom = "Wealth"
                    self.navigationController?.pushViewController(objPortDetail, animated: true)
                    
                }else{
                    let objMFAccount = self.arrExistingPortfolio.objectAtIndex(indexPath.row) as! MFAccount
                    print("Exist \(objMFAccount.SchemeName)")
                    
                    let objPortDetail = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdPortfolioDetailScreen) as! PortfolioDetailScreen
                    objPortDetail.objMFAccountDetail = objMFAccount
                    objPortDetail.isFrom = "Exist"
                    self.navigationController?.pushViewController(objPortDetail, animated: true)

                }
                
            }else{
                print("Walth")
                let objMFAccount = self.arrWealthtrustPortfolio.objectAtIndex(indexPath.row) as! MFAccount
                print("Walth \(objMFAccount.SchemeName)")
                
                let objPortDetail = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdPortfolioDetailScreen) as! PortfolioDetailScreen
                objPortDetail.objMFAccountDetail = objMFAccount
                objPortDetail.isFrom = "Wealth"
                self.navigationController?.pushViewController(objPortDetail, animated: true)

            }
            
        }else{
            if isExistingPortfolioAvailable {
                print("Exist")
                let objMFAccount = self.arrExistingPortfolio.objectAtIndex(indexPath.row) as! MFAccount
                
                let objPortDetail = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdPortfolioDetailScreen) as! PortfolioDetailScreen
                objPortDetail.objMFAccountDetail = objMFAccount
                objPortDetail.isFrom = "Exist"
                self.navigationController?.pushViewController(objPortDetail, animated: true)

            }
        }
    }
    
//    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
//        if isWealthTrustPortfolioAvailable {
//            if isExistingPortfolioAvailable {
//                if indexPath.section==0
//                {
//                    return false
//                    
//                }else{
//                    return true
//                }
//                
//            }else{
//                return false
//            }
//            
//        }else{
//            if isExistingPortfolioAvailable {
//                return true
//            }
//        }
//
//        
//        return true
//    }
//    
//    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        if (editingStyle == UITableViewCellEditingStyle.Delete) {
//            // handle delete (by removing the data from your array and updating the tableview)
//        }
//    }

    

    
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
    
    
    
    @IBAction func btnWealthMoreClicked(sender: AnyObject) {

        let alertController = UIAlertController(title: APP_NAME, message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let investMore = UIAlertAction(title: "INVEST MORE", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
            print("INVEST MORE")
            
            
            let objMFAccountDetails = self.arrWealthtrustPortfolio.objectAtIndex(sender.tag) as! MFAccount
            print(objMFAccountDetails.SchemeName)
            
            
            let jo = NSMutableDictionary()
            jo.setValue(objMFAccountDetails.RTAamcCode, forKey: "Fund_Code")
            jo.setValue(Double(objMFAccountDetails.CurrentNAV), forKey: "NAV")
            jo.setValue(objMFAccountDetails.NAVDate, forKey: "NAVDate")
            
            jo.setValue(objMFAccountDetails.SchemeName, forKey: "Plan_Name")
            jo.setValue(objMFAccountDetails.DivOption, forKey: "Div_Opt")
            jo.setValue(objMFAccountDetails.SchemeCode, forKey: "Scheme_Code")
            
            sharedInstance.userDefaults.setObject(jo, forKey: kSelectBuyNowScheme)
            
//            print(sharedInstance.userDefaults.objectForKey(kSelectBuyNowScheme))
//            
//            
//            let objBuyScreen = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdBuyScreeen) as! BuyScreeen
//            objBuyScreen.isBuyFrom = kBUY_FROM_SELECTED_FUND
//            objBuyScreen.isExisting = true
//            self.navigationController?.pushViewController(objBuyScreen, animated: true)

            
            RootManager.sharedInstance.isFrom = IS_FROM.BuySIPFromPortfolio
            RootManager.sharedInstance.navigateToScreen(self, data: jo)
            
        }
        let switchBtn = UIAlertAction(title: "SWITCH", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
            print("SWITCH")
            

            let objMFAccountDetails = self.arrWealthtrustPortfolio.objectAtIndex(sender.tag) as! MFAccount
            print(objMFAccountDetails.SchemeName)
            print(objMFAccountDetails.FolioNo)

            
            let jo = NSMutableDictionary()
            jo.setValue(objMFAccountDetails.RTAamcCode, forKey: "Fund_Code")
            jo.setValue(Double(objMFAccountDetails.CurrentNAV), forKey: "NAV")
            jo.setValue(objMFAccountDetails.NAVDate, forKey: "NAVDate")
            
            jo.setValue(objMFAccountDetails.SchemeName, forKey: "Plan_Name")
            jo.setValue(objMFAccountDetails.DivOption, forKey: "Div_Opt")
            jo.setValue(objMFAccountDetails.SchemeCode, forKey: "Scheme_Code")
            jo.setValue(objMFAccountDetails.FolioNo, forKey: "FolioNo")

            sharedInstance.userDefaults.setObject(jo, forKey: kSelectFromFundValue)
            
            print(sharedInstance.userDefaults.objectForKey(kSelectFromFundValue))

            sharedInstance.userDefaults .setObject("Select Fund", forKey: kSelectToFundValue)
            
            let objSwitchScreen = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdSwitchScreen) as! SwitchScreen
            self.navigationController?.pushViewController(objSwitchScreen, animated: true)

            
        }
        let redeemBtn = UIAlertAction(title: "REDEEM", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
            print("REDEEM")
            
            
            let arrMFAccounts = DBManager.getInstance().getMFAccountsForRedeemCondition()
            if arrMFAccounts.count==0 {
                SharedManager.invokeAlertMethod("No schemes found", strBody: "Currently there are no schemes in your WealthTrust portfolio for redemption.", delegate: nil)
            }else{
                
                let objMFAccountDetails = self.arrWealthtrustPortfolio.objectAtIndex(sender.tag) as! MFAccount
                print(objMFAccountDetails.SchemeName)
                
                var indexSelect = 0
                for objDetails in arrMFAccounts
                {
                    let dt = objDetails as! MFAccount
                    print(dt.AccId)
                    print(dt.SchemeName)

                    if objMFAccountDetails.AccId == dt.AccId
                    {
                        let objRedeem = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdRedeemScreen) as! RedeemScreen
                        objRedeem.arrSchemes = arrMFAccounts
                        objRedeem.isFrom = "Existing"
                        objRedeem.pickerSelectedIndex = indexSelect
                        self.navigationController?.pushViewController(objRedeem, animated: true)

                        break
                    }
                    indexSelect = indexSelect + 1
                }
            }
        }
        let okAction = UIAlertAction(title: "CANCEL", style: UIAlertActionStyle.Destructive) { (result : UIAlertAction) -> Void in
            print("OK")
        }

        alertController.addAction(investMore)
        alertController.addAction(switchBtn)
        alertController.addAction(redeemBtn)
        alertController.addAction(okAction)

        self.presentViewController(alertController, animated: true, completion: nil)

        
    }
    @IBAction func btnExistingMoreClicked(sender: AnyObject) {
        
        
        let alertController = UIAlertController(title: APP_NAME, message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let investMore = UIAlertAction(title: "SWITCH", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
            print("SWITCH")
            
            
            let objMFAccountDetails = self.arrExistingPortfolio.objectAtIndex(sender.tag) as! MFAccount
            print(objMFAccountDetails.SchemeName)
            print(objMFAccountDetails.FolioNo)

            let jo = NSMutableDictionary()
            jo.setValue(objMFAccountDetails.RTAamcCode, forKey: "Fund_Code")
            jo.setValue(Double(objMFAccountDetails.CurrentNAV), forKey: "NAV")
            jo.setValue(objMFAccountDetails.NAVDate, forKey: "NAVDate")
            
            jo.setValue(objMFAccountDetails.SchemeName, forKey: "Plan_Name")
            jo.setValue(objMFAccountDetails.DivOption, forKey: "Div_Opt")
            jo.setValue(objMFAccountDetails.SchemeCode, forKey: "Scheme_Code")
            jo.setValue(objMFAccountDetails.FolioNo, forKey: "FolioNo")

            sharedInstance.userDefaults.setObject(jo, forKey: kSelectFromFundValue)
            
            print(sharedInstance.userDefaults.objectForKey(kSelectFromFundValue))
            
            //            sharedInstance.userDefaults .setObject("Select Fund", forKey: kSelectFromFundValue)
            sharedInstance.userDefaults .setObject("Select Fund", forKey: kSelectToFundValue)
            
            let objSwitchScreen = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdSwitchScreen) as! SwitchScreen
            self.navigationController?.pushViewController(objSwitchScreen, animated: true)
            
        }
        
        
        
        
        let switchBtn = UIAlertAction(title: "ADD MANUAL TRANSACTION", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
            print("ADD MANUAL TRANSACTION")

            self.viewPortFload.hidden = true
            
            
            let objMFAccountDetails = self.arrExistingPortfolio.objectAtIndex(sender.tag) as! MFAccount
            print(objMFAccountDetails.SchemeName)
            
            let jo = NSMutableDictionary()
            jo.setValue(objMFAccountDetails.RTAamcCode, forKey: "Fund_Code")
            jo.setValue(Double(objMFAccountDetails.CurrentNAV), forKey: "NAV")
            jo.setValue(objMFAccountDetails.NAVDate, forKey: "NAVDate")
            
            jo.setValue(objMFAccountDetails.SchemeName, forKey: "Plan_Name")
            jo.setValue(objMFAccountDetails.DivOption, forKey: "Div_Opt")
            jo.setValue(objMFAccountDetails.SchemeCode, forKey: "Scheme_Code")
            
            sharedInstance.userDefaults.setObject(jo, forKey: kSelectAddExistingScheme)


            let objAddPort = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdAddPortfolioManually) as! AddPortfolioManually
            self.navigationController?.pushViewController(objAddPort, animated: true)
            
        }
        
        
        
        let redeemBtn = UIAlertAction(title: "DELETE", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
            print("DELETE")
            
            let objMFAccount = self.arrExistingPortfolio.objectAtIndex(sender.tag) as! MFAccount
            print("Exist \(objMFAccount.SchemeName)")

            let alertDeleter = UIAlertController(title: "Delete ?", message: "Are you sure, You want to delete Account ?", preferredStyle: UIAlertControllerStyle.Alert)
            
            let btnYes = UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
                print("Yes delete")
                
                
                let dicToSend:NSDictionary = [
                    "AccId" : objMFAccount.AccId,
                    "ClientId" : objMFAccount.clientid]
                
                WebManagerHK.postDataToURL(kModeDeleteManuallMFAccount, params: dicToSend, message: "Deleting account..") { (response) in
                    print("Dic Response : \(response)")
                    
                    if response.objectForKey(kWAPIResponse) is NSDictionary
                    {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            
                            let mainResponse = response.objectForKey(kWAPIResponse) as! NSDictionary
                            
                            let isDeleted = DBManager.getInstance().deleteManualMFAccount(objMFAccount)
                            if isDeleted
                            {
                                print("Yes Deleted....")
                            }
                            
                            let arrManual = DBManager.getInstance().getManualMFAccounts()
                            if arrManual.count==0 {
                                self.isExistingPortfolioAvailable = false
                            }else{
                                self.isExistingPortfolioAvailable = true
                                self.arrExistingPortfolio = arrManual
                            }
                            
                            self.tblView.reloadData()

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

        let okAction = UIAlertAction(title: "CANCEL", style: UIAlertActionStyle.Destructive) { (result : UIAlertAction) -> Void in
            print("OK")
        }
        
        alertController.addAction(investMore)
        alertController.addAction(switchBtn)
        alertController.addAction(redeemBtn)
        alertController.addAction(okAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)

        
    }
    
    
    
    func updateTotalWealth() {
        
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

    }
    
    func updateTotalExisting() {
        
        var portfolioTotal = ("0.0").doubleValue
        var totalInvestment = ("0.0").doubleValue
        for objMFAccount in arrExistingPortfolio {
            let objMM = objMFAccount as! MFAccount
            
            let allUnits = (objMM.pucharseUnits as NSString).doubleValue
            let currentPrice = (objMM.CurrentNAV as NSString).doubleValue
            let ttlPurchase = (allUnits * currentPrice)
            
            portfolioTotal = portfolioTotal + ttlPurchase
            
            let allInvest = (objMM.InvestmentAmount as NSString).doubleValue
            totalInvestment = totalInvestment + allInvest
        }

        existingPortTotal = portfolioTotal
        existingPortInveTotal = totalInvestment
        
    }

    func updateHeaderTotal() {
        
        let tot = (wealthPortTotal + existingPortTotal)
        let totInve = (wealthPortInveTotal + existingPortInveTotal)

        let earnedAmount =  tot - totInve
        
        var stringGroth = "0"
        if totInve==0 {
            lblPortfolioGrandTotal.text = self.getFormatForDoublePrice(wealthPortTotal + existingPortTotal)
            lblPortfolioGrandInveTotal.text = "You invested: \(self.getFormatForDoublePrice(wealthPortInveTotal + existingPortInveTotal))"

        }else{
            let growth = (earnedAmount / totInve) * 100
            print("Growth \(growth)")
            stringGroth = String(format: "%.1f", (earnedAmount / totInve) * 100)
            
            // GROWTH CALCULATED just need to display...
            lblPortfolioGrandTotal.text = self.getFormatForDoublePrice(wealthPortTotal + existingPortTotal) + " | \(stringGroth)%"
            lblPortfolioGrandInveTotal.text = "You invested: \(self.getFormatForDoublePrice(wealthPortInveTotal + existingPortInveTotal))"

        }
        
        lblPortfolioGrandTotal.numberOfLines = 1;
        lblPortfolioGrandTotal.sizeToFit()
        
        lblPortfolioGrandTotal.frame = CGRect(x: (SCREEN_WIDTH/2)-(lblPortfolioGrandTotal.frame.size.width/2), y: lblPortfolioGrandTotal.frame.origin.y, width: lblPortfolioGrandTotal.frame.size.width, height: lblPortfolioGrandTotal.frame.size.height)
        
        
//        imageupDown
        
        var imgArrow : UIImageView!
        imgArrow = UIImageView(frame: CGRect(x: (lblPortfolioGrandTotal.frame.origin.x + lblPortfolioGrandTotal.frame.size.width), y: lblPortfolioGrandTotal.frame.origin.y+5, width:20 , height: 20));
        
        let dbl = (stringGroth as NSString).doubleValue
        if dbl<0 {
            imgArrow.image = UIImage(named: "red_arrow")
        }else{
            imgArrow.image = UIImage(named: "green_arrow")
        }
        lblPortfolioGrandTotal.superview!.addSubview(imgArrow)
        
        
    }
    
    @IBAction func btnPortFloadClicked(sender: AnyObject) {
        self.viewPortFload.hidden = false
        
    }
    
    @IBAction func btnPortCloseClicked(sender: AnyObject) {
        self.viewPortFload.hidden = true
    }
    
    func btnPortUploadExistingClicked(sender: AnyObject) {
        print("Upload Existing Clicked ")
        self.viewPortFload.hidden = true

//        let objscreen = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdUploadPortfolioInstruScreen) as! UploadPortfolioInstruScreen
//        self.navigationController?.pushViewController(objscreen, animated: true)
        
        let objUser = DBManager.getInstance().getLoggedInUserDetails()
        if objUser.SignupStatus == nil {
            print("Yes Blank....")
            
            let objUserLoginSignYp = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdUserLoginSignUp) as! UserLoginSignUp
            objUserLoginSignYp.isFrom = IS_FROM.AutoGenerate
            self.navigationController?.pushViewController(objUserLoginSignYp, animated: true)
        }
        else
        {
            let objscreen = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdUploadPortfolioInstruScreen) as! UploadPortfolioInstruScreen
            self.navigationController?.pushViewController(objscreen, animated: true)
        }

    }
    
    func btnPortAddExistingClicked(sender: AnyObject) {
        print("Add Existing Clicked ")
        self.viewPortFload.hidden = true

//        sharedInstance.userDefaults .setObject(kEnterSchemeName, forKey: kSelectAddExistingScheme)
//        
//        let objAddPort = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdAddPortfolioManually) as! AddPortfolioManually
//        
//        self.navigationController?.pushViewController(objAddPort, animated: true)

        let objUser = DBManager.getInstance().getLoggedInUserDetails()
        
        if objUser.SignupStatus == nil {
            print("Yes Blank....")
            
            let objUserLoginSignYp = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdUserLoginSignUp) as! UserLoginSignUp
            objUserLoginSignYp.isFrom = IS_FROM.AddManuallyPortfolio
            self.navigationController?.pushViewController(objUserLoginSignYp, animated: true)
        }
        else
        {
            self.viewPortFload.hidden = true
            sharedInstance.userDefaults .setObject(kEnterSchemeName, forKey: kSelectAddExistingScheme)
            let objAddPort = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdAddPortfolioManually) as! AddPortfolioManually
            self.navigationController?.pushViewController(objAddPort, animated: true)
        }
    }
    @IBAction func btnShareClicked(sender: AnyObject) {
        SharedManager.sharedInstance.uploadUserAction(USERACTIONTYPE.UA_SHARE_PORTFOLIOBOTTOMBAR)
        let img = UIImage()
        let shareItems:Array = [img]

        let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        
        if let wPPC = activityViewController.popoverPresentationController {
            wPPC.sourceView = sender as? UIView
        }
        self.presentViewController(activityViewController, animated: true) {
        }
    }
    @IBAction func btnRateUsClicked(sender: AnyObject) {
        SharedManager.sharedInstance.uploadUserAction(USERACTIONTYPE.UA_RATEUS_PORTFOLIOBOTTOMBAR)
        UIApplication.sharedApplication().openURL(NSURL(string: APP_URL)!)
    }

    
}
