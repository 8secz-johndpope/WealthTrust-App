//
//  ContactViewController.swift
//  WealthTrust
//
//  Created by Shree ButBhavani on 20/01/17.
//  Copyright © 2017 Hemen Gohil. All rights reserved.
//

import UIKit
import MessageUI

class ContactViewController: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var popupView = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        popupView?.layer.cornerRadius = 2
    }

    
    
    @IBAction func whatsappTap(sender: AnyObject)
    {
        
        let whatsappURL = NSURL(string: "whatsapp://")
        if (UIApplication.sharedApplication().canOpenURL(whatsappURL!))
        {
            UIApplication.sharedApplication().openURL(whatsappURL!)
        }
        
    }
    
    
    @IBAction func emailTap(sender: AnyObject)
    {
        sendEmail()
    }
    
    @IBAction func btnOkTap(sender: AnyObject)
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func sendEmail()
    {
        if MFMailComposeViewController.canSendMail()
        {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["service@wealthtrust.in"])
            mail.setMessageBody("", isHTML: false)
            
            //self.present(mail, animated: true)
            self.presentViewController(mail, animated: true, completion: nil)
            
        }
        else
        {
            // show failure alert
        }
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?)
    {
        controller.dismissViewControllerAnimated(true, completion: nil)
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

}
