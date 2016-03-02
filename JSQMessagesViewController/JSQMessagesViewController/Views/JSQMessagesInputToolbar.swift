//
//  JSQMessagesInputToolbar.swift
//  JSQMessagesViewController
//
//  Created by Sylvain FAY-CHATELARD on 20/08/2015.
//  Copyright (c) 2015 Dviance. All rights reserved.
//

import UIKit

let kJSQMessagesInputToolbarKeyValueObservingContext = UnsafeMutablePointer<Void>()

public protocol JSQMessagesInputToolbarDelegate: UIToolbarDelegate {
    
    func messagesInputToolbar(toolbar: JSQMessagesInputToolbar, didPressRightBarButton sender: UIButton)
    func messagesInputToolbar(toolbar: JSQMessagesInputToolbar, didPressLeftBarButton sender: UIButton)
}

public class JSQMessagesInputToolbar: UIToolbar {
    
    var toolbarDelegate: JSQMessagesInputToolbarDelegate? {
        get { return self.delegate as? JSQMessagesInputToolbarDelegate }
        set { self.delegate = newValue }
    }
    
    private(set) public var contentView: JSQMessagesToolbarContentView!
    
    public var sendButtonOnRight: Bool = true
    public var preferredDefaultHeight: CGFloat = 44
    public var maximumHeight: Int = NSNotFound
    
    private var jsq_isObserving: Bool = false
    
    public override func awakeFromNib() {
        
        super.awakeFromNib()
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let toolbarContentView = self.loadToolbarContentView()
        toolbarContentView.frame = self.frame
        self.addSubview(toolbarContentView)
        self.jsq_pinAllEdgesOfSubview(toolbarContentView)
        self.setNeedsUpdateConstraints()
        self.contentView = toolbarContentView
        
        self.jsq_addObservers()
        
        self.contentView.leftBarButtonItem = JSQMessagesToolbarButtonFactory.defaultAccessoryButtonItem()
        self.contentView.rightBarButtonItem = JSQMessagesToolbarButtonFactory.defaultSendButtonItem()
        
        self.toggleSendButtonEnabled()
    }

    func loadToolbarContentView() -> JSQMessagesToolbarContentView {
        
        return NSBundle(forClass: JSQMessagesToolbarContentView.self).loadNibNamed("\(JSQMessagesToolbarContentView.self)".jsq_className(), owner: nil, options: nil).first as! JSQMessagesToolbarContentView
    }
    
    deinit {
        
        self.jsq_removeObservers()
        self.contentView = nil
    }
    
    // MARK: - Input toolbar
    
    func toggleSendButtonEnabled() {
        
        let hasText = self.contentView.textView.hasText()
        
        if self.sendButtonOnRight {
            
            self.contentView.rightBarButtonItem?.enabled = hasText
        }
        else {
            
            self.contentView.leftBarButtonItem?.enabled = hasText
        }
    }
    
    // MARK: - Actions
    
    func jsq_leftBarButtonPressed(sender: UIButton) {
        
        self.toolbarDelegate?.messagesInputToolbar(self, didPressLeftBarButton: sender)
    }
    
    func jsq_rightBarButtonPressed(sender: UIButton) {
        
        self.toolbarDelegate?.messagesInputToolbar(self, didPressRightBarButton: sender)
    }
    
    // MARK: - Key-value observing
    
    public override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        if context == kJSQMessagesInputToolbarKeyValueObservingContext {
            
            if let object = object as? JSQMessagesToolbarContentView {
                
                if object == self.contentView {
                    
                    if keyPath == "leftBarButtonItem" {
                        
                        self.contentView.leftBarButtonItem?.removeTarget(self, action: nil, forControlEvents: .TouchUpInside)
                        self.contentView.leftBarButtonItem?.addTarget(self, action: Selector("jsq_leftBarButtonPressed:"), forControlEvents: .TouchUpInside)
                    }
                    else if keyPath == "rightBarButtonItem" {
                        
                        self.contentView.rightBarButtonItem?.removeTarget(self, action: nil, forControlEvents: .TouchUpInside)
                        self.contentView.rightBarButtonItem?.addTarget(self, action: Selector("jsq_rightBarButtonPressed:"), forControlEvents: .TouchUpInside)
                    }
                    
                    self.toggleSendButtonEnabled()
                }
            }
        }
    }
    
    func jsq_addObservers() {
        
        if self.jsq_isObserving {
            
            return
        }
        
        self.contentView.addObserver(self, forKeyPath: "leftBarButtonItem", options: NSKeyValueObservingOptions(), context: kJSQMessagesInputToolbarKeyValueObservingContext)
        self.contentView.addObserver(self, forKeyPath: "rightBarButtonItem", options: NSKeyValueObservingOptions(), context: kJSQMessagesInputToolbarKeyValueObservingContext)
        
        self.jsq_isObserving = true
    }
    
    func jsq_removeObservers() {
        
        if !self.jsq_isObserving {
            return
        }
        
        self.contentView.removeObserver(self, forKeyPath: "leftBarButtonItem", context: kJSQMessagesInputToolbarKeyValueObservingContext)
        self.contentView.removeObserver(self, forKeyPath: "rightBarButtonItem", context: kJSQMessagesInputToolbarKeyValueObservingContext)
        
        self.jsq_isObserving = false
    }
}