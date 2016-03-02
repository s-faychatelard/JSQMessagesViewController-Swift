//
//  JSQMessagesViewController.swift
//  JSQMessagesViewController
//
//  Created by Sylvain FAY-CHATELARD on 19/08/2015.
//  Copyright (c) 2015 Dviance. All rights reserved.
//

import UIKit

public class JSQMessagesViewController: UIViewController, JSQMessagesCollectionViewDataSource, JSQMessagesCollectionViewDelegateFlowLayout, UITextViewDelegate, JSQMessagesInputToolbarDelegate, JSQMessagesKeyboardControllerDelegate {
    
    @IBOutlet private(set) public var collectionView: JSQMessagesCollectionView!
    @IBOutlet private(set) public var inputToolbar: JSQMessagesInputToolbar!
    
    @IBOutlet var toolbarHeightConstraint: NSLayoutConstraint!
    @IBOutlet var toolbarBottomLayoutGuide: NSLayoutConstraint!
    
    public var keyboardController: JSQMessagesKeyboardController!
    
    public var senderID: String = ""
    public var senderDisplayName: String = ""
    
    public var automaticallyScrollsToMostRecentMessage: Bool = true
    
    public var outgoingCellIdentifier: String = JSQMessagesCollectionViewCellOutgoing.cellReuseIdentifier()
    public var outgoingMediaCellIdentifier: String = JSQMessagesCollectionViewCellOutgoing.mediaCellReuseIdentifier()

    
    public var incomingCellIdentifier: String = JSQMessagesCollectionViewCellIncoming.cellReuseIdentifier()
    public var incomingMediaCellIdentifier: String = JSQMessagesCollectionViewCellIncoming.mediaCellReuseIdentifier()
    
    public var showTypingIndicator: Bool = false {
        
        didSet {
            
            self.collectionView.collectionViewLayout.invalidateLayoutWithContext(JSQMessagesCollectionViewFlowLayoutInvalidationContext.context())
            self.collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    public var showLoadEarlierMessagesHeader: Bool = false {
        
        didSet {
            
            self.collectionView.collectionViewLayout.invalidateLayoutWithContext(JSQMessagesCollectionViewFlowLayoutInvalidationContext.context())
            self.collectionView.collectionViewLayout.invalidateLayout()
            self.collectionView.reloadData()
        }
    }
    
    public var topContentAdditionalInset: CGFloat = 0 {
        
        didSet {
            
            self.jsq_updateCollectionViewInsets()
        }
    }
    
    private var snapshotView: UIView?
    private var jsq_isObserving: Bool = false
    private let kJSQMessagesKeyValueObservingContext = UnsafeMutablePointer<Void>()
    
    private var selectedIndexPathForMenu: NSIndexPath?
    
    // MARK: - Initialization
    
    func jsq_configureMessagesViewController() {
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.toolbarHeightConstraint.constant = self.inputToolbar.preferredDefaultHeight
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        self.inputToolbar.delegate = self
        self.inputToolbar.contentView.textView.placeHolder = NSBundle.jsq_localizedStringForKey("new_message")
        self.inputToolbar.contentView.textView.delegate = self
        
        self.automaticallyScrollsToMostRecentMessage = true
        
        self.outgoingCellIdentifier = JSQMessagesCollectionViewCellOutgoing.cellReuseIdentifier()
        self.outgoingMediaCellIdentifier = JSQMessagesCollectionViewCellOutgoing.mediaCellReuseIdentifier()
        
        self.incomingCellIdentifier = JSQMessagesCollectionViewCellIncoming.cellReuseIdentifier()
        self.incomingMediaCellIdentifier = JSQMessagesCollectionViewCellIncoming.mediaCellReuseIdentifier()
        
        self.showTypingIndicator = false
        
        self.showLoadEarlierMessagesHeader = false
        
        self.topContentAdditionalInset = 0
        
        self.jsq_updateCollectionViewInsets()
        
        self.keyboardController = JSQMessagesKeyboardController(textView: self.inputToolbar.contentView.textView, contextView: self.view, panGestureRecognizer: self.collectionView.panGestureRecognizer, delegate: self)
    }
    
    // MARK: - Class methods 
    
    public class func nib() -> UINib {
        
        return UINib(nibName: "\(JSQMessagesViewController.self)".jsq_className(), bundle: NSBundle.jsq_messagesBundle())
    }
    
    public static func messagesViewController() -> JSQMessagesViewController {

        return self.init(nibName: "\(JSQMessagesViewController.self)".jsq_className(), bundle: NSBundle.jsq_messagesBundle())
    }
    
    // MARK: - View lifecycle
    
    public required override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    public required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    
    public override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.dynamicType.nib().instantiateWithOwner(self, options: nil)
        
        self.jsq_configureMessagesViewController()
        self.jsq_registerForNotifications(true)
    }
    
    public override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        if self.senderID == "" {
            
            print("senderID must not be nil \(__FUNCTION__)")
            abort()
        }
        if self.senderDisplayName == "" {
            
            print("senderDisplayName must not be nil \(__FUNCTION__)")
            abort()
        }
        
        self.view.layoutIfNeeded()
        self.collectionView.collectionViewLayout.invalidateLayout()
        
        if self.automaticallyScrollsToMostRecentMessage {
            
            dispatch_async(dispatch_get_main_queue()) {
                
                self.scrollToBottom(animated: false)
                self.collectionView.collectionViewLayout.invalidateLayoutWithContext(JSQMessagesCollectionViewFlowLayoutInvalidationContext.context())
            }
        }
        
        self.jsq_updateKeyboardTriggerPoint()
    }
    
