//
//  UserProfile.swift
//  WealthTrust
//
//  Created by Hemen Gohil on 9/14/16.
//  Copyright © 2016 Hemen Gohil. All rights reserved.
//

import UIKit

class UserProfile: UIViewController,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    var objUser = User()
    
    @IBOutlet weak var view1: UIView!
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblMobile: UILabel!
    @IBOutlet weak var lblEmail: UILabel!

    @IBOutlet weak var tblView: UITableView!
    
//    @IBOutlet weak var lblSignUpStatus: UILabel!
//    @IBOutlet weak var lblInvestmentAccountStatus: UILabel!
//    @IBOutlet weak var btnCreateInvestmentAccount: UIButton!
    
    
    var imagePicked : UIImage!
    let picker = UIImagePickerController()
    var imageToUpload = "Selfie"
    var isSignupSelfieInvalid = false
    var isInvestSignatureInvalid = false


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        let value = UIInterfaceOrientation.Portrait.rawValue
        UIDevice.currentDevice().setValue(value, forKey: "orientation")

        SharedManager.addShadowToView(view1)
        
        self.fetchDetails()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func fetchDetails()
    {
        let allUser = DBManager.getInstance().getAllUser()
        if allUser.count==0{
        }else{
            
            objUser = allUser.objectAtIndex(0) as! User
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.lblName.text = self.objUser.Name
                self.lblEmail.text = self.objUser.email
                self.lblMobile.text = self.objUser.mob
            })
            
            isSignupSelfieInvalid = false
            if objUser.SignupStatus=="3" { // Invalid Selfie..
                
                let userSignUpInfo: AOFStatus = AOFStatus()
                userSignUpInfo.ClientID = objUser.ClientID
                
                let arrRecord = DBManager.getInstance().getSignUpStatusRecord(userSignUpInfo)
                if arrRecord.count==0 {
                    print("No Record Found!!")
                } else {
                    let objAOFStatusRecord = arrRecord.objectAtIndex(0) as! AOFStatus
                    if objAOFStatusRecord.selfie=="0" {
                        isSignupSelfieInvalid = true
                    }
                }
            }
            
            isInvestSignatureInvalid = false
            if objUser.InvestmentAofStatus=="4" { // Invalid Signature
                
                let userInvestmentInfo: AOFStatus = AOFStatus()
                userInvestmentInfo.ClientID = objUser.ClientID
                
                let arrInveRecord = DBManager.getInstance().getInvetmentAOFRecord(userInvestmentInfo)
                if arrInveRecord.count==0 {
                    print("No Record Found!!")
                } else {
                    let objAOFStatusRecord = arrInveRecord.objectAtIndex(0) as! AOFStatus
                    if objAOFStatusRecord.signaturemismatch=="0"
                    {
                        isInvestSignatureInvalid = true
                    }
                }
            }
            if objUser.InvestmentAofStatus=="\(INVESTMENTAACCOUNT_STATUS.PENDING0.hashValue)" //Pending
            {
                
            }else if objUser.InvestmentAofStatus=="\(INVESTMENTAACCOUNT_STATUS.PROCESSING1.hashValue)" //            Processing
            {
            }
            else if objUser.InvestmentAofStatus=="\(INVESTMENTAACCOUNT_STATUS.CANGENERATED2.hashValue)" //CanGenerated
            {
                
            }
            else if objUser.InvestmentAofStatus=="\(INVESTMENTAACCOUNT_STATUS.VERIFIED3.hashValue)" //CanVerified
            {
                
            }
            else if objUser.InvestmentAofStatus=="\(INVESTMENTAACCOUNT_STATUS.INVALID4.hashValue)" && isInvestSignatureInvalid == true //Invalid Signature
            {
                
            }
            else if objUser.InvestmentAofStatus=="\(INVESTMENTAACCOUNT_STATUS.INVALID4.hashValue)" && isInvestSignatureInvalid == false //Invalid Without Signature
            {
                
            }
            
            if objUser.SignupStatus=="\(SIGNUP_STATUS.PENDING0.hashValue)" // PENDING.. THIS WILL NOT IN USE...
            {
            }
            else if objUser.SignupStatus=="\(SIGNUP_STATUS.CREATED1.hashValue)" || objUser.SignupStatus=="\(SIGNUP_STATUS.PANVERIFICATIONPENDING4.hashValue)" // CREATED...
            {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    //                 Pan Verification Pending... Signupstatus is 4
                    self.lblName.text = self.objUser.Name
                    self.lblEmail.text = self.objUser.email
                    self.lblMobile.text = self.objUser.mob
                })
            }
            else if objUser.SignupStatus=="\(SIGNUP_STATUS.VERIFIED2.hashValue)" // VERIFIED....
            {
            }
            else if objUser.SignupStatus=="\(SIGNUP_STATUS.INVALID3.hashValue)" || isSignupSelfieInvalid == true // INVALID & EEOR SELPHIE
            {
            }
            else if objUser.SignupStatus=="\(SIGNUP_STATUS.INVALID3.hashValue)" || isSignupSelfieInvalid == false // INVALID & EEOR SELPHIE
            {
            }
            
            
            // UPDATE STATUS FROM HERE TEMPORARY
            
