//
//  SwiftViewController.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 1/19/15.
//  Copyright (c) 2015 Yuji Hato. All rights reserved.
//



import UIKit

class SwiftViewController: UIViewController,UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    
    
    @IBOutlet weak var avtiviryIndi: UIActivityIndicatorView!
    
    var titleToDisplay = ""
    
    var isBackArrow = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        
        let titleDict: NSDictionary = [NSFontAttributeName: UIFont.boldSystemFontOfSize(18),NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController!.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        
        // Change the navigation bar background color to blue.
        self.navigationController!.navigationBar.barTintColor = UIColor.defaultAppColorBlue
        
        
    }

//    override func viewWillAppear(animated: Bool) {
//        super.viewWillAppear(animated)
//        self.navigationController?.setNavigationBarHidden(true, animated: false)
//
////        self.removeNavigationBarItem()
//        self.setNavigationBarItemLeft()
//    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: .None)
        
        if isBackArrow {
            
            let btnBack = UIButton()
            btnBack.frame = CGRect(x:0, y:0, width:30, height:30)
            btnBack.addTarget(self, action: #selector(SwiftViewController.btnBackTap(_:)), forControlEvents: .TouchUpInside)
            if let image = UIImage(named: "iconBack") {
                btnBack.setImage(image, forState: .Normal)
            }

//            self.navigationItem.hidesBackButton = true
//            self.navigationItem.backBarButtonItem = UIBarButtonItem.init(customView: btnBack)
            self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: btnBack)
        }else{
            self.setNavigationBarItemForWebView()
        }
        
        self.title = sharedInstance.userDefaults.objectForKey(kTITLE_TO_DISPLAY) as? String
        
        webView.delegate = self
        
        let myURLBlank = NSURL(string: "about:blank")
        let myURLRequestBlank:NSURLRequest = NSURLRequest(URL: myURLBlank!)
        webView.loadRequest(myURLRequestBlank)

        
        //1. Load web site into my web view
        let myURL = NSURL(string: (sharedInstance.userDefaults.objectForKey(kURL_TO_LOAD) as? String)!)
        let myURLRequest:NSURLRequest = NSURLRequest(URL: myURL!)
        webView.loadRequest(myURLRequest)

    }

    func btnBackTap( sender:AnyObject) {

        self.navigationController?.popViewControllerAnimated(true)
        
    }

    func webViewDidStartLoad(webView: UIWebView)
    {
        avtiviryIndi.startAnimating()
    }
    func webViewDidFinishLoad(webView: UIWebView)
    {
        avtiviryIndi.stopAnimating()
    }
    
    @IBAction func refreshButtonTapped(sender: AnyObject) {
        webView.reload()
    }

}
