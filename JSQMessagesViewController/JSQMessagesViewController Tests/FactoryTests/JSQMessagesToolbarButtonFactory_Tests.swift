//
//  JSQMessagesToolbarButtonFactory_Tests.swift
//  JSQMessagesViewController
//
//  Created by Sylvain FAY-CHATELARD on 20/08/2015.
//  Copyright (c) 2015 Dviance. All rights reserved.
//

import XCTest
import JSQMessagesViewController

class JSQMessagesToolbarButtonFactory_Tests: XCTestCase {
    
    func testDefaultSendButtonItem() {

        let button = JSQMessagesToolbarButtonFactory.defaultSendButtonItem()
        XCTAssertNotNil(button, "Button should not be nil")
    }
    
    func testDefaultAccessoryButtonItem() {
        
        let button = JSQMessagesToolbarButtonFactory.defaultAccessoryButtonItem()
        XCTAssertNotNil(button, "Button should not be nil")
    }
}