//
//  NSDate+Extension.swift
//  WealthTrust
//
//  Created by Hemen Gohil on 11/18/16.
//  Copyright © 2016 Hemen Gohil. All rights reserved.
//

import Foundation
import UIKit

extension NSDate {
    func isGreaterThanDate(dateToCompare: NSDate) -> Bool {
        //Declare Variables
        var isGreater = false
        
        //Compare Values
        if self.compare(dateToCompare) == NSComparisonResult.OrderedDescending {
            isGreater = true
        }
        
        //Return Result
        return isGreater
    }
    
    func isLessThanDate(dateToCompare: NSDate) -> Bool {
        //Declare Variables
        var isLess = false
        
        //Compare Values
        if self.compare(dateToCompare) == NSComparisonResult.OrderedAscending {
            isLess = true
        }
        
        //Return Result
        return isLess
    }
    
    func equalToDate(dateToCompare: NSDate) -> Bool {
        //Declare Variables
        var isEqualTo = false
        
        //Compare Values
        if self.compare(dateToCompare) == NSComparisonResult.OrderedSame {
            isEqualTo = true
        }
        
        //Return Result
        return isEqualTo
    }
    
    func addDays(daysToAdd: Int) -> NSDate {
        let secondsInDays: NSTimeInterval = Double(daysToAdd) * 60 * 60 * 24
        let dateWithDaysAdded: NSDate = self.dateByAddingTimeInterval(secondsInDays)
        
        //Return Result
        return dateWithDaysAdded
    }
    
    func addHours(hoursToAdd: Int) -> NSDate {
        let secondsInHours: NSTimeInterval = Double(hoursToAdd) * 60 * 60
        let dateWithHoursAdded: NSDate = self.dateByAddingTimeInterval(secondsInHours)
        
        //Return Result
        return dateWithHoursAdded
    }
    func setMonth(monthToSet: Int) -> NSDate {

        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day , .Month , .Year], fromDate: self)

        components.month = monthToSet
        
        //Return Result
        return calendar.dateFromComponents(components)!
    }
    func setMonthWitDay1(monthToSet: Int, date : NSDate) -> NSDate {
        
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day , .Month , .Year], fromDate: date)
        
        components.month = monthToSet
        components.day = 1
            var dt = calendar.dateFromComponents(components)
        dt = dt?.addDays(1)
        print(dt)

//        let componentsNew = calendar.components([.Year, .Month], fromDate: date)
//        let startOfMonth = calendar.dateFromComponents(componentsNew)!
//        print(startOfMonth) // 2015-11-01

        
        
        return dt!
    }

    func setDay(dayToSet: Int) -> NSDate {
        
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day , .Month , .Year], fromDate: self)
        
        components.day = dayToSet
        
        //Return Result
        return calendar.dateFromComponents(components)!
    }

    func getMonth() -> Int {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day , .Month , .Year], fromDate: self)
        return components.month
    }
    func getYear() -> Int {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day , .Month , .Year], fromDate: self)
        return components.year
    }
    func getDay() -> Int {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day , .Month , .Year], fromDate: self)
        return components.day
    }

    func getDateInString() -> String {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        let string = dateFormatter.stringFromDate(self)

        return string
    }
    

}
