//
//  JSQMessagesLabel_Tests.swift
//  JSQMessagesViewController
//
//  Created by Sylvain FAY-CHATELARD on 20/08/2015.
//  Copyright (c) 2015 Dviance. All rights reserved.
//

import XCTest
import JSQMessagesViewController

class JSQMessagesLabel_Tests: XCTestCase {

    func testMessagesLabelInit() {
        
        let label = JSQMessagesLabel(frame:CGRectMake(0, 0, 200, 40))
        XCTAssertNotNil(label, "Label should not be nil")
        XCTAssertTrue(UIEdgeInsetsEqualToEdgeInsets(label.textInsets, UIEdgeInsetsZero), "Property should be equal to default value")
    }
}