//
//  LeftViewController.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 12/3/14.
//

import UIKit

enum LeftMenu: Int {
    case Dashboard = 0
    case Transact
    case Portfolio
    case Pricing
    case ContactUs
    case About
    case Feedback
    case FAQs
    case Blog
    case Privacy
}

protocol LeftMenuProtocol : class {
    func changeViewController(menu: LeftMenu)
}

let URL_PRICING = "https://www.wealthtrust.in/#price"
let URL_ABOUT = "https://www.wealthtrust.in/whywealthtrust.html"
let URL_FEEDBACK = ""
let URL_FAQs = "http://www.wealthtrust.in/faq.html"
let URL_BLOG = "https://www.wealthtrust.in/blog"
let URL_PRIVACY = "https://www.wealthtrust.in/privacy-policy.html"

let URL_SIGNUP_HELP = "http://www.wealthtrust.in/faq.html#sign-up"
let URL_SIGNUP_TERMS = "https://www.wealthtrust.in/terms-of-use.html#app-portal-div"
let URL_INVESTMENT_HELP    = "http://www.wealthtrust.in/faq.html#investment-account"
let kURL_TO_LOAD = "UrlToLoad"
let kTITLE_TO_DISPLAY = "TitleToDisplay"


let URL_FACEBOOK = "https://www.facebook.com/WealthTrust"//fb://profile/1530323843942273
let URL_GOOGLE = "https://plus.google.com/104680975443762193197"
let URL_TWITTER = "https://twitter.com/WealthTrust"
let URL_RATEUS = ""
let URL_SHARE = ""




