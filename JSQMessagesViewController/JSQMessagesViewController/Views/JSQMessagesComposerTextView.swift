//
//  JSQMessagesComposerTextView.swift
//  JSQMessagesViewController
//
//  Created by Sylvain FAY-CHATELARD on 20/08/2015.
//  Copyright (c) 2015 Dviance. All rights reserved.
//

import UIKit

class JSQMessagesComposerTextView: UITextView {
    
    var placeHolder: String? {
        
        didSet {
            
            self.setNeedsDisplay()
        }
    }
    var placeHolderTextColor: UIColor = UIColor.lightGrayColor() {
        
        didSet {
            
            self.setNeedsDisplay()
        }
    }
    
    // MARK: - Initialization
    
    func jsq_configureTextView() {
        
        self.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        let cornerRadius: CGFloat = 6
        
        self.backgroundColor = UIColor.whiteColor()
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.layer.cornerRadius = cornerRadius
        
        self.scrollIndicatorInsets = UIEdgeInsetsMake(cornerRadius, 0, cornerRadius, 0)
        
        self.textContainerInset = UIEdgeInsetsMake(4, 2, 4, 2)
        self.contentInset = UIEdgeInsetsMake(1, 0, 1, 0)
        
        self.scrollEnabled = true
        self.scrollsToTop = false
        self.userInteractionEnabled = true
        
        self.font = UIFont.systemFontOfSize(16)
        self.textColor = UIColor.blackColor()
        self.textAlignment = .Natural
        
        self.contentMode = .Redraw
        self.dataDetectorTypes = .None
        self.keyboardAppearance = .Default
        self.keyboardType = .Default
        self.returnKeyType = .Default
        
        self.text = nil
        
        self.jsq_addTextViewNotificationObservers()
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        
        super.init(frame: frame, textContainer: textContainer)
        
        self.jsq_configureTextView()
    }

    required init(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        self.jsq_configureTextView()
    }
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        self.jsq_configureTextView()
    }
    
    deinit {
        
        self.jsq_removeTextViewNotificationObservers()
        self.placeHolder = nil
    }
    
    // MARK: - Composer text view
    
    override func hasText() -> Bool {
    
        return self.text.jsq_stringByTrimingWhitespace().lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0
    }
    
    // MARK: - UITextView overrides
    
    override var text: String! {
        
        didSet {
            
            self.setNeedsDisplay()
        }
    }
    
    override var font: UIFont! {
        
        didSet {
            
            self.setNeedsDisplay()
        }
    }
    
    override var textColor: UIColor! {
        
        didSet {
            
            self.setNeedsDisplay()
        }
    }
    
    override var textAlignment: NSTextAlignment {
        
        didSet {
    
            self.setNeedsDisplay()
        }
    }
    
    // MARK: - Drawing
    
    override func drawRect(rect: CGRect) {
        
        super.drawRect(rect)
        
        if self.text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0 && self.placeHolder != nil {
            
            self.placeHolderTextColor.set()
            
            if let placholder = self.placeHolder {
            
                (placholder as NSString).drawInRect(CGRectInset(rect, 7, 5), withAttributes: self.jsq_placeholderTextAttributes())
            }
        }
    }
    
    // MARK: - Notifications
    
    func jsq_addTextViewNotificationObservers() {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("jsq_didReceiveTextViewNotification:"), name: UITextViewTextDidChangeNotification, object: self)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("jsq_didReceiveTextViewNotification:"), name: UITextViewTextDidBeginEditingNotification, object: self)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("jsq_didReceiveTextViewNotification:"), name: UITextViewTextDidEndEditingNotification, object: self)
    }
    
    func jsq_removeTextViewNotificationObservers() {
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UITextViewTextDidChangeNotification, object: self)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UITextViewTextDidBeginEditingNotification, object: self)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UITextViewTextDidEndEditingNotification, object: self)
    }
    
    func jsq_didReceiveTextViewNotification(notification: NSNotification) {
        
        self.setNeedsDisplay()
    }
    
    // MARK: - Utilities
    
    func jsq_placeholderTextAttributes() -> [NSObject : AnyObject] {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .ByTruncatingTail
        paragraphStyle.alignment = self.textAlignment
        
        return [
            NSFontAttributeName : self.font,
            NSForegroundColorAttributeName : self.placeHolderTextColor,
            NSParagraphStyleAttributeName : paragraphStyle
        ]
    }
}