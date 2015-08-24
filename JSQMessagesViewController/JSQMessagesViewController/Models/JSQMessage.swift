//
//  JSQMessage.swift
//  JSQMessagesViewController
//
//  Created by Sylvain FAY-CHATELARD on 19/08/2015.
//  Copyright (c) 2015 Dviance. All rights reserved.
//

import Foundation

class JSQMessage: NSObject, JSQMessageData, NSCoding, NSCopying {
    
    private(set) var senderID: String
    private(set) var senderDisplayName: String
    private(set) var date: NSDate
    
    private(set) var isMediaMessage: Bool
    var messageHash: Int {
        
        get {
            
            return self.hash
        }
    }
    
    private(set) var text: String?
    private(set) var media: JSQMessageMediaData?
    
    // MARK: - Initialization
    
    required convenience init(senderId: String, senderDisplayName: String, date: NSDate, text: String) {
        
        self.init(senderId: senderId, senderDisplayName: senderDisplayName, date: date, isMedia: false)
        self.text = text
    }
    
    class func message(#senderId: String, senderDisplayName: String, text: String) -> JSQMessage {
        
        return JSQMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: NSDate(), text: text)
    }
    
    required convenience init(senderId: String, senderDisplayName: String, date: NSDate, media: JSQMessageMediaData) {
        
        self.init(senderId: senderId, senderDisplayName: senderDisplayName, date: date, isMedia: true)
        self.media = media
    }
    
    class func message(#senderId: String, senderDisplayName: String, media: JSQMessageMediaData) -> JSQMessage {
        
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
    
    override func isEqual(object: AnyObject?) -> Bool {
        
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
    
    override var hash:Int {
        
        get {
            
            let contentHash = self.isMediaMessage ? self.media?.mediaHash : self.text?.hash
            return self.senderID.hash^self.date.hash^contentHash!
        }
    }
    
    override var description: String {
        
        get {
            
            return "<\(self.dynamicType): senderId=\(self.senderID), senderDisplayName=\(self.senderDisplayName), date=\(self.date), isMediaMessage=\(self.isMediaMessage), text=\(self.text), media=\(self.media)>"
        }
    }
    
    func debugQuickLookObject() -> AnyObject? {
        
        return self.media?.mediaPlaceholderView
    }
    
    // MARK: - NSCoding
    
    required init(coder aDecoder: NSCoder) {
        
        self.senderID = aDecoder.decodeObjectForKey("senderID") as? String ?? ""
        self.senderDisplayName = aDecoder.decodeObjectForKey("senderDisplayName") as? String ?? ""
        self.date = aDecoder.decodeObjectForKey("date") as? NSDate ?? NSDate()
        
        self.isMediaMessage = aDecoder.decodeBoolForKey("isMediaMessage")
        self.text = aDecoder.decodeObjectForKey("text") as? String ?? ""
        
        self.media = aDecoder.decodeObjectForKey("media") as? JSQMessageMediaData
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(self.senderID, forKey: "senderID")
        aCoder.encodeObject(self.senderDisplayName, forKey: "senderDisplayName")
        aCoder.encodeObject(self.date, forKey: "date")
        
        aCoder.encodeBool(self.isMediaMessage, forKey: "isMediaMessage")
        aCoder.encodeObject(self.text, forKey: "text")
        
        aCoder.encodeObject(self.media, forKey: "media")
    }
    
    // MARK: - NSCopying
    
    func copyWithZone(zone: NSZone) -> AnyObject {
        
        if self.isMediaMessage {
            
            return self.dynamicType(senderId: self.senderID, senderDisplayName: self.senderDisplayName, date: self.date, media: self.media!)
        }
        
        return self.dynamicType(senderId: self.senderID, senderDisplayName: self.senderDisplayName, date: self.date, text: self.text!)
    }
}