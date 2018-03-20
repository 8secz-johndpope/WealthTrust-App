//
//  PanVerificationScreen.swift
//  WealthTrust
//
//  Created by Hemen Gohil on 9/4/16.
//  Copyright © 2016 Hemen Gohil. All rights reserved.
//

import UIKit


let imageAlpha = 8.0


class PanVerificationScreen: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var tblView: UITableView!

    var txtPan : RPFloatingPlaceholderTextField!
    var txtPanLine : UILabel!

    var lblName : UILabel!
    var lblNameDisp : UILabel!
    var lblNameLine : UILabel!


    var btnClickPicturePan : UIButton!
    var btnClickPicturePanIcon : UIButton!

    var btnUploadPicturePan : UIButton!
    var btnUploadPicturePanIcon : UIButton!

    var btnCheckPanEmail : UIButton!
    var btnCheckBoxPanEmail : UIButton!
    
    var imagePicked : UIImage!
    var imageSelfie : UIImage!
    var imageClickedIndex = 0
    
    var isPanValid = false

    var lblImageUploadedRight : UIImageView!

    var nameFromPan = ""
    
    let picker = UIImagePickerController()
    
    var isFrom = IS_FROM.Profile

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIKeyboardDidHideNotification, object: nil)
        
        tblView.sectionHeaderHeight = 110
        
        picker.delegate = self

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let keyboardHeight = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue.size.height {
                tblView.contentInset = UIEdgeInsetsMake(0, 0, keyboardHeight, 0)
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        UIView.animateWithDuration(0.2, animations: { self.tblView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0) })
        // For some reason adding inset in keyboardWillShow is animated by itself but removing is not, that's why we have to use animateWithDuration here
    }
    
    
    @IBAction func btnBackClicked(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }

    func applyTextFiledStyle1(textField : UITextField) {
        
        textField.delegate = self;
        textField.returnKeyType = UIReturnKeyType.Next
        textField.tintColor = UIColor.blueColor()
        textField .setValue(UIColor.darkGrayColor(), forKeyPath: "_placeholderLabel.textColor")
        textField.textColor = UIColor.darkGrayColor()
        textField.textAlignment = NSTextAlignment.Left
        textField.font = UIFont.systemFontOfSize(16)
        textField.autocorrectionType = .No
    }

    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "CELL_FIRST")
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CELL_FIRST", forIndexPath: indexPath) as UITableViewCell
        
        if (cell.contentView.subviews.count==0) {
            
            if indexPath.row==3 {
                
                let buttonSubmit = UIButton(frame: CGRect(x: cell.contentView.frame.size.width-80, y: 10, width: 70, height: 36))
                buttonSubmit.setTitle("SUBMIT", forState: .Normal)
                buttonSubmit.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                buttonSubmit.backgroundColor = UIColor.defaultOrangeButton
                buttonSubmit.titleLabel?.font = UIFont.systemFontOfSize(14)
                buttonSubmit.layer.cornerRadius = 1.5
                buttonSubmit.addTarget(self, action: #selector(PanVerificationScreen.btnSubmitClicked(_:)), forControlEvents: .TouchUpInside)
                cell.contentView.addSubview(buttonSubmit)
                
                
                let buttonCancel = UIButton(frame: CGRect(x: cell.contentView.frame.size.width-(80*2), y: 10, width: 70, height: 36))
                buttonCancel.setTitle("CANCEL", forState: .Normal)
                buttonCancel.setTitleColor(UIColor.defaultOrangeButton, forState: .Normal)
                buttonCancel.backgroundColor = UIColor.whiteColor()
                buttonCancel.titleLabel?.font = UIFont.systemFontOfSize(14)
                buttonCancel.layer.cornerRadius = 1.5
                buttonCancel.layer.borderColor = UIColor.defaultOrangeButton.CGColor
                buttonCancel.layer.borderWidth = 1.0
                buttonCancel.addTarget(self, action: #selector(PanVerificationScreen.btnBackClicked(_:)), forControlEvents: .TouchUpInside)
                cell.contentView.addSubview(buttonCancel)
                
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                cell.contentView.backgroundColor = UIColor.clearColor()
                cell.backgroundColor = UIColor.clearColor()
                
                return cell;
            }
            
            
            switch indexPath.row {
            case 0:
                
                
                lblNameDisp = UILabel(frame: CGRect(x: 10, y: 0, width: (cell.contentView.frame.size.width)-20, height: 22));
                lblNameDisp.text = "Name"
                lblNameDisp.font = UIFont.systemFontOfSize(12)
                lblNameDisp.textColor = UIColor.defaultMenuGray
                cell.contentView.addSubview(lblNameDisp)
                
                lblName = UILabel(frame: CGRect(x: 10, y: 20, width: (cell.contentView.frame.size.width)-20, height: 35));
                lblName.text = "Name Display".uppercaseString
                lblName.font = UIFont.systemFontOfSize(16)
                lblName.textColor = UIColor.blackColor()
                cell.contentView.addSubview(lblName)
                
                lblNameLine = UILabel(frame: CGRect(x: 10, y: 55, width: (cell.contentView.frame.size.width)-20, height: 1));
                lblNameLine.backgroundColor = UIColor.lightGrayColor()
                lblNameLine.alpha = 0.4
                cell.contentView.addSubview(lblNameLine)

                  let viewTextField = UIView(frame: CGRect(x: 5, y: 5, width: (cell.contentView.frame.size.width)-20, height: 55))
                
                txtPan = RPFloatingPlaceholderTextField(frame: CGRect(x: 0, y: 5, width: viewTextField.frame.size.width, height: 45));
                txtPan.placeholder = "PAN Number"
                txtPan.keyboardType = UIKeyboardType.Default
                self.applyTextFiledStyle1(txtPan)
                cell.contentView.addSubview(txtPan)
                txtPan.autocapitalizationType = .AllCharacters
                
                txtPanLine = UILabel(frame: CGRect(x: 0, y: viewTextField.frame.size.height-1, width: (cell.contentView.frame.size.width)-20, height: 1));
                txtPanLine.backgroundColor = UIColor.lightGrayColor()
                txtPanLine.alpha = 0.4
                
                viewTextField.addSubview(txtPanLine)
                viewTextField.addSubview(txtPan)
                cell.contentView.addSubview(viewTextField)

                
                if self.isPanValid
                {
                    lblNameDisp.frame = CGRect(x: 10, y: 0, width: (cell.contentView.frame.size.width)-20, height: 22);
                    lblName.frame = CGRect(x: 10, y: 20, width: (cell.contentView.frame.size.width)-20, height: 35);
                    lblNameLine.frame = CGRect(x: 10, y: 50, width: (cell.contentView.frame.size.width)-20, height: 1);
                    txtPan.frame = CGRect(x: 0, y: 65, width: (cell.contentView.frame.size.width)-20, height: 35);
                    txtPanLine.frame = CGRect(x: 0, y: 105, width: (cell.contentView.frame.size.width)-20, height: 1);
                    
                }else{
                    
                    
                    lblNameDisp.hidden = true
                    lblName.hidden = true
                    lblNameLine.hidden = true
                    txtPan.frame = CGRect(x: 0, y: 5, width: (cell.contentView.frame.size.width)-20, height: 40);
                    txtPanLine.frame = CGRect(x: 0, y: 40, width: (cell.contentView.frame.size.width)-20, height: 1);

                }

                
                break;
            case 1:

                
                var lblUploadPan : UILabel!
                lblUploadPan = UILabel(frame: CGRect(x: 10, y: 0, width: (cell.contentView.frame.size.width)-20, height: 30));
                lblUploadPan.text = "Upload PAN Card"
                lblUploadPan.textColor = UIColor.blackColor()
                lblUploadPan.font = UIFont.systemFontOfSize(16)
                cell.contentView.addSubview(lblUploadPan)

                lblImageUploadedRight = UIImageView(frame: CGRect(x: (cell.contentView.frame.size.width)-40, y: 5, width: 20, height: 20));
                lblImageUploadedRight.image = UIImage(named: "iconCheckPhotoUploa")
                cell.contentView.addSubview(lblImageUploadedRight)
                lblImageUploadedRight.hidden = true
                
                
                var lblOption1 : UILabel!
                lblOption1 = UILabel(frame: CGRect(x: 10, y: lblUploadPan.frame.size.height , width: 60, height: 15));
                lblOption1.text = "Option 1 :"
                lblOption1.textColor = UIColor.blackColor()
                lblOption1.font = UIFont.systemFontOfSize(11)
                cell.contentView.addSubview(lblOption1)

                btnClickPicturePanIcon = UIButton(frame: CGRect(x: 5, y: lblUploadPan.frame.size.height + lblOption1.frame.size.height + 3, width: 35, height: 30));
                btnClickPicturePanIcon.backgroundColor = UIColor.clearColor()
                btnClickPicturePanIcon.setImage(UIImage(named: "iconCamera"), forState: .Normal)
                cell.contentView.addSubview(btnClickPicturePanIcon)
                btnClickPicturePanIcon.alpha = 0.6
                
                btnClickPicturePan = UIButton(frame: CGRect(x: 40, y: lblUploadPan.frame.size.height + lblOption1.frame.size.height + 3, width: (cell.contentView.frame.size.width)-55, height: 30));
                btnClickPicturePan.setTitle(" Click Picture of PAN Card", forState: .Normal)
                btnClickPicturePan.titleLabel?.font = UIFont.systemFontOfSize(14)
                btnClickPicturePan.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
                btnClickPicturePan.titleLabel?.textAlignment = .Left
                btnClickPicturePan.contentHorizontalAlignment = .Left;
                cell.contentView.addSubview(btnClickPicturePan)

                btnClickPicturePanIcon.addTarget(self, action: #selector(PanVerificationScreen.btnCapturePAN(_:)), forControlEvents: .TouchUpInside)
                btnClickPicturePan.addTarget(self, action: #selector(PanVerificationScreen.btnCapturePAN(_:)), forControlEvents: .TouchUpInside)

                
                var lblOption2 : UILabel!
                lblOption2 = UILabel(frame: CGRect(x: 10, y: lblUploadPan.frame.size.height + lblOption1.frame.size.height + btnClickPicturePanIcon.frame.size.height + 10 , width: 60, height: 15));
                lblOption2.text = "Option 2 :"
                lblOption2.textColor = UIColor.blackColor()
                lblOption2.font = UIFont.systemFontOfSize(11)
                cell.contentView.addSubview(lblOption2)
                
                btnUploadPicturePanIcon = UIButton(frame: CGRect(x: 5, y: lblUploadPan.frame.size.height + lblOption1.frame.size.height + btnClickPicturePanIcon.frame.size.height + lblOption2.frame.size.height + 13, width: 35, height: 30));
                btnUploadPicturePanIcon.backgroundColor = UIColor.clearColor()
                btnUploadPicturePanIcon.setImage(UIImage(named: "iconGalary"), forState: .Normal)
                cell.contentView.addSubview(btnUploadPicturePanIcon)
                btnUploadPicturePanIcon.alpha = 0.6

                btnUploadPicturePan = UIButton(frame: CGRect(x: 40, y: lblUploadPan.frame.size.height + lblOption1.frame.size.height + btnClickPicturePanIcon.frame.size.height + lblOption2.frame.size.height + 13, width: (cell.contentView.frame.size.width)-55, height: 30));
                btnUploadPicturePan.setTitle(" Upload PAN Card copy from Gallery", forState: .Normal)
                btnUploadPicturePan.titleLabel?.font = UIFont.systemFontOfSize(14)
                btnUploadPicturePan.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
                btnUploadPicturePan.titleLabel?.textAlignment = .Left
                btnUploadPicturePan.contentHorizontalAlignment = .Left;
                cell.contentView.addSubview(btnUploadPicturePan)

                btnUploadPicturePanIcon.addTarget(self, action: #selector(PanVerificationScreen.btnUploadPAN(_:)), forControlEvents: .TouchUpInside)
                btnUploadPicturePan.addTarget(self, action: #selector(PanVerificationScreen.btnUploadPAN(_:)), forControlEvents: .TouchUpInside)


                var lblOption3 : UILabel!
                lblOption3 = UILabel(frame: CGRect(x: 10, y: lblUploadPan.frame.size.height + lblOption1.frame.size.height + btnClickPicturePanIcon.frame.size.height + lblOption2.frame.size.height + btnUploadPicturePan.frame.size.height + 18 , width: 60, height: 15));
                lblOption3.text = "Option 3 :"
                lblOption3.textColor = UIColor.blackColor()
                lblOption3.font = UIFont.systemFontOfSize(11)
                cell.contentView.addSubview(lblOption3)
                
                btnCheckBoxPanEmail = UIButton(frame: CGRect(x: 12, y: lblUploadPan.frame.size.height + lblOption1.frame.size.height + btnClickPicturePanIcon.frame.size.height + lblOption2.frame.size.height + lblOption3.frame.size.height + btnUploadPicturePan.frame.size.height + 26, width: 20, height: 20));
                cell.contentView.addSubview(btnCheckBoxPanEmail)
                btnCheckBoxPanEmail.backgroundColor = UIColor.clearColor()
                btnCheckBoxPanEmail.layer.cornerRadius = 2.0
                btnCheckBoxPanEmail.layer.borderWidth = 2
                btnCheckBoxPanEmail.layer.borderColor = UIColor.defaultMenuGray.CGColor
                
                //set highlighted image
                btnCheckBoxPanEmail.setImage(UIImage(named: "iconCheckEmail"), forState: UIControlState.Selected)

                
                btnCheckPanEmail = UIButton(frame: CGRect(x: 40, y: lblUploadPan.frame.size.height + lblOption1.frame.size.height + btnClickPicturePanIcon.frame.size.height + lblOption2.frame.size.height + lblOption3.frame.size.height + btnUploadPicturePan.frame.size.height + 21, width: (cell.contentView.frame.size.width)-55, height: 30));
                btnCheckPanEmail.setTitle(" I will send PAN Card copy by e-mail", forState: .Normal)
                btnCheckPanEmail.titleLabel?.font = UIFont.systemFontOfSize(14)
                btnCheckPanEmail.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
                btnCheckPanEmail.titleLabel?.textAlignment = .Left
                btnCheckPanEmail.contentHorizontalAlignment = .Left;
                cell.contentView.addSubview(btnCheckPanEmail)
                
                btnCheckBoxPanEmail.addTarget(self, action: #selector(PanVerificationScreen.btnEmailCheckboxClicked(_:)), forControlEvents: .TouchUpInside)
                btnCheckPanEmail.addTarget(self, action: #selector(PanVerificationScreen.btnEmailCheckboxClicked(_:)), forControlEvents: .TouchUpInside)

                
                var lblLine : UILabel!
                lblLine = UILabel(frame: CGRect(x: 10, y: 189, width: (cell.contentView.frame.size.width)-20, height: 1));
                lblLine.backgroundColor = UIColor.lightGrayColor()
                lblLine.alpha = 0.4
                cell.contentView.addSubview(lblLine)

                
                break;
            case 2:
                
                var lblUploadPan : UILabel!
                lblUploadPan = UILabel(frame: CGRect(x: 10, y: 0, width: (cell.contentView.frame.size.width)-20, height: 30));
                lblUploadPan.text = "Selfie"
                lblUploadPan.textColor = UIColor.blackColor()
                lblUploadPan.font = UIFont.systemFontOfSize(16)
                cell.contentView.addSubview(lblUploadPan)
                
                let btnCamera = UIButton(frame: CGRect(x: 5, y: lblUploadPan.frame.size.height, width: 35, height: 30));
                btnCamera.setImage(UIImage(named: "iconCamera"), forState: .Normal)
                cell.contentView.addSubview(btnCamera)
                btnCamera.alpha = 0.6

                let btnCameraSelfie = UIButton(frame: CGRect(x: 40, y: lblUploadPan.frame.size.height, width: (cell.contentView.frame.size.width)-55, height: 30));
                btnCameraSelfie.setTitle(" Click Selfie", forState: .Normal)
                btnCameraSelfie.titleLabel?.font = UIFont.systemFontOfSize(16)
                btnCameraSelfie.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
                btnCameraSelfie.titleLabel?.textAlignment = .Left
                btnCameraSelfie.contentHorizontalAlignment = .Left;
                cell.contentView.addSubview(btnCameraSelfie)
                
                btnCamera.addTarget(self, action: #selector(PanVerificationScreen.btnCaptureSelfie(_:)), forControlEvents: .TouchUpInside)
                btnCameraSelfie.addTarget(self, action: #selector(PanVerificationScreen.btnCaptureSelfie(_:)), forControlEvents: .TouchUpInside)

                break;

            default:
                break;
            }
            
        }else{
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.contentView.backgroundColor = UIColor.clearColor()
        cell.backgroundColor = UIColor.clearColor()
        
        return cell;
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row==0 {
            
            if self.isPanValid
            {
                return 110
                
            }else{
                return 65
            }
            
        }
        if indexPath.row==1 {
            return 190
        }
        if indexPath.row==2 {
            return 65
        }
        return 55
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView(frame: CGRect(x: 10, y: 0, width: tableView.frame.size.width-20, height: 110))
        view.backgroundColor = UIColor.whiteColor()
        
        let imageProfile = UIImageView(frame: CGRect(x: (view.frame.size.width/2)-45, y: 10, width: 90, height: 90))
        imageProfile.backgroundColor = UIColor.whiteColor()
        imageProfile.layer.cornerRadius = 42
        let image = UIImage(named: "iconProfile")?.imageWithRenderingMode(.AlwaysTemplate)
        imageProfile.tintColor = UIColor.defaultAppColorBlue
        imageProfile.image = image
        view.addSubview(imageProfile)
        imageProfile.center = view.center
        
        let label = UILabel(frame: CGRect(x: 10, y: view.frame.size.height-1, width: view.frame.size.width, height: 1))
        label.backgroundColor = UIColor.lightGrayColor()
        view.addSubview(label)
        label.alpha = 0.4
        
        return view
    }
    
    // UITextField Delegates
    func textFieldDidBeginEditing(textField: UITextField) {
        print("TextField did begin editing method called")
    }
    func textFieldDidEndEditing(textField: UITextField) {
        
        print("TextField did end editing method called")
        
    }
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        print("TextField should begin editing method called")
        return true;
    }
    func textFieldShouldClear(textField: UITextField) -> Bool {
        print("TextField should clear method called")
        return true;
    }
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        print("TextField should snd editing method called")
        return true;
    }
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        isPanValid = false
        
        var updatedTextString : NSString = textField.text! as NSString
        updatedTextString = updatedTextString.stringByReplacingCharactersInRange(range, withString: string)
        if textField == txtPan {
            
            if updatedTextString.length==10 {
                print("CALL WEB API TO CHECK PAN CARD...")
                txtPan.text = updatedTextString as String

                //panno
                textField.resignFirstResponder()
                
                let dicToSend:NSDictionary = [
                    "panno" : updatedTextString]
                
                WebManagerHK.postDataToURL(kModePanInquiryInfo, params: dicToSend, message: "Validating PAN..") { (response) in
                    print("Dic Response : \(response)")
                    
                    if response.objectForKey(kWAPIResponse) is NSDictionary
                    {
                        let mainResponse = response.objectForKey(kWAPIResponse) as! NSDictionary

                        let appStatus = String(mainResponse.objectForKey("APP_STATUS")!)
                        let last4 = String(appStatus.characters.suffix(2))
                        if (last4 == "01" || last4 == "02")
                        {
                            self.isPanValid = true
                            print("PAN is VALID ....")
                            self.nameFromPan = String(mainResponse.objectForKey("APP_NAME")!)
                            sharedInstance.objLoginUser.Name = String(mainResponse.objectForKey("APP_NAME")!)


                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                self.lblName.hidden = false
                                self.lblNameDisp.hidden = false
                                self.lblNameLine.hidden = false

                                self.lblName.text = self.nameFromPan

                                self.lblNameDisp.frame = CGRect(x: 10, y: 55, width: (self.tblView.frame.size.width)-20, height: 22);
                                self.lblName.frame = CGRect(x: 10, y: 70, width: (self.tblView.frame.size.width)-20, height: 35);
                                self.lblNameLine.frame = CGRect(x: 10, y: 55, width: (self.tblView.frame.size.width)-20, height: 1);
                                self.txtPan.frame = CGRect(x: 0, y: 10, width: (self.tblView.frame.size.width)-20, height: 45);
                                self.txtPanLine.frame = CGRect(x: 0, y: 105, width: (self.tblView.frame.size.width)-20, height: 1);
                                
                                self.tblView.reloadData()

                            })


                        }
                        else{
                            self.isPanValid = false

                            print("PAN is NOT... VALID ....")

                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                
                                self.lblNameDisp.hidden = true
                                self.lblName.hidden = true
                                self.lblNameLine.hidden = true

                                self.lblName.text = ""

                                self.txtPan.frame = CGRect(x: 0, y: 5, width: (self.tblView.frame.size.width)-20, height: 40);
                                self.txtPanLine.frame = CGRect(x: 0, y: 40, width: (self.tblView.frame.size.width)-20, height: 1);

                                
                                self.tblView.reloadData()

                                SharedManager.invokeAlertMethod(APP_NAME, strBody: "Sorry, we are currently supporting only KYC complaint customers. Please complete the KYC process online to start investing.", delegate: nil)

                            })

                            

//                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                            })
                        }
                        
                        

                        
                        
                        
                    }
                }
                
                
                
            }
        }
        return true;
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        print("TextField should return method called")
        
        if textField.text=="" {
            tblView.reloadData()
            textField.resignFirstResponder();
            return true;
        }
        textField.resignFirstResponder();
        return true;
    }
    
    
    @IBAction func btnSubmitClicked(sender: AnyObject) {

//        let objOtherInfo = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdOtherInfo) as! OtherInfo
//        objOtherInfo.isFrom = self.isFrom
//        self.navigationController?.pushViewController(objOtherInfo, animated: true)
//        return
        
//        txtPan.text = "EX1490CDEE"
//        isPanValid = true
//        nameFromPan = "HemenGohil"
//        sharedInstance.objLoginUser.Name = "HemenGohil"
        
        
        if (txtPan.text!.isEmpty) {
            SharedManager.invokeAlertMethod(APP_NAME, strBody: "Please enter PAN number.", delegate: nil)
            return;
        }
        if isPanValid {
            
        }else{
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                SharedManager.invokeAlertMethod(APP_NAME, strBody: "Sorry, we are currently supporting only KYC complaint customers. Please complete the KYC process online to start investing.", delegate: nil)
            })
            return
        }
        
        let arrDic : NSMutableArray = []
        
        var isImagePicked = false
        if imagePicked==nil {
            isImagePicked = false
        }else{
            isImagePicked = true
            //                let imageData:NSData = UIImagePNGRepresentation(self.imagePicked)!
                let imageData:NSData = UIImageJPEGRepresentation(self.imagePicked, 1)!
                
                let strBase64:String = imageData.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
                let pan64 = "data:image/jpeg;base64,\(strBase64)"
                arrDic.addObject(["DocumentType" : "\(DocumentType.Pan.hashValue)","SendCopyType" : "App","DocumentData" : pan64])
                
           
        }
        
        if btnCheckBoxPanEmail.selected {
            arrDic.addObject(["DocumentType":"\(DocumentType.Pan.hashValue)","SendCopyType" : "Email","DocumentData" : ""])
        }else{
            if isImagePicked==true {
                
            }else{
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    SharedManager.invokeAlertMethod(APP_NAME, strBody: "Please Upload PAN Card.", delegate: nil)
                })
                return
            }
        }
        
        if imageSelfie==nil {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                SharedManager.invokeAlertMethod(APP_NAME, strBody: "Please take selfie.", delegate: nil)
            })
            return
        }else{
                let imageData:NSData = UIImagePNGRepresentation(self.imageSelfie)!
                let strBase64Selfie:String = imageData.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
                let selfie64 = "data:image/jpeg;base64,\(strBase64Selfie)"
                arrDic.addObject(["DocumentType":"\(DocumentType.Selfie.hashValue)","SendCopyType" : "App","DocumentData" : selfie64])
        }
        
        let dicToSend:NSDictionary = [
            "ClientId" : sharedInstance.objLoginUser.ClientID,
            "PassWord" : sharedInstance.objLoginUser.password,
            "PANNo" : txtPan.text!,
            "MobileNo" : sharedInstance.objLoginUser.mob,
            "Name" : nameFromPan,
            "AndroidAppSync" : "0",
            "DocumentArr" : arrDic]

