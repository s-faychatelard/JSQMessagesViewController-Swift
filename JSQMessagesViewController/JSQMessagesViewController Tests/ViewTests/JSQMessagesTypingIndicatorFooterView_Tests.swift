//
//  JSQMessagesTypingIndicatorFooterView_Tests.swift
//  JSQMessagesViewController
//
//  Created by Sylvain FAY-CHATELARD on 20/08/2015.
//  Copyright (c) 2015 Dviance. All rights reserved.
//

import XCTest
import JSQMessagesViewController

class JSQMessagesTypingIndicatorFooterView_Tests: XCTestCase {
    
    func testTypingIndicatorFooterViewInit() {

        let footerView = JSQMessagesTypingIndicatorFooterView.nib()
        XCTAssertNotNil(footerView, "Nib should not be nil")
        
        let footerId = JSQMessagesTypingIndicatorFooterView.footerReuseIdentifier()
        XCTAssertNotNil(footerId, "Footer view identifier should not be nil")
        
        let views = footerView.instantiateWithOwner(nil, options: nil)
        let view = views.first as? JSQMessagesTypingIndicatorFooterView
        XCTAssertNotNil(view, "JSQMessagesTypingIndicatorFooterView view should not be nil")
    }
}