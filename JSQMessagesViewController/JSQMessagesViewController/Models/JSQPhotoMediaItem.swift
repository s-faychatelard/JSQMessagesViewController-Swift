//
//  JSQPhotoMediaItem.swift
//  JSQMessagesViewController
//
//  Created by Sylvain FAY-CHATELARD on 20/08/2015.
//  Copyright (c) 2015 Dviance. All rights reserved.
//

import Foundation

class JSQPhotoMediaItem: JSQMediaItem, JSQMessageMediaData, NSCoding, NSCopying {
    
    private var _image: UIImage?
    var image: UIImage? {
        
        get {
            
            return self._image
        }
        set {
            
            if self._image == newValue {
                
                return
            }
            
            self._image = newValue?.copy() as? UIImage
            self.cachedImageView = nil
        }
    }
    
    private var cachedImageView: UIImageView?
    
    // MARK: - Initialization
    
    required init() {
        
        super.init()
    }

    required init(image: UIImage?) {
        
        super.init(maskAsOutgoing: true)
        
        self.image = image?.copy() as? UIImage
    }

    required init(maskAsOutgoing: Bool) {

        super.init(maskAsOutgoing: maskAsOutgoing)
    }
    
    override var appliesMediaViewMaskAsOutgoing: Bool {
        
        didSet {
            
            self.cachedImageView = nil
        }
    }
    
    override func clearCachedMediaViews() {

        super.clearCachedMediaViews()
        
        self.cachedImageView = nil
    }
    
    // MARK: - JSQMessageMediaData protocol
    
    override var mediaView: UIView? {

        get {
            
            if let cachedImageView = self.cachedImageView {
                
                return self.cachedImageView
            }
            
            if let image = self.image {
                
                let size = self.mediaViewDisplaySize
                let imageView = UIImageView(image: image)
                imageView.frame = CGRectMake(0, 0, size.width, size.height)
                imageView.contentMode = .ScaleAspectFill
                imageView.clipsToBounds = true
                
                JSQMessagesMediaViewBubbleImageMasker.applyBubbleImageMaskToMediaView(imageView, isOutgoing: self.appliesMediaViewMaskAsOutgoing)
                self.cachedImageView = imageView
                
                return self.cachedImageView
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
    
    override var hash:Int {
        
        get {
            
            return super.hash^(self.image?.hash ?? 0)
        }
    }
    
    override var description: String {
        
        get {
            
            return "<\(self.dynamicType): image=\(self.image) appliesMediaViewMaskAsOutgoing=\(self.appliesMediaViewMaskAsOutgoing)>"
        }
    }
    
    // MARK: - NSCoding
    
    required init(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        self.image = aDecoder.decodeObjectForKey("image") as? UIImage
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        
        super.encodeWithCoder(aCoder)
        
        aCoder.encodeObject(self.image, forKey: "image")
    }
    
    // MARK: - NSCopying
    
    override func copyWithZone(zone: NSZone) -> AnyObject {
        
        let copy = self.dynamicType(image: UIImage(CGImage: self.image?.CGImage))
        copy.appliesMediaViewMaskAsOutgoing = self.appliesMediaViewMaskAsOutgoing
        return copy
    }
}