//        let dicToSend:NSDictionary = [
//            "ClientId" : "123",
//            "PassWord" : "darshan@123",
//            "PANNo" : "33rETF3234D",
//            "MobileNo" : "9033650336",
//            "Name" : "Jasmin",
//            "AndroidAppSync" : "0",
//            "DocumentArr" : arrDic]
        
        
        WebManagerHK.postDataToURL(kModeUpdatePanInfo, params: dicToSend, message: "Registering your details..") { (response) in
            print("Dic Response : \(response)")
            
            if response.objectForKey(kWAPIResponse) is String
            {
                let mainResponse = response.objectForKey(kWAPIResponse) as! String
                print("Response : \(mainResponse)")
                
                if mainResponse == "-2" // PAN is already in USE....
                {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        SharedManager.invokeAlertMethod(APP_NAME, strBody: "PAN card is already in use.", delegate: nil)
                    })
                    return
                }
                if mainResponse == "-4" // Invalid Password....
                {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        SharedManager.invokeAlertMethod(APP_NAME, strBody: "Invalid Password.", delegate: nil)
                    })
                    return
                }

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
                userInfo.InvestmentAofStatus = sharedInstance.objLoginUser.InvestmentAofStatus
                
                print("INSERTED DATA \(userInfo)")
                
                let isInserted = DBManager.getInstance().updateUser(userInfo)
                if isInserted {
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        
                        if self.isFrom == .SwitchToDirect
                        {
                            
                            let alertController = UIAlertController(title: "Signup Successful", message: "Thanks for signing up. You can SWITCH now or create Investment Acount to start investment.", preferredStyle: .Alert)
                            
                            let defaultAction = UIAlertAction(title: "CREATE INVESTMENT A/C", style: .Default, handler: { (defaultAction1) in
                                
                                let objOtherInfo = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdOtherInfo) as! OtherInfo
                                objOtherInfo.isFrom = self.isFrom
                                self.navigationController?.pushViewController(objOtherInfo, animated: true)

                            })
                            let defaultAction2 = UIAlertAction(title: "SWITCH NOW", style: .Default, handler: { (defaultAction1) in
                                
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
                                
                            })

                            alertController.addAction(defaultAction)
                            alertController.addAction(defaultAction2)

                            self.presentViewController(alertController, animated: true, completion: nil)
                            
                        }else{
                            
                            let objOtherInfo = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdOtherInfo) as! OtherInfo
                            objOtherInfo.isFrom = self.isFrom
                            self.navigationController?.pushViewController(objOtherInfo, animated: true)

                        }
                        
                    })
                    
                } else {
                    SharedManager.invokeAlertMethod("", strBody: "Error in saving record.", delegate: nil)
                }

            }

            if response.objectForKey(kWAPIResponse) is NSInteger
            {
                let mainResponse = response.objectForKey(kWAPIResponse) as! NSInteger
                
                if mainResponse == -2 // PAN is already in USE....
                {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        SharedManager.invokeAlertMethod(APP_NAME, strBody: "PAN card is already in use.", delegate: nil)
                    })
                    return
                }
                if mainResponse == -4 // Invalid Password....
                {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        SharedManager.invokeAlertMethod(APP_NAME, strBody: "Invalid Password.", delegate: nil)
                    })
                    return
                }
                
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
                userInfo.InvestmentAofStatus = sharedInstance.objLoginUser.InvestmentAofStatus
                
                print("INSERTED DATA \(userInfo)")
                
                let isInserted = DBManager.getInstance().updateUser(userInfo)
                if isInserted {
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        
                        if self.isFrom == .SwitchToDirect
                        {
                            
                            let alertController = UIAlertController(title: "Signup Successful", message: "Thanks for signing up. You can SWITCH now or create Investment Acount to start investment.", preferredStyle: .Alert)
                            
                            let defaultAction = UIAlertAction(title: "CREATE INVESTMENT A/C", style: .Default, handler: { (defaultAction1) in
                                
                                let objOtherInfo = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdOtherInfo) as! OtherInfo
                                objOtherInfo.isFrom = self.isFrom
                                self.navigationController?.pushViewController(objOtherInfo, animated: true)
                                
                            })
                            
                            let defaultAction2 = UIAlertAction(title: "SWITCH NOW", style: .Default, handler: { (defaultAction1) in
                                
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
                            })
                            alertController.addAction(defaultAction)
                            alertController.addAction(defaultAction2)
                            self.presentViewController(alertController, animated: true, completion: nil)
                            
                        }
                        else if self.isFrom == .BuySIP
                        {
                            let objOtherInfo = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdOtherInfo) as! OtherInfo
                            objOtherInfo.isFrom = self.isFrom
                            self.navigationController?.pushViewController(objOtherInfo, animated: true)

                        }
                        else if self.isFrom == .BuySIPFromTopFunds
                        {
                            let objOtherInfo = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdOtherInfo) as! OtherInfo
                            objOtherInfo.isFrom = self.isFrom
                            self.navigationController?.pushViewController(objOtherInfo, animated: true)
                            
                        }
                        else{
                            
                            let objOtherInfo = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdOtherInfo) as! OtherInfo
                            objOtherInfo.isFrom = self.isFrom
                            self.navigationController?.pushViewController(objOtherInfo, animated: true)
                            
                        }
                    })
                } else {
                    SharedManager.invokeAlertMethod("", strBody: "Error in saving record.", delegate: nil)
                }
            }
        }
    }
    
    func clearAllFields() {
        txtPan.text = ""

    }

    @IBAction func btnCapturePAN(sender: AnyObject) {
        
        if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil {
            
            imageClickedIndex = 1
            
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerControllerSourceType.Camera
            picker.cameraCaptureMode = .Photo
            presentViewController(picker, animated: true, completion: nil)
        } else {
            noCamera()
        }
    }
    
    @IBAction func btnEmailCheckboxClicked(sender: AnyObject) {

        if btnCheckBoxPanEmail.selected {
            
            btnCheckBoxPanEmail.selected = false
            btnCheckBoxPanEmail.layer.cornerRadius = 2.0
            btnCheckBoxPanEmail.layer.borderWidth = 2
            btnCheckBoxPanEmail.layer.borderColor = UIColor.defaultMenuGray.CGColor

        }else{
            btnCheckBoxPanEmail.selected = true
            btnCheckBoxPanEmail.layer.cornerRadius = 2.0
            btnCheckBoxPanEmail.layer.borderWidth = 0
        }
        
    }

    
    @IBAction func btnUploadPAN(sender: AnyObject) {
        
        imageClickedIndex = 2
        picker.allowsEditing = false //2
        picker.sourceType = .PhotoLibrary //3
        presentViewController(picker, animated: true, completion: nil)//4
    }
    
    @IBAction func btnCaptureSelfie(sender: AnyObject) {
        
//        imageClickedIndex = 3
//        picker.allowsEditing = false //2
//        picker.sourceType = .PhotoLibrary //3
//        presentViewController(picker, animated: true, completion: nil)//4
        if UIImagePickerController.availableCaptureModesForCameraDevice(.Front) != nil {
            imageClickedIndex = 3

            picker.allowsEditing = false //2
            picker.sourceType = .PhotoLibrary //3
            presentViewController(picker, animated: true, completion: nil)//4

//            picker.allowsEditing = false
//            picker.sourceType = .Camera
//            picker.cameraDevice = .Front
//            picker.cameraCaptureMode = .Photo
//            presentViewController(picker, animated: true, completion: nil)
            
            
            
        } else {
            noCamera()
        }

    }

    //MARK: Delegates
    func imagePickerController(
        picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        
        let chosenImage = SharedManager.sharedInstance.resizeImage(selectedImage)
        
        if imageClickedIndex==1 {
            imagePicked = chosenImage
            lblImageUploadedRight.hidden = false
            lblImageUploadedRight.image = UIImage(named: "iconCheckPhotoUpload")

        }
        if imageClickedIndex==2 {
            imagePicked = chosenImage
            lblImageUploadedRight.hidden = false
            lblImageUploadedRight.image = UIImage(named: "iconCheckPhotoUpload")

        }
        if imageClickedIndex==3 {
            imageSelfie = chosenImage
        }
        
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
}
