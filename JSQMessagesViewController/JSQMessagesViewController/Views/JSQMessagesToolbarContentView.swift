//
//  JSQMessagesToolbarContentView.swift
//  JSQMessagesViewController
//
//  Created by Sylvain FAY-CHATELARD on 20/08/2015.
//  Copyright (c) 2015 Dviance. All rights reserved.
//

import UIKit

let kJSQMessagesToolbarContentViewHorizontalSpacingDefault: CGFloat = 8;

public class JSQMessagesToolbarContentView: UIView {
    
    @IBOutlet private(set) public var textView: JSQMessagesComposerTextView!
    
    @IBOutlet var leftBarButtonContainerView: UIView!
    @IBOutlet var leftBarButtonContainerViewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet var rightBarButtonContainerView: UIView!
    @IBOutlet var rightBarButtonContainerViewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet var leftHorizontalSpacingConstraint: NSLayoutConstraint!
    @IBOutlet var rightHorizontalSpacingConstraint: NSLayoutConstraint!
    
    public override var backgroundColor: UIColor? {
        
        didSet {
            
            self.leftBarButtonContainerView?.backgroundColor = backgroundColor
            self.rightBarButtonContainerView?.backgroundColor = backgroundColor
        }
    }
    
    public dynamic var leftBarButtonItem: UIButton? {
        
        willSet {
            
            self.leftBarButtonItem?.removeFromSuperview()

            if let newValue = newValue {
                
                if CGRectEqualToRect(newValue.frame, CGRectZero) {
                    
                    newValue.frame = self.leftBarButtonContainerView.bounds
                }
                
                self.leftBarButtonContainerView.hidden = false
                self.leftHorizontalSpacingConstraint.constant = kJSQMessagesToolbarContentViewHorizontalSpacingDefault
                self.leftBarButtonItemWidth = newValue.frame.width
                
                newValue.setTranslatesAutoresizingMaskIntoConstraints(false)
                
                self.leftBarButtonContainerView.addSubview(newValue)
                self.leftBarButtonContainerView.jsq_pinAllEdgesOfSubview(newValue)
                self.setNeedsUpdateConstraints()
                return
            }
            
            self.leftHorizontalSpacingConstraint.constant = 0
            self.leftBarButtonItemWidth = 0
            self.leftBarButtonContainerView.hidden = true
        }
    }
    var leftBarButtonItemWidth: CGFloat {
        
        get {
            
            return self.leftBarButtonContainerViewWidthConstraint.constant
        }
        
        set {
            
            self.leftBarButtonContainerViewWidthConstraint.constant = newValue
            self.setNeedsUpdateConstraints()
        }
    }
    
    public dynamic var rightBarButtonItem: UIButton? {
        
        willSet {
            
            self.rightBarButtonItem?.removeFromSuperview()
            
            if let newValue = newValue {
                
                if CGRectEqualToRect(newValue.frame, CGRectZero) {
                    
                    newValue.frame = self.rightBarButtonContainerView.bounds
                }
                
                self.rightBarButtonContainerView.hidden = false
                self.rightHorizontalSpacingConstraint.constant = kJSQMessagesToolbarContentViewHorizontalSpacingDefault
                self.rightBarButtonItemWidth = newValue.frame.width
                
                newValue.setTranslatesAutoresizingMaskIntoConstraints(false)
                
                self.rightBarButtonContainerView.addSubview(newValue)
                self.rightBarButtonContainerView.jsq_pinAllEdgesOfSubview(newValue)
                self.setNeedsUpdateConstraints()
                return
            }
            
            self.rightHorizontalSpacingConstraint.constant = 0
            self.rightBarButtonItemWidth = 0
            self.rightBarButtonContainerView.hidden = true
        }
    }
    var rightBarButtonItemWidth: CGFloat {
        
        get {
            
            return self.rightBarButtonContainerViewWidthConstraint.constant
        }
        
        set {
            
            self.rightBarButtonContainerViewWidthConstraint.constant = newValue
            self.setNeedsUpdateConstraints()
        }
    }
    
    public class func nib() -> UINib {
        
        return UINib(nibName: "\(JSQMessagesToolbarContentView.self)".jsq_className(), bundle: NSBundle(forClass: JSQMessagesToolbarContentView.self))
    }
    
    // MARK: - Initialization
    
    public override func awakeFromNib() {
        
        super.awakeFromNib()
        
        self.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        self.leftHorizontalSpacingConstraint.constant = kJSQMessagesToolbarContentViewHorizontalSpacingDefault
        self.rightHorizontalSpacingConstraint.constant = kJSQMessagesToolbarContentViewHorizontalSpacingDefault
        
        self.backgroundColor = UIColor.clearColor()
    }
    
    // MARK: - UIView overrides
    
    public override func setNeedsDisplay() {
    
        super.setNeedsDisplay()

        self.textView?.setNeedsDisplay()
    }
}
