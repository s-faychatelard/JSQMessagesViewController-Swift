//
//  JSQMessageMediaData_Tests.swift
//  JSQMessagesViewController
//
//  Created by Sylvain FAY-CHATELARD on 19/08/2015.
//  Copyright (c) 2015 Dviance. All rights reserved.
//

import XCTest
import JSQMessagesViewController

class JSQMessageMediaData_Tests: XCTestCase {
    
    class FakeMedia: NSObject, JSQMessageMediaData, NSCoding {
        
        override init() { super.init() }
        var mediaView: UIView? { get { return UIView() } }
        var mediaViewDisplaySize: CGSize { get { return CGSizeMake(50, 50) } }
        var mediaPlaceholderView: UIView { get { return self.mediaView! } }
        var mediaHash: Int { get { return self.hash } }
        
        func encodeWithCoder(aCoder: NSCoder) {}
        required init(coder aDecoder: NSCoder) { super.init() }
        
        override func isEqual(object: AnyObject?) -> Bool { return true }
        override var hash:Int { get { return 100000 } }
    }
    
    var senderId: String = "324543-43556-212343"
    var senderDisplayName: String = "Jesse Squires"
    var date: NSDate = NSDate()
    var mockMedia: JSQMessageMediaData = FakeMedia()
    
    func testMediaMessageInit() {

        let msg = JSQMessage(senderId: self.senderId, senderDisplayName: self.senderDisplayName, date: self.date, media: self.mockMedia)
        XCTAssertNotNil(msg, "Message should not be nil")
    }
    
    func testMediaPrint() {
        
        let msg = JSQMessage(senderId: self.senderId, senderDisplayName: self.senderDisplayName, date: self.date, media: self.mockMedia)
        print(msg)
    }
    
    func testMediaMessageIsEqual() {
        
        let msg = JSQMessage(senderId: self.senderId, senderDisplayName: self.senderDisplayName, date: self.date, media: self.mockMedia)
        let copy = msg.copy() as? JSQMessage
        
        XCTAssertNotNil(copy, "Copied message should no be nil")
        XCTAssertEqual(msg, copy!, "Copied messages should be equal")
        XCTAssertEqual(msg.hash, copy!.hash, "Copied messages hashes should be equal")
        XCTAssertEqual(msg, msg, "Messages should be equal to itself")
    }
    
    func testMediaMessageArchiving() {
        
        let msg = JSQMessage(senderId: self.senderId, senderDisplayName: self.senderDisplayName, date: self.date, media: self.mockMedia)
        let msgData: NSData = NSKeyedArchiver.archivedDataWithRootObject(msg)
        let unarchivedMsg = NSKeyedUnarchiver.unarchiveObjectWithData(msgData) as? JSQMessage
        
        XCTAssertNotNil(unarchivedMsg, "Unarchived message should no be nil")
        XCTAssertEqual(msg, unarchivedMsg!, "Message should be equal")
    }
}