//
//  WebManagerHK.swift
//  WealthTrust
//
//  Created by Hemen Gohil on 9/2/16.
//  Copyright © 2016 Hemen Gohil. All rights reserved.
//

// Files.. All Alerts Messages.. String..
// kModesss....
// WEB APIS Keys.
//


import UIKit

// API Domain name...
let URL_DOMAIN = "http://35.154.151.195//dev/api/"

//let URL_DOMAIN = "https://www.wealthtrust.in//api/api/"

// API Names listed here..
let kModeClientlogincheck = "Clientlogincheck"
let kModeSignUp = "signup"
let kModePanInquiryInfo = "paninquiryinfo"
let kModeUpdatePanInfo = "UpdatePanInfo"
let kModeMFUAccountInfo = "MFUAccountInfo"
let kModeSyncUserAccount = "SyncUserAccount"
let kModeGetNAVFromtoToDate = "GetNAVFromtoToDate"
let kModeGetNAVFromDate = "GetNAVFromDate"
let kModegetLatestNAV = "getLatestNAV"
let kModeGetSchemeSearchFilters = "GetSchemeSearchFilters"
let kModeSearchTopSchemeNameByText = "SearchTopSchemeNameByText"
let kModeSearchAllSchemeNameByText = "SearchAllSchemeNameByText"
let kModeSearchSchemeNameByText = "SearchSchemeNameByText"
let kModeGetDirectSchemeDetail = "GetDirectSchemeDetail"
let kModeOrders = "Orders"
let kModeGetFundHouse = "GetFundHouse"
let kModeGetFundCategory = "GetFundCategory"
let kModeGetSchemeThresholdDetails = "GetSchemeThresholdDetails"
let kModeClientForgotpassword = "ClientForgotpassword"
let kModeClientUpdatePassword = "ClientUpdatePassword"
let kModeGetTopFunds = "GetTopFunds"
let kModeGetSchemeCompleteDetail = "GetSchemeCompleteDetail"
let kModeGetSchemeDetails = "GetSchemeDetails"
let kModeUpdateOrderStatus = "UpdateOrderStatus"
let kModePhotoUpdate = "PhotoUpdate"
let kModeAddManuallyPortfolio = "AddManuallyPortfolio"
let kModeDeleteManuallMFAccount = "DeleteManuallMFAccount"
let kModeDeleteManualMFTransaction = "DeleteManualMFTransaction"


let kModeSyncAppConf = "SyncAppConf"
let kModeSyncMFAccount = "SyncMFAccount"
let kModeSyncManualTxnx = "SyncManualTxnx"
let kModeSyncOrders = "SyncOrders"
let kModeSyncDynamicText = "SyncDynamicText"
let kModeSyncPayeezzMandate = "SyncPayeezzMandate"

let kModegeneratestatement = "generatestatement"
let kModeUserActionTracking = "UserAction"

let kModeSaveFeeback = "SaveFeeback"

// FETHING THE DEFAULT DEVICE TOKEN CREDENTIALS...
let tokenEmailId = "WealthTrustBasic"
let tokenPassword = "B@sic110$"

// WEB APIS KEYS DECLARED HERE....
let kEmailId = "EmailId"
let kPassWord = "PassWord"
let kMobileNo = "MobileNo"

let kWAPIResponseStatus = "WAPIResponseStatus"
let kWAPIResponse   = "WAPIResponse"

let kToken = "Token"

let kSyncFromDateTime = "SyncFromDateTime"
let kWAPIServerTimeIST = "WAPIServerTimeIST"
let kWAPIServerTimeISTSyncUserAccount = "WAPIServerTimeISTSyncUserAccount"
let kWAPIServerTimeISTSyncMFAccount = "WAPIServerTimeISTSyncMFAccount" // NOT COMING..
let kWAPIServerTimeISTSyncManualTxnx = "WAPIServerTimeISTSyncManualTxnx"
let kWAPIServerTimeISTSyncOrders = "WAPIServerTimeISTSyncOrders"
let kWAPIServerTimeISTSyncDynamicText = "WAPIServerTimeISTSyncDynamicText"
let kWAPIServerTimeISTSyncPayeezzMandate = "WAPIServerTimeISTSyncPayeezzMandate"


class WebManagerHK: NSObject {

