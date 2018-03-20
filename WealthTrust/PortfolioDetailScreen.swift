//
//  PortfolioDetailScreen.swift
//  WealthTrust
//  Created by Hemen Gohil on 11/7/16.
//  Copyright © 2016 Hemen Gohil. All rights reserved.

import UIKit
import Charts

class PortfolioDetailScreen: UIViewController,UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate, ChartViewDelegate {

    @IBOutlet weak var lblBankName: UILabel!
    
    @IBOutlet weak var lblGrandTotal: UILabel!
    
    @IBOutlet weak var lblUnitsNav: UILabel!
    
    @IBOutlet weak var lblFundName: UILabel!
    
    @IBOutlet weak var lblFolioNumber: UILabel!
    
    @IBOutlet weak var scrollableView: UIScrollView!
    
    @IBOutlet weak var viewGraph: LineChartView!
    var objMFAccountDetail = MFAccount()
    var objMfuPortfolioWorthDetail = MfuPortfolioWorth()
    
    @IBOutlet weak var viewRecentTransactions: UIView!
    @IBOutlet weak var childView: UIView!
    
//    @IBOutlet weak var btn13M: UIButton!
//    
//    @IBOutlet weak var btn21Yr: UIButton!
//    
//    @IBOutlet weak var btn3All: UIButton!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var lblLine: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var tbView: UITableView!
    
//    @IBOutlet weak var scrollRecentTrans: UIScrollView!
    
    var isPurchaseAvail = false
    var isRedeemAvail = false
    var arrPurchase = NSMutableArray()
    var arrRedeem = NSMutableArray()
    var arrGraphTransactions = NSMutableArray()

    var currentDate = "currentDate"

//    var selectedMenu = 0
    
//    @IBOutlet weak var tblViewGraph: UITableView!
//    
//    @IBOutlet weak var viewGraphDetailData: UIView!
    
    
    var isFrom = "Wealth"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        SharedManager.addShadowToView(viewGraph)
        SharedManager.addShadowToView(viewRecentTransactions)
//        SharedManager.addShadowToView(viewGraphDetailData)

        let Namee = objMFAccountDetail.AmcName.stringByReplacingOccurrencesOfString("Mutual Fund", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        lblBankName.text = Namee
        
        let currentNav = (objMFAccountDetail.CurrentNAV as NSString).doubleValue
        let purchaseNav = (objMFAccountDetail.puchaseNAV as NSString).doubleValue
        let growth = ((currentNav/purchaseNav)-1) * 100
        var twoDecimalPlaces = String(format: "%.1f", growth)
        
//        var imgArrow : UIImageView!
//        imgArrow = UIImageView(frame: CGRect(x: (cell.contentView.frame.size.width)-35, y: 75, width:20 , height: 20));
        
        let dbl = (twoDecimalPlaces as NSString).doubleValue
        if dbl<0 {
//            imgArrow.image = UIImage(named: "red_arrow")
            twoDecimalPlaces = String(format: "%.1f", (dbl*(-1)))
            
        }else{
//            imgArrow.image = UIImage(named: "green_arrow")
        }
        
        let allUnits = (objMFAccountDetail.pucharseUnits as NSString).doubleValue
        let currentPrice = (objMFAccountDetail.CurrentNAV as NSString).doubleValue
        
        let num = NSNumber(double: (allUnits * currentPrice))
        let formatr : NSNumberFormatter = NSNumberFormatter()
        formatr.numberStyle = .CurrencyStyle
        formatr.locale = NSLocale(localeIdentifier: "en_IN")
        if let stringDT = formatr.stringFromNumber(num)
        {
            lblGrandTotal.text = "\(stringDT) | \(twoDecimalPlaces) %"
        }
        
        lblUnitsNav.text = "UNITS: \(String(format: "%.1f", allUnits)) | NAV: \(String(format: "%.2f", currentPrice))"
        
        self.lblFundName.text = objMFAccountDetail.SchemeName
        
        let last4 = String(objMFAccountDetail.FolioNo.characters.suffix(4))
        self.lblFolioNumber.text = "X- \(last4)"
        if last4=="" {
                self.lblFolioNumber.hidden = true
        }
        
        segmentedControl.selectedSegmentIndex = 2;
        print(segmentedControl.selectedSegmentIndex)
        self.indexChanged(segmentedControl)
        self.viewGraph.setNeedsDisplay()
        self.viewGraph.noDataText = "Please click here to view the chart."
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
	dispatch_async(dispatch_get_main_queue(), { () -> Void in
        	self.loadScrollRecentTrans()
        
//        	self.selectedMenu = 3
//        	self.viewGraphDetailData.hidden = true
        
//        	self.btnAllClick(self.btn3All)
            self.generatePortfolioData()
//            self.updateChartWithData()
	 })
    }

    // MARK: update Chart with data
    
//    func updateChartWithData()
//    {
//        if isFrom == "Wealth"
//        {
//            generateWealthPortfolioChart(objMFAccountDetail)
//        }
//        else
//        {
//            generateManualPortfolioChart(objMFAccountDetail)
//        }
//    }
    
    //Generate Chart for 3 months records.
    func generateWealthPortfolioChart3Months(mfAccount: MFAccount)
    {
        if (Double(mfAccount.pucharseUnits) > 0) {
            let portfolioData = DBManager.getInstance().getMFUPortfolioWorthByAccountIDFor3Months((Int(mfAccount.AccId))!)
            if portfolioData.count>0
            {
                var dates: [String] = []
                var values: [Double] = []
                
                for index in 0..<(portfolioData.count)
                {
                    print(index)
                    let obj = portfolioData.objectAtIndex(index) as! MfuPortfolioWorth
                    let date = obj.portfolio_date
                    let currValue = obj.CurrentValue
                    dates.append(date)
                    values.append(currValue)
                }
                
                setChart(dates, values:values)
            }
        }
    }
    
    func generateManualPortfolioChart3Months(mfAccount: MFAccount) {
        if (Double(mfAccount.pucharseUnits) > 0) {
            let portfolioData = DBManager.getInstance().getManualMFUPortfolioWorthByAccountIDFor3Months((Int(mfAccount.AccId))!)
            
            if portfolioData.count>0
            {
                var dates: [String] = []
                var values: [Double] = []
                
                for index in 0..<(portfolioData.count)
                {
                    print(index)
                    let obj = portfolioData.objectAtIndex(index) as! MfuPortfolioWorth
                    let date = obj.portfolio_date
                    let currValue = obj.CurrentValue
                    dates.append(date)
                    values.append(currValue)
                }
                
                setChart(dates, values:values)
            }
        }
    }
    
    //Generate Chart for 1 year records.
    func generateWealthPortfolioChart1Year(mfAccount: MFAccount)
    {
        if (Double(mfAccount.pucharseUnits) > 0) {
            let portfolioData = DBManager.getInstance().getMFUPortfolioWorthByAccountIDFor1Year((Int(mfAccount.AccId))!)
            if portfolioData.count>0
            {
                var dates: [String] = []
                var values: [Double] = []
                
                for index in 0..<(portfolioData.count)
                {
                    print(index)
                    let obj = portfolioData.objectAtIndex(index) as! MfuPortfolioWorth
                    let date = obj.portfolio_date
                    let currValue = obj.CurrentValue
                    dates.append(date)
                    values.append(currValue)
                }
                
                setChart(dates, values:values)
            }
        }
    }
    
    func generateManualPortfolioChart1Year(mfAccount: MFAccount) {
        if (Double(mfAccount.pucharseUnits) > 0) {
            let portfolioData = DBManager.getInstance().getManualMFUPortfolioWorthByAccountIDFor1Year((Int(mfAccount.AccId))!)
            
            if portfolioData.count>0
            {
                var dates: [String] = []
                var values: [Double] = []
                
                for index in 0..<(portfolioData.count)
                {
                    print(index)
                    let obj = portfolioData.objectAtIndex(index) as! MfuPortfolioWorth
                    let date = obj.portfolio_date
                    let currValue = obj.CurrentValue
                    dates.append(date)
                    values.append(currValue)
                }
                
                setChart(dates, values:values)
            }
        }
    }
    
    //Generate Chart for all records.
    
    func generateWealthPortfolioChartAll(mfAccount: MFAccount)
    {
        if (Double(mfAccount.pucharseUnits) > 0) {
            let portfolioData = DBManager.getInstance().getMFUPortfolioWorthByAccountIDForAll((Int(mfAccount.AccId))!)
            if portfolioData.count>0
            {
                var dates: [String] = []
                var values: [Double] = []
                
                for index in 0..<(portfolioData.count)
                {
                    print(index)
                    let obj = portfolioData.objectAtIndex(index) as! MfuPortfolioWorth
                    let date = obj.portfolio_date
                    let currValue = obj.CurrentValue
                    dates.append(date)
                    values.append(currValue)
                }
                
                setChart(dates, values:values)
            }
        }
    }

    func generateManualPortfolioChartAll(mfAccount: MFAccount)
    {
        if (Double(mfAccount.pucharseUnits) > 0) {
            let portfolioData = DBManager.getInstance().getManualMFUPortfolioWorthByAccountIDForAll((Int(mfAccount.AccId))!)
            
            if portfolioData.count>0
            {
                var dates: [String] = []
                var values: [Double] = []
                
                for index in 0..<(portfolioData.count)
                {
                    print(index)
                    let obj = portfolioData.objectAtIndex(index) as! MfuPortfolioWorth
                    let date = obj.portfolio_date
                    let currValue = obj.CurrentValue
                    dates.append(date)
                    values.append(currValue)
                }
                
                setChart(dates, values:values)
            }
        }
    }
    
