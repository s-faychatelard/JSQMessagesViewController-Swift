//
//  JSQMessagesCellTextView.swift
//  JSQMessagesViewController
//
//  Created by Sylvain FAY-CHATELARD on 20/08/2015.
//  Copyright (c) 2015 Dviance. All rights reserved.
//

import UIKit

class JSQMessagesCellTextView: UITextView {
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        self.textColor = UIColor.whiteColor()
        self.editable = false
        self.selectable = true
        self.userInteractionEnabled = true
        self.dataDetectorTypes = .None
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.scrollEnabled = false
        self.backgroundColor = UIColor.clearColor()
        self.contentInset = UIEdgeInsetsZero
        self.scrollIndicatorInsets = UIEdgeInsetsZero
        self.contentOffset = CGPointZero
        self.textContainerInset = UIEdgeInsetsZero
        self.textContainer.lineFragmentPadding = 0
        self.linkTextAttributes = [
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue
        ]
    }
    
    //  prevent selecting text
    override var selectedRange: NSRange {
        
        didSet {
            
            if NSEqualRanges(self.selectedRange, oldValue) {

                return
            }
            
            self.selectedRange = NSMakeRange(NSNotFound, 0)
        }
    }
    
    override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        //  ignore double-tap to prevent copy/define/etc. menu from showing
        if let tap = gestureRecognizer as? UITapGestureRecognizer {
            
            if tap.numberOfTapsRequired == 2 {
                
                return false
            }
        }
        
        return true
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        
        //  ignore double-tap to prevent copy/define/etc. menu from showing
        if let tap = gestureRecognizer as? UITapGestureRecognizer {
            
            if tap.numberOfTapsRequired == 2 {
                
                return false
            }
        }
        
        return true
    }
}