//            objUser.SignupStatus = "\(SIGNUP_STATUS.PANVERIFICATIONPENDING4.hashValue)"
//            isSignupSelfieInvalid = true
//            
//            objUser.InvestmentAofStatus="\(INVESTMENTAACCOUNT_STATUS.INVALID4.hashValue)"
//            isInvestSignatureInvalid = true
//
//            objUser.InvestmentAofStatus="\(INVESTMENTAACCOUNT_STATUS.VERIFIED3.hashValue)"
            
            self.tblView.delegate = self
            self.tblView.dataSource = self
            self.tblView.reloadData()
            
            
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func btnUserProfile(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        //        print(enumOccupation.hashValue)
        //        print(enumSourceOfWealth.hashValue)
        
        let string = "CELL_ALL_\(objUser.SignupStatus)_\(objUser.InvestmentAofStatus)"
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: string)
        
        let cell = tableView.dequeueReusableCellWithIdentifier(string, forIndexPath: indexPath) as UITableViewCell

        if indexPath.row == 0 { // Signup Status UI
            if (cell.contentView.subviews.count==0) {
                
                let view = UIView(frame: CGRect(x: 2, y: 5, width: tableView.frame.size.width-4, height: 90))
                view.backgroundColor = UIColor.whiteColor()
                cell.contentView.addSubview(view)
                SharedManager.addShadowToView(view)

                
                if objUser.SignupStatus=="\(SIGNUP_STATUS.PENDING0.hashValue)" // PENDING.. THIS WILL NOT IN USE...
                {
                }else if objUser.SignupStatus=="\(SIGNUP_STATUS.CREATED1.hashValue)" || objUser.SignupStatus=="\(SIGNUP_STATUS.PANVERIFICATIONPENDING4.hashValue)" // CREATED...
                {
                    view.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.size.width, height: 60)
                    
                    var lblSignStatus : UILabel!
                    lblSignStatus = UILabel(frame: CGRect(x: 10, y: 5, width: (view.frame.size.width)-20, height: 20));
                    lblSignStatus.text = "Sign up Status"
                    lblSignStatus.font = UIFont.systemFontOfSize(15)
                    lblSignStatus.textColor = UIColor.blackColor().colorWithAlphaComponent(0.87)
                    view.addSubview(lblSignStatus)
                    
                    var lblLine : UILabel!
                    lblLine = UILabel(frame: CGRect(x: 10, y: 30, width: (view.frame.size.width)-20, height: 1));
                    lblLine.backgroundColor = UIColor.init(red: 220, green: 220, blue: 220)
                    view.addSubview(lblLine)
                    
                    var lblSignS : UILabel!
                    lblSignS = UILabel(frame: CGRect(x: 10, y: 35, width: (view.frame.size.width)-20, height: 20));
                    lblSignS.text = "Status : Created"
                    lblSignS.font = UIFont.systemFontOfSize(13)
                    lblSignS.textColor = UIColor.blackColor().colorWithAlphaComponent(0.87)
                    view.addSubview(lblSignS)
                    
                }
                else if objUser.SignupStatus=="\(SIGNUP_STATUS.VERIFIED2.hashValue)" // VERIFIED....
                {
                    view.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.size.width, height: 60)
                    
                    var lblSignStatus : UILabel!
                    lblSignStatus = UILabel(frame: CGRect(x: 10, y: 5, width: (view.frame.size.width)-20, height: 20));
                    lblSignStatus.text = "Sign up Status"
                    lblSignStatus.font = UIFont.systemFontOfSize(15)
                    lblSignStatus.textColor = UIColor.blackColor().colorWithAlphaComponent(0.87)
                    view.addSubview(lblSignStatus)
                    
                    var lblLine : UILabel!
                    lblLine = UILabel(frame: CGRect(x: 10, y: 30, width: (view.frame.size.width)-20, height: 1));
                    lblLine.backgroundColor = UIColor.init(red: 220, green: 220, blue: 220)
                    view.addSubview(lblLine)
                    
                    var lblSignS : UILabel!
                    lblSignS = UILabel(frame: CGRect(x: 10, y: 35, width: (view.frame.size.width)-20, height: 20));
                    lblSignS.text = "Status : Verified"
                    lblSignS.font = UIFont.systemFontOfSize(13)
                    lblSignS.textColor = UIColor.blackColor().colorWithAlphaComponent(0.87)
                    view.addSubview(lblSignS)

                }
                else if objUser.SignupStatus=="\(SIGNUP_STATUS.INVALID3.hashValue)" && isSignupSelfieInvalid == false // INVALID & EEOR SELPHIE
                {
                    
                    view.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.size.width, height: 95)
                    
                    var lblSignStatus : UILabel!
                    lblSignStatus = UILabel(frame: CGRect(x: 10, y: 5, width: (view.frame.size.width)-20, height: 20));
                    lblSignStatus.text = "Sign up Status"
                    lblSignStatus.font = UIFont.systemFontOfSize(15)
                    lblSignStatus.textColor = UIColor.blackColor().colorWithAlphaComponent(0.87)
                    view.addSubview(lblSignStatus)
                    
                    var lblLine : UILabel!
                    lblLine = UILabel(frame: CGRect(x: 10, y: 30, width: (view.frame.size.width)-20, height: 1));
                    lblLine.backgroundColor = UIColor.init(red: 220, green: 220, blue: 220)
                    view.addSubview(lblLine)
                    
                    var lblSignS : UILabel!
                    lblSignS = UILabel(frame: CGRect(x: 10, y: 35, width: (view.frame.size.width)-20, height: 20));
                    lblSignS.text = "Status : Unable to verify"
                    lblSignS.font = UIFont.systemFontOfSize(13)
                    lblSignS.textColor = UIColor.blackColor().colorWithAlphaComponent(0.87)
                    view.addSubview(lblSignS)

                    
                    var lblRemarks : UILabel!
                    lblRemarks = UILabel(frame: CGRect(x: 10, y: 55, width: 60, height: 20));
                    lblRemarks.text = "Remarks : "
                    lblRemarks.font = UIFont.systemFontOfSize(13)
                    lblRemarks.textColor = UIColor.blackColor().colorWithAlphaComponent(0.87)
                    view.addSubview(lblRemarks)
                    
                    var lblRemarksDe : UILabel!
                    lblRemarksDe = UILabel(frame: CGRect(x: 10+62, y: 55, width: (view.frame.size.width)-20-62, height: 35));
                    lblRemarksDe.text = "Please check your email and provide missing details."
                    lblRemarksDe.font = UIFont.systemFontOfSize(13)
                    lblRemarksDe.textColor = UIColor.blackColor().colorWithAlphaComponent(0.87)
                    view.addSubview(lblRemarksDe)
                    lblRemarksDe.numberOfLines = 0
                    lblRemarksDe.lineBreakMode = NSLineBreakMode.ByWordWrapping

                }
                else if objUser.SignupStatus=="\(SIGNUP_STATUS.INVALID3.hashValue)" && isSignupSelfieInvalid == true // INVALID & EEOR SELPHIE
                {
                    
                    view.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.size.width, height: 129)
                    
                    var lblSignStatus : UILabel!
                    lblSignStatus = UILabel(frame: CGRect(x: 10, y: 5, width: (view.frame.size.width)-20, height: 20));
                    lblSignStatus.text = "Sign up Status"
                    lblSignStatus.font = UIFont.systemFontOfSize(15)
                    lblSignStatus.textColor = UIColor.blackColor().colorWithAlphaComponent(0.87)
                    view.addSubview(lblSignStatus)
                    
                    var lblLine : UILabel!
                    lblLine = UILabel(frame: CGRect(x: 10, y: 30, width: (view.frame.size.width)-20, height: 1));
                    lblLine.backgroundColor = UIColor.init(red: 220, green: 220, blue: 220)
                    view.addSubview(lblLine)
                    
                    var lblSignS : UILabel!
                    lblSignS = UILabel(frame: CGRect(x: 10, y: 35, width: (view.frame.size.width)-20, height: 20));
                    lblSignS.text = "Status : Unable to verify"
                    lblSignS.font = UIFont.systemFontOfSize(13)
                    lblSignS.textColor = UIColor.blackColor().colorWithAlphaComponent(0.87)
                    view.addSubview(lblSignS)
                    
                    var lblRemarks : UILabel!
                    lblRemarks = UILabel(frame: CGRect(x: 10, y: 55, width: 60, height: 20));
                    lblRemarks.text = "Remarks : "
                    lblRemarks.font = UIFont.systemFontOfSize(13)
                    lblRemarks.textColor = UIColor.blackColor().colorWithAlphaComponent(0.87)
                    view.addSubview(lblRemarks)
                    
                    var lblRemarksDe : UILabel!
                    lblRemarksDe = UILabel(frame: CGRect(x: 10+62, y: 55, width: (view.frame.size.width)-20-62, height: 20));
                    lblRemarksDe.text = "Please Upload Selfie."
                    lblRemarksDe.font = UIFont.systemFontOfSize(13)
                    lblRemarksDe.textColor = UIColor.blackColor().colorWithAlphaComponent(0.87)
                    view.addSubview(lblRemarksDe)

                    let buttonUploadS = UIButton(frame: CGRect(x: view.frame.size.width-118, y: 85, width: 114, height: 36))
                    buttonUploadS.setTitle("UPLOAD SELFIE", forState: .Normal)
                    buttonUploadS.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                    buttonUploadS.backgroundColor = UIColor.defaultOrangeButton
                    buttonUploadS.titleLabel?.font = UIFont.systemFontOfSize(14)
                    buttonUploadS.layer.cornerRadius = 1.5
                    buttonUploadS.addTarget(self, action: #selector(UserProfile.btnInvalidSelfieClicked(_:)), forControlEvents: .TouchUpInside)
                    view.addSubview(buttonUploadS)

                }
            }
        }
        if indexPath.row == 1 { // Investment Status UI
            if (cell.contentView.subviews.count==0) {
                
                let view = UIView(frame: CGRect(x: 2, y: 5, width: tableView.frame.size.width-4, height: 90))
                view.backgroundColor = UIColor.whiteColor()
                cell.contentView.addSubview(view)
                SharedManager.addShadowToView(view)

                if objUser.InvestmentAofStatus=="\(INVESTMENTAACCOUNT_STATUS.PENDING0.hashValue)" //Pending
                {
                    view.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.size.width, height: 100)
                    
                    var lblSignStatus : UILabel!
                    lblSignStatus = UILabel(frame: CGRect(x: 10, y: 5, width: (view.frame.size.width)-20, height: 20));
                    lblSignStatus.text = "Investment Account Status"
                    lblSignStatus.font = UIFont.systemFontOfSize(15)
                    lblSignStatus.textColor = UIColor.blackColor().colorWithAlphaComponent(0.87)
                    view.addSubview(lblSignStatus)
                    
                    var lblLine : UILabel!
                    lblLine = UILabel(frame: CGRect(x: 10, y: 30, width: (view.frame.size.width)-20, height: 1));
                    lblLine.backgroundColor = UIColor.init(red: 220, green: 220, blue: 220)
                    view.addSubview(lblLine)
                    
                    var lblSignS : UILabel!
                    lblSignS = UILabel(frame: CGRect(x: 10, y: 35, width: (view.frame.size.width)-20, height: 20));
                    lblSignS.text = "Status : Pending"
                    lblSignS.font = UIFont.systemFontOfSize(13)
                    lblSignS.textColor = UIColor.blackColor().colorWithAlphaComponent(0.87)
                    view.addSubview(lblSignS)
                    
                    
                    let buttonUploadS = UIButton(frame: CGRect(x: view.frame.size.width-192, y: 55, width: 184, height: 36))
                    buttonUploadS.setTitle("CREATE INVESTMENT A/C", forState: .Normal)
                    buttonUploadS.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                    buttonUploadS.backgroundColor = UIColor.defaultOrangeButton
                    buttonUploadS.titleLabel?.font = UIFont.systemFontOfSize(14)
                    buttonUploadS.layer.cornerRadius = 1.5
                    buttonUploadS.addTarget(self, action: #selector(UserProfile.btnCreateInveClicked(_:)), forControlEvents: .TouchUpInside)
                    view.addSubview(buttonUploadS)

                }else if objUser.InvestmentAofStatus=="\(INVESTMENTAACCOUNT_STATUS.PROCESSING1.hashValue)" //            Processing
                {
                    view.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.size.width, height: 60)
                    
                    var lblSignStatus : UILabel!
                    lblSignStatus = UILabel(frame: CGRect(x: 10, y: 5, width: (view.frame.size.width)-20, height: 20));
                    lblSignStatus.text = "Investment Account Status"
                    lblSignStatus.font = UIFont.systemFontOfSize(15)
                    lblSignStatus.textColor = UIColor.blackColor().colorWithAlphaComponent(0.87)
                    view.addSubview(lblSignStatus)
                    
                    var lblLine : UILabel!
                    lblLine = UILabel(frame: CGRect(x: 10, y: 30, width: (view.frame.size.width)-20, height: 1));
                    lblLine.backgroundColor = UIColor.init(red: 220, green: 220, blue: 220)
                    view.addSubview(lblLine)
                    
                    var lblSignS : UILabel!
                    lblSignS = UILabel(frame: CGRect(x: 10, y: 35, width: (view.frame.size.width)-20, height: 20));
                    lblSignS.text = "Status : Created"
                    lblSignS.font = UIFont.systemFontOfSize(13)
                    lblSignS.textColor = UIColor.blackColor().colorWithAlphaComponent(0.87)
                    view.addSubview(lblSignS)

                }
                else if objUser.InvestmentAofStatus=="\(INVESTMENTAACCOUNT_STATUS.CANGENERATED2.hashValue)" //CanGenerated
                {
                    view.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.size.width, height: 60)
                    
                    var lblSignStatus : UILabel!
                    lblSignStatus = UILabel(frame: CGRect(x: 10, y: 5, width: (view.frame.size.width)-20, height: 20));
                    lblSignStatus.text = "Investment Account Status"
                    lblSignStatus.font = UIFont.systemFontOfSize(15)
                    lblSignStatus.textColor = UIColor.blackColor().colorWithAlphaComponent(0.87)
                    view.addSubview(lblSignStatus)
                    
                    var lblLine : UILabel!
                    lblLine = UILabel(frame: CGRect(x: 10, y: 30, width: (view.frame.size.width)-20, height: 1));
                    lblLine.backgroundColor = UIColor.init(red: 220, green: 220, blue: 220)
                    view.addSubview(lblLine)
                    
                    var lblSignS : UILabel!
                    lblSignS = UILabel(frame: CGRect(x: 10, y: 35, width: (view.frame.size.width)-20, height: 20));
                    lblSignS.text = "Status : Created"
                    lblSignS.font = UIFont.systemFontOfSize(13)
                    lblSignS.textColor = UIColor.blackColor().colorWithAlphaComponent(0.87)
                    view.addSubview(lblSignS)

                }
                else if objUser.InvestmentAofStatus=="\(INVESTMENTAACCOUNT_STATUS.VERIFIED3.hashValue)" //CanVerified
                {
                    view.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.size.width, height: 60)
                    
                    var lblSignStatus : UILabel!
                    lblSignStatus = UILabel(frame: CGRect(x: 10, y: 5, width: (view.frame.size.width)-20, height: 20));
                    lblSignStatus.text = "Investment Account Status"
                    lblSignStatus.font = UIFont.systemFontOfSize(15)
                    lblSignStatus.textColor = UIColor.blackColor().colorWithAlphaComponent(0.87)
                    view.addSubview(lblSignStatus)
                    
                    var lblLine : UILabel!
                    lblLine = UILabel(frame: CGRect(x: 10, y: 30, width: (view.frame.size.width)-20, height: 1));
                    lblLine.backgroundColor = UIColor.init(red: 220, green: 220, blue: 220)
                    view.addSubview(lblLine)
                    
                    var lblSignS : UILabel!
                    lblSignS = UILabel(frame: CGRect(x: 10, y: 35, width: (view.frame.size.width)-20, height: 20));
                    lblSignS.text = "Status : Verified"
                    lblSignS.font = UIFont.systemFontOfSize(13)
                    lblSignS.textColor = UIColor.blackColor().colorWithAlphaComponent(0.87)
                    view.addSubview(lblSignS)

                }
                else if objUser.InvestmentAofStatus=="\(INVESTMENTAACCOUNT_STATUS.INVALID4.hashValue)" && isInvestSignatureInvalid == false //Invalid Signature
                {
                    
                    view.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.size.width, height: 95)
                    
                    var lblSignStatus : UILabel!
                    lblSignStatus = UILabel(frame: CGRect(x: 10, y: 5, width: (view.frame.size.width)-20, height: 20));
                    lblSignStatus.text = "Investment Account Status"
                    lblSignStatus.font = UIFont.systemFontOfSize(15)
                    lblSignStatus.textColor = UIColor.blackColor().colorWithAlphaComponent(0.87)
                    view.addSubview(lblSignStatus)
                    
                    var lblLine : UILabel!
                    lblLine = UILabel(frame: CGRect(x: 10, y: 30, width: (view.frame.size.width)-20, height: 1));
                    lblLine.backgroundColor = UIColor.init(red: 220, green: 220, blue: 220)
                    view.addSubview(lblLine)
                    
                    var lblSignS : UILabel!
                    lblSignS = UILabel(frame: CGRect(x: 10, y: 35, width: (view.frame.size.width)-20, height: 20));
                    lblSignS.text = "Status : Unable to verify"
                    lblSignS.font = UIFont.systemFontOfSize(13)
                    lblSignS.textColor = UIColor.blackColor().colorWithAlphaComponent(0.87)
                    view.addSubview(lblSignS)
                    
                    
                    var lblRemarks : UILabel!
                    lblRemarks = UILabel(frame: CGRect(x: 10, y: 55, width: 60, height: 20));
                    lblRemarks.text = "Remarks : "
                    lblRemarks.font = UIFont.systemFontOfSize(13)
                    lblRemarks.textColor = UIColor.blackColor().colorWithAlphaComponent(0.87)
                    view.addSubview(lblRemarks)
                    
                    var lblRemarksDe : UILabel!
                    lblRemarksDe = UILabel(frame: CGRect(x: 10+62, y: 55, width: (view.frame.size.width)-20-62, height: 35));
                    lblRemarksDe.text = "Please check your email and provide missing details."
                    lblRemarksDe.font = UIFont.systemFontOfSize(13)
                    lblRemarksDe.textColor = UIColor.blackColor().colorWithAlphaComponent(0.87)
                    view.addSubview(lblRemarksDe)
                    lblRemarksDe.numberOfLines = 0
                    lblRemarksDe.lineBreakMode = NSLineBreakMode.ByWordWrapping
                    
                }
                else if objUser.InvestmentAofStatus=="\(INVESTMENTAACCOUNT_STATUS.INVALID4.hashValue)" && isInvestSignatureInvalid == true //Invalid Without Signature
                {
                    
                    view.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.size.width, height: 127)
                    
                    var lblSignStatus : UILabel!
                    lblSignStatus = UILabel(frame: CGRect(x: 10, y: 5, width: (view.frame.size.width)-20, height: 20));
                    lblSignStatus.text = "Investment Account Status"
                    lblSignStatus.font = UIFont.systemFontOfSize(15)
                    lblSignStatus.textColor = UIColor.blackColor().colorWithAlphaComponent(0.87)
                    view.addSubview(lblSignStatus)
                    
                    var lblLine : UILabel!
                    lblLine = UILabel(frame: CGRect(x: 10, y: 30, width: (view.frame.size.width)-20, height: 1));
                    lblLine.backgroundColor = UIColor.init(red: 220, green: 220, blue: 220)
                    view.addSubview(lblLine)
                    
                    var lblSignS : UILabel!
                    lblSignS = UILabel(frame: CGRect(x: 10, y: 35, width: (view.frame.size.width)-20, height: 20));
                    lblSignS.text = "Status : Unable to verify"
                    lblSignS.font = UIFont.systemFontOfSize(13)
                    lblSignS.textColor = UIColor.blackColor().colorWithAlphaComponent(0.87)
                    view.addSubview(lblSignS)
                    
                    
                    var lblRemarks : UILabel!
                    lblRemarks = UILabel(frame: CGRect(x: 10, y: 55, width: 60, height: 20));
                    lblRemarks.text = "Remarks : "
                    lblRemarks.font = UIFont.systemFontOfSize(13)
                    lblRemarks.textColor = UIColor.blackColor().colorWithAlphaComponent(0.87)
                    view.addSubview(lblRemarks)
                    
                    var lblRemarksDe : UILabel!
                    lblRemarksDe = UILabel(frame: CGRect(x: 10+62, y: 55, width: (view.frame.size.width)-20-62, height: 20));
                    lblRemarksDe.text = "Please Upload Singature."
                    lblRemarksDe.font = UIFont.systemFontOfSize(13)
                    lblRemarksDe.textColor = UIColor.blackColor().colorWithAlphaComponent(0.87)
                    view.addSubview(lblRemarksDe)
                    
                    
                    let buttonUploadS = UIButton(frame: CGRect(x: view.frame.size.width-158, y: 83, width: 150, height: 36))
                    buttonUploadS.setTitle("UPLOAD SIGNATURE", forState: .Normal)
                    buttonUploadS.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                    buttonUploadS.backgroundColor = UIColor.defaultOrangeButton
                    buttonUploadS.titleLabel?.font = UIFont.systemFontOfSize(14)
                    buttonUploadS.layer.cornerRadius = 1.5
                    buttonUploadS.addTarget(self, action: #selector(UserProfile.btnUploadSignatureClicked(_:)), forControlEvents: .TouchUpInside)
                    view.addSubview(buttonUploadS)

                }

            }
        }
        if indexPath.row == 2 { // Transaction Allowed UI
            if (cell.contentView.subviews.count==0) {
                
                let view = UIView(frame: CGRect(x: 2, y: 5, width: tableView.frame.size.width-4, height: 90))
                view.backgroundColor = UIColor.whiteColor()
                cell.contentView.addSubview(view)
                SharedManager.addShadowToView(view)

                
                var lblSignStatus : UILabel!
                lblSignStatus = UILabel(frame: CGRect(x: 10, y: 5, width: (view.frame.size.width)-20, height: 20));
                lblSignStatus.text = "Transactions Allowed"
                lblSignStatus.font = UIFont.systemFontOfSize(15)
                lblSignStatus.textColor = UIColor.blackColor().colorWithAlphaComponent(0.87)
                view.addSubview(lblSignStatus)
                
                var lblLine : UILabel!
                lblLine = UILabel(frame: CGRect(x: 10, y: 30, width: (view.frame.size.width)-20, height: 1));
                lblLine.backgroundColor = UIColor.init(red: 220, green: 220, blue: 220)
                view.addSubview(lblLine)

                if objUser.InvestmentAofStatus=="\(INVESTMENTAACCOUNT_STATUS.VERIFIED3.hashValue)"
                {
                    
                    view.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.size.width, height: 200)

                    var imgIcon1 : UIImageView!
                    imgIcon1 = UIImageView(frame: CGRect(x: 10, y: 40, width: 25, height: 25));
                    imgIcon1.image = UIImage(named: "transactswitch_icon")
                    view.addSubview(imgIcon1)
                    
                    var lblSignS : UILabel!
                    lblSignS = UILabel(frame: CGRect(x: 40, y: 40, width: (view.frame.size.width)-20-40, height: 25));
                    lblSignS.text = "Switch"
                    lblSignS.font = UIFont.systemFontOfSize(13)
                    lblSignS.textColor = UIColor.blackColor().colorWithAlphaComponent(0.87)
                    view.addSubview(lblSignS)

                    
                    let btnSwitch = UIButton(frame: CGRect(x: 10, y: 40, width: (view.frame.size.width)-20, height: 25))
                    btnSwitch.backgroundColor = UIColor.clearColor()
                    btnSwitch.addTarget(self, action: #selector(UserProfile.btnSwitchClicked(_:)), forControlEvents: .TouchUpInside)
                    view.addSubview(btnSwitch)

                    
                    var imgIcon2 : UIImageView!
                    imgIcon2 = UIImageView(frame: CGRect(x: 10, y: 70, width: 25, height: 25));
                    imgIcon2.image = UIImage(named: "transactBuySIP")
                    view.addSubview(imgIcon2)
                    
                    var lblBuy : UILabel!
                    lblBuy = UILabel(frame: CGRect(x: 40, y: 70, width: (view.frame.size.width)-20-40, height: 25));
                    lblBuy.text = "Buy/SIP"
                    lblBuy.font = UIFont.systemFontOfSize(13)
                    lblBuy.textColor = UIColor.blackColor().colorWithAlphaComponent(0.87)
                    view.addSubview(lblBuy)

                    let btnBuy = UIButton(frame: CGRect(x: 10, y: 70, width: (view.frame.size.width)-20, height: 25))
                    btnBuy.backgroundColor = UIColor.clearColor()
                    btnBuy.addTarget(self, action: #selector(UserProfile.btnBuySIPClicked(_:)), forControlEvents: .TouchUpInside)
                    view.addSubview(btnBuy)

                    
                    var imgIcon3 : UIImageView!
                    imgIcon3 = UIImageView(frame: CGRect(x: 10, y: 100, width: 25, height: 25));
                    imgIcon3.image = UIImage(named: "transactRedeem")
                    view.addSubview(imgIcon3)
                    
                    var lblRedeeem : UILabel!
                    lblRedeeem = UILabel(frame: CGRect(x: 40, y: 100, width: (view.frame.size.width)-20-40, height: 25));
                    lblRedeeem.text = "Redeem"
                    lblRedeeem.font = UIFont.systemFontOfSize(13)
                    lblRedeeem.textColor = UIColor.blackColor().colorWithAlphaComponent(0.87)
                    view.addSubview(lblRedeeem)
                    
                    let btnRedeem = UIButton(frame: CGRect(x: 10, y: 100, width: (view.frame.size.width)-20, height: 25))
                    btnRedeem.backgroundColor = UIColor.clearColor()
                    btnRedeem.addTarget(self, action: #selector(UserProfile.btnRedeemClicked(_:)), forControlEvents: .TouchUpInside)
                    view.addSubview(btnRedeem)

                    
                    var imgIcon4 : UIImageView!
                    imgIcon4 = UIImageView(frame: CGRect(x: 10, y: 130, width: 25, height: 25));
                    imgIcon4.image = UIImage(named: "slide_portfolio")
                    imgIcon4.backgroundColor = UIColor.defaultYellow
                    imgIcon4.layer.cornerRadius = imgIcon4.frame.size.width/2
                    view.addSubview(imgIcon4)
                    
                    var lblAddPort : UILabel!
                    lblAddPort = UILabel(frame: CGRect(x: 40, y: 130, width: (view.frame.size.width)-20-40, height: 25));
                    lblAddPort.text = "Add Portfolio"
                    lblAddPort.font = UIFont.systemFontOfSize(13)
                    lblAddPort.textColor = UIColor.blackColor().colorWithAlphaComponent(0.87)
                    view.addSubview(lblAddPort)
                    
                    let btnAddPort = UIButton(frame: CGRect(x: 10, y: 130, width: (view.frame.size.width)-20, height: 25))
                    btnAddPort.backgroundColor = UIColor.clearColor()
                    btnAddPort.addTarget(self, action: #selector(UserProfile.btnPortAddPortfolioClicked(_:)), forControlEvents: .TouchUpInside)
                    view.addSubview(btnAddPort)

                    
                    var imgIcon5 : UIImageView!
                    imgIcon5 = UIImageView(frame: CGRect(x: 10, y: 160, width: 25, height: 25));
                    imgIcon5.image = UIImage(named: "ic_file_upload_white")
                    imgIcon5.backgroundColor = UIColor.defaultGreenColor
                    imgIcon5.layer.cornerRadius = imgIcon4.frame.size.width/2
                    view.addSubview(imgIcon5)
                    
                    var lblAuto : UILabel!
                    lblAuto = UILabel(frame: CGRect(x: 40, y: 160, width: (view.frame.size.width)-20-40, height: 25));
                    lblAuto.text = "Auto Generate Portfolio"
                    lblAuto.font = UIFont.systemFontOfSize(13)
                    lblAuto.textColor = UIColor.blackColor().colorWithAlphaComponent(0.87)
                    view.addSubview(lblAuto)
                    
                    let btnAuto = UIButton(frame: CGRect(x: 10, y: 160, width: (view.frame.size.width)-20, height: 25))
                    btnAuto.backgroundColor = UIColor.clearColor()
                    btnAuto.addTarget(self, action: #selector(UserProfile.btnAutoGeneratePortfolioClicked(_:)), forControlEvents: .TouchUpInside)
                    view.addSubview(btnAuto)

                }else if objUser.SignupStatus=="\(SIGNUP_STATUS.PENDING0.hashValue)" || objUser.SignupStatus=="\(SIGNUP_STATUS.PANVERIFICATIONPENDING4.hashValue)"
                { // Add Two Buttons...
                    
                    view.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.size.width, height: 100)

                    var imgIcon4 : UIImageView!
                    imgIcon4 = UIImageView(frame: CGRect(x: 10, y: 40, width: 25, height: 25));
                    imgIcon4.image = UIImage(named: "slide_portfolio")
                    imgIcon4.backgroundColor = UIColor.defaultYellow
                    imgIcon4.layer.cornerRadius = imgIcon4.frame.size.width/2
                    view.addSubview(imgIcon4)
                    
                    var lblAddPort : UILabel!
                    lblAddPort = UILabel(frame: CGRect(x: 40, y: 40, width: (view.frame.size.width)-20-40, height: 25));

                    lblAddPort.text = "Add Portfolio"
                    lblAddPort.font = UIFont.systemFontOfSize(13)
                    lblAddPort.textColor = UIColor.blackColor().colorWithAlphaComponent(0.87)
                    view.addSubview(lblAddPort)
                    
                    let btnAdd = UIButton(frame: CGRect(x: 10, y: 40, width: (view.frame.size.width)-20, height: 25))
                    btnAdd.backgroundColor = UIColor.clearColor()
                    btnAdd.addTarget(self, action: #selector(UserProfile.btnPortAddPortfolioClicked(_:)), forControlEvents: .TouchUpInside)
                    view.addSubview(btnAdd)

                    
                    var imgIcon5 : UIImageView!
                    imgIcon5 = UIImageView(frame: CGRect(x: 10, y: 70, width: 25, height: 25));
                    imgIcon5.image = UIImage(named: "ic_file_upload_white")
                    imgIcon5.backgroundColor = UIColor.defaultGreenColor
                    imgIcon5.layer.cornerRadius = imgIcon4.frame.size.width/2
                    view.addSubview(imgIcon5)
                    
                    var lblAuto : UILabel!
                    lblAuto = UILabel(frame: CGRect(x: 40, y: 70, width: (view.frame.size.width)-20-40, height: 25));
                    lblAuto.text = "Auto Generate Portfolio"
                    lblAuto.font = UIFont.systemFontOfSize(13)
                    lblAuto.textColor = UIColor.blackColor().colorWithAlphaComponent(0.87)
                    view.addSubview(lblAuto)

                    let btnAuto = UIButton(frame: CGRect(x: 10, y: 70, width: (view.frame.size.width)-20, height: 25))
                    btnAuto.backgroundColor = UIColor.clearColor()
                    btnAuto.addTarget(self, action: #selector(UserProfile.btnAutoGeneratePortfolioClicked(_:)), forControlEvents: .TouchUpInside)
                    view.addSubview(btnAuto)

                    
                }else
                { // Add 4 Buttons...
                    
                    view.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.size.width, height: 170)
                    
                    var imgIcon1 : UIImageView!
                    imgIcon1 = UIImageView(frame: CGRect(x: 10, y: 40, width: 25, height: 25));
                    imgIcon1.image = UIImage(named: "transactswitch_icon")
                    view.addSubview(imgIcon1)
                    
                    var lblSignS : UILabel!
                    lblSignS = UILabel(frame: CGRect(x: 40, y: 40, width: (view.frame.size.width)-20-40, height: 25));
                    lblSignS.text = "Switch"
                    lblSignS.font = UIFont.systemFontOfSize(13)
                    lblSignS.textColor = UIColor.blackColor().colorWithAlphaComponent(0.87)
                    view.addSubview(lblSignS)

                    
                    let btnSwitch = UIButton(frame: CGRect(x: 10, y: 40, width: (view.frame.size.width)-20, height: 25))
                    btnSwitch.backgroundColor = UIColor.clearColor()
                    btnSwitch.addTarget(self, action: #selector(UserProfile.btnSwitchClicked(_:)), forControlEvents: .TouchUpInside)
                    view.addSubview(btnSwitch)

                    
                    
                    var imgIcon3 : UIImageView!
                    imgIcon3 = UIImageView(frame: CGRect(x: 10, y: 70, width: 25, height: 25));
                    imgIcon3.image = UIImage(named: "transactRedeem")
                    view.addSubview(imgIcon3)
                    
                    var lblRedeeem : UILabel!
                    lblRedeeem = UILabel(frame: CGRect(x: 40, y: 70, width: (view.frame.size.width)-20-40, height: 25));
                    lblRedeeem.text = "Redeem"
                    lblRedeeem.font = UIFont.systemFontOfSize(13)
                    lblRedeeem.textColor = UIColor.blackColor().colorWithAlphaComponent(0.87)
                    view.addSubview(lblRedeeem)
                    
                    let btnRedeeem = UIButton(frame: CGRect(x: 10, y: 70, width: (view.frame.size.width)-20, height: 25))
                    btnRedeeem.backgroundColor = UIColor.clearColor()
                    btnRedeeem.addTarget(self, action: #selector(UserProfile.btnRedeemClicked(_:)), forControlEvents: .TouchUpInside)
                    view.addSubview(btnRedeeem)

                    
                    var imgIcon4 : UIImageView!
                    imgIcon4 = UIImageView(frame: CGRect(x: 10, y: 100, width: 25, height: 25));
                    imgIcon4.image = UIImage(named: "slide_portfolio")
                    imgIcon4.backgroundColor = UIColor.defaultYellow
                    imgIcon4.layer.cornerRadius = imgIcon4.frame.size.width/2
                    view.addSubview(imgIcon4)
                    
                    var lblAddPort : UILabel!
                    lblAddPort = UILabel(frame: CGRect(x: 40, y: 100, width: (view.frame.size.width)-20-40, height: 25));
                    lblAddPort.text = "Add Portfolio"
                    lblAddPort.font = UIFont.systemFontOfSize(13)
                    lblAddPort.textColor = UIColor.blackColor().colorWithAlphaComponent(0.87)
                    view.addSubview(lblAddPort)
                    
                    let btnAddPort = UIButton(frame: CGRect(x: 10, y: 100, width: (view.frame.size.width)-20, height: 25))
                    btnAddPort.backgroundColor = UIColor.clearColor()
                    btnAddPort.addTarget(self, action: #selector(UserProfile.btnPortAddPortfolioClicked(_:)), forControlEvents: .TouchUpInside)
                    view.addSubview(btnAddPort)

                    
                    
                    var imgIcon5 : UIImageView!
                    imgIcon5 = UIImageView(frame: CGRect(x: 10, y: 130, width: 25, height: 25));
                    imgIcon5.image = UIImage(named: "ic_file_upload_white")
                    imgIcon5.backgroundColor = UIColor.defaultGreenColor
                    imgIcon5.layer.cornerRadius = imgIcon4.frame.size.width/2
                    view.addSubview(imgIcon5)
                    
                    var lblAuto : UILabel!
                    lblAuto = UILabel(frame: CGRect(x: 40, y: 130, width: (view.frame.size.width)-20-40, height: 25));
                    lblAuto.text = "Auto Generate Portfolio"
                    lblAuto.font = UIFont.systemFontOfSize(13)
                    lblAuto.textColor = UIColor.blackColor().colorWithAlphaComponent(0.87)
                    view.addSubview(lblAuto)

                    let btnAuto = UIButton(frame: CGRect(x: 10, y: 130, width: (view.frame.size.width)-20, height: 25))
                    btnAuto.backgroundColor = UIColor.clearColor()
                    btnAuto.addTarget(self, action: #selector(UserProfile.btnAutoGeneratePortfolioClicked(_:)), forControlEvents: .TouchUpInside)
                    view.addSubview(btnAuto)

                }

            }
        }


        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.contentView.backgroundColor = UIColor.clearColor()
        cell.backgroundColor = UIColor.clearColor()
        return cell;
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            
            if objUser.SignupStatus=="\(SIGNUP_STATUS.PENDING0.hashValue)" // PENDING.. THIS WILL NOT IN USE...
            {
            }
            else if objUser.SignupStatus=="\(SIGNUP_STATUS.CREATED1.hashValue)" || objUser.SignupStatus=="\(SIGNUP_STATUS.PANVERIFICATIONPENDING4.hashValue)" // CREATED...
            {
                return 70
            }
            else if objUser.SignupStatus=="\(SIGNUP_STATUS.VERIFIED2.hashValue)" // VERIFIED....
            {
                return 70
            }
            else if objUser.SignupStatus=="\(SIGNUP_STATUS.INVALID3.hashValue)" && isSignupSelfieInvalid == false // INVALID & EEOR SELPHIE
            {
                return 105
            }
            else if objUser.SignupStatus=="\(SIGNUP_STATUS.INVALID3.hashValue)" && isSignupSelfieInvalid == true // INVALID & EEOR SELPHIE
            {
                return 130
            }

        }
        if indexPath.row == 1 {
            
            if objUser.InvestmentAofStatus=="\(INVESTMENTAACCOUNT_STATUS.PENDING0.hashValue)" //Pending
            {
                return 100

            }else if objUser.InvestmentAofStatus=="\(INVESTMENTAACCOUNT_STATUS.PROCESSING1.hashValue)" //            Processing
            {
                return 70
            }
            else if objUser.InvestmentAofStatus=="\(INVESTMENTAACCOUNT_STATUS.CANGENERATED2.hashValue)" //CanGenerated
            {
                return 70
            }
            else if objUser.InvestmentAofStatus=="\(INVESTMENTAACCOUNT_STATUS.VERIFIED3.hashValue)" //CanVerified
            {
                return 70
            }
            else if objUser.InvestmentAofStatus=="\(INVESTMENTAACCOUNT_STATUS.INVALID4.hashValue)" && isInvestSignatureInvalid == false //Invalid Signature
            {
                return 105
            }
            else if objUser.InvestmentAofStatus=="\(INVESTMENTAACCOUNT_STATUS.INVALID4.hashValue)" && isInvestSignatureInvalid == true //Invalid Without Signature
            {
                return 130
            }

        }
        if indexPath.row == 2 {
            
            if objUser.InvestmentAofStatus=="\(INVESTMENTAACCOUNT_STATUS.VERIFIED3.hashValue)"
            {
                return 210
            }else if objUser.SignupStatus=="\(SIGNUP_STATUS.PENDING0.hashValue)" || objUser.SignupStatus=="\(SIGNUP_STATUS.PANVERIFICATIONPENDING4)"
            { // Add Two Buttons...
                
                return 100

            }else
            { // Add 4 Buttons...
                return 170

            }
        }
        
        return 100
    }
    
    
    @IBAction func btnVerifyPanClicked(sender: AnyObject) {
        
        let allUser = DBManager.getInstance().getAllUser()
        if allUser.count==0
        {
            
        }else{
            
            let objUser = allUser.objectAtIndex(0) as! User
            print(objUser)
            
            sharedInstance.objLoginUser.ClientID = objUser.ClientID
            sharedInstance.objLoginUser.Name = objUser.Name
            sharedInstance.objLoginUser.email = objUser.email
            sharedInstance.objLoginUser.mob = objUser.mob
            sharedInstance.objLoginUser.password = objUser.password
            sharedInstance.objLoginUser.CAN = objUser.CAN
            sharedInstance.objLoginUser.SignupStatus = objUser.SignupStatus
            sharedInstance.objLoginUser.InvestmentAofStatus = objUser.InvestmentAofStatus
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let objDocScreen = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdDocScreen)
                self.navigationController?.pushViewController(objDocScreen!, animated: true)
            })
        }
    }
    
    @IBAction func btnCreateInveClicked(sender: AnyObject) {
        print("Create Investment Clicked...")
        
        let allUser = DBManager.getInstance().getAllUser()
        if allUser.count==0
        {
            
        }else{
            
            let objUser = allUser.objectAtIndex(0) as! User
            print(objUser)
            
            sharedInstance.objLoginUser.ClientID = objUser.ClientID
            sharedInstance.objLoginUser.Name = objUser.Name
            sharedInstance.objLoginUser.email = objUser.email
            sharedInstance.objLoginUser.mob = objUser.mob
            sharedInstance.objLoginUser.password = objUser.password
            sharedInstance.objLoginUser.CAN = objUser.CAN
            sharedInstance.objLoginUser.SignupStatus = objUser.SignupStatus
            sharedInstance.objLoginUser.InvestmentAofStatus = objUser.InvestmentAofStatus
            
            let objDocScreen = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdDocScreen) as! DocScreen
            objDocScreen.isFrom = IS_FROM.Profile
            self.navigationController?.pushViewController(objDocScreen, animated: true)
           
        }
    }
    
    @IBAction func btnSwitchClicked(sender: AnyObject) {
        print("Switch clicked....")
        
        sharedInstance.userDefaults .setObject("Select Fund", forKey: kSelectFromFundValue)
        sharedInstance.userDefaults .setObject("Select Fund", forKey: kSelectToFundValue)
        
        let objSwitch = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdSwitchScreen)
        self.navigationController?.pushViewController(objSwitch!, animated: true)
    }
    
    @IBAction func btnBuySIPClicked(sender: AnyObject) {
        print("Buy/SIP Clicked...")
        
        print("Buy/SIP Clicked")
        
        sharedInstance.userDefaults .setObject(kEnterSchemeName, forKey: kSelectBuyNowScheme)
        
        let objBuyScreen = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdBuyScreeen) as! BuyScreeen
        self.navigationController?.pushViewController(objBuyScreen, animated: true)
        
    }

    @IBAction func btnRedeemClicked(sender: AnyObject) {
        print("Redeem Clicked...")
        
        let arrMFAccounts = DBManager.getInstance().getMFAccountsForRedeemCondition()
        if arrMFAccounts.count==0 {
            SharedManager.invokeAlertMethod("No schemes found", strBody: "Currently there are no schemes in your WealthTrust portfolio for redemption.", delegate: nil)
        }else{
            let objRedeem = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdRedeemScreen) as! RedeemScreen
            objRedeem.arrSchemes = arrMFAccounts
            self.navigationController?.pushViewController(objRedeem, animated: true)
        }
    }
    
    @IBAction func btnAutoGeneratePortfolioClicked(sender: AnyObject) {
        print("AutiGenerate Clicked ")
//        RootManager.sharedInstance.isFrom = IS_FROM.AutoGenerate
//        RootManager.sharedInstance.navigateToScreen(self, data: [:])
        
        let objscreen = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdUploadPortfolioInstruScreen) as! UploadPortfolioInstruScreen
        self.navigationController?.pushViewController(objscreen, animated: true)

    }
    
    @IBAction func btnPortAddPortfolioClicked(sender: AnyObject) {
        print("Add Portfolio Clicked ")
//        RootManager.sharedInstance.isFrom = IS_FROM.AddManuallyPortfolio
//        RootManager.sharedInstance.navigateToScreen(self, data: [:])
        
        
        sharedInstance.userDefaults .setObject(kEnterSchemeName, forKey: kSelectAddExistingScheme)
        let objAddPort = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdAddPortfolioManually) as! AddPortfolioManually
        self.navigationController?.pushViewController(objAddPort, animated: true)

    }
    
    @IBAction func btnInvalidSelfieClicked(sender: AnyObject) {
        print("InvalidSelfie Clicked...")
        
        imageToUpload = "Selfie"
        if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil {
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerControllerSourceType.Camera
            picker.cameraCaptureMode = .Photo
            picker.delegate = self
            presentViewController(picker, animated: true, completion: nil)
        } else {
//            noCamera()
            
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            picker.delegate = self
            presentViewController(picker, animated: true, completion: nil)

        }
    }
    @IBAction func btnUploadSignatureClicked(sender: AnyObject) {
        print("UploadSign Clicked...")
        
        imageToUpload = "Signature"

        if UIImagePickerController.availableMediaTypesForSourceType(.PhotoLibrary) != nil {
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            picker.delegate = self
            presentViewController(picker, animated: true, completion: nil)
        } else {
            let alertVC = UIAlertController(
                title: "No Libarary Access",
                message: "Sorry, this device has no libarary access.",
                preferredStyle: .Alert)
            let okAction = UIAlertAction(
                title: "OK",
                style:.Default,
                handler: nil)
            alertVC.addAction(okAction)
            presentViewController(alertVC,
                                  animated: true,
                                  completion: nil)
        }
    }

    
    
    
    
    //MARK: Delegates
    func imagePickerController(
        picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        
        let chosenImage = SharedManager.sharedInstance.resizeImage(selectedImage)
        
        imagePicked = chosenImage
        
        self.callAPIs()
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func noCamera(){
        let alertVC = UIAlertController(
            title: "No Camera",
            message: "Sorry, this device has no camera",
            preferredStyle: .Alert)
        let okAction = UIAlertAction(
            title: "OK",
            style:.Default,
            handler: nil)
        alertVC.addAction(okAction)
        presentViewController(alertVC,
                              animated: true,
                              completion: nil)
    }

    
    
    func callAPIs() {
        
        let dic = NSMutableDictionary()
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            
            let arrDic : NSMutableArray = []
            
            let imageData:NSData = UIImagePNGRepresentation(self.imagePicked)!
            let strBase64:String = imageData.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
            let bank64 = "data:image/jpeg;base64,\(strBase64)"
            
            if self.imageToUpload=="Selfie"
            {
                arrDic.addObject(["ClientId":sharedInstance.objLoginUser.ClientID,"DocumentType" : "\(DocumentType.Selfie.hashValue)","SendCopyType" : "App","DocumentData" : bank64])
            }else{
                arrDic.addObject(["ClientId":sharedInstance.objLoginUser.ClientID,"DocumentType" : "\(DocumentType.Signature.hashValue)","SendCopyType" : "App","DocumentData" : bank64])
            }
            
            dic["ImageArr"] = arrDic
            
            
            
            var messageToDisp = "Uploading Signature"
            if self.imageToUpload=="Selfie"
            {
                messageToDisp = "Uploading Selfie"
            }
            
            WebManagerHK.postDataToURL(kModePhotoUpdate, params: dic, message: messageToDisp) { (response) in
                
                print("Dic Response : \(response)")
                
                if response is NSDictionary
                {
                    let mainResponse = String(response.objectForKey(kWAPIResponse)!)
                    if mainResponse=="-2"
                    {
                        return
                    }
                }
                
//                let mainResponse = response.objectForKey(kWAPIResponse) as! NSArray

                if response.objectForKey(kWAPIResponse) is NSDictionary
                {
                    let mainResponse = response.objectForKey(kWAPIResponse) as! NSDictionary
                    
                    if mainResponse.objectForKey("SignUpStatus") is NSMutableDictionary
                    {
                       
                        let SignUpStatusDetails = mainResponse.objectForKey("SignUpStatus") as! NSMutableDictionary
                        
                        ////         UPDATE AOF SignUp Details..
                        let userInfo: AOFStatus = AOFStatus()
                        
                        if let theTitle = SignUpStatusDetails.objectForKey("BankAccNoMismatch") {
                            userInfo.banckaccmismatch = String(theTitle)
                        }
                        if let theTitle = SignUpStatusDetails.objectForKey("CheckCopy") {
                            userInfo.chequecopy = String(theTitle)
                        }
                        if let theTitle = SignUpStatusDetails.objectForKey("ClientId") {
                            userInfo.ClientID = String(theTitle)
                        }
                        if let theTitle = SignUpStatusDetails.objectForKey("DOBMismatch") {
                            userInfo.dobmismatch = String(theTitle)
                        }
                        if let theTitle = SignUpStatusDetails.objectForKey("IFSCCodeMismatch") {
                            userInfo.ifscmismatch = String(theTitle)
                        }
                        if let theTitle = SignUpStatusDetails.objectForKey("Id") {
                            userInfo.idS = String(theTitle)
                        }
                        if let theTitle = SignUpStatusDetails.objectForKey("NameMismatch") {
                            userInfo.namemismatch = String(theTitle)
                        }
                        if let theTitle = SignUpStatusDetails.objectForKey("PANNumberMismatch") {
                            userInfo.pannummismatch = String(theTitle)
                        }
                        if let theTitle = SignUpStatusDetails.objectForKey("PanCopy") {
                            userInfo.pancopy = String(theTitle)
                        }
                        if let theTitle = SignUpStatusDetails.objectForKey("Selfie") {
                            userInfo.selfie = String(theTitle)
                        }
                        if let theTitle = SignUpStatusDetails.objectForKey("SignatureMistmatch") {
                            userInfo.signaturemismatch = String(theTitle)
                        }
                        if let theTitle = SignUpStatusDetails.objectForKey("Type") {
                            userInfo.aoftype = String(theTitle)
                        }
                        
                        // ADD OR UPDATE..
                        if DBManager.getInstance().checkSignUpStatusAlreadyExist(userInfo)
                        {
                            let isUpdated = DBManager.getInstance().updateAOFStatus(userInfo)
                            if isUpdated {
                                print("SIGN STATUS UPDATED.....")
                            } else {
                                print("ERROR : SIGN STATUS SYNCHED ERROR!!!!")
                            }
                            
                        }else{
                            
                            let isUpdated = DBManager.getInstance().addAOFStatus(userInfo)
                            if isUpdated {
                                print("SIGN STATUS ADDED.....")
                            } else {
                                print("ERROR : SIGN STATUS SYNCHED ERROR!!!!")
                            }
                        }
                        
                        self.fetchDetails()

                    }

                }
            }
            
        })
        
    }
}
