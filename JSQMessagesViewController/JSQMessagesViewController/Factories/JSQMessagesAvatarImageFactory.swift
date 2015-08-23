//
//  JSQMessagesAvatarImageFactory.swift
//  JSQMessagesViewController
//
//  Created by Sylvain FAY-CHATELARD on 20/08/2015.
//  Copyright (c) 2015 Dviance. All rights reserved.
//

import Foundation

public class JSQMessagesAvatarImageFactory {
    
    // MARK: - Public
    
    public class func avatarImage(#placholder: UIImage, diameter: CGFloat) -> JSQMessagesAvatarImage {
        
        let circlePlaceholderImage = JSQMessagesAvatarImageFactory.jsq_circularImage(placholder, diameter: diameter, highlightedColor: nil)
        return JSQMessagesAvatarImage.avatar(placeholder: circlePlaceholderImage)
    }
    
    public class func avatarImage(#image: UIImage, diameter: CGFloat) -> JSQMessagesAvatarImage {
        
        let avatar = JSQMessagesAvatarImageFactory.circularAvatar(image: image, diameter: diameter)
        let highlightedAvatar = JSQMessagesAvatarImageFactory.circularAvatar(highlightedImage: image, diameter: diameter)
        
        return JSQMessagesAvatarImage(avatarImage: avatar, highlightedImage: highlightedAvatar, placeholderImage: avatar)
    }
    
    public class func circularAvatar(#image: UIImage, diameter: CGFloat) -> UIImage {
        
        return JSQMessagesAvatarImageFactory.jsq_circularImage(image, diameter: diameter, highlightedColor: nil)
    }
    
    public class func circularAvatar(#highlightedImage: UIImage, diameter: CGFloat) -> UIImage {
        
        return JSQMessagesAvatarImageFactory.jsq_circularImage(highlightedImage, diameter: diameter, highlightedColor: UIColor(white: 0.1, alpha: 0.3))
    }
    
    public class func avatarImage(#userInitials: String, backgroundColor: UIColor, textColor: UIColor, font: UIFont, diameter: CGFloat) -> JSQMessagesAvatarImage {
        
        let avatar = JSQMessagesAvatarImageFactory.jsq_image(initials: userInitials, backgroundColor: backgroundColor, textColor: textColor, font: font, diameter: diameter)
        let highlightedAvatar = JSQMessagesAvatarImageFactory.jsq_circularImage(avatar, diameter: diameter, highlightedColor: UIColor(white: 0.1, alpha: 0.3))
        
        return JSQMessagesAvatarImage(avatarImage: avatar, highlightedImage: highlightedAvatar, placeholderImage: avatar)
    }
    
    // MARK: - Private
    
    private class func jsq_image(#initials: String, backgroundColor: UIColor, textColor: UIColor, font: UIFont, diameter: CGFloat) -> UIImage {
        
        let frame = CGRectMake(0, 0, diameter, diameter)
        
        let attributes: [NSObject: AnyObject] = [
            NSFontAttributeName: font,
            NSForegroundColorAttributeName: textColor
        ]
        
        let options = NSStringDrawingOptions.UsesLineFragmentOrigin|NSStringDrawingOptions.UsesFontLeading
        let textFrame = (initials as NSString).boundingRectWithSize(frame.size, options: options, attributes: attributes, context: nil)
        
        let frameMidPoint = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame))
        let textFrameMidPoint = CGPointMake(CGRectGetMidX(textFrame), CGRectGetMidY(textFrame))
        
        let dx = frameMidPoint.x - textFrameMidPoint.x
        let dy = frameMidPoint.y - textFrameMidPoint.y
        let drawPoint = CGPointMake(dx, dy)
        
        UIGraphicsBeginImageContextWithOptions(frame.size, false, UIScreen.mainScreen().scale)
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSetFillColorWithColor(context, backgroundColor.CGColor)
        CGContextFillRect(context, frame)
        (initials as NSString).drawAtPoint(drawPoint, withAttributes: attributes)
        let image = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()
        
        return JSQMessagesAvatarImageFactory.jsq_circularImage(image, diameter: diameter, highlightedColor: nil)
    }
    
    private class func jsq_circularImage(image: UIImage, diameter: CGFloat, highlightedColor: UIColor?) -> UIImage {
        
        let frame = CGRectMake(0, 0, diameter, diameter)
        
        UIGraphicsBeginImageContextWithOptions(frame.size, false, UIScreen.mainScreen().scale)
        let context = UIGraphicsGetCurrentContext()
        
        let imgPath = UIBezierPath(ovalInRect: frame)
        imgPath.addClip()
        image.drawInRect(frame)
        
        if let highlightedColor = highlightedColor {
            
            CGContextSetFillColorWithColor(context, highlightedColor.CGColor)
            CGContextFillEllipseInRect(context, frame)
        }
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return newImage
    }
}