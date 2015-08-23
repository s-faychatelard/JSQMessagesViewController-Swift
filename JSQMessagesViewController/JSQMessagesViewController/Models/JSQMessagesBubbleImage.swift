//
//  JSQMessagesBubbleImage.swift
//  JSQMessagesViewController
//
//  Created by Sylvain FAY-CHATELARD on 19/08/2015.
//  Copyright (c) 2015 Dviance. All rights reserved.
//

import Foundation

public class JSQMessagesBubbleImage: NSObject, JSQMessageBubbleImageDataSource, NSCopying {
    
    private(set) public var messageBubbleImage: UIImage
    private(set) public var messageBubbleHighlightedImage: UIImage
    
    public required init(bubbleImage: UIImage, highlightedImage: UIImage) {
        
        self.messageBubbleImage = bubbleImage
        self.messageBubbleHighlightedImage = highlightedImage
    }
    
    // MARK: - NSCopying
    
    public func copyWithZone(zone: NSZone) -> AnyObject {
        
        return self.dynamicType(bubbleImage: UIImage(CGImage: self.messageBubbleImage.CGImage)!, highlightedImage: UIImage(CGImage: self.messageBubbleHighlightedImage.CGImage)!)
    }
}