    func setChart(dataPoints: [String], values: [Double])
    {
        viewGraph.delegate = self
        viewGraph.legend.enabled = false
        viewGraph.descriptionText = ""
        
        viewGraph.xAxis.labelPosition = .Bottom
        viewGraph.xAxis.drawGridLinesEnabled = false
        viewGraph.xAxis.avoidFirstLastClippingEnabled = true
        
        viewGraph.leftAxis.drawGridLinesEnabled = false
        viewGraph.rightAxis.drawGridLinesEnabled = false
        
        viewGraph.rightAxis.enabled = false
        viewGraph.rightAxis.drawAxisLineEnabled = false
        viewGraph.rightAxis.drawGridLinesEnabled = false
//        viewGraph.rightAxis.labelPosition = .InsideChart
        
        var dataEntries: [ChartDataEntry] = []
        var dates: [String] = []
        var count = 0
        
        for i in 0..<dataPoints.count
        {
            let DataEntry = ChartDataEntry(value: values[i], xIndex:i)
            dataEntries.append(DataEntry)
            dates.append(dataPoints[count])
            
            if (count == dataPoints.count-1) {
                count = 0
            }
            else
            {
                count = count+1
            }
        }
        let lineChartDataSet = LineChartDataSet(yVals: dataEntries, label: "Values")
        lineChartDataSet.axisDependency = .Left
        lineChartDataSet.setCircleColor(UIColor(red:0.00, green:0.48, blue:1.00, alpha:1.0))
        lineChartDataSet.circleRadius = 3.0
        lineChartDataSet.setColor(UIColor(red:0.00, green:0.48, blue:1.00, alpha:1.0).colorWithAlphaComponent(0.5))
        let lineChartData = LineChartData(xVals: dates,dataSet: lineChartDataSet)
        lineChartData.setDrawValues(false)
        viewGraph.data = lineChartData

//        viewGraph.leftAxis.axisMinValue = (viewGraph.data?.yMin)!
//        viewGraph.leftAxis.axisMaxValue = (viewGraph.data?.yMax)!
        viewGraph.leftAxis.labelCount = 2
//        viewGraph.leftAxis.calculate(min: (viewGraph.data?.yMin)!, max: (viewGraph.data?.yMax)!)
//        viewGraph.leftAxis.startAtZeroEnabled = false

        
        //Gradient Fill
        
        let gradientColors = [UIColor(red:0.00, green:0.48, blue:1.00, alpha:1.0).colorWithAlphaComponent(0.5).CGColor, UIColor.clearColor().CGColor] // Colors of the gradient
        let colorLocations:[CGFloat] = [0.5, 0.0] // Positioning of the gradient
        let gradient = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(), gradientColors, colorLocations)
        lineChartDataSet.fill = .fillWithLinearGradient(gradient!, angle: 90.0) // Set the Gradient
//        lineChartDataSet.fill = ChartFill.fillWithRadialGradient(gradient!)
        lineChartDataSet.drawFilledEnabled = true // Draw the Gradient
        
        
    }

    
 // MARK: generate Portfolio Data
    
    func generatePortfolioData()
    {
        if isFrom == "Wealth" {
            generateMFUMutualFundPortfolioForAccount(objMFAccountDetail)
        }
        else {
            generateManualPortfolioData(objMFAccountDetail)
        }
    }
    
    func generateMFUMutualFundPortfolioForAccount(mfAccount : MFAccount) {
        
        if (Double(mfAccount.pucharseUnits) > 0) {
            // Get the Portfolio Last Date. If less than today, proceed.
            // If not, we are already upto-date
            
            // If no records for Portfolio, then call ForFirstTime function
            var portfolioData = DBManager.getInstance().getMFUPortfolioWorthByAccountIDForAll((Int(mfAccount.AccId))!)
            if portfolioData.count==0
            {
                self.generateMFUMutualFundPortfolioForAccountForFirstTime(mfAccount)
                
                portfolioData = DBManager.getInstance().getMFUPortfolioWorthByAccountIDForAll((Int(mfAccount.AccId))!)
            }
            
            // Else Now, get Last Date and Return
            if portfolioData.count>0 {
                let lastFound = portfolioData.lastObject as! MfuPortfolioWorth
                generateMFUMutualFundPortfolioForAccount(mfAccount, mfuPortfolioWorth: lastFound)
            }
        }
    }
    
    func generateManualPortfolioData(mfAccount : MFAccount) {
        
        if (Double(mfAccount.pucharseUnits) > 0) {
            // Get the Portfolio Last Date. If less than today, proceed.
            // If not, we are already upto-date
            
            // If no records for Portfolio, then call ForFirstTime function
            var portfolioData = DBManager.getInstance().getManualMFUPortfolioWorthByAccountIDForAll((Int(mfAccount.AccId))!)
            if portfolioData.count==0
            {
                self.generateManualMFUMutualFundPortfolioForAccountForFirstTime(mfAccount)
                
                portfolioData = DBManager.getInstance().getManualMFUPortfolioWorthByAccountIDForAll((Int(mfAccount.AccId))!)
            }
            
            // Else Now, get Last Date and Return
            if portfolioData.count>0 {
                let lastFound = portfolioData.lastObject as! MfuPortfolioWorth
                generateManualMFUMutualFundPortfolioForAccount(mfAccount, mfuPortfolioWorth: lastFound)
            }
            
        }
    }
    
    func generateManualMFUMutualFundPortfolioForAccount(mfAccount : MFAccount, mfuPortfolioWorth : MfuPortfolioWorth ) {
        
        if (Double(mfAccount.pucharseUnits) > 0) {
            
            if mfuPortfolioWorth.pucharseUnits == Double(mfAccount.pucharseUnits)
            {
                self.getManualMFUPortfolioWorthTillDate(mfAccount, lastDate: mfuPortfolioWorth.portfolio_date, units: mfuPortfolioWorth.pucharseUnits)
                
            }
            else
            {
                // Get All Transactions.. And go Line By Line!
                
                let mfTransactionList = DBManager.getInstance().getManualMFUTransactionsByAccountID(mfAccount.AccId)
                if mfTransactionList.count>0
                {
                    
                    var totalUnits = 0.0
                    
                    let TotlaList = mfTransactionList.count-1
                    var index = 0
                    for i in 0..<TotlaList {
                        let transaction = mfTransactionList.objectAtIndex(i) as! MFTransaction
                        
                        let thisUnit = Double(transaction.TxnpucharseUnits)
                        let patternType = transaction.TxtType
                        
                        if patternType == MFU_TXN_TYPE_ADDITIONAL_BUY || patternType == MFU_TXN_TYPE_BUY || patternType == MFU_TXN_TYPE_SIP || patternType == MFU_TXN_TYPE_SWITCH_IN || patternType == MFU_TXN_TYPE_STP_IN{
                            totalUnits += thisUnit!;
                        }else if patternType == MFU_TXN_TYPE_REDEEM || patternType == MFU_TXN_TYPE_SWP || patternType == MFU_TXN_TYPE_STP_OUT || patternType == MFU_TXN_TYPE_SWITCH_OUT{
                            totalUnits -= thisUnit!;
                        }
                        
                        if totalUnits < 0
                        {
                            totalUnits = 0
                        }
                        
                        if totalUnits == mfuPortfolioWorth.pucharseUnits
                        {
                            break;
                        }
                        index += 1
                    }
                    
                    for i in index..<TotlaList {
                        let transaction = mfTransactionList.objectAtIndex(i) as! MFTransaction
                        let transactionNext = mfTransactionList.objectAtIndex(i+1) as! MFTransaction
                        
                        let date = transaction.ExecutaionDateTime
                        let thisUnit = Double(transaction.TxnpucharseUnits)
                        let patternType = transaction.TxtType
                        
                        if patternType == MFU_TXN_TYPE_ADDITIONAL_BUY || patternType == MFU_TXN_TYPE_BUY || patternType == MFU_TXN_TYPE_SIP || patternType == MFU_TXN_TYPE_SWITCH_IN || patternType == MFU_TXN_TYPE_STP_IN{
                            totalUnits += thisUnit!;
                        }else if patternType == MFU_TXN_TYPE_REDEEM || patternType == MFU_TXN_TYPE_SWP || patternType == MFU_TXN_TYPE_STP_OUT || patternType == MFU_TXN_TYPE_SWITCH_OUT{
                            totalUnits -= thisUnit!;
                        }
                        
                        if totalUnits < 0
                        {
                            totalUnits = 0
                        }
                        
                        let thisNav = transaction.TxnpuchaseNAV
                        let nextDate = transactionNext.ExecutaionDateTime
                        
                        self.getManualMFUPortfolioWorthBetweenDates(mfAccount, startDate: date, endDate: nextDate, startNAV: thisNav, units: String(totalUnits))
                    }
                    
                    
                    // Only from last to Today
                    let transaction = mfTransactionList.lastObject as! MFTransaction
                    //                let thisUnit = transaction.TxnpucharseUnits
                    let patternType = transaction.TxtType
                    
                    if patternType == MFU_TXN_TYPE_ADDITIONAL_BUY || patternType == MFU_TXN_TYPE_BUY || patternType == MFU_TXN_TYPE_SIP || patternType == MFU_TXN_TYPE_SWITCH_IN || patternType == MFU_TXN_TYPE_STP_IN{
                        totalUnits = totalUnits + 1
                    }else if patternType == MFU_TXN_TYPE_REDEEM || patternType == MFU_TXN_TYPE_SWP || patternType == MFU_TXN_TYPE_STP_OUT || patternType == MFU_TXN_TYPE_SWITCH_OUT{
                        totalUnits = totalUnits - 1
                    }
                    
                    if totalUnits < 0
                    {
                        totalUnits = 0
                    }
                    
                    let date = NSDate()
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    let todayDate = dateFormatter.stringFromDate(date)
                    print(todayDate)
                    
                    //                let todayDate = ""
                    
                    self.getManualMFUPortfolioWorthBetweenDates(mfAccount, startDate: transaction.ExecutaionDateTime, endDate: todayDate, startNAV: transaction.TxnpuchaseNAV, units: String(totalUnits))
                    
                    
                }
                // Else What's the point of having a Portfolio Worth! Dont do anything
                
            }
            
            
            
        }
        
    }
    
    func generateMFUMutualFundPortfolioForAccount(mfAccount : MFAccount, mfuPortfolioWorth : MfuPortfolioWorth ) {
        
        if (Double(mfAccount.pucharseUnits) > 0) {
            
            if mfuPortfolioWorth.pucharseUnits == Double(mfAccount.pucharseUnits)
            {
                self.getMFUPortfolioWorthTillDate(mfAccount, lastDate: mfuPortfolioWorth.portfolio_date, units: mfuPortfolioWorth.pucharseUnits)
                
            }
            else
            {
                // Get All Transactions.. And go Line By Line!
                
                let mfTransactionList = DBManager.getInstance().getMFUTransactionsByAccountID(mfAccount.AccId)
                if mfTransactionList.count>0
                {
                    
                    var totalUnits = 0.0
                    
                    let TotlaList = mfTransactionList.count-1
                    var index = 0
                    for i in 0..<TotlaList {
                        let transaction = mfTransactionList.objectAtIndex(i) as! MFTransaction
                    
                        let thisUnit = Double(transaction.TxnpucharseUnits)
                        let patternType = transaction.TxtType
                        
                        if patternType == MFU_TXN_TYPE_ADDITIONAL_BUY || patternType == MFU_TXN_TYPE_BUY || patternType == MFU_TXN_TYPE_SIP || patternType == MFU_TXN_TYPE_SWITCH_IN || patternType == MFU_TXN_TYPE_STP_IN{
                            totalUnits += thisUnit!;
                        }else if patternType == MFU_TXN_TYPE_REDEEM || patternType == MFU_TXN_TYPE_SWP || patternType == MFU_TXN_TYPE_STP_OUT || patternType == MFU_TXN_TYPE_SWITCH_OUT{
                            totalUnits -= thisUnit!;
                        }
                        
                        if totalUnits < 0
                        {
                            totalUnits = 0
                        }
                        
                        if totalUnits == mfuPortfolioWorth.pucharseUnits
                        {
                            break;
                        }
                        index += 1
                    }
                    
                    for i in index..<TotlaList {
                        let transaction = mfTransactionList.objectAtIndex(i) as! MFTransaction
                        let transactionNext = mfTransactionList.objectAtIndex(i+1) as! MFTransaction
                        
                        let date = transaction.ExecutaionDateTime
                        let thisUnit = Double(transaction.TxnpucharseUnits)
                        let patternType = transaction.TxtType
                        
                        if patternType == MFU_TXN_TYPE_ADDITIONAL_BUY || patternType == MFU_TXN_TYPE_BUY || patternType == MFU_TXN_TYPE_SIP || patternType == MFU_TXN_TYPE_SWITCH_IN || patternType == MFU_TXN_TYPE_STP_IN{
                            totalUnits += thisUnit!;
                        }else if patternType == MFU_TXN_TYPE_REDEEM || patternType == MFU_TXN_TYPE_SWP || patternType == MFU_TXN_TYPE_STP_OUT || patternType == MFU_TXN_TYPE_SWITCH_OUT{
                            totalUnits -= thisUnit!;
                        }
                        
                        if totalUnits < 0
                        {
                            totalUnits = 0
                        }
                        
                        let thisNav = transaction.TxnpuchaseNAV
                        let nextDate = transactionNext.ExecutaionDateTime
                        
                        self.getMFUPortfolioWorthBetweenDates(mfAccount, startDate: date, endDate: nextDate, startNAV: thisNav, units: String(totalUnits))
                    }
                    
                    
                    // Only from last to Today
                    let transaction = mfTransactionList.lastObject as! MFTransaction
                    //                let thisUnit = transaction.TxnpucharseUnits
                    let patternType = transaction.TxtType
                    
                    if patternType == MFU_TXN_TYPE_ADDITIONAL_BUY || patternType == MFU_TXN_TYPE_BUY || patternType == MFU_TXN_TYPE_SIP || patternType == MFU_TXN_TYPE_SWITCH_IN || patternType == MFU_TXN_TYPE_STP_IN{
                        totalUnits = totalUnits + 1
                    }else if patternType == MFU_TXN_TYPE_REDEEM || patternType == MFU_TXN_TYPE_SWP || patternType == MFU_TXN_TYPE_STP_OUT || patternType == MFU_TXN_TYPE_SWITCH_OUT{
                        totalUnits = totalUnits - 1
                    }
                    
                    if totalUnits < 0
                    {
                        totalUnits = 0
                    }
                    
                    let date = NSDate()
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    let todayDate = dateFormatter.stringFromDate(date)
                    print(todayDate)
                    
                    //                let todayDate = ""
                    
                    self.getMFUPortfolioWorthBetweenDates(mfAccount, startDate: transaction.ExecutaionDateTime, endDate: todayDate, startNAV: transaction.TxnpuchaseNAV, units: String(totalUnits))
                    
                    
                }
                // Else What's the point of having a Portfolio Worth! Dont do anything

            }
            
            
            
        }
        
    }
    
    func generateManualMFUMutualFundPortfolioForAccountForFirstTime(mfAccount : MFAccount) {
        
        if (Double(mfAccount.pucharseUnits) > 0) {
            
            // Get All Transactions.. And go Line By Line!
            
            let mfTransactionList = DBManager.getInstance().getManualMFUTransactionsByAccountID(mfAccount.AccId)
            if mfTransactionList.count>0
            {
                
                var totalUnits = 0.0
                
                let TotlaList = mfTransactionList.count-1
                for i in 0..<TotlaList {
                    
                    let transaction = mfTransactionList.objectAtIndex(i) as! MFTransaction
                    let transactionNext = mfTransactionList.objectAtIndex(i+1) as! MFTransaction
                    
                    let date = transaction.ExecutaionDateTime
                    let thisUnit = Double(transaction.TxnpucharseUnits)
                    let patternType = transaction.TxtType
                    
                    if patternType == MFU_TXN_TYPE_ADDITIONAL_BUY || patternType == MFU_TXN_TYPE_BUY || patternType == MFU_TXN_TYPE_SIP || patternType == MFU_TXN_TYPE_SWITCH_IN || patternType == MFU_TXN_TYPE_STP_IN{
                        totalUnits += thisUnit!;
                    }else if patternType == MFU_TXN_TYPE_REDEEM || patternType == MFU_TXN_TYPE_SWP || patternType == MFU_TXN_TYPE_STP_OUT || patternType == MFU_TXN_TYPE_SWITCH_OUT{
                        totalUnits -= thisUnit!;
                    }
                    
                    if totalUnits < 0
                    {
                        totalUnits = 0
                    }
                    
                    let thisNav = transaction.TxnpuchaseNAV
                    let nextDate = transactionNext.ExecutaionDateTime
                    
                    self.getManualMFUPortfolioWorthBetweenDates(mfAccount, startDate: date, endDate: nextDate, startNAV: thisNav, units: String(totalUnits))
                }
                
                // Only from last to Today
                let transaction = mfTransactionList.lastObject as! MFTransaction
                let thisUnit = Double(transaction.TxnpucharseUnits)
                let patternType = transaction.TxtType
                
                if patternType == MFU_TXN_TYPE_ADDITIONAL_BUY || patternType == MFU_TXN_TYPE_BUY || patternType == MFU_TXN_TYPE_SIP || patternType == MFU_TXN_TYPE_SWITCH_IN || patternType == MFU_TXN_TYPE_STP_IN{
                    totalUnits += thisUnit!;
                }else if patternType == MFU_TXN_TYPE_REDEEM || patternType == MFU_TXN_TYPE_SWP || patternType == MFU_TXN_TYPE_STP_OUT || patternType == MFU_TXN_TYPE_SWITCH_OUT{
                    totalUnits -= thisUnit!;
                }
                
                if totalUnits < 0
                {
                    totalUnits = 0
                }
                
                let date = NSDate()
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let todayDate = dateFormatter.stringFromDate(date)
                print(todayDate)
                
                //                let todayDate = ""
                
                self.getManualMFUPortfolioWorthBetweenDates(mfAccount, startDate: transaction.ExecutaionDateTime, endDate: todayDate, startNAV: transaction.TxnpuchaseNAV, units: String(totalUnits))
                
                
            }
            // Else What's the point of having a Portfolio Worth! Dont do anything
            
        }
        
    }
    
    func generateMFUMutualFundPortfolioForAccountForFirstTime(mfAccount : MFAccount) {
        
        if (Double(mfAccount.pucharseUnits) > 0) {
            
            // Get All Transactions.. And go Line By Line!
            
            let mfTransactionList = DBManager.getInstance().getMFUTransactionsByAccountID(mfAccount.AccId)
            
            if mfTransactionList.count>0
            {
                
                var totalUnits = 0.0
                
                let TotlaList = mfTransactionList.count-1
                for i in 0..<TotlaList {
                    
                    let transaction = mfTransactionList.objectAtIndex(i) as! MFTransaction
                    let transactionNext = mfTransactionList.objectAtIndex(i+1) as! MFTransaction
                    
                    let date = transaction.ExecutaionDateTime
                    let thisUnit = Double(transaction.TxnpucharseUnits)
                    let patternType = transaction.TxtType
                    
                    if patternType == MFU_TXN_TYPE_ADDITIONAL_BUY || patternType == MFU_TXN_TYPE_BUY || patternType == MFU_TXN_TYPE_SIP || patternType == MFU_TXN_TYPE_SWITCH_IN || patternType == MFU_TXN_TYPE_STP_IN{
                        totalUnits += thisUnit!;
                    }else if patternType == MFU_TXN_TYPE_REDEEM || patternType == MFU_TXN_TYPE_SWP || patternType == MFU_TXN_TYPE_STP_OUT || patternType == MFU_TXN_TYPE_SWITCH_OUT{
                        totalUnits -= thisUnit!;
                    }
                    
                    if totalUnits < 0
                    {
                        totalUnits = 0
                    }
                    
                    let thisNav = transaction.TxnpuchaseNAV
                    let nextDate = transactionNext.ExecutaionDateTime
                    
                    self.getMFUPortfolioWorthBetweenDates(mfAccount, startDate: date, endDate: nextDate, startNAV: thisNav, units: String(totalUnits))
                }
                
                // Only from last to Today
                let transaction = mfTransactionList.lastObject as! MFTransaction
                let thisUnit = Double(transaction.TxnpucharseUnits)
                let patternType = transaction.TxtType
                
                if patternType == MFU_TXN_TYPE_ADDITIONAL_BUY || patternType == MFU_TXN_TYPE_BUY || patternType == MFU_TXN_TYPE_SIP || patternType == MFU_TXN_TYPE_SWITCH_IN || patternType == MFU_TXN_TYPE_STP_IN{
                    totalUnits += thisUnit!;
                }else if patternType == MFU_TXN_TYPE_REDEEM || patternType == MFU_TXN_TYPE_SWP || patternType == MFU_TXN_TYPE_STP_OUT || patternType == MFU_TXN_TYPE_SWITCH_OUT{
                    totalUnits -= thisUnit!;
                }
                
                if totalUnits < 0
                {
                    totalUnits = 0
                }
                
                let date = NSDate()
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let todayDate = dateFormatter.stringFromDate(date)
                print(todayDate)
                
                //                let todayDate = ""
                
                self.getMFUPortfolioWorthBetweenDates(mfAccount, startDate: transaction.ExecutaionDateTime, endDate: todayDate, startNAV: transaction.TxnpuchaseNAV, units: String(totalUnits))
                
                
            }
            // Else What's the point of having a Portfolio Worth! Dont do anything
            
        }
        
    }

    
    func getMFUPortfolioWorthBetweenDates(mfAccount : MFAccount,startDate : String,endDate : String,startNAV : String,units : String) {
        
        let startDatee = startDate.componentsSeparatedByString("T").first
        let mfuPortWorth = MfuPortfolioWorth()
        mfuPortWorth.portfolio_date = startDatee
        mfuPortWorth.AccId = mfAccount.AccId
        mfuPortWorth.pucharseUnits = Double(units)
        mfuPortWorth.CurrentNAV = Double(startNAV)
        mfuPortWorth.CurrentValue = Double(startNAV)! * Double(units)!
        mfuPortWorth.isTransaction = 1
        DBManager.getInstance().addorUpdateMFU_WORTH(mfuPortWorth)
        
        var dicToSend = NSMutableDictionary()
        
        dicToSend = ["AMC_code" : "\(mfAccount.RTAamcCode!)", "Scheme_code" : "\(mfAccount.SchemeCode!)", "FromDate" : startDatee!, "ToDate" : endDate]
        
        WebManagerHK.postDataToURL(kModeGetNAVFromtoToDate, params: dicToSend, message: "") { (response) in
            print("Dic Response : \(response)")
            
            if response.objectForKey(kWAPIResponseStatus) as! String == "OK"
            {
                if response.objectForKey(kWAPIResponse) as! NSArray == []
                {
                    return
                }
                
                let array = response.objectForKey(kWAPIResponse) as! NSArray
                
                for index in 0..<(array.count) {
                    print(index)
                    let navData = array[index] as! NSDictionary
                    let nav = navData.objectForKey("netassetvalue") as! Double
                    let date = navData.objectForKey("date") as! String
                    let navDate = date.componentsSeparatedByString("T").first
                    let mfuPortWorth = MfuPortfolioWorth()
                    mfuPortWorth.portfolio_date = navDate
                    mfuPortWorth.AccId = mfAccount.AccId
                    mfuPortWorth.pucharseUnits = Double(units)
                    mfuPortWorth.CurrentNAV = nav
                    mfuPortWorth.CurrentValue = nav * Double(units)!
                    mfuPortWorth.isTransaction = 0
                    
                    if (navDate == startDatee)
                    {
                        
                    }
                    else
                    {
                        DBManager.getInstance().addorUpdateMFU_WORTH(mfuPortWorth)
                        self.indexChanged(self.segmentedControl)
                        self.viewGraph.setNeedsDisplay()
                    }
                }
            }
        }
    }
    
    func getManualMFUPortfolioWorthBetweenDates(mfAccount : MFAccount,startDate : String,endDate : String,startNAV : String, units : String) {
        
        let startDatee = startDate.componentsSeparatedByString("T").first
        let mfuPortWorth = MfuPortfolioWorth()
        mfuPortWorth.portfolio_date = startDatee
        mfuPortWorth.AccId = mfAccount.AccId
        mfuPortWorth.pucharseUnits = Double(units)
        mfuPortWorth.CurrentNAV = Double(startNAV)
        mfuPortWorth.CurrentValue = Double(startNAV)! * Double(units)!
        mfuPortWorth.isTransaction = 1
        DBManager.getInstance().addorUpdateManualMFU_WORTH(mfuPortWorth)
        
        var dicToSend = NSMutableDictionary()
        dicToSend = ["AMC_code" : "\(mfAccount.RTAamcCode!)", "Scheme_code" : "\(mfAccount.SchemeCode!)", "FromDate" : startDate, "ToDate" : endDate]
        
        WebManagerHK.postDataToURL(kModeGetNAVFromtoToDate, params: dicToSend, message: "") { (response) in
            print("Dic Response : \(response)")
            
            if response.objectForKey(kWAPIResponseStatus) as! String == "OK"
            {
                if response.objectForKey(kWAPIResponse) as! NSArray == []
                {
                    return
                }
                
                let array = response.objectForKey(kWAPIResponse) as! NSArray
                
                for index in 0..<(array.count) {
                    print(index)
                    let navData = array[index] as! NSDictionary
                    let nav = navData.objectForKey("netassetvalue") as! Double
                    let date = navData.objectForKey("date") as! String
                    let navDate = date.componentsSeparatedByString("T").first
                    let mfuPortWorth = MfuPortfolioWorth()
                    mfuPortWorth.portfolio_date = navDate
                    mfuPortWorth.AccId = mfAccount.AccId
                    mfuPortWorth.pucharseUnits = Double(units)
                    mfuPortWorth.CurrentNAV = nav
                    mfuPortWorth.CurrentValue = nav * Double(units)!
                    mfuPortWorth.isTransaction = 0
                    
                    if (navDate == startDatee)
                    {
                        
                    }
                    else
                    {
                        DBManager.getInstance().addorUpdateManualMFU_WORTH(mfuPortWorth)
                        self.indexChanged(self.segmentedControl)
                        self.viewGraph.setNeedsDisplay()
                    }
                }
            }
        }
    }
    
    func getMFUPortfolioWorthTillDate(mfAccount : MFAccount,lastDate : String, units : Double) {
        
//        let dateFormatter = NSDateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        var date = dateFormatter.dateFromString(lastDate)
//        date = date?.addDays(1)
        
        let fullNameArr = lastDate.characters.split{$0 == "T"}.map(String.init)
        var dateString = ""
        
        if fullNameArr.count > 0
        {
            dateString = fullNameArr[0]
        }
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var date = dateFormatter.dateFromString(dateString)
        date = date?.addDays(1)
        
        
//        var date = lastDate.componentsSeparatedByString("T").first;
//        date = date.addDays(1)
        
        var dicToSend = NSMutableDictionary()
        dicToSend = ["Amc_code" : "\(mfAccount.RTAamcCode!)", "Scheme_code" : "\(mfAccount.SchemeCode!)", "Date" :dateFormatter.stringFromDate(date!)]
        
        WebManagerHK.postDataToURL(kModeGetNAVFromDate, params: dicToSend, message: "") { (response) in
            print("Dic Response : \(response)")
            
            if response.objectForKey(kWAPIResponseStatus) as! String == "OK"
            {
                if response.objectForKey(kWAPIResponse) as! NSArray == []
                {
                    return
                }
                
                let array = response.objectForKey(kWAPIResponse) as! NSArray
                
                for index in 0..<(array.count) {
                    print(index)
                    let navData = array[index] as! NSDictionary
                    let nav = navData.objectForKey("netassetvalue") as! Double
                    let date = navData.objectForKey("date") as! String
                    let navDate = date.componentsSeparatedByString("T").first
                    let mfuPortWorth = MfuPortfolioWorth()
                    mfuPortWorth.portfolio_date = navDate
                    mfuPortWorth.AccId = mfAccount.AccId
                    mfuPortWorth.pucharseUnits = Double(units)
                    mfuPortWorth.CurrentNAV = nav
                    mfuPortWorth.CurrentValue = nav * Double(units)
                    mfuPortWorth.isTransaction = 0
                    DBManager.getInstance().addorUpdateMFU_WORTH(mfuPortWorth)
                }
                self.indexChanged(self.segmentedControl)
                self.viewGraph.setNeedsDisplay()
            }
        }
    }
    
    func getManualMFUPortfolioWorthTillDate(mfAccount : MFAccount,lastDate : String, units : Double) {
        
        let fullNameArr = lastDate.characters.split{$0 == "T"}.map(String.init)
//        let lastDatee = lastDate.componentsSeparatedByString("T").first
        // or simply:
        // let fullNameArr = fullName.characters.split{" "}.map(String.init)
        var dateString = ""
        if fullNameArr.count > 0
        {
            dateString = fullNameArr[0]
        }
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var date = dateFormatter.dateFromString(dateString)
        date = date?.addDays(1)
        
        var dicToSend = NSMutableDictionary()
        dicToSend = ["Amc_code" : "\(mfAccount.RTAamcCode!)", "Scheme_code" : "\(mfAccount.SchemeCode!)", "Date" : dateFormatter.stringFromDate(date!)]
//        dateFormatter.stringFromDate(date!)
        
        WebManagerHK.postDataToURL(kModeGetNAVFromDate, params: dicToSend, message: "") { (response) in
            print("Dic Response : \(response)")
            
            if response.objectForKey(kWAPIResponseStatus) as! String == "OK"
            {
                if response.objectForKey(kWAPIResponse) as! NSArray == []
                {
                    return
                }
                
                let array = response.objectForKey(kWAPIResponse) as! NSArray
                
                for index in 0..<(array.count) {
                    print(index)
                    let navData = array[index] as! NSDictionary
                    let nav = navData.objectForKey("netassetvalue") as! Double
                    let date = navData.objectForKey("date") as! String
                    let navDate = date.componentsSeparatedByString("T").first
                    let mfuPortWorth = MfuPortfolioWorth()
                    mfuPortWorth.portfolio_date = navDate
                    mfuPortWorth.AccId = mfAccount.AccId
                    mfuPortWorth.pucharseUnits = Double(units)
                    mfuPortWorth.CurrentNAV = nav
                    mfuPortWorth.CurrentValue = nav * Double(units)
                    mfuPortWorth.isTransaction = 0
                    
//                    if(navDate == )
                    DBManager.getInstance().addorUpdateManualMFU_WORTH(mfuPortWorth)
                    
                }
                self.indexChanged(self.segmentedControl)
                self.viewGraph.setNeedsDisplay()
            }
        }
    }
    
    func generateManualPortfolioData()
    {
        
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
    @IBAction func btnBaccClicked(sender: AnyObject) {
        
        
//        if viewGraphDetailData.hidden {
            self.navigationController?.popViewControllerAnimated(true)
//        }else{
//            viewGraphDetailData.hidden = true
//        }

    }
    
    @IBAction func indexChanged(sender:UISegmentedControl)
    {
        switch segmentedControl.selectedSegmentIndex
    {
        case 0: //3Months
            if isFrom == "Wealth"
            {
                generateWealthPortfolioChart3Months(objMFAccountDetail)
            }
            else
            {
                generateManualPortfolioChart3Months(objMFAccountDetail)
            }
            
            break
        
        case 1: //1 Year
            if isFrom == "Wealth"
            {
                generateWealthPortfolioChart1Year(objMFAccountDetail)
            }
            else
            {
                generateManualPortfolioChart1Year(objMFAccountDetail)
            }
            break
            
        case 2: //ALL
            if isFrom == "Wealth"
            {
                generateWealthPortfolioChartAll(objMFAccountDetail)
            }
            else
            {
                generateManualPortfolioChartAll(objMFAccountDetail)
            }
            
//                dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                    self.tblViewGraph.reloadData()
//                    self.viewGraph.reloadInputViews()
//                })
            
            break
        
        default:
            break
        }
    }

//    @IBAction func btn3MClick(sender: AnyObject) {
//        self.lblLine.frame = CGRect(x: btn13M.frame.origin.x, y: self.lblLine.frame.origin.y, width: self.lblLine.frame.size.width, height: self.lblLine.frame.size.height)
//        
//        selectedMenu = 1
//        
//        var arr = NSMutableArray()
//        if isFrom == "Wealth" {
//            arr = DBManager.getInstance().getMFUTransactionsByAccountID(objMFAccountDetail.AccId)
//        }else{
//            arr = DBManager.getInstance().getMFUTransactionsByAccountIDFromManual(objMFAccountDetail.AccId)
//        }
//        
//        if arr.count==0 {
//            
//        }else{
//            self.arrGraphTransactions = arr
//            self.tblViewGraph.reloadData()
//        }
//
//    }
//    
//    @IBAction func btn1YClick(sender: AnyObject) {
//        self.lblLine.frame = CGRect(x: btn21Yr.frame.origin.x, y: self.lblLine.frame.origin.y, width: self.lblLine.frame.size.width, height: self.lblLine.frame.size.height)
//
//        selectedMenu = 2
//        
//
//        var arr = NSMutableArray()
//        if isFrom == "Wealth" {
//            arr = DBManager.getInstance().getMFUTransactionsByAccountID(objMFAccountDetail.AccId)
//        }else{
//            arr = DBManager.getInstance().getMFUTransactionsByAccountIDFromManual(objMFAccountDetail.AccId)
//        }
//
//        if arr.count==0 {
//            
//        }else{
//            self.arrGraphTransactions = arr
//            self.tblViewGraph.reloadData()
//        }
//
//    }
//    
//    @IBAction func btnAllClick(sender: AnyObject) {
//        self.lblLine.frame = CGRect(x: btn3All.frame.origin.x, y: self.lblLine.frame.origin.y, width: self.lblLine.frame.size.width, height: self.lblLine.frame.size.height)
//        
//        selectedMenu = 3
//
//        var arr = NSMutableArray()
////        var arr2 = NSMutableArray()
//        if isFrom == "Wealth" {
//            arr = DBManager.getInstance().getMFUTransactionsByAccountID(objMFAccountDetail.AccId)
//        }else{
//            arr = DBManager.getInstance().getMFUTransactionsByAccountIDFromManual(objMFAccountDetail.AccId)
//                
//        }
//
//        if arr.count==0 {
//            
//        }else{
//            self.arrGraphTransactions = arr
//            
//            dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                self.tblViewGraph.reloadData()
//            })
//
//        }
//    }
    
    let TAG_DT_TITLE = 2000
    let TAG_DT_SUB_TITLE = 4000
    let TAG_VIEW = 6000
    
    
    func loadScrollRecentTrans() {
        
//        self.scrollRecentTrans.subviews.forEach({ $0.removeFromSuperview() }) // this gets things done
        imageView.backgroundColor = UIColor.defaultAppColorBlue
        imageView.layer.cornerRadius = imageView.frame.height/2
        
        var arr = NSMutableArray()
        if isFrom=="Wealth" {
            arr = DBManager.getInstance().getMFTransactionsGroupByDate(objMFAccountDetail)
        }else{
            arr = DBManager.getInstance().getMFTransactionsGroupByDateFromManual(objMFAccountDetail)
        }
        
        if arr.count==0 {
            self.navigationController?.popViewControllerAnimated(true)
            
            return
        }else{
        }
        

        var xPos = 10
        var counter = 0
        
        for objData in arr {
            
            let transaction = objData as! MFTransaction
            let index = transaction.ExecutaionDateTime.startIndex.advancedBy(10)
            let dtShort = transaction.ExecutaionDateTime.substringToIndex(index)
            print(dtShort)
            
            let formatter  = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let date = formatter.dateFromString(dtShort)!

            let calendar = NSCalendar.currentCalendar()
            let components = calendar.components([.Day , .Month , .Year], fromDate: date)
            
            let year =  components.year
            let month = components.month
            let day = components.day
            
            print(year)
            print(month)
            print(day)
            
            let view = UIView(frame: CGRect(x: xPos, y: 5, width: 45, height: 45))
            view.tag = counter + TAG_VIEW
            
            if counter==0 {
                view.backgroundColor = UIColor.defaultAppColorBlue
            }else{
                view.backgroundColor = UIColor.whiteColor()
            }
            
            view.layer.cornerRadius = view.frame.size.width/2
//            self.scrollRecentTrans.addSubview(view)
            
            let lblDt = UILabel(frame: CGRect(x: 0, y: 0, width: 45, height: 35))
            lblDt.text = String(day)
            lblDt.textAlignment = .Center
            lblDt.font = UIFont.systemFontOfSize(21)
            view.addSubview(lblDt)
            if counter==0 {
                lblDt.textColor = UIColor.whiteColor()
            }else{
                lblDt.textColor = UIColor.blackColor()
            }
            lblDt.tag = counter + TAG_DT_TITLE
            
            let lblDtLast = UILabel(frame: CGRect(x: 0, y: 28, width: 45, height: 10))
            
            let stringMonth = MONTH.allValues[month]
            
            let stringYear = String(year)
            let yearToAdd = stringYear.substring(2)

            lblDtLast.text = "\(stringMonth.capitalizedString)-\(yearToAdd)"
            lblDtLast.textAlignment = .Center
            lblDtLast.font = UIFont.systemFontOfSize(9)
            view.addSubview(lblDtLast)
            if counter==0 {
                lblDtLast.textColor = UIColor.whiteColor()
            }else{
                lblDtLast.textColor = UIColor.blackColor()
            }
            lblDtLast.tag = counter + TAG_DT_SUB_TITLE
            
            
            
            var arrDateWiseData = NSMutableArray()
            if isFrom=="Wealth" {
                arrDateWiseData = DBManager.getInstance().getMFTransactionsByDate(transaction.ExecutaionDateTime, mfAccountInfo: objMFAccountDetail)
            }else{
                arrDateWiseData = DBManager.getInstance().getMFTransactionsByDateFromManual(transaction.ExecutaionDateTime, mfAccountInfo: objMFAccountDetail)
            }
                
            var isPurchaseAvailable = false
            var isRedeemAvailable = false
            
            for objTrans in arrDateWiseData {
                let dtTransaction = objTrans as! MFTransaction

                if dtTransaction.TxtType == MFU_TXN_TYPE_ADDITIONAL_BUY || dtTransaction.TxtType == MFU_TXN_TYPE_BUY || dtTransaction.TxtType == MFU_TXN_TYPE_SIP || dtTransaction.TxtType == MFU_TXN_TYPE_SWITCH_IN || dtTransaction.TxtType == MFU_TXN_TYPE_STP_IN{
                    
                    isPurchaseAvailable = true
                }else if dtTransaction.TxtType == MFU_TXN_TYPE_REDEEM || dtTransaction.TxtType == MFU_TXN_TYPE_SWP || dtTransaction.TxtType == MFU_TXN_TYPE_STP_OUT || dtTransaction.TxtType == MFU_TXN_TYPE_SWITCH_OUT{
                    
                    isRedeemAvailable = true
                }
            }
            
            if isPurchaseAvailable==true && isRedeemAvailable==true {
                
                var imgArrowGreen : UIImageView!
                imgArrowGreen = UIImageView(frame: CGRect(x: xPos+5, y: 50, width:20 , height: 20));
                imgArrowGreen.image = UIImage(named: "green_arrow")
//                self.scrollRecentTrans.addSubview(imgArrowGreen)
                
                var imgArrowRed : UIImageView!
                imgArrowRed = UIImageView(frame: CGRect(x: xPos+19, y: 50, width:20 , height: 20));
                imgArrowRed.image = UIImage(named: "red_arrow")
//                self.scrollRecentTrans.addSubview(imgArrowRed)

                
                if counter==0 {
                    isPurchaseAvail = true
                    isRedeemAvail = true
                    
                    self.arrPurchase.removeAllObjects()
                    self.arrRedeem.removeAllObjects()
                    
                    for objTrans in arrDateWiseData {
                        let dtTransaction = objTrans as! MFTransaction
                        if dtTransaction.TxtType == MFU_TXN_TYPE_ADDITIONAL_BUY || dtTransaction.TxtType == MFU_TXN_TYPE_BUY || dtTransaction.TxtType == MFU_TXN_TYPE_SIP || dtTransaction.TxtType == MFU_TXN_TYPE_SWITCH_IN || dtTransaction.TxtType == MFU_TXN_TYPE_STP_IN{
                            
                            self.arrPurchase.addObject(dtTransaction)
                        }else if dtTransaction.TxtType == MFU_TXN_TYPE_REDEEM || dtTransaction.TxtType == MFU_TXN_TYPE_SWP || dtTransaction.TxtType == MFU_TXN_TYPE_STP_OUT || dtTransaction.TxtType == MFU_TXN_TYPE_SWITCH_OUT{
                            
                            self.arrRedeem.addObject(dtTransaction)
                        }

                    }

                    self.tbView.reloadData()
                    
                }
                
            }else{

                var imgArrow : UIImageView!
                imgArrow = UIImageView(frame: CGRect(x: xPos+12, y: 50, width:20 , height: 20));

                if isPurchaseAvailable {
                    imgArrow.image = UIImage(named: "green_arrow")
                    

                    if counter==0 {
                        isPurchaseAvail = true
                        
                        self.arrPurchase.removeAllObjects()

                        for objTrans in arrDateWiseData {
                            let dtTransaction = objTrans as! MFTransaction
                            if dtTransaction.TxtType == MFU_TXN_TYPE_ADDITIONAL_BUY || dtTransaction.TxtType == MFU_TXN_TYPE_BUY || dtTransaction.TxtType == MFU_TXN_TYPE_SIP || dtTransaction.TxtType == MFU_TXN_TYPE_SWITCH_IN || dtTransaction.TxtType == MFU_TXN_TYPE_STP_IN{
                                
                                self.arrPurchase.addObject(dtTransaction)
                            }else if dtTransaction.TxtType == MFU_TXN_TYPE_REDEEM || dtTransaction.TxtType == MFU_TXN_TYPE_SWP || dtTransaction.TxtType == MFU_TXN_TYPE_STP_OUT || dtTransaction.TxtType == MFU_TXN_TYPE_SWITCH_OUT{
                                
                            }
                            
                        }

                        self.tbView.reloadData()
                    }

                }
                
                if isRedeemAvailable {
                    imgArrow.image = UIImage(named: "red_arrow")
                    
                    if counter==0 {
                        isRedeemAvail = true
                        
                        self.arrRedeem.removeAllObjects()

                        for objTrans in arrDateWiseData {
                            let dtTransaction = objTrans as! MFTransaction
                            if dtTransaction.TxtType == MFU_TXN_TYPE_ADDITIONAL_BUY || dtTransaction.TxtType == MFU_TXN_TYPE_BUY || dtTransaction.TxtType == MFU_TXN_TYPE_SIP || dtTransaction.TxtType == MFU_TXN_TYPE_SWITCH_IN || dtTransaction.TxtType == MFU_TXN_TYPE_STP_IN{
                                
                            }else if dtTransaction.TxtType == MFU_TXN_TYPE_REDEEM || dtTransaction.TxtType == MFU_TXN_TYPE_SWP || dtTransaction.TxtType == MFU_TXN_TYPE_STP_OUT || dtTransaction.TxtType == MFU_TXN_TYPE_SWITCH_OUT{
                                
                                self.arrRedeem.addObject(dtTransaction)
                            }
                        }

                        self.tbView.reloadData()
                    }
                }
//                self.scrollRecentTrans.addSubview(imgArrow)
            }

            let myFirstButton = UIButton(frame: CGRect(x: 0, y: 0, width: 45, height: 45))
            myFirstButton.addTarget(self, action: #selector(self.pressed(_:)), forControlEvents: .TouchUpInside)
            myFirstButton.backgroundColor = UIColor.clearColor()
            view.addSubview(myFirstButton)
            myFirstButton.tag = counter
            
            xPos = xPos + 60
            counter = counter + 1
        }
        
//        self.scrollRecentTrans.contentSize = CGSize(width: xPos, height: 0)
//        self.scrollRecentTrans.showsHorizontalScrollIndicator = false
//        self.scrollRecentTrans.showsVerticalScrollIndicator = false
        
    }
    
    func pressed(sender: UIButton!) {
        print("Clicked \(sender.tag)")
        
        currentDate = "currentDate_\(sender.titleLabel?.text)"
        
        var arr = NSMutableArray()
        
        if isFrom=="Wealth" {
            arr = DBManager.getInstance().getMFTransactionsGroupByDate(objMFAccountDetail)
        }else{
            arr = DBManager.getInstance().getMFTransactionsGroupByDateFromManual(objMFAccountDetail)
        }
        
        if arr.count==0 {
            return
        }else{
            
        }
        
//        var counter = 0
//        
//        for objData in arr {
//            
//            let viewSub = self.scrollRecentTrans.viewWithTag((counter+TAG_VIEW))
//            viewSub?.backgroundColor = UIColor.whiteColor()
//            let lblDt = viewSub!.viewWithTag((counter+TAG_DT_TITLE)) as! UILabel
//            lblDt.textColor = UIColor.blackColor()
//            
//            let lblDtLast = viewSub!.viewWithTag((counter+TAG_DT_SUB_TITLE)) as! UILabel
//            lblDtLast.textColor = UIColor.blackColor()
//
//            counter = counter + 1
//        }
        
        let view = sender.superview
        view!.backgroundColor = UIColor.defaultAppColorBlue
        
        let lblDt = view?.viewWithTag((sender.tag+TAG_DT_TITLE)) as! UILabel
        lblDt.textColor = UIColor.whiteColor()

        let lblDtLast = view?.viewWithTag((sender.tag+TAG_DT_SUB_TITLE)) as! UILabel
        lblDtLast.textColor = UIColor.whiteColor()
     
        let mfTransactionDetailsSelected = arr.objectAtIndex(sender.tag) as! MFTransaction
     
        var arrDateWiseData = NSMutableArray()
        
        if isFrom=="Wealth" {
            arrDateWiseData = DBManager.getInstance().getMFTransactionsByDate(mfTransactionDetailsSelected.ExecutaionDateTime, mfAccountInfo: objMFAccountDetail)
        }else{
            arrDateWiseData = DBManager.getInstance().getMFTransactionsByDateFromManual(mfTransactionDetailsSelected.ExecutaionDateTime, mfAccountInfo: objMFAccountDetail)
        }
        print("Total Transaction Found \(arrDateWiseData.count)")

        
        self.arrRedeem.removeAllObjects()
        self.arrPurchase.removeAllObjects()
        
        
        for objTrans in arrDateWiseData {
            let dtTransaction = objTrans as! MFTransaction
            
            
            if dtTransaction.TxtType == MFU_TXN_TYPE_ADDITIONAL_BUY || dtTransaction.TxtType == MFU_TXN_TYPE_BUY || dtTransaction.TxtType == MFU_TXN_TYPE_SIP || dtTransaction.TxtType == MFU_TXN_TYPE_SWITCH_IN || dtTransaction.TxtType == MFU_TXN_TYPE_STP_IN{
                
                self.arrPurchase.addObject(dtTransaction)
                
            }else if dtTransaction.TxtType == MFU_TXN_TYPE_REDEEM || dtTransaction.TxtType == MFU_TXN_TYPE_SWP || dtTransaction.TxtType == MFU_TXN_TYPE_STP_OUT || dtTransaction.TxtType == MFU_TXN_TYPE_SWITCH_OUT{
                
                self.arrRedeem.addObject(dtTransaction)

            }
            
            
        }
        
        if self.arrPurchase.count==0 {
            isPurchaseAvail = false
        }else{
            isPurchaseAvail = true
        }
        if self.arrRedeem.count==0 {
            isRedeemAvail = false
        }else{
            isRedeemAvail = true
        }
        
        
        self.tbView.reloadData()
    }
    
    func getBuyImageView() -> UIImageView {
        let imgArrow = UIImageView(frame: CGRect(x: 3, y: 5, width: 35, height: 35))
        imgArrow.image = UIImage(named: "transactswitch_icon")
        return imgArrow
    }
    func getRedeemImageView() -> UIImageView {
        let imgArrow = UIImageView(frame: CGRect(x: 3, y: 5, width: 35, height: 35))
        imgArrow.image = UIImage(named: "transactRedeem")
        return imgArrow
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if tableView==self.tbView {
            if isPurchaseAvail==true && isRedeemAvail==true{
                return 2
            }else{
                if isPurchaseAvail==true {
                    return 1
                }
                if isRedeemAvail==true {
                    return 1
                }
                return 0
            }
 
        }else{
            return 1
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView==self.tbView {
            if isPurchaseAvail==true && isRedeemAvail==true{
                
                if section==0 {
                    return arrPurchase.count
                }else{
                    return arrRedeem.count
                }
            }else{
                if isPurchaseAvail==true {
                    return arrPurchase.count
                }
                if isRedeemAvail==true {
                    return arrRedeem.count
                }
                return 0
            }
        }else{
            return arrGraphTransactions.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        if tableView==self.tbView {
            
            let stringIdentifier = "CELL_FOR_\(indexPath.row)_\(indexPath.section)_\(self.arrRedeem)_\(self.arrPurchase)_\(currentDate)"
            
            tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: stringIdentifier)
            
            let cell = tableView.dequeueReusableCellWithIdentifier(stringIdentifier, forIndexPath: indexPath) as UITableViewCell
            
            if isPurchaseAvail==true && isRedeemAvail==true{
                
                if (cell.contentView.subviews.count==0) {
                    
                    var objMFTransaction = MFTransaction()
                    if indexPath.section==0 {
                        objMFTransaction = arrPurchase.objectAtIndex(indexPath.row) as! MFTransaction
                        
                        
                        var lblType : UILabel!
                        lblType = UILabel(frame: CGRect(x: 3, y: 40, width: (cell.contentView.frame.size.width/2), height: 15));
                        lblType.text = "Switch-In"
                        lblType.font = UIFont.systemFontOfSize(7)
                        lblType.textColor = UIColor.darkGrayColor()
                        lblType.textAlignment = .Left
                        cell.contentView.addSubview(lblType)
                        
                        //                        let imgArrow = UIImageView(frame: CGRect(x: 3, y: 5, width: 30, height: 30))
                        //                        imgArrow.image = UIImage(named: "transactBuySIP")
                        cell.contentView.addSubview(self.getBuyImageView())
                        
                        
                    }else{
                        objMFTransaction = arrRedeem.objectAtIndex(indexPath.row) as! MFTransaction
                        
                        var lblType : UILabel!
                        lblType = UILabel(frame: CGRect(x: 3, y: 40, width: (cell.contentView.frame.size.width/2), height: 15));
                        lblType.text = "Redeem"
                        lblType.font = UIFont.systemFontOfSize(7)
                        lblType.textColor = UIColor.darkGrayColor()
                        lblType.textAlignment = .Left
                        cell.contentView.addSubview(lblType)
                        
                        //                        let imgArrow = UIImageView(frame: CGRect(x: 3, y: 5, width: 30, height: 30))
                        //                        imgArrow.image = UIImage(named: "transactRedeem")
                        cell.contentView.addSubview(self.getRedeemImageView())
                        
                        
                    }
                    
                    var lblFundName : UILabel!
                    lblFundName = UILabel(frame: CGRect(x: 45, y: 0, width: (cell.contentView.frame.size.width/2), height: 25));
                    lblFundName.text = objMFAccountDetail.SchemeName
                    lblFundName.font = UIFont.systemFontOfSize(15)
                    lblFundName.textColor = UIColor.blackColor()
                    lblFundName.textAlignment = .Left
                    cell.contentView.addSubview(lblFundName)
                    
                    var lblUnits : UILabel!
                    lblUnits = UILabel(frame: CGRect(x: 45, y: 20, width: (cell.contentView.frame.size.width/2), height: 20));
                    let un = Double(objMFTransaction.TxnpucharseUnits)
                    let Units = String(format: "%.1f", un!)
                    
                    let nv = Double(objMFTransaction.TxnpuchaseNAV)
                    let Nav = String(format: "%.1f", nv!)
                    
                    lblUnits.text = "Units : \(Units) | Nav : \(Nav)"
                    lblUnits.font = UIFont.systemFontOfSize(11)
                    lblUnits.textColor = UIColor.darkGrayColor()
                    lblUnits.textAlignment = .Left
                    cell.contentView.addSubview(lblUnits)
                    
                    var lblPrice : UILabel!
                    lblPrice = UILabel(frame: CGRect(x: 15, y: 0, width: (cell.contentView.frame.size.width)-20, height: 25));
                    
                    let allUnits = (objMFTransaction.TxnPurchaseAmount as NSString).doubleValue
                    
                    let num = NSNumber(double: allUnits)
                    let formatr : NSNumberFormatter = NSNumberFormatter()
                    formatr.numberStyle = .CurrencyStyle
                    formatr.locale = NSLocale(localeIdentifier: "en_IN")
                    if let stringDT = formatr.stringFromNumber(num)
                    {
                        lblPrice.text = stringDT
                    }
                    
                    lblPrice.font = UIFont.systemFontOfSize(13)
                    lblPrice.textColor = UIColor.defaultGreenColor
                    lblPrice.textAlignment = .Right
                    cell.contentView.addSubview(lblPrice)
                    
                    
//                    var lblFolio : UILabel!
//                    lblFolio = UILabel(frame: CGRect(x: (cell.contentView.frame.size.width)-95, y: 20, width: 90, height: 20));
//                    let last4 = String(objMFAccountDetail.FolioNo.characters.suffix(4))
//                    lblFolio.text = "Folio: X- \(last4)"
//                    lblFolio.font = UIFont.systemFontOfSize(11)
//                    lblFolio.textColor = UIColor.darkGrayColor()
//                    lblFolio.textAlignment = .Right
//                    if last4=="" {
//                    }else{
//                        cell.contentView.addSubview(lblFolio)
//                    }
                    
                    var lblDATE : UILabel!
                    lblDATE = UILabel(frame: CGRect(x: 45, y: 35, width: (cell.contentView.frame.size.width/2), height: 20));
                    
                    let index = objMFTransaction.ExecutaionDateTime.startIndex.advancedBy(10)
                    let dtShort = objMFTransaction.ExecutaionDateTime.substringToIndex(index)
                    print(dtShort)
                    
                    let formatter  = NSDateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd"
                    let date = formatter.dateFromString(dtShort)!
                    //                lblDATE.text = date.getDateInString()
                    lblDATE.font = UIFont.systemFontOfSize(11)
                    lblDATE.textColor = UIColor.darkGrayColor()
                    lblDATE.textAlignment = .Left
                    cell.contentView.addSubview(lblDATE)
                    
                    
                    let calendar = NSCalendar.currentCalendar()
                    let components = calendar.components([.Day , .Month , .Year], fromDate: date)
                    let year =  components.year
                    let month = components.month
                    let day = components.day
                    
                    let stringMonth = MONTH.allValues[month]
                    let stringYear = String(year)
                    let yearToAdd = stringYear.substring(2)
                    
                    lblDATE.text = "\(String(day))-\(stringMonth.capitalizedString)-\(yearToAdd)"
                    
                    
                    cell.selectionStyle = UITableViewCellSelectionStyle.None
                    cell.contentView.backgroundColor = UIColor.clearColor()
                    cell.backgroundColor = UIColor.whiteColor()
                    return cell
                }
                
            }else{
                if isPurchaseAvail==true {
                    
                    if (cell.contentView.subviews.count==0) {
                        
                        var objMFTransaction = MFTransaction()
                        objMFTransaction = arrPurchase.objectAtIndex(indexPath.row) as! MFTransaction
                        
                        var lblFundName : UILabel!
                        lblFundName = UILabel(frame: CGRect(x: 45, y: 0, width: (cell.contentView.frame.size.width/2), height: 25));
                        lblFundName.text = objMFAccountDetail.SchemeName
                        lblFundName.font = UIFont.systemFontOfSize(15)
                        lblFundName.textColor = UIColor.blackColor()
                        lblFundName.textAlignment = .Left
                        cell.contentView.addSubview(lblFundName)
                        
                        var lblUnits : UILabel!
                        lblUnits = UILabel(frame: CGRect(x: 45, y: 20, width: (cell.contentView.frame.size.width/2), height: 20));
                        
                        let un = Double(objMFTransaction.TxnpucharseUnits)
                        let Units = String(format: "%.1f", un!)
                        
                        let nv = Double(objMFTransaction.TxnpuchaseNAV)
                        let Nav = String(format: "%.1f", nv!)
                        
                        lblUnits.text = "Units : \(Units) | Nav : \(Nav)"
                        lblUnits.font = UIFont.systemFontOfSize(11)
                        lblUnits.textColor = UIColor.darkGrayColor()
                        lblUnits.textAlignment = .Left
                        cell.contentView.addSubview(lblUnits)
                        
                        var lblPrice : UILabel!
                        lblPrice = UILabel(frame: CGRect(x: 15, y: 0, width: (cell.contentView.frame.size.width)-20, height: 25));
                        
                        let allUnits = (objMFTransaction.TxnPurchaseAmount as NSString).doubleValue
                        
                        let num = NSNumber(double: allUnits)
                        let formatr : NSNumberFormatter = NSNumberFormatter()
                        formatr.numberStyle = .CurrencyStyle
                        formatr.locale = NSLocale(localeIdentifier: "en_IN")
                        if let stringDT = formatr.stringFromNumber(num)
                        {
                            lblPrice.text = stringDT
                        }
                        
                        lblPrice.font = UIFont.systemFontOfSize(13)
                        lblPrice.textColor = UIColor.defaultGreenColor
                        lblPrice.textAlignment = .Right
                        cell.contentView.addSubview(lblPrice)
                        
//                        var lblFolio : UILabel!
//                        lblFolio = UILabel(frame: CGRect(x: (cell.contentView.frame.size.width)-95, y: 20, width: 90, height: 20));
//                        let last4 = String(objMFAccountDetail.FolioNo.characters.suffix(4))
//                        lblFolio.text = "Folio: X- \(last4)"
//                        lblFolio.font = UIFont.systemFontOfSize(11)
//                        lblFolio.textColor = UIColor.darkGrayColor()
//                        lblFolio.textAlignment = .Right
//                        if last4=="" {
//                        }else{
//                            cell.contentView.addSubview(lblFolio)
//                        }
                        
                        var lblDATE : UILabel!
                        lblDATE = UILabel(frame: CGRect(x: 45, y: 35, width: (cell.contentView.frame.size.width/2), height: 20));
                        
                        let index = objMFTransaction.ExecutaionDateTime.startIndex.advancedBy(10)
                        let dtShort = objMFTransaction.ExecutaionDateTime.substringToIndex(index)
                        print(dtShort)
                        
                        let formatter  = NSDateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd"
                        let date = formatter.dateFromString(dtShort)!
                        //                lblDATE.text = date.getDateInString()
                        lblDATE.font = UIFont.systemFontOfSize(11)
                        lblDATE.textColor = UIColor.darkGrayColor()
                        lblDATE.textAlignment = .Left
                        cell.contentView.addSubview(lblDATE)
                        
                        
                        let calendar = NSCalendar.currentCalendar()
                        let components = calendar.components([.Day , .Month , .Year], fromDate: date)
                        let year =  components.year
                        let month = components.month
                        let day = components.day
                        
                        let stringMonth = MONTH.allValues[month]
                        let stringYear = String(year)
                        let yearToAdd = stringYear.substring(2)
                        
                        lblDATE.text = "\(String(day))-\(stringMonth.capitalizedString)-\(yearToAdd)"

                        
                        var lblType : UILabel!
                        lblType = UILabel(frame: CGRect(x: 3, y: 40, width: (cell.contentView.frame.size.width/2), height: 15));
                        lblType.text = "Switch-In"
                        lblType.font = UIFont.systemFontOfSize(7)
                        lblType.textColor = UIColor.darkGrayColor()
                        lblType.textAlignment = .Left
                        cell.contentView.addSubview(lblType)
                        
                        //                        let imgArrow = UIImageView(frame: CGRect(x: 3, y: 5, width: 30, height: 30))
                        //                        imgArrow.image = UIImage(named: "transactBuySIP")
                        cell.contentView.addSubview(self.getBuyImageView())
                        
                        cell.selectionStyle = UITableViewCellSelectionStyle.None
                        cell.contentView.backgroundColor = UIColor.clearColor()
                        cell.backgroundColor = UIColor.whiteColor()
                        return cell

                    }
                    
                }
                if isRedeemAvail==true {
                    
                    if (cell.contentView.subviews.count==0) {
                        
                        var objMFTransaction = MFTransaction()
                        objMFTransaction = arrRedeem.objectAtIndex(indexPath.row) as! MFTransaction
                        
                        var lblFundName : UILabel!
                        lblFundName = UILabel(frame: CGRect(x: 45, y: 0, width: (cell.contentView.frame.size.width/2), height: 25));
                        lblFundName.text = objMFAccountDetail.SchemeName
                        lblFundName.font = UIFont.systemFontOfSize(15)
                        lblFundName.textColor = UIColor.blackColor()
                        lblFundName.textAlignment = .Left
                        cell.contentView.addSubview(lblFundName)
                        
                        var lblUnits : UILabel!
                        lblUnits = UILabel(frame: CGRect(x: 45, y: 20, width: (cell.contentView.frame.size.width/2), height: 20));
                        
                        let un = Double(objMFTransaction.TxnpucharseUnits)
                        let Units = String(format: "%.1f", un!)
                        
                        let nv = Double(objMFTransaction.TxnpuchaseNAV)
                        let Nav = String(format: "%.1f", nv!)
                        
                        lblUnits.text = "Units : \(Units) | Nav : \(Nav)"
                        
                        lblUnits.font = UIFont.systemFontOfSize(11)
                        lblUnits.textColor = UIColor.darkGrayColor()
                        lblUnits.textAlignment = .Left
                        cell.contentView.addSubview(lblUnits)
                        
                        var lblPrice : UILabel!
                        lblPrice = UILabel(frame: CGRect(x: 15, y: 0, width: (cell.contentView.frame.size.width)-20, height: 25));
                        
                        let allUnits = (objMFTransaction.TxnPurchaseAmount as NSString).doubleValue
                        
                        let num = NSNumber(double: allUnits)
                        let formatr : NSNumberFormatter = NSNumberFormatter()
                        formatr.numberStyle = .CurrencyStyle
                        formatr.locale = NSLocale(localeIdentifier: "en_IN")
                        if let stringDT = formatr.stringFromNumber(num)
                        {
                            lblPrice.text = stringDT
                        }
                        
                        lblPrice.font = UIFont.systemFontOfSize(13)
                        lblPrice.textColor = UIColor.defaultGreenColor
                        lblPrice.textAlignment = .Right
                        cell.contentView.addSubview(lblPrice)
                        
                        
//                        var lblFolio : UILabel!
//                        lblFolio = UILabel(frame: CGRect(x: (cell.contentView.frame.size.width)-95, y: 20, width: 90, height: 20));
//                        let last4 = String(objMFAccountDetail.FolioNo.characters.suffix(4))
//                        lblFolio.text = "Folio: X- \(last4)"
//                        lblFolio.font = UIFont.systemFontOfSize(11)
//                        lblFolio.textColor = UIColor.darkGrayColor()
//                        lblFolio.textAlignment = .Right
//                        if last4=="" {
//                        }else{
//                            cell.contentView.addSubview(lblFolio)
//                        }
                        
                        var lblDATE : UILabel!
                        lblDATE = UILabel(frame: CGRect(x: 45, y: 35, width: (cell.contentView.frame.size.width/2), height: 20));
                        
                        let index = objMFTransaction.ExecutaionDateTime.startIndex.advancedBy(10)
                        let dtShort = objMFTransaction.ExecutaionDateTime.substringToIndex(index)
                        print(dtShort)
                        
                        let formatter  = NSDateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd"
                        let date = formatter.dateFromString(dtShort)!
                        //                lblDATE.text = date.getDateInString()
                        lblDATE.font = UIFont.systemFontOfSize(11)
                        lblDATE.textColor = UIColor.darkGrayColor()
                        lblDATE.textAlignment = .Left
                        cell.contentView.addSubview(lblDATE)
                        
                        
                        let calendar = NSCalendar.currentCalendar()
                        let components = calendar.components([.Day , .Month , .Year], fromDate: date)
                        let year =  components.year
                        let month = components.month
                        let day = components.day
                        
                        let stringMonth = MONTH.allValues[month]
                        let stringYear = String(year)
                        let yearToAdd = stringYear.substring(2)
                        
                        lblDATE.text = "\(String(day))-\(stringMonth.capitalizedString)-\(yearToAdd)"

                        
                        var lblType : UILabel!
                        lblType = UILabel(frame: CGRect(x: 3, y: 40, width: (cell.contentView.frame.size.width/2), height: 15));
                        lblType.text = "Redeem"
                        lblType.font = UIFont.systemFontOfSize(7)
                        lblType.textColor = UIColor.darkGrayColor()
                        lblType.textAlignment = .Left
                        cell.contentView.addSubview(lblType)
                        
                        //                        let imgArrow = UIImageView(frame: CGRect(x: 3, y: 5, width: 30, height: 30))
                        //                        imgArrow.image = UIImage(named: "transactBuySIP")
                        cell.contentView.addSubview(self.getRedeemImageView())
                        
                        cell.selectionStyle = UITableViewCellSelectionStyle.None
                        cell.contentView.backgroundColor = UIColor.clearColor()
                        cell.backgroundColor = UIColor.whiteColor()
                        return cell

                        
                    }
                }
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.contentView.backgroundColor = UIColor.clearColor()
            cell.backgroundColor = UIColor.whiteColor()
            
            return cell;
            
        }else{
            
            
            let stringIdentifier = "ALL_SELECTED_DATA_\(indexPath.row)_\(indexPath.section)_\(self.arrGraphTransactions.count)_\(segmentedControl.selectedSegmentIndex)"
            
            tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: stringIdentifier)
            
            let cell = tableView.dequeueReusableCellWithIdentifier(stringIdentifier, forIndexPath: indexPath) as UITableViewCell
            
            if (cell.contentView.subviews.count==0) {
                
                var objMFTransaction = MFTransaction()
                objMFTransaction = arrGraphTransactions.objectAtIndex(indexPath.row) as! MFTransaction
                
                var lblFundName : UILabel!
                lblFundName = UILabel(frame: CGRect(x: 45, y: 0, width: (cell.contentView.frame.size.width/2), height: 25));
                lblFundName.text = objMFAccountDetail.SchemeName
                lblFundName.font = UIFont.systemFontOfSize(15)
                lblFundName.textColor = UIColor.blackColor()
                lblFundName.textAlignment = .Left
                cell.contentView.addSubview(lblFundName)
                
                var lblUnits : UILabel!
                lblUnits = UILabel(frame: CGRect(x: 45, y: 20, width: (cell.contentView.frame.size.width/2), height: 20));
                
                let un = Double(objMFTransaction.TxnpucharseUnits)
                let Units = String(format: "%.1f", un!)
                
                let nv = Double(objMFTransaction.TxnpuchaseNAV)
                let Nav = String(format: "%.1f", nv!)
                
                lblUnits.text = "Units : \(Units) | Nav : \(Nav)"
                
                lblUnits.font = UIFont.systemFontOfSize(11)
                lblUnits.textColor = UIColor.darkGrayColor()
                lblUnits.textAlignment = .Left
                cell.contentView.addSubview(lblUnits)
                
                var lblPrice : UILabel!
                lblPrice = UILabel(frame: CGRect(x: 15, y: 0, width: (cell.contentView.frame.size.width)-20, height: 25));
                
                let allUnits = (objMFTransaction.TxnPurchaseAmount as NSString).doubleValue
                
                let num = NSNumber(double: allUnits)
                let formatr : NSNumberFormatter = NSNumberFormatter()
                formatr.numberStyle = .CurrencyStyle
                formatr.locale = NSLocale(localeIdentifier: "en_IN")
                if let stringDT = formatr.stringFromNumber(num)
                {
                    lblPrice.text = stringDT
                }
                
                lblPrice.font = UIFont.systemFontOfSize(13)
                lblPrice.textColor = UIColor.defaultGreenColor
                lblPrice.textAlignment = .Right
                cell.contentView.addSubview(lblPrice)
                
                
//                var lblFolio : UILabel!
//                lblFolio = UILabel(frame: CGRect(x: (cell.contentView.frame.size.width)-95, y: 20, width: 90, height: 20));
//                let last4 = String(objMFAccountDetail.FolioNo.characters.suffix(4))
//                lblFolio.text = "Folio: X- \(last4)"
//                lblFolio.font = UIFont.systemFontOfSize(11)
//                lblFolio.textColor = UIColor.darkGrayColor()
//                lblFolio.textAlignment = .Right
//                if last4=="" {
//                }else{
//                    cell.contentView.addSubview(lblFolio)
//                }

                var lblDATE : UILabel!
                lblDATE = UILabel(frame: CGRect(x: 45, y: 35, width: (cell.contentView.frame.size.width/2), height: 20));
                
                let index = objMFTransaction.ExecutaionDateTime.startIndex.advancedBy(10)
                let dtShort = objMFTransaction.ExecutaionDateTime.substringToIndex(index)
                print(dtShort)
                
                let formatter  = NSDateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                let date = formatter.dateFromString(dtShort)!
//                lblDATE.text = date.getDateInString()
                lblDATE.font = UIFont.systemFontOfSize(11)
                lblDATE.textColor = UIColor.darkGrayColor()
                lblDATE.textAlignment = .Left
                cell.contentView.addSubview(lblDATE)

                
                let calendar = NSCalendar.currentCalendar()
                let components = calendar.components([.Day , .Month , .Year], fromDate: date)
                let year =  components.year
                let month = components.month
                let day = components.day

                let stringMonth = MONTH.allValues[month]
                let stringYear = String(year)
                let yearToAdd = stringYear.substring(2)

                lblDATE.text = "\(String(day))-\(stringMonth.capitalizedString)-\(yearToAdd)"
                
                var lblType : UILabel!
                lblType = UILabel(frame: CGRect(x: 3, y: 60, width: (cell.contentView.frame.size.width/2), height: 15));
                lblType.text = "Redeem"
                lblType.font = UIFont.systemFontOfSize(7)
                lblType.textColor = UIColor.darkGrayColor()
                lblType.textAlignment = .Left
                cell.contentView.addSubview(lblType)
                
                
                if objMFTransaction.TxtType == MFU_TXN_TYPE_ADDITIONAL_BUY || objMFTransaction.TxtType == MFU_TXN_TYPE_BUY || objMFTransaction.TxtType == MFU_TXN_TYPE_SIP || objMFTransaction.TxtType == MFU_TXN_TYPE_SWITCH_IN || objMFTransaction.TxtType == MFU_TXN_TYPE_STP_IN{
                    
                    lblType.text = "Switch-In"
                    cell.contentView.addSubview(self.getBuyImageView())

                }else if objMFTransaction.TxtType == MFU_TXN_TYPE_REDEEM || objMFTransaction.TxtType == MFU_TXN_TYPE_SWP || objMFTransaction.TxtType == MFU_TXN_TYPE_STP_OUT || objMFTransaction.TxtType == MFU_TXN_TYPE_SWITCH_OUT{
                    
                    lblType.text = "Redeem"
                    cell.contentView.addSubview(self.getRedeemImageView())
                    
                }

                
                var lblLineBot : UILabel!
                lblLineBot = UILabel(frame: CGRect(x: 0, y: 69, width: (tableView.frame.size.width), height: 0.5));
                lblLineBot.backgroundColor = UIColor.lightGrayColor()
                cell.contentView.addSubview(lblLineBot)

                
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                cell.contentView.backgroundColor = UIColor.clearColor()
                cell.backgroundColor = UIColor.whiteColor()
                
                return cell
                

            }
        }
        
        let stringIdentifier = "CELL_BLANK"
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: stringIdentifier)
        let cell = tableView.dequeueReusableCellWithIdentifier(stringIdentifier, forIndexPath: indexPath) as UITableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.contentView.backgroundColor = UIColor.clearColor()
        cell.backgroundColor = UIColor.whiteColor()
        
        return cell;
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if tableView==self.tbView {
            return 70
        }else{
            return 70
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if tableView==self.tbView {
            
//            if isPurchaseAvail==true && isRedeemAvail==true{
//                
//                if section==0 {
//                    
//                    let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 5))
//                    view.backgroundColor = UIColor.whiteColor()
//                    
//                    var lblLineTop : UILabel!
//                    lblLineTop = UILabel(frame: CGRect(x: 0, y: 0, width: (tableView.frame.size.width), height: 0.5));
//                    lblLineTop.backgroundColor = UIColor.lightGrayColor()
//                    view.addSubview(lblLineTop)
//                    
//                    var lblLineBot : UILabel!
//                    lblLineBot = UILabel(frame: CGRect(x: 0, y: 34, width: (tableView.frame.size.width), height: 0.5));
//                    lblLineBot.backgroundColor = UIColor.lightGrayColor()
//                    view.addSubview(lblLineBot)
//                    
//                    var lblWalthTrustPort : UILabel!
//                    lblWalthTrustPort = UILabel(frame: CGRect(x: 10, y: 0, width: (tableView.frame.size.width)-20, height: 35));
//                    lblWalthTrustPort.text = "PURCHASE"
//                    lblWalthTrustPort.font = UIFont.systemFontOfSize(18)
//                    lblWalthTrustPort.textColor = UIColor.defaultAppColorBlue
//                    lblWalthTrustPort.textAlignment = .Left
//                    view.addSubview(lblWalthTrustPort)
//                    
//                    var lblPrice : UILabel!
//                    lblPrice = UILabel(frame: CGRect(x: 10, y: 0, width: (tableView.frame.size.width)-15, height: 35));
//                    
//                    var total = 0.0
//                    for objData in self.arrPurchase {
//                        
//                        let transaction = objData as! MFTransaction
//                        total = total + Double(transaction.TxnPurchaseAmount)!
//                    }
//                    
//                    let num = NSNumber(double: total)
//                    let formatr : NSNumberFormatter = NSNumberFormatter()
//                    formatr.numberStyle = .CurrencyStyle
//                    formatr.locale = NSLocale(localeIdentifier: "en_IN")
//                    if let stringDT = formatr.stringFromNumber(num)
//                    {
//                        lblPrice.text = stringDT
//                    }
//                    
//                    lblPrice.font = UIFont.systemFontOfSize(18)
//                    lblPrice.textColor = UIColor.defaultGreenColor
//                    lblPrice.textAlignment = .Right
//                    view.addSubview(lblPrice)
//                    self.tbView.tableHeaderView = view
//                    return view
//                    
//                }else{
//                    
//                    let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 5))
//                    view.backgroundColor = UIColor.whiteColor()
//                    
//                    var lblLineTop : UILabel!
//                    lblLineTop = UILabel(frame: CGRect(x: 0, y: 0, width: (tableView.frame.size.width), height: 0.5));
//                    lblLineTop.backgroundColor = UIColor.lightGrayColor()
//                    view.addSubview(lblLineTop)
//                    
//                    var lblLineBot : UILabel!
//                    lblLineBot = UILabel(frame: CGRect(x: 0, y: 34, width: (tableView.frame.size.width), height: 0.5));
//                    lblLineBot.backgroundColor = UIColor.lightGrayColor()
//                    view.addSubview(lblLineBot)
//                    
//                    
//                    var lblWalthTrustPort : UILabel!
//                    lblWalthTrustPort = UILabel(frame: CGRect(x: 10, y: 0, width: (tableView.frame.size.width)-20, height: 35));
//                    lblWalthTrustPort.text = "REDEMPTION"
//                    lblWalthTrustPort.font = UIFont.systemFontOfSize(18)
//                    lblWalthTrustPort.textColor = UIColor.defaultAppColorBlue
//                    lblWalthTrustPort.textAlignment = .Left
//                    view.addSubview(lblWalthTrustPort)
//                    
//                    
//                    var lblPrice : UILabel!
//                    lblPrice = UILabel(frame: CGRect(x: 10, y: 0, width: (tableView.frame.size.width)-15, height: 35));
//                    
//                    var total = 0.0
//                    for objData in self.arrRedeem {
//                        
//                        let transaction = objData as! MFTransaction
//                        total = total + Double(transaction.TxnPurchaseAmount)!
//                    }
//                    
//                    let num = NSNumber(double: total)
//                    let formatr : NSNumberFormatter = NSNumberFormatter()
//                    formatr.numberStyle = .CurrencyStyle
//                    formatr.locale = NSLocale(localeIdentifier: "en_IN")
//                    if let stringDT = formatr.stringFromNumber(num)
//                    {
//                        lblPrice.text = stringDT
//                    }
//                    
//                    lblPrice.font = UIFont.systemFontOfSize(18)
//                    lblPrice.textColor = UIColor.defaultGreenColor
//                    lblPrice.textAlignment = .Right
//                    view.addSubview(lblPrice)
//                    
//                    self.tbView.tableHeaderView = view
//                    return view
//                    
//                }
//            }else{
//                if isPurchaseAvail==true {
//                    
//                    let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 5))
//                    view.backgroundColor = UIColor.whiteColor()
//                    
//                    var lblLineTop : UILabel!
//                    lblLineTop = UILabel(frame: CGRect(x: 0, y: 0, width: (tableView.frame.size.width), height: 0.5));
//                    lblLineTop.backgroundColor = UIColor.lightGrayColor()
//                    view.addSubview(lblLineTop)
//                    
//                    var lblLineBot : UILabel!
//                    lblLineBot = UILabel(frame: CGRect(x: 0, y: 34, width: (tableView.frame.size.width), height: 0.5));
//                    lblLineBot.backgroundColor = UIColor.lightGrayColor()
//                    view.addSubview(lblLineBot)
//                    
//                    var lblWalthTrustPort : UILabel!
//                    lblWalthTrustPort = UILabel(frame: CGRect(x: 10, y: 0, width: (tableView.frame.size.width)-20, height: 35));
//                    lblWalthTrustPort.text = "PURCHASE"
//                    lblWalthTrustPort.font = UIFont.systemFontOfSize(18)
//                    lblWalthTrustPort.textColor = UIColor.defaultAppColorBlue
//                    lblWalthTrustPort.textAlignment = .Left
//                    view.addSubview(lblWalthTrustPort)
//                    
//                    var lblPrice : UILabel!
//                    lblPrice = UILabel(frame: CGRect(x: 10, y: 0, width: (tableView.frame.size.width)-15, height: 35));
//                    
//                    var total = 0.0
//                    for objData in self.arrPurchase {
//                        
//                        let transaction = objData as! MFTransaction
//                        total = total + Double(transaction.TxnPurchaseAmount)!
//                    }
//                    
//                    let num = NSNumber(double: total)
//                    let formatr : NSNumberFormatter = NSNumberFormatter()
//                    formatr.numberStyle = .CurrencyStyle
//                    formatr.locale = NSLocale(localeIdentifier: "en_IN")
//                    if let stringDT = formatr.stringFromNumber(num)
//                    {
//                        lblPrice.text = stringDT
//                    }
//                    
//                    lblPrice.font = UIFont.systemFontOfSize(18)
//                    lblPrice.textColor = UIColor.defaultGreenColor
//                    lblPrice.textAlignment = .Right
//                    view.addSubview(lblPrice)
//                    
//                    self.tbView.tableHeaderView = view
//                    return view
//                    
//                }
//                if isRedeemAvail==true {
//                    
//                    let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 5))
//                    view.backgroundColor = UIColor.whiteColor()
//                    
//                    var lblLineTop : UILabel!
//                    lblLineTop = UILabel(frame: CGRect(x: 0, y: 0, width: (tableView.frame.size.width), height: 0.5));
//                    lblLineTop.backgroundColor = UIColor.lightGrayColor()
//                    view.addSubview(lblLineTop)
//                    
//                    var lblLineBot : UILabel!
//                    lblLineBot = UILabel(frame: CGRect(x: 0, y: 34, width: (tableView.frame.size.width), height: 0.5));
//                    lblLineBot.backgroundColor = UIColor.lightGrayColor()
//                    view.addSubview(lblLineBot)
//                    
//                    
//                    var lblWalthTrustPort : UILabel!
//                    lblWalthTrustPort = UILabel(frame: CGRect(x: 10, y: 0, width: (tableView.frame.size.width)-20, height: 35));
//                    lblWalthTrustPort.text = "REDEMPTION"
//                    lblWalthTrustPort.font = UIFont.systemFontOfSize(18)
//                    lblWalthTrustPort.textColor = UIColor.defaultAppColorBlue
//                    lblWalthTrustPort.textAlignment = .Left
//                    view.addSubview(lblWalthTrustPort)
//                    
//                    
//                    var lblPrice : UILabel!
//                    lblPrice = UILabel(frame: CGRect(x: 10, y: 0, width: (tableView.frame.size.width)-15, height: 35));
//                    
//                    var total = 0.0
//                    for objData in self.arrRedeem {
//                        
//                        let transaction = objData as! MFTransaction
//                        total = total + Double(transaction.TxnPurchaseAmount)!
//                    }
//                    
//                    let num = NSNumber(double: total)
//                    let formatr : NSNumberFormatter = NSNumberFormatter()
//                    formatr.numberStyle = .CurrencyStyle
//                    formatr.locale = NSLocale(localeIdentifier: "en_IN")
//                    if let stringDT = formatr.stringFromNumber(num)
//                    {
//                        lblPrice.text = stringDT
//                    }
//                    
//                    lblPrice.font = UIFont.systemFontOfSize(18)
//                    lblPrice.textColor = UIColor.defaultGreenColor
//                    lblPrice.textAlignment = .Right
//                    view.addSubview(lblPrice)
//                    self.tbView.tableHeaderView = view
//                    return view
//                    
//                }
//            }
//            
//
//        }else{
//            return UIView()
        }
        return UIView()
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView==self.tbView
        {
            return 0
        }
        else
        {
            return 0
        }
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView==self.tbView {
            
            if isPurchaseAvail==true && isRedeemAvail==true
            {
                
                let objDetials = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdMFTransactionDetailScreen) as! MFTransactionDetailScreen
                
                var objMFTransaction = MFTransaction()
                if indexPath.section==0
                {
                    objMFTransaction = arrPurchase.objectAtIndex(indexPath.row) as! MFTransaction
                    
                    objDetials.isRedeem = false
                }
                else
                {
                    objMFTransaction = arrRedeem.objectAtIndex(indexPath.row) as! MFTransaction
                    
                    objDetials.isRedeem = true
                }
                
                objDetials.isFrom = self.isFrom
                
                objDetials.objMFAccountDetail = self.objMFAccountDetail
                objDetials.objMFTransactionDetail = objMFTransaction
                self.navigationController?.pushViewController(objDetials, animated: true)
                
                
            }
            else
            {
                if isPurchaseAvail==true
                {
                    
                    let objMFTransaction = arrPurchase.objectAtIndex(indexPath.row) as! MFTransaction
                    let objDetials = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdMFTransactionDetailScreen) as! MFTransactionDetailScreen
                    objDetials.objMFAccountDetail = self.objMFAccountDetail
                    objDetials.objMFTransactionDetail = objMFTransaction
                    objDetials.isRedeem = false
                    objDetials.isFrom = self.isFrom

                    self.navigationController?.pushViewController(objDetials, animated: true)
                    
                }
                if isRedeemAvail==true
                {
                    
                    let objMFTransaction = arrRedeem.objectAtIndex(indexPath.row) as! MFTransaction
                    let objDetials = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdMFTransactionDetailScreen) as! MFTransactionDetailScreen
                    objDetials.objMFAccountDetail = self.objMFAccountDetail
                    objDetials.objMFTransactionDetail = objMFTransaction
                    objDetials.isRedeem = true
                    objDetials.isFrom = self.isFrom

                    self.navigationController?.pushViewController(objDetials, animated: true)
                    
                }
            }
            
        }
        else{
            
            let objMFTransaction = arrGraphTransactions.objectAtIndex(indexPath.row) as! MFTransaction
            let objDetials = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdMFTransactionDetailScreen) as! MFTransactionDetailScreen
            objDetials.objMFAccountDetail = self.objMFAccountDetail
            objDetials.objMFTransactionDetail = objMFTransaction
            
            if objMFTransaction.TxtType == MFU_TXN_TYPE_ADDITIONAL_BUY || objMFTransaction.TxtType == MFU_TXN_TYPE_BUY || objMFTransaction.TxtType == MFU_TXN_TYPE_SIP || objMFTransaction.TxtType == MFU_TXN_TYPE_SWITCH_IN || objMFTransaction.TxtType == MFU_TXN_TYPE_STP_IN{
                
                objDetials.isRedeem = false
                
            }else if objMFTransaction.TxtType == MFU_TXN_TYPE_REDEEM || objMFTransaction.TxtType == MFU_TXN_TYPE_SWP || objMFTransaction.TxtType == MFU_TXN_TYPE_STP_OUT || objMFTransaction.TxtType == MFU_TXN_TYPE_SWITCH_OUT{
                
                objDetials.isRedeem = true
            }

            objDetials.isFrom = self.isFrom

            self.navigationController?.pushViewController(objDetials, animated: true)

        }
    }
    
