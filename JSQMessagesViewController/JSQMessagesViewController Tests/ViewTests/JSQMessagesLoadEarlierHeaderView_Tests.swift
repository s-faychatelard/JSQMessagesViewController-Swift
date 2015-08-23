//
//  JSQMessagesLoadEarlierHeaderView_Tests.swift
//  JSQMessagesViewController
//
//  Created by Sylvain FAY-CHATELARD on 20/08/2015.
//  Copyright (c) 2015 Dviance. All rights reserved.
//

import XCTest
import JSQMessagesViewController

class JSQMessagesLoadEarlierHeaderView_Tests: XCTestCase {

    func testLoadEarlierHeaderViewInit() {
        
        let headerView = JSQMessagesLoadEarlierHeaderView.nib()
        XCTAssertNotNil(headerView, "Nib should not be nil")
        
        let headerId = JSQMessagesLoadEarlierHeaderView.headerReuseIdentifier()
        XCTAssertNotNil(headerId, "Header view identifier should not be nil")
        
        let views = headerView.instantiateWithOwner(nil, options: nil)
        let view = views.first as? JSQMessagesLoadEarlierHeaderView
        XCTAssertNotNil(view, "JSQMessagesLoadEarlierHeaderView view should not be nil")
    }
}