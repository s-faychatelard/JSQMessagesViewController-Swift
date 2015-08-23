//
//  JSQMessagesCollectionViewCell.swift
//  JSQMessagesViewController
//
//  Created by Sylvain FAY-CHATELARD on 20/08/2015.
//  Copyright (c) 2015 Dviance. All rights reserved.
//

import UIKit

public protocol JSQMessagesCollectionViewCellDelegate {
    
    func messagesCollectionViewCellDidTapAvatar(cell: JSQMessagesCollectionViewCell)
    func messagesCollectionViewCellDidTapMessageBubble(cell: JSQMessagesCollectionViewCell)
    
    func messagesCollectionViewCellDidTapCell(cell: JSQMessagesCollectionViewCell, atPosition position: CGPoint)
    func messagesCollectionViewCell(cell: JSQMessagesCollectionViewCell, didPerformAction action: Selector, withSender sender: AnyObject)
}

public class JSQMessagesCollectionViewCell: UICollectionViewCell {
    
    private static var jsqMessagesCollectionViewCellActions: Set<Selector> = Set()
    
    public var delegate: JSQMessagesCollectionViewCellDelegate?
    
    @IBOutlet private(set) public var cellTopLabel: JSQMessagesLabel!
    @IBOutlet private(set) public var messageBubbleTopLabel: JSQMessagesLabel!
    @IBOutlet private(set) public var cellBottomLabel: JSQMessagesLabel!
    
    @IBOutlet private(set) public var messageBubbleContainerView: UIView!
    @IBOutlet private(set) public var messageBubbleImageView: UIImageView?
    @IBOutlet private(set) public var textView: JSQMessagesCellTextView?
    
    @IBOutlet private(set) public var avatarImageView: UIImageView!
    @IBOutlet private(set) public var avatarContainerView: UIView!
    
    @IBOutlet private var messageBubbleContainerWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet private var textViewTopVerticalSpaceConstraint: NSLayoutConstraint!
    @IBOutlet private var textViewBottomVerticalSpaceConstraint: NSLayoutConstraint!
    @IBOutlet private var textViewAvatarHorizontalSpaceConstraint: NSLayoutConstraint!
    @IBOutlet private var textViewMarginHorizontalSpaceConstraint: NSLayoutConstraint!
    
    @IBOutlet private var cellTopLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet private var messageBubbleTopLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet private var cellBottomLabelHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet private var avatarContainerViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet private var avatarContainerViewHeightConstraint: NSLayoutConstraint!
    
    private(set) var tapGestureRecognizer: UITapGestureRecognizer?
    
    private var textViewFrameInsets: UIEdgeInsets {
        
        set {

            if UIEdgeInsetsEqualToEdgeInsets(newValue, self.textViewFrameInsets) {
                
                return
            }
            
            self.jsq_update(constraint: self.textViewTopVerticalSpaceConstraint, withConstant: newValue.top)
            self.jsq_update(constraint: self.textViewBottomVerticalSpaceConstraint, withConstant: newValue.bottom)
            self.jsq_update(constraint: self.textViewAvatarHorizontalSpaceConstraint, withConstant: newValue.right)
            self.jsq_update(constraint: self.textViewMarginHorizontalSpaceConstraint, withConstant: newValue.left)
        }

        get {
            
            return UIEdgeInsetsMake(self.textViewTopVerticalSpaceConstraint.constant,
                                    self.textViewMarginHorizontalSpaceConstraint.constant,
                                    self.textViewBottomVerticalSpaceConstraint.constant,
                                    self.textViewAvatarHorizontalSpaceConstraint.constant)
        }
    }
    
    private var avatarViewSize: CGSize {
        
        set {
            
            if CGSizeEqualToSize(newValue, self.avatarViewSize) {
                
                return
            }
            
            self.jsq_update(constraint: self.avatarContainerViewWidthConstraint, withConstant: newValue.width)
            self.jsq_update(constraint: self.avatarContainerViewHeightConstraint, withConstant: newValue.height)
        }
        
        get {
            
            return CGSizeMake(self.avatarContainerViewWidthConstraint.constant,
                              self.avatarContainerViewHeightConstraint.constant)
        }
    }
    
