//
//  UIImage.swift
//  JSQMessagesViewController
//
//  Created by Sylvain FAY-CHATELARD on 19/08/2015.
//  Copyright (c) 2015 Dviance. All rights reserved.
//

import UIKit

extension UIImage {
    
    public func jsq_imageMaskedWithColor(maskColor: UIColor) -> UIImage {
        
        let imageRect = CGRectMake(0, 0, self.size.width, self.size.height)
        
        UIGraphicsBeginImageContextWithOptions(imageRect.size, false, self.scale)
        
        let context = UIGraphicsGetCurrentContext()
        CGContextScaleCTM(context, 1, -1)
        CGContextTranslateCTM(context, 0, -imageRect.height)
        
        CGContextClipToMask(context, imageRect, self.CGImage)
        CGContextSetFillColorWithColor(context, maskColor.CGColor)
        CGContextFillRect(context, imageRect)
        
        if let image = UIGraphicsGetImageFromCurrentImageContext() {

            UIGraphicsEndImageContext()
            return image
        }

        UIGraphicsEndImageContext()
        return self
    }
    
    public class func jsq_bubbleImageFromBundle(#name: String) -> UIImage? {
        
        if let bundle = NSBundle.jsq_messagesAssetBundle(),
            let path = bundle.pathForResource(name, ofType: "png", inDirectory: "Images") {
        
            return UIImage(contentsOfFile: path)
        }
        
        return nil
    }
    
    public class func jsq_bubbleRegularImage() -> UIImage? {

        return UIImage.jsq_bubbleImageFromBundle(name: "bubble_regular")
    }
    
    public class func jsq_bubbleRegularTaillessImage() -> UIImage? {
        
        return UIImage.jsq_bubbleImageFromBundle(name: "bubble_tailless")
    }
    
    public class func jsq_bubbleRegularStrokedImage() -> UIImage? {
        
        return UIImage.jsq_bubbleImageFromBundle(name: "bubble_stroked")
    }
    
    public class func jsq_bubbleRegularStrokedTaillessImage() -> UIImage? {
        
        return UIImage.jsq_bubbleImageFromBundle(name: "bubble_stroked_tailless")
    }
    
    public class func jsq_bubbleCompactImage() -> UIImage? {
        
        return UIImage.jsq_bubbleImageFromBundle(name: "bubble_min")
    }
    
    public class func jsq_bubbleCompactTaillessImage() -> UIImage? {
        
        return UIImage.jsq_bubbleImageFromBundle(name: "bubble_min_tailless")
    }
    
    public class func jsq_defaultAccessoryImage() -> UIImage? {
        
        return UIImage.jsq_bubbleImageFromBundle(name: "clip")
    }
    
    public class func jsq_defaultTypingIndicatorImage() -> UIImage? {
        
        return UIImage.jsq_bubbleImageFromBundle(name: "typing")
    }
    
    public class func jsq_defaultPlayImage() -> UIImage? {
        
        return UIImage.jsq_bubbleImageFromBundle(name: "play")
    }
}