//
//  UploadPortfolioInstruScreen.swift
//  WealthTrust
//
//  Created by Hemen Gohil on 11/21/16.
//  Copyright © 2016 Hemen Gohil. All rights reserved.
//

import UIKit

class UploadPortfolioInstruScreen: UIViewController {

    
    
    
    @IBOutlet weak var btnNext: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        SharedManager.addShadow(self.btnNext)

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func bnBackclicked(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }

    @IBAction func btnNextClicked(sender: AnyObject) {
        
        let objscreen = self.storyboard?.instantiateViewControllerWithIdentifier(ksbIdUploadPortScreen) as! UploadPortScreen
        self.navigationController?.pushViewController(objscreen, animated: true)
        
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
