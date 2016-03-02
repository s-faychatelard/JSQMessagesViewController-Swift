//
//  JSQMediaItem.swift
//  JSQMessagesViewController
//
//  Created by Sylvain FAY-CHATELARD on 19/08/2015.
//  Copyright (c) 2015 Dviance. All rights reserved.
//

import UIKit

public class JSQMediaItem: NSObject, JSQMessageMediaData, NSCoding, NSCopying {

    var cachedPlaceholderView: UIView?
    
    public var appliesMediaViewMaskAsOutgoing: Bool = true {
        
        didSet {
            
            self.cachedPlaceholderView = nil
        }
    }
    
    public override required init() {
        
        super.init()
        
        self.appliesMediaViewMaskAsOutgoing = true
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("didReceiveMemoryWarningNotification:"), name: UIApplicationDidReceiveMemoryWarningNotification, object: nil)
    }
    
    public required init(maskAsOutgoing: Bool) {
    
        super.init()
        
        self.appliesMediaViewMaskAsOutgoing = maskAsOutgoing

        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("didReceiveMemoryWarningNotification:"), name: UIApplicationDidReceiveMemoryWarningNotification, object: nil)
    }
    
    deinit {
        
        NSNotificationCenter.defaultCenter().removeObserver(self)

        self.cachedPlaceholderView = nil
    }
    
    func clearCachedMediaViews() {
        
        self.cachedPlaceholderView = nil
    }
    
    // MARK: - Notifications
    
    func didReceiveMemoryWarningNotification(notification: NSNotification) {
        
        self.clearCachedMediaViews()
    }
    
    // MARK: - JSQMessageMediaData protocol
    
    public var mediaView: UIView? {
        
        get {
            print("Error! required method not implemented in subclass. Need to implement \(__FUNCTION__)")
            abort()
        }
    }
    
    public var mediaViewDisplaySize: CGSize {
        
        get {
            
            if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
                
                return CGSizeMake(315, 225)
            }
            return CGSizeMake(210, 150)
        }
    }
    
    public var mediaPlaceholderView: UIView {
        
        get {
    
            if let cachedPlaceholderView = self.cachedPlaceholderView {
                
                return cachedPlaceholderView
            }
            
            let size = self.mediaViewDisplaySize
            let view = JSQMessagesMediaPlaceholderView.viewWithActivityIndicator()
            view.frame = CGRectMake(0, 0, size.width, size.height)
            JSQMessagesMediaViewBubbleImageMasker.applyBubbleImageMaskToMediaView(view, isOutgoing: self.appliesMediaViewMaskAsOutgoing)
            
            self.cachedPlaceholderView = view
            
            return view
        }
    }
    
    public var mediaHash: Int {
    
        get {
        
            return self.hash
        }
    }
    
    // MARK: - NSObject
    
    public override func isEqual(object: AnyObject?) -> Bool {
        
        if !object!.isKindOfClass(self.dynamicType) {
            
            return false
        }
        
        if let item = object as? JSQMediaItem {
            
            return self.appliesMediaViewMaskAsOutgoing == item.appliesMediaViewMaskAsOutgoing
        }
        
        return false
    }
    
    public override var hash:Int {

        get {

            return NSNumber(bool: self.appliesMediaViewMaskAsOutgoing).hash
        }
    }
    
    public override var description: String {
        
        get {
            
            return "<\(self.dynamicType): appliesMediaViewMaskAsOutgoing=\(self.appliesMediaViewMaskAsOutgoing)>"
        }
    }
    
    func debugQuickLookObject() -> AnyObject? {
        
        return self.mediaPlaceholderView
    }
    
    // MARK: - NSCoding
    
    public required init(coder aDecoder: NSCoder) {
        
        super.init()
        
        self.appliesMediaViewMaskAsOutgoing = aDecoder.decodeBoolForKey("appliesMediaViewMaskAsOutgoing")
    }
    
    public func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeBool(self.appliesMediaViewMaskAsOutgoing, forKey: "appliesMediaViewMaskAsOutgoing")
    }
    
    // MARK: - NSCopying
    
    public func copyWithZone(zone: NSZone) -> AnyObject {
        
        return self.dynamicType.init(maskAsOutgoing: self.appliesMediaViewMaskAsOutgoing)
    }
}