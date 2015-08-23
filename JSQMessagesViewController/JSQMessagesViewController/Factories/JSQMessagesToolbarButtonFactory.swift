//
//  JSQMessagesToolbarButtonFactory.swift
//  JSQMessagesViewController
//
//  Created by Sylvain FAY-CHATELARD on 20/08/2015.
//  Copyright (c) 2015 Dviance. All rights reserved.
//

import Foundation

public class JSQMessagesToolbarButtonFactory {
    
    public class func defaultAccessoryButtonItem() -> UIButton {
    
        let accessoryImage = UIImage.jsq_defaultAccessoryImage()!
        let normalImage = accessoryImage.jsq_imageMaskedWithColor(UIColor.lightGrayColor())
        let highlightedImage = accessoryImage.jsq_imageMaskedWithColor(UIColor.darkGrayColor())
        
        let accessoryButton = UIButton(frame: CGRectMake(0, 0, accessoryImage.size.width, 32))
        accessoryButton.setImage(normalImage, forState: .Normal)
        accessoryButton.setImage(highlightedImage, forState: .Highlighted)
        
        accessoryButton.contentMode = .ScaleAspectFit
        accessoryButton.backgroundColor = UIColor.clearColor()
        accessoryButton.tintColor = UIColor.lightGrayColor()
        
        return accessoryButton
    }
    
    public class func defaultSendButtonItem() -> UIButton {
    
        let sendTitle = NSBundle.jsq_localizedStringForKey("send")
        
        let sendButton = UIButton(frame: CGRectZero)
        sendButton.setTitle(sendTitle, forState: .Normal)
        sendButton.setTitleColor(UIColor.jsq_messageBubbleBlueColor(), forState: .Normal)
        sendButton.setTitleColor(UIColor.jsq_messageBubbleBlueColor().jsq_colorByDarkeningColorWithValue(0.1), forState: .Highlighted)
        sendButton.setTitleColor(UIColor.lightGrayColor(), forState: .Disabled)
        
        sendButton.titleLabel?.font = UIFont.boldSystemFontOfSize(17)
        sendButton.titleLabel?.adjustsFontSizeToFitWidth = true
        sendButton.titleLabel?.minimumScaleFactor = 0.85
        sendButton.contentMode = .Center
        sendButton.backgroundColor = UIColor.clearColor()
        sendButton.tintColor = UIColor.jsq_messageBubbleBlueColor()
        
        let maxHeigth: CGFloat = 32
        let options: NSStringDrawingOptions = NSStringDrawingOptions.UsesLineFragmentOrigin|NSStringDrawingOptions.UsesFontLeading
        let attributes: [NSObject : AnyObject] = sendButton.titleLabel?.font != nil ? [ NSFontAttributeName: sendButton.titleLabel!.font!] : [:]
        
        let sendTitleRect = (sendTitle as NSString).boundingRectWithSize(CGSizeMake(CGFloat.max, maxHeigth), options: options, attributes: attributes, context: nil)
        
        return sendButton
    }
}