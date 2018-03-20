//
//  IntroScreen.swift
//  WealthTrust
//
//  Created by Hemen Gohil on 9/13/16.
//  Copyright © 2016 Hemen Gohil. All rights reserved.
//

import UIKit

class IntroScreen: UIViewController,UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    
    var image1 : UIImageView!
    var image2 : UIImageView!
    var image3 : UIImageView!

    var btnStart : UIButton!

    var timer : NSTimer!
    var pageControl : UIPageControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        timer = NSTimer.scheduledTimerWithTimeInterval(15.0, target: self, selector: #selector(IntroScreen.randomScreenRotation), userInfo: nil, repeats: true)
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            
            
            self.image1 = UIImageView(frame: CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT))
            self.image1.backgroundColor = UIColor.blueColor()
            self.image1.image = UIImage(named: "Intro1")
            
            self.image2 = UIImageView(frame: CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT))
            self.image2.backgroundColor = UIColor.cyanColor()
            self.image2.image = UIImage(named: "Intro2")

            self.image3 = UIImageView(frame: CGRectMake((SCREEN_WIDTH*2), 0, SCREEN_WIDTH, SCREEN_HEIGHT))
            self.image3.backgroundColor = UIColor.grayColor()
            self.image3.image = UIImage(named: "Intro3")


            self.scrollView.addSubview(self.image1)
            self.scrollView.addSubview(self.image2)
            self.scrollView.addSubview(self.image3)
            
            self.scrollView.contentSize = CGSize(width:(SCREEN_WIDTH*3), height: SCREEN_HEIGHT)
            self.scrollView.pagingEnabled = true
            self.scrollView.delegate = self
            
            self.pageControl = UIPageControl(frame: CGRectMake((SCREEN_WIDTH/2)-100, SCREEN_HEIGHT-40, 200, 50))
            self.configurePageControl()

            //self.btnStart = UIButton(frame: CGRectMake((SCREEN_WIDTH/2)-90, SCREEN_HEIGHT-70, 180, 35))
            self.btnStart = UIButton(type: UIButtonType.System)
            self.btnStart.frame = CGRectMake((SCREEN_WIDTH/2)-90, SCREEN_HEIGHT-70, 180, 35)
            self.btnStart.backgroundColor = UIColor.clearColor()
            self.btnStart.setTitle("START WEALTHTRUST", forState: .Normal)
            self.btnStart.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            self.btnStart.titleLabel?.font = UIFont.systemFontOfSize(14)
            self.btnStart.layer.cornerRadius = 3;
            self.btnStart.layer.borderColor = UIColor.whiteColor().CGColor;
            self.btnStart.layer.borderWidth = 2.0
            self.btnStart.addTarget(self, action: #selector(IntroScreen.btnStartClicked(_:)), forControlEvents: .TouchUpInside)

            self.view.addSubview(self.btnStart)
            
        })
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: .None)

        
    }
    
    func randomScreenRotation() {
        
        print("ROTATING ................................")
        
    }

    func configurePageControl() {
        // The total number of pages that are available is based on how many available colors we have.
        self.pageControl.numberOfPages = 3
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.redColor()
        self.pageControl.pageIndicatorTintColor = UIColor.whiteColor()
        self.pageControl.currentPageIndicatorTintColor = UIColor.defaultOrangeButton
        self.view.addSubview(pageControl)
        
    }
    
    // MARK : TO CHANGE WHILE CLICKING ON PAGE CONTROL
    func changePage(sender: AnyObject) -> () {
        let x = CGFloat(pageControl.currentPage) * scrollView.frame.size.width
        scrollView.setContentOffset(CGPointMake(x, 0), animated: true)
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }

    @IBAction func btnStartClicked(sender: AnyObject) {
        
//        AppDelegate
        sharedInstance.userDefaults.setBool(true, forKey: kIsOpenedFirstTime)
        
        SharedManager.appDelegate.createMenuView()
        
        
//        var obj = AppDelegate()
//        
//        
//        // create viewController code...
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        
//        let mainViewController = storyboard.instantiateViewControllerWithIdentifier("MainViewController") as! MainViewController
//        let leftViewController = storyboard.instantiateViewControllerWithIdentifier("LeftViewController") as! LeftViewController
//        let rightViewController = storyboard.instantiateViewControllerWithIdentifier("RightViewController") as! RightViewController
//        
//        let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
//        
//        UINavigationBar.appearance().tintColor = UIColor.blueColor()
//        
//        leftViewController.mainViewController = nvc
//        
//        let slideMenuController = ExSlideMenuController(mainViewController:nvc, leftMenuViewController: leftViewController, rightMenuViewController: rightViewController)
//        slideMenuController.automaticallyAdjustsScrollViewInsets = true
//        slideMenuController.delegate = mainViewController
//        
//        obj.window?.backgroundColor = UIColor(red: 236.0, green: 238.0, blue: 241.0, alpha: 1.0)
//        obj.window?.rootViewController = slideMenuController

    }
    
//    override func prefersStatusBarHidden() -> Bool {
//        return true
//    }

    
}
