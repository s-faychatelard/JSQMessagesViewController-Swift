//
//  JSQMessagesCollectionView.swift
//  JSQMessagesViewController
//
//  Created by Sylvain FAY-CHATELARD on 20/08/2015.
//  Copyright (c) 2015 Dviance. All rights reserved.
//

import UIKit

public class JSQMessagesCollectionView: UICollectionView, JSQMessagesCollectionViewCellDelegate, JSQMessagesLoadEarlierHeaderViewDelegate {
    
    public var messagesDataSource: JSQMessagesCollectionViewDataSource? {
        get { return self.dataSource as? JSQMessagesCollectionViewDataSource }
    }
    public var messagesDelegate: JSQMessagesCollectionViewDelegateFlowLayout? {
        get { return self.delegate as? JSQMessagesCollectionViewDelegateFlowLayout }
    }
    public var messagesCollectionViewLayout: JSQMessagesCollectionViewFlowLayout {
        get { return self.collectionViewLayout as! JSQMessagesCollectionViewFlowLayout }
    }
    
    var typingIndicatorDisplaysOnLeft: Bool = true
    var typingIndicatorMessageBubbleColor: UIColor = UIColor.jsq_messageBubbleLightGrayColor()
    var typingIndicatorEllipsisColor: UIColor = UIColor.jsq_messageBubbleLightGrayColor().jsq_colorByDarkeningColorWithValue(0.3)
    
    var loadEarlierMessagesHeaderTextColor: UIColor = UIColor.jsq_messageBubbleBlueColor()
    
    // MARK: - Initialization
    
    func jsq_configureCollectionView() {
        
        self.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        self.backgroundColor = UIColor.whiteColor()
        self.keyboardDismissMode = .None
        self.alwaysBounceVertical = true
        self.bounces = true
        
        self.registerNib(JSQMessagesCollectionViewCellIncoming.nib(), forCellWithReuseIdentifier: JSQMessagesCollectionViewCellIncoming.cellReuseIdentifier())
        
        self.registerNib(JSQMessagesCollectionViewCellOutgoing.nib(), forCellWithReuseIdentifier: JSQMessagesCollectionViewCellOutgoing.cellReuseIdentifier())
        
        self.registerNib(JSQMessagesCollectionViewCellIncoming.nib(), forCellWithReuseIdentifier: JSQMessagesCollectionViewCellIncoming.mediaCellReuseIdentifier())
        
        self.registerNib(JSQMessagesCollectionViewCellOutgoing.nib(), forCellWithReuseIdentifier: JSQMessagesCollectionViewCellOutgoing.mediaCellReuseIdentifier())
        
        self.registerNib(JSQMessagesTypingIndicatorFooterView.nib(), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: JSQMessagesTypingIndicatorFooterView.footerReuseIdentifier())
        
        self.registerNib(JSQMessagesLoadEarlierHeaderView.nib(), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: JSQMessagesLoadEarlierHeaderView.headerReuseIdentifier())
    }
    
    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        
        super.init(frame: frame, collectionViewLayout: layout)
        
        self.jsq_configureCollectionView()
    }

    public required init(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        self.jsq_configureCollectionView()
    }
    
    public override func awakeFromNib() {
        
        super.awakeFromNib()
        
        self.jsq_configureCollectionView()
    }
    
    // MARK: - Typing indicator
    
    func dequeueTypingIndicatorFooterView(indexPath: NSIndexPath) -> JSQMessagesTypingIndicatorFooterView {
        
        let footerView = super.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionFooter, withReuseIdentifier: JSQMessagesTypingIndicatorFooterView.footerReuseIdentifier(), forIndexPath: indexPath) as! JSQMessagesTypingIndicatorFooterView
        
        footerView.configure(self.typingIndicatorEllipsisColor, messageBubbleColor: self.typingIndicatorMessageBubbleColor, shouldDisplayOnLeft: self.typingIndicatorDisplaysOnLeft, forCollectionView: self)
        
        return footerView
    }
    
    // MARK: - Load earlier messages header
    
    func dequeueLoadEarlierMessagesViewHeader(indexPath: NSIndexPath) -> JSQMessagesLoadEarlierHeaderView {
        
        let headerView = super.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: JSQMessagesLoadEarlierHeaderView.headerReuseIdentifier(), forIndexPath: indexPath) as! JSQMessagesLoadEarlierHeaderView
        
        headerView.loadButton.tintColor = self.loadEarlierMessagesHeaderTextColor
        headerView.delegate = self
        
        return headerView
    }
    
    // MARK: - Load earlier messages header delegate
    
    public func headerView(headerView: JSQMessagesLoadEarlierHeaderView, didPressLoadButton sender: UIButton?) {
        
        self.messagesDelegate?.collectionView?(self, header: headerView, didTapLoadEarlierMessagesButton: sender)
    }
    
    // MARK: - Messages collection cell delegate

    public func messagesCollectionViewCellDidTapAvatar(cell: JSQMessagesCollectionViewCell) {
        
        if let indexPath = self.indexPathForCell(cell) {
            
            self.messagesDelegate?.collectionView?(self, didTapAvatarImageView: cell.avatarImageView, atIndexPath: indexPath)
        }
    }
    
    public func messagesCollectionViewCellDidTapMessageBubble(cell: JSQMessagesCollectionViewCell) {
        
        if let indexPath = self.indexPathForCell(cell) {
            
            self.messagesDelegate?.collectionView?(self, didTapMessageBubbleAtIndexPath: indexPath)
        }
    }
    
    public func messagesCollectionViewCellDidTapCell(cell: JSQMessagesCollectionViewCell, atPosition position: CGPoint) {
        
        if let indexPath = self.indexPathForCell(cell) {
            
            self.messagesDelegate?.collectionView?(self, didTapCellAtIndexPath: indexPath, touchLocation: position)
        }
    }
    
    public func messagesCollectionViewCell(cell: JSQMessagesCollectionViewCell, didPerformAction action: Selector, withSender sender: AnyObject) {
        
        if let indexPath = self.indexPathForCell(cell) {
            
            self.messagesDelegate?.collectionView?(self, performAction: action, forItemAtIndexPath: indexPath, withSender: sender)
        }
    }
}