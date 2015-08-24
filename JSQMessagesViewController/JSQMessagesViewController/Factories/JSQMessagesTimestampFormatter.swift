//
//  JSQMessagesTimestampFormatter.swift
//  JSQMessagesViewController
//
//  Created by Sylvain FAY-CHATELARD on 20/08/2015.
//  Copyright (c) 2015 Dviance. All rights reserved.
//

import Foundation

class JSQMessagesTimestampFormatter: NSObject {

    private(set) var dateFormatter: NSDateFormatter = NSDateFormatter()
    
    private(set) var dateTextAttributes: [NSObject: AnyObject]
    private(set) var timeTextAttributes: [NSObject: AnyObject]
    
    static let sharedFormatter: JSQMessagesTimestampFormatter = JSQMessagesTimestampFormatter()
    
    override init() {
        
        self.dateFormatter.locale = NSLocale.currentLocale()
        self.dateFormatter.doesRelativeDateFormatting = true
        
        let color = UIColor.lightGrayColor()
        
        var paragraphStyle: NSMutableParagraphStyle = NSParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.alignment = .Center
        
        self.dateTextAttributes = [
            NSFontAttributeName: UIFont.boldSystemFontOfSize(12),
            NSForegroundColorAttributeName: color,
            NSParagraphStyleAttributeName: paragraphStyle
        ]
        
        self.timeTextAttributes = [
            NSFontAttributeName: UIFont.boldSystemFontOfSize(12),
            NSForegroundColorAttributeName: color,
            NSParagraphStyleAttributeName: paragraphStyle
        ]
    }
    
    // MARK: - Formatter
    
    func timestamp(date: NSDate) -> String {
        
        self.dateFormatter.dateStyle = .MediumStyle
        self.dateFormatter.timeStyle = .ShortStyle

        return self.dateFormatter.stringFromDate(date)
    }
    
    func attributedTimestamp(date: NSDate) -> NSAttributedString {
    
        let relativeDate = self.relativeDate(date)
        let time = self.time(date)
        
        let timestamp = NSMutableAttributedString(string: relativeDate, attributes: self.dateTextAttributes)
        timestamp.appendAttributedString(NSAttributedString(string: " "))
        timestamp.appendAttributedString(NSAttributedString(string: time, attributes: self.timeTextAttributes))
        
        return NSAttributedString(attributedString: timestamp)
    }
    
    func time(date: NSDate) -> String {
        
        self.dateFormatter.dateStyle = .NoStyle
        self.dateFormatter.timeStyle = .ShortStyle
        
        return self.dateFormatter.stringFromDate(date)
    }
    
    func relativeDate(date: NSDate) -> String {
        
        self.dateFormatter.dateStyle = .MediumStyle
        self.dateFormatter.timeStyle = .NoStyle
        
        return self.dateFormatter.stringFromDate(date)
    }
}