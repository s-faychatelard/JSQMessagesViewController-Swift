//
//  JSQMessagesBubbleImageFactory.swift
//  JSQMessagesViewController
//
//  Created by Sylvain FAY-CHATELARD on 19/08/2015.
//  Copyright (c) 2015 Dviance. All rights reserved.
//

import Foundation

public class JSQMessagesBubbleImageFactory {
    
    private let bubbleImage: UIImage
    private var capInsets: UIEdgeInsets
    
    public convenience init() {
        
        self.init(bubbleImage: UIImage.jsq_bubbleCompactImage()!, capInsets: UIEdgeInsetsZero)
    }
    
    public init(bubbleImage: UIImage, capInsets: UIEdgeInsets) {
    
        self.bubbleImage = bubbleImage
        self.capInsets = capInsets
        
        if UIEdgeInsetsEqualToEdgeInsets(capInsets, UIEdgeInsetsZero) {
            
            self.capInsets = self.jsq_centerPointEdgeInsetsForImageSize(bubbleImage.size)
        }
        else {
            
            self.capInsets = capInsets
        }
    }
    
    // MARK: - Public
    
    public func outgoingMessagesBubbleImage(#color: UIColor) -> JSQMessagesBubbleImage {

        return self.jsq_messagesBubbleImage(color: color, flippedForIncoming: false)
    }
    
    public func incomingMessagesBubbleImage(#color: UIColor) -> JSQMessagesBubbleImage {
        
        return self.jsq_messagesBubbleImage(color: color, flippedForIncoming: true)
    }
    
    // MARK: - Private
    
    func jsq_centerPointEdgeInsetsForImageSize(bubbleImageSize: CGSize) -> UIEdgeInsets {
        
        let center = CGPointMake(bubbleImageSize.width/2, bubbleImageSize.height/2)
        return UIEdgeInsetsMake(center.y, center.x, center.y, center.x)
    }
    
    func jsq_messagesBubbleImage(#color: UIColor, flippedForIncoming: Bool) -> JSQMessagesBubbleImage {
        
        var normalBubble = self.bubbleImage.jsq_imageMaskedWithColor(color)
        var highlightedBubble = self.bubbleImage.jsq_imageMaskedWithColor(color.jsq_colorByDarkeningColorWithValue(0.12))
        
        if flippedForIncoming {
            
            normalBubble = self.jsq_horizontallyFlippedImage(normalBubble)
            highlightedBubble = self.jsq_horizontallyFlippedImage(highlightedBubble)
        }
        
        normalBubble = self.jsq_stretchableImage(normalBubble, capInsets: self.capInsets)
        highlightedBubble = self.jsq_stretchableImage(highlightedBubble, capInsets: self.capInsets)
        
        return JSQMessagesBubbleImage(bubbleImage: normalBubble, highlightedImage: highlightedBubble)
    }
    
    func jsq_horizontallyFlippedImage(image: UIImage) -> UIImage {
        
        if let image = UIImage(CGImage: image.CGImage, scale: image.scale, orientation: .UpMirrored) {
            
            return image
        }
        
        return image
    }
    
    func jsq_stretchableImage(image: UIImage, capInsets: UIEdgeInsets) -> UIImage {
        
        return image.resizableImageWithCapInsets(capInsets, resizingMode: .Stretch)
    }
}