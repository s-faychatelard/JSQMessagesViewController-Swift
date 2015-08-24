//
//  JSQVideoMediaItem.swift
//  JSQMessagesViewController
//
//  Created by Sylvain FAY-CHATELARD on 20/08/2015.
//  Copyright (c) 2015 Dviance. All rights reserved.
//

import Foundation

class JSQVideoMediaItem: JSQMediaItem, JSQMessageMediaData, NSCoding, NSCopying {
    
    var fileURL: NSURL? {
        
        didSet {
            
            self.cachedVideoImageView = nil
        }
    }
    
    var isReadyToPlay: Bool = false {
        
        didSet {
            
            self.cachedVideoImageView = nil
        }
    }
    
    private var cachedVideoImageView: UIImageView?
    
    // MARK: - Initialization
    
    required init() {
        
        super.init()
    }
    
    required init(fileURL: NSURL?, isReadyToPlay: Bool) {
        
        self.fileURL = fileURL
        self.isReadyToPlay = isReadyToPlay
        self.cachedVideoImageView = nil

        super.init()
    }
    
    required init(maskAsOutgoing: Bool) {
        
        super.init(maskAsOutgoing: maskAsOutgoing)
    }
    
    override var appliesMediaViewMaskAsOutgoing: Bool {
        
        didSet {
            
            self.cachedVideoImageView = nil
        }
    }
    
    override func clearCachedMediaViews() {
        
        super.clearCachedMediaViews()
        
        self.cachedVideoImageView = nil
    }
    
    // MARK: - JSQMessageMediaData protocol
    
    override var mediaView: UIView? {
        
        get {
            
            if !self.isReadyToPlay {
                
                return nil
            }

            if let fileURL = self.fileURL {
                
                if let cachedVideoImageView = self.cachedVideoImageView {
                    
                    return self.cachedVideoImageView
                }
                
                let size = self.mediaViewDisplaySize
                let playIcon = UIImage.jsq_defaultPlayImage()?.jsq_imageMaskedWithColor(UIColor.lightGrayColor())
                let imageView = UIImageView(image: playIcon)
                imageView.frame = CGRectMake(0, 0, size.width, size.height)
                imageView.contentMode = .Center
                imageView.clipsToBounds = true
                
                JSQMessagesMediaViewBubbleImageMasker.applyBubbleImageMaskToMediaView(imageView, isOutgoing: self.appliesMediaViewMaskAsOutgoing)
                self.cachedVideoImageView = imageView
                
                return self.cachedVideoImageView
            }
            
            return nil
        }
    }
    
    override var mediaHash: Int {
        
        get {
            
            return self.hash
        }
    }
    
    // MARK: - NSObject
    
    override func isEqual(object: AnyObject?) -> Bool {
        
        if !super.isEqual(object) {
            
            return false
        }
        
        if let videoItem = object as? JSQVideoMediaItem {
            
            return self.fileURL == videoItem.fileURL && self.isReadyToPlay == videoItem.isReadyToPlay
        }
        
        return false
    }
    
    override var hash:Int {
        
        get {
            
            return super.hash^(self.fileURL?.hash ?? 0)
        }
    }
    
    override var description: String {
        
        get {
            
            return "<\(self.dynamicType):  fileURL=\(self.fileURL), isReadyToPlay=\(self.isReadyToPlay), appliesMediaViewMaskAsOutgoing=\(self.appliesMediaViewMaskAsOutgoing)>"
        }
    }
    
    // MARK: - NSCoding
    
    required init(coder aDecoder: NSCoder) {
        
        self.fileURL = aDecoder.decodeObjectForKey("fileURL") as? NSURL
        self.isReadyToPlay = aDecoder.decodeBoolForKey("isReadyToPlay")
        
        super.init(coder: aDecoder)
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        
        super.encodeWithCoder(aCoder)
        
        aCoder.encodeObject(self.fileURL, forKey: "fileURL")
        aCoder.encodeBool(self.isReadyToPlay, forKey: "isReadyToPlay")
    }
    
    // MARK: - NSCopying
    
    override func copyWithZone(zone: NSZone) -> AnyObject {
        
        let copy = self.dynamicType(fileURL: self.fileURL, isReadyToPlay: self.isReadyToPlay)
        copy.appliesMediaViewMaskAsOutgoing = self.appliesMediaViewMaskAsOutgoing
        return copy
    }
}