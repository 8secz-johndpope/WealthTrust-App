//
//  SignatureScreen.swift
//  WealthTrust
//
//  Created by Hemen Gohil on 9/8/16.
//  Copyright © 2016 Hemen Gohil. All rights reserved.
//

import UIKit

class SignatureScreen: UIViewController,YPDrawSignatureViewDelegate {

    @IBOutlet weak var btnClear = UIButton()
    @IBOutlet weak var btnSubmit = UIButton()
    
    // Connect this Outlet to the Signature View
    @IBOutlet weak var drawSignatureView: YPDrawSignatureView!

    @IBOutlet weak var lblMessage: UILabel!
    
    var isFrom = IS_FROM.Profile

    var dicToSend = NSMutableDictionary()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        drawSignatureView.delegate = self
        
        drawSignatureView.layer.cornerRadius = 3.0
        drawSignatureView.layer.borderColor = UIColor.darkGrayColor().CGColor
        drawSignatureView.layer.borderWidth = 1
        // Do any additional setup after loading the view.
        
        btnSubmit!.layer.cornerRadius = 1
        btnClear!.layer.borderColor = UIColor.defaultOrangeButton.CGColor
        
        btnClear!.layer.cornerRadius = 1;
        btnClear!.layer.borderColor = UIColor.defaultOrangeButton.CGColor
        btnClear!.layer.borderWidth = 1.0
        
//        let value = UIInterfaceOrientation.LandscapeLeft.rawValue
//        UIDevice.currentDevice().setValue(value, forKey: "orientation")
        
