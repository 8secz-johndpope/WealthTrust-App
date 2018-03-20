//
//  WebViewController.swift
//  WealthTrust
//
//  Created by Shree ButBhavani on 20/01/17.
//  Copyright © 2017 Hemen Gohil. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

    var urlLink = NSURL()
    var screenTitle = String()
    @IBOutlet weak var webView = UIWebView()
    @IBOutlet weak var activityIndi = UIActivityIndicatorView()
    @IBOutlet weak var lblTitle = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool)
    {
        lblTitle!.text = screenTitle
        let myURLRequest:NSURLRequest = NSURLRequest(URL: urlLink)
        webView!.loadRequest(myURLRequest)
    }
    
    func webViewDidStartLoad(webView: UIWebView)
    {
        activityIndi!.startAnimating()
    }
    func webViewDidFinishLoad(webView: UIWebView)
    {
        activityIndi!.stopAnimating()
    }
    
    @IBAction func btnBackClick(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
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
