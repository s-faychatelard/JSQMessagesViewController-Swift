//
//  JSQMessagesAvatarImage.swift
//  JSQMessagesViewController
//
//  Created by Sylvain FAY-CHATELARD on 20/08/2015.
//  Copyright (c) 2015 Dviance. All rights reserved.
//

import Foundation

public class JSQMessagesAvatarImage: NSObject, JSQMessageAvatarImageDataSource, NSCopying {
    
    public var avatarImage: UIImage?
    public var avatarHighlightedImage: UIImage?
    private(set) public var avatarPlaceholderImage: UIImage
    
    public required init(avatarImage: UIImage?, highlightedImage: UIImage?, placeholderImage: UIImage) {
        
        self.avatarImage = avatarImage
        self.avatarHighlightedImage = highlightedImage
        self.avatarPlaceholderImage = placeholderImage
        
        super.init()
    }
    
    public class func avatar(#image: UIImage) -> JSQMessagesAvatarImage {
        
        return JSQMessagesAvatarImage(avatarImage: image, highlightedImage: image, placeholderImage: image)
    }
    
    public class func avatar(#placeholder: UIImage) -> JSQMessagesAvatarImage {
        
        return JSQMessagesAvatarImage(avatarImage: nil, highlightedImage: nil, placeholderImage: placeholder)
    }
    
    // MARK: - NSObject
    
    public override var description: String {
        
        get {
            
            return "<\(self.dynamicType): avatarImage=\(self.avatarImage), avatarHighlightedImage=\(self.avatarHighlightedImage), avatarPlaceholderImage=\(self.avatarPlaceholderImage)>"
        }
    }
    
    func debugQuickLookObject() -> AnyObject? {
        
        return UIImageView(image: self.avatarImage != nil ? self.avatarImage : self.avatarPlaceholderImage)
    }
    
    // MARK: - NSCopying
    
    public func copyWithZone(zone: NSZone) -> AnyObject {
     
        return self.dynamicType(avatarImage: UIImage(CGImage: self.avatarImage?.CGImage), highlightedImage: UIImage(CGImage: self.avatarHighlightedImage?.CGImage), placeholderImage: UIImage(CGImage: self.avatarPlaceholderImage.CGImage)!)
    }
}