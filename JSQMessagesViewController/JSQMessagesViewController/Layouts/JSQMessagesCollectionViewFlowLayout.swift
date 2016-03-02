//
//  JSQMessagesCollectionViewFlowLayout.swift
//  JSQMessagesViewController
//
//  Created by Sylvain FAY-CHATELARD on 20/08/2015.
//  Copyright (c) 2015 Dviance. All rights reserved.
//

import UIKit

public let kJSQMessagesCollectionViewCellLabelHeightDefault: CGFloat = 20
public let kJSQMessagesCollectionViewAvatarSizeDefault: CGFloat = 30

public class JSQMessagesCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    public override class func layoutAttributesClass() -> AnyClass {
        
        return JSQMessagesCollectionViewLayoutAttributes.self
    }
    
    public override class func invalidationContextClass() -> AnyClass {
        
        return JSQMessagesCollectionViewFlowLayoutInvalidationContext.self
    }
    
    public var messagesCollectionView: JSQMessagesCollectionView {
        
        get {
            
            return self.collectionView as! JSQMessagesCollectionView
        }
    }
    
    public var springinessEnabled: Bool = false {
        
        didSet {
            
            if !self.springinessEnabled {
                
                self.dynamicAnimator.removeAllBehaviors()
                self.visibleIndexPaths.removeAll()
            }
            self.invalidateLayoutWithContext(JSQMessagesCollectionViewFlowLayoutInvalidationContext.context())
        }
    }
    public var springResistanceFactor: CGFloat = 1000
    
    public var itemWidth: CGFloat {
        
        get {

            return (self.collectionView?.frame.width ?? 0) - self.sectionInset.left - self.sectionInset.right
        }
    }
    
    public var messageBubbleFont: UIFont = UIFont.preferredFontForTextStyle(UIFontTextStyleBody) {
        
        didSet {
            
            self.invalidateLayoutWithContext(JSQMessagesCollectionViewFlowLayoutInvalidationContext.context())
        }
    }
    public var messageBubbleLeftRightMargin: CGFloat = 50 {
        
        didSet {
            
            self.invalidateLayoutWithContext(JSQMessagesCollectionViewFlowLayoutInvalidationContext.context())
        }
    }
    public var messageBubbleTextViewFrameInsets: UIEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 6) {
        
        didSet {
            
            self.invalidateLayoutWithContext(JSQMessagesCollectionViewFlowLayoutInvalidationContext.context())
        }
    }
    public var messageBubbleTextViewTextContainerInsets: UIEdgeInsets = UIEdgeInsetsMake(7, 14, 7, 14) {
        
        didSet {
            
            self.invalidateLayoutWithContext(JSQMessagesCollectionViewFlowLayoutInvalidationContext.context())
        }
    }
    
    public var incomingAvatarViewSize: CGSize = CGSizeMake(30, 30) {
        
        didSet {
            
            self.invalidateLayoutWithContext(JSQMessagesCollectionViewFlowLayoutInvalidationContext.context())
        }
    }
    public var outgoingAvatarViewSize: CGSize = CGSizeMake(30, 30) {
        
        didSet {
            
            self.invalidateLayoutWithContext(JSQMessagesCollectionViewFlowLayoutInvalidationContext.context())
        }
    }
    
    public var cacheLimit: Int {
        
        get {
            
            return self.messageBubbleCache.countLimit
        }
    }
    
    private var messageBubbleCache: NSCache = NSCache()
    private var dynamicAnimator: UIDynamicAnimator!
    private var visibleIndexPaths: Set<NSIndexPath> = Set<NSIndexPath>()
    private var latestDelta: CGFloat = 0
    private var bubbleImageAssetWidth: CGFloat = 0
    
    func jsq_configureFlowLayout() {
        
        self.scrollDirection = .Vertical
        self.sectionInset = UIEdgeInsetsMake(10, 4, 10, 4)
        self.minimumLineSpacing = 4
        
        self.bubbleImageAssetWidth = UIImage.jsq_bubbleCompactImage()?.size.width ?? 0
        
        self.messageBubbleCache.name = "JSQMessagesCollectionViewFlowLayout.messageBubbleCache"
        self.messageBubbleCache.countLimit = 200
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            
            self.messageBubbleLeftRightMargin = 240
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("jsq_didReceiveApplicationMemoryWarningNotification:"), name: UIApplicationDidReceiveMemoryWarningNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("jsq_didReceiveDeviceOrientationDidChangeNotification:"), name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    deinit {
        
        self.messageBubbleCache.removeAllObjects()
        self.dynamicAnimator.removeAllBehaviors()
        self.visibleIndexPaths.removeAll()
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    public override init() {
        
        super.init()
        
        self.dynamicAnimator = UIDynamicAnimator(collectionViewLayout: self)
        
        self.jsq_configureFlowLayout()
    }

    public required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        self.dynamicAnimator = UIDynamicAnimator(collectionViewLayout: self)

        self.jsq_configureFlowLayout()
    }
    
    // MARK: - Notifications
    
    func jsq_didReceiveApplicationMemoryWarningNotification(notification: NSNotification) {
        
        self.jsq_resetLayout()
    }
    
    func jsq_didReceiveDeviceOrientationDidChangeNotification(notification: NSNotification) {
        
        self.jsq_resetLayout()
        self.invalidateLayoutWithContext(JSQMessagesCollectionViewFlowLayoutInvalidationContext.context())
    }
    
    // MARK: - Collection view flow layout
    
    public override func invalidateLayoutWithContext(context: UICollectionViewLayoutInvalidationContext) {
        
        if let context = context as? JSQMessagesCollectionViewFlowLayoutInvalidationContext {
            
            if context.invalidateDataSourceCounts {
                
                context.invalidateFlowLayoutAttributes = true
                context.invalidateFlowLayoutDelegateMetrics = true
            }
            
            if context.invalidateFlowLayoutAttributes || context.invalidateFlowLayoutDelegateMetrics {
                
                self.jsq_resetDynamicAnimator()
            }
            
            if context.invalidateFlowLayoutMessagesCache {
                
                self.jsq_resetLayout()
            }
        }
        
        super.invalidateLayoutWithContext(context)
    }
    
    public override func prepareLayout() {
        
        super.prepareLayout()
        
        if self.springinessEnabled {
            
            let padding: CGFloat = -100
            let visibleRect = CGRectInset(self.collectionView?.bounds ?? CGRectZero, padding, padding)
            
            if let visibleItems = super.layoutAttributesForElementsInRect(visibleRect) {
            
                let visibleItemsIndexPaths = visibleItems.map { $0.indexPath } as [NSIndexPath]

                self.jsq_removeNoLongerVisibleBehaviors(Set<NSIndexPath>(visibleItemsIndexPaths))
                self.jsq_addNewlyVisibleBehaviors(visibleItems)
            }
        }
    }

    public override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        if let attributesInRect = super.layoutAttributesForElementsInRect(rect) as? [JSQMessagesCollectionViewLayoutAttributes] {
        
            if self.springinessEnabled {
                
                var attributesInRectCopy = Set(attributesInRect)
                let dynamicAttributes = self.dynamicAnimator.itemsInRect(rect)
                
                //  avoid duplicate attributes
                //  use dynamic animator attribute item instead of regular item, if it exists
                for eachItem in attributesInRect {
                    
                    for eachDynamicItem in dynamicAttributes {
                        
                        if let eachDynamicItem = eachDynamicItem as? JSQMessagesCollectionViewLayoutAttributes {
                            
                            if eachItem.indexPath == eachDynamicItem.indexPath && eachItem.representedElementCategory == eachDynamicItem.representedElementCategory {
                                
                                attributesInRectCopy.remove(eachItem)
                                attributesInRectCopy.insert(eachDynamicItem)
                            }
                        }
                    }
                }
            }

            for attributesItem in attributesInRect {
                
                if attributesItem.representedElementCategory == .Cell {
                    
                    self.jsq_configureMessageCell(attributesItem)
                }
                else {
                    
                    attributesItem.zIndex = -1
                }
            }
        
            return attributesInRect
        }
        return []
    }
    
    public override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        
        let customAttributes = super.layoutAttributesForItemAtIndexPath(indexPath) as! JSQMessagesCollectionViewLayoutAttributes
        
        if customAttributes.representedElementCategory == .Cell {
            
            self.jsq_configureMessageCell(customAttributes)
        }
        
        return customAttributes
    }
    
    public override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {

        if self.springinessEnabled {
            
            let delta = newBounds.origin.y - self.messagesCollectionView.bounds.origin.y
            
            self.latestDelta = delta
            
            let touchLocation = self.messagesCollectionView.panGestureRecognizer.locationInView(self.messagesCollectionView)
            
            for springBehaviour in self.dynamicAnimator.behaviors as? [UIAttachmentBehavior] ?? [] {
                
                self.jsq_adjust(springBehaviour, forTouchLocation: touchLocation)
                
                if let item = springBehaviour.items.first {
                    
                    self.dynamicAnimator.updateItemUsingCurrentState(item)
                }
            }
        }
        
        let oldBounds = self.messagesCollectionView.bounds
        if newBounds.width != oldBounds.width {

            return true
        }
        
        return false
    }

    public override func prepareForCollectionViewUpdates(updateItems: [UICollectionViewUpdateItem]) {
        
        super.prepareForCollectionViewUpdates(updateItems)
        
        for updateItem in updateItems {
            
            if let indexPathAfterUpdate = updateItem.indexPathAfterUpdate {

                if self.springinessEnabled && self.dynamicAnimator.layoutAttributesForCellAtIndexPath(indexPathAfterUpdate) != nil {

                    return
                }

                let collectionViewHeight = self.messagesCollectionView.bounds.height
                let attributes = JSQMessagesCollectionViewLayoutAttributes(forCellWithIndexPath: indexPathAfterUpdate)

                if attributes.representedElementCategory == .Cell {

                    self.jsq_configureMessageCell(attributes)
                }

                attributes.frame = CGRectMake(0, collectionViewHeight, attributes.frame.width, attributes.frame.height)

                if self.springinessEnabled {

                    if let springBehaviour = self.jsq_springBehavior(layoutAttributesItem: attributes) {

                        self.dynamicAnimator.addBehavior(springBehaviour)
                    }
                }
            }
        }

    }

    // MARK: - Invalidation utilities

    func jsq_resetLayout() {
        
        self.messageBubbleCache.removeAllObjects()
        self.jsq_resetDynamicAnimator()
    }
    
    func jsq_resetDynamicAnimator () {
        
        if self.springinessEnabled {
            
            self.dynamicAnimator.removeAllBehaviors()
            self.visibleIndexPaths.removeAll()
        }
    }
    
    // MARK: - Message cell layout utilities
    
    func messageBubbleSize(indexPath: NSIndexPath) -> CGSize {
        
        if let messageItem = self.messagesCollectionView.messagesDataSource?.collectionView(self.messagesCollectionView, messageDataForItemAtIndexPath: indexPath) {
        
            if let cachedSize = self.messageBubbleCache.objectForKey(messageItem.messageHash) as? NSValue {
                
                return cachedSize.CGSizeValue()
            }
            
            var finalSize = CGSizeZero
            
            if messageItem.isMediaMessage {
                
                finalSize = messageItem.media?.mediaViewDisplaySize ?? CGSizeZero
            }
            else {
                
                let avatarSize = self.jsq_avatarSize(indexPath)
                let spacingBetweenAvatarAndBubble: CGFloat = 2
                let horizontalContainerInsets = self.messageBubbleTextViewTextContainerInsets.left + self.messageBubbleTextViewTextContainerInsets.right
                let horizontalFrameInsets = self.messageBubbleTextViewFrameInsets.left + self.messageBubbleTextViewFrameInsets.right
                
                let horizontalInsetsTotal = horizontalContainerInsets + horizontalFrameInsets + spacingBetweenAvatarAndBubble
                let maximumTextWidth = self.itemWidth - avatarSize.width - self.messageBubbleLeftRightMargin - horizontalInsetsTotal
                
                let stringRect = (messageItem.text! as NSString).boundingRectWithSize(CGSizeMake(maximumTextWidth, CGFloat.max), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName : self.messageBubbleFont], context: nil)
                
                let stringSize = CGRectIntegral(stringRect).size
                
                let verticalContainerInsets = self.messageBubbleTextViewTextContainerInsets.top + self.messageBubbleTextViewTextContainerInsets.bottom
                let verticalFrameInsets = self.messageBubbleTextViewFrameInsets.top + self.messageBubbleTextViewFrameInsets.bottom
                
                //  add extra 2 points of space, because `boundingRectWithSize:` is slightly off
                //  not sure why. magix. (shrug) if you know, submit a PR
                let verticalInsets = verticalContainerInsets + verticalFrameInsets + 2
                
                //  same as above, an extra 2 points of magix
                let finalWidth = max(stringSize.width + horizontalInsetsTotal, self.bubbleImageAssetWidth) + 2
                
                finalSize = CGSizeMake(finalWidth, stringSize.height + verticalInsets)
            }
            
            self.messageBubbleCache.setObject(NSValue(CGSize: finalSize), forKey: messageItem.messageHash)
            
            return finalSize
        }
        
        return CGSizeZero
    }
    
    func sizeForItem(indexPath: NSIndexPath) -> CGSize {
        
        let messageBubbleSize = self.messageBubbleSize(indexPath)
        if let attributes = self.layoutAttributesForItemAtIndexPath(indexPath) as? JSQMessagesCollectionViewLayoutAttributes {
            
            var finalHeight = messageBubbleSize.height
            finalHeight += attributes.cellTopLabelHeight
            finalHeight += attributes.messageBubbleTopLabelHeight
            finalHeight += attributes.cellBottomLabelHeight
            
            return CGSizeMake(self.itemWidth, ceil(finalHeight))
        }
        return CGSizeZero
    }
    
    func jsq_configureMessageCell(layoutAttributes: JSQMessagesCollectionViewLayoutAttributes) {
        
        let indexPath = layoutAttributes.indexPath
        let messageBubbleSize = self.messageBubbleSize(indexPath)
        
        layoutAttributes.messageBubbleContainerViewWidth = messageBubbleSize.width
        layoutAttributes.textViewFrameInsets = self.messageBubbleTextViewFrameInsets
        layoutAttributes.textViewTextContainerInsets = self.messageBubbleTextViewTextContainerInsets
        layoutAttributes.messageBubbleFont = self.messageBubbleFont
        layoutAttributes.incomingAvatarViewSize = self.incomingAvatarViewSize
        layoutAttributes.outgoingAvatarViewSize = self.outgoingAvatarViewSize
        layoutAttributes.cellTopLabelHeight = self.messagesCollectionView.messagesDelegate?.collectionView?(self.messagesCollectionView, layout: self, heightForCellTopLabelAtIndexPath: indexPath) ?? layoutAttributes.cellTopLabelHeight
        layoutAttributes.messageBubbleTopLabelHeight = self.messagesCollectionView.messagesDelegate?.collectionView?(self.messagesCollectionView, layout: self, heightForMessageBubbleTopLabelAtIndexPath: indexPath) ?? layoutAttributes.messageBubbleTopLabelHeight
        layoutAttributes.cellBottomLabelHeight = self.messagesCollectionView.messagesDelegate?.collectionView?(self.messagesCollectionView, layout: self, heightForCellBottomLabelAtIndexPath: indexPath) ?? layoutAttributes.cellBottomLabelHeight
        
    }
    
    func jsq_avatarSize(indexPath: NSIndexPath) -> CGSize {
        
        if let messageItem = self.messagesCollectionView.messagesDataSource?.collectionView(self.messagesCollectionView, messageDataForItemAtIndexPath: indexPath) {
            
            let messageSender = messageItem.senderID
            if messageSender == self.messagesCollectionView.messagesDataSource?.senderID {
                
                return self.outgoingAvatarViewSize
            }
        }
        
        return self.incomingAvatarViewSize
    }
    
    // MARK: - Spring behavior utilities
    
    func jsq_springBehavior(layoutAttributesItem item: UICollectionViewLayoutAttributes) -> UIAttachmentBehavior? {
        
        if CGSizeEqualToSize(item.frame.size, CGSizeZero) {
            
            return nil
        }
        
        let springBehavior = UIAttachmentBehavior(item: item, attachedToAnchor: item.center)
        springBehavior.length = 1
        springBehavior.damping = 1
        springBehavior.frequency = 1
        
        return springBehavior
    }
    
    func jsq_addNewlyVisibleBehaviors(visibleItems: [UICollectionViewLayoutAttributes]) {
        
        let newlyVisibleItems = visibleItems.filter { !self.visibleIndexPaths.contains($0.indexPath) }
        
        for item in newlyVisibleItems {
            
            if let springBehavior = self.jsq_springBehavior(layoutAttributesItem: item) {

                self.dynamicAnimator.addBehavior(springBehavior)
                self.visibleIndexPaths.insert(item.indexPath)
            }
        }
    }
    
    func jsq_removeNoLongerVisibleBehaviors(visibleItemsIndexPath: Set<NSIndexPath>) {
        
        if let behaviors = self.dynamicAnimator.behaviors as? [UIAttachmentBehavior] {
        
            let behaviorsToRemove = behaviors.filter {
                if let layoutAttributes = $0.items.first as? UICollectionViewLayoutAttributes {
                    return !visibleItemsIndexPath.contains(layoutAttributes.indexPath)
                }
                return false
            }
            
            for item in behaviorsToRemove {
                
                self.dynamicAnimator.removeBehavior(item)
                
                if let layoutAttributes = item.items.first as? UICollectionViewLayoutAttributes {
                
                    self.visibleIndexPaths.remove(layoutAttributes.indexPath)
                }
            }
        }
    }
    
    func jsq_adjust(springBehavior: UIAttachmentBehavior, forTouchLocation touchLocation: CGPoint) {
        
        if let item = springBehavior.items.first as? UICollectionViewLayoutAttributes {
            
            var center = item.center
            if !CGPointEqualToPoint(touchLocation, CGPointZero) {
                
                let distanceFromTouch: CGFloat = abs(touchLocation.y - springBehavior.anchorPoint.y)
                let scrollResistance = distanceFromTouch/self.springResistanceFactor
                
                if self.latestDelta < 0 {
                    
                    center.y += max(self.latestDelta, self.latestDelta * scrollResistance)
                }
                else {
                    
                    center.y += min(self.latestDelta, self.latestDelta * scrollResistance)
                }
                item.center = center
            }
        }
    }
}