//
//  JSQMessageText_Tests.swift
//  JSQMessagesViewController
//
//  Created by Sylvain FAY-CHATELARD on 20/08/2015.
//  Copyright (c) 2015 Dviance. All rights reserved.
//

import XCTest
import JSQMessagesViewController

class JSQMessageText_Tests: XCTestCase {

    let senderId: String = "324543-43556-212343"
    let senderDisplayName: String = "Jesse Squires"
    let date: NSDate = NSDate()
    let text: String =  "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque" +
                        "laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi" +
                        "architecto beatae vitae dicta sunt explicabo."
    
    func testTextMessageInit() {
        
        let msg = JSQMessage(senderId: self.senderId, senderDisplayName: self.senderDisplayName, date: self.date, text: self.text)
        XCTAssertNotNil(msg, "Message should not be nil")
    }
    
    func testTextMessageIsEqual() {
        
        let msg = JSQMessage(senderId: self.senderId, senderDisplayName: self.senderDisplayName, date: self.date, text: self.text)
        let copy = msg.copy() as? JSQMessage
        
        XCTAssertNotNil(copy, "Copied message should no be nil")
        XCTAssertEqual(msg, copy!, "Copied messages should be equal")
        XCTAssertEqual(msg.hash, copy!.hash, "Copied messages hashes should be equal")
        XCTAssertEqual(msg, msg, "Messages should be equal to itself")
    }
    
    func testMediaMessageArchiving() {
        
        let msg = JSQMessage(senderId: self.senderId, senderDisplayName: self.senderDisplayName, date: self.date, text: self.text)
        let msgData: NSData = NSKeyedArchiver.archivedDataWithRootObject(msg)
        let unarchivedMsg = NSKeyedUnarchiver.unarchiveObjectWithData(msgData) as? JSQMessage
        
        XCTAssertNotNil(unarchivedMsg, "Unarchived message should no be nil")
        XCTAssertEqual(msg, unarchivedMsg!, "Message should be equal")
    }
}