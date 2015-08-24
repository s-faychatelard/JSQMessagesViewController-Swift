//
//  UIColor.swift
//  JSQMessagesViewController
//
//  Created by Sylvain FAY-CHATELARD on 19/08/2015.
//  Copyright (c) 2015 Dviance. All rights reserved.
//

import UIKit

internal extension UIColor {
    
    class func jsq_messageBubbleGreenColor() -> UIColor {
        
        return UIColor(hue: 130/360, saturation:0.68, brightness:0.84, alpha:1)
    }
    
    class func jsq_messageBubbleBlueColor() -> UIColor {
        
        return UIColor(hue: 210/360, saturation:0.94, brightness:1, alpha:1)
    }
    
    class func jsq_messageBubbleRedColor() -> UIColor {
        
        return UIColor(hue: 0, saturation:0.79, brightness:1, alpha:1)
    }
    
    class func jsq_messageBubbleLightGrayColor() -> UIColor {
        
        return UIColor(hue: 240.0/360.0, saturation:0.02, brightness:0.94, alpha:1)
    }
    
    // MARK: - Utilities
    
    func jsq_colorByDarkeningColorWithValue(value: CGFloat) -> UIColor {
        
        let totalComponents = CGColorGetNumberOfComponents(self.CGColor)
        let isGreyscale = (totalComponents == 2) ? true : false
        
        let oldComponents = CGColorGetComponents(self.CGColor)
        var newComponents: [CGFloat] = []
        
        if isGreyscale {

            newComponents.append(oldComponents[0] - value < 0.0 ? 0.0 : oldComponents[0] - value)
            newComponents.append(oldComponents[0] - value < 0.0 ? 0.0 : oldComponents[0] - value)
            newComponents.append(oldComponents[0] - value < 0.0 ? 0.0 : oldComponents[0] - value)
            newComponents.append(oldComponents[1])
        }
        else {

            newComponents.append(oldComponents[0] - value < 0.0 ? 0.0 : oldComponents[0] - value)
            newComponents.append(oldComponents[1] - value < 0.0 ? 0.0 : oldComponents[1] - value)
            newComponents.append(oldComponents[2] - value < 0.0 ? 0.0 : oldComponents[2] - value)
            newComponents.append(oldComponents[3])
        }
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let newColor = CGColorCreate(colorSpace, newComponents)
        if let retColor = UIColor(CGColor: newColor) {
            return retColor
        }
        
        return self
    }
}