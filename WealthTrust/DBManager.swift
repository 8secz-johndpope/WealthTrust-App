    //
    //  DBManager.swift
    //  StakesApp
    //
    //  Created by Hemen Gohil on 6/23/16.
    //  Copyright © 2016 Hemen Gohil. All rights reserved.
    //
    
    import UIKit
    
    let sharedInstanceDB = DBManager()
    
    let DB_NAME = "WealthTrustDB.sqlite"
    let DB_TBL_USER_MASTER = "User"
    let DB_TBL_AOFStatus_MASTER = "AOFStatus"
    let DB_TBL_ORDER_MASTER = "OrderMaster"
    let DB_TBL_ORDER_SYSTEMATIC_MASTER = "SystematicOrderDetail"
    
    let DB_TBL_MF_ACCOUNT = "MF_Account"
    let DB_TBL_MF_TRANSACTION = "MF_Transaction"
    let DB_TBL_MANUAL_MF_ACCOUNT = "Manual_MF_Account"
    let DB_TBL_MANUAL_MF_TRANSACTION = "Manual_MF_Transaction"
    let DB_TBL_DYNAMIC_TEXT = "Dynamictext"
    let DB_TBL_PAY_EZZ_MANDATE = "PayEzzMandate"
    
    let DB_TBL_mfuPortfolioWorthTable = "mfuPortfolioWorthTable"
    let DB_TBL_mfuPortfolioManualWorthTable = "mfuPortfolioManualWorthTable"
    
    let date = NSDate()
    let dateFormatter = NSDateFormatter()
    let calendar = NSCalendar.currentCalendar()
    let unitFlags: NSCalendarUnit = [.Year,.Month]
    
    class DBManager: NSObject {
        
        var database: FMDatabase? = nil
        
        class func getInstance() -> DBManager
        {
            if(sharedInstanceDB.database == nil)
            {
                sharedInstanceDB.database = FMDatabase(path: SharedManager.getPath(DB_NAME))
            }
            return sharedInstanceDB
        }
        
        func getMyOrdersData() -> NSMutableArray {
            
            
            var clientId = "0";
            let allUser = getAllUser()
            if allUser.count>0
            {
                let objUser = allUser.objectAtIndex(0) as! User
                clientId = objUser.ClientID
            }
            
            sharedInstanceDB.database!.open()
            
            let SQL = "SELECT OrderMaster.*,MF_Transaction.TxnpucharseUnits,MF_Transaction.TxnpuchaseNAV,MF_Transaction.TxnPurchaseAmount,MF_Transaction.ExecutaionDateTime,MF_Transaction.TxtType FROM OrderMaster LEFT JOIN MF_Transaction ON OrderMaster.ServerOrderID=MF_Transaction.OrderId WHERE CartFlag=0 AND OrderMaster.ClientID=\(clientId)"
            
            let resultSet: FMResultSet! = sharedInstanceDB.database!.executeQuery(SQL, withArgumentsInArray: nil)
            
            let marrStakeInfo : NSMutableArray = NSMutableArray()
            if (resultSet != nil) {
                while resultSet.next() {
                    
                    let userInfo : Order = Order()
                    
                    userInfo.AppOrderID = resultSet.stringForColumn(kAppOrderID)
                    userInfo.ServerOrderID = resultSet.stringForColumn(kServerOrderID)
                    userInfo.ClientID = resultSet.stringForColumn(kClientID)
                    userInfo.FolioNo = resultSet.stringForColumn(kFolioNo)
                    userInfo.FolioCheckDigit = resultSet.stringForColumn(kFolioCheckDigit)
                    userInfo.RtaAmcCode = resultSet.stringForColumn(kRtaAmcCode)
                    userInfo.SrcSchemeCode = resultSet.stringForColumn(kSrcSchemeCode)
                    userInfo.SrcSchemeName = resultSet.stringForColumn(kSrcSchemeName)
                    userInfo.TarSchemeCode = resultSet.stringForColumn(kTarSchemeCode)
                    userInfo.TarSchemeName = resultSet.stringForColumn(kTarSchemeName)
                    userInfo.DividendOption = resultSet.stringForColumn(kDividendOption)
                    userInfo.VolumeType = resultSet.stringForColumn(kVolumeType)
                    userInfo.Volume = resultSet.stringForColumn(kVolume)
                    userInfo.OrderType = resultSet.stringForColumn(kOrderType)
                    userInfo.OrderStatus = resultSet.stringForColumn(kOrderStatus)
                    userInfo.AppOrderTimeStamp = resultSet.stringForColumn(kAppOrderTimeStamp)
                    userInfo.CartFlag = resultSet.stringForColumn(kCartFlag)
                    userInfo.UpdateTime = resultSet.stringForColumn(kUpdateTime)
                    userInfo.txnPurchaseUnits = resultSet.stringForColumn(kTxnpucharseUnits)
                    userInfo.txnPurchaseNav = resultSet.stringForColumn(kTxnpuchaseNAV)
                    userInfo.txnPurchaseAmount = resultSet.stringForColumn(kTxnPurchaseAmount)
                    userInfo.executionDateTime = resultSet.stringForColumn(kExecutaionDateTime)
                    
                    marrStakeInfo.addObject(userInfo)
                    
                }
            }
            sharedInstanceDB.database!.close()
            
            return marrStakeInfo
        }
        
        
        func addUser(UserInfo : User) -> Bool {
            
            sharedInstanceDB.database!.open()
            
            let isInserted = sharedInstanceDB.database?.executeUpdate("INSERT INTO \(DB_TBL_USER_MASTER) (\(kClientID), \(kName), \(kEmail), \(kMob), \(kPassword), \(kCAN), \(kSignupStatus), \(kInvestmentAofStatus)) VALUES (?, ?, ?, ?, ?, ?, ?, ?)", withArgumentsInArray: [UserInfo.ClientID,UserInfo.Name,UserInfo.email,UserInfo.mob,UserInfo.password,UserInfo.CAN,UserInfo.SignupStatus,UserInfo.InvestmentAofStatus])
            
            sharedInstanceDB.database?.close()
            
            return isInserted!
        }
        
        func updateUser(UserInfo : User) -> Bool {
            
            sharedInstanceDB.database!.open()
            
            let isInserted = sharedInstanceDB.database?.executeUpdate("UPDATE \(DB_TBL_USER_MASTER) SET \(kName)=?, \(kEmail)=?, \(kMob)=?, \(kCAN)=?, \(kSignupStatus)=?, \(kInvestmentAofStatus)=? WHERE \(kClientID)=?", withArgumentsInArray: [UserInfo.Name,UserInfo.email,UserInfo.mob,UserInfo.CAN,UserInfo.SignupStatus,UserInfo.InvestmentAofStatus,UserInfo.ClientID])
            
            sharedInstanceDB.database?.close()
            
            return isInserted!
        }
        
        func deleteAllUser() -> Bool {
            
            sharedInstanceDB.database!.open()
            
            let isInserted = sharedInstanceDB.database?.executeUpdate("DELETE FROM \(DB_TBL_USER_MASTER)", withArgumentsInArray: nil)
            
            sharedInstanceDB.database?.close()
            
            return isInserted!
        }
        
        func getAllUser() -> NSMutableArray {
            
            sharedInstanceDB.database!.open()
            
            let resultSet: FMResultSet! = sharedInstanceDB.database!.executeQuery("SELECT * FROM \(DB_TBL_USER_MASTER)", withArgumentsInArray: nil)
            
            let marrStakeInfo : NSMutableArray = NSMutableArray()
            if (resultSet != nil) {
                while resultSet.next() {
                    let userInfo : User = User()
                    
                    userInfo.ClientID = resultSet.stringForColumn(kClientID)
                    userInfo.Name = resultSet.stringForColumn(kName)
                    userInfo.email = resultSet.stringForColumn(kEmail)
                    
                    userInfo.mob = resultSet.stringForColumn(kMob)
                    userInfo.password = resultSet.stringForColumn(kPassword)
                    userInfo.CAN = resultSet.stringForColumn(kCAN)
                    userInfo.SignupStatus = resultSet.stringForColumn(kSignupStatus)
                    userInfo.InvestmentAofStatus = resultSet.stringForColumn(kInvestmentAofStatus)
                    
                    marrStakeInfo.addObject(userInfo)
                }
            }
            sharedInstanceDB.database!.close()
            
            return marrStakeInfo
        }
        
        func getLoggedInUserDetails() -> User {
            
            sharedInstanceDB.database!.open()
            
            let resultSet: FMResultSet! = sharedInstanceDB.database!.executeQuery("SELECT * FROM \(DB_TBL_USER_MASTER)", withArgumentsInArray: nil)
            
            let marrStakeInfo : NSMutableArray = NSMutableArray()
            if (resultSet != nil) {
                while resultSet.next() {
                    let userInfo : User = User()
                    
                    userInfo.ClientID = resultSet.stringForColumn(kClientID)
                    userInfo.Name = resultSet.stringForColumn(kName)
                    userInfo.email = resultSet.stringForColumn(kEmail)
                    
                    userInfo.mob = resultSet.stringForColumn(kMob)
                    userInfo.password = resultSet.stringForColumn(kPassword)
                    userInfo.CAN = resultSet.stringForColumn(kCAN)
                    userInfo.SignupStatus = resultSet.stringForColumn(kSignupStatus)
                    userInfo.InvestmentAofStatus = resultSet.stringForColumn(kInvestmentAofStatus)
                    
                    marrStakeInfo.addObject(userInfo)
                }
            }
            sharedInstanceDB.database!.close()
            
            if marrStakeInfo.count==0 {
                return User()
            }else{
                return marrStakeInfo.objectAtIndex(0) as! User
            }
        }
        
        
        // AOFStatus Table Methods....
        func addAOFStatus(UserAOFStatus : AOFStatus) -> Bool {
            
            sharedInstanceDB.database!.open()
            
            let isInserted = sharedInstanceDB.database?.executeUpdate("INSERT INTO \(DB_TBL_AOFStatus_MASTER) (\(kClientID), \(kPanCopy), \(kChequeCopy), \(kSelfie), \(kDobmismatch), \(kNameMismatch), \(kSignaturemismatch), \(kBanckaccmismatch), \(kIFSCmismatch), \(kPannummismatch), \(kAOFtype), \(kIdS)) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", withArgumentsInArray: [UserAOFStatus.ClientID,UserAOFStatus.pancopy,UserAOFStatus.chequecopy,UserAOFStatus.selfie,UserAOFStatus.dobmismatch,UserAOFStatus.namemismatch,UserAOFStatus.signaturemismatch,UserAOFStatus.banckaccmismatch,UserAOFStatus.ifscmismatch,UserAOFStatus.pannummismatch,UserAOFStatus.aoftype,UserAOFStatus.idS])
            
            sharedInstanceDB.database?.close()
            
            return isInserted!
        }
        
        func updateAOFStatus(UserAOFStatus : AOFStatus) -> Bool {
            
            sharedInstanceDB.database!.open()
            
            let isInserted = sharedInstanceDB.database?.executeUpdate("UPDATE \(DB_TBL_AOFStatus_MASTER) SET \(kPanCopy)=?, \(kChequeCopy)=?, \(kSelfie)=?, \(kDobmismatch)=?, \(kNameMismatch)=?, \(kSignaturemismatch)=?, \(kBanckaccmismatch)=?, \(kIFSCmismatch)=?, \(kPannummismatch)=?, \(kIdS)=? WHERE \(kAOFtype)=? AND \(kClientID)=?", withArgumentsInArray: [UserAOFStatus.pancopy,UserAOFStatus.chequecopy,UserAOFStatus.selfie,UserAOFStatus.dobmismatch,UserAOFStatus.namemismatch,UserAOFStatus.signaturemismatch,UserAOFStatus.banckaccmismatch,UserAOFStatus.ifscmismatch,UserAOFStatus.pannummismatch,UserAOFStatus.idS,UserAOFStatus.aoftype,UserAOFStatus.ClientID])
            
            sharedInstanceDB.database?.close()
            
            return isInserted!
        }
        
        func deleteAllAOFStatus() -> Bool {
            
            sharedInstanceDB.database!.open()
            
            let isInserted = sharedInstanceDB.database?.executeUpdate("DELETE FROM \(DB_TBL_AOFStatus_MASTER)", withArgumentsInArray: nil)
            
            sharedInstanceDB.database?.close()
            
            return isInserted!
        }
        
        func getAllAOFStatus() -> NSMutableArray {
            
            sharedInstanceDB.database!.open()
            
            let resultSet: FMResultSet! = sharedInstanceDB.database!.executeQuery("SELECT * FROM \(DB_TBL_AOFStatus_MASTER)", withArgumentsInArray: nil)
            
            let marrStakeInfo : NSMutableArray = NSMutableArray()
            if (resultSet != nil) {
                while resultSet.next() {
                    let UserAOFStatus : AOFStatus = AOFStatus()
                    
                    UserAOFStatus.ClientID = resultSet.stringForColumn(kClientID)
                    UserAOFStatus.pancopy = resultSet.stringForColumn(kPanCopy)
                    UserAOFStatus.chequecopy = resultSet.stringForColumn(kChequeCopy)
                    UserAOFStatus.selfie = resultSet.stringForColumn(kSelfie)
                    UserAOFStatus.dobmismatch = resultSet.stringForColumn(kDobmismatch)
                    UserAOFStatus.namemismatch = resultSet.stringForColumn(kNameMismatch)
                    UserAOFStatus.signaturemismatch = resultSet.stringForColumn(kSignaturemismatch)
                    UserAOFStatus.banckaccmismatch = resultSet.stringForColumn(kBanckaccmismatch)
                    UserAOFStatus.ifscmismatch = resultSet.stringForColumn(kIFSCmismatch)
                    UserAOFStatus.pannummismatch = resultSet.stringForColumn(kPannummismatch)
                    UserAOFStatus.aoftype = resultSet.stringForColumn(kAOFtype)
                    UserAOFStatus.idS = resultSet.stringForColumn(kIdS)
                    
                    marrStakeInfo.addObject(UserAOFStatus)
                }
            }
            sharedInstanceDB.database!.close()
            
            return marrStakeInfo
        }
        
        func checkSignUpStatusAlreadyExist(UserAOFStatus : AOFStatus) -> Bool {
            
            sharedInstanceDB.database!.open()
            
            let resultSet: FMResultSet! = sharedInstanceDB.database!.executeQuery("SELECT * FROM \(DB_TBL_AOFStatus_MASTER) WHERE \(kClientID)=\(UserAOFStatus.ClientID) AND \(kAOFtype)=0", withArgumentsInArray: nil)
            
            let marrStakeInfo : NSMutableArray = NSMutableArray()
            if (resultSet != nil) {
                while resultSet.next() {
                    let UserAOFStatus : AOFStatus = AOFStatus()
                    
                    UserAOFStatus.ClientID = resultSet.stringForColumn(kClientID)
                    UserAOFStatus.pancopy = resultSet.stringForColumn(kPanCopy)
                    UserAOFStatus.chequecopy = resultSet.stringForColumn(kChequeCopy)
                    UserAOFStatus.selfie = resultSet.stringForColumn(kSelfie)
                    UserAOFStatus.dobmismatch = resultSet.stringForColumn(kDobmismatch)
                    UserAOFStatus.namemismatch = resultSet.stringForColumn(kNameMismatch)
                    UserAOFStatus.signaturemismatch = resultSet.stringForColumn(kSignaturemismatch)
                    UserAOFStatus.banckaccmismatch = resultSet.stringForColumn(kBanckaccmismatch)
                    UserAOFStatus.ifscmismatch = resultSet.stringForColumn(kIFSCmismatch)
                    UserAOFStatus.pannummismatch = resultSet.stringForColumn(kPannummismatch)
                    UserAOFStatus.aoftype = resultSet.stringForColumn(kAOFtype)
                    UserAOFStatus.idS = resultSet.stringForColumn(kIdS)
                    
                    marrStakeInfo.addObject(UserAOFStatus)
                }
            }
            
            sharedInstanceDB.database!.close()
            
            
            if marrStakeInfo.count==0 {
                return false
            }else{
                return true
            }
        }
        
        func checkInvetmentAOFAlreadyExist(UserAOFStatus : AOFStatus) -> Bool {
            
            sharedInstanceDB.database!.open()
            
            let resultSet: FMResultSet! = sharedInstanceDB.database!.executeQuery("SELECT * FROM \(DB_TBL_AOFStatus_MASTER) WHERE \(kClientID)=\(UserAOFStatus.ClientID) AND \(kAOFtype)=1", withArgumentsInArray: nil)
            
            let marrStakeInfo : NSMutableArray = NSMutableArray()
            if (resultSet != nil) {
                while resultSet.next() {
                    let UserAOFStatus : AOFStatus = AOFStatus()
                    
                    UserAOFStatus.ClientID = resultSet.stringForColumn(kClientID)
                    UserAOFStatus.pancopy = resultSet.stringForColumn(kPanCopy)
                    UserAOFStatus.chequecopy = resultSet.stringForColumn(kChequeCopy)
                    UserAOFStatus.selfie = resultSet.stringForColumn(kSelfie)
                    UserAOFStatus.dobmismatch = resultSet.stringForColumn(kDobmismatch)
                    UserAOFStatus.namemismatch = resultSet.stringForColumn(kNameMismatch)
                    UserAOFStatus.signaturemismatch = resultSet.stringForColumn(kSignaturemismatch)
                    UserAOFStatus.banckaccmismatch = resultSet.stringForColumn(kBanckaccmismatch)
                    UserAOFStatus.ifscmismatch = resultSet.stringForColumn(kIFSCmismatch)
                    UserAOFStatus.pannummismatch = resultSet.stringForColumn(kPannummismatch)
                    UserAOFStatus.aoftype = resultSet.stringForColumn(kAOFtype)
                    UserAOFStatus.idS = resultSet.stringForColumn(kIdS)
                    
                    marrStakeInfo.addObject(UserAOFStatus)
                }
            }
            
            sharedInstanceDB.database!.close()
            
            
            if marrStakeInfo.count==0 {
                return false
            }else{
                return true
            }
        }
        
        
        func getSignUpStatusRecord(UserAOFStatus : AOFStatus) -> NSMutableArray {
            
            sharedInstanceDB.database!.open()
            
            let resultSet: FMResultSet! = sharedInstanceDB.database!.executeQuery("SELECT * FROM \(DB_TBL_AOFStatus_MASTER) WHERE \(kClientID)=\(UserAOFStatus.ClientID) AND \(kAOFtype)=0", withArgumentsInArray: nil)
            
            let marrStakeInfo : NSMutableArray = NSMutableArray()
            if (resultSet != nil) {
                while resultSet.next() {
                    let UserAOFStatus : AOFStatus = AOFStatus()
                    
                    UserAOFStatus.ClientID = resultSet.stringForColumn(kClientID)
                    UserAOFStatus.pancopy = resultSet.stringForColumn(kPanCopy)
                    UserAOFStatus.chequecopy = resultSet.stringForColumn(kChequeCopy)
                    UserAOFStatus.selfie = resultSet.stringForColumn(kSelfie)
                    UserAOFStatus.dobmismatch = resultSet.stringForColumn(kDobmismatch)
                    UserAOFStatus.namemismatch = resultSet.stringForColumn(kNameMismatch)
                    UserAOFStatus.signaturemismatch = resultSet.stringForColumn(kSignaturemismatch)
                    UserAOFStatus.banckaccmismatch = resultSet.stringForColumn(kBanckaccmismatch)
                    UserAOFStatus.ifscmismatch = resultSet.stringForColumn(kIFSCmismatch)
                    UserAOFStatus.pannummismatch = resultSet.stringForColumn(kPannummismatch)
                    UserAOFStatus.aoftype = resultSet.stringForColumn(kAOFtype)
                    UserAOFStatus.idS = resultSet.stringForColumn(kIdS)
                    
                    marrStakeInfo.addObject(UserAOFStatus)
                }
            }
            
            sharedInstanceDB.database!.close()
            
            return marrStakeInfo
        }
        
        func getInvetmentAOFRecord(UserAOFStatus : AOFStatus) -> NSMutableArray {
            
            sharedInstanceDB.database!.open()
            
            let resultSet: FMResultSet! = sharedInstanceDB.database!.executeQuery("SELECT * FROM \(DB_TBL_AOFStatus_MASTER) WHERE \(kClientID)=\(UserAOFStatus.ClientID) AND \(kAOFtype)=1", withArgumentsInArray: nil)
            
            let marrStakeInfo : NSMutableArray = NSMutableArray()
            if (resultSet != nil) {
                while resultSet.next() {
                    let UserAOFStatus : AOFStatus = AOFStatus()
                    
                    UserAOFStatus.ClientID = resultSet.stringForColumn(kClientID)
                    UserAOFStatus.pancopy = resultSet.stringForColumn(kPanCopy)
                    UserAOFStatus.chequecopy = resultSet.stringForColumn(kChequeCopy)
                    UserAOFStatus.selfie = resultSet.stringForColumn(kSelfie)
                    UserAOFStatus.dobmismatch = resultSet.stringForColumn(kDobmismatch)
                    UserAOFStatus.namemismatch = resultSet.stringForColumn(kNameMismatch)
                    UserAOFStatus.signaturemismatch = resultSet.stringForColumn(kSignaturemismatch)
                    UserAOFStatus.banckaccmismatch = resultSet.stringForColumn(kBanckaccmismatch)
                    UserAOFStatus.ifscmismatch = resultSet.stringForColumn(kIFSCmismatch)
                    UserAOFStatus.pannummismatch = resultSet.stringForColumn(kPannummismatch)
                    UserAOFStatus.aoftype = resultSet.stringForColumn(kAOFtype)
                    UserAOFStatus.idS = resultSet.stringForColumn(kIdS)
                    
                    marrStakeInfo.addObject(UserAOFStatus)
                }
            }
            
            sharedInstanceDB.database!.close()
            
            return marrStakeInfo
            
        }
        
        
        
        func addOrder(OrderInfo : Order) -> Bool {
            
            sharedInstanceDB.database!.open()
            
            //        OrderInfo.AppOrderID = "1234"
            //        OrderInfo.ServerOrderID = "Default"
            //        OrderInfo.ClientID = "Default"
            //        OrderInfo.FolioNo = "Default"
            //        OrderInfo.FolioCheckDigit = "Default"
            //        OrderInfo.RtaAmcCode = "Default"
            //        OrderInfo.SrcSchemeCode = "Default"
            //        OrderInfo.SrcSchemeName = "Default"
            //        OrderInfo.TarSchemeCode = "Default"
            //        OrderInfo.TarSchemeName = "Default"
            //        OrderInfo.DividendOption = "Default"
            //        OrderInfo.VolumeType = "Default"
            //        OrderInfo.Volume = "Default"
            //        OrderInfo.OrderType = "Default"
            //        OrderInfo.OrderStatus = "Default"
            //        OrderInfo.AppOrderTimeStamp = "Default"
            //        OrderInfo.CartFlag = "Default"
            //        OrderInfo.UpdateTime = "Default"
            
            
            let isInserted = sharedInstanceDB.database?.executeUpdate("INSERT INTO \(DB_TBL_ORDER_MASTER) (\(kServerOrderID), \(kClientID), \(kFolioNo), \(kFolioCheckDigit), \(kRtaAmcCode), \(kSrcSchemeCode), \(kSrcSchemeName), \(kTarSchemeCode), \(kTarSchemeName), \(kDividendOption), \(kVolumeType), \(kVolume), \(kOrderType), \(kOrderStatus), \(kAppOrderTimeStamp), \(kCartFlag), \(kUpdateTime)) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", withArgumentsInArray: [OrderInfo.ServerOrderID,OrderInfo.ClientID,OrderInfo.FolioNo,OrderInfo.FolioCheckDigit,OrderInfo.RtaAmcCode,OrderInfo.SrcSchemeCode,OrderInfo.SrcSchemeName,OrderInfo.TarSchemeCode,OrderInfo.TarSchemeName,OrderInfo.DividendOption,OrderInfo.VolumeType,OrderInfo.Volume,OrderInfo.OrderType,OrderInfo.OrderStatus,OrderInfo.AppOrderTimeStamp,OrderInfo.CartFlag,OrderInfo.UpdateTime])
            
            sharedInstanceDB.database?.close()
            
            return isInserted!
        }
        
        func updateOrder(OrderInfo : Order) -> Bool {
            
            sharedInstanceDB.database!.open()
            
            let isInserted = sharedInstanceDB.database?.executeUpdate("UPDATE \(DB_TBL_ORDER_MASTER) SET \(kServerOrderID)=?, \(kClientID)=?, \(kFolioNo)=?, \(kFolioCheckDigit)=?, \(kRtaAmcCode)=?, \(kSrcSchemeCode)=?, \(kSrcSchemeName)=?, \(kTarSchemeCode)=?, \(kTarSchemeName)=?, \(kDividendOption)=?, \(kVolumeType)=?, \(kVolume)=?, \(kOrderType)=?, \(kOrderStatus)=?, \(kAppOrderTimeStamp)=?, \(kCartFlag)=?, \(kUpdateTime)=? WHERE \(kAppOrderID)=?", withArgumentsInArray: [OrderInfo.ServerOrderID,OrderInfo.ClientID,OrderInfo.FolioNo,OrderInfo.FolioCheckDigit,OrderInfo.RtaAmcCode,OrderInfo.SrcSchemeCode,OrderInfo.SrcSchemeName,OrderInfo.TarSchemeCode,OrderInfo.TarSchemeName,OrderInfo.DividendOption,OrderInfo.VolumeType,OrderInfo.Volume,OrderInfo.OrderType,OrderInfo.OrderStatus,OrderInfo.AppOrderTimeStamp,OrderInfo.CartFlag,OrderInfo.UpdateTime,OrderInfo.AppOrderID])
            
            sharedInstanceDB.database?.close()
            
            return isInserted!
        }
        
        
        func getAllOrder() -> NSMutableArray {
            
            sharedInstanceDB.database!.open()
            
            let resultSet: FMResultSet! = sharedInstanceDB.database!.executeQuery("SELECT * FROM \(DB_TBL_ORDER_MASTER)", withArgumentsInArray: nil)
            
            let marrStakeInfo : NSMutableArray = NSMutableArray()
            if (resultSet != nil) {
                
                while resultSet.next() {
                    
                    let userInfo : Order = Order()
                    
                    userInfo.AppOrderID = resultSet.stringForColumn(kAppOrderID)
                    userInfo.ServerOrderID = resultSet.stringForColumn(kServerOrderID)
                    userInfo.ClientID = resultSet.stringForColumn(kClientID)
                    userInfo.FolioNo = resultSet.stringForColumn(kFolioNo)
                    userInfo.FolioCheckDigit = resultSet.stringForColumn(kFolioCheckDigit)
                    userInfo.RtaAmcCode = resultSet.stringForColumn(kRtaAmcCode)
                    userInfo.SrcSchemeCode = resultSet.stringForColumn(kSrcSchemeCode)
                    userInfo.SrcSchemeName = resultSet.stringForColumn(kSrcSchemeName)
                    userInfo.TarSchemeCode = resultSet.stringForColumn(kTarSchemeCode)
                    userInfo.TarSchemeName = resultSet.stringForColumn(kTarSchemeName)
                    userInfo.DividendOption = resultSet.stringForColumn(kDividendOption)
                    userInfo.VolumeType = resultSet.stringForColumn(kVolumeType)
                    userInfo.Volume = resultSet.stringForColumn(kVolume)
                    userInfo.OrderType = resultSet.stringForColumn(kOrderType)
                    userInfo.OrderStatus = resultSet.stringForColumn(kOrderStatus)
                    userInfo.AppOrderTimeStamp = resultSet.stringForColumn(kAppOrderTimeStamp)
                    userInfo.CartFlag = resultSet.stringForColumn(kCartFlag)
                    userInfo.UpdateTime = resultSet.stringForColumn(kUpdateTime)
                    
                    marrStakeInfo.addObject(userInfo)
                }
            }
            sharedInstanceDB.database!.close()
            
            return marrStakeInfo
        }
        
        func getLatestOrder() -> NSMutableArray {
            
            sharedInstanceDB.database!.open()
            
            //        SELECT * FROM OrderMaster ORDER BY AppOrderID DESC LIMIT 1
            
            let resultSet: FMResultSet! = sharedInstanceDB.database!.executeQuery("SELECT * FROM \(DB_TBL_ORDER_MASTER) ORDER BY AppOrderID DESC LIMIT 1", withArgumentsInArray: nil)
            
            let marrStakeInfo : NSMutableArray = NSMutableArray()
            if (resultSet != nil) {
                
                while resultSet.next() {
                    
                    let userInfo : Order = Order()
                    
                    userInfo.AppOrderID = resultSet.stringForColumn(kAppOrderID)
                    userInfo.ServerOrderID = resultSet.stringForColumn(kServerOrderID)
                    userInfo.ClientID = resultSet.stringForColumn(kClientID)
                    userInfo.FolioNo = resultSet.stringForColumn(kFolioNo)
                    userInfo.FolioCheckDigit = resultSet.stringForColumn(kFolioCheckDigit)
                    userInfo.RtaAmcCode = resultSet.stringForColumn(kRtaAmcCode)
                    userInfo.SrcSchemeCode = resultSet.stringForColumn(kSrcSchemeCode)
                    userInfo.SrcSchemeName = resultSet.stringForColumn(kSrcSchemeName)
                    userInfo.TarSchemeCode = resultSet.stringForColumn(kTarSchemeCode)
                    userInfo.TarSchemeName = resultSet.stringForColumn(kTarSchemeName)
                    userInfo.DividendOption = resultSet.stringForColumn(kDividendOption)
                    userInfo.VolumeType = resultSet.stringForColumn(kVolumeType)
                    userInfo.Volume = resultSet.stringForColumn(kVolume)
                    userInfo.OrderType = resultSet.stringForColumn(kOrderType)
                    userInfo.OrderStatus = resultSet.stringForColumn(kOrderStatus)
                    userInfo.AppOrderTimeStamp = resultSet.stringForColumn(kAppOrderTimeStamp)
                    userInfo.CartFlag = resultSet.stringForColumn(kCartFlag)
                    userInfo.UpdateTime = resultSet.stringForColumn(kUpdateTime)
                    
                    marrStakeInfo.addObject(userInfo)
                }
            }
            sharedInstanceDB.database!.close()
            
            return marrStakeInfo
        }
        
        
        func checkOrderAlreadyExist(OrderInfo : Order) -> Bool {
            
            sharedInstanceDB.database!.open()
            
            let resultSet: FMResultSet! = sharedInstanceDB.database!.executeQuery("SELECT * FROM \(DB_TBL_ORDER_MASTER) WHERE \(kServerOrderID)='\(OrderInfo.ServerOrderID)'", withArgumentsInArray: nil)
            
            let marrStakeInfo : NSMutableArray = NSMutableArray()
            if (resultSet != nil) {
                while resultSet.next() {
                    
                    let userInfo : Order = Order()
                    
                    userInfo.AppOrderID = resultSet.stringForColumn(kAppOrderID)
                    userInfo.ServerOrderID = resultSet.stringForColumn(kServerOrderID)
                    
                    marrStakeInfo.addObject(userInfo)
                    
                }
            }
            
            sharedInstanceDB.database!.close()
            
            if marrStakeInfo.count==0 {
                return false
            }else{
                return true
            }
        }
        
        
        
        
        
        
        //MF_ACCOUNT
        
        func addMFAccount(mfAccountInfo : MFAccount) -> Bool {
            
            sharedInstanceDB.database!.open()
            
            let isInserted = sharedInstanceDB.database?.executeUpdate("INSERT INTO \(DB_TBL_MF_ACCOUNT) (\(kAccId), \(kclientid), \(kFolioNo), \(kRTAamcCode), \(kAmcName), \(kSchemeCode), \(kSchemeName), \(kDivOption), \(kpucharseUnits), \(kpuchaseNAV), \(kInvestmentAmount), \(kCurrentNAV), \(kNAVDate), \(kisDeleted)) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", withArgumentsInArray: [mfAccountInfo.AccId,mfAccountInfo.clientid,mfAccountInfo.FolioNo,mfAccountInfo.RTAamcCode,mfAccountInfo.AmcName,mfAccountInfo.SchemeCode,mfAccountInfo.SchemeName,mfAccountInfo.DivOption,mfAccountInfo.pucharseUnits,mfAccountInfo.puchaseNAV,mfAccountInfo.InvestmentAmount,mfAccountInfo.CurrentNAV,mfAccountInfo.NAVDate,mfAccountInfo.isDeleted])
            
            sharedInstanceDB.database?.close()
            
            return isInserted!
        }
        
        func updateMFAccount(mfAccountInfo : MFAccount) -> Bool {
            
            sharedInstanceDB.database!.open()
            
            let isInserted = sharedInstanceDB.database?.executeUpdate("UPDATE \(DB_TBL_MF_ACCOUNT) SET \(kclientid)=?, \(kFolioNo)=?, \(kRTAamcCode)=?, \(kAmcName)=?, \(kSchemeCode)=?, \(kSchemeName)=?, \(kDivOption)=?, \(kpucharseUnits)=?, \(kpuchaseNAV)=?, \(kInvestmentAmount)=?, \(kCurrentNAV)=?, \(kNAVDate)=?, \(kisDeleted)=? WHERE \(kAccId)=?", withArgumentsInArray: [mfAccountInfo.clientid,mfAccountInfo.FolioNo,mfAccountInfo.RTAamcCode,mfAccountInfo.AmcName,mfAccountInfo.SchemeCode,mfAccountInfo.SchemeName,mfAccountInfo.DivOption,mfAccountInfo.pucharseUnits,mfAccountInfo.puchaseNAV,mfAccountInfo.InvestmentAmount,mfAccountInfo.CurrentNAV,mfAccountInfo.NAVDate,mfAccountInfo.isDeleted,mfAccountInfo.AccId])
            
            sharedInstanceDB.database?.close()
            
            return isInserted!
        }
        
        
        func getMFAccounts() -> NSMutableArray {
            
            sharedInstanceDB.database!.open()
            
            let resultSet: FMResultSet! = sharedInstanceDB.database!.executeQuery("SELECT * FROM \(DB_TBL_MF_ACCOUNT) WHERE pucharseUnits<>0 AND isDeleted=0", withArgumentsInArray: nil)
            
            let marrStakeInfo : NSMutableArray = NSMutableArray()
            if (resultSet != nil) {
                
                while resultSet.next() {
                    
                    let mfAccountInfo : MFAccount = MFAccount()
                    
                    mfAccountInfo.AccId = resultSet.stringForColumn(kAccId)
                    mfAccountInfo.clientid = resultSet.stringForColumn(kclientid)
                    mfAccountInfo.FolioNo = resultSet.stringForColumn(kFolioNo)
                    mfAccountInfo.RTAamcCode = resultSet.stringForColumn(kRTAamcCode)
                    mfAccountInfo.AmcName = resultSet.stringForColumn(kAmcName)
                    mfAccountInfo.SchemeCode = resultSet.stringForColumn(kSchemeCode)
                    mfAccountInfo.SchemeName = resultSet.stringForColumn(kSchemeName)
                    mfAccountInfo.DivOption = resultSet.stringForColumn(kDivOption)
                    mfAccountInfo.pucharseUnits = resultSet.stringForColumn(kpucharseUnits)
                    mfAccountInfo.puchaseNAV = resultSet.stringForColumn(kpuchaseNAV)
                    mfAccountInfo.InvestmentAmount = resultSet.stringForColumn(kInvestmentAmount)
                    mfAccountInfo.CurrentNAV = resultSet.stringForColumn(kCurrentNAV)
                    mfAccountInfo.NAVDate = resultSet.stringForColumn(kNAVDate)
                    mfAccountInfo.isDeleted = resultSet.stringForColumn(kisDeleted)
                    
                    marrStakeInfo.addObject(mfAccountInfo)
                }
            }
            sharedInstanceDB.database!.close()
            
            return marrStakeInfo
        }
        
        func getMFAccountsForRedeemCondition() -> NSMutableArray {
            
            sharedInstanceDB.database!.open()
            
            let resultSet: FMResultSet! = sharedInstanceDB.database!.executeQuery("SELECT * FROM \(DB_TBL_MF_ACCOUNT) WHERE pucharseUnits<>0 AND isDeleted=0", withArgumentsInArray: nil)
            
            let marrStakeInfo : NSMutableArray = NSMutableArray()
            if (resultSet != nil) {
                
                while resultSet.next() {
                    
                    let mfAccountInfo : MFAccount = MFAccount()
                    
                    mfAccountInfo.AccId = resultSet.stringForColumn(kAccId)
                    mfAccountInfo.clientid = resultSet.stringForColumn(kclientid)
                    mfAccountInfo.FolioNo = resultSet.stringForColumn(kFolioNo)
                    mfAccountInfo.RTAamcCode = resultSet.stringForColumn(kRTAamcCode)
                    mfAccountInfo.AmcName = resultSet.stringForColumn(kAmcName)
                    mfAccountInfo.SchemeCode = resultSet.stringForColumn(kSchemeCode)
                    mfAccountInfo.SchemeName = resultSet.stringForColumn(kSchemeName)
                    mfAccountInfo.DivOption = resultSet.stringForColumn(kDivOption)
                    mfAccountInfo.pucharseUnits = resultSet.stringForColumn(kpucharseUnits)
                    mfAccountInfo.puchaseNAV = resultSet.stringForColumn(kpuchaseNAV)
                    mfAccountInfo.InvestmentAmount = resultSet.stringForColumn(kInvestmentAmount)
                    mfAccountInfo.CurrentNAV = resultSet.stringForColumn(kCurrentNAV)
                    mfAccountInfo.NAVDate = resultSet.stringForColumn(kNAVDate)
                    mfAccountInfo.isDeleted = resultSet.stringForColumn(kisDeleted)
                    
                    marrStakeInfo.addObject(mfAccountInfo)
                }
            }
            sharedInstanceDB.database!.close()
            
            return marrStakeInfo
        }
        
        
        func checkMFAccountAlreadyExist(mfAccountInfo : MFAccount) -> Bool {
            
            sharedInstanceDB.database!.open()
            
            let resultSet: FMResultSet! = sharedInstanceDB.database!.executeQuery("SELECT * FROM \(DB_TBL_MF_ACCOUNT) WHERE \(kAccId)=\(mfAccountInfo.AccId)", withArgumentsInArray: nil)
            
            let marrStakeInfo : NSMutableArray = NSMutableArray()
            if (resultSet != nil) {
                while resultSet.next() {
                    
                    let mfAccountInfo : MFAccount = MFAccount()
                    
                    mfAccountInfo.AccId = resultSet.stringForColumn(kAccId)
                    mfAccountInfo.clientid = resultSet.stringForColumn(kclientid)
                    mfAccountInfo.FolioNo = resultSet.stringForColumn(kFolioNo)
                    mfAccountInfo.RTAamcCode = resultSet.stringForColumn(kRTAamcCode)
                    mfAccountInfo.AmcName = resultSet.stringForColumn(kAmcName)
                    mfAccountInfo.SchemeCode = resultSet.stringForColumn(kSchemeCode)
                    mfAccountInfo.SchemeName = resultSet.stringForColumn(kSchemeName)
                    mfAccountInfo.DivOption = resultSet.stringForColumn(kDivOption)
                    mfAccountInfo.pucharseUnits = resultSet.stringForColumn(kpucharseUnits)
                    mfAccountInfo.puchaseNAV = resultSet.stringForColumn(kpuchaseNAV)
                    mfAccountInfo.InvestmentAmount = resultSet.stringForColumn(kInvestmentAmount)
                    mfAccountInfo.CurrentNAV = resultSet.stringForColumn(kCurrentNAV)
                    mfAccountInfo.NAVDate = resultSet.stringForColumn(kNAVDate)
                    mfAccountInfo.isDeleted = resultSet.stringForColumn(kisDeleted)
                    
                    marrStakeInfo.addObject(mfAccountInfo)
                    
                }
            }
            
            sharedInstanceDB.database!.close()
            
            
            if marrStakeInfo.count==0 {
                return false
            }else{
                return true
            }
        }
        
        //    func checkMFAccountAlreadyExistForSchemeCode(schemCode : String) -> Bool
        //    {
        //
        //        sharedInstanceDB.database!.open()
        //
        //        let resultSet: FMResultSet! = sharedInstanceDB.database!.executeQuery("SELECT * FROM \(DB_TBL_MF_ACCOUNT) WHERE \(kSchemeCode)=\(schemCode)", withArgumentsInArray: nil)
        //
        //        let marrStakeInfo : NSMutableArray = NSMutableArray()
        //        if (resultSet != nil) {
        //            while resultSet.next() {
        //
        //                let mfAccountInfo : MFAccount = MFAccount()
        //
        //                mfAccountInfo.AccId = resultSet.stringForColumn(kAccId)
        //                mfAccountInfo.clientid = resultSet.stringForColumn(kclientid)
        //                mfAccountInfo.FolioNo = resultSet.stringForColumn(kFolioNo)
        //                mfAccountInfo.RTAamcCode = resultSet.stringForColumn(kRTAamcCode)
        //                mfAccountInfo.AmcName = resultSet.stringForColumn(kAmcName)
        //                mfAccountInfo.SchemeCode = resultSet.stringForColumn(kSchemeCode)
        //                mfAccountInfo.SchemeName = resultSet.stringForColumn(kSchemeName)
        //                mfAccountInfo.DivOption = resultSet.stringForColumn(kDivOption)
        //                mfAccountInfo.pucharseUnits = resultSet.stringForColumn(kpucharseUnits)
        //                mfAccountInfo.puchaseNAV = resultSet.stringForColumn(kpuchaseNAV)
        //                mfAccountInfo.InvestmentAmount = resultSet.stringForColumn(kInvestmentAmount)
        //                mfAccountInfo.CurrentNAV = resultSet.stringForColumn(kCurrentNAV)
        //                mfAccountInfo.NAVDate = resultSet.stringForColumn(kNAVDate)
        //                mfAccountInfo.isDeleted = resultSet.stringForColumn(kisDeleted)
        //
        //                marrStakeInfo.addObject(mfAccountInfo)
        //            }
        //        }
        //
        //        sharedInstanceDB.database!.close()
        //
        //
        //        if marrStakeInfo.count==0 {
        //            return false
        //        }else{
        //            return true
        //        }
        //    }
        
        func checkMFAccountAlreadyExistForSchemeCode(schemCode : String, fundCode : String, ClientId : String) -> Bool
        {
            
            sharedInstanceDB.database!.open()
            
            let resultSet: FMResultSet! = sharedInstanceDB.database!.executeQuery("SELECT * FROM \(DB_TBL_MF_ACCOUNT) WHERE \(kSchemeCode)=\(schemCode) AND \(kRTAamcCode)=\(fundCode) AND \(kclientid)=\(ClientId)", withArgumentsInArray: nil)
            
            let marrStakeInfo : NSMutableArray = NSMutableArray()
            if (resultSet != nil) {
                while resultSet.next() {
                    
                    let mfAccountInfo : MFAccount = MFAccount()
                    
                    mfAccountInfo.AccId = resultSet.stringForColumn(kAccId)
                    mfAccountInfo.clientid = resultSet.stringForColumn(kclientid)
                    mfAccountInfo.FolioNo = resultSet.stringForColumn(kFolioNo)
                    mfAccountInfo.RTAamcCode = resultSet.stringForColumn(kRTAamcCode)
                    mfAccountInfo.AmcName = resultSet.stringForColumn(kAmcName)
                    mfAccountInfo.SchemeCode = resultSet.stringForColumn(kSchemeCode)
                    mfAccountInfo.SchemeName = resultSet.stringForColumn(kSchemeName)
                    mfAccountInfo.DivOption = resultSet.stringForColumn(kDivOption)
                    mfAccountInfo.pucharseUnits = resultSet.stringForColumn(kpucharseUnits)
                    mfAccountInfo.puchaseNAV = resultSet.stringForColumn(kpuchaseNAV)
                    mfAccountInfo.InvestmentAmount = resultSet.stringForColumn(kInvestmentAmount)
                    mfAccountInfo.CurrentNAV = resultSet.stringForColumn(kCurrentNAV)
                    mfAccountInfo.NAVDate = resultSet.stringForColumn(kNAVDate)
                    mfAccountInfo.isDeleted = resultSet.stringForColumn(kisDeleted)
                    
                    marrStakeInfo.addObject(mfAccountInfo)
                }
            }
            
            sharedInstanceDB.database!.close()
            
            
            if marrStakeInfo.count==0 {
                return false
            }else{
                return true
            }
        }
        
        func getMFAccountDetailsFromAccID(mfAccountInfo : MFAccount) -> MFAccount {
            
            sharedInstanceDB.database!.open()
            
            let resultSet: FMResultSet! = sharedInstanceDB.database!.executeQuery("SELECT * FROM \(DB_TBL_MF_ACCOUNT) WHERE \(kAccId)=\(mfAccountInfo.AccId)", withArgumentsInArray: nil)
            
            let marrStakeInfo : NSMutableArray = NSMutableArray()
            if (resultSet != nil) {
                while resultSet.next() {
                    
                    let mfAccountInfo : MFAccount = MFAccount()
                    
                    mfAccountInfo.AccId = resultSet.stringForColumn(kAccId)
                    mfAccountInfo.clientid = resultSet.stringForColumn(kclientid)
                    mfAccountInfo.FolioNo = resultSet.stringForColumn(kFolioNo)
                    mfAccountInfo.RTAamcCode = resultSet.stringForColumn(kRTAamcCode)
                    mfAccountInfo.AmcName = resultSet.stringForColumn(kAmcName)
                    mfAccountInfo.SchemeCode = resultSet.stringForColumn(kSchemeCode)
                    mfAccountInfo.SchemeName = resultSet.stringForColumn(kSchemeName)
                    mfAccountInfo.DivOption = resultSet.stringForColumn(kDivOption)
                    mfAccountInfo.pucharseUnits = resultSet.stringForColumn(kpucharseUnits)
                    mfAccountInfo.puchaseNAV = resultSet.stringForColumn(kpuchaseNAV)
                    mfAccountInfo.InvestmentAmount = resultSet.stringForColumn(kInvestmentAmount)
                    mfAccountInfo.CurrentNAV = resultSet.stringForColumn(kCurrentNAV)
                    mfAccountInfo.NAVDate = resultSet.stringForColumn(kNAVDate)
                    mfAccountInfo.isDeleted = resultSet.stringForColumn(kisDeleted)
                    
                    marrStakeInfo.addObject(mfAccountInfo)
                    
                }
            }
            
            sharedInstanceDB.database!.close()
            
            if marrStakeInfo.count==0 {
                return MFAccount()
            }else{
                return marrStakeInfo.objectAtIndex(0) as! MFAccount
            }
        }
        
        
        //MF_TRANSACTIONS
        
        func addMFTransaction(mfAccountInfo : MFTransaction) -> Bool {
            
            sharedInstanceDB.database!.open()
            
            let isInserted = sharedInstanceDB.database?.executeUpdate("INSERT INTO \(DB_TBL_MF_TRANSACTION) (\(kTxnID), \(kAccID), \(kOrderId), \(kTxnOrderDateTime), \(kTxtType), \(kTxnpucharseUnits), \(kTxnpuchaseNAV), \(kTxnPurchaseAmount), \(kExecutaionDateTime), \(kisDeleted)) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", withArgumentsInArray: [mfAccountInfo.TxnID,mfAccountInfo.AccID,mfAccountInfo.OrderId,mfAccountInfo.TxnOrderDateTime,mfAccountInfo.TxtType,mfAccountInfo.TxnpucharseUnits,mfAccountInfo.TxnpuchaseNAV,mfAccountInfo.TxnPurchaseAmount,mfAccountInfo.ExecutaionDateTime,mfAccountInfo.isDeleted])
            
            sharedInstanceDB.database?.close()
            
            return isInserted!
        }
        
        func updateMFTransaction(mfAccountInfo : MFTransaction) -> Bool {
            
            sharedInstanceDB.database!.open()
            
            let isInserted = sharedInstanceDB.database?.executeUpdate("UPDATE \(DB_TBL_MF_TRANSACTION) SET \(kAccID)=?, \(kOrderId)=?, \(kTxnOrderDateTime)=?, \(kTxtType)=?, \(kTxnpucharseUnits)=?, \(kTxnpuchaseNAV)=?, \(kTxnPurchaseAmount)=?, \(kExecutaionDateTime)=?, \(kisDeleted)=? WHERE \(kTxnID)=?", withArgumentsInArray: [mfAccountInfo.AccID,mfAccountInfo.OrderId,mfAccountInfo.TxnOrderDateTime,mfAccountInfo.TxtType,mfAccountInfo.TxnpucharseUnits,mfAccountInfo.TxnpuchaseNAV,mfAccountInfo.TxnPurchaseAmount,mfAccountInfo.ExecutaionDateTime,mfAccountInfo.isDeleted,mfAccountInfo.TxnID])
            
            sharedInstanceDB.database?.close()
            
            return isInserted!
        }
        
        
        func getMFTransactions() -> NSMutableArray {
            
            sharedInstanceDB.database!.open()
            
            let resultSet: FMResultSet! = sharedInstanceDB.database!.executeQuery("SELECT * FROM \(DB_TBL_MF_TRANSACTION) WHERE isDeleted=0", withArgumentsInArray: nil)
            
            let marrStakeInfo : NSMutableArray = NSMutableArray()
            if (resultSet != nil) {
                
                while resultSet.next() {
                    
                    let mfAccountInfo : MFTransaction = MFTransaction()
                    
                    mfAccountInfo.TxnID = resultSet.stringForColumn(kTxnID)
                    mfAccountInfo.AccID = resultSet.stringForColumn(kAccID)
                    mfAccountInfo.OrderId = resultSet.stringForColumn(kOrderId)
                    mfAccountInfo.TxnOrderDateTime = resultSet.stringForColumn(kTxnOrderDateTime)
                    mfAccountInfo.TxtType = resultSet.stringForColumn(kTxtType)
                    mfAccountInfo.TxnpucharseUnits = resultSet.stringForColumn(kTxnpucharseUnits)
                    mfAccountInfo.TxnpuchaseNAV = resultSet.stringForColumn(kTxnpuchaseNAV)
                    mfAccountInfo.TxnPurchaseAmount = resultSet.stringForColumn(kTxnPurchaseAmount)
                    mfAccountInfo.ExecutaionDateTime = resultSet.stringForColumn(kExecutaionDateTime)
                    mfAccountInfo.isDeleted = resultSet.stringForColumn(kisDeleted)
                    
                    marrStakeInfo.addObject(mfAccountInfo)
                }
            }
            sharedInstanceDB.database!.close()
            
            return marrStakeInfo
        }
        
        func getMFTransactionsGroupByDate(mfAccountInfo : MFAccount) -> NSMutableArray {
            
            sharedInstanceDB.database!.open()
            
            let resultSet: FMResultSet! = sharedInstanceDB.database!.executeQuery("SELECT * FROM \(DB_TBL_MF_TRANSACTION) WHERE isDeleted=0 AND \(kAccID)=\(mfAccountInfo.AccId) GROUP BY \(kExecutaionDateTime)", withArgumentsInArray: nil)
            
            let marrStakeInfo : NSMutableArray = NSMutableArray()
            if (resultSet != nil) {
                
                while resultSet.next() {
                    
                    let mfAccountInfo : MFTransaction = MFTransaction()
                    
                    mfAccountInfo.TxnID = resultSet.stringForColumn(kTxnID)
                    mfAccountInfo.AccID = resultSet.stringForColumn(kAccID)
                    mfAccountInfo.OrderId = resultSet.stringForColumn(kOrderId)
                    mfAccountInfo.TxnOrderDateTime = resultSet.stringForColumn(kTxnOrderDateTime)
                    mfAccountInfo.TxtType = resultSet.stringForColumn(kTxtType)
                    mfAccountInfo.TxnpucharseUnits = resultSet.stringForColumn(kTxnpucharseUnits)
                    mfAccountInfo.TxnpuchaseNAV = resultSet.stringForColumn(kTxnpuchaseNAV)
                    mfAccountInfo.TxnPurchaseAmount = resultSet.stringForColumn(kTxnPurchaseAmount)
                    mfAccountInfo.ExecutaionDateTime = resultSet.stringForColumn(kExecutaionDateTime)
                    mfAccountInfo.isDeleted = resultSet.stringForColumn(kisDeleted)
                    
                    marrStakeInfo.addObject(mfAccountInfo)
                }
            }
            sharedInstanceDB.database!.close()
            
            return marrStakeInfo
        }
        
        func getMFUTransactionsByAccountIDAndAfterDate(accId : String, date : String) -> NSMutableArray {
            
            sharedInstanceDB.database!.open()
            
            let resultSet: FMResultSet! = sharedInstanceDB.database!.executeQuery("SELECT * FROM \(DB_TBL_MF_TRANSACTION) WHERE \(kAccID)=? AND \(kExecutaionDateTime)>? AND \(kisDeleted)=0 ORDER BY \(kExecutaionDateTime)", withArgumentsInArray: [accId, date])
            
            let marrStakeInfo : NSMutableArray = NSMutableArray()
            if (resultSet != nil) {
                
                while resultSet.next() {
                    
                    let mfAccountInfo : MFTransaction = MFTransaction()
                    
                    mfAccountInfo.TxnID = resultSet.stringForColumn(kTxnID)
                    mfAccountInfo.AccID = resultSet.stringForColumn(kAccID)
                    mfAccountInfo.OrderId = resultSet.stringForColumn(kOrderId)
                    mfAccountInfo.TxnOrderDateTime = resultSet.stringForColumn(kTxnOrderDateTime)
                    mfAccountInfo.TxtType = resultSet.stringForColumn(kTxtType)
                    mfAccountInfo.TxnpucharseUnits = resultSet.stringForColumn(kTxnpucharseUnits)
                    mfAccountInfo.TxnpuchaseNAV = resultSet.stringForColumn(kTxnpuchaseNAV)
                    mfAccountInfo.TxnPurchaseAmount = resultSet.stringForColumn(kTxnPurchaseAmount)
                    mfAccountInfo.ExecutaionDateTime = resultSet.stringForColumn(kExecutaionDateTime)
                    mfAccountInfo.isDeleted = resultSet.stringForColumn(kisDeleted)
                    
                    marrStakeInfo.addObject(mfAccountInfo)
                }
            }
            sharedInstanceDB.database!.close()
            
            return marrStakeInfo
        }
        
        
        func getMFUTransactionsByAccountID(accId : String) -> NSMutableArray {
            
            sharedInstanceDB.database!.open()
            
            let resultSet: FMResultSet! = sharedInstanceDB.database!.executeQuery("SELECT * FROM \(DB_TBL_MF_TRANSACTION) WHERE \(kAccID)=? AND \(kisDeleted)=0 ORDER BY \(kExecutaionDateTime)", withArgumentsInArray: [accId])
            
            let marrStakeInfo : NSMutableArray = NSMutableArray()
            if (resultSet != nil) {
                
                while resultSet.next() {
                    
                    let mfAccountInfo : MFTransaction = MFTransaction()
                    
                    mfAccountInfo.TxnID = resultSet.stringForColumn(kTxnID)
                    mfAccountInfo.AccID = resultSet.stringForColumn(kAccID)
                    mfAccountInfo.OrderId = resultSet.stringForColumn(kOrderId)
                    mfAccountInfo.TxnOrderDateTime = resultSet.stringForColumn(kTxnOrderDateTime)
                    mfAccountInfo.TxtType = resultSet.stringForColumn(kTxtType)
                    mfAccountInfo.TxnpucharseUnits = resultSet.stringForColumn(kTxnpucharseUnits)
                    mfAccountInfo.TxnpuchaseNAV = resultSet.stringForColumn(kTxnpuchaseNAV)
                    mfAccountInfo.TxnPurchaseAmount = resultSet.stringForColumn(kTxnPurchaseAmount)
                    mfAccountInfo.ExecutaionDateTime = resultSet.stringForColumn(kExecutaionDateTime)
                    mfAccountInfo.isDeleted = resultSet.stringForColumn(kisDeleted)
                    
                    marrStakeInfo.addObject(mfAccountInfo)
                }
            }
            sharedInstanceDB.database!.close()
            
            return marrStakeInfo
        }
        
        func getManualMFUTransactionsByAccountID(accId : String) -> NSMutableArray {
            
            sharedInstanceDB.database!.open()
            
            let resultSet: FMResultSet! = sharedInstanceDB.database!.executeQuery("SELECT * FROM \(DB_TBL_MANUAL_MF_TRANSACTION) WHERE \(kAccID)=? AND \(kisDeleted)=0 ORDER BY \(kExecutaionDateTime)", withArgumentsInArray: [accId])
            
            let marrStakeInfo : NSMutableArray = NSMutableArray()
            if (resultSet != nil) {
                
                while resultSet.next() {
                    
                    let mfAccountInfo : MFTransaction = MFTransaction()
                    
                    mfAccountInfo.TxnID = resultSet.stringForColumn(kTxnID)
                    mfAccountInfo.AccID = resultSet.stringForColumn(kAccID)
                    mfAccountInfo.OrderId = resultSet.stringForColumn(kOrderId)
                    mfAccountInfo.TxnOrderDateTime = resultSet.stringForColumn(kTxnOrderDateTime)
                    mfAccountInfo.TxtType = resultSet.stringForColumn(kTxtType)
                    mfAccountInfo.TxnpucharseUnits = resultSet.stringForColumn(kTxnpucharseUnits)
                    mfAccountInfo.TxnpuchaseNAV = resultSet.stringForColumn(kTxnpuchaseNAV)
                    mfAccountInfo.TxnPurchaseAmount = resultSet.stringForColumn(kTxnPurchaseAmount)
                    mfAccountInfo.ExecutaionDateTime = resultSet.stringForColumn(kExecutaionDateTime)
                    mfAccountInfo.isDeleted = resultSet.stringForColumn(kisDeleted)
                    
                    marrStakeInfo.addObject(mfAccountInfo)
                }
            }
            sharedInstanceDB.database!.close()
            
            return marrStakeInfo
        }
        
        func getMFTransactionsByDate(date : String, mfAccountInfo : MFAccount) -> NSMutableArray {
            
            sharedInstanceDB.database!.open()
            
            let resultSet: FMResultSet! = sharedInstanceDB.database!.executeQuery("SELECT * FROM \(DB_TBL_MF_TRANSACTION) WHERE isDeleted=0 AND \(kAccID)=\(mfAccountInfo.AccId) AND \(kExecutaionDateTime)='\(date)'", withArgumentsInArray: nil)
            
            let marrStakeInfo : NSMutableArray = NSMutableArray()
            if (resultSet != nil) {
                
                while resultSet.next() {
                    
                    let mfAccountInfo : MFTransaction = MFTransaction()
                    
                    mfAccountInfo.TxnID = resultSet.stringForColumn(kTxnID)
                    mfAccountInfo.AccID = resultSet.stringForColumn(kAccID)
                    mfAccountInfo.OrderId = resultSet.stringForColumn(kOrderId)
                    mfAccountInfo.TxnOrderDateTime = resultSet.stringForColumn(kTxnOrderDateTime)
                    mfAccountInfo.TxtType = resultSet.stringForColumn(kTxtType)
                    mfAccountInfo.TxnpucharseUnits = resultSet.stringForColumn(kTxnpucharseUnits)
                    mfAccountInfo.TxnpuchaseNAV = resultSet.stringForColumn(kTxnpuchaseNAV)
                    mfAccountInfo.TxnPurchaseAmount = resultSet.stringForColumn(kTxnPurchaseAmount)
                    mfAccountInfo.ExecutaionDateTime = resultSet.stringForColumn(kExecutaionDateTime)
                    mfAccountInfo.isDeleted = resultSet.stringForColumn(kisDeleted)
                    
                    marrStakeInfo.addObject(mfAccountInfo)
                }
            }
            sharedInstanceDB.database!.close()
            
            return marrStakeInfo
        }
        
        func getMFTransactionsByServerOrderId(ordeRId : String) -> NSMutableArray {
            
            sharedInstanceDB.database!.open()
            
            let resultSet: FMResultSet! = sharedInstanceDB.database!.executeQuery("SELECT * FROM \(DB_TBL_MF_TRANSACTION) WHERE \(kOrderId)='\(ordeRId)'", withArgumentsInArray: nil)
            
            let marrStakeInfo : NSMutableArray = NSMutableArray()
            if (resultSet != nil) {
                
                while resultSet.next() {
                    
                    let mfAccountInfo : MFTransaction = MFTransaction()
                    
                    mfAccountInfo.TxnID = resultSet.stringForColumn(kTxnID)
                    mfAccountInfo.AccID = resultSet.stringForColumn(kAccID)
                    mfAccountInfo.OrderId = resultSet.stringForColumn(kOrderId)
                    mfAccountInfo.TxnOrderDateTime = resultSet.stringForColumn(kTxnOrderDateTime)
                    mfAccountInfo.TxtType = resultSet.stringForColumn(kTxtType)
                    mfAccountInfo.TxnpucharseUnits = resultSet.stringForColumn(kTxnpucharseUnits)
                    mfAccountInfo.TxnpuchaseNAV = resultSet.stringForColumn(kTxnpuchaseNAV)
                    mfAccountInfo.TxnPurchaseAmount = resultSet.stringForColumn(kTxnPurchaseAmount)
                    mfAccountInfo.ExecutaionDateTime = resultSet.stringForColumn(kExecutaionDateTime)
                    mfAccountInfo.isDeleted = resultSet.stringForColumn(kisDeleted)
                    
                    marrStakeInfo.addObject(mfAccountInfo)
                }
            }
            sharedInstanceDB.database!.close()
            
            return marrStakeInfo
        }
        
        func checkMFTransactionAlreadyExist(mfAccountInfo : MFTransaction) -> Bool {
            
            sharedInstanceDB.database!.open()
            
            let resultSet: FMResultSet! = sharedInstanceDB.database!.executeQuery("SELECT * FROM \(DB_TBL_MF_TRANSACTION) WHERE \(kTxnID)=\(mfAccountInfo.TxnID)", withArgumentsInArray: nil)
            
            let marrStakeInfo : NSMutableArray = NSMutableArray()
            if (resultSet != nil) {
                while resultSet.next() {
                    
                    let mfAccountInfo : MFTransaction = MFTransaction()
                    
                    mfAccountInfo.TxnID = resultSet.stringForColumn(kTxnID)
                    mfAccountInfo.AccID = resultSet.stringForColumn(kAccID)
                    mfAccountInfo.OrderId = resultSet.stringForColumn(kOrderId)
                    mfAccountInfo.TxnOrderDateTime = resultSet.stringForColumn(kTxnOrderDateTime)
                    mfAccountInfo.TxtType = resultSet.stringForColumn(kTxtType)
                    mfAccountInfo.TxnpucharseUnits = resultSet.stringForColumn(kTxnpucharseUnits)
                    mfAccountInfo.TxnpuchaseNAV = resultSet.stringForColumn(kTxnpuchaseNAV)
                    mfAccountInfo.TxnPurchaseAmount = resultSet.stringForColumn(kTxnPurchaseAmount)
                    mfAccountInfo.ExecutaionDateTime = resultSet.stringForColumn(kExecutaionDateTime)
                    mfAccountInfo.isDeleted = resultSet.stringForColumn(kisDeleted)
                    
                    marrStakeInfo.addObject(mfAccountInfo)
                    
                }
            }
            
            sharedInstanceDB.database!.close()
            
            if marrStakeInfo.count==0 {
                return false
            }else{
                return true
            }
        }
        
        
        
        
        
        // Manual MF Account
        
        //MF_ACCOUNT
        
        func addManualMFAccount(mfAccountInfo : MFAccount) -> Bool {
            
            sharedInstanceDB.database!.open()
            
            let isInserted = sharedInstanceDB.database?.executeUpdate("INSERT INTO \(DB_TBL_MANUAL_MF_ACCOUNT) (\(kAccId), \(kclientid), \(kFolioNo), \(kRTAamcCode), \(kAmcName), \(kSchemeCode), \(kSchemeName), \(kDivOption), \(kpucharseUnits), \(kpuchaseNAV), \(kInvestmentAmount), \(kCurrentNAV), \(kNAVDate), \(kisDeleted)) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", withArgumentsInArray: [mfAccountInfo.AccId,mfAccountInfo.clientid,mfAccountInfo.FolioNo,mfAccountInfo.RTAamcCode,mfAccountInfo.AmcName,mfAccountInfo.SchemeCode,mfAccountInfo.SchemeName,mfAccountInfo.DivOption,mfAccountInfo.pucharseUnits,mfAccountInfo.puchaseNAV,mfAccountInfo.InvestmentAmount,mfAccountInfo.CurrentNAV,mfAccountInfo.NAVDate,mfAccountInfo.isDeleted])
            
            sharedInstanceDB.database?.close()
            
            return isInserted!
        }
        
        func updateManualMFAccount(mfAccountInfo : MFAccount) -> Bool {
            
            sharedInstanceDB.database!.open()
            
            let isInserted = sharedInstanceDB.database?.executeUpdate("UPDATE \(DB_TBL_MANUAL_MF_ACCOUNT) SET \(kclientid)=?, \(kFolioNo)=?, \(kRTAamcCode)=?, \(kAmcName)=?, \(kSchemeCode)=?, \(kSchemeName)=?, \(kDivOption)=?, \(kpucharseUnits)=?, \(kpuchaseNAV)=?, \(kInvestmentAmount)=?, \(kCurrentNAV)=?, \(kNAVDate)=?, \(kisDeleted)=? WHERE \(kAccId)=?", withArgumentsInArray: [mfAccountInfo.clientid,mfAccountInfo.FolioNo,mfAccountInfo.RTAamcCode,mfAccountInfo.AmcName,mfAccountInfo.SchemeCode,mfAccountInfo.SchemeName,mfAccountInfo.DivOption,mfAccountInfo.pucharseUnits,mfAccountInfo.puchaseNAV,mfAccountInfo.InvestmentAmount,mfAccountInfo.CurrentNAV,mfAccountInfo.NAVDate,mfAccountInfo.isDeleted,mfAccountInfo.AccId])
            
            sharedInstanceDB.database?.close()
            
            return isInserted!
        }
        
        func deleteManualMFAccount(mfAccountInfo : MFAccount) -> Bool {
            
            sharedInstanceDB.database!.open()
            
            let isInserted = sharedInstanceDB.database?.executeUpdate("UPDATE \(DB_TBL_MANUAL_MF_ACCOUNT) SET \(kisDeleted)=1 WHERE \(kAccId)=?", withArgumentsInArray: [mfAccountInfo.AccId])
            
            sharedInstanceDB.database?.close()
            
            return isInserted!
        }
        
        
        func getManualMFAccounts() -> NSMutableArray {
            
            sharedInstanceDB.database!.open()
            
            let resultSet: FMResultSet! = sharedInstanceDB.database!.executeQuery("SELECT * FROM \(DB_TBL_MANUAL_MF_ACCOUNT) WHERE pucharseUnits<>0 AND isDeleted=0", withArgumentsInArray: nil)
            
            let marrStakeInfo : NSMutableArray = NSMutableArray()
            if (resultSet != nil) {
                
                while resultSet.next() {
                    
                    let mfAccountInfo : MFAccount = MFAccount()
                    
                    mfAccountInfo.AccId = resultSet.stringForColumn(kAccId)
                    mfAccountInfo.clientid = resultSet.stringForColumn(kclientid)
                    mfAccountInfo.FolioNo = resultSet.stringForColumn(kFolioNo)
                    mfAccountInfo.RTAamcCode = resultSet.stringForColumn(kRTAamcCode)
                    mfAccountInfo.AmcName = resultSet.stringForColumn(kAmcName)
                    mfAccountInfo.SchemeCode = resultSet.stringForColumn(kSchemeCode)
                    mfAccountInfo.SchemeName = resultSet.stringForColumn(kSchemeName)
                    mfAccountInfo.DivOption = resultSet.stringForColumn(kDivOption)
                    mfAccountInfo.pucharseUnits = resultSet.stringForColumn(kpucharseUnits)
                    mfAccountInfo.puchaseNAV = resultSet.stringForColumn(kpuchaseNAV)
                    mfAccountInfo.InvestmentAmount = resultSet.stringForColumn(kInvestmentAmount)
                    mfAccountInfo.CurrentNAV = resultSet.stringForColumn(kCurrentNAV)
                    mfAccountInfo.NAVDate = resultSet.stringForColumn(kNAVDate)
                    mfAccountInfo.isDeleted = resultSet.stringForColumn(kisDeleted)
                    
                    marrStakeInfo.addObject(mfAccountInfo)
                }
            }
            sharedInstanceDB.database!.close()
            
            return marrStakeInfo
        }
        
        
        func checkManualMFAccountAlreadyExist(mfAccountInfo : MFAccount) -> Bool {
            
            sharedInstanceDB.database!.open()
            
            let resultSet: FMResultSet! = sharedInstanceDB.database!.executeQuery("SELECT * FROM \(DB_TBL_MANUAL_MF_ACCOUNT) WHERE \(kAccId)=\(mfAccountInfo.AccId)", withArgumentsInArray: nil)
            
            let marrStakeInfo : NSMutableArray = NSMutableArray()
            if (resultSet != nil) {
                while resultSet.next() {
                    
                    let mfAccountInfo : MFAccount = MFAccount()
                    
                    mfAccountInfo.AccId = resultSet.stringForColumn(kAccId)
                    mfAccountInfo.clientid = resultSet.stringForColumn(kclientid)
                    mfAccountInfo.FolioNo = resultSet.stringForColumn(kFolioNo)
                    mfAccountInfo.RTAamcCode = resultSet.stringForColumn(kRTAamcCode)
                    mfAccountInfo.AmcName = resultSet.stringForColumn(kAmcName)
                    mfAccountInfo.SchemeCode = resultSet.stringForColumn(kSchemeCode)
                    mfAccountInfo.SchemeName = resultSet.stringForColumn(kSchemeName)
                    mfAccountInfo.DivOption = resultSet.stringForColumn(kDivOption)
                    mfAccountInfo.pucharseUnits = resultSet.stringForColumn(kpucharseUnits)
                    mfAccountInfo.puchaseNAV = resultSet.stringForColumn(kpuchaseNAV)
                    mfAccountInfo.InvestmentAmount = resultSet.stringForColumn(kInvestmentAmount)
                    mfAccountInfo.CurrentNAV = resultSet.stringForColumn(kCurrentNAV)
                    mfAccountInfo.NAVDate = resultSet.stringForColumn(kNAVDate)
                    mfAccountInfo.isDeleted = resultSet.stringForColumn(kisDeleted)
                    
                    marrStakeInfo.addObject(mfAccountInfo)
                    
                }
            }
            
            sharedInstanceDB.database!.close()
            
            
            if marrStakeInfo.count==0 {
                return false
            }else{
                return true
            }
        }
        
        
        //MF_TRANSACTIONS
        
        func getMFTransactionsGroupByDateFromManual(mfAccountInfo : MFAccount) -> NSMutableArray { // NEWLY
            
            sharedInstanceDB.database!.open()
            
            let resultSet: FMResultSet! = sharedInstanceDB.database!.executeQuery("SELECT * FROM \(DB_TBL_MANUAL_MF_TRANSACTION) WHERE isDeleted=0 AND \(kAccID)=\(mfAccountInfo.AccId) GROUP BY \(kExecutaionDateTime)", withArgumentsInArray: nil)
            
            let marrStakeInfo : NSMutableArray = NSMutableArray()
            if (resultSet != nil) {
                
                while resultSet.next() {
                    
                    let mfAccountInfo : MFTransaction = MFTransaction()
                    
                    mfAccountInfo.TxnID = resultSet.stringForColumn(kTxnID)
                    mfAccountInfo.AccID = resultSet.stringForColumn(kAccID)
                    mfAccountInfo.OrderId = resultSet.stringForColumn(kOrderId)
                    mfAccountInfo.TxnOrderDateTime = resultSet.stringForColumn(kTxnOrderDateTime)
                    mfAccountInfo.TxtType = resultSet.stringForColumn(kTxtType)
                    mfAccountInfo.TxnpucharseUnits = resultSet.stringForColumn(kTxnpucharseUnits)
                    mfAccountInfo.TxnpuchaseNAV = resultSet.stringForColumn(kTxnpuchaseNAV)
                    mfAccountInfo.TxnPurchaseAmount = resultSet.stringForColumn(kTxnPurchaseAmount)
                    mfAccountInfo.ExecutaionDateTime = resultSet.stringForColumn(kExecutaionDateTime)
                    mfAccountInfo.isDeleted = resultSet.stringForColumn(kisDeleted)
                    
                    marrStakeInfo.addObject(mfAccountInfo)
                }
            }
            sharedInstanceDB.database!.close()
            
            return marrStakeInfo
        }
        
        
        
        func deleteManualMFTransaction(mfAccountInfo : MFTransaction) -> Bool {
            
            sharedInstanceDB.database!.open()
            
            let isInserted = sharedInstanceDB.database?.executeUpdate("UPDATE \(DB_TBL_MANUAL_MF_TRANSACTION) SET \(kisDeleted)=1 WHERE \(kTxnID)=?", withArgumentsInArray: [mfAccountInfo.TxnID])
            
            sharedInstanceDB.database?.close()
            
            return isInserted!
        }
        
        func addManualMFTransaction(mfAccountInfo : MFTransaction) -> Bool {
            
            sharedInstanceDB.database!.open()
            
            let isInserted = sharedInstanceDB.database?.executeUpdate("INSERT INTO \(DB_TBL_MANUAL_MF_TRANSACTION) (\(kTxnID), \(kAccID), \(kOrderId), \(kTxnOrderDateTime), \(kTxtType), \(kTxnpucharseUnits), \(kTxnpuchaseNAV), \(kTxnPurchaseAmount), \(kExecutaionDateTime), \(kisDeleted)) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", withArgumentsInArray: [mfAccountInfo.TxnID,mfAccountInfo.AccID,mfAccountInfo.OrderId,mfAccountInfo.TxnOrderDateTime,mfAccountInfo.TxtType,mfAccountInfo.TxnpucharseUnits,mfAccountInfo.TxnpuchaseNAV,mfAccountInfo.TxnPurchaseAmount,mfAccountInfo.ExecutaionDateTime,mfAccountInfo.isDeleted])
            
            sharedInstanceDB.database?.close()
            
            return isInserted!
        }
        
        func updateManualMFTransaction(mfAccountInfo : MFTransaction) -> Bool {
            
            sharedInstanceDB.database!.open()
            
            let isInserted = sharedInstanceDB.database?.executeUpdate("UPDATE \(DB_TBL_MANUAL_MF_TRANSACTION) SET \(kAccID)=?, \(kOrderId)=?, \(kTxnOrderDateTime)=?, \(kTxtType)=?, \(kTxnpucharseUnits)=?, \(kTxnpuchaseNAV)=?, \(kTxnPurchaseAmount)=?, \(kExecutaionDateTime)=?, \(kisDeleted)=? WHERE \(kTxnID)=?", withArgumentsInArray: [mfAccountInfo.AccID,mfAccountInfo.OrderId,mfAccountInfo.TxnOrderDateTime,mfAccountInfo.TxtType,mfAccountInfo.TxnpucharseUnits,mfAccountInfo.TxnpuchaseNAV,mfAccountInfo.TxnPurchaseAmount,mfAccountInfo.ExecutaionDateTime,mfAccountInfo.isDeleted,mfAccountInfo.TxnID])
            
            sharedInstanceDB.database?.close()
            
            return isInserted!
        }
        
        
        func getManualMFTransactions() -> NSMutableArray {
            
            sharedInstanceDB.database!.open()
            
            let resultSet: FMResultSet! = sharedInstanceDB.database!.executeQuery("SELECT * FROM \(DB_TBL_MANUAL_MF_TRANSACTION)", withArgumentsInArray: nil)
            
            let marrStakeInfo : NSMutableArray = NSMutableArray()
            if (resultSet != nil) {
                
                while resultSet.next() {
                    
                    let mfAccountInfo : MFTransaction = MFTransaction()
                    
                    mfAccountInfo.TxnID = resultSet.stringForColumn(kTxnID)
                    mfAccountInfo.AccID = resultSet.stringForColumn(kAccID)
                    mfAccountInfo.OrderId = resultSet.stringForColumn(kOrderId)
                    mfAccountInfo.TxnOrderDateTime = resultSet.stringForColumn(kTxnOrderDateTime)
                    mfAccountInfo.TxtType = resultSet.stringForColumn(kTxtType)
                    mfAccountInfo.TxnpucharseUnits = resultSet.stringForColumn(kTxnpucharseUnits)
                    mfAccountInfo.TxnpuchaseNAV = resultSet.stringForColumn(kTxnpuchaseNAV)
                    mfAccountInfo.TxnPurchaseAmount = resultSet.stringForColumn(kTxnPurchaseAmount)
                    mfAccountInfo.ExecutaionDateTime = resultSet.stringForColumn(kExecutaionDateTime)
                    mfAccountInfo.isDeleted = resultSet.stringForColumn(kisDeleted)
                    
                    marrStakeInfo.addObject(mfAccountInfo)
                }
            }
            sharedInstanceDB.database!.close()
            
            return marrStakeInfo
        }
        
        func getMFUTransactionsByAccountIDFromManual(accId : String) -> NSMutableArray {
            
            sharedInstanceDB.database!.open()
            
            let resultSet: FMResultSet! = sharedInstanceDB.database!.executeQuery("SELECT * FROM \(DB_TBL_MANUAL_MF_TRANSACTION) WHERE \(kAccID)=? AND \(kisDeleted)=0 ORDER BY \(kExecutaionDateTime)", withArgumentsInArray: [accId])
            
            let marrStakeInfo : NSMutableArray = NSMutableArray()
            if (resultSet != nil) {
                
                while resultSet.next() {
                    
                    let mfAccountInfo : MFTransaction = MFTransaction()
                    
                    mfAccountInfo.TxnID = resultSet.stringForColumn(kTxnID)
                    mfAccountInfo.AccID = resultSet.stringForColumn(kAccID)
                    mfAccountInfo.OrderId = resultSet.stringForColumn(kOrderId)
                    mfAccountInfo.TxnOrderDateTime = resultSet.stringForColumn(kTxnOrderDateTime)
                    mfAccountInfo.TxtType = resultSet.stringForColumn(kTxtType)
                    mfAccountInfo.TxnpucharseUnits = resultSet.stringForColumn(kTxnpucharseUnits)
                    mfAccountInfo.TxnpuchaseNAV = resultSet.stringForColumn(kTxnpuchaseNAV)
                    mfAccountInfo.TxnPurchaseAmount = resultSet.stringForColumn(kTxnPurchaseAmount)
                    mfAccountInfo.ExecutaionDateTime = resultSet.stringForColumn(kExecutaionDateTime)
                    mfAccountInfo.isDeleted = resultSet.stringForColumn(kisDeleted)
                    
                    marrStakeInfo.addObject(mfAccountInfo)
                }
            }
            sharedInstanceDB.database!.close()
            
            return marrStakeInfo
        }
        
        
        func getMFTransactionsByDateFromManual(date : String, mfAccountInfo : MFAccount) -> NSMutableArray {
            
            sharedInstanceDB.database!.open()
            
            let resultSet: FMResultSet! = sharedInstanceDB.database!.executeQuery("SELECT * FROM \(DB_TBL_MANUAL_MF_TRANSACTION) WHERE isDeleted=0 AND \(kAccID)=\(mfAccountInfo.AccId) AND \(kExecutaionDateTime)='\(date)'", withArgumentsInArray: nil)
            
            let marrStakeInfo : NSMutableArray = NSMutableArray()
            if (resultSet != nil) {
                
                while resultSet.next() {
                    
                    let mfAccountInfo : MFTransaction = MFTransaction()
                    
                    mfAccountInfo.TxnID = resultSet.stringForColumn(kTxnID)
                    mfAccountInfo.AccID = resultSet.stringForColumn(kAccID)
                    mfAccountInfo.OrderId = resultSet.stringForColumn(kOrderId)
                    mfAccountInfo.TxnOrderDateTime = resultSet.stringForColumn(kTxnOrderDateTime)
                    mfAccountInfo.TxtType = resultSet.stringForColumn(kTxtType)
                    mfAccountInfo.TxnpucharseUnits = resultSet.stringForColumn(kTxnpucharseUnits)
                    mfAccountInfo.TxnpuchaseNAV = resultSet.stringForColumn(kTxnpuchaseNAV)
                    mfAccountInfo.TxnPurchaseAmount = resultSet.stringForColumn(kTxnPurchaseAmount)
                    mfAccountInfo.ExecutaionDateTime = resultSet.stringForColumn(kExecutaionDateTime)
                    mfAccountInfo.isDeleted = resultSet.stringForColumn(kisDeleted)
                    
                    marrStakeInfo.addObject(mfAccountInfo)
                }
            }
            sharedInstanceDB.database!.close()
            
            return marrStakeInfo
        }
        
        func checkManualMFTransactionAlreadyExist(mfAccountInfo : MFTransaction) -> Bool {
            
            sharedInstanceDB.database!.open()
            
            let resultSet: FMResultSet! = sharedInstanceDB.database!.executeQuery("SELECT * FROM \(DB_TBL_MANUAL_MF_TRANSACTION) WHERE \(kTxnID)=\(mfAccountInfo.TxnID)", withArgumentsInArray: nil)
            
            let marrStakeInfo : NSMutableArray = NSMutableArray()
            if (resultSet != nil) {
                while resultSet.next() {
                    
                    let mfAccountInfo : MFTransaction = MFTransaction()
                    
                    mfAccountInfo.TxnID = resultSet.stringForColumn(kTxnID)
                    mfAccountInfo.AccID = resultSet.stringForColumn(kAccID)
                    mfAccountInfo.OrderId = resultSet.stringForColumn(kOrderId)
                    mfAccountInfo.TxnOrderDateTime = resultSet.stringForColumn(kTxnOrderDateTime)
                    mfAccountInfo.TxtType = resultSet.stringForColumn(kTxtType)
                    mfAccountInfo.TxnpucharseUnits = resultSet.stringForColumn(kTxnpucharseUnits)
                    mfAccountInfo.TxnpuchaseNAV = resultSet.stringForColumn(kTxnpuchaseNAV)
                    mfAccountInfo.TxnPurchaseAmount = resultSet.stringForColumn(kTxnPurchaseAmount)
                    mfAccountInfo.ExecutaionDateTime = resultSet.stringForColumn(kExecutaionDateTime)
                    mfAccountInfo.isDeleted = resultSet.stringForColumn(kisDeleted)
                    
                    marrStakeInfo.addObject(mfAccountInfo)
                    
                }
            }
            
            sharedInstanceDB.database!.close()
            
            if marrStakeInfo.count==0 {
                return false
            }else{
                return true
            }
        }
        
        
        // GET Systematic Order Details
        func addOrderSystematic(OrderInfo : OrderSystematic) -> Bool {
            
            sharedInstanceDB.database!.open()
            
            let isInserted = sharedInstanceDB.database?.executeUpdate("INSERT INTO \(DB_TBL_ORDER_SYSTEMATIC_MASTER) (\(kAppOrderID), \(kFrequency), \(kDay), \(kStart_Month), \(kStart_Year), \(kEnd_Month), \(kEnd_Year), \(kNoOfInstallments), \(kFirstPaymentAmount), \(kFirstPaymentFlag)) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", withArgumentsInArray: [OrderInfo.AppOrderID,OrderInfo.Frequency,OrderInfo.Day,OrderInfo.Start_Month,OrderInfo.Start_Year,OrderInfo.End_Month,OrderInfo.End_Year,OrderInfo.NoOfInstallments,OrderInfo.FirstPaymentAmount,OrderInfo.FirstPaymentFlag])
            
            sharedInstanceDB.database?.close()
            
            return isInserted!
        }
        
        func updateOrderSystematic(OrderInfo : OrderSystematic) -> Bool {
            
            sharedInstanceDB.database!.open()
            
            let isInserted = sharedInstanceDB.database?.executeUpdate("UPDATE \(DB_TBL_ORDER_SYSTEMATIC_MASTER) SET \(kFrequency)=?, \(kDay)=?, \(kStart_Month)=?, \(kStart_Year)=?, \(kEnd_Month)=?, \(kEnd_Year)=?, \(kNoOfInstallments)=?, \(kFirstPaymentAmount)=?, \(kFirstPaymentFlag)=? WHERE \(kAppOrderID)=?", withArgumentsInArray: [OrderInfo.Frequency,OrderInfo.Day,OrderInfo.Start_Month,OrderInfo.Start_Year,OrderInfo.End_Month,OrderInfo.End_Year,OrderInfo.NoOfInstallments,OrderInfo.FirstPaymentAmount,OrderInfo.FirstPaymentFlag,OrderInfo.AppOrderID])
            
            sharedInstanceDB.database?.close()
            
            return isInserted!
        }
        
        
        func getAllOrderSystematic() -> NSMutableArray {
            
            sharedInstanceDB.database!.open()
            
            let resultSet: FMResultSet! = sharedInstanceDB.database!.executeQuery("SELECT * FROM \(DB_TBL_ORDER_SYSTEMATIC_MASTER)", withArgumentsInArray: nil)
            
            let marrStakeInfo : NSMutableArray = NSMutableArray()
            if (resultSet != nil) {
                
                while resultSet.next() {
                    
                    let userInfo : OrderSystematic = OrderSystematic()
                    
                    userInfo.AppOrderID = resultSet.stringForColumn(kAppOrderID)
                    userInfo.Frequency = resultSet.stringForColumn(kFrequency)
                    userInfo.Day = resultSet.stringForColumn(kDay)
                    userInfo.Start_Month = resultSet.stringForColumn(kStart_Month)
                    userInfo.Start_Year = resultSet.stringForColumn(kStart_Year)
                    userInfo.End_Month = resultSet.stringForColumn(kEnd_Month)
                    userInfo.End_Year = resultSet.stringForColumn(kEnd_Year)
                    userInfo.NoOfInstallments = resultSet.stringForColumn(kNoOfInstallments)
                    userInfo.FirstPaymentAmount = resultSet.stringForColumn(kFirstPaymentAmount)
                    userInfo.FirstPaymentFlag = resultSet.stringForColumn(kFirstPaymentFlag)
                    
                    marrStakeInfo.addObject(userInfo)
                }
            }
            sharedInstanceDB.database!.close()
            
            return marrStakeInfo
        }
        
        func getSystematicOrderByAppOrderId(objOrder : Order) -> NSMutableArray {
            
            sharedInstanceDB.database!.open()
            
            let resultSet: FMResultSet! = sharedInstanceDB.database!.executeQuery("SELECT * FROM \(DB_TBL_ORDER_SYSTEMATIC_MASTER) WHERE \(kAppOrderID)=\(objOrder.AppOrderID)", withArgumentsInArray: nil)
            
            let marrStakeInfo : NSMutableArray = NSMutableArray()
            if (resultSet != nil) {
                
                while resultSet.next() {
                    
                    let userInfo : OrderSystematic = OrderSystematic()
                    
                    userInfo.AppOrderID = resultSet.stringForColumn(kAppOrderID)
                    userInfo.Frequency = resultSet.stringForColumn(kFrequency)
                    userInfo.Day = resultSet.stringForColumn(kDay)
                    userInfo.Start_Month = resultSet.stringForColumn(kStart_Month)
                    userInfo.Start_Year = resultSet.stringForColumn(kStart_Year)
                    userInfo.End_Month = resultSet.stringForColumn(kEnd_Month)
                    userInfo.End_Year = resultSet.stringForColumn(kEnd_Year)
                    userInfo.NoOfInstallments = resultSet.stringForColumn(kNoOfInstallments)
                    userInfo.FirstPaymentAmount = resultSet.stringForColumn(kFirstPaymentAmount)
                    userInfo.FirstPaymentFlag = resultSet.stringForColumn(kFirstPaymentFlag)
                    
                    marrStakeInfo.addObject(userInfo)
                }
            }
            sharedInstanceDB.database!.close()
            
            return marrStakeInfo
        }
        
        
        func checkOrderSystematicAlreadyExist(OrderInfo : OrderSystematic) -> Bool {
            
            sharedInstanceDB.database!.open()
            
            let resultSet: FMResultSet! = sharedInstanceDB.database!.executeQuery("SELECT * FROM \(DB_TBL_ORDER_SYSTEMATIC_MASTER) WHERE \(kAppOrderID)=\(OrderInfo.AppOrderID)", withArgumentsInArray: nil)
            
            let marrStakeInfo : NSMutableArray = NSMutableArray()
            if (resultSet != nil) {
                while resultSet.next() {
                    
                    let mfAccountInfo : OrderSystematic = OrderSystematic()
                    
                    mfAccountInfo.AppOrderID = resultSet.stringForColumn(kAppOrderID)
                    mfAccountInfo.Frequency = resultSet.stringForColumn(kFrequency)
                    mfAccountInfo.Day = resultSet.stringForColumn(kDay)
                    mfAccountInfo.Start_Month = resultSet.stringForColumn(kStart_Month)
                    mfAccountInfo.Start_Year = resultSet.stringForColumn(kStart_Year)
                    mfAccountInfo.End_Month = resultSet.stringForColumn(kEnd_Month)
                    mfAccountInfo.End_Year = resultSet.stringForColumn(kEnd_Year)
                    mfAccountInfo.NoOfInstallments = resultSet.stringForColumn(kNoOfInstallments)
                    mfAccountInfo.FirstPaymentAmount = resultSet.stringForColumn(kFirstPaymentAmount)
                    mfAccountInfo.FirstPaymentFlag = resultSet.stringForColumn(kFirstPaymentFlag)
                    
                    marrStakeInfo.addObject(mfAccountInfo)
                    
                }
            }
            
            sharedInstanceDB.database!.close()
            
            
            if marrStakeInfo.count==0 {
                return false
            }else{
                return true
            }
        }
        
        
        // Dynamic Text
        func addDynamiText(dynamicText : DynamicText) -> Bool {
            
            sharedInstanceDB.database!.open()
            
            let isInserted = sharedInstanceDB.database?.executeUpdate("INSERT INTO \(DB_TBL_DYNAMIC_TEXT) (\(kText_type), \(kTitle), \(kText)) VALUES (?, ?, ?)", withArgumentsInArray: [dynamicText.text_type,dynamicText.title,dynamicText.text])
            
            sharedInstanceDB.database?.close()
            
            return isInserted!
        }
        
        func updateDynamicText(dynamicText : DynamicText) -> Bool {
            
            sharedInstanceDB.database!.open()
            
            let isInserted = sharedInstanceDB.database?.executeUpdate("UPDATE \(DB_TBL_DYNAMIC_TEXT) SET \(kTitle)=?, \(kText)=? WHERE \(kText_type)=?", withArgumentsInArray: [dynamicText.title,dynamicText.text,dynamicText.text_type])
            
            sharedInstanceDB.database?.close()
            
            return isInserted!
        }
        
        func getDynamicText(textType : SyncDynamicTextType) -> DynamicText {
            
            sharedInstanceDB.database!.open()
            
            let resultSet: FMResultSet! = sharedInstanceDB.database!.executeQuery("SELECT * FROM \(DB_TBL_DYNAMIC_TEXT) WHERE \(kText_type) = \(textType.hashValue)" , withArgumentsInArray: nil)
            
            let dynamicText : DynamicText = DynamicText()
            if (resultSet != nil) {
                while resultSet.next() {
                    dynamicText.text_type = resultSet.stringForColumn(kText_type)
                    dynamicText.title = resultSet.stringForColumn(kTitle)
                    dynamicText.text = resultSet.stringForColumn(kText)
                }
            }
            sharedInstanceDB.database!.close()
            
            return dynamicText
        }
        
        
        func getAllDynamicText() -> NSMutableArray {
            
            sharedInstanceDB.database!.open()
            
            let resultSet: FMResultSet! = sharedInstanceDB.database!.executeQuery("SELECT * FROM \(DB_TBL_DYNAMIC_TEXT)", withArgumentsInArray: nil)
            
            let marrStakeInfo : NSMutableArray = NSMutableArray()
            if (resultSet != nil) {
                
                while resultSet.next() {
                    
                    let mfAccountInfo : DynamicText = DynamicText()
                    
                    mfAccountInfo.text_type = resultSet.stringForColumn(kText_type)
                    mfAccountInfo.title = resultSet.stringForColumn(kTitle)
                    mfAccountInfo.text = resultSet.stringForColumn(kText)
                    
                    marrStakeInfo.addObject(mfAccountInfo)
                }
            }
            sharedInstanceDB.database!.close()
            
            return marrStakeInfo
        }
        
        func checkDynamicTextAlreadyExist(dynamicText : DynamicText) -> Bool {
            
            sharedInstanceDB.database!.open()
            
            let resultSet: FMResultSet! = sharedInstanceDB.database!.executeQuery("SELECT * FROM \(DB_TBL_DYNAMIC_TEXT) WHERE \(kText_type)=\(dynamicText.text_type)", withArgumentsInArray: nil)
            
            let marrStakeInfo : NSMutableArray = NSMutableArray()
            if (resultSet != nil) {
                while resultSet.next() {
                    
                    let mfAccountInfo : DynamicText = DynamicText()
                    
                    mfAccountInfo.text_type = resultSet.stringForColumn(kText_type)
                    mfAccountInfo.title = resultSet.stringForColumn(kTitle)
                    mfAccountInfo.text = resultSet.stringForColumn(kText)
                    
                    marrStakeInfo.addObject(mfAccountInfo)
                    
                }
            }
            
            sharedInstanceDB.database!.close()
            
            if marrStakeInfo.count==0 {
                return false
            }else{
                return true
            }
        }
        
        
        
        
        // PayEzzMandate
        func addPayEzzMandate(payMandate : PayEzzMandate) -> Bool {
            
            sharedInstanceDB.database!.open()
            
            let isInserted = sharedInstanceDB.database?.executeUpdate("INSERT INTO \(DB_TBL_PAY_EZZ_MANDATE) (\(kMandateID), \(kclientID), \(ksubSeq_invAccType),\(ksubSeq_invAccNo),\(ksubSeq_micrNo),\(ksubSeq_ifscCode),\(ksubSeq_bankId),\(ksubSeq_maximumAmount),\(ksubSeq_perpetualFlag),\(ksubSeq_startDate),\(ksubSeq_endDate),\(ksubSeq_paymentRefNo),\(kFilePath),\(kAndroidAppSync),\(kPayEzzStatus)) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", withArgumentsInArray: [payMandate.MandateID,payMandate.clientID,payMandate.subSeq_invAccType,payMandate.subSeq_invAccNo,payMandate.subSeq_micrNo,payMandate.subSeq_ifscCode,payMandate.subSeq_bankId,payMandate.subSeq_maximumAmount,payMandate.subSeq_perpetualFlag,payMandate.subSeq_startDate,payMandate.subSeq_endDate,payMandate.subSeq_paymentRefNo,payMandate.FilePath,payMandate.AndroidAppSync,payMandate.PayEzzStatus])
            
            sharedInstanceDB.database?.close()
            
            return isInserted!
        }
        
        func updatePayEzzMandate(payMandate : PayEzzMandate) -> Bool {
            
            sharedInstanceDB.database!.open()
            
            let isInserted = sharedInstanceDB.database?.executeUpdate("UPDATE \(DB_TBL_PAY_EZZ_MANDATE) SET \(kclientID)=?, \(ksubSeq_invAccType)=?,\(ksubSeq_invAccNo)=?,\(ksubSeq_micrNo)=?,\(ksubSeq_ifscCode)=?,\(ksubSeq_bankId)=?,\(ksubSeq_maximumAmount)=?,\(ksubSeq_perpetualFlag)=?,\(ksubSeq_startDate)=?,\(ksubSeq_endDate)=?,\(ksubSeq_paymentRefNo)=?,\(kFilePath)=?,\(kAndroidAppSync)=?,\(kPayEzzStatus)=? WHERE \(kMandateID)=?", withArgumentsInArray: [payMandate.clientID,payMandate.subSeq_invAccType,payMandate.subSeq_invAccNo,payMandate.subSeq_micrNo,payMandate.subSeq_ifscCode,payMandate.subSeq_bankId,payMandate.subSeq_maximumAmount,payMandate.subSeq_perpetualFlag,payMandate.subSeq_startDate,payMandate.subSeq_endDate,payMandate.subSeq_paymentRefNo,payMandate.FilePath,payMandate.AndroidAppSync,payMandate.PayEzzStatus,payMandate.MandateID])
            
            sharedInstanceDB.database?.close()
            
            return isInserted!
        }
        
        
        func getAllPayEzzMandate() -> NSMutableArray {
            
            sharedInstanceDB.database!.open()
            
            let resultSet: FMResultSet! = sharedInstanceDB.database!.executeQuery("SELECT * FROM \(DB_TBL_PAY_EZZ_MANDATE)", withArgumentsInArray: nil)
            
            let marrStakeInfo : NSMutableArray = NSMutableArray()
            if (resultSet != nil) {
                
                while resultSet.next() {
                    
                    let mfAccountInfo : PayEzzMandate = PayEzzMandate()
                    
                    mfAccountInfo.MandateID = resultSet.stringForColumn(kMandateID)
                    mfAccountInfo.clientID = resultSet.stringForColumn(kclientID)
                    mfAccountInfo.subSeq_invAccType = resultSet.stringForColumn(ksubSeq_invAccType)
                    mfAccountInfo.subSeq_invAccNo = resultSet.stringForColumn(ksubSeq_invAccNo)
                    mfAccountInfo.subSeq_micrNo = resultSet.stringForColumn(ksubSeq_micrNo)
                    mfAccountInfo.subSeq_ifscCode = resultSet.stringForColumn(ksubSeq_ifscCode)
                    mfAccountInfo.subSeq_bankId = resultSet.stringForColumn(ksubSeq_bankId)
                    mfAccountInfo.subSeq_maximumAmount = resultSet.stringForColumn(ksubSeq_maximumAmount)
                    mfAccountInfo.subSeq_perpetualFlag = resultSet.stringForColumn(ksubSeq_perpetualFlag)
                    mfAccountInfo.subSeq_startDate = resultSet.stringForColumn(ksubSeq_startDate)
                    mfAccountInfo.subSeq_endDate = resultSet.stringForColumn(ksubSeq_endDate)
                    mfAccountInfo.subSeq_paymentRefNo = resultSet.stringForColumn(ksubSeq_paymentRefNo)
                    mfAccountInfo.FilePath = resultSet.stringForColumn(kFilePath)
                    mfAccountInfo.AndroidAppSync = resultSet.stringForColumn(kAndroidAppSync)
                    mfAccountInfo.PayEzzStatus = resultSet.stringForColumn(kPayEzzStatus)
                    
                    marrStakeInfo.addObject(mfAccountInfo)
                }
            }
            sharedInstanceDB.database!.close()
            
            return marrStakeInfo
        }
        
        func checkPayEzzMandateAlreadyExist(payMandate : PayEzzMandate) -> Bool {
            
            sharedInstanceDB.database!.open()
            
            let resultSet: FMResultSet! = sharedInstanceDB.database!.executeQuery("SELECT * FROM \(DB_TBL_PAY_EZZ_MANDATE) WHERE \(kMandateID)=\(payMandate.MandateID)", withArgumentsInArray: nil)
            
            let marrStakeInfo : NSMutableArray = NSMutableArray()
            if (resultSet != nil) {
                while resultSet.next() {
                    
                    let mfAccountInfo : PayEzzMandate = PayEzzMandate()
                    
                    mfAccountInfo.MandateID = resultSet.stringForColumn(kMandateID)
                    
                    marrStakeInfo.addObject(mfAccountInfo)
                    
                }
            }
            
            sharedInstanceDB.database!.close()
            
            if marrStakeInfo.count==0 {
                return false
            }else{
                return true
            }
        }
        
        
        
        
        
        // WORTH TABLE ENTRY.......MARK: COMMENT
        
        func addorUpdateMFU_WORTH(mfAccountInfo : MfuPortfolioWorth) -> Bool {
            
            sharedInstanceDB.database!.open()
            
            var isInserted = sharedInstanceDB.database?.executeUpdate("INSERT INTO \(DB_TBL_mfuPortfolioWorthTable) (\(kportfolio_date), \(kAccID), \(kpucharseUnits), \(kCurrentNAV), \(kCurrentValue), \(kIsTransaction)) VALUES (?, ?, ?, ?, ?, ?)", withArgumentsInArray: [mfAccountInfo.portfolio_date, mfAccountInfo.AccId, mfAccountInfo.pucharseUnits,mfAccountInfo.CurrentNAV,mfAccountInfo.CurrentValue,mfAccountInfo.isTransaction])
            
            if !isInserted!
            {
                
                isInserted = sharedInstanceDB.database?.executeUpdate("UPDATE \(DB_TBL_mfuPortfolioWorthTable) SET \(kpucharseUnits) = ?, \(kCurrentNAV) = ?, \(kCurrentValue) = ?, \(kIsTransaction) = ? WHERE \(kportfolio_date) = ? AND \(kAccID) = ?",withArgumentsInArray: [mfAccountInfo.pucharseUnits,mfAccountInfo.CurrentNAV,mfAccountInfo.CurrentValue, mfAccountInfo.isTransaction, mfAccountInfo.portfolio_date, mfAccountInfo.AccId])
            }
            
            sharedInstanceDB.database?.close()
            
            return isInserted!
        }
        
        func addorUpdateManualMFU_WORTH(mfAccountInfo : MfuPortfolioWorth) -> Bool {
            
            sharedInstanceDB.database!.open()
            
            var isInserted = sharedInstanceDB.database?.executeUpdate("INSERT INTO \(DB_TBL_mfuPortfolioManualWorthTable) (\(kportfolio_date), \(kAccID), \(kpucharseUnits), \(kCurrentNAV), \(kCurrentValue), \(kIsTransaction)) VALUES (?, ?, ?, ?, ?, ?)", withArgumentsInArray: [mfAccountInfo.portfolio_date, mfAccountInfo.AccId, mfAccountInfo.pucharseUnits,mfAccountInfo.CurrentNAV,mfAccountInfo.CurrentValue,mfAccountInfo.isTransaction])
            
            if !isInserted!
            {
                
                isInserted = sharedInstanceDB.database?.executeUpdate("UPDATE \(DB_TBL_mfuPortfolioManualWorthTable) SET \(kpucharseUnits) = ?, \(kCurrentNAV) = ?, \(kCurrentValue) = ?, \(kIsTransaction) = ? WHERE \(kportfolio_date) = ? AND \(kAccID) = ?",withArgumentsInArray: [mfAccountInfo.pucharseUnits,mfAccountInfo.CurrentNAV,mfAccountInfo.CurrentValue, mfAccountInfo.isTransaction, mfAccountInfo.portfolio_date, mfAccountInfo.AccId])
            }
            
            sharedInstanceDB.database?.close()
            
            return isInserted!
        }
        
        /*   func updateMFU_WORTH(mfAccountInfo : MfuPortfolioWorth) -> Bool {
         
         sharedInstanceDB.database!.open()
         
         let isInserted = sharedInstanceDB.database?.executeUpdate("UPDATE \(DB_TBL_mfuPortfolioWorthTable) SET \(kAccID)=?, \(kOrderId)=?, \(kTxnOrderDateTime)=?, \(kTxtType)=?, \(kTxnpucharseUnits)=?, \(kTxnpuchaseNAV)=?, \(kTxnPurchaseAmount)=?, \(kExecutaionDateTime)=?, \(kisDeleted)=? WHERE \(kTxnID)=?", withArgumentsInArray: [mfAccountInfo.AccID,mfAccountInfo.OrderId,mfAccountInfo.TxnOrderDateTime,mfAccountInfo.TxtType,mfAccountInfo.TxnpucharseUnits,mfAccountInfo.TxnpuchaseNAV,mfAccountInfo.TxnPurchaseAmount,mfAccountInfo.ExecutaionDateTime,mfAccountInfo.isDeleted,mfAccountInfo.TxnID])
         
         sharedInstanceDB.database?.close()
         
         return isInserted!
         }
         */
        
        
        func updateMFUMutualFundAccountNAVAndDate(accId : String, currentNAV : String, lastUpdatedDate : String) -> Bool {
            
            sharedInstanceDB.database!.open()
            
            let isInserted = sharedInstanceDB.database?.executeUpdate("UPDATE \(DB_TBL_mfuPortfolioWorthTable) SET \(kCurrentNAV)=?, \(kportfolio_date)=? WHERE \(kAccID)=?", withArgumentsInArray: [currentNAV,lastUpdatedDate,accId])
            
            sharedInstanceDB.database?.close()
            
            return isInserted!
        }
        
        func getMFU_WORTH() -> NSMutableArray {
            
            sharedInstanceDB.database!.open()
            
            let resultSet: FMResultSet! = sharedInstanceDB.database!.executeQuery("SELECT * FROM \(DB_TBL_mfuPortfolioWorthTable)", withArgumentsInArray: nil)
            
            let marrStakeInfo : NSMutableArray = NSMutableArray()
            if (resultSet != nil) {
                
                while resultSet.next() {
                    
                    let mfAccountInfo : MfuPortfolioWorth = MfuPortfolioWorth()
                    
                    mfAccountInfo.portfolio_date = resultSet.stringForColumn(kportfolio_date)
                    mfAccountInfo.AccId = resultSet.stringForColumn(kAccID)
                    mfAccountInfo.pucharseUnits = Double(resultSet.stringForColumn(kpucharseUnits))
                    mfAccountInfo.CurrentNAV = Double(resultSet.stringForColumn(kCurrentNAV))
                    mfAccountInfo.CurrentValue = Double(resultSet.stringForColumn(kCurrentValue))
                    
                    marrStakeInfo.addObject(mfAccountInfo)
                }
            }
            sharedInstanceDB.database!.close()
            
            return marrStakeInfo
        }
        
        
        //Get for 3 Months from today's date.
        
        //Wealth
        func getMFUPortfolioWorthByAccountIDFor3Months(accId : Int) -> NSMutableArray {
            
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let todaysDate = dateFormatter.stringFromDate(date)
            
            let previous3Months = calendar.dateByAddingUnit(.Month, value: -2, toDate:date, options: [])
            let dateComponent = calendar.components(unitFlags, fromDate: previous3Months!)
            let startOfMonth = calendar.dateFromComponents(dateComponent)
            
            let previousDate = dateFormatter.stringFromDate(startOfMonth!)
            print(previousDate)
            
            sharedInstanceDB.database!.open()
            
            let resultSet: FMResultSet! = sharedInstanceDB.database!.executeQuery("SELECT * FROM \(DB_TBL_mfuPortfolioWorthTable) WHERE \(kAccID)=? AND \(kportfolio_date)  BETWEEN '\(previousDate)' AND '\(todaysDate)'", withArgumentsInArray: [accId])
            
            let marrStakeInfo : NSMutableArray = NSMutableArray()
            if (resultSet != nil) {
                
                while resultSet.next() {
                    
                    let mfAccountInfo : MfuPortfolioWorth = MfuPortfolioWorth()
                    
                    mfAccountInfo.portfolio_date = resultSet.stringForColumn(kportfolio_date)
                    mfAccountInfo.AccId = resultSet.stringForColumn(kAccID)
                    mfAccountInfo.pucharseUnits = Double(resultSet.stringForColumn(kpucharseUnits))
                    mfAccountInfo.CurrentNAV = Double(resultSet.stringForColumn(kCurrentNAV))
                    mfAccountInfo.CurrentValue = Double(resultSet.stringForColumn(kCurrentValue))
                    
                    marrStakeInfo.addObject(mfAccountInfo)
                }
            }
            sharedInstanceDB.database!.close()
            
            return marrStakeInfo
        }
        
        //Manual
        func getManualMFUPortfolioWorthByAccountIDFor3Months(accId : Int) -> NSMutableArray {
            
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let todaysDate = dateFormatter.stringFromDate(date)
            
            let previous3Months = NSCalendar.currentCalendar().dateByAddingUnit(.Month, value: -2, toDate:date, options: [])
            let dateComponent = calendar.components(unitFlags, fromDate: previous3Months!)
            let startOfMonth = calendar.dateFromComponents(dateComponent)
            
            let previousDate = dateFormatter.stringFromDate(startOfMonth!)
            print(previousDate)
            
            sharedInstanceDB.database!.open()
            
            let resultSet: FMResultSet! = sharedInstanceDB.database!.executeQuery("SELECT * FROM \(DB_TBL_mfuPortfolioManualWorthTable) WHERE \(kAccID)=? AND \(kportfolio_date) BETWEEN '\(previousDate)' AND '\(todaysDate)'", withArgumentsInArray: [accId])
            
            let marrStakeInfo : NSMutableArray = NSMutableArray()
            if (resultSet != nil) {
                
                while resultSet.next() {
                    
                    let mfAccountInfo : MfuPortfolioWorth = MfuPortfolioWorth()
                    
                    mfAccountInfo.portfolio_date = resultSet.stringForColumn(kportfolio_date)
                    mfAccountInfo.AccId = resultSet.stringForColumn(kAccID)
                    mfAccountInfo.pucharseUnits = Double(resultSet.stringForColumn(kpucharseUnits))
                    mfAccountInfo.CurrentNAV = Double(resultSet.stringForColumn(kCurrentNAV))
                    mfAccountInfo.CurrentValue = Double(resultSet.stringForColumn(kCurrentValue))
                    
                    marrStakeInfo.addObject(mfAccountInfo)
                }
            }
            sharedInstanceDB.database!.close()
            
            return marrStakeInfo
        }
         //Get for 1 Year from today's date.
        
        //Wealth
        func getMFUPortfolioWorthByAccountIDFor1Year(accId : Int) -> NSMutableArray {
            
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let todaysDate = dateFormatter.stringFromDate(date)
            
            let previous1Year = NSCalendar.currentCalendar().dateByAddingUnit(.Month, value: -11, toDate:date, options: [])
            let dateComponent = calendar.components(unitFlags, fromDate: previous1Year!)
            let startOfMonth = calendar.dateFromComponents(dateComponent)
            
            let previousDate = dateFormatter.stringFromDate(startOfMonth!)
            print(previousDate)


            sharedInstanceDB.database!.open()
            
            let resultSet: FMResultSet! = sharedInstanceDB.database!.executeQuery("SELECT * FROM \(DB_TBL_mfuPortfolioWorthTable) WHERE \(kAccID)=? AND \(kportfolio_date) BETWEEN '\(previousDate)' AND '\(todaysDate)'", withArgumentsInArray: [accId])
            
            let marrStakeInfo : NSMutableArray = NSMutableArray()
            if (resultSet != nil) {
                
                while resultSet.next() {
                    
                    let mfAccountInfo : MfuPortfolioWorth = MfuPortfolioWorth()
                    
                    mfAccountInfo.portfolio_date = resultSet.stringForColumn(kportfolio_date)
                    mfAccountInfo.AccId = resultSet.stringForColumn(kAccID)
                    mfAccountInfo.pucharseUnits = Double(resultSet.stringForColumn(kpucharseUnits))
                    mfAccountInfo.CurrentNAV = Double(resultSet.stringForColumn(kCurrentNAV))
                    mfAccountInfo.CurrentValue = Double(resultSet.stringForColumn(kCurrentValue))
                    
                    marrStakeInfo.addObject(mfAccountInfo)
                }
            }
            sharedInstanceDB.database!.close()
            
            return marrStakeInfo
        }
        
        //Manual
        func getManualMFUPortfolioWorthByAccountIDFor1Year(accId : Int) -> NSMutableArray {
            
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let todaysDate = dateFormatter.stringFromDate(date)
            
            let previous1Year = NSCalendar.currentCalendar().dateByAddingUnit(.Month, value: -11, toDate:date, options: [])
            let dateComponent = calendar.components(unitFlags, fromDate: previous1Year!)
            let startOfMonth = calendar.dateFromComponents(dateComponent)
            
            let previousDate = dateFormatter.stringFromDate(startOfMonth!)
            print(previousDate)
            
            sharedInstanceDB.database!.open()
            
            let resultSet: FMResultSet! = sharedInstanceDB.database!.executeQuery("SELECT * FROM \(DB_TBL_mfuPortfolioManualWorthTable) WHERE \(kAccID)=? AND \(kportfolio_date) BETWEEN '\(previousDate)' AND '\(todaysDate)'", withArgumentsInArray: [accId])
            
            let marrStakeInfo : NSMutableArray = NSMutableArray()
            if (resultSet != nil) {
                
                while resultSet.next() {
                    
                    let mfAccountInfo : MfuPortfolioWorth = MfuPortfolioWorth()
                    
                    mfAccountInfo.portfolio_date = resultSet.stringForColumn(kportfolio_date)
                    mfAccountInfo.AccId = resultSet.stringForColumn(kAccID)
                    mfAccountInfo.pucharseUnits = Double(resultSet.stringForColumn(kpucharseUnits))
                    mfAccountInfo.CurrentNAV = Double(resultSet.stringForColumn(kCurrentNAV))
                    mfAccountInfo.CurrentValue = Double(resultSet.stringForColumn(kCurrentValue))
                    
                    marrStakeInfo.addObject(mfAccountInfo)
                }
            }
            sharedInstanceDB.database!.close()
            
            return marrStakeInfo
        }

        
        //Get for All records
        
        //Wealth
        func getMFUPortfolioWorthByAccountIDForAll(accId : Int) -> NSMutableArray {
            
            sharedInstanceDB.database!.open()
            
            let resultSet: FMResultSet! = sharedInstanceDB.database!.executeQuery("SELECT * FROM \(DB_TBL_mfuPortfolioWorthTable) WHERE \(kAccID)=? AND \(kportfolio_date) ORDER BY \(kportfolio_date) ", withArgumentsInArray: [accId])
            
            let marrStakeInfo : NSMutableArray = NSMutableArray()
            if (resultSet != nil) {
                
                while resultSet.next() {
                    
                    let mfAccountInfo : MfuPortfolioWorth = MfuPortfolioWorth()
                    
                    mfAccountInfo.portfolio_date = resultSet.stringForColumn(kportfolio_date)
                    mfAccountInfo.AccId = resultSet.stringForColumn(kAccID)
                    mfAccountInfo.pucharseUnits = Double(resultSet.stringForColumn(kpucharseUnits))
                    mfAccountInfo.CurrentNAV = Double(resultSet.stringForColumn(kCurrentNAV))
                    mfAccountInfo.CurrentValue = Double(resultSet.stringForColumn(kCurrentValue))
                    
                    marrStakeInfo.addObject(mfAccountInfo)
                }
            }
            sharedInstanceDB.database!.close()
            
            return marrStakeInfo
        }
        
        //Manual
        func getManualMFUPortfolioWorthByAccountIDForAll(accId : Int) -> NSMutableArray {
            
            sharedInstanceDB.database!.open()
            
            let resultSet: FMResultSet! = sharedInstanceDB.database!.executeQuery("SELECT * FROM \(DB_TBL_mfuPortfolioManualWorthTable) WHERE \(kAccID)=? AND \(kportfolio_date) ORDER BY \(kportfolio_date)", withArgumentsInArray: [accId])
            
            let marrStakeInfo : NSMutableArray = NSMutableArray()
            if (resultSet != nil) {
                
                while resultSet.next() {
                    
                    let mfAccountInfo : MfuPortfolioWorth = MfuPortfolioWorth()
                    
                    mfAccountInfo.portfolio_date = resultSet.stringForColumn(kportfolio_date)
                    mfAccountInfo.AccId = resultSet.stringForColumn(kAccID)
                    mfAccountInfo.pucharseUnits = Double(resultSet.stringForColumn(kpucharseUnits))
                    mfAccountInfo.CurrentNAV = Double(resultSet.stringForColumn(kCurrentNAV))
                    mfAccountInfo.CurrentValue = Double(resultSet.stringForColumn(kCurrentValue))
                    
                    marrStakeInfo.addObject(mfAccountInfo)
                }
            }
            sharedInstanceDB.database!.close()
            
            return marrStakeInfo
        }
        
        
        
        //ADD MANUAL TABLE
        func addMFUManual_WORTH(mfAccountInfo : MfuPortfolioWorth) -> Bool {
            
            sharedInstanceDB.database!.open()
            
            let isInserted = sharedInstanceDB.database?.executeUpdate("INSERT INTO \(DB_TBL_mfuPortfolioManualWorthTable) (\(kportfolio_date), \(kAccID),  \(kpucharseUnits), \(kCurrentNAV), \(kCurrentValue)) VALUES (?, ?, ?, ?, ?, ?, ?)", withArgumentsInArray: [mfAccountInfo.portfolio_date,mfAccountInfo.AccId,mfAccountInfo.pucharseUnits,mfAccountInfo.CurrentNAV,mfAccountInfo.CurrentValue])
            
            sharedInstanceDB.database?.close()
            
            return isInserted!
        }
        
        /*   func updateMFU_WORTH(mfAccountInfo : MfuPortfolioWorth) -> Bool {
         
         sharedInstanceDB.database!.open()
         
         let isInserted = sharedInstanceDB.database?.executeUpdate("UPDATE \(DB_TBL_mfuPortfolioWorthTable) SET \(kAccID)=?, \(kOrderId)=?, \(kTxnOrderDateTime)=?, \(kTxtType)=?, \(kTxnpucharseUnits)=?, \(kTxnpuchaseNAV)=?, \(kTxnPurchaseAmount)=?, \(kExecutaionDateTime)=?, \(kisDeleted)=? WHERE \(kTxnID)=?", withArgumentsInArray: [mfAccountInfo.AccID,mfAccountInfo.OrderId,mfAccountInfo.TxnOrderDateTime,mfAccountInfo.TxtType,mfAccountInfo.TxnpucharseUnits,mfAccountInfo.TxnpuchaseNAV,mfAccountInfo.TxnPurchaseAmount,mfAccountInfo.ExecutaionDateTime,mfAccountInfo.isDeleted,mfAccountInfo.TxnID])
         
         sharedInstanceDB.database?.close()
         
         return isInserted!
         }
         */
        
        func getMFUManual_WORTH() -> NSMutableArray {
            
            sharedInstanceDB.database!.open()
            
            let resultSet: FMResultSet! = sharedInstanceDB.database!.executeQuery("SELECT * FROM \(DB_TBL_mfuPortfolioManualWorthTable)", withArgumentsInArray: nil)
            
            let marrStakeInfo : NSMutableArray = NSMutableArray()
            if (resultSet != nil) {
                
                while resultSet.next() {
                    
                    let mfAccountInfo : MfuPortfolioWorth = MfuPortfolioWorth()
                    
                    mfAccountInfo.portfolio_date = resultSet.stringForColumn(kportfolio_date)
                    mfAccountInfo.AccId = resultSet.stringForColumn(kAccID)
                    mfAccountInfo.pucharseUnits = Double(resultSet.stringForColumn(kpucharseUnits))
                    mfAccountInfo.CurrentNAV = Double(resultSet.stringForColumn(kCurrentNAV))
                    mfAccountInfo.CurrentValue = Double(resultSet.stringForColumn(kCurrentValue))
                    
                    marrStakeInfo.addObject(mfAccountInfo)
                }
            }
            sharedInstanceDB.database!.close()
            
            return marrStakeInfo
        }
        
    }
