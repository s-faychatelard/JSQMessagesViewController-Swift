//
//  JSQMessagesKeyboardController.swift
//  JSQMessagesViewController
//
//  Created by Sylvain FAY-CHATELARD on 19/08/2015.
//  Copyright (c) 2015 Dviance. All rights reserved.
//

import Foundation

public let JSQMessagesKeyboardControllerNotificationKeyboardDidChangeFrame = "JSQMessagesKeyboardControllerNotificationKeyboardDidChangeFrame"
public let JSQMessagesKeyboardControllerUserInfoKeyKeyboardDidChangeFrame = "JSQMessagesKeyboardControllerUserInfoKeyKeyboardDidChangeFrame"

public protocol JSQMessagesKeyboardControllerDelegate {
    
    func keyboardController(keyboardController: JSQMessagesKeyboardController, keyboardDidChangeFrame keyboardFrame: CGRect)
}

public class JSQMessagesKeyboardController: NSObject, UIGestureRecognizerDelegate {
    
    public var delegate: JSQMessagesKeyboardControllerDelegate?
    private(set) public var textView: UITextView
    private(set) public var contextView: UIView
    private(set) public var panGestureRecognizer: UIPanGestureRecognizer
    
    public var keyboardTriggerPoint: CGPoint = CGPointZero
    public var keyboardIsVisible: Bool {
        
        get {
            
            return self.keyboardView != nil
        }
    }
    public var currentKeyboardFrame: CGRect {
        
        get {
            
            if !self.keyboardIsVisible {
                
                return CGRectNull
            }
            
            return self.keyboardView?.frame ?? CGRectNull
        }
    }
    
    private var jsq_isObserving: Bool = false
    private var keyboardView: UIView? {
        
        didSet {
            
            if self.keyboardView != nil {
                
                self.jsq_removeKeyboardFrameObserver()
            }
            
            if let keyboardView = self.keyboardView {
                
                if !self.jsq_isObserving {
                    
                    keyboardView.addObserver(self, forKeyPath: "frame", options: NSKeyValueObservingOptions.Old|NSKeyValueObservingOptions.New, context: self.kJSQMessagesKeyboardControllerKeyValueObservingContext)
                    
                    self.jsq_isObserving = true
                }
            }
        }
    }
    
    private let kJSQMessagesKeyboardControllerKeyValueObservingContext = UnsafeMutablePointer<Void>()
    typealias JSQAnimationCompletionBlock = ((Bool) -> Void)
    
    // MARK: - Initialization
    
    public init(textView: UITextView, contextView: UIView, panGestureRecognizer: UIPanGestureRecognizer, delegate: JSQMessagesKeyboardControllerDelegate?) {
        
        self.textView = textView
        self.contextView = contextView
        self.panGestureRecognizer = panGestureRecognizer
        self.delegate = delegate
    }
    
    // MARK: - Keyboard controller
    
    public func beginListeningForKeyboard() {
        
        if self.textView.inputAccessoryView == nil {
            
            self.textView.inputAccessoryView = UIView()
        }
        
        self.jsq_registerForNotifications()
    }
    
    public func endListeningForKeyboard() {
        
        self.jsq_unregisterForNotifications()
        
        self.jsq_setKeyboardView(hidden: false)
        self.keyboardView = nil
    }
    
    // MARK: - Notifications
    
    func jsq_registerForNotifications() {
        
        self.jsq_unregisterForNotifications()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("jsq_didReceiveKeyboardDidShowNotification:"), name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("jsq_didReceiveKeyboardWillChangeFrameNotification:"), name: UIKeyboardWillChangeFrameNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("jsq_didReceiveKeyboardDidChangeFrameNotification:"), name: UIKeyboardDidChangeFrameNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("jsq_didReceiveKeyboardDidHideNotification:"), name: UIKeyboardDidHideNotification, object: nil)
    }
    
    func jsq_unregisterForNotifications() {
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func jsq_didReceiveKeyboardDidShowNotification(notification: NSNotification) {
        
        self.keyboardView = self.textView.inputAccessoryView?.superview
        self.jsq_setKeyboardView(hidden: false)
        
        self.jsq_handleKeyboardNotification(notification) { (finished) -> Void in
            
            self.panGestureRecognizer.addTarget(self, action: Selector("jsq_handlePanGestureRecognizer:"))
        }
    }
    
    func jsq_didReceiveKeyboardWillChangeFrameNotification(notification: NSNotification) {

        self.jsq_handleKeyboardNotification(notification, completion: nil)
    }
    
    func jsq_didReceiveKeyboardDidChangeFrameNotification(notification: NSNotification) {
        
        self.jsq_setKeyboardView(hidden: false)
        self.jsq_handleKeyboardNotification(notification, completion: nil)
    }
    
    func jsq_didReceiveKeyboardDidHideNotification(notification: NSNotification) {
        
        self.keyboardView = nil
        
        self.jsq_handleKeyboardNotification(notification) { (finished) -> Void in
            
            self.panGestureRecognizer.removeTarget(self, action: nil)
        }
    }
    
    func jsq_handleKeyboardNotification(notification: NSNotification, completion: JSQAnimationCompletionBlock?) {
        
        if let userInfo = notification.userInfo,
            let keyboardEndFrame = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue() {
            
            if CGRectIsNull(keyboardEndFrame) {
                
                return
            }
            
            if let animationCurve = userInfo[UIKeyboardAnimationCurveUserInfoKey]?.integerValue,
                let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey]?.doubleValue {
            
                let animationCurveOption = UIViewAnimationOptions(UInt(animationCurve << 16))
                let keyboardEndFrameConverted = self.contextView.convertRect(keyboardEndFrame, fromView: nil)

                UIView.animateWithDuration(animationDuration, delay: 0, options: animationCurveOption, animations: { () -> Void in
                    
                    self.jsq_notifyKeyboardFrameNotification(frame: keyboardEndFrameConverted)

                }, completion: { (finished) -> Void in
                    
                    completion?(finished)
                })
            }
        }
    }
    
    // MARK: - Utilities
    
    func jsq_setKeyboardView(#hidden: Bool) {
        
        self.keyboardView?.hidden = hidden
        self.keyboardView?.userInteractionEnabled = !hidden
    }
    
    func jsq_notifyKeyboardFrameNotification(#frame: CGRect) {
        
        self.delegate?.keyboardController(self, keyboardDidChangeFrame: frame)
        
        NSNotificationCenter.defaultCenter().postNotificationName(JSQMessagesKeyboardControllerNotificationKeyboardDidChangeFrame, object: self, userInfo: [JSQMessagesKeyboardControllerUserInfoKeyKeyboardDidChangeFrame: NSValue(CGRect: frame)])
    }
    
    func jsq_resetKeyboardAndTextView() {
        
        self.jsq_setKeyboardView(hidden: true)
        self.jsq_removeKeyboardFrameObserver()
        self.textView.resignFirstResponder()
    }
    
    // MARK: - Key-value observing
    
    public override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        
        if context == self.kJSQMessagesKeyboardControllerKeyValueObservingContext {
            
            if let object = object as? UIView {
                
                if object == self.keyboardView && keyPath == "frame" {
                    
                    if let oldKeyboardFrame = change[NSKeyValueChangeOldKey]?.CGRectValue(),
                        let newKeyboardFrame = change[NSKeyValueChangeNewKey]?.CGRectValue() {
                    
                        if (CGRectIsNull(newKeyboardFrame) || CGRectEqualToRect(newKeyboardFrame, oldKeyboardFrame)) {
                            return;
                        }
                        
                        let keyboardEndFrameConverted = self.contextView.convertRect(newKeyboardFrame, fromView: self.keyboardView?.superview)
                            
                        self.jsq_notifyKeyboardFrameNotification(frame: keyboardEndFrameConverted)
                    }
                }
            }
        }
    }
    
    func jsq_removeKeyboardFrameObserver() {
        
        if !self.jsq_isObserving {
            
            return
        }
        
        self.keyboardView?.removeObserver(self, forKeyPath: "frame", context: self.kJSQMessagesKeyboardControllerKeyValueObservingContext)
        
        self.jsq_isObserving = false
    }
    
    // MARK: - Pan gesture recognizer
    
    func jsq_handlePanGestureRecognizer(pan: UIPanGestureRecognizer) {
        
        let touch = pan.locationInView(self.contextView.window)
        let contextViewWindowHeight = self.contextView.window?.frame.height ?? 0
        
        let keyboardViewHeight = self.keyboardView?.frame.height ?? 0
        let dragThresholdY = contextViewWindowHeight - keyboardViewHeight - self.keyboardTriggerPoint.y
        var newKeyboardViewFrame = self.keyboardView?.frame ?? CGRectZero
        
        let userIsDraggingNearThresholdForDismissing = touch.y > dragThresholdY
        self.keyboardView?.userInteractionEnabled = !userIsDraggingNearThresholdForDismissing
        
        switch pan.state {
            
            case .Changed:
                
                newKeyboardViewFrame.origin.y = touch.y + self.keyboardTriggerPoint.y
                
                //  bound frame between bottom of view and height of keyboard
                newKeyboardViewFrame.origin.y = min(newKeyboardViewFrame.origin.y, contextViewWindowHeight)
                newKeyboardViewFrame.origin.y = max(newKeyboardViewFrame.origin.y, contextViewWindowHeight - keyboardViewHeight)
                
                if CGRectGetMinY(newKeyboardViewFrame) == CGRectGetMinY(self.keyboardView?.frame ?? CGRectZero) {
                    
                    return
                }
                
                UIView.animateWithDuration(0, delay: 0, options: UIViewAnimationOptions.BeginFromCurrentState|UIViewAnimationOptions.TransitionNone, animations: { () -> Void in
                    
                    self.keyboardView?.frame = newKeyboardViewFrame
                }, completion: nil)
            
            case .Ended, .Cancelled, .Failed:
                
                let keyboardViewIsHidden: Bool = CGRectGetMinY(self.keyboardView?.frame ?? CGRectZero) >= contextViewWindowHeight
                if keyboardViewIsHidden {
                    
                    self.jsq_resetKeyboardAndTextView()
                }
                let velocity = pan.velocityInView(self.contextView)
                let userIsScrollingDown: Bool = velocity.y > 0
                let shouldHide: Bool = userIsScrollingDown && userIsDraggingNearThresholdForDismissing
                
                newKeyboardViewFrame.origin.y = shouldHide ? contextViewWindowHeight : (contextViewWindowHeight - keyboardViewHeight)
            
                let options = UIViewAnimationOptions.BeginFromCurrentState|UIViewAnimationOptions.CurveEaseOut
                UIView.animateWithDuration(0.25, delay: 0, options: options, animations: { () -> Void in
                    
                    self.keyboardView?.frame = newKeyboardViewFrame
                }, completion: { (finished) -> Void in
                    
                    self.keyboardView?.userInteractionEnabled = !shouldHide
                    
                    if shouldHide {

                        self.jsq_resetKeyboardAndTextView()
                    }
                })
            
            default:
                break
        }
    }
}