//
//  JSQMessagesMediaViewBubbleImageMasker.swift
//  JSQMessagesViewController
//
//  Created by Sylvain FAY-CHATELARD on 19/08/2015.
//  Copyright (c) 2015 Dviance. All rights reserved.
//

import Foundation

class JSQMessagesMediaViewBubbleImageMasker {
    
    private(set) var bubbleImageFactory: JSQMessagesBubbleImageFactory
    
    convenience init() {
        
        self.init(bubbleImageFactory: JSQMessagesBubbleImageFactory())
    }
    
    init(bubbleImageFactory: JSQMessagesBubbleImageFactory) {
        
        self.bubbleImageFactory = bubbleImageFactory
    }
    
    // MARK: - View masking
    
    func applyOutgoingBubbleImageMask(#mediaView: UIView) {
        
        let bubbleImageData = self.bubbleImageFactory.outgoingMessagesBubbleImage(color: UIColor.whiteColor())
        self.jsq_maskView(mediaView, image: bubbleImageData.messageBubbleImage)
    }
    
    func applyIncomingBubbleImageMask(#mediaView: UIView) {
        
        let bubbleImageData = self.bubbleImageFactory.incomingMessagesBubbleImage(color: UIColor.whiteColor())
        self.jsq_maskView(mediaView, image: bubbleImageData.messageBubbleImage)
    }
    
    class func applyBubbleImageMaskToMediaView(mediaView: UIView, isOutgoing: Bool) {
        
        let masker = JSQMessagesMediaViewBubbleImageMasker()
        
        if isOutgoing {
            masker.applyOutgoingBubbleImageMask(mediaView: mediaView)
        }
        else {
            masker.applyIncomingBubbleImageMask(mediaView: mediaView)
        }
    }
    
    // MARK: - Private
    
    private func jsq_maskView(view: UIView, image: UIImage) {
        
        let imageViewMask = UIImageView(image: image)
        imageViewMask.frame = CGRectInset(view.frame, 2, 2)
        
        view.layer.mask = imageViewMask.layer
    }
}