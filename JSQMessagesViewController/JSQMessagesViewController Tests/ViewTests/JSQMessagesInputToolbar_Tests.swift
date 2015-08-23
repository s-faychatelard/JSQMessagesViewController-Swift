//
//  JSQMessagesInputToolbar_Tests.swift
//  JSQMessagesViewController
//
//  Created by Sylvain FAY-CHATELARD on 21/08/2015.
//  Copyright (c) 2015 Dviance. All rights reserved.
//

import XCTest
import JSQMessagesViewController

class JSQMessagesInputToolbar_Tests: XCTestCase {

    func testInputToolbarInit() {
        
        let vc = JSQMessagesViewController.messagesViewController()
        vc.loadView()
        
        let toolbar = vc.inputToolbar
        XCTAssertNotNil(toolbar, "Toolbar should not be nil")
        XCTAssertNotNil(toolbar.contentView, "Toolbar content view should not be nil")
        XCTAssertEqual(toolbar.sendButtonOnRight, true, "Property should be equal to default value")
    }
    
    func testSetMaximumHeight() {
        
        let vc = JSQMessagesViewController.messagesViewController()
        vc.loadView()
        
        let toolbar = vc.inputToolbar
        
        XCTAssertEqual(toolbar.maximumHeight, NSNotFound, "maximumInputToolbarHeight should equal default value")
        
        var newBounds = toolbar.bounds
        newBounds.size.height = 100
        toolbar.bounds = newBounds
        
        XCTAssertEqual(vc.inputToolbar.bounds.size.height, 100)
        
        vc.inputToolbar.maximumHeight = 54
        vc.viewDidLoad()
        
        XCTAssertLessThanOrEqual(vc.inputToolbar.frame.height, 54, "Toolbar height should be <= to maximumInputToolbarHeight")
    }
}