        print("Prepared Data To Send Signature \(dicToSend)")
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        let value = UIInterfaceOrientation.LandscapeLeft.rawValue
        UIDevice.currentDevice().setValue(value, forKey: "orientation")
        
    }

    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Landscape
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btnClearClicked(sender: AnyObject) {
        // This is how the signature gets cleared
        self.drawSignatureView.clearSignature()
    }
    
    @IBAction func btnSubmitClicked(sender: AnyObject) {


        
        // Getting the Signature Image from self.drawSignatureView using the method getSignature().
        if let signatureImage = self.drawSignatureView.getSignature(scale: 10) {
            // Saving signatureImage from the line above to the Photo Roll.
            // The first time you do this, the app asks for access to your pictures.
//            UIImageWriteToSavedPhotosAlbum(signatureImage, nil, nil, nil)
            
//            // Since the Signature is now saved to the Photo Roll, the View can be cleared anyway.
//            self.drawSignatureView.clearSignature()
            
            let arrDic = dicToSend["ImageArr"] as! NSMutableArray
            
            //let imafe = signatureImage.resizedImageWithSize(CGSize(width: 240, height: 120))
//            let imageData:NSData = UIImagePNGRepresentation(imafe)!
            let image = SharedManager.sharedInstance.resizeImage(signatureImage, newWidth: 240, newHeight: 120)
            let imageData:NSData = UIImageJPEGRepresentation(image, 1)!

//                let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//                let documentsDirectory = paths[0]
//
//            if let image = UIImage(named: "example.png") {
//                if let data = UIImagePNGRepresentation(image) {
//                    let filename = documentsDirectory.appendingPathComponent("copy.png")
//                    try? data.write(to: filename)
//                }
//            }

            
            
            //let strBase64Selfie:String = imageData.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
            
            let strBase64Selfie:String = image.getBase64(imageData)
            
            let OtherSelg = "data:image/jpeg;base64,\(strBase64Selfie)"
            
            arrDic.addObject(["DocumentType":"\(DocumentType.Signature.hashValue)","SendCopyType" : "App","DocumentData" : OtherSelg])

            dicToSend["ImageArr"] = arrDic
            
        }else{
            SharedManager.invokeAlertMethod(APP_NAME, strBody: "Please draw signature!", delegate: nil)
            return
        }

        print("Registering Info \(dicToSend)")
        
        WebManagerHK.postDataToURL(kModeMFUAccountInfo, params: dicToSend, message: "Registering Info...") { (response) in
            
            print("Dic Response : \(response)")
            
            if response is NSDictionary
            {
                let mainResponse = String(response.objectForKey(kWAPIResponse)!)
                if mainResponse=="-2"
                {
//                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                        SharedManager.invokeAlertMethod(APP_NAME, strBody: "Something went wrong, Please try again!", delegate: nil)
//                    })
                    return
                }
            }
            
            if response.objectForKey(kWAPIResponse) is NSDictionary
            {
                let mainResponse = response.objectForKey(kWAPIResponse) as! NSDictionary
//                //    WAPIResponse =     {
//                ClientId = 1481;
//                EmailId = "HemenTest8@email.com";
//                InvestmentAOFStatus = 1;
//                InvestmentAOFStatusArr = "<null>";
//                Name = "SANDEEP CHAVAN";
//                SignUpStatus = 1;
//                SignUpStatusArr = "<null>";
//            };
//            WAPIResponseStatus = OK;

                
                // UPDATE DB...
                ////         UPDATE USER..
                let userInfo: User = User()
                userInfo.ClientID = sharedInstance.objLoginUser.ClientID
                userInfo.Name = sharedInstance.objLoginUser.Name
                userInfo.email = sharedInstance.objLoginUser.email
                userInfo.mob = sharedInstance.objLoginUser.mob
                userInfo.password = sharedInstance.objLoginUser.password
                userInfo.CAN = sharedInstance.objLoginUser.CAN
                sharedInstance.objLoginUser.SignupStatus = "1" // Created Status....
                userInfo.SignupStatus = sharedInstance.objLoginUser.SignupStatus
                
                sharedInstance.objLoginUser.InvestmentAofStatus = "1" // Processing Status....
                userInfo.InvestmentAofStatus = sharedInstance.objLoginUser.InvestmentAofStatus
                
                print("INSERTED DATA \(userInfo)")
                
                let isInserted = DBManager.getInstance().updateUser(userInfo)
                if isInserted {
                    
                } else {
                    SharedManager.invokeAlertMethod("", strBody: "Error in saving record.", delegate: nil)
                }
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    print(self.isFrom)
                    
                    if self.isFrom == .SwitchToDirect
                    {
                        SharedManager.sharedInstance.userDefaults .setObject("Select Fund", forKey: kSelectFromFundValue)
                        SharedManager.sharedInstance.userDefaults .setObject("Select Fund", forKey: kSelectToFundValue)

                        for viewController in (self.navigationController?.viewControllers)! {
                            
                            if viewController.isKindOfClass(SwitchScreen) {
                                self.navigationController?.popToViewController(viewController, animated: true)
                                return
                            }
                        }
                        
                        let objUserProfile = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdSwitchScreen) as! SwitchScreen
                        self.navigationController?.viewControllers.insert(objUserProfile, atIndex: 1)
                        print(self.navigationController?.viewControllers)
                        
                        for viewController in (self.navigationController?.viewControllers)! {
                            
                            if viewController.isKindOfClass(SwitchScreen) {
                                self.navigationController?.popToViewController(viewController, animated: true)
                                return
                            }
                        }
                        
                    }
                    else if(self.isFrom == .BuySIP)
                    {
                     
                        SharedManager.sharedInstance.userDefaults .setObject(kEnterSchemeName, forKey: kSelectBuyNowScheme)
                        
                        for viewController in (self.navigationController?.viewControllers)! {
                            
                            if viewController.isKindOfClass(BuyScreeen) {
                                self.navigationController?.popToViewController(viewController, animated: true)
                                return
                            }
                        }
                        
                        let objUserProfile = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdBuyScreeen) as! BuyScreeen
                        self.navigationController?.viewControllers.insert(objUserProfile, atIndex: 1)
                        print(self.navigationController?.viewControllers)
                        
                        for viewController in (self.navigationController?.viewControllers)! {
                            
                            if viewController.isKindOfClass(BuyScreeen) {
                                self.navigationController?.popToViewController(viewController, animated: true)
                                return
                            }
                        }
                    }
                    else if(self.isFrom == .BuySIPFromTopFunds)
                    {
                        
                        for viewController in (self.navigationController?.viewControllers)! {
                            
                            if viewController.isKindOfClass(BuyScreeen) {
                                let objBuyScreen = viewController as! BuyScreeen
                                objBuyScreen.isBuyFrom = kBUY_FROM_SELECTED_FUND
                                objBuyScreen.isExisting = true
                                self.navigationController?.popToViewController(objBuyScreen, animated: true)
                                return
                            }
                        }
                        
                        let objBuyScreen = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdBuyScreeen) as! BuyScreeen
                        objBuyScreen.isBuyFrom = kBUY_FROM_SELECTED_FUND
                        objBuyScreen.isExisting = true
                        self.navigationController?.viewControllers.insert(objBuyScreen, atIndex: 2)
                        print(self.navigationController?.viewControllers)
                        
                        for viewController in (self.navigationController?.viewControllers)! {
                            if viewController.isKindOfClass(BuyScreeen) {
                                self.navigationController?.popToViewController(viewController, animated: true)
                                return
                            }
                        }
                    }
                    else if(self.isFrom == .BuySIPFromSearch)
                    {
                        
                        for viewController in (self.navigationController?.viewControllers)! {
                            
                            if viewController.isKindOfClass(BuyScreeen) {
                                let objBuyScreen = viewController as! BuyScreeen
                                objBuyScreen.isBuyFrom = kBUY_FROM_SELECTED_FUND
                                objBuyScreen.isExisting = true
                                self.navigationController?.popToViewController(objBuyScreen, animated: true)
                                return
                            }
                        }
                        
                        let objBuyScreen = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdBuyScreeen) as! BuyScreeen
                        objBuyScreen.isBuyFrom = kBUY_FROM_SELECTED_FUND
                        objBuyScreen.isExisting = true
                        self.navigationController?.viewControllers.insert(objBuyScreen, atIndex: 2)
                        print(self.navigationController?.viewControllers)
                        
                        for viewController in (self.navigationController?.viewControllers)! {
                            if viewController.isKindOfClass(BuyScreeen) {
                                self.navigationController?.popToViewController(viewController, animated: true)
                                return
                            }
                        }
                    }
                    else if(self.isFrom == .BuySIPFromPortfolio)
                    {
                        
                        for viewController in (self.navigationController?.viewControllers)! {
                            
                            if viewController.isKindOfClass(BuyScreeen) {
                                let objBuyScreen = viewController as! BuyScreeen
                                objBuyScreen.isBuyFrom = kBUY_FROM_SELECTED_FUND
                                objBuyScreen.isExisting = true
                                self.navigationController?.popToViewController(objBuyScreen, animated: true)
                                return
                            }
                        }
                        
                        let objBuyScreen = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdBuyScreeen) as! BuyScreeen
                        objBuyScreen.isBuyFrom = kBUY_FROM_SELECTED_FUND
                        objBuyScreen.isExisting = true
                        self.navigationController?.viewControllers.insert(objBuyScreen, atIndex: 2)
                        print(self.navigationController?.viewControllers)
                        
                        for viewController in (self.navigationController?.viewControllers)! {
                            if viewController.isKindOfClass(BuyScreeen) {
                                self.navigationController?.popToViewController(viewController, animated: true)
                                return
                            }
                        }
                    }
                    else
                    {
                        for viewController in (self.navigationController?.viewControllers)! {
                            
                            if viewController.isKindOfClass(UserProfile) {
                                self.navigationController?.popToViewController(viewController, animated: true)
                                return
                            }
                        }
                        
                        let objUserProfile = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdUserProfile)
                        self.navigationController?.viewControllers.insert(objUserProfile!, atIndex: 1)
                        print(self.navigationController?.viewControllers)
                        
                        for viewController in (self.navigationController?.viewControllers)! {
                            
                            if viewController.isKindOfClass(UserProfile) {
                                self.navigationController?.popToViewController(viewController, animated: true)
                                return
                            }
                        }
                    }
                })
            }
        }
    }
    
    // The delegate methods gives feedback to the instanciating class
    func finishedSignatureDrawing() {
        print("Finished")
    }
    
    func startedSignatureDrawing() {
        print("Started")
        lblMessage.hidden = true
    }
    


    @IBAction func btnBackClicked(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //        let n: Int! = self.navigationController?.viewControllers.count
    //        let myUIViewController = self.navigationController?.viewControllers[n-2]
    //        if ((myUIViewController?.isKindOfClass(OtherInfo)) != nil) {
    //            print(myUIViewController)
    //            let otherInfo = myUIViewController as! OtherInfo
    //
    //            if !otherInfo.validateStep1() {
    //                print("Step 1 is incomplete....")
    ////                otherInfo.currentMode = InfoMode.PersonalInfoMode
    ////                otherInfo.btnPersonalInfoClicked(otherInfo.btn1)
    //
    //                self.navigationController?.popViewControllerAnimated(true)
    //
    //                SharedManager.invokeAlertMethod(APP_NAME, strBody: "Please fill Personal Info.", delegate: nil)
    //
    //            }else if !otherInfo.validateStep2(){
    //                print("Step 2 is incomplete....")
    ////                otherInfo.currentMode = InfoMode.BankInfoMode
    ////                otherInfo.btnBankInfoClicked(otherInfo.btn2)
    //
    //                self.navigationController?.popViewControllerAnimated(true)
    //
    //                SharedManager.invokeAlertMethod(APP_NAME, strBody: "Please fill Bank Info.", delegate: nil)
    //
    //            }else if !otherInfo.validateStep3(){
    //                print("Step 3 is incomplete....")
    ////                otherInfo.currentMode = InfoMode.IdentitykInfoMode
    ////                otherInfo.btnIdentityInfoClicked(otherInfo.btn3)
    //
    //                self.navigationController?.popViewControllerAnimated(true)
    //
    //                SharedManager.invokeAlertMethod(APP_NAME, strBody: "Please fill Identity Info.", delegate: nil)
    //
    //            }else if !otherInfo.validateStep4(){
    //                print("Step 4 is incomplete....")
    ////                otherInfo.currentMode = InfoMode.NominyInfoMode
    ////                otherInfo.btnNomineeInfoClicked(otherInfo.btn4)
    //
    //                self.navigationController?.popViewControllerAnimated(true)
    //
    //                SharedManager.invokeAlertMethod(APP_NAME, strBody: "Please fill Nominee Info.", delegate: nil)
    //
    //            }else{
    //                print("All Completet...")
    //                
    //            }
    //        }

}


