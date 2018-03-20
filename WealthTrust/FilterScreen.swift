//
//  FilterScreen.swift
//  SearchDemo
//
//  Created by Chirag_i-Phone13 on 08/12/16.
//  Copyright © 2016 The Infinity. All rights reserved.
//

import UIKit

class FilterScreen: UIViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet var btnApplyFilter: UIButton!
    @IBOutlet var btnClearSelection: UIButton!
    @IBOutlet var viewButtonBack: UIView?
    @IBOutlet var btnHorizon: UIButton!
    @IBOutlet var btnRisk: UIButton!
    @IBOutlet var btnFundHouse: UIButton!
    @IBOutlet var btnOption: UIButton!
    @IBOutlet var btnCategory: UIButton!
    var arrHorizon = NSMutableArray()
    var arrPlanOpt = NSMutableArray()
    var arrFundType = NSMutableArray()
    var arrFundName = NSMutableArray()
    var arrRisk = NSMutableArray()
    var arrFilterSubData = NSArray()
    var selectedButtonIndex = Int()
    
    let objDefault=NSUserDefaults.standardUserDefaults()
    
    @IBOutlet weak var tblSubFilter: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        
        let barbutton = UIBarButtonItem(image: UIImage(named:"iconBack"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(SearchScreen.btnBackTap(_:)))
        
        self.navigationItem.leftBarButtonItem = barbutton
        self.title = "FILTER BY"
        
        if objDefault .valueForKey("Horizon")==nil
        {
            self .APIToGetFilterList()
        }
        else
        {
            arrHorizon=objDefault .valueForKey("Horizon")?.mutableCopy() as! NSMutableArray
            arrFundName=objDefault .valueForKey("Fund_Name")?.mutableCopy() as! NSMutableArray
            arrPlanOpt=objDefault .valueForKey("Plan_Opt")?.mutableCopy() as! NSMutableArray
            arrRisk=objDefault .valueForKey("Risk")?.mutableCopy() as! NSMutableArray
            arrFundType=objDefault .valueForKey("Fund_type")?.mutableCopy() as! NSMutableArray
            
            dispatch_async(dispatch_get_main_queue(),{
                self.btnFilterCatagoryTap(self.btnHorizon)
                self.tblSubFilter.reloadData()
            })
        }
        
    }
    func methodToSortArray(str:String,dicVal:NSMutableDictionary)->NSMutableArray
    {
        var arrTemp=NSMutableArray()
        let arrValues=NSMutableArray()
        
        arrTemp=dicVal .valueForKey(str)?.mutableCopy() as! NSMutableArray
        for i in 0..<arrTemp .count
        {   let dicTemp=NSMutableDictionary()
            dicTemp .setValue(arrTemp .objectAtIndex(i), forKey: "value")
            dicTemp .setValue(i , forKey: "index")
            dicTemp .setValue(0, forKey: "isSelected")
            arrValues .addObject(dicTemp)
        }
        return arrValues
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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func btnFilterCatagoryTap(sender: UIButton) {
        
        btnHorizon.backgroundColor = UIColor(red:240/250, green:240/250, blue:240/250, alpha: 1)
        btnRisk.backgroundColor = UIColor(red:240/250, green:240/250, blue:240/250, alpha: 1)
        btnFundHouse.backgroundColor = UIColor(red:240/250, green:240/250, blue:240/250, alpha: 1)
        btnOption.backgroundColor = UIColor(red:240/250, green:240/250, blue:240/250, alpha: 1)
        btnCategory.backgroundColor = UIColor(red:240/250, green:240/250, blue:240/250, alpha: 1)
        
        sender.backgroundColor = UIColor.whiteColor()
        
        selectedButtonIndex = sender.tag
        
        switch sender.tag {
        case 1:
            arrFilterSubData = arrHorizon as NSArray
            break
        case 2:
            arrFilterSubData = arrRisk as NSArray
            break
        case 3:
            arrFilterSubData = arrFundName as NSArray
            break
        case 4:
            arrFilterSubData = arrPlanOpt as NSArray
            break
        case 5:
            arrFilterSubData = arrFundType as NSArray
            break
        default:
            break
        }
        
        self.tblSubFilter.reloadData()
        
    }
    
    
    
    
    @IBAction func btnClearSelectionTap(sender: AnyObject) {
        
        for i in 0..<5
        {
            switch i
            {
            case 0:
                self.arrHorizon=self.ClearArraySelection(arrHorizon)
                print(arrHorizon)
                break
            case 1:
                self.arrFundName=self.ClearArraySelection(arrFundName)
                break
            case 2:
                self.arrPlanOpt=self.ClearArraySelection(arrPlanOpt)
                break
            case 3:
                self.arrRisk=self.ClearArraySelection(arrRisk)
                break
            case 4:
                self.arrFundType=self.ClearArraySelection(arrFundType)
                break
                
            default:
                break
            }
        }
        self.tblSubFilter.reloadData()
        self .saveToUserDefault()
        
    }
    @IBAction func btnApplyFilterTap(sender: AnyObject) {
        self .saveToUserDefault()
        sharedInstance.kIsFilter = true
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrFilterSubData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        let stringIdentifier = "ALL_SELECTED_DATA_\(indexPath.row)_\(indexPath.section)"
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: stringIdentifier)
        
        let cell = tableView.dequeueReusableCellWithIdentifier(stringIdentifier, forIndexPath: indexPath) as UITableViewCell
        
        var str = NSString()
        str = (arrFilterSubData.objectAtIndex(indexPath.row) .valueForKey("value") as? String)!
        if str.isEqualToString("BO") {
            cell.textLabel?.text = "Bonus"
        }
        else if str.isEqualToString("GR") {
            cell.textLabel?.text = "Growth"
        }
        else if str.isEqualToString("DIV") {
            cell.textLabel?.text = "Dividend"
        }
        else{
            cell.textLabel?.text = arrFilterSubData.objectAtIndex(indexPath.row) .valueForKey("value") as? String
        }
        let isSelected = arrFilterSubData.objectAtIndex(indexPath.row).valueForKey("isSelected") as? NSInteger
        
        if isSelected==1 {
            cell.imageView?.image = UIImage(named: "iconCheck.png")
        }
        else
        {
            cell.imageView?.image = UIImage(named: "iconUncheck.png")
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
        
        
        
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tblSubFilter.cellForRowAtIndexPath(indexPath)
        var valSelected = NSInteger()
        if cell?.imageView?.image == UIImage(named: "iconUncheck.png")
        {
            cell?.imageView?.image = UIImage(named: "iconCheck.png")
            
            valSelected=1
        }else
        {
            cell?.imageView?.image = UIImage(named: "iconUncheck.png")
            valSelected=0
        }
        
        
        switch selectedButtonIndex
        {
        case 1:
            print(arrHorizon);
            let dic = NSMutableDictionary()
            let strValue = arrHorizon.objectAtIndex(indexPath.row).valueForKey("value")
            let strIndex = arrHorizon.objectAtIndex(indexPath.row).valueForKey("index")
            dic .setValue(valSelected, forKey: "isSelected")
            dic .setValue(strIndex, forKey: "index")
            dic .setValue(strValue, forKey: "value")
            arrHorizon .replaceObjectAtIndex(indexPath.row, withObject: dic)
            print(arrHorizon)
            //                arrHorizon .replaceObjectAtIndex(indexPath.row);, withObject: dic
            //                arrHorizon.objectAtIndex(indexPath.row).setValue(valSelected, forKey: "isSelected")
            break
        case 2:
            let dic = NSMutableDictionary()
            let strValue = arrRisk.objectAtIndex(indexPath.row).valueForKey("value")
            let strIndex = arrRisk.objectAtIndex(indexPath.row).valueForKey("index")
            dic .setValue(valSelected, forKey: "isSelected")
            dic .setValue(strIndex, forKey: "index")
            dic .setValue(strValue, forKey: "value")
            arrRisk .replaceObjectAtIndex(indexPath.row, withObject: dic)
            print(arrRisk)
            
            //                arrRisk.objectAtIndex(indexPath.row).setValue(valSelected, forKey: "isSelected")
            break
        case 3:
            let dic = NSMutableDictionary()
            let strValue = arrFundName.objectAtIndex(indexPath.row).valueForKey("value")
            let strIndex = arrFundName.objectAtIndex(indexPath.row).valueForKey("index")
            dic .setValue(valSelected, forKey: "isSelected")
            dic .setValue(strIndex, forKey: "index")
            dic .setValue(strValue, forKey: "value")
            arrFundName .replaceObjectAtIndex(indexPath.row, withObject: dic)
            print(arrFundName)
            
            //                arrFundName.objectAtIndex(indexPath.row).setValue(valSelected, forKey: "isSelected")
            break
        case 4:
            let dic = NSMutableDictionary()
            let strValue = arrPlanOpt.objectAtIndex(indexPath.row).valueForKey("value")
            let strIndex = arrPlanOpt.objectAtIndex(indexPath.row).valueForKey("index")
            dic .setValue(valSelected, forKey: "isSelected")
            dic .setValue(strIndex, forKey: "index")
            dic .setValue(strValue, forKey: "value")
            arrPlanOpt .replaceObjectAtIndex(indexPath.row, withObject: dic)
            print(arrPlanOpt)
            
            //                arrPlanOpt.objectAtIndex(indexPath.row).setValue(valSelected, forKey: "isSelected")
            break
        case 5:
            let dic = NSMutableDictionary()
            let strValue = arrFundType.objectAtIndex(indexPath.row).valueForKey("value")
            let strIndex = arrFundType.objectAtIndex(indexPath.row).valueForKey("index")
            dic .setValue(valSelected, forKey: "isSelected")
            dic .setValue(strIndex, forKey: "index")
            dic .setValue(strValue, forKey: "value")
            arrFundType .replaceObjectAtIndex(indexPath.row, withObject: dic)
            print(arrFundType)
            
            //                arrFundType.objectAtIndex(indexPath.row).setValue(valSelected, forKey: "isSelected")
            break
            
        default:
            break
        }
        
    }
    func APIToGetFilterList()  {
        WebManagerHK .getDataToURL(kModeGetSchemeSearchFilters, params: NSNull(), message: "Please Wait...") { (result) in
            var dic = NSDictionary()
            dic = result.valueForKey(kWAPIResponse) as! NSDictionary
            
            for i in 0..<dic .count
            {
                switch i
                {
                case 0:
                    self.arrHorizon=self .methodToSortArray("Horizon", dicVal: dic .mutableCopy() as! NSMutableDictionary)
                    
                    break
                case 1:
                    self.arrFundName=self .methodToSortArray("Fund_Name", dicVal: dic .mutableCopy() as! NSMutableDictionary)
                    
                    break
                case 2:
                    self.arrPlanOpt = self.methodForOptionArray(NSNull)
                    break
                case 3:
                    self.arrRisk=self .methodToSortArray("Risk", dicVal: dic .mutableCopy() as! NSMutableDictionary)
                    break
                case 4:
                    self.arrFundType=self .methodToSortArray("Fund_type", dicVal: dic .mutableCopy() as! NSMutableDictionary)
                    break
                    
                default:
                    break
                }
            }
            self .saveToUserDefault()
            
            self.btnHorizon.backgroundColor = UIColor.whiteColor()
            
            dispatch_async(dispatch_get_main_queue(),{
                self.btnFilterCatagoryTap(self.btnHorizon)
                self.tblSubFilter.reloadData()
            })
        }
    }
    func saveToUserDefault()  {
        
        self.objDefault .setValue(self.arrHorizon, forKey: "Horizon")
        self.objDefault .setValue(self.arrHorizon, forKey: "Horizon")
        
        self.objDefault .setValue(self.arrFundName, forKey: "Fund_Name")
        self.objDefault .setValue(self.arrPlanOpt, forKey: "Plan_Opt")
        self.objDefault .setValue(self.arrRisk, forKey: "Risk")
        self.objDefault .setValue(self.arrFundType, forKey: "Fund_type")
        self.objDefault .synchronize()
    }
    func ClearArraySelection(array:NSMutableArray) -> NSMutableArray {
        
        for index in 0..<array.count {
            
            let dic = NSMutableDictionary()
            let strValue = array.objectAtIndex(index).valueForKey("value")
            let strIndex = array.objectAtIndex(index).valueForKey("index")
            dic .setValue(0, forKey: "isSelected")
            dic .setValue(strIndex, forKey: "index")
            dic .setValue(strValue, forKey: "value")
            array .replaceObjectAtIndex(index, withObject: dic)
        }
        return array
    }
    
    func btnBackTap( sender:AnyObject) {
        if let navController = self.navigationController {
            navController.popViewControllerAnimated(true)
        }
        sharedInstance.kIsFilter = false
        print(sender)
    }
}

