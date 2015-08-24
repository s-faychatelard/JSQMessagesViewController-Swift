//
//  JSQMessagesBubbleImage.swift
//  JSQMessagesViewController
//
//  Created by Sylvain FAY-CHATELARD on 19/08/2015.
//  Copyright (c) 2015 Dviance. All rights reserved.
//

import Foundation

class JSQMessagesBubbleImage: NSObject, JSQMessageBubbleImageDataSource, NSCopying {
    
    private(set) var messageBubbleImage: UIImage
    private(set) var messageBubbleHighlightedImage: UIImage
    
    required init(bubbleImage: UIImage, highlightedImage: UIImage) {
        
        self.messageBubbleImage = bubbleImage
        self.messageBubbleHighlightedImage = highlightedImage
    }
    
    // MARK: - NSCopying
    
    func copyWithZone(zone: NSZone) -> AnyObject {
        
        return self.dynamicType(bubbleImage: UIImage(CGImage: self.messageBubbleImage.CGImage)!, highlightedImage: UIImage(CGImage: self.messageBubbleHighlightedImage.CGImage)!)
    }
}