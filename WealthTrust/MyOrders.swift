//
//  MyOrders.swift
//  WealthTrust
//
//  Created by Hemen Gohil on 11/25/16.
//  Copyright © 2016 Hemen Gohil. All rights reserved.
//

import UIKit

let FONT_SIZE_CELL_TITLE = UIFont.systemFontOfSize(16)
let FONT_SIZE_CELL_SUB_TITLE = UIFont.systemFontOfSize(12)

let FONT_COLOR_CELL_TITLE = UIColor.blackColor().colorWithAlphaComponent(0.87)
let FONT_COLOR_CELL_SUB_TITLE = UIColor.blackColor().colorWithAlphaComponent(0.54)

class MyOrders: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tblView: UITableView!

    var arrOrders = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()

        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            let getAllOrders = DBManager.getInstance().getMyOrdersData()
            for objOrd in getAllOrders {
                let objOrders = objOrd as! Order
                
                // Sorting should be applied
                // Android code for sorting element
//                for (int i = 0; i < mfuOrders.size(); i++) {
//                    if (!TextUtils.isEmpty(mfuOrders.get(i).getExecutionDateTime())) {
//                        mfuOrders.get(i).setDummyDate(mfuOrders.get(i).getExecutionDateTime());
//                    }
//                    else {
//                        mfuOrders.get(i).setDummyDate(mfuOrders.get(i).getWealtheeOrderTimeStamp());
//                    }
//                }
//                Collections.sort(mfuOrders, new Comparator<MFUOrder>() {
//                    @Override
//                    public int compare(MFUOrder lhs, MFUOrder rhs) {
//                        return lhs.getDummyDate().compareTo(rhs.getDummyDate());
//                    }
//                    });
//                Collections.reverse(mfuOrders);
                
                self.arrOrders.addObject(objOrders)
                
            }

            
            self.tblView.reloadData()
        })

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func btnBKClicked(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }

    func getBuyImageView() -> UIImageView {
        let imgArrow = UIImageView(frame: CGRect(x: 8, y: 8, width: 40, height: 40))
        imgArrow.image = UIImage(named: "ic_buy_transparentN") //transactBuySIP
        imgArrow.layer.cornerRadius = imgArrow.frame.size.width/2
        imgArrow.backgroundColor = UIColor(red:76/250, green:175/250, blue:80/250, alpha: 1)
        imgArrow.contentMode = .Center
        return imgArrow
    }
    func getRedeemImageView() -> UIImageView {
        let imgArrow = UIImageView(frame: CGRect(x: 8, y: 8, width: 40, height: 40))
        imgArrow.image = UIImage(named: "ic_redeemN") //transactRedeem
        imgArrow.layer.cornerRadius = imgArrow.frame.size.width/2
        imgArrow.backgroundColor = UIColor(red:255/250, green:171/250, blue:64/250, alpha: 1)
        imgArrow.contentMode = .Center
        return imgArrow
    }
    func getSwitchImageView() -> UIImageView {
        let imgArrow = UIImageView(frame: CGRect(x: 8, y: 8, width: 40, height: 40))
        imgArrow.image = UIImage(named: "ic_switch") //transactswitch_icon
        imgArrow.layer.cornerRadius = imgArrow.frame.size.width/2
        imgArrow.backgroundColor = UIColor(red:33/250, green:150/250, blue:243/250, alpha: 1)
        imgArrow.contentMode = .Center
        return imgArrow
    }
    func getSIPImageView() -> UIImageView {
        let imgArrow = UIImageView(frame: CGRect(x: 8, y: 8, width: 40, height: 40))
        imgArrow.image = UIImage(named: "ic_sip_transparentN") //transactswitch_icon
        imgArrow.layer.cornerRadius = imgArrow.frame.size.width/2
        imgArrow.backgroundColor = UIColor(red:76/250, green:175/250, blue:80/250, alpha: 1)
        imgArrow.contentMode = .Center
        return imgArrow
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.arrOrders.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        var objOrders = Order()
        objOrders = self.arrOrders.objectAtIndex(indexPath.row) as! Order
        let enumOrderStatus = OrderStatus.fromHashValue((Int(objOrders.OrderStatus))!)
        
//        let stringIdentifier = "ALL_SELECTED_DATA_\(indexPath.row)_\(indexPath.section)_\(enumOrderStatus.hashValue)_\(objOrders.ServerOrderID)"
        let stringIdentifier = "ALL_SELECTED_DATA_\(indexPath.row)_\(indexPath.section)_"

        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: stringIdentifier)
        
        let cell = tableView.dequeueReusableCellWithIdentifier(stringIdentifier, forIndexPath: indexPath) as UITableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.contentView.backgroundColor = UIColor.clearColor()
        cell.backgroundColor = UIColor.clearColor()
        
        
        if (cell.contentView.subviews.count==0)
        {
            
            var isFor = "BUY"
            var enumOrderType = OrderType.Buy
            enumOrderType = OrderType.fromHashValue((Int(objOrders.OrderType))!)
            if enumOrderType == OrderType.Buy
            {
                isFor = "BUY"
            }
            else if enumOrderType == OrderType.SIP || enumOrderType == OrderType.BuyPlusSIP
            {
                isFor = "SIP"
            }
            else if enumOrderType == OrderType.RedeemWithOutDocs || enumOrderType == OrderType.RedeemWithDocs
            {
                isFor = "REDEEM"
            }
            else if enumOrderType == OrderType.SwitchWithOutDocs || enumOrderType == OrderType.SwitchWithDocs
            {
                isFor = "SWITCH"
            }

            print(isFor)
            
            
            let viewSquare = UIView(frame: CGRect(x: 10, y: 2, width: (cell.contentView.frame.size.width)-20, height: 141))
            viewSquare.backgroundColor = UIColor.whiteColor()
            cell.contentView.addSubview(viewSquare)
            SharedManager.addShadowToView(viewSquare)
            
            var lblType : UILabel!
            lblType = UILabel(frame: CGRect(x: 8, y: 50, width: 40, height: 15));
            lblType.font = UIFont.systemFontOfSize(12)
            lblType.textColor = UIColor.blackColor().colorWithAlphaComponent(0.54)
            lblType.textAlignment = .Center
            viewSquare.addSubview(lblType)
            
            
            if isFor=="BUY" {
                
                if enumOrderStatus==OrderStatus.RP {
                    
                    viewSquare.frame = CGRect(x: 10, y: 2, width: (cell.contentView.frame.size.width)-20, height: 149)
                    lblType.text = "Buy"
                    viewSquare.addSubview(self.getBuyImageView())
                    
                    // TO BUY UI..... BUY START
                    var lblFundName : UILabel!
                    lblFundName = UILabel(frame: CGRect(x: 54, y: 8, width: viewSquare.frame.size.width-53, height: 40));
                    lblFundName.text = objOrders.SrcSchemeName.capitalizedString
                    if objOrders.SrcSchemeName=="" {
                        lblFundName.text = "Scheme Name - N/A"
                    }
                    lblFundName.font = FONT_SIZE_CELL_TITLE
                    lblFundName.textColor = FONT_COLOR_CELL_TITLE
                    lblFundName.textAlignment = .Left
                    lblFundName.numberOfLines = 0
                    viewSquare.addSubview(lblFundName)
                    
                    var lblPurchaseAmount : UILabel!
                    lblPurchaseAmount = UILabel(frame: CGRect(x: 54, y: 48, width: viewSquare.frame.size.width-53, height: 15));
                    lblPurchaseAmount.text = "Purchase Amount : -"
                    
                    let amount = (objOrders.Volume as NSString).doubleValue
                    let num = NSNumber(double: amount)
                    let formatr : NSNumberFormatter = NSNumberFormatter()
                    formatr.numberStyle = .CurrencyStyle
                    formatr.locale = NSLocale(localeIdentifier: "en_IN")
                    if let stringDT = formatr.stringFromNumber(num)
                    {
                        lblPurchaseAmount.text = "Purchase Amount : \(stringDT)"
                    }
                    lblPurchaseAmount.font = UIFont.systemFontOfSize(12)
                    lblPurchaseAmount.textColor = FONT_COLOR_CELL_SUB_TITLE
                    lblPurchaseAmount.textAlignment = .Left
                    viewSquare.addSubview(lblPurchaseAmount)
                    
                    var lblNAV : UILabel!
                    lblNAV = UILabel(frame: CGRect(x: 54, y: 63, width: viewSquare.frame.size.width-53, height: 15));
                    
                    lblNAV.text = "NAV : -"
                    if let stringDT = objOrders.txnPurchaseNav
                    {
                        let nv = Double(stringDT)
                        let Nav = String(format: "%.2f", nv!)
                        lblNAV.text = "NAV : \(Nav)"
                    }

//                    if objOrders.txnPurchaseNav.isEmpty {
//                        lblNAV.text = "NAV : -"
//                    }else{
//                        let nv = Double(objOrders.txnPurchaseNav)
//                        let Nav = String(format: "%.2f", nv!)
//                        lblNAV.text = "NAV : \(Nav)"
//                    }
                    
                    lblNAV.font = FONT_SIZE_CELL_SUB_TITLE
                    lblNAV.textColor = FONT_COLOR_CELL_SUB_TITLE
                    lblNAV.textAlignment = .Left
                    viewSquare.addSubview(lblNAV)
                    
                    var lblUnits : UILabel!
                    lblUnits = UILabel(frame: CGRect(x: 54, y: 78, width: viewSquare.frame.size.width-53, height: 15));
                    lblUnits.text = "Units : -"
                    if let stringDT = objOrders.txnPurchaseUnits
                    {
                        let un = Double(stringDT)
                        let Units = String(format: "%.2f", un!)
                        lblUnits.text = "Units : \(Units)"
                    }

                    
//                    let un = Double(objOrders.txnPurchaseUnits)
//                    let Units = String(format: "%.2f", un!)
//                    lblUnits.text = "Units : \(Units)"
                    
                    lblUnits.font = FONT_SIZE_CELL_SUB_TITLE
                    lblUnits.textColor = FONT_COLOR_CELL_SUB_TITLE
                    lblUnits.textAlignment = .Left
                    viewSquare.addSubview(lblUnits)
                    
                    
                    var lblOrderOd : UILabel!
                    lblOrderOd = UILabel(frame: CGRect(x: 54, y: 93, width: viewSquare.frame.size.width-53, height: 15));
                    lblOrderOd.text = "Order Id : \(objOrders.ServerOrderID)"
                    lblOrderOd.font = FONT_SIZE_CELL_SUB_TITLE
                    lblOrderOd.textColor = FONT_COLOR_CELL_SUB_TITLE
                    lblOrderOd.textAlignment = .Left
                    viewSquare.addSubview(lblOrderOd)
                    
                    
                    var lblDATE : UILabel!
                    lblDATE = UILabel(frame: CGRect(x: 54, y: 108, width: viewSquare.frame.size.width-53, height: 15));
                    lblDATE.font = FONT_SIZE_CELL_SUB_TITLE
                    lblDATE.textColor = FONT_COLOR_CELL_SUB_TITLE
                    lblDATE.textAlignment = .Left
                    viewSquare.addSubview(lblDATE)
                    lblDATE.text = "Execution Date : -"
                    if let stringDT = objOrders.executionDateTime
                    {
                        lblDATE.text = "Execution Date : \(sharedInstance.getFormatedDate(stringDT))"
                    }
                    
                    var lblOrderStatus : UILabel!
                    lblOrderStatus = UILabel(frame: CGRect(x: 54, y: 123, width: viewSquare.frame.size.width-53, height: 15));
                    lblOrderStatus.text = "Order Status : \(OrderStatus.allValues[enumOrderStatus.hashValue])"
                    lblOrderStatus.font = FONT_SIZE_CELL_SUB_TITLE
                    lblOrderStatus.textColor = FONT_COLOR_CELL_SUB_TITLE
                    lblOrderStatus.textAlignment = .Left
                    viewSquare.addSubview(lblOrderStatus)
                    
                    return cell
                    
                }else{
                    
                    
                    viewSquare.frame = CGRect(x: 10, y: 2, width: (cell.contentView.frame.size.width)-20, height: 104)
                    lblType.text = "Buy"
                    viewSquare.addSubview(self.getBuyImageView())
                    
                    // TO BUY UI..... BUY START
                    var lblFundName : UILabel!
                    lblFundName = UILabel(frame: CGRect(x: 54, y: 8, width: viewSquare.frame.size.width-53, height: 40));
                    lblFundName.text = objOrders.SrcSchemeName.capitalizedString
                    if objOrders.SrcSchemeName=="" {
                        lblFundName.text = "Scheme Name - N/A"
                    }
                    lblFundName.font = FONT_SIZE_CELL_TITLE
                    lblFundName.textColor = FONT_COLOR_CELL_TITLE
                    lblFundName.textAlignment = .Left
                    lblFundName.numberOfLines = 0
                    viewSquare.addSubview(lblFundName)
                    
                    var lblPurchaseAmount : UILabel!
                    lblPurchaseAmount = UILabel(frame: CGRect(x: 54, y: 48, width: viewSquare.frame.size.width-53, height: 15));
                    lblPurchaseAmount.text = "Purchase Amount : -"
                    
                    let amount = (objOrders.Volume as NSString).doubleValue
                    let num = NSNumber(double: amount)
                    let formatr : NSNumberFormatter = NSNumberFormatter()
                    formatr.numberStyle = .CurrencyStyle
                    formatr.locale = NSLocale(localeIdentifier: "en_IN")
                    if let stringDT = formatr.stringFromNumber(num)
                    {
                        lblPurchaseAmount.text = "Purchase Amount : \(stringDT)"
                    }
                    lblPurchaseAmount.font = UIFont.systemFontOfSize(12)
                    lblPurchaseAmount.textColor = FONT_COLOR_CELL_SUB_TITLE
                    lblPurchaseAmount.textAlignment = .Left
                    viewSquare.addSubview(lblPurchaseAmount)
                    
//                    var lblNAV : UILabel!
//                    lblNAV = UILabel(frame: CGRect(x: 54, y: 60, width: viewSquare.frame.size.width-53, height: 15));
//                    let nv = Double(objOrders.txnPurchaseNav)
//                    let Nav = String(format: "%.2f", nv!)
//                    
//                    lblNAV.text = "NAV : \(Nav)"
//                    lblNAV.font = FONT_SIZE_CELL_SUB_TITLE
//                    lblNAV.textColor = FONT_COLOR_CELL_SUB_TITLE
//                    lblNAV.textAlignment = .Left
//                    viewSquare.addSubview(lblNAV)
//                    
//                    var lblUnits : UILabel!
//                    lblUnits = UILabel(frame: CGRect(x: 54, y: 75, width: viewSquare.frame.size.width-53, height: 15));
//                    let un = Double(objOrders.txnPurchaseUnits)
//                    let Units = String(format: "%.2f", un!)
//                    
//                    lblUnits.text = "Units : \(Units)"
//                    lblUnits.font = FONT_SIZE_CELL_SUB_TITLE
//                    lblUnits.textColor = FONT_COLOR_CELL_SUB_TITLE
//                    lblUnits.textAlignment = .Left
//                    viewSquare.addSubview(lblUnits)
                    
                    
                    var lblOrderOd : UILabel!
                    lblOrderOd = UILabel(frame: CGRect(x: 54, y: 63, width: viewSquare.frame.size.width-53, height: 15));
                    lblOrderOd.text = "Order Id : \(objOrders.ServerOrderID)"
                    lblOrderOd.font = FONT_SIZE_CELL_SUB_TITLE
                    lblOrderOd.textColor = FONT_COLOR_CELL_SUB_TITLE
                    lblOrderOd.textAlignment = .Left
                    viewSquare.addSubview(lblOrderOd)
                    
                    
//                    var lblDATE : UILabel!
//                    lblDATE = UILabel(frame: CGRect(x: 54, y: 105, width: viewSquare.frame.size.width-53, height: 15));
//                    lblDATE.font = FONT_SIZE_CELL_SUB_TITLE
//                    lblDATE.textColor = FONT_COLOR_CELL_SUB_TITLE
//                    lblDATE.textAlignment = .Left
//                    viewSquare.addSubview(lblDATE)
//                    lblDATE.text = "Execution Date : \(sharedInstance.getFormatedDate(objOrders.executionDateTime))"
                    
                    var lblOrderStatus : UILabel!
                    lblOrderStatus = UILabel(frame: CGRect(x: 54, y: 78, width: viewSquare.frame.size.width-53, height: 15));
                    lblOrderStatus.text = "Order Status : \(OrderStatus.allValues[enumOrderStatus.hashValue])"
                    lblOrderStatus.font = FONT_SIZE_CELL_SUB_TITLE
                    lblOrderStatus.textColor = FONT_COLOR_CELL_SUB_TITLE
                    lblOrderStatus.textAlignment = .Left
                    viewSquare.addSubview(lblOrderStatus)
                    
                    return cell

                    
                }
                
                // TO BUY UI..... BUY END...
            }
            
            if isFor=="SIP" {
                
                
                let arrData = DBManager.getInstance().getSystematicOrderByAppOrderId(objOrders)
                var objSystematicOrder : OrderSystematic = OrderSystematic()
                if arrData.count==0 {
                    
                }else{
                    objSystematicOrder = arrData.objectAtIndex(0) as! OrderSystematic
                }
                
                if enumOrderStatus==OrderStatus.RP {
                    
                    viewSquare.frame = CGRect(x: 10, y: 2, width: (cell.contentView.frame.size.width)-20, height: 193)
                    lblType.text = "SIP"
                    viewSquare.addSubview(self.getSIPImageView())
                    
                    // TO BUY UI..... BUY START
                    var lblFundName : UILabel!
                    lblFundName = UILabel(frame: CGRect(x: 54, y: 8, width: viewSquare.frame.size.width-53, height: 40));
                    lblFundName.text = objOrders.SrcSchemeName.capitalizedString
                    if objOrders.SrcSchemeName=="" {
                        lblFundName.text = "Scheme Name - N/A"
                    }
                    lblFundName.font = FONT_SIZE_CELL_TITLE
                    lblFundName.textColor = FONT_COLOR_CELL_TITLE
                    lblFundName.textAlignment = .Left
                    lblFundName.numberOfLines = 0
                    viewSquare.addSubview(lblFundName)
                    
                    var lblSIPAmount : UILabel!
                    lblSIPAmount = UILabel(frame: CGRect(x: 54, y: 48, width: viewSquare.frame.size.width-53, height: 15));
                    lblSIPAmount.text = "SIP Amount : -"
                    let amount = (objOrders.Volume as NSString).doubleValue
                    
                    let num = NSNumber(double: amount)
                    let formatr : NSNumberFormatter = NSNumberFormatter()
                    formatr.numberStyle = .CurrencyStyle
                    formatr.locale = NSLocale(localeIdentifier: "en_IN")
                    if let stringDT = formatr.stringFromNumber(num)
                    {
                        lblSIPAmount.text = "SIP Amount : \(stringDT)"
                    }
                    lblSIPAmount.font = UIFont.systemFontOfSize(12)
                    lblSIPAmount.textColor = FONT_COLOR_CELL_SUB_TITLE
                    lblSIPAmount.textAlignment = .Left
                    viewSquare.addSubview(lblSIPAmount)
                    
                    
                    var lblFre : UILabel!
                    lblFre = UILabel(frame: CGRect(x: 54, y: 63, width: viewSquare.frame.size.width-53, height: 15));
                    lblFre.text = "Frequency : -"
                    lblFre.font = FONT_SIZE_CELL_SUB_TITLE
                    lblFre.textColor = FONT_COLOR_CELL_SUB_TITLE
                    lblFre.textAlignment = .Left
                    viewSquare.addSubview(lblFre)
                    
                    
                    var lblStartD : UILabel!
                    lblStartD = UILabel(frame: CGRect(x: 54, y: 78, width: viewSquare.frame.size.width-53, height: 15));
                    if (objSystematicOrder.Day != nil) && (objSystematicOrder.Start_Month != nil) {
                        let enumStartMonth = MONTH.fromHashValue((Int(objSystematicOrder.Start_Month))!)
                        lblStartD.text = "Start Date : \(objSystematicOrder.Day)-\(MONTH.allValues[enumStartMonth.hashValue])-\(objSystematicOrder.Start_Year)"
                    }else{
                        lblStartD.text = "Start Date : -"
                    }
                    lblStartD.font = FONT_SIZE_CELL_SUB_TITLE
                    lblStartD.textColor = FONT_COLOR_CELL_SUB_TITLE
                    lblStartD.textAlignment = .Left
                    viewSquare.addSubview(lblStartD)
                    
                    var lblNoOI : UILabel!
                    lblNoOI = UILabel(frame: CGRect(x: 54, y: 93, width: viewSquare.frame.size.width-53, height: 15));
                    lblNoOI.font = FONT_SIZE_CELL_SUB_TITLE
                    lblNoOI.textColor = FONT_COLOR_CELL_SUB_TITLE
                    lblNoOI.textAlignment = .Left
                    viewSquare.addSubview(lblNoOI)
                    
                    if objSystematicOrder.Frequency != nil {
                        let frequencyToSend = sharedInstance.getFullNameFromFrequency(objSystematicOrder.Frequency)
                        lblFre.text = "Frequency : \(frequencyToSend)"
                        if frequencyToSend=="Monthly" || frequencyToSend=="Quarterly" || frequencyToSend=="Half Yearly" || frequencyToSend=="Annual" || frequencyToSend=="Bi Monthly"
                        {
                            if objSystematicOrder.NoOfInstallments != nil {
                                lblNoOI.text = "No of Installments : \(objSystematicOrder.NoOfInstallments)"
                            }
                        }else{
                            let enumEndMonth = MONTH.fromHashValue((Int(objSystematicOrder.End_Month))!)
                            lblNoOI.text = "End Date : \(MONTH.allValues[enumEndMonth.hashValue])-\(objSystematicOrder.End_Year)"
                        }
                    }
                    
                    var lblNAV : UILabel!
                    lblNAV = UILabel(frame: CGRect(x: 54, y: 108, width: viewSquare.frame.size.width-53, height: 15));
                    if objOrders.txnPurchaseNav != nil {
                        let nv = Double(objOrders.txnPurchaseNav)
                        let Nav = String(format: "%.2f", nv!)
                        lblNAV.text = "NAV : \(Nav)"
                    }else{
                        lblNAV.text = "NAV : -"
                    }
                    
                    lblNAV.font = FONT_SIZE_CELL_SUB_TITLE
                    lblNAV.textColor = FONT_COLOR_CELL_SUB_TITLE
                    lblNAV.textAlignment = .Left
                    viewSquare.addSubview(lblNAV)
                    
                    
                    var lblUnits : UILabel!
                    lblUnits = UILabel(frame: CGRect(x: 54, y: 123, width: viewSquare.frame.size.width-53, height: 15));
                    if objOrders.txnPurchaseUnits != nil {
                        let un = Double(objOrders.txnPurchaseUnits)
                        let Units = String(format: "%.2f", un!)
                        lblUnits.text = "Units : \(Units)"
                    }else{
                        lblUnits.text = "Units : -"
                    }
                    
                    lblUnits.font = FONT_SIZE_CELL_SUB_TITLE
                    lblUnits.textColor = FONT_COLOR_CELL_SUB_TITLE
                    lblUnits.textAlignment = .Left
                    viewSquare.addSubview(lblUnits)
                    
                    var lblOrderOd : UILabel!
                    lblOrderOd = UILabel(frame: CGRect(x: 54, y: 138, width: viewSquare.frame.size.width-53, height: 15));
                    lblOrderOd.text = "Order Id : \(objOrders.ServerOrderID)"
                    lblOrderOd.font = FONT_SIZE_CELL_SUB_TITLE
                    lblOrderOd.textColor = FONT_COLOR_CELL_SUB_TITLE
                    lblOrderOd.textAlignment = .Left
                    viewSquare.addSubview(lblOrderOd)
                    
                    
                    var lblDATE : UILabel!
                    lblDATE = UILabel(frame: CGRect(x: 54, y: 153, width: viewSquare.frame.size.width-53, height: 15));
                    lblDATE.font = FONT_SIZE_CELL_SUB_TITLE
                    lblDATE.textColor = FONT_COLOR_CELL_SUB_TITLE
                    lblDATE.textAlignment = .Left
                    viewSquare.addSubview(lblDATE)
                    lblDATE.text = "Order Date : \(sharedInstance.getFormatedDate(objOrders.executionDateTime))"
                    
                    var lblOrderStatus : UILabel!
                    lblOrderStatus = UILabel(frame: CGRect(x: 54, y: 168, width: viewSquare.frame.size.width-53, height: 15));
                    lblOrderStatus.text = "Order Status : \(OrderStatus.allValues[enumOrderStatus.hashValue])"
                    lblOrderStatus.font = FONT_SIZE_CELL_SUB_TITLE
                    lblOrderStatus.textColor = FONT_COLOR_CELL_SUB_TITLE
                    lblOrderStatus.textAlignment = .Left
                    viewSquare.addSubview(lblOrderStatus)
                    
                    return cell

                }else{
                    
                    viewSquare.frame = CGRect(x: 10, y: 2, width: (cell.contentView.frame.size.width)-20, height: 149)
                    lblType.text = "SIP"
                    viewSquare.addSubview(self.getSIPImageView())
                    
                    // TO BUY UI..... BUY START
                    var lblFundName : UILabel!
                    lblFundName = UILabel(frame: CGRect(x: 54, y: 8, width: viewSquare.frame.size.width-53, height: 40));
                    lblFundName.text = objOrders.SrcSchemeName.capitalizedString
                    if objOrders.SrcSchemeName=="" {
                        lblFundName.text = "Scheme Name - N/A"
                    }
                    lblFundName.font = FONT_SIZE_CELL_TITLE
                    lblFundName.textColor = FONT_COLOR_CELL_TITLE
                    lblFundName.textAlignment = .Left
                    lblFundName.numberOfLines = 0
                    viewSquare.addSubview(lblFundName)
                    
                    var lblSIPAmount : UILabel!
                    lblSIPAmount = UILabel(frame: CGRect(x: 54, y: 48, width: viewSquare.frame.size.width-53, height: 15));
                    lblSIPAmount.text = "SIP Amount : -"
                    let amount = (objOrders.Volume as NSString).doubleValue
                    
                    let num = NSNumber(double: amount)
                    let formatr : NSNumberFormatter = NSNumberFormatter()
                    formatr.numberStyle = .CurrencyStyle
                    formatr.locale = NSLocale(localeIdentifier: "en_IN")
                    if let stringDT = formatr.stringFromNumber(num)
                    {
                        lblSIPAmount.text = "SIP Amount : \(stringDT)"
                    }
                    lblSIPAmount.font = UIFont.systemFontOfSize(12)
                    lblSIPAmount.textColor = FONT_COLOR_CELL_SUB_TITLE
                    lblSIPAmount.textAlignment = .Left
                    viewSquare.addSubview(lblSIPAmount)
                    
                    
                    var lblFre : UILabel!
                    lblFre = UILabel(frame: CGRect(x: 54, y: 63, width: viewSquare.frame.size.width-53, height: 15));
                    lblFre.text = "Frequency : -"
                    lblFre.font = FONT_SIZE_CELL_SUB_TITLE
                    lblFre.textColor = FONT_COLOR_CELL_SUB_TITLE
                    lblFre.textAlignment = .Left
                    viewSquare.addSubview(lblFre)
                    
                    var lblStartD : UILabel!
                    lblStartD = UILabel(frame: CGRect(x: 54, y: 78, width: viewSquare.frame.size.width-53, height: 15));
                    if (objSystematicOrder.Day != nil) && (objSystematicOrder.Start_Month != nil) {
                        let enumStartMonth = MONTH.fromHashValue((Int(objSystematicOrder.Start_Month))!)
                        lblStartD.text = "Start Date : \(objSystematicOrder.Day)-\(MONTH.allValues[enumStartMonth.hashValue])-\(objSystematicOrder.Start_Year)"
                    }else{
                        lblStartD.text = "Start Date : -"
                    }
                    lblStartD.font = FONT_SIZE_CELL_SUB_TITLE
                    lblStartD.textColor = FONT_COLOR_CELL_SUB_TITLE
                    lblStartD.textAlignment = .Left
                    viewSquare.addSubview(lblStartD)
                    
                    
                    var lblNoOI : UILabel!
                    lblNoOI = UILabel(frame: CGRect(x: 54, y: 93, width: viewSquare.frame.size.width-53, height: 15));
                    lblNoOI.font = FONT_SIZE_CELL_SUB_TITLE
                    lblNoOI.textColor = FONT_COLOR_CELL_SUB_TITLE
                    lblNoOI.textAlignment = .Left
                    viewSquare.addSubview(lblNoOI)
                    
                    if objSystematicOrder.Frequency != nil {
                        let frequencyToSend = sharedInstance.getFullNameFromFrequency(objSystematicOrder.Frequency)
                        lblFre.text = "Frequency : \(frequencyToSend)"
                        if frequencyToSend=="Monthly" || frequencyToSend=="Quarterly" || frequencyToSend=="Half Yearly" || frequencyToSend=="Annual" || frequencyToSend=="Bi Monthly"
                        {
                            if objSystematicOrder.NoOfInstallments != nil {
                                lblNoOI.text = "No of Installments : \(objSystematicOrder.NoOfInstallments)"
                            }
                        }else{
                            let enumEndMonth = MONTH.fromHashValue((Int(objSystematicOrder.End_Month))!)
                            lblNoOI.text = "End Date : \(MONTH.allValues[enumEndMonth.hashValue])-\(objSystematicOrder.End_Year)"
                        }
                    }
                    
                    
//                    var lblNAV : UILabel!
//                    lblNAV = UILabel(frame: CGRect(x: 54, y: 105, width: viewSquare.frame.size.width-53, height: 15));
//                    let nv = Double(objOrders.txnPurchaseNav)
//                    let Nav = String(format: "%.2f", nv!)
//                    
//                    lblNAV.text = "NAV : \(Nav)"
//                    lblNAV.font = FONT_SIZE_CELL_SUB_TITLE
//                    lblNAV.textColor = FONT_COLOR_CELL_SUB_TITLE
//                    lblNAV.textAlignment = .Left
//                    viewSquare.addSubview(lblNAV)
//                    
//                    
//                    var lblUnits : UILabel!
//                    lblUnits = UILabel(frame: CGRect(x: 54, y: 120, width: viewSquare.frame.size.width-53, height: 15));
//                    let un = Double(objOrders.txnPurchaseUnits)
//                    let Units = String(format: "%.2f", un!)
//                    
//                    lblUnits.text = "Units : \(Units)"
//                    lblUnits.font = FONT_SIZE_CELL_SUB_TITLE
//                    lblUnits.textColor = FONT_COLOR_CELL_SUB_TITLE
//                    lblUnits.textAlignment = .Left
//                    viewSquare.addSubview(lblUnits)
                    
                    var lblOrderOd : UILabel!
                    lblOrderOd = UILabel(frame: CGRect(x: 54, y: 108, width: viewSquare.frame.size.width-53, height: 15));
                    lblOrderOd.text = "Order Id : \(objOrders.ServerOrderID)"
                    lblOrderOd.font = FONT_SIZE_CELL_SUB_TITLE
                    lblOrderOd.textColor = FONT_COLOR_CELL_SUB_TITLE
                    lblOrderOd.textAlignment = .Left
                    viewSquare.addSubview(lblOrderOd)
                    
                    
//                    var lblDATE : UILabel!
//                    lblDATE = UILabel(frame: CGRect(x: 54, y: 150, width: viewSquare.frame.size.width-53, height: 15));
//                    lblDATE.font = FONT_SIZE_CELL_SUB_TITLE
//                    lblDATE.textColor = FONT_COLOR_CELL_SUB_TITLE
//                    lblDATE.textAlignment = .Left
//                    viewSquare.addSubview(lblDATE)
//                    lblDATE.text = "Order Date : \(sharedInstance.getFormatedDate(objOrders.executionDateTime))"
                    
                    var lblOrderStatus : UILabel!
                    lblOrderStatus = UILabel(frame: CGRect(x: 54, y: 123, width: viewSquare.frame.size.width-53, height: 15));
                    lblOrderStatus.text = "Order Status : \(OrderStatus.allValues[enumOrderStatus.hashValue])"
                    lblOrderStatus.font = FONT_SIZE_CELL_SUB_TITLE
                    lblOrderStatus.textColor = FONT_COLOR_CELL_SUB_TITLE
                    lblOrderStatus.textAlignment = .Left
                    viewSquare.addSubview(lblOrderStatus)
                    
                    return cell

                }
                
                // TO BUY UI..... BUY END...
            }
            
            
            if isFor=="REDEEM" {
                

                if enumOrderStatus==OrderStatus.RP {
                    
                    viewSquare.frame = CGRect(x: 10, y: 2, width: (cell.contentView.frame.size.width)-20, height: 169)
                    lblType.text = "Redeem"
                    viewSquare.addSubview(self.getRedeemImageView())
                    
                    // TO REDEEM UI..... REDEEM START
                    var lblFundName : UILabel!
                    lblFundName = UILabel(frame: CGRect(x: 54, y: 8, width: viewSquare.frame.size.width-53, height: 40));
                    lblFundName.text = objOrders.SrcSchemeName.capitalizedString
                    if objOrders.SrcSchemeName=="" {
                        lblFundName.text = "Scheme Name - N/A"
                    }
                    lblFundName.font = FONT_SIZE_CELL_TITLE
                    lblFundName.textColor = FONT_COLOR_CELL_TITLE
                    lblFundName.textAlignment = .Left
                    lblFundName.numberOfLines = 0
                    viewSquare.addSubview(lblFundName)
                    
                    
                    var lblFolio : UILabel!
                    lblFolio = UILabel(frame: CGRect(x: 54, y: 48, width: viewSquare.frame.size.width-53, height: 15));
                    lblFolio.text = "Folio Number : \(objOrders.FolioNo)"
                    lblFolio.font = FONT_SIZE_CELL_SUB_TITLE
                    lblFolio.textColor = FONT_COLOR_CELL_SUB_TITLE
                    lblFolio.textAlignment = .Left
                    viewSquare.addSubview(lblFolio)
                    
                    var tp = ""
                    if objOrders.VolumeType=="E" {
                        tp = "All Units"
                    }
                    if objOrders.VolumeType=="U" {
                        tp = "Units"
                    }
                    if objOrders.VolumeType=="A" {
                        tp = "Amount"
                    }
                    
                    var lblRedeemType : UILabel!
                    lblRedeemType = UILabel(frame: CGRect(x: 54, y: 63, width: viewSquare.frame.size.width-53, height: 15));
                    lblRedeemType.text = "Redeem Type : \(tp)"
                    lblRedeemType.font = FONT_SIZE_CELL_SUB_TITLE
                    lblRedeemType.textColor = FONT_COLOR_CELL_SUB_TITLE
                    lblRedeemType.textAlignment = .Left
                    viewSquare.addSubview(lblRedeemType)
                    
                    
                    var lblNAV : UILabel!
                    lblNAV = UILabel(frame: CGRect(x: 54, y: 78, width: viewSquare.frame.size.width-53, height: 15));
                    let nv = Double(objOrders.txnPurchaseNav)
                    let Nav = String(format: "%.2f", nv!)
                    
                    lblNAV.text = "NAV : \(Nav)"
                    lblNAV.font = FONT_SIZE_CELL_SUB_TITLE
                    lblNAV.textColor = FONT_COLOR_CELL_SUB_TITLE
                    lblNAV.textAlignment = .Left
                    viewSquare.addSubview(lblNAV)
                    
                    
                    var lblUnits : UILabel!
                    lblUnits = UILabel(frame: CGRect(x: 54, y: 93, width: viewSquare.frame.size.width-53, height: 15));
                    let un = Double(objOrders.txnPurchaseUnits)
                    let Units = String(format: "%.2f", un!)
                    
                    lblUnits.text = "Units : \(Units)"
                    lblUnits.font = FONT_SIZE_CELL_SUB_TITLE
                    lblUnits.textColor = FONT_COLOR_CELL_SUB_TITLE
                    lblUnits.textAlignment = .Left
                    viewSquare.addSubview(lblUnits)
                    
                    var lblOrderOd : UILabel!
                    lblOrderOd = UILabel(frame: CGRect(x: 54, y: 108, width: viewSquare.frame.size.width-53, height: 15));
                    lblOrderOd.text = "Order Id : \(objOrders.ServerOrderID)"
                    lblOrderOd.font = FONT_SIZE_CELL_SUB_TITLE
                    lblOrderOd.textColor = FONT_COLOR_CELL_SUB_TITLE
                    lblOrderOd.textAlignment = .Left
                    viewSquare.addSubview(lblOrderOd)
                    
                    
                    var lblDATE : UILabel!
                    lblDATE = UILabel(frame: CGRect(x: 54, y: 123, width: viewSquare.frame.size.width-53, height: 15));
                    lblDATE.font = FONT_SIZE_CELL_SUB_TITLE
                    lblDATE.textColor = FONT_COLOR_CELL_SUB_TITLE
                    lblDATE.textAlignment = .Left
                    viewSquare.addSubview(lblDATE)
                    lblDATE.text = "Execution Date : \(sharedInstance.getFormatedDate(objOrders.executionDateTime))"
                    
                    var lblOrderStatus : UILabel!
                    lblOrderStatus = UILabel(frame: CGRect(x: 54, y: 138, width: viewSquare.frame.size.width-53, height: 15));
                    lblOrderStatus.text = "Order Status : \(OrderStatus.allValues[enumOrderStatus.hashValue])"
                    
                    lblOrderStatus.font = FONT_SIZE_CELL_SUB_TITLE
                    lblOrderStatus.textColor = FONT_COLOR_CELL_SUB_TITLE
                    lblOrderStatus.textAlignment = .Left
                    viewSquare.addSubview(lblOrderStatus)
                    
                    return cell

                }else{
                    
                    viewSquare.frame = CGRect(x: 10, y: 2, width: (cell.contentView.frame.size.width)-20, height: 116)
                    lblType.text = "Redeem"
                    viewSquare.addSubview(self.getRedeemImageView())
                    
                    // TO REDEEM UI..... REDEEM START
                    var lblFundName : UILabel!
                    lblFundName = UILabel(frame: CGRect(x: 54, y: 8, width: viewSquare.frame.size.width-53, height: 40));
                    lblFundName.text = objOrders.SrcSchemeName.capitalizedString
                    if objOrders.SrcSchemeName=="" {
                        lblFundName.text = "Scheme Name - N/A"
                    }
                    lblFundName.font = FONT_SIZE_CELL_TITLE
                    lblFundName.textColor = FONT_COLOR_CELL_TITLE
                    lblFundName.textAlignment = .Left
                    lblFundName.numberOfLines = 0
                    viewSquare.addSubview(lblFundName)
                    
                    
                    var lblFolio : UILabel!
                    lblFolio = UILabel(frame: CGRect(x: 54, y: 48, width: viewSquare.frame.size.width-53, height: 15));
                    lblFolio.text = "Folio Number : \(objOrders.FolioNo)"
                    lblFolio.font = FONT_SIZE_CELL_SUB_TITLE
                    lblFolio.textColor = FONT_COLOR_CELL_SUB_TITLE
                    lblFolio.textAlignment = .Left
                    viewSquare.addSubview(lblFolio)
                    
                    
                    
                    var lblRedeemType : UILabel!
                    lblRedeemType = UILabel(frame: CGRect(x: 54, y: 63, width: viewSquare.frame.size.width-53, height: 15));
                    if objOrders.VolumeType=="U" { // Units
                        lblRedeemType.text = "Units : \(objOrders.Volume)"
                    }
                    if objOrders.VolumeType=="A" { // Amount
                        
                        let num = NSNumber(double: Double(objOrders.Volume)!)
                        
                        let formatr : NSNumberFormatter = NSNumberFormatter()
                        formatr.numberStyle = .CurrencyStyle
                        formatr.locale = NSLocale(localeIdentifier: "en_IN")
                        if let stringDT = formatr.stringFromNumber(num)
                        {
                            lblRedeemType.text = "Amount : \(stringDT)"
                        }
                        
                    }
                    if objOrders.VolumeType=="E" { // All Units
                        lblRedeemType.text = "Units : All Units"
                        
                    }
                    lblRedeemType.font = FONT_SIZE_CELL_SUB_TITLE
                    lblRedeemType.textColor = FONT_COLOR_CELL_SUB_TITLE
                    lblRedeemType.textAlignment = .Left
                    viewSquare.addSubview(lblRedeemType)
                    
                    
                    //                    var lblNAV : UILabel!
                    //                    lblNAV = UILabel(frame: CGRect(x: 54, y: 75, width: viewSquare.frame.size.width-53, height: 15));
                    //                    let nv = Double(objOrders.txnPurchaseNav)
                    //                    let Nav = String(format: "%.2f", nv!)
                    //
                    //                    lblNAV.text = "NAV : \(Nav)"
                    //                    lblNAV.font = FONT_SIZE_CELL_SUB_TITLE
                    //                    lblNAV.textColor = FONT_COLOR_CELL_SUB_TITLE
                    //                    lblNAV.textAlignment = .Left
                    //                    viewSquare.addSubview(lblNAV)
                    
                    
                    //                    var lblUnits : UILabel!
                    //                    lblUnits = UILabel(frame: CGRect(x: 54, y: 90, width: viewSquare.frame.size.width-53, height: 15));
                    //                    let un = Double(objOrders.txnPurchaseUnits)
                    //                    let Units = String(format: "%.2f", un!)
                    //
                    //                    lblUnits.text = "Units : \(Units)"
                    //                    lblUnits.font = FONT_SIZE_CELL_SUB_TITLE
                    //                    lblUnits.textColor = FONT_COLOR_CELL_SUB_TITLE
                    //                    lblUnits.textAlignment = .Left
                    //                    viewSquare.addSubview(lblUnits)
                    
                    var lblOrderOd : UILabel!
                    lblOrderOd = UILabel(frame: CGRect(x: 54, y: 78, width: viewSquare.frame.size.width-53, height: 15));
                    lblOrderOd.text = "Order Id : \(objOrders.ServerOrderID)"
                    lblOrderOd.font = FONT_SIZE_CELL_SUB_TITLE
                    lblOrderOd.textColor = FONT_COLOR_CELL_SUB_TITLE
                    lblOrderOd.textAlignment = .Left
                    viewSquare.addSubview(lblOrderOd)
                    
                    
                    //                    var lblDATE : UILabel!
                    //                    lblDATE = UILabel(frame: CGRect(x: 54, y: 120, width: viewSquare.frame.size.width-53, height: 15));
                    //                    lblDATE.font = FONT_SIZE_CELL_SUB_TITLE
                    //                    lblDATE.textColor = FONT_COLOR_CELL_SUB_TITLE
                    //                    lblDATE.textAlignment = .Left
                    //                    viewSquare.addSubview(lblDATE)
                    //                    lblDATE.text = "Execution Date : \(sharedInstance.getFormatedDate(objOrders.executionDateTime))"
                    
                    var lblOrderStatus : UILabel!
                    lblOrderStatus = UILabel(frame: CGRect(x: 54, y: 93, width: viewSquare.frame.size.width-53, height: 15));
                    lblOrderStatus.text = "Order Status : \(OrderStatus.allValues[enumOrderStatus.hashValue])"
                    
                    lblOrderStatus.font = FONT_SIZE_CELL_SUB_TITLE
                    lblOrderStatus.textColor = FONT_COLOR_CELL_SUB_TITLE
                    lblOrderStatus.textAlignment = .Left
                    viewSquare.addSubview(lblOrderStatus)
                    
                    return cell

                }
                
                // TO REDEEM UI..... REDEEM END...
                
            }
            
            
            if isFor=="SWITCH" {
                
                if enumOrderStatus==OrderStatus.RP {
                    
                    viewSquare.frame = CGRect(x: 10, y: 2, width: (cell.contentView.frame.size.width)-20, height: 198)
                    lblType.text = "Switch"
                    viewSquare.addSubview(self.getSwitchImageView())
                    
                    var lblFundName : UILabel!
                    lblFundName = UILabel(frame: CGRect(x: 54, y: 8, width: viewSquare.frame.size.width-53, height: 40));
                    lblFundName.text = objOrders.SrcSchemeName.capitalizedString
                    if objOrders.SrcSchemeName=="" {
                        lblFundName.text = "Scheme Name - N/A"
                    }
                    lblFundName.font = FONT_SIZE_CELL_TITLE
                    lblFundName.textColor = FONT_COLOR_CELL_TITLE
                    lblFundName.textAlignment = .Left
                    lblFundName.numberOfLines = 0
                    viewSquare.addSubview(lblFundName)
                    
                    var lblSwitTo : UILabel!
                    lblSwitTo = UILabel(frame: CGRect(x: 54, y: 48, width: viewSquare.frame.size.width-53, height: 35));
                    lblSwitTo.text = "Switch to : \(objOrders.TarSchemeName.capitalizedString)"
                    lblSwitTo.font = FONT_SIZE_CELL_SUB_TITLE
                    lblSwitTo.textColor = FONT_COLOR_CELL_SUB_TITLE
                    lblSwitTo.textAlignment = .Left
                    lblSwitTo.numberOfLines = 2
                    viewSquare.addSubview(lblSwitTo)
                    
                    
                    var lblFolio : UILabel!
                    lblFolio = UILabel(frame: CGRect(x: 54, y: 83, width: viewSquare.frame.size.width-53, height: 15));
                    lblFolio.text = "Folio Number : \(objOrders.FolioNo)"
                    lblFolio.font = FONT_SIZE_CELL_SUB_TITLE
                    lblFolio.textColor = FONT_COLOR_CELL_SUB_TITLE
                    lblFolio.textAlignment = .Left
                    viewSquare.addSubview(lblFolio)
                    
                    
                    
                    var lblPurchaseAmount : UILabel!
                    lblPurchaseAmount = UILabel(frame: CGRect(x: 54, y: 98, width: viewSquare.frame.size.width-53, height: 15));
                    lblPurchaseAmount.text = "Amount : -"
                    let amount = (objOrders.txnPurchaseAmount as NSString).doubleValue
                    
                    let num = NSNumber(double: amount)
                    let formatr : NSNumberFormatter = NSNumberFormatter()
                    formatr.numberStyle = .CurrencyStyle
                    formatr.locale = NSLocale(localeIdentifier: "en_IN")
                    if let stringDT = formatr.stringFromNumber(num)
                    {
                        lblPurchaseAmount.text = "Amount : \(stringDT)"
                    }
                    lblPurchaseAmount.font = FONT_SIZE_CELL_SUB_TITLE
                    lblPurchaseAmount.textColor = FONT_COLOR_CELL_SUB_TITLE
                    lblPurchaseAmount.textAlignment = .Left
                    viewSquare.addSubview(lblPurchaseAmount)
                    
                    var lblNAV : UILabel!
                    lblNAV = UILabel(frame: CGRect(x: 54, y: 113, width: viewSquare.frame.size.width-53, height: 15));
                    let nv = Double(objOrders.txnPurchaseNav)
                    let Nav = String(format: "%.2f", nv!)
                    
                    lblNAV.text = "NAV : \(Nav)"
                    lblNAV.font = FONT_SIZE_CELL_SUB_TITLE
                    lblNAV.textColor = FONT_COLOR_CELL_SUB_TITLE
                    lblNAV.textAlignment = .Left
                    viewSquare.addSubview(lblNAV)
                    
                    var lblUnits : UILabel!
                    lblUnits = UILabel(frame: CGRect(x: 54, y: 128, width: viewSquare.frame.size.width-53, height: 15));
                    let un = Double(objOrders.txnPurchaseUnits)
                    let Units = String(format: "%.2f", un!)
                    
                    lblUnits.text = "Units : \(Units)"
                    lblUnits.font = FONT_SIZE_CELL_SUB_TITLE
                    lblUnits.textColor = FONT_COLOR_CELL_SUB_TITLE
                    lblUnits.textAlignment = .Left
                    viewSquare.addSubview(lblUnits)
                    
                    var lblOrderOd : UILabel!
                    lblOrderOd = UILabel(frame: CGRect(x: 54, y: 143, width: viewSquare.frame.size.width-53, height: 15));
                    lblOrderOd.text = "Order Id : \(objOrders.ServerOrderID)"
                    lblOrderOd.font = FONT_SIZE_CELL_SUB_TITLE
                    lblOrderOd.textColor = FONT_COLOR_CELL_SUB_TITLE
                    lblOrderOd.textAlignment = .Left
                    viewSquare.addSubview(lblOrderOd)
                    
                    var lblDATE : UILabel!
                    lblDATE = UILabel(frame: CGRect(x: 54, y: 158, width: viewSquare.frame.size.width-53, height: 15));
                    lblDATE.font = FONT_SIZE_CELL_SUB_TITLE
                    lblDATE.textColor = FONT_COLOR_CELL_SUB_TITLE
                    lblDATE.textAlignment = .Left
                    viewSquare.addSubview(lblDATE)
                    lblDATE.text = "Execution Date : \(sharedInstance.getFormatedDate(objOrders.executionDateTime))"
                    
                    var lblOrderStatus : UILabel!
                    lblOrderStatus = UILabel(frame: CGRect(x: 54, y: 173, width: viewSquare.frame.size.width-53, height: 15));
                    lblOrderStatus.text = "Order Status : \(OrderStatus.allValues[enumOrderStatus.hashValue])"
                    lblOrderStatus.font = FONT_SIZE_CELL_SUB_TITLE
                    lblOrderStatus.textColor = FONT_COLOR_CELL_SUB_TITLE
                    lblOrderStatus.textAlignment = .Left
                    viewSquare.addSubview(lblOrderStatus)
                    
                    return cell
                    
                }else{
                    
                    viewSquare.frame = CGRect(x: 10, y: 2, width: (cell.contentView.frame.size.width)-20, height: 154)
                    lblType.text = "Switch"
                    viewSquare.addSubview(self.getSwitchImageView())
                    
                    var lblFundName : UILabel!
                    lblFundName = UILabel(frame: CGRect(x: 54, y: 8, width: viewSquare.frame.size.width-53, height: 40));
                    lblFundName.text = objOrders.SrcSchemeName.capitalizedString
                    if objOrders.SrcSchemeName=="" {
                        lblFundName.text = "Scheme Name - N/A"
                    }
                    lblFundName.font = FONT_SIZE_CELL_TITLE
                    lblFundName.textColor = FONT_COLOR_CELL_TITLE
                    lblFundName.textAlignment = .Left
                    lblFundName.numberOfLines = 0
                    viewSquare.addSubview(lblFundName)
                    
                    var lblSwitTo : UILabel!
                    lblSwitTo = UILabel(frame: CGRect(x: 54, y: 48, width: viewSquare.frame.size.width-53, height: 35));
                    lblSwitTo.text = "Switch to : \(objOrders.TarSchemeName.capitalizedString)"
                    lblSwitTo.font = FONT_SIZE_CELL_SUB_TITLE
                    lblSwitTo.textColor = FONT_COLOR_CELL_SUB_TITLE
                    lblSwitTo.textAlignment = .Left
                    lblSwitTo.numberOfLines = 2
                    viewSquare.addSubview(lblSwitTo)
                    
                    
                    var lblFolio : UILabel!
                    lblFolio = UILabel(frame: CGRect(x: 54, y: 83, width: viewSquare.frame.size.width-53, height: 15));
                    lblFolio.text = "Folio Number : \(objOrders.FolioNo)"
                    lblFolio.font = FONT_SIZE_CELL_SUB_TITLE
                    lblFolio.textColor = FONT_COLOR_CELL_SUB_TITLE
                    lblFolio.textAlignment = .Left
                    viewSquare.addSubview(lblFolio)
                    
                    
                    
                    var lblPurchaseAmount : UILabel!
                    lblPurchaseAmount = UILabel(frame: CGRect(x: 54, y: 98, width: viewSquare.frame.size.width-53, height: 15));
                    
                    if objOrders.VolumeType=="U" { // Units
                        if objOrders.Volume != nil{
                            lblPurchaseAmount.text = "Units : \(objOrders.Volume)"
                        }else{
                            lblPurchaseAmount.text = "Amount : -"
                        }
                    }
                    if objOrders.VolumeType=="A" { // Amount
                        
                        if objOrders.Volume != nil{
                            let num = NSNumber(double: Double(objOrders.Volume)!)
                            
                            let formatr : NSNumberFormatter = NSNumberFormatter()
                            formatr.numberStyle = .CurrencyStyle
                            formatr.locale = NSLocale(localeIdentifier: "en_IN")
                            if let stringDT = formatr.stringFromNumber(num)
                            {
                                lblPurchaseAmount.text = "Amount : \(stringDT)"
                            }
                        }else{
                            lblPurchaseAmount.text = "Amount : -"
                        }
                        
                    }
                    if objOrders.VolumeType=="E" { // All Units
                        lblPurchaseAmount.text = "Units : All Units"
                        
                    }
                    
                    
                
                    lblPurchaseAmount.font = FONT_SIZE_CELL_SUB_TITLE
                    lblPurchaseAmount.textColor = FONT_COLOR_CELL_SUB_TITLE
                    lblPurchaseAmount.textAlignment = .Left
                    viewSquare.addSubview(lblPurchaseAmount)
                    
                    
                    
//                    var lblNAV : UILabel!
//                    lblNAV = UILabel(frame: CGRect(x: 54, y: 110, width: viewSquare.frame.size.width-53, height: 15));
//                    let nv = Double(objOrders.txnPurchaseNav)
//                    let Nav = String(format: "%.2f", nv!)
                    
//                    lblNAV.text = "NAV : \(Nav)"
//                    lblNAV.font = FONT_SIZE_CELL_SUB_TITLE
//                    lblNAV.textColor = FONT_COLOR_CELL_SUB_TITLE
//                    lblNAV.textAlignment = .Left
//                    viewSquare.addSubview(lblNAV)
//                    
//                    var lblUnits : UILabel!
//                    lblUnits = UILabel(frame: CGRect(x: 54, y: 125, width: viewSquare.frame.size.width-53, height: 15));
//                    let un = Double(objOrders.txnPurchaseUnits)
//                    let Units = String(format: "%.2f", un!)
//                    
//                    lblUnits.text = "Units : \(Units)"
//                    lblUnits.font = FONT_SIZE_CELL_SUB_TITLE
//                    lblUnits.textColor = FONT_COLOR_CELL_SUB_TITLE
//                    lblUnits.textAlignment = .Left
//                    viewSquare.addSubview(lblUnits)
                    
                    var lblOrderOd : UILabel!
                    lblOrderOd = UILabel(frame: CGRect(x: 54, y: 113, width: viewSquare.frame.size.width-53, height: 15));
                    lblOrderOd.text = "Order Id : \(objOrders.ServerOrderID)"
                    lblOrderOd.font = FONT_SIZE_CELL_SUB_TITLE
                    lblOrderOd.textColor = FONT_COLOR_CELL_SUB_TITLE
                    lblOrderOd.textAlignment = .Left
                    viewSquare.addSubview(lblOrderOd)
                    
//                    var lblDATE : UILabel!
//                    lblDATE = UILabel(frame: CGRect(x: 54, y: 155, width: viewSquare.frame.size.width-53, height: 15));
//                    lblDATE.font = FONT_SIZE_CELL_SUB_TITLE
//                    lblDATE.textColor = FONT_COLOR_CELL_SUB_TITLE
//                    lblDATE.textAlignment = .Left
//                    viewSquare.addSubview(lblDATE)
//                    lblDATE.text = "Execution Date : \(sharedInstance.getFormatedDate(objOrders.executionDateTime))"
                    
                    var lblOrderStatus : UILabel!
                    lblOrderStatus = UILabel(frame: CGRect(x: 54, y: 128, width: viewSquare.frame.size.width-53, height: 15));
                    lblOrderStatus.text = "Order Status : \(OrderStatus.allValues[enumOrderStatus.hashValue])"
                    lblOrderStatus.font = FONT_SIZE_CELL_SUB_TITLE
                    lblOrderStatus.textColor = FONT_COLOR_CELL_SUB_TITLE
                    lblOrderStatus.textAlignment = .Left
                    viewSquare.addSubview(lblOrderStatus)
                    
                    return cell

                }
                
                
                // TO REDEEM UI..... REDEEM END...
            }
            
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

        
        var objOrders = Order()
        objOrders = self.arrOrders.objectAtIndex(indexPath.row) as! Order
        var isFor = "BUY"
        let enumOrderStatus = OrderStatus.fromHashValue((Int(objOrders.OrderStatus))!)

        
        var enumOrderType = OrderType.Buy
        enumOrderType = OrderType.fromHashValue((Int(objOrders.OrderType))!)
        if enumOrderType == OrderType.Buy
        {
            isFor = "BUY"
        }
        else if enumOrderType == OrderType.SIP || enumOrderType == OrderType.BuyPlusSIP
        {
            isFor = "SIP"
        }
        else if enumOrderType == OrderType.RedeemWithOutDocs || enumOrderType == OrderType.RedeemWithDocs
        {
            isFor = "REDEEM"
        }
        else if enumOrderType == OrderType.SwitchWithOutDocs || enumOrderType == OrderType.SwitchWithDocs
        {
            isFor = "SWITCH"
        }
        
        if isFor=="BUY" {
            if enumOrderStatus==OrderStatus.RP {
                return 157
            }else{
                return 112
            }
        }
        if isFor=="SIP" {
            if enumOrderStatus==OrderStatus.RP {
                return 201
            }else{
                return 157
            }
        }
        if isFor=="REDEEM" {
            if enumOrderStatus==OrderStatus.RP {
                return 177
            }else{
                return 124
            }
        }
        if isFor=="SWITCH" {
            if enumOrderStatus==OrderStatus.RP {
                return 206
            }else{
                return 162
            }
        }
        
        return 145

    }

