//
//  JSQMessagesCollectionViewDelegateFlowLayout.swift
//  JSQMessagesViewController
//
//  Created by Sylvain FAY-CHATELARD on 20/08/2015.
//  Copyright (c) 2015 Dviance. All rights reserved.
//

import Foundation

@objc protocol JSQMessagesCollectionViewDelegateFlowLayout: UICollectionViewDelegateFlowLayout {

    optional func collectionView(collectionView: JSQMessagesCollectionView, layout: JSQMessagesCollectionViewFlowLayout, heightForCellTopLabelAtIndexPath indexPath: NSIndexPath) -> CGFloat
    optional func collectionView(collectionView: JSQMessagesCollectionView, layout: JSQMessagesCollectionViewFlowLayout, heightForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath) -> CGFloat
    optional func collectionView(collectionView: JSQMessagesCollectionView, layout: JSQMessagesCollectionViewFlowLayout, heightForCellBottomLabelAtIndexPath indexPath: NSIndexPath) -> CGFloat
    optional func collectionView(collectionView: JSQMessagesCollectionView, didTapAvatarImageView imageView: UIImageView, atIndexPath indexPath: NSIndexPath)
    optional func collectionView(collectionView: JSQMessagesCollectionView, didTapMessageBubbleAtIndexPath indexPath: NSIndexPath)
    optional func collectionView(collectionView: JSQMessagesCollectionView, didTapCellAtIndexPath indexPath: NSIndexPath, touchLocation: CGPoint)
    optional func collectionView(collectionView: JSQMessagesCollectionView, header: JSQMessagesLoadEarlierHeaderView, didTapLoadEarlierMessagesButton button: UIButton?)
}