    public override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
        self.jsq_addObservers()
        self.jsq_addActionToInteractivePopGestureRecognizer(true)
        self.keyboardController.beginListeningForKeyboard()
        
        if UIDevice.jsq_isCurrentDeviceBeforeiOS8() {
            
            self.snapshotView?.removeFromSuperview()
        }
    }
    
    public override func viewWillDisappear(animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        self.jsq_addActionToInteractivePopGestureRecognizer(false)
        self.collectionView.messagesCollectionViewLayout.springinessEnabled = false
    }
    
    public override func viewDidDisappear(animated: Bool) {
        
        super.viewDidDisappear(animated)
        
        self.keyboardController.endListeningForKeyboard()
    }
    
    public override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
        print("MEMORY WARNING: \(__FUNCTION__)")
    }
    
    // MARK: - View rotation
    
    public override func shouldAutorotate() -> Bool {
        
        return true
    }
    
    public override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {

            return .AllButUpsideDown
        }
        return .All
    }
    
    public override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        
        super.willRotateToInterfaceOrientation(toInterfaceOrientation, duration: duration)
        
        self.collectionView.collectionViewLayout.invalidateLayoutWithContext(JSQMessagesCollectionViewFlowLayoutInvalidationContext.context())
    }
    
    public override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        
        super.didRotateFromInterfaceOrientation(fromInterfaceOrientation)
        
        if self.showTypingIndicator {
            
            self.showTypingIndicator = false
            self.showTypingIndicator = true
            
            self.collectionView.reloadData()
        }
    }
    
    // MARK: - Messages view controller
    
    public func didPressSendButton(button: UIButton, withMessageText text: String, senderId: String, senderDisplayName: String, date: NSDate) {
        
        print("ERROR: required method not implemented in subclass. Need to implement \(__FUNCTION__)")
        abort()
    }

    public func didPressAccessoryButton(sender: UIButton) {
        
        print("ERROR: required method not implemented in subclass. Need to implement \(__FUNCTION__)")
        abort()
    }
    
    public func finishSendingMessage() {
        
        self.finishSendingMessage(animated: true)
    }
    
    public func finishSendingMessage(animated animated: Bool) {
        
        let textView = self.inputToolbar.contentView.textView
        textView.text = nil
        textView.undoManager?.removeAllActions()
        
        self.inputToolbar.toggleSendButtonEnabled()
        
        NSNotificationCenter.defaultCenter().postNotificationName(UITextViewTextDidChangeNotification, object: textView)
        
        self.collectionView.collectionViewLayout.invalidateLayoutWithContext(JSQMessagesCollectionViewFlowLayoutInvalidationContext.context())
        self.collectionView.reloadData()
        
        if self.automaticallyScrollsToMostRecentMessage && !self.jsq_isMenuVisible() {
            
            self.scrollToBottom(animated: animated)
        }
    }
    
    public func finishReceivingMessage() {
        
        self.finishReceivingMessage(animated: true)
    }
    
    public func finishReceivingMessage(animated animated: Bool) {
        
        self.showTypingIndicator = false
        
        self.collectionView.collectionViewLayout.invalidateLayoutWithContext(JSQMessagesCollectionViewFlowLayoutInvalidationContext.context())
        self.collectionView.reloadData()
        
        if self.automaticallyScrollsToMostRecentMessage && !self.jsq_isMenuVisible() {
            
            self.scrollToBottom(animated: animated)
        }
    }
    
    public func scrollToBottom(animated animated: Bool) {
        
        if self.collectionView.numberOfSections() == 0 {
            
            return
        }
        
        if self.collectionView.numberOfItemsInSection(0) == 0 {
            
            return
        }
        
        let collectionViewContentHeight = self.collectionView.collectionViewLayout.collectionViewContentSize().height
        let isContentTooSmall = collectionViewContentHeight < CGRectGetHeight(self.collectionView.bounds)
        
        if isContentTooSmall {
            
            self.collectionView.scrollRectToVisible(CGRectMake(0, collectionViewContentHeight - 1, 1, 1), animated: animated)
            return
        }
        
        let finalRow = max(0, self.collectionView.numberOfItemsInSection(0) - 1)
        let finalIndexPath = NSIndexPath(forRow: finalRow, inSection: 0)
        let finalCellSize = self.collectionView.messagesCollectionViewLayout.sizeForItem(finalIndexPath)
        
        let maxHeightForVisibleMessage = self.collectionView.bounds.height - self.collectionView.contentInset.top - self.inputToolbar.bounds.height
        let scrollPosition: UICollectionViewScrollPosition = finalCellSize.height > maxHeightForVisibleMessage ? .Bottom : .Top
        
        self.collectionView.scrollToItemAtIndexPath(finalIndexPath, atScrollPosition: scrollPosition, animated: animated)
    }
    
    // MARK: - JSQMessages collection view data source
    
    public func collectionView(collectionView: JSQMessagesCollectionView, messageDataForItemAtIndexPath indexPath: NSIndexPath) -> JSQMessageData {
        
        print("ERROR: required method not implemented: \(__FUNCTION__)")
        abort()
    }
    
    public func collectionView(collectionView: JSQMessagesCollectionView, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath) -> JSQMessageBubbleImageDataSource {
        
        print("ERROR: required method not implemented: \(__FUNCTION__)")
        abort()
    }
    
    public func collectionView(collectionView: JSQMessagesCollectionView, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath) -> JSQMessageAvatarImageDataSource? {
        
        print("ERROR: required method not implemented: \(__FUNCTION__)")
        abort()
    }
    
    public func collectionView(collectionView: JSQMessagesCollectionView, attributedTextForCellTopLabelAtIndexPath indexPath: NSIndexPath) -> NSAttributedString? {
        
        return nil
    }
    
    public func collectionView(collectionView: JSQMessagesCollectionView, attributedTextForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath) -> NSAttributedString? {
        
        return nil
    }
    
    public func collectionView(collectionView: JSQMessagesCollectionView, attributedTextForCellBottomLabelAtIndexPath indexPath: NSIndexPath) -> NSAttributedString? {
        
        return nil
    }
    
    // MARK: - Collection view data source
    
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 0
    }
    
    public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let dataSource = collectionView.dataSource as! JSQMessagesCollectionViewDataSource
        let flowLayout = collectionView.collectionViewLayout as! JSQMessagesCollectionViewFlowLayout
        
        let messageItem = dataSource.collectionView(self.collectionView, messageDataForItemAtIndexPath: indexPath)
        
        let messageSendId = messageItem.senderID
        let isOutgoingMessage = messageSendId == self.senderID
        let isMediaMessage = messageItem.isMediaMessage
        
        var cellIdentifier = isOutgoingMessage ? self.outgoingCellIdentifier : self.incomingCellIdentifier
        if isMediaMessage {
            
            cellIdentifier = isOutgoingMessage ? self.outgoingMediaCellIdentifier : self.incomingMediaCellIdentifier
        }
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! JSQMessagesCollectionViewCell
        
        if !isMediaMessage {
            
            cell.textView?.text = messageItem.text
            
            if UIDevice.jsq_isCurrentDeviceBeforeiOS8() {
                
                cell.textView?.text = nil
                cell.textView?.attributedText = NSAttributedString(string: messageItem.text ?? "", attributes: [
                    NSFontAttributeName: flowLayout.messageBubbleFont
                ])
            }
            
            let bubbleImageDataSource = dataSource.collectionView(self.collectionView, messageBubbleImageDataForItemAtIndexPath: indexPath)
            cell.messageBubbleImageView?.image = bubbleImageDataSource.messageBubbleImage
            cell.messageBubbleImageView?.highlightedImage = bubbleImageDataSource.messageBubbleHighlightedImage
        }
        else {
            
            let messageMedia = messageItem.media!
            cell.mediaView = messageMedia.mediaView != nil ? messageMedia.mediaView: messageMedia.mediaPlaceholderView
        }
        
        var needsAvatar = true
        if isOutgoingMessage && CGSizeEqualToSize(flowLayout.outgoingAvatarViewSize, CGSizeZero) {
            
            needsAvatar = false
        }
        else if !isOutgoingMessage && CGSizeEqualToSize((collectionView.collectionViewLayout as! JSQMessagesCollectionViewFlowLayout).incomingAvatarViewSize, CGSizeZero) {
            
            needsAvatar = false
        }
        
        var avatarImageDataSource: JSQMessageAvatarImageDataSource?
        if needsAvatar {
            
            avatarImageDataSource = dataSource.collectionView(self.collectionView, avatarImageDataForItemAtIndexPath: indexPath)
            if let avatarImageDataSource = avatarImageDataSource {
                
                if let avatarImage = avatarImageDataSource.avatarImage {
                    
                    cell.avatarImageView.image = avatarImage
                    cell.avatarImageView.highlightedImage = avatarImageDataSource.avatarHighlightedImage
                }
                else {
                    
                    cell.avatarImageView.image = avatarImageDataSource.avatarPlaceholderImage
                    cell.avatarImageView.highlightedImage = nil
                }
                
            }
        }
        
        cell.cellTopLabel.attributedText = dataSource.collectionView?(self.collectionView, attributedTextForCellTopLabelAtIndexPath: indexPath)
        cell.messageBubbleTopLabel.attributedText = dataSource.collectionView?(self.collectionView, attributedTextForMessageBubbleTopLabelAtIndexPath: indexPath)
        cell.cellBottomLabel.attributedText = dataSource.collectionView?(self.collectionView, attributedTextForCellBottomLabelAtIndexPath: indexPath)
        
        let bubbleTopLabelInset: CGFloat = avatarImageDataSource != nil ? 60 : 15
        
        if isOutgoingMessage {
            
            cell.messageBubbleTopLabel.textInsets = UIEdgeInsetsMake(0, 0, 0, bubbleTopLabelInset)
        }
        else {
            
            cell.messageBubbleTopLabel.textInsets = UIEdgeInsetsMake(0, bubbleTopLabelInset, 0, 0)
        }
        
        cell.textView?.dataDetectorTypes = .All
        
        cell.backgroundColor = UIColor.clearColor()
        cell.layer.rasterizationScale = UIScreen.mainScreen().scale
        cell.layer.shouldRasterize = true
        
        return cell
    }
    
    public func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        if self.showTypingIndicator && kind == UICollectionElementKindSectionFooter {
            
            return self.collectionView.dequeueTypingIndicatorFooterView(indexPath)
        }
        
        // self.showLoadEarlierMessagesHeader && kind == UICollectionElementKindSectionHeader
        return self.collectionView.dequeueLoadEarlierMessagesViewHeader(indexPath)
    }
    
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        if !self.showTypingIndicator {
            
            return CGSizeZero
        }
        
        return CGSizeMake((collectionViewLayout as? JSQMessagesCollectionViewFlowLayout)?.itemWidth ?? 0, JSQMessagesTypingIndicatorFooterView.kJSQMessagesTypingIndicatorFooterViewHeight)
    }
    
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        if !self.showLoadEarlierMessagesHeader {
            
            return CGSizeZero
        }
        
        return CGSizeMake((collectionViewLayout as? JSQMessagesCollectionViewFlowLayout)?.itemWidth ?? 0, JSQMessagesLoadEarlierHeaderView.kJSQMessagesLoadEarlierHeaderViewHeight)
    }
    
    // MARK: - Collection view delegate
    
    public func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        if let messageItem = (collectionView.dataSource as? JSQMessagesCollectionViewDataSource)?.collectionView(self.collectionView, messageDataForItemAtIndexPath: indexPath) {
            
            if messageItem.isMediaMessage {
                
                return false
            }
        }
        
        self.selectedIndexPathForMenu = indexPath
        
        if let selectedCell = collectionView.cellForItemAtIndexPath(indexPath) as? JSQMessagesCollectionViewCell {
            
            selectedCell.textView?.selectable = false
        }
        
        return true
    }
    
    public func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        
        if action == Selector("copy:") {
            
            return true
        }
        
        return false
    }
    
    public func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
        
        if action == Selector("copy:") {

            if let messageData = (collectionView.dataSource as? JSQMessagesCollectionViewDataSource)?.collectionView(self.collectionView, messageDataForItemAtIndexPath: indexPath) {
                
                UIPasteboard.generalPasteboard().string = messageData.text
            }
        }
    }
    
    // MARK: - Collection view delegate flow layout
    
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return (collectionViewLayout as! JSQMessagesCollectionViewFlowLayout).sizeForItem(indexPath)
    }
    
    public func collectionView(collectionView: JSQMessagesCollectionView, layout: JSQMessagesCollectionViewFlowLayout, heightForCellTopLabelAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 0
    }
    
    public func collectionView(collectionView: JSQMessagesCollectionView, layout: JSQMessagesCollectionViewFlowLayout, heightForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 0
    }
    
    public func collectionView(collectionView: JSQMessagesCollectionView, layout: JSQMessagesCollectionViewFlowLayout, heightForCellBottomLabelAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 0
    }
    
    public func collectionView(collectionView: JSQMessagesCollectionView, didTapAvatarImageView imageView: UIImageView, atIndexPath indexPath: NSIndexPath) { }
    
    public func collectionView(collectionView: JSQMessagesCollectionView, didTapMessageBubbleAtIndexPath indexPath: NSIndexPath) { }

    public func collectionView(collectionView: JSQMessagesCollectionView, didTapCellAtIndexPath indexPath: NSIndexPath, touchLocation: CGPoint) { }

    // MARK: - Input toolbar delegate
    
    public func messagesInputToolbar(toolbar: JSQMessagesInputToolbar, didPressLeftBarButton sender: UIButton) {
        
        if toolbar.sendButtonOnRight {
            
            self.didPressAccessoryButton(sender)
        }
        else {
            
            self.didPressSendButton(sender, withMessageText: self.jsq_currentlyComposedMessageText(), senderId: self.senderID, senderDisplayName: self.senderDisplayName, date: NSDate())
        }
    }
    
    public func messagesInputToolbar(toolbar: JSQMessagesInputToolbar, didPressRightBarButton sender: UIButton) {
        
        if toolbar.sendButtonOnRight {
            
            self.didPressSendButton(sender, withMessageText: self.jsq_currentlyComposedMessageText(), senderId: self.senderID, senderDisplayName: self.senderDisplayName, date: NSDate())
        }
        else {
            
            self.didPressAccessoryButton(sender)
        }
    }
    
    func jsq_currentlyComposedMessageText() -> String {
    
        self.inputToolbar.contentView.textView.inputDelegate?.selectionWillChange(self.inputToolbar.contentView.textView)
        self.inputToolbar.contentView.textView.inputDelegate?.selectionDidChange(self.inputToolbar.contentView.textView)
        
        return self.inputToolbar.contentView.textView.text.jsq_stringByTrimingWhitespace()
    }
    
    // MARK: - Text view delegate
    
    public func textViewDidBeginEditing(textView: UITextView) {
        
        if textView != self.inputToolbar.contentView.textView {
            
            return
        }
        
        textView.becomeFirstResponder()
        
        if self.automaticallyScrollsToMostRecentMessage {
            
            self.scrollToBottom(animated: true)
        }
    }
    
    public func textViewDidChange(textView: UITextView) {
        
        if textView != self.inputToolbar.contentView.textView {
            
            return
        }
        
        self.inputToolbar.toggleSendButtonEnabled()
    }
    
    public func textViewDidEndEditing(textView: UITextView) {
        
        if textView != self.inputToolbar.contentView.textView {
            
            return
        }
        
        textView.resignFirstResponder()
    }
    
    // MARK: - Notifications
    
    func jsq_handleDidChangeStatusBarFrameNotification(notification: NSNotification) {
        
        if self.keyboardController.keyboardIsVisible {
            
            self.jsq_setToolbarBottomLayoutGuideConstant(self.keyboardController.currentKeyboardFrame.height)
        }
    }
    
    func jsq_didReceiveMenuWillShowNotification(notification: NSNotification) {
        
        if let selectedIndexPathForMenu = self.selectedIndexPathForMenu {
            
            NSNotificationCenter.defaultCenter().removeObserver(self, name: UIMenuControllerWillShowMenuNotification, object: nil)
            
            if let menu = notification.object as? UIMenuController {
                
                menu.setMenuVisible(false, animated: false)
                
                if let selectedCell = self.collectionView.cellForItemAtIndexPath(selectedIndexPathForMenu) as? JSQMessagesCollectionViewCell {
                    
                    let selectedCellMessageBubbleFrame = selectedCell.convertRect(selectedCell.messageBubbleContainerView.frame, toView: self.view)
                    
                    menu.setTargetRect(selectedCellMessageBubbleFrame, inView: self.view)
                    menu.setMenuVisible(true, animated: true)
                }
            }
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("jsq_didReceiveMenuWillShowNotification:"), name: UIMenuControllerWillShowMenuNotification, object: nil)
        }
    }
    
    func jsq_didReceiveMenuWillHideNotification(notification: NSNotification) {
        
        if let selectedIndexPathForMenu = self.selectedIndexPathForMenu,
            let selectedCell = self.collectionView.cellForItemAtIndexPath(selectedIndexPathForMenu) as? JSQMessagesCollectionViewCell {
            
            selectedCell.textView?.selectable = true
            self.selectedIndexPathForMenu = nil
        }
    }
    
    // MARK: - Key-value observing

    public override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        if context == self.kJSQMessagesKeyValueObservingContext {
            
            if let object = object as? UITextView {
                
                if object == self.inputToolbar.contentView.textView && keyPath == "contentSize" {
                    
                    if let oldContentSize = change?[NSKeyValueChangeOldKey]?.CGSizeValue(),
                        let newContentSize = change?[NSKeyValueChangeNewKey]?.CGSizeValue() {

                        let dy = newContentSize.height - oldContentSize.height
                        
                        self.jsq_adjustInputToolbarForComposerTextViewContentSizeChange(dy)
                        self.jsq_updateCollectionViewInsets()
                        if self.automaticallyScrollsToMostRecentMessage {
                            
                            self.scrollToBottom(animated: false)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Keyboard controller delegate
    
    public func keyboardController(keyboardController: JSQMessagesKeyboardController, keyboardDidChangeFrame keyboardFrame: CGRect) {
        
        if !self.inputToolbar.contentView.textView.isFirstResponder() && self.toolbarBottomLayoutGuide.constant == 0 {
            
            return
        }
        
        var heightFromBottom = CGRectGetMaxY(self.collectionView.frame) - CGRectGetMinY(keyboardFrame)
        heightFromBottom = max(0, heightFromBottom)
        
        self.jsq_setToolbarBottomLayoutGuideConstant(heightFromBottom)
    }
    
    func jsq_setToolbarBottomLayoutGuideConstant(constant: CGFloat) {
    
        self.toolbarBottomLayoutGuide.constant = constant
        self.view.setNeedsUpdateConstraints()
        self.view.layoutIfNeeded()
        
        self.jsq_updateCollectionViewInsets()
    }
    
    func jsq_updateKeyboardTriggerPoint() {
        
        self.keyboardController.keyboardTriggerPoint = CGPointMake(0, self.inputToolbar.bounds.height)
    }
    
    // MARK: - Gesture recognizers
    
    func jsq_handleInteractivePopGestureRecognizer(gestureRecognizer: UIGestureRecognizer) {
        
        switch gestureRecognizer.state {
            
            case .Began:
                if UIDevice.jsq_isCurrentDeviceBeforeiOS8() {
             
                    self.snapshotView?.removeFromSuperview()
                }
            
                self.keyboardController.endListeningForKeyboard()
            
                if UIDevice.jsq_isCurrentDeviceBeforeiOS8() {
                
                    self.inputToolbar.contentView.textView.resignFirstResponder()
                    UIView.animateWithDuration(0, animations: { () -> Void in
                        
                        self.jsq_setToolbarBottomLayoutGuideConstant(0)
                    })
                    
                    let snapshot = self.view.snapshotViewAfterScreenUpdates(true)
                    self.view.addSubview(snapshot)
                    self.snapshotView = snapshot
                }
            case .Changed:
                break
            case .Ended, .Cancelled, .Failed:
            
                self.keyboardController.beginListeningForKeyboard()
            
                if UIDevice.jsq_isCurrentDeviceBeforeiOS8() {
                
                    self.snapshotView?.removeFromSuperview()
                }
            default:
                break
        }
    }
    
    // MARK: - Input toolbar utilities
    
    func jsq_inputToolbarHasReachedMaximumHeight() -> Bool {
        
        return CGRectGetMinY(self.inputToolbar.frame) == (self.topLayoutGuide.length + self.topContentAdditionalInset)
    }
    
    func jsq_adjustInputToolbarForComposerTextViewContentSizeChange(var dy: CGFloat) {
        
        let contentSizeIsIncreasing = dy > 0
        
        if self.jsq_inputToolbarHasReachedMaximumHeight() {

            let contentOffsetIsPositive = (self.inputToolbar.contentView.textView.contentOffset.y > 0);
            
            if (contentSizeIsIncreasing || contentOffsetIsPositive) {

                self.jsq_scrollComposerTextViewToBottom(animated: true)
                return
            }
        }
        
        let toolbarOriginY = CGRectGetMinY(self.inputToolbar.frame)
        let newToolbarOriginY = toolbarOriginY - dy
        
        //  attempted to increase origin.Y above topLayoutGuide
        if newToolbarOriginY <= self.topLayoutGuide.length + self.topContentAdditionalInset {

            dy = toolbarOriginY - (self.topLayoutGuide.length + self.topContentAdditionalInset)
            self.jsq_scrollComposerTextViewToBottom(animated: true)
        }
        
        self.jsq_adjustInputToolbarHeightConstraintByDelta(dy)
        
        self.jsq_updateKeyboardTriggerPoint()
        
        if dy < 0 {
            
            self.jsq_scrollComposerTextViewToBottom(animated: false)
        }
    }
    
    func jsq_adjustInputToolbarHeightConstraintByDelta(dy: CGFloat) {
        
        let proposedHeight = self.toolbarHeightConstraint.constant + dy
        
        var finalHeight = max(proposedHeight, self.inputToolbar.preferredDefaultHeight)
        
        if self.inputToolbar.maximumHeight != NSNotFound {
            
            finalHeight = min(finalHeight, CGFloat(self.inputToolbar.maximumHeight))
        }
        
        if self.toolbarHeightConstraint.constant != finalHeight {
            
            self.toolbarHeightConstraint.constant = finalHeight
            self.view.setNeedsUpdateConstraints()
            self.view.layoutIfNeeded()
        }
    }
    
    func jsq_scrollComposerTextViewToBottom(animated animated: Bool) {
        
        let textView = self.inputToolbar.contentView.textView
        let contentOffsetToShowLastLine = CGPointMake(0, textView.contentSize.height - CGRectGetHeight(textView.bounds))
        
        if !animated {
            
            textView.contentOffset = contentOffsetToShowLastLine
            return
        }
        
        UIView.animateWithDuration(0.01, delay: 0.01, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
            
            textView.contentOffset = contentOffsetToShowLastLine

        }, completion: nil)
    }
    
    // MARK: - Collection view utilities
    
    func jsq_updateCollectionViewInsets() {
        
        self.jsq_setCollectionViewInsets(topValue: self.topLayoutGuide.length + self.topContentAdditionalInset, bottomValue: CGRectGetMaxY(self.collectionView.frame) - CGRectGetMinY(self.inputToolbar.frame))
    }
    
    func jsq_setCollectionViewInsets(topValue topValue: CGFloat, bottomValue: CGFloat) {
        
        let insets = UIEdgeInsetsMake(topValue, 0, bottomValue, 0)
        self.collectionView.contentInset = insets
        self.collectionView.scrollIndicatorInsets = insets
    }
    
    func jsq_isMenuVisible() -> Bool {
        
        return self.selectedIndexPathForMenu != nil && UIMenuController.sharedMenuController().menuVisible
    }
    
    // MARK: - Utilities
    
    func jsq_addObservers() {
        
        if self.jsq_isObserving {

            return
        }
        
        self.inputToolbar.contentView.textView.addObserver(self, forKeyPath: "contentSize", options: [NSKeyValueObservingOptions.Old, NSKeyValueObservingOptions.New], context: self.kJSQMessagesKeyValueObservingContext)
        
        self.jsq_isObserving = true
    }
    
    func jsq_removeObservers() {
        
        if !self.jsq_isObserving {
            
            return
        }
        
        self.inputToolbar.contentView.textView.removeObserver(self, forKeyPath: "contentSize", context: self.kJSQMessagesKeyValueObservingContext)
        
        self.jsq_isObserving = false
    }
    
    func jsq_registerForNotifications(register: Bool) {
        
        if register {
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("jsq_handleDidChangeStatusBarFrameNotification:"), name: UIApplicationDidChangeStatusBarFrameNotification, object: nil)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("jsq_didReceiveMenuWillShowNotification:"), name: UIMenuControllerWillShowMenuNotification, object: nil)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("jsq_didReceiveMenuWillHideNotification:"), name: UIMenuControllerWillHideMenuNotification, object: nil)
        }
        else {
            
            NSNotificationCenter.defaultCenter().removeObserver(self, name: UIApplicationDidChangeStatusBarFrameNotification, object: nil)
            NSNotificationCenter.defaultCenter().removeObserver(self, name: UIMenuControllerWillShowMenuNotification, object: nil)
            NSNotificationCenter.defaultCenter().removeObserver(self, name: UIMenuControllerWillHideMenuNotification, object: nil)
        }
    }

    func jsq_addActionToInteractivePopGestureRecognizer(addAction: Bool) {
        
        if let interactivePopGestureRecognizer = self.navigationController?.interactivePopGestureRecognizer {
            
            interactivePopGestureRecognizer.removeTarget(nil, action: Selector("jsq_handleInteractivePopGestureRecognizer:"))
            
            if addAction {
                
                interactivePopGestureRecognizer.addTarget(self, action: Selector("jsq_handleInteractivePopGestureRecognizer:"))
            }
        }
    }
}