//    if objTransaction.TxtType == MFU_TXN_TYPE_ADDITIONAL_BUY || objTransaction.TxtType == MFU_TXN_TYPE_BUY || objTransaction.TxtType == MFU_TXN_TYPE_SIP || objTransaction.TxtType == MFU_TXN_TYPE_SWITCH_IN || objTransaction.TxtType == MFU_TXN_TYPE_STP_IN{
//    
//    
//    isFor = "BUY"
//    
//    }else if objTransaction.TxtType == MFU_TXN_TYPE_REDEEM || objTransaction.TxtType == MFU_TXN_TYPE_SWP || objTransaction.TxtType == MFU_TXN_TYPE_STP_OUT || objTransaction.TxtType == MFU_TXN_TYPE_SWITCH_OUT{
//    
//    isFor = "REDEEM"
//    
//    }
    

    // DB QUERY....
//    SELECT OrderMaster.*,MF_Transaction.TxnpucharseUnits,MF_Transaction.TxnpuchaseNAV,MF_Transaction.TxnPurchaseAmount,MF_Transaction.ExecutaionDateTime,MF_Transaction.TxtType FROM OrderMaster LEFT JOIN MF_Transaction ON OrderMaster.ServerOrderID=MF_Transaction.OrderId WHERE OrderMaster.ClientID=1
    
    
    // SELECT OrderMaster.*,MF_Transaction.TxnpucharseUnits,MF_Transaction.TxnpuchaseNAV,MF_Transaction.TxnPurchaseAmount,MF_Transaction.ExecutaionDateTime,MF_Transaction.TxtType FROM OrderMaster LEFT JOIN MF_Transaction ON OrderMaster.ServerOrderID=MF_Transaction.OrderId WHERE OrderMaster.ClientID=1
    
    
    
}
