//
//  Extension.swift
//  WhatToCook
//
//  Created by Vitaliy Kuzmenko on 11/10/14.
//  Copyright (c) 2014 KuzmenkoFamily. All rights reserved.
//

import UIKit

extension UIButton {
    
    func setBackgroundColor(color: UIColor, forState state: UIControlState) {
        let image = UIImage(color: UIColor.lightGrayColor())
        setBackgroundImage(image, forState: state)
    }
    
    func playImplicitBounceAnimation() {
        
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bounceAnimation.values = [1.0 ,1.4, 0.9, 1.15, 0.95, 1.02, 1.0]
        bounceAnimation.duration = NSTimeInterval(0.5)
        bounceAnimation.calculationMode = kCAAnimationCubic
        
        layer.addAnimation(bounceAnimation, forKey: "bounceAnimation")
    }
    
    func playExplicitBounceAnimation() {
        
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        
        var values = [Double]()
        let e = 2.71
        
        for t in 1..<100 {
            let value = 0.6 * pow(e, -0.045 * Double(t)) * cos(0.1 * Double(t)) + 1.0
            
            values.append(value)
        }
        
        
        bounceAnimation.values = values
        bounceAnimation.duration = NSTimeInterval(0.5)
        bounceAnimation.calculationMode = kCAAnimationCubic
        
        layer.addAnimation(bounceAnimation, forKey: "bounceAnimation")
    }

    func addLayer() {
        let layer = CAGradientLayer()
        layer.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
//        layer.colors = [UIColor.redColor().CGColor, UIColor.blackColor().CGColor]
        layer.colors = [UIColor(red: 41,green: 63,blue: 83).CGColor, UIColor(red: 74,green: 120,blue: 159).CGColor]
        self.layer.addSublayer(layer)
    }
    
    func addAtmosLayer(color1: UIColor, color2: UIColor) {
        let layer = CAGradientLayer()
        layer.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        layer.colors = [color1.CGColor, color2.CGColor]
        self.layer.addSublayer(layer)
    }

}

