//
//  UserLoginSignUp.swift
//  WealthTrust
//
//  Created by Hemen Gohil on 9/1/16.
//  Copyright © 2016 Hemen Gohil. All rights reserved.
//

import UIKit

class UserLoginSignUp: UIViewController {

    @IBOutlet weak var btnExistingUserLogin: UIButton!
    @IBOutlet weak var btnSignUp: UIButton!
    
    var isFrom = IS_FROM.Profile
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        SharedManager.addShadow(btnExistingUserLogin)
        SharedManager.addShadow(btnSignUp)

        print(isFrom)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func btnBackClicked(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }

    @IBAction func btnExistingUserLogin(sender: AnyObject) {
        let objLoginUser = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdLoginUser) as! LoginUser
        objLoginUser.isFrom = self.isFrom
        self.navigationController?.pushViewController(objLoginUser, animated: true)
    }
    
    @IBAction func btnNewUserSignUp(sender: AnyObject) {
        let objSignUp = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdNewUserSignUp) as! NewUserSignUp
        objSignUp.isFrom = self.isFrom
        self.navigationController?.pushViewController(objSignUp, animated: true)
        
    }
    
//    func callLogin() {
//        let objLoginUser = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdLoginUser)
//        self.navigationController?.pushViewController(objLoginUser!, animated: true)
//    }
    
}