    // Initial Setup URLs.... To Load the request..
    class func postDataToURL(mode : String, params : AnyObject, message : String, completionSuccess : (AnyObject)->Void) {
        
        if SharedManager.isNetAvailable() {
            
            if message.characters.count>0 {
                SVProgressHUD.showWithStatus(message)
                SVProgressHUD.setDefaultAnimationType(SVProgressHUDAnimationType.Flat)
            }
            
            let domainURL = URL_DOMAIN + mode
            let urlToRequestOn = domainURL
            
            // Setup the session to make REST POST call
            let postEndpoint: String = urlToRequestOn
            print("URL TO REQUEST : "+postEndpoint)
            
            let url = NSURL(string: postEndpoint)!
            
            let session = NSURLSession.sharedSession()
            let postParams = params
            
            // Create the request
            let request = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            //        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.timeoutInterval = 45 // Set your timeout interval here.
            
            // kToken : sharedInstance.userDefaults.objectForKey(kToken)!

            if mode==kModeClientlogincheck
            {
            }else{
                request.addValue(sharedInstance.userDefaults.objectForKey(kToken)! as! String, forHTTPHeaderField: kToken)
                request.addValue("IOS", forHTTPHeaderField: "OS")
                request.addValue("1.0", forHTTPHeaderField: "AndroidAppVersion")
            }
            
            do {
                    request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(postParams, options: NSJSONWritingOptions())

            } catch {
                print("bad things happened")
            }
            
            let dataTask = session.dataTaskWithRequest(request) { (data, response, error) in
                
                SVProgressHUD .dismiss()
                
                let realResponse1 = response as? NSHTTPURLResponse
                print(realResponse1?.statusCode)
                if realResponse1?.statusCode == 401 // If Unauthorized Token 401 then we have to get new token again...
                {
                    let allUser = DBManager.getInstance().getAllUser()
                    if allUser.count==0
                    {
                        // API Call
                        let dicToSend:NSDictionary = [
                            kEmailId : tokenEmailId
                            ,kPassWord : tokenPassword]
                        WebManagerHK.postDataToURL(kModeClientlogincheck, params: dicToSend, message: "") { (response) in
                            
                            print("Dic Response : \(response)")
                            let mainResponse = response.objectForKey(kWAPIResponse) as! NSDictionary
                            let tokenFetched = mainResponse.objectForKey(kToken) as! String
                            sharedInstance.userDefaults.setObject(tokenFetched, forKey: kToken)
                        }
                    }else{
                        let objUser = allUser.objectAtIndex(0) as! User
                        sharedInstance.objLoginUser = objUser
                        
                        // API Call
                        let dicToSend:NSDictionary = [
                            kEmailId : sharedInstance.objLoginUser.email
                            ,kPassWord : sharedInstance.objLoginUser.password]
                        WebManagerHK.postDataToURL(kModeClientlogincheck, params: dicToSend, message: "") { (response) in
                            print("Dic Response : \(response)")
                            let mainResponse = response.objectForKey(kWAPIResponse) as! NSDictionary
                            let tokenFetched = mainResponse.objectForKey(kToken) as! String
                            sharedInstance.userDefaults.setObject(tokenFetched, forKey: kToken)
                        }
                    }
                }

                // Make sure we get an OK response
                guard let realResponse = response as? NSHTTPURLResponse,
                    realResponse.statusCode == 200 else {
                        
                        print("Not a 200 response ")
                        
                        // Unauthorized Token 401
                        // Timeout 45 seconds...
                        return
                }
                do{
                    
                    let response = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                    
                    let responseStatus = response.objectForKey(kWAPIResponseStatus) as! String
                    
                    if responseStatus=="OK"
                    {
                        completionSuccess(response)
                        
                    }else
                    {
                        if mode==kModeClientlogincheck
                        {
                            sharedInstance.generateToken()
                        }
                        if responseStatus=="Error"
                        {
                            
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                
                                SharedManager.invokeAlertMethod(APP_NAME, strBody: "There are some problem connecting server! Please try again later", delegate: nil)
                                
                            })

                        }
                    }
                    
                }catch{
                }
            }
            dataTask.resume()
        }
        else
        {
            SharedManager.invokeAlertMethod(APP_NAME, strBody: ALERT_INTERNET, delegate: nil)
        }
    }
    
    
    // Initial Setup URLs.... To Load the request..
    class func getDataToURL(mode : String, params : AnyObject, message : String, completionSuccess : (AnyObject)->Void) {
        
        if SharedManager.isNetAvailable() {
            
            if message.characters.count>0 {
                SVProgressHUD.showWithStatus(message)
                SVProgressHUD.setDefaultAnimationType(SVProgressHUDAnimationType.Flat)
            }
            
            let domainURL = URL_DOMAIN + mode
            let urlToRequestOn = domainURL
            
            // Setup the session to make REST POST call
            let postEndpoint: String = urlToRequestOn
            print("URL TO REQUEST : "+postEndpoint)
            
            let url = NSURL(string: postEndpoint)!
            
            let session = NSURLSession.sharedSession()
            let postParams = params
            
            // Create the request
            let request = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            //        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.timeoutInterval = 45 // Set your timeout interval here.
            
            // kToken : sharedInstance.userDefaults.objectForKey(kToken)!
            
            if mode==kModeClientlogincheck
            {
                
            }else{
                request.addValue(sharedInstance.userDefaults.objectForKey(kToken)! as! String, forHTTPHeaderField: kToken)
                request.addValue("IOS", forHTTPHeaderField: "OS")
                request.addValue("1.0", forHTTPHeaderField: "AndroidAppVersion")

            }
            
            
            
//            do {
//                request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(postParams, options: NSJSONWritingOptions())
//                print(params)
//                
//            } catch {
//                print("bad things happened")
//            }
            
            let dataTask = session.dataTaskWithRequest(request) { (data, response, error) in
                
                SVProgressHUD .dismiss()
                
                let realResponse1 = response as? NSHTTPURLResponse
                print(realResponse1?.statusCode)
                if realResponse1?.statusCode == 401 // If Unauthorized Token 401 then we have to get new token again...
                {
                    
                    let allUser = DBManager.getInstance().getAllUser()
                    if allUser.count==0
                    {
                        // API Call
                        let dicToSend:NSDictionary = [
                            kEmailId : tokenEmailId
                            ,kPassWord : tokenPassword]
                        WebManagerHK.postDataToURL(kModeClientlogincheck, params: dicToSend, message: "") { (response) in
                            print("Dic Response : \(response)")
                            let mainResponse = response.objectForKey(kWAPIResponse) as! NSMutableDictionary
                            let tokenFetched = mainResponse.objectForKey(kToken) as! String
                            sharedInstance.userDefaults.setObject(tokenFetched, forKey: kToken)
                        }
                        
                    }else{
                        let objUser = allUser.objectAtIndex(0) as! User
                        sharedInstance.objLoginUser = objUser
                        
                        // API Call
                        let dicToSend:NSDictionary = [
                            kEmailId : sharedInstance.objLoginUser.email
                            ,kPassWord : sharedInstance.objLoginUser.password]
                        WebManagerHK.postDataToURL(kModeClientlogincheck, params: dicToSend, message: "") { (response) in
                            print("Dic Response : \(response)")
                            let mainResponse = response.objectForKey(kWAPIResponse) as! NSDictionary
                            let tokenFetched = mainResponse.objectForKey(kToken) as! String
                            sharedInstance.userDefaults.setObject(tokenFetched, forKey: kToken)
                        }
                        
                    }
                    
                    
                }
                
                // Make sure we get an OK response
                guard let realResponse = response as? NSHTTPURLResponse,
                    realResponse.statusCode == 200 else {
                        
                        print("Not a 200 response ")
                        
                        // Unauthorized Token 401
                        // Timeout 45 seconds...
                        return
                }
                do{
                    
                    let response = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                    
                    let responseStatus = response.objectForKey(kWAPIResponseStatus) as! String
                    
                    if responseStatus=="OK"
                    {
                        completionSuccess(response)
                        
                    }else
                    {
                        if mode==kModeClientlogincheck
                        {
                            sharedInstance.generateToken()
                        }
                        if responseStatus=="Error"
                        {
                            
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                
                                SharedManager.invokeAlertMethod(APP_NAME, strBody: "There are some problem connecting server! Please try again later", delegate: nil)
                                
                            })
                            
                        }
                        
                    }
                    
                }catch{
                }
            }
            dataTask.resume()
        }
        else
        {
            SharedManager.invokeAlertMethod(APP_NAME, strBody: ALERT_INTERNET, delegate: nil)
        }
    }


}
