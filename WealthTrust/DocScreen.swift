//
//  DocScreen.swift
//  WealthTrust
//
//  Created by Hemen Gohil on 9/7/16.
//  Copyright © 2016 Hemen Gohil. All rights reserved.
//

import UIKit

class DocScreen: UIViewController {
    
    @IBOutlet weak var btnNext: UIButton!

    @IBOutlet weak var viewCameraPanBank: UIView!
    @IBOutlet weak var viewCameraPan: UIView!
    @IBOutlet weak var viewCameraBank: UIView!

    var isFrom = IS_FROM.Profile

    @IBAction func btnBackTap(sender: AnyObject) {
        if let navController = self.navigationController {
            navController.popViewControllerAnimated(true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SharedManager.addShadow(btnNext)

        if self.isFrom == .SwitchToDirect
        {
            viewCameraPan.hidden = false
            viewCameraPanBank.hidden = true
            viewCameraBank.hidden = true

        }else{
            
            if DBManager.getInstance().getLoggedInUserDetails().SignupStatus == "\(SIGNUP_STATUS.PANVERIFICATIONPENDING4.hashValue)"
            {
                viewCameraPan.hidden = true
                viewCameraBank.hidden = true
                viewCameraPanBank.hidden = false
            }
            else
            {
                // Show image with Camera and bank icon
                viewCameraPan.hidden = true
                viewCameraPanBank.hidden = true
                viewCameraBank.hidden = false
            }
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func btnNextClicked(sender: AnyObject) {
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            if self.isFrom == .BuySIP
            {
                if DBManager.getInstance().getLoggedInUserDetails().SignupStatus == "\(SIGNUP_STATUS.PANVERIFICATIONPENDING4.hashValue)"
                {
                    let objPanVerificationScreen = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdPanVerificationScreen) as! PanVerificationScreen
                    objPanVerificationScreen.isFrom = self.isFrom
                    
                    self.navigationController?.pushViewController(objPanVerificationScreen, animated: true)
                }
                else
                {
                    let objOtherInfo = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdOtherInfo) as! OtherInfo
                    objOtherInfo.isFrom = self.isFrom
                    self.navigationController?.pushViewController(objOtherInfo, animated: true)
                }
                
            }
            else if(self.isFrom == .BuySIPFromTopFunds)
            {
                if DBManager.getInstance().getLoggedInUserDetails().SignupStatus == "\(SIGNUP_STATUS.PANVERIFICATIONPENDING4.hashValue)"
                {
                    let objPanVerificationScreen = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdPanVerificationScreen) as! PanVerificationScreen
                    objPanVerificationScreen.isFrom = self.isFrom
                    
                    self.navigationController?.pushViewController(objPanVerificationScreen, animated: true)
                }
                else
                {
                    let objOtherInfo = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdOtherInfo) as! OtherInfo
                    objOtherInfo.isFrom = self.isFrom
                    self.navigationController?.pushViewController(objOtherInfo, animated: true)
                }
            }
            else if(self.isFrom == .BuySIPFromSearch)
            {
                if DBManager.getInstance().getLoggedInUserDetails().SignupStatus == "\(SIGNUP_STATUS.PANVERIFICATIONPENDING4.hashValue)"
                {
                    let objPanVerificationScreen = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdPanVerificationScreen) as! PanVerificationScreen
                    objPanVerificationScreen.isFrom = self.isFrom
                    
                    self.navigationController?.pushViewController(objPanVerificationScreen, animated: true)
                }
                else
                {
                    let objOtherInfo = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdOtherInfo) as! OtherInfo
                    objOtherInfo.isFrom = self.isFrom
                    self.navigationController?.pushViewController(objOtherInfo, animated: true)
                }
            }
            else if(self.isFrom == .BuySIPFromPortfolio)
            {
                let objOtherInfo = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdOtherInfo) as! OtherInfo
                objOtherInfo.isFrom = self.isFrom
                self.navigationController?.pushViewController(objOtherInfo, animated: true)
            }
            else
            {
                if DBManager.getInstance().getLoggedInUserDetails().SignupStatus == "\(SIGNUP_STATUS.PANVERIFICATIONPENDING4.hashValue)"
                {
                    let objPanVerificationScreen = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdPanVerificationScreen) as! PanVerificationScreen
                    objPanVerificationScreen.isFrom = self.isFrom
                    
                    self.navigationController?.pushViewController(objPanVerificationScreen, animated: true)
                }
                else
                {
                    let objOtherInfo = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdOtherInfo) as! OtherInfo
                    objOtherInfo.isFrom = self.isFrom
                    self.navigationController?.pushViewController(objOtherInfo, animated: true)
                }
            }
            
        })
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