class LeftViewController : UIViewController, LeftMenuProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    var menus = ["Dashboard","Transact","Portfolio","Pricing", "Contact Us", "About", "Feedback", "FAQs", "Blog", "Privacy"]
    var menuImages = ["slide_dashboard", "slide_Transact","slide_portfolio","slide_pricing", "slide_contactus", "slide_about", "slide_feedback","slide_faq","slide_blog","slide_lock"]

    var mainViewController: UIViewController!
    var transactController: UIViewController!
    var portfolioController: UIViewController!
    
    var contactViewController = UIViewController()
    
    var swiftViewController: UIViewController!
    var feedbackViewController: UIViewController!

    var goViewController: UIViewController!
    var nonMenuViewController: UIViewController!
    
    var imageHeaderView: ImageHeaderView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1.0)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let transactController = storyboard.instantiateViewControllerWithIdentifier("TransactScreen") as! TransactScreen
        self.transactController = UINavigationController(rootViewController: transactController)

        let portfolioController = storyboard.instantiateViewControllerWithIdentifier("PortfolioScreen") as! PortfolioScreen
        self.portfolioController = UINavigationController(rootViewController: portfolioController)

        
        self.contactViewController = storyboard.instantiateViewControllerWithIdentifier("ContactViewController") as! ContactViewController
        
        let swiftViewController = storyboard.instantiateViewControllerWithIdentifier("SwiftViewController") as! SwiftViewController
        self.swiftViewController = UINavigationController(rootViewController: swiftViewController)
        
        let feedbackViewController = storyboard.instantiateViewControllerWithIdentifier("FeedbackScreen") as! FeedbackScreen
        self.feedbackViewController = UINavigationController(rootViewController: feedbackViewController)

        
        let goViewController = storyboard.instantiateViewControllerWithIdentifier("GoViewController") as! GoViewController
        self.goViewController = UINavigationController(rootViewController: goViewController)
        
        let nonMenuController = storyboard.instantiateViewControllerWithIdentifier("NonMenuController") as! NonMenuController
        nonMenuController.delegate = self
        self.nonMenuViewController = UINavigationController(rootViewController: nonMenuController)
        
        self.tableView.registerCellClass(BaseTableViewCell.self)
        
        self.imageHeaderView = ImageHeaderView.loadNib()
        self.view.addSubview(self.imageHeaderView)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let allUser = DBManager.getInstance().getAllUser()
        if allUser.count != 0 {
            let objUser = allUser.objectAtIndex(0) as! User
            self.imageHeaderView.lblUserName.text = objUser.Name
            self.imageHeaderView.lblUserEmail.text = objUser.email
        }

    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.imageHeaderView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 120)
        self.view.layoutIfNeeded()
    }
    
    func changeViewController(menu: LeftMenu) {
        
        switch menu {
        case .Dashboard:
            self.slideMenuController()?.changeMainViewController(self.mainViewController, close: true)
        case .Transact:
            self.slideMenuController()?.changeMainViewController(self.transactController, close: true)
        case .Portfolio:
            
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            self.slideMenuController()?.changeMainViewController(self.portfolioController, close: true)
        case .Pricing:
            
            sharedInstance.userDefaults.setObject(URL_PRICING, forKey: kURL_TO_LOAD)
            sharedInstance.userDefaults.setObject("Pricing", forKey: kTITLE_TO_DISPLAY)
            
            self.slideMenuController()?.changeMainViewController(self.swiftViewController, close: true)

//                        closeLeft()
//                        closeRight()
//
//            let swiftView = storyboard!.instantiateViewControllerWithIdentifier("SwiftViewController") as! SwiftViewController
//
//            openWebWith(swiftView)
//
//            print(self.slideMenuController()?.mainViewController)
//            self.navigationController?.pushViewController(self.swiftViewController, animated: true)
//
//
//            self.slideMenuController()?.changeMainViewController(self.swiftViewController, close: true)
            
        case .ContactUs:
            
            self.contactViewController.modalPresentationStyle = .OverCurrentContext
            presentViewController(self.contactViewController, animated: true, completion: nil)
            //self.slideMenuController()?.changeMainViewController(self.mainViewController, close: true)
            //self.contactViewController.view.frame = self.view.frame
            //self.addChildViewController(self.contactViewController)
            //self.view.window!.addSubview(self.contactViewController.view)
            //self.contactViewController.didMoveToParentViewController(self)
            //self.presentViewController(self.contactViewController, animated: true, completion: nil)
            
            
        case .About:
            
            sharedInstance.userDefaults.setObject(URL_ABOUT, forKey: kURL_TO_LOAD)
            sharedInstance.userDefaults.setObject("About", forKey: kTITLE_TO_DISPLAY)

            self.slideMenuController()?.changeMainViewController(self.swiftViewController, close: true)
        case .Feedback:
            
            self.slideMenuController()?.changeMainViewController(self.feedbackViewController, close: true)
            
        case .FAQs:
            
            sharedInstance.userDefaults.setObject(URL_FAQs, forKey: kURL_TO_LOAD)
            sharedInstance.userDefaults.setObject("FAQs", forKey: kTITLE_TO_DISPLAY)

            self.slideMenuController()?.changeMainViewController(self.swiftViewController, close: true)
        case .Blog:
            
            sharedInstance.userDefaults.setObject(URL_BLOG, forKey: kURL_TO_LOAD)
            sharedInstance.userDefaults.setObject("Blog", forKey: kTITLE_TO_DISPLAY)

            self.slideMenuController()?.changeMainViewController(self.swiftViewController, close: true)
        case .Privacy:
            
            sharedInstance.userDefaults.setObject(URL_PRIVACY, forKey: kURL_TO_LOAD)
            sharedInstance.userDefaults.setObject("Privacy", forKey: kTITLE_TO_DISPLAY)

            self.slideMenuController()?.changeMainViewController(self.swiftViewController, close: true)
        }
    }
    
    @IBAction func btnFBClicked(sender: AnyObject) {
        SharedManager.sharedInstance.uploadUserAction(USERACTIONTYPE.UA_FACEBOOK)
        
        self.closeLeft()
        let url = NSURL(string: "fb://profile/1530323843942273")!
        if UIApplication.sharedApplication().canOpenURL(url) {
            UIApplication.sharedApplication().openURL(url)
        }
        else{
            UIApplication.sharedApplication().openURL(NSURL(string: URL_FACEBOOK)!)
        }
//        sharedInstance.userDefaults.setObject(URL_FACEBOOK, forKey: kURL_TO_LOAD)
//        sharedInstance.userDefaults.setObject("Facebook", forKey: kTITLE_TO_DISPLAY)
//        self.slideMenuController()?.changeMainViewController(self.swiftViewController, close: true)
    }
    
    @IBAction func btnGPlusClicked(sender: AnyObject) {
        SharedManager.sharedInstance.uploadUserAction(USERACTIONTYPE.UA_GPLUS)
        self.closeLeft()
        
        let url = NSURL(string: "gplus://plus.google.com/104680975443762193197")!
        if UIApplication.sharedApplication().canOpenURL(url) {
            UIApplication.sharedApplication().openURL(url)
        }
        else{
            UIApplication.sharedApplication().openURL(NSURL(string: URL_GOOGLE)!)
        }
//        sharedInstance.userDefaults.setObject(URL_GOOGLE, forKey: kURL_TO_LOAD)
//        sharedInstance.userDefaults.setObject("Google+", forKey: kTITLE_TO_DISPLAY)
//        self.slideMenuController()?.changeMainViewController(self.swiftViewController, close: true)
    }
    
    @IBAction func btnTwitClicked(sender: AnyObject) {
        SharedManager.sharedInstance.uploadUserAction(USERACTIONTYPE.UA_TWITTER)
        self.closeLeft()
        let url = NSURL(string: "twitter://user?screen_name=WealthTrust")!
        if UIApplication.sharedApplication().canOpenURL(url) {
            UIApplication.sharedApplication().openURL(url)
        }
        else{
            UIApplication.sharedApplication().openURL(NSURL(string: URL_TWITTER)!)
        }
//        sharedInstance.userDefaults.setObject(URL_TWITTER, forKey: kURL_TO_LOAD)
//        sharedInstance.userDefaults.setObject("Twitter", forKey: kTITLE_TO_DISPLAY)
//        self.slideMenuController()?.changeMainViewController(self.swiftViewController, close: true)
    }
    
    @IBAction func btnStartClicked(sender: AnyObject) {
        // Rate US
        SharedManager.sharedInstance.uploadUserAction(USERACTIONTYPE.UA_RATEUS_DRAWER)
        UIApplication.sharedApplication().openURL(NSURL(string: APP_URL)!)
    }
    
    @IBAction func btnShareClicked(sender: AnyObject) {
        SharedManager.sharedInstance.uploadUserAction(USERACTIONTYPE.UA_SHARE_DRAWER)
    }
}

extension LeftViewController : UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if let menu = LeftMenu(rawValue: indexPath.item) {
            switch menu {
            case .Dashboard,.Transact,.Portfolio, .Pricing, .ContactUs, .About, .Feedback, .FAQs, .Blog, .Privacy:
                return BaseTableViewCell.height()
            }
        }
        return 0
    }
}

extension LeftViewController : UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let menu = LeftMenu(rawValue: indexPath.item) {
            switch menu {
            case .Dashboard,.Transact,.Portfolio, .Pricing, .ContactUs, .About, .Feedback, .FAQs, .Blog, .Privacy:
                let cell = BaseTableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: BaseTableViewCell.identifier)
                cell.setData(menus[indexPath.row])
                
                cell.imageView?.image = UIImage(named: menuImages[indexPath.row])!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
                cell.imageView!.tintColor = UIColor.blackColor()
                cell.imageView?.alpha = 0.6
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let menu = LeftMenu(rawValue: indexPath.item) {
            self.changeViewController(menu)
        }
    }
}

extension LeftViewController: UIScrollViewDelegate {
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if self.tableView == scrollView {
            
        }
    }
}
