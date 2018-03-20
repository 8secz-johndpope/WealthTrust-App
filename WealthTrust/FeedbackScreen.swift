//
//  FeedbackScreen.swift
//  WealthTrust
//
//  Created by Hemen Gohil on 12/24/16.
//  Copyright © 2016 Hemen Gohil. All rights reserved.
//

import UIKit

class FeedbackScreen: UIViewController,UITextViewDelegate,UITextFieldDelegate {

    @IBOutlet weak var txtViewFeedback: UITextView!
    @IBOutlet weak var viewFeedback: UIView!
    
    
    @IBOutlet weak var txtEmaiId: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        
        let titleDict: NSDictionary = [NSFontAttributeName: UIFont.boldSystemFontOfSize(18),NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController!.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        
        // Change the navigation bar background color to blue.
        self.navigationController!.navigationBar.barTintColor = UIColor.defaultAppColorBlue
        
        self.title = "Feedback"
        self.navigationController!.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont.boldSystemFontOfSize(18)]

        SharedManager.addShadowToView(self.viewFeedback)
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        
        let allUser = DBManager.getInstance().getAllUser()
        if allUser.count==0
        {
        }else{
            let objUser = allUser.objectAtIndex(0) as! User
            sharedInstance.objLoginUser = objUser
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: .None)
        
        self.setNavigationBarItemForWebView()
        
        
        let btnBack = UIButton()
        btnBack.frame = CGRect(x:SCREEN_WIDTH-42, y:2, width:40, height:40)
        btnBack.addTarget(self, action: #selector(FeedbackScreen.btnRightTap(_:)), forControlEvents: .TouchUpInside)
        if let image = UIImage(named: "ic_done_white") {
            btnBack.setImage(image, forState: .Normal)
        }
        self.navigationController!.navigationBar.addSubview(btnBack)

        
        txtViewFeedback.text = "Please provide your feedback"
        txtViewFeedback.textColor = UIColor.lightGrayColor()
        txtEmaiId.text = ""
        txtEmaiId.resignFirstResponder()
        txtViewFeedback.resignFirstResponder()
        
        if sharedInstance.objLoginUser.email.isEmpty {
            
        }else{
            txtEmaiId.text = sharedInstance.objLoginUser.email
            txtEmaiId.enabled = false
        }
    }

    override func viewWillDisappear(animated: Bool) {
        txtViewFeedback.resignFirstResponder()
    }
    
    
    func btnRightTap( sender:AnyObject) {
        
        
        if (txtEmaiId.text!.isEmpty) {
            SharedManager.invokeAlertMethod(APP_NAME, strBody: kAlertEmptyEmailId, delegate: nil)
            return;
        }
        if (txtEmaiId.text!.isValidEmail()) {
        }else{
            SharedManager.invokeAlertMethod(APP_NAME, strBody: kAlertEmailIdIsValidEmail, delegate: nil)
            return;
        }
        if (txtViewFeedback.text!.isEmpty) {
            SharedManager.invokeAlertMethod(APP_NAME, strBody: kAlertFeedback, delegate: nil)
            return;
        }

        txtEmaiId.resignFirstResponder()
        txtViewFeedback.resignFirstResponder()
        
        // Call API NOW...
        // API Call
        
        let dicToSend:NSDictionary = [
            "email" : self.txtEmaiId.text!,
            "feedback1" : self.txtViewFeedback.text!]
        
        WebManagerHK.postDataToURL(kModeSaveFeeback, params: dicToSend, message: "Sending feedback..") { (response) in
            
            print("Dic Response : \(response)")
            
            
            // SIP
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                self.txtViewFeedback.text = ""
                if self.txtViewFeedback.text.isEmpty {
                    self.txtViewFeedback.text = "Please provide your feedback"
                    self.txtViewFeedback.textColor = UIColor.lightGrayColor()
                }

                if response.objectForKey(kWAPIResponse) is NSInteger
                {
                    let mainResponse = response.objectForKey(kWAPIResponse) as! NSInteger
                    if mainResponse==1
                    {
                        
                        let alertController = UIAlertController(title: APP_NAME, message: "Thank You for your Feedback.", preferredStyle: .Alert)
                        
                        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: { (defaultAction1) in
                            
                            print("YES CAKKKEDDD OKJJJJJJKKKKK")
                            self.navigationController?.popViewControllerAnimated(true)
                            
                        })
                        
                        alertController.addAction(defaultAction)
                        self.presentViewController(alertController, animated: true, completion: nil)

                    }else{
                        
                        let alertController = UIAlertController(title: APP_NAME, message: "Error in sending feedback. Please try again later.", preferredStyle: .Alert)
                        
                        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: { (defaultAction1) in
                            print("YES CAKKKEDDD OKJJJJJJKKKKK")
                            self.navigationController?.popViewControllerAnimated(true)
                            
                        })
                        alertController.addAction(defaultAction)
                        self.presentViewController(alertController, animated: true, completion: nil)
                    }
                }
             
                
            })

            
        }
        
        
        
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == UIColor.lightGrayColor() {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Please provide your feedback"
            textView.textColor = UIColor.lightGrayColor()
        }
    }

    
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        
//        // Combine the textView text and the replacement text to
//        // create the updated text string
//        let currentText = textView.text
//        let updatedText = currentText?.replacingCharacters(in: range as Range, with: text)
//        
//        // If updated text view will be empty, add the placeholder
//        // and set the cursor to the beginning of the text view
//        if updatedText.isEmpty {
//            
//            textView.text = "Placeholder"
//            textView.textColor = UIColor.lightGray
//            
//            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
//            
//            return false
//        }
//            
//            // Else if the text view's placeholder is showing and the
//            // length of the replacement string is greater than 0, clear
//            // the text view and set its color to black to prepare for
//            // the user's entry
//        else if textView.textColor == UIColor.lightGray && !text.isEmpty {
//            textView.text = nil
//            textView.textColor = UIColor.black
//        }
//        
//        return true
//    }

    
    
    // UITextField Delegates
    func textFieldDidBeginEditing(textField: UITextField) {
        print("TextField did begin editing method called")
        
        if self.txtViewFeedback.text.isEmpty {
            self.txtViewFeedback.text = "Please provide your feedback"
            self.txtViewFeedback.textColor = UIColor.lightGrayColor()
        }

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
        print("While entering the characters this method gets called")
        return true;
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        print("TextField should return method called")
        
        if textField==self.txtEmaiId {
            self.txtViewFeedback.becomeFirstResponder()
            return true;
        }
//
//        textField.resignFirstResponder();
        return true;
    }

}
