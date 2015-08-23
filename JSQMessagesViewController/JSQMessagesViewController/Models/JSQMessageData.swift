//
//  JSQMessageData.swift
//  JSQMessagesViewController
//
//  Created by Sylvain FAY-CHATELARD on 19/08/2015.
//  Copyright (c) 2015 Dviance. All rights reserved.
//

import Foundation

@objc public protocol JSQMessageData {
    
    var senderID: String { get }
    var senderDisplayName: String { get }
    var date: NSDate { get }
    var isMediaMessage: Bool { get }
    var messageHash: Int { get }
    
    var text: String? { get }
    var media: JSQMessageMediaData? { get }
}