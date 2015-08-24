//
//  JSQMessagesCollectionViewLayoutAttributes.swift
//  JSQMessagesViewController
//
//  Created by Sylvain FAY-CHATELARD on 20/08/2015.
//  Copyright (c) 2015 Dviance. All rights reserved.
//

import UIKit

class JSQMessagesCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes, NSCopying {
    
    var messageBubbleFont: UIFont = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
    var messageBubbleContainerViewWidth: CGFloat = 0
    var textViewTextContainerInsets: UIEdgeInsets = UIEdgeInsetsZero
    var textViewFrameInsets: UIEdgeInsets = UIEdgeInsetsZero
    var incomingAvatarViewSize: CGSize = CGSizeZero
    var outgoingAvatarViewSize: CGSize = CGSizeZero
    var cellTopLabelHeight: CGFloat = 0
    var messageBubbleTopLabelHeight: CGFloat = 0
    var cellBottomLabelHeight: CGFloat = 0
    
    // MARK: - NSObject
    
    override func isEqual(object: AnyObject?) -> Bool {
        
        if !object!.isKindOfClass(self.dynamicType) {
            
            return false
        }
        
        if self.representedElementCategory == .Cell {
            
            if let layoutAttributes = object as? JSQMessagesCollectionViewLayoutAttributes {
                
                if !layoutAttributes.messageBubbleFont.isEqual(self.messageBubbleFont)
                    || !UIEdgeInsetsEqualToEdgeInsets(layoutAttributes.textViewFrameInsets, self.textViewFrameInsets)
                    || !UIEdgeInsetsEqualToEdgeInsets(layoutAttributes.textViewTextContainerInsets, self.textViewTextContainerInsets)
                    || !CGSizeEqualToSize(layoutAttributes.incomingAvatarViewSize, self.incomingAvatarViewSize)
                    || !CGSizeEqualToSize(layoutAttributes.outgoingAvatarViewSize, self.outgoingAvatarViewSize)
                    || layoutAttributes.messageBubbleContainerViewWidth != self.messageBubbleContainerViewWidth
                    || layoutAttributes.cellTopLabelHeight != self.cellTopLabelHeight
                    || layoutAttributes.messageBubbleTopLabelHeight != self.messageBubbleTopLabelHeight
                    || layoutAttributes.cellBottomLabelHeight != self.cellBottomLabelHeight {
                            
                    return false
                }
            }
        }
        
        return super.isEqual(object)
    }
    
    override var hash:Int {
        
        get {
            
            return self.indexPath.hash
        }
    }
    
    // MARK: - NSCopying
    
    override func copyWithZone(zone: NSZone) -> AnyObject {
        
        var copy: AnyObject = super.copyWithZone(zone)
        
        if copy.representedElementCategory != .Cell {
            
            return copy
        }
        
        if let copy = copy as? JSQMessagesCollectionViewLayoutAttributes {
        
            copy.messageBubbleFont = self.messageBubbleFont
            copy.messageBubbleContainerViewWidth = self.messageBubbleContainerViewWidth
            copy.textViewFrameInsets = self.textViewFrameInsets
            copy.textViewTextContainerInsets = self.textViewTextContainerInsets
            copy.incomingAvatarViewSize = self.incomingAvatarViewSize
            copy.outgoingAvatarViewSize = self.outgoingAvatarViewSize
            copy.cellTopLabelHeight = self.cellTopLabelHeight
            copy.messageBubbleTopLabelHeight = self.messageBubbleTopLabelHeight
            copy.cellBottomLabelHeight = self.cellBottomLabelHeight
        }
        
        return copy
    }
}