//
//  UIImageViewExtension.swift
//  WealthTrust
//
//  Created by Hemen Gohil on 8/24/16.
//  Copyright © 2016 Hemen Gohil. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    
    func addAtmosLayer(color1: UIColor, color2: UIColor) {
        let layer = CAGradientLayer()
        layer.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        layer.colors = [color1.CGColor, color2.CGColor]
        self.layer.addSublayer(layer)
    }

    static func loadImageFromUrl(url: String, view: UIImageView){
        

        // Create Url from string
        let url = NSURL(string: url)!
        
        // Download task:
        // - sharedSession = global NSURLCache, NSHTTPCookieStorage and NSURLCredentialStorage objects.
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (responseData, responseUrl, error) -> Void in
            // if responseData is not null...
            if let data = responseData{
                
                // execute in UI thread
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    view.image = UIImage(data: data)
                })
            }
        }
        
        // Run task
        task.resume()
    }
}


//class ImageLoader {
//    
//    var cache = NSCache()
//    
//    class var sharedLoader : ImageLoader {
//        struct Static {
//            static let instance : ImageLoader = ImageLoader()
//        }
//        return Static.instance
//    }
//    
//    func imageForUrl(urlString: String, completionHandler:(image: UIImage?, url: String) -> ()) {
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {()in
//            var data: NSData? = self.cache.objectForKey(urlString) as? NSData
//            
//            if let goodData = data {
//                let image = UIImage(data: goodData)
//                dispatch_async(dispatch_get_main_queue(), {() in
//                    completionHandler(image: image, url: urlString)
//                })
//                return
//            }
//            
//            var downloadTask: NSURLSessionDataTask = NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: urlString)!, completionHandler: {(data: NSData!, response: NSURLResponse!, error: NSError!) -> Void in
//                if (error != nil) {
//                    completionHandler(image: nil, url: urlString)
//                    return
//                }
//                
//                if data != nil {
//                    let image = UIImage(data: data)
//                    self.cache.setObject(data, forKey: urlString)
//                    dispatch_async(dispatch_get_main_queue(), {() in
//                        completionHandler(image: image, url: urlString)
//                    })
//                    return
//                }
//                
//            })
//            downloadTask.resume()
//        })
//        
//    }
//}
