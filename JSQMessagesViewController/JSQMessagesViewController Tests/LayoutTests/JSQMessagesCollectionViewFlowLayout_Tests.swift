//
//  JSQMessagesCollectionViewFlowLayout_Tests.swift
//  JSQMessagesViewController
//
//  Created by Sylvain FAY-CHATELARD on 20/08/2015.
//  Copyright (c) 2015 Dviance. All rights reserved.
//

import XCTest
import JSQMessagesViewController

class JSQMessagesCollectionViewFlowLayout_Tests: XCTestCase {

    func testFlowLayoutInit() {
        
        let layout = JSQMessagesCollectionViewFlowLayout()
        XCTAssertNotNil(layout, "Layout should not be nil")
    }
}