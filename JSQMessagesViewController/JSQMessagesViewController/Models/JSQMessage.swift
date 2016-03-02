//
//  JSQMessage.swift
//  JSQMessagesViewController
//
//  Created by Sylvain FAY-CHATELARD on 19/08/2015.
//  Copyright (c) 2015 Dviance. All rights reserved.
//

import Foundation

public class JSQMessage: NSObject, JSQMessageData, NSCoding, NSCopying {
    
    private(set) public var senderID: String
    private(set) public var senderDisplayName: String
    private(set) public var date: NSDate
    
    private(set) public var isMediaMessage: Bool
    public var messageHash: Int {
        
        get {
            
            return self.hash
        }
    }
    
    private(set) public var text: String?
    private(set) public var media: JSQMessageMediaData?
    
    // MARK: - Initialization
    
    public required convenience init(senderId: String, senderDisplayName: String, date: NSDate, text: String) {
        
        self.init(senderId: senderId, senderDisplayName: senderDisplayName, date: date, isMedia: false)
        self.text = text
    }
    
    public class func message(senderId senderId: String, senderDisplayName: String, text: String) -> JSQMessage {
        
        return JSQMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: NSDate(), text: text)
    }
    
    public required convenience init(senderId: String, senderDisplayName: String, date: NSDate, media: JSQMessageMediaData) {
        
        self.init(senderId: senderId, senderDisplayName: senderDisplayName, date: date, isMedia: true)
        self.media = media
    }
    
    public class func message(senderId senderId: String, senderDisplayName: String, media: JSQMessageMediaData) -> JSQMessage {
        
        return JSQMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: NSDate(), media: media)
    }
    
    private init(senderId: String, senderDisplayName: String, date: NSDate, isMedia: Bool) {
        
        self.senderID = senderId
        self.senderDisplayName = senderDisplayName
        self.date = date
        self.isMediaMessage = isMedia
        
        super.init()
    }
    
    // MARK: - NSObject
    
    public override func isEqual(object: AnyObject?) -> Bool {
        
        if !object!.isKindOfClass(self.dynamicType) {
            
            return false
        }
        
        if let msg = object as? JSQMessage {
        
            if self.isMediaMessage != msg.isMediaMessage {
                
                return false
            }
            
            let hasEqualContent: Bool = (self.isMediaMessage ? self.media?.isEqual(msg.media) : self.text == msg.text) ?? false
            
            return self.senderID == msg.senderID
                    && self.senderDisplayName == msg.senderDisplayName
                    && self.date.compare(msg.date) == .OrderedSame
                    && hasEqualContent
        }
        
        return false
    }
    
    public override var hash:Int {
        
        get {
            
            let contentHash = self.isMediaMessage ? self.media?.mediaHash : self.text?.hash
            return self.senderID.hash^self.date.hash^contentHash!
        }
    }
    
    public override var description: String {
        
        get {
            
            return "<\(self.dynamicType): senderId=\(self.senderID), senderDisplayName=\(self.senderDisplayName), date=\(self.date), isMediaMessage=\(self.isMediaMessage), text=\(self.text), media=\(self.media)>"
        }
    }
    
    func debugQuickLookObject() -> AnyObject? {
        
        return self.media?.mediaPlaceholderView
    }
    
    // MARK: - NSCoding
    
    public required init(coder aDecoder: NSCoder) {
        
        self.senderID = aDecoder.decodeObjectForKey("senderID") as? String ?? ""
        self.senderDisplayName = aDecoder.decodeObjectForKey("senderDisplayName") as? String ?? ""
        self.date = aDecoder.decodeObjectForKey("date") as? NSDate ?? NSDate()
        
        self.isMediaMessage = aDecoder.decodeBoolForKey("isMediaMessage")
        self.text = aDecoder.decodeObjectForKey("text") as? String ?? ""
        
        self.media = aDecoder.decodeObjectForKey("media") as? JSQMessageMediaData
    }
    
    public func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(self.senderID, forKey: "senderID")
        aCoder.encodeObject(self.senderDisplayName, forKey: "senderDisplayName")
        aCoder.encodeObject(self.date, forKey: "date")
        
        aCoder.encodeBool(self.isMediaMessage, forKey: "isMediaMessage")
        aCoder.encodeObject(self.text, forKey: "text")
        
        aCoder.encodeObject(self.media, forKey: "media")
    }
    
    // MARK: - NSCopying
    
    public func copyWithZone(zone: NSZone) -> AnyObject {
        
        if self.isMediaMessage {
            
            return self.dynamicType.init(senderId: self.senderID, senderDisplayName: self.senderDisplayName, date: self.date, media: self.media!)
        }
        
        return self.dynamicType.init(senderId: self.senderID, senderDisplayName: self.senderDisplayName, date: self.date, text: self.text!)
    }
}