    public var mediaView: UIView? {
        
        didSet {
            
            if let mediaView = self.mediaView {
                
                self.messageBubbleImageView?.removeFromSuperview()
                self.textView?.removeFromSuperview()
                
                mediaView.setTranslatesAutoresizingMaskIntoConstraints(false)
                mediaView.frame = self.messageBubbleContainerView.bounds
                
                self.messageBubbleContainerView.addSubview(mediaView)
                self.messageBubbleContainerView.jsq_pinAllEdgesOfSubview(mediaView)
                
                dispatch_async(dispatch_get_main_queue()) {
                    
                    for var i=0; i<self.messageBubbleContainerView.subviews.count; i++ {
                        
                        if self.messageBubbleContainerView.subviews[i] as? UIView != mediaView {
                            
                            self.messageBubbleContainerView.subviews[i].removeFromSuperview()
                        }
                    }
                }
            }
        }
    }
    
    public override var backgroundColor: UIColor? {
        
        didSet {
            
            self.cellTopLabel.backgroundColor = backgroundColor
            self.messageBubbleTopLabel.backgroundColor = backgroundColor
            self.cellBottomLabel.backgroundColor = backgroundColor
            
            self.messageBubbleImageView?.backgroundColor = backgroundColor
            self.avatarImageView.backgroundColor = backgroundColor
            
            self.messageBubbleContainerView.backgroundColor = backgroundColor
            self.avatarContainerView.backgroundColor = backgroundColor
        }
    }
    
    // MARK: - Class methods
    
    public class func nib() -> UINib {
        
        return UINib(nibName: "\(JSQMessagesCollectionViewCell.self)".jsq_className(), bundle: NSBundle(forClass: JSQMessagesCollectionViewCell.self))
    }
    
    public class func cellReuseIdentifier() -> String {
        
        return "\(JSQMessagesCollectionViewCell.self)".jsq_className()
    }
    
    public class func mediaCellReuseIdentifier() -> String {
        
        return "\(JSQMessagesCollectionViewCell.self)".jsq_className() + "_JSQMedia"
    }
    
    public class func registerMenuAction(action: Selector) {
        
        JSQMessagesCollectionViewCell.jsqMessagesCollectionViewCellActions.insert(action)
    }
    
    // MARK: - Initialization
    
    public override func awakeFromNib() {
        
        super.awakeFromNib()
        
        self.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        self.backgroundColor = UIColor.whiteColor()
        
        self.cellTopLabelHeightConstraint.constant = 0
        self.messageBubbleTopLabelHeightConstraint.constant = 0
        self.cellBottomLabelHeightConstraint.constant = 0
        
        self.cellTopLabel.textAlignment = .Center
        self.cellTopLabel.font = UIFont.boldSystemFontOfSize(12)
        self.cellTopLabel.textColor = UIColor.lightGrayColor()
        
        self.messageBubbleTopLabel.font = UIFont.systemFontOfSize(12)
        self.messageBubbleTopLabel.textColor = UIColor.lightGrayColor()
        
        self.cellBottomLabel.font = UIFont.systemFontOfSize(11);
        self.cellBottomLabel.textColor = UIColor.lightGrayColor()
        
        let tap = UITapGestureRecognizer(target: self, action: Selector("jsq_handleTapGesture:"))
        self.addGestureRecognizer(tap)
        self.tapGestureRecognizer = tap
    }
    
    deinit {
        
        self.tapGestureRecognizer?.removeTarget(nil, action: nil)
        self.tapGestureRecognizer = nil
    }
    
    // MARK: - Collection view cell
    
    public override func prepareForReuse() {
        
        super.prepareForReuse()
        
        self.cellTopLabel.text = nil
        self.messageBubbleTopLabel.text = nil
        self.cellBottomLabel.text = nil
        
        self.textView?.dataDetectorTypes = .None
        self.textView?.text = nil
        self.textView?.attributedText = nil
        
        self.avatarImageView.image = nil
        self.avatarImageView.highlightedImage = nil
    }
    
