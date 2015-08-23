//
//  NSBundle_Tests.swift
//  JSQMessagesViewController
//
//  Created by Sylvain FAY-CHATELARD on 19/08/2015.
//  Copyright (c) 2015 Dviance. All rights reserved.
//

import XCTest
import JSQMessagesViewController

class NSBundle_Tests: XCTestCase {
    
    func testMessagesBundle() {
        
        XCTAssertNotNil(NSBundle.jsq_messagesBundle())
    }

    func testAssetBundle() {
        
        let bundle = NSBundle.jsq_messagesAssetBundle()
        XCTAssertNotNil(bundle)
        XCTAssertEqual(bundle?.bundlePath.lastPathComponent ?? "", "JSQMessagesAssets.bundle")
    }
    
    func testLocalizedStringForKey() {
        
        XCTAssertNotNil(NSBundle.jsq_localizedStringForKey("send"))
        XCTAssertNotEqual(NSBundle.jsq_localizedStringForKey("send"), "send")
        
        XCTAssertNotNil(NSBundle.jsq_localizedStringForKey("load_earlier_messages"))
        XCTAssertNotEqual(NSBundle.jsq_localizedStringForKey("load_earlier_messages"), "load_earlier_messages")

        XCTAssertNotNil(NSBundle.jsq_localizedStringForKey("new_message"))
        XCTAssertNotEqual(NSBundle.jsq_localizedStringForKey("new_message"), "new_message")
    }
}