//    @IBAction func btnGraphClickedd(sender: AnyObject) {
    
//        viewGraphDetailData.hidden = false
        
//        var arr = NSMutableArray()
//
//        if isFrom == "Wealth" {
//            arr = DBManager.getInstance().getMFUTransactionsByAccountID(objMFAccountDetail.AccId)
//        }else{
//            arr = DBManager.getInstance().getMFUTransactionsByAccountIDFromManual(objMFAccountDetail.AccId)
//        }
//        
//        if selectedMenu==1 { // 3m Selected..
//            print("3m Selected")
//            
//            if arr.count==0 {
//                
//            }else{
    
//                for objTrans in arr
//                {
//                    let dtTransaction = objTrans as! MFTransaction
//                    let index = dtTransaction.ExecutaionDateTime.startIndex.advancedBy(10)
//                    let dtShort = dtTransaction.ExecutaionDateTime.substringToIndex(index)
//                    print(dtShort)
//                    
//                    let formatter  = NSDateFormatter()
//                    formatter.dateFormat = "yyyy-MM-dd"
//                    let date = formatter.dateFromString(dtShort)!
//                    
//                    let calendar = NSCalendar.currentCalendar()
//                    let components = calendar.components([.Day , .Month , .Year], fromDate: date)
//                    
////                    let year =  components.year
////                    let month = components.month
////                    let day = components.day
//                    
//
//                    let todayDate = NSDate()
//                    print(todayDate)
//
//                    let lastThreeMonthDate = date.setMonthWitDay1(<#T##monthToSet: Int##Int#>, date: <#T##NSDate#>)
//                    
//                }
                
                
//                self.arrGraphTransactions = arr
////                self.tblViewGraph.reloadData()
//                self.viewGraph.reloadInputViews()
//            }
//
//        }
//        if selectedMenu==2 { // 1Y selected..
//            print("1Y Selected")
//            
//            if arr.count==0 {
//                
//            }else{
//                self.arrGraphTransactions = arr
//                self.tblViewGraph.reloadData()
//                self.viewGraph.reloadInputViews()
//            }
//
//        }
//        if selectedMenu==3 {// All Seelcted...
//            print("All Selected")
//            
//            
//            if arr.count==0 {
//                
//            }else{
//                self.arrGraphTransactions = arr
////                self.tblViewGraph.reloadData()
//                self.viewGraph.reloadInputViews()
//            }
//
//        }
//        
//    }
    
    func scrollViewDidScroll(scrollView: UIScrollView)
    {
        self.scrollableView.delegate = self
        print("scrollViewDidScroll")
        scrollView.scrollEnabled = true
        
        self.scrollableView.contentSize = CGSize(width: self.childView.frame.size.width, height: self.childView.frame.size.height+self.viewGraph.frame.size.height+15)
        
//        self.scrollableView.contentSize = CGSize(width: self.childView.frame.size.width, height: childView.frame.size.height)
//        var previousOffset = CGFloat()
//        var rect = CGRect()
//        rect = self.scrollableView.frame
//        rect.origin.y += previousOffset - scrollView.contentOffset.y
//        previousOffset = scrollView.contentOffset.y
//        self.scrollableView.frame = rect
        
//        let desiredOffset = CGPoint(x: 0, y: -scrollView.contentInset.top)
//        scrollView.setContentOffset(desiredOffset, animated: true)
        
//        ContentView.Frame = new CGRect (0, 0, View.Bounds.Width, View.Bounds.Height);
    }
    
}
