//
//  JSQMessagesToolbarContentView_Tests.swift
//  JSQMessagesViewController
//
//  Created by Sylvain FAY-CHATELARD on 20/08/2015.
//  Copyright (c) 2015 Dviance. All rights reserved.
//

import XCTest
import JSQMessagesViewController

class JSQMessagesToolbarContentView_Tests: XCTestCase {

    var contentView: JSQMessagesToolbarContentView!
    
    override func setUp() {
        
        super.setUp()
        
        let contentViewNib = JSQMessagesToolbarContentView.nib()
        XCTAssertNotNil(contentViewNib, "Nib should not be nil")
        
        let view = contentViewNib.instantiateWithOwner(nil, options: nil)
        self.contentView = view.first as? JSQMessagesToolbarContentView
        XCTAssertNotNil(self.contentView, "Content view should not be nil")
    }
    
    override func tearDown() {
        
        super.tearDown()
        self.contentView = nil
    }
    
    func testToolbarContentViewInit() {
        
        XCTAssertTrue(CGRectEqualToRect(self.contentView.frame, CGRectMake(0, 0, 320, 44)), "Frame should be equal to default value")
        
        XCTAssertNotNil(self.contentView.textView, "Text view should not be nil")
        XCTAssertNil(self.contentView.leftBarButtonItem, "Property should be equal to default value")
        XCTAssertNil(self.contentView.rightBarButtonItem, "Property should be equal to default value")
    }
}