//
//  DemoMessagesViewController.swift
//  JSQMessagesViewControllerTest
//
//  Created by Sylvain FAY-CHATELARD on 21/08/2015.
//  Copyright (c) 2015 Dviance. All rights reserved.
//

import UIKit
import MapKit
import JSQSystemSoundPlayer
import JSQMessagesViewController

protocol JSQDemoViewControllerDelegate {
    
    func didDismissJSQDemoViewController(vc: DemoMessagesViewController)
}

class DemoMessagesViewController: JSQMessagesViewController, UIActionSheetDelegate {

    var delegateModal: JSQDemoViewControllerDelegate?
    
    var demoModel: DemoModelData = DemoModelData()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = "JSQMessages"
        
        self.senderID = kJSQDemoAvatarIdSquires
        self.senderDisplayName = kJSQDemoAvatarDisplayNameSquires
        
        if !NSUserDefaults.incomingAvatarSetting() {
            
            self.collectionView.messagesCollectionViewLayout.incomingAvatarViewSize = CGSizeZero
        }
        if !NSUserDefaults.outgoingAvatarSetting() {
            
            self.collectionView.messagesCollectionViewLayout.outgoingAvatarViewSize = CGSizeZero
        }
        
        self.showLoadEarlierMessagesHeader = true
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.jsq_defaultTypingIndicatorImage(), style: .Plain, target: self, action: Selector("receivedMessagePressed:"))
        
        JSQMessagesCollectionViewCell.registerMenuAction(Selector("customAction:"))
        UIMenuController.sharedMenuController().menuItems = [UIMenuItem(title: "Custom Action", action: Selector("customAction:"))]
        
        /**
        *  Customize your toolbar buttons
        *
        *  self.inputToolbar.contentView.leftBarButtonItem = custom button or nil to remove
        *  self.inputToolbar.contentView.rightBarButtonItem = custom button or nil to remove
        */
        
        /**
        *  Set a maximum height for the input toolbar
        *
        *  self.inputToolbar.maximumHeight = 150
        */
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        if self.delegateModal != nil {
            
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Stop, target: self, action: Selector("closePressed:"))
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
        self.collectionView.messagesCollectionViewLayout.springinessEnabled = NSUserDefaults.springinessSetting()
    }
    
    // MARK: - Testing
    
    func pushMainViewController() {
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let nc = sb.instantiateInitialViewController() as! UINavigationController
        self.navigationController?.pushViewController(nc.topViewController, animated: true)
    }
    
    // MARK: - Actions
    
    func receivedMessagePressed(sender: UIBarButtonItem) {
        
        /**
        *  DEMO ONLY
        *
        *  The following is simply to simulate received messages for the demo.
        *  Do not actually do this.
        */
    
        self.showTypingIndicator = !self.showTypingIndicator
        
        self.scrollToBottom(animated: true)
        
        var copyMessage = self.demoModel.messages.last?.copy() as? JSQMessage
        if copyMessage == nil {
            
            copyMessage = JSQMessage.message(senderId: kJSQDemoAvatarIdJobs, senderDisplayName: kJSQDemoAvatarDisplayNameJobs, text: "First received!")
        }
        
        if let copyMessage = copyMessage {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1*NSEC_PER_SEC)), dispatch_get_main_queue()) {
                
                var userIds = self.demoModel.users.keys.array
                userIds.removeAtIndex(find(userIds, self.senderID)!)
                let randomUserId = userIds[Int(arc4random_uniform(UInt32(userIds.count)))]
                
                var newMessage: JSQMessage?
                var newMediaData: JSQMessageMediaData?
                var newMediaAttachmentCopy: AnyObject?
                
                if copyMessage.isMediaMessage {
                    
                    let copyMediaData = copyMessage.media
                    
                    if let copyMediaData = copyMediaData as? JSQPhotoMediaItem {
                        
                        let photoItemCopy = copyMediaData.copy() as! JSQPhotoMediaItem
                        photoItemCopy.appliesMediaViewMaskAsOutgoing = false
                        newMediaAttachmentCopy = UIImage(CGImage: photoItemCopy.image!.CGImage)
                        
                        /**
                        *  Set image to nil to simulate "downloading" the image
                        *  and show the placeholder view
                        */
                        photoItemCopy.image = nil
                        
                        newMediaData = photoItemCopy
                    }
                    else if let copyMediaData = copyMediaData as? JSQLocationMediaItem {
                        
                        let locationItemCopy = copyMediaData.copy() as! JSQLocationMediaItem
                        locationItemCopy.appliesMediaViewMaskAsOutgoing = false
                        newMediaAttachmentCopy = locationItemCopy.location!.copy() as! CLLocation
                        
                        /**
                        *  Set location to nil to simulate "downloading" the location data
                        */
                        locationItemCopy.location = nil
                        
                        newMediaData = locationItemCopy
                    }
                    else if let copyMediaData = copyMediaData as? JSQVideoMediaItem {
                        
                        let videoItemCopy = copyMediaData.copy() as! JSQVideoMediaItem
                        videoItemCopy.appliesMediaViewMaskAsOutgoing = false
                        newMediaAttachmentCopy = videoItemCopy.fileURL!.copy() as! NSURL
                        
                        /**
                        *  Set location to nil to simulate "downloading" the location data
                        */
                        videoItemCopy.fileURL = nil
                        
                        newMediaData = videoItemCopy
                    }
                    else {

                        println("\(__FUNCTION__) error: unrecognized media item")
                    }
                    
                    newMessage = JSQMessage.message(senderId: randomUserId, senderDisplayName: self.demoModel.users[randomUserId]!, media: newMediaData!)
                }
                else {
                    
                    newMessage = JSQMessage.message(senderId: randomUserId, senderDisplayName: self.demoModel.users[randomUserId]!, text: copyMessage.text!)
                }
                
                /**
                *  Upon receiving a message, you should:
                *
                *  1. Play sound (optional)
                *  2. Add new id<JSQMessageData> object to your data source
                *  3. Call `finishReceivingMessage`
                */
                JSQSystemSoundPlayer.jsq_playMessageReceivedSound()
                self.demoModel.messages.append(newMessage!)
                self.finishReceivingMessage()
                
                if newMessage!.isMediaMessage {
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2*NSEC_PER_SEC)), dispatch_get_main_queue()) {
                        
                        if let newMediaData = newMediaData as? JSQPhotoMediaItem {
                            
                            newMediaData.image = newMediaAttachmentCopy as? UIImage
                            self.collectionView.reloadData()
                        }
                        else if let newMediaData = newMediaData as? JSQLocationMediaItem {
                            
                            newMediaData.set(newMediaAttachmentCopy as? CLLocation, completion: { () -> Void in
                                
                                self.collectionView.reloadData()
                            })
                        }
                        else if let newMediaData = newMediaData as? JSQVideoMediaItem {
                            
                            newMediaData.fileURL = newMediaAttachmentCopy as? NSURL
                            newMediaData.isReadyToPlay = true
                            self.collectionView.reloadData()
                        }
                        else {
                            
                            println("\(__FUNCTION__) error: unrecognized media item")
                        }
                    }
                }
            }
        }
    }

    func closePressed(sender: UIBarButtonItem) {
        
        self.delegateModal?.didDismissJSQDemoViewController(self)
    }
    
    // MARK: - JSQMessagesViewController method overrides
    
    override func didPressSendButton(button: UIButton, withMessageText text: String, senderId: String, senderDisplayName: String, date: NSDate) {
        
        /**
        *  Sending a message. Your implementation of this method should do *at least* the following:
        *
        *  1. Play sound (optional)
        *  2. Add new id<JSQMessageData> object to your data source
        *  3. Call `finishSendingMessage`
        */
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        
        let message = JSQMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: date, text: text)
        
        self.demoModel.messages.append(message)
        
        self.finishSendingMessage()
    }
    
    override func didPressAccessoryButton(sender: UIButton) {
        
        let sheet = UIActionSheet(title: "Media messages", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Send photo", "Send location", "Send video")
        sheet.showFromToolbar(self.inputToolbar)
    }
    
    func actionSheet(actionSheet: UIActionSheet, didDismissWithButtonIndex buttonIndex: Int) {
        
        if buttonIndex == actionSheet.cancelButtonIndex {
            
            return
        }
        
        switch buttonIndex {
            case 1:
                self.demoModel.addPhotoMediaMessage()
            case 2:
                weak var weakCollectionView = self.collectionView
                self.demoModel.addLocationMediaMessageCompletion({ () -> Void in
                    
                    weakCollectionView?.reloadData()
                })
            case 3:
                self.demoModel.addVideoMediaMessage()
            default:
                break
        }
        
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        
        self.finishSendingMessage()
    }
    
    // MARK: - JSQMessages CollectionView DataSource
    
    override func collectionView(collectionView: JSQMessagesCollectionView, messageDataForItemAtIndexPath indexPath: NSIndexPath) -> JSQMessageData {
        
        return self.demoModel.messages[indexPath.item]
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath) -> JSQMessageBubbleImageDataSource {
        
        let message = self.demoModel.messages[indexPath.item]
        
        if message.senderID == self.senderID {
            
            return self.demoModel.outgoingBubbleImageData
        }
        
        return self.demoModel.incomingBubbleImageData
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath) -> JSQMessageAvatarImageDataSource? {
        
        let message = self.demoModel.messages[indexPath.item]
        
        if message.senderID == self.senderID {
            
            if !NSUserDefaults.outgoingAvatarSetting() {
                
                return nil
            }
        }
        else {
            
            if !NSUserDefaults.incomingAvatarSetting() {
                
                return nil
            }
        }
        
        return self.demoModel.avatars[message.senderID]!
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView, attributedTextForCellTopLabelAtIndexPath indexPath: NSIndexPath) -> NSAttributedString? {
        
        /**
        *  This logic should be consistent with what you return from `heightForCellTopLabelAtIndexPath:`
        *  The other label text delegate methods should follow a similar pattern.
        *
        *  Show a timestamp for every 3rd message
        */
        if indexPath.item%3 == 0 {
            
            let message = self.demoModel.messages[indexPath.item]
            
            return JSQMessagesTimestampFormatter.sharedFormatter.attributedTimestamp(message.date)
        }
        
        return nil
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView, attributedTextForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath) -> NSAttributedString? {
        
        let message = self.demoModel.messages[indexPath.item]
        
        /**
        *  iOS7-style sender name labels
        */
        if message.senderID == self.senderID {
            
            return nil
        }
        
        if indexPath.item - 1 > 0 {
            
            let previousMessage = self.demoModel.messages[indexPath.item - 1]
            if previousMessage.senderID == message.senderID {
                
                return nil
            }
        }
        
        /**
        *  Don't specify attributes to use the defaults.
        */
        return NSAttributedString(string: message.senderDisplayName)
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView, attributedTextForCellBottomLabelAtIndexPath indexPath: NSIndexPath) -> NSAttributedString? {
        
        return nil
    }
    
    // MARK: - UICollectionView DataSource
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return self.demoModel.messages.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as! JSQMessagesCollectionViewCell
        
        /**
        *  Configure almost *anything* on the cell
        *
        *  Text colors, label text, label colors, etc.
        *
        *
        *  DO NOT set `cell.textView.font` !
        *  Instead, you need to set `self.collectionView.collectionViewLayout.messageBubbleFont` to the font you want in `viewDidLoad`
        *
        *
        *  DO NOT manipulate cell layout information!
        *  Instead, override the properties you want on `self.collectionView.collectionViewLayout` from `viewDidLoad`
        */
        
        let msg = self.demoModel.messages[indexPath.item]
        
        if !msg.isMediaMessage {
            
            if msg.senderID == self.senderID {
                
                cell.textView?.textColor = UIColor.blackColor()
            }
            else {
                
                cell.textView?.textColor = UIColor.whiteColor()
            }
            
            cell.textView?.linkTextAttributes = [
                NSForegroundColorAttributeName: cell.textView!.textColor,
                NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue
            ]
        }
        
        return cell
    }
    
    // MARK: - UICollectionView Delegate
    
    // MARK: - Custom menu items
    
    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject!) -> Bool {
        
        if action == Selector("customAction:") {
            
            return true
        }
        
        return super.collectionView(collectionView, canPerformAction: action, forItemAtIndexPath: indexPath, withSender: sender)
    }
    
    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject!) {
        
        if action == Selector("customAction:") {
            
            self.customAction(sender)
            return
        }
        
        super.collectionView(collectionView, performAction: action, forItemAtIndexPath: indexPath, withSender: sender)
    }
    
    func customAction(sender: AnyObject?) {
        
        println("Custom action received! Sender: \(sender)")
        
        UIAlertView(title: "Custom Action", message: nil, delegate: nil, cancelButtonTitle: "OK").show()
    }
    
    // MARK: - JSQMessages collection view flow layout delegate
    
    // MARK: - Adjusting cell label heights
    
    override func collectionView(collectionView: JSQMessagesCollectionView, layout: JSQMessagesCollectionViewFlowLayout, heightForCellTopLabelAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        /**
        *  Each label in a cell has a `height` delegate method that corresponds to its text dataSource method
        */
        
        /**
        *  This logic should be consistent with what you return from `attributedTextForCellTopLabelAtIndexPath:`
        *  The other label height delegate methods should follow similarly
        *
        *  Show a timestamp for every 3rd message
        */
        if indexPath.item % 3 == 0 {

            return kJSQMessagesCollectionViewCellLabelHeightDefault
        }
        
        return 0
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView, layout: JSQMessagesCollectionViewFlowLayout, heightForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        
        /**
        *  iOS7-style sender name labels
        */
        let currentMessage = self.demoModel.messages[indexPath.item]
        if currentMessage.senderID == self.senderID {
            
            return 0
        }
        
        if indexPath.item - 1 > 0 {
            
            let previousMessage = self.demoModel.messages[indexPath.item - 1]
            if previousMessage.senderID == currentMessage.senderID {
                
                return 0
            }
        }

        return kJSQMessagesCollectionViewCellLabelHeightDefault
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView, layout: JSQMessagesCollectionViewFlowLayout, heightForCellBottomLabelAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 0
    }
    
    // MARK: - Responding to collection view tap events
    
    func collectionView(collectionView: JSQMessagesCollectionView, header: JSQMessagesLoadEarlierHeaderView, didTapLoadEarlierMessagesButton button: UIButton?) {
        
        println("Load earlier messages!")
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView, didTapAvatarImageView imageView: UIImageView, atIndexPath indexPath: NSIndexPath) {
        
        println("Tapped avatar!")
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView, didTapMessageBubbleAtIndexPath indexPath: NSIndexPath) {
        
        println("Tapped message bubble!")
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView, didTapCellAtIndexPath indexPath: NSIndexPath, touchLocation: CGPoint) {
        
        println("Tapped cell at \(NSStringFromCGPoint(touchLocation))!")
    }    
}