    public override func preferredLayoutAttributesFittingAttributes(layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes! {
        
        return layoutAttributes
    }
    
    public override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes!) {
        
        super.applyLayoutAttributes(layoutAttributes)
        
        if let customAttributes = layoutAttributes as? JSQMessagesCollectionViewLayoutAttributes {
            
            if let textView = self.textView {
                
                if textView.font != customAttributes.messageBubbleFont {
                    
                    textView.font = customAttributes.messageBubbleFont
                }
                
                if !UIEdgeInsetsEqualToEdgeInsets(textView.textContainerInset, customAttributes.textViewTextContainerInsets) {
                    
                    textView.textContainerInset = customAttributes.textViewTextContainerInsets
                }
            }
            
            self.textViewFrameInsets = customAttributes.textViewFrameInsets
            
            self.jsq_update(constraint: self.messageBubbleContainerWidthConstraint, withConstant: customAttributes.messageBubbleContainerViewWidth)
            self.jsq_update(constraint: self.cellTopLabelHeightConstraint, withConstant: customAttributes.cellTopLabelHeight)
            self.jsq_update(constraint: self.messageBubbleTopLabelHeightConstraint, withConstant: customAttributes.messageBubbleTopLabelHeight)
            self.jsq_update(constraint: self.cellBottomLabelHeightConstraint, withConstant: customAttributes.cellBottomLabelHeight)
            
            if self is JSQMessagesCollectionViewCellIncoming {
                
                self.avatarViewSize = customAttributes.incomingAvatarViewSize
            }
            else if self is JSQMessagesCollectionViewCellOutgoing {
                
                self.avatarViewSize = customAttributes.outgoingAvatarViewSize
            }
        }
    }
    
    public override var highlighted: Bool {
        
        didSet {
            
            self.messageBubbleImageView?.highlighted = self.highlighted
        }
    }
    
    public override var selected: Bool {
        
        didSet {
            
            self.messageBubbleImageView?.highlighted = self.selected
        }
    }
    
    public override var bounds: CGRect {
        
        didSet {
            
            if UIDevice.jsq_isCurrentDeviceBeforeiOS8() {
 
                self.contentView.frame = bounds
            }
        }
    }
    
    // MARK: - Menu actions
    
    public override func respondsToSelector(aSelector: Selector) -> Bool {
        
        if JSQMessagesCollectionViewCell.jsqMessagesCollectionViewCellActions.contains(aSelector) {
            
            return true
        }
        
        return super.respondsToSelector(aSelector)
    }
    
    //TODO: Swift compatibility
    /*override func forwardInvocation(anInvocation: NSInvocation!) {
        
        if JSQMessagesCollectionViewCell.jsqMessagesCollectionViewCellActions.contains(aSelector) {
            
            return
        }
    }
    
    override func methodSignatureForSelector(aSelector: Selector) -> NSMethodSignature! {
        
        if JSQMessagesCollectionViewCell.jsqMessagesCollectionViewCellActions.contains(aSelector) {
            
            return NSMethodSign
        }
    }*/
    
    // MARK: - Utilities
    
    func jsq_update(#constraint: NSLayoutConstraint, withConstant constant: CGFloat) {
        
        if constraint.constant == constant {
            return
        }
        
        constraint.constant = constant
    }
    
    // MARK: - Gesture recognizers
    
    func jsq_handleTapGesture(tap: UITapGestureRecognizer) {
        
        let touchPoint = tap.locationInView(self)
        
        if CGRectContainsPoint(self.avatarContainerView.frame, touchPoint) {
            
            self.delegate?.messagesCollectionViewCellDidTapAvatar(self)
        }
        else if CGRectContainsPoint(self.messageBubbleContainerView.frame, touchPoint) {
            
            self.delegate?.messagesCollectionViewCellDidTapMessageBubble(self)
        }
        else {
            
            self.delegate?.messagesCollectionViewCellDidTapCell(self, atPosition: touchPoint)
        }
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        
        let touchPoint = touch.locationInView(self)
        
        if let gestureRecognizer = gestureRecognizer as? UILongPressGestureRecognizer {
            
            return CGRectContainsPoint(self.messageBubbleContainerView.frame, touchPoint)
        }
        
        return true
    }
}