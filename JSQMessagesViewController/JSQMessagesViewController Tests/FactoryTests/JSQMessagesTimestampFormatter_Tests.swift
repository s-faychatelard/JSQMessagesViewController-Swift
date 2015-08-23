//
//  JSQMessagesTimestampFormatter_Tests.swift
//  JSQMessagesViewController
//
//  Created by Sylvain FAY-CHATELARD on 20/08/2015.
//  Copyright (c) 2015 Dviance. All rights reserved.
//

import XCTest
import JSQMessagesViewController

class JSQMessagesTimestampFormatter_Tests: XCTestCase {
    
    func testTimestampFormatterInit() {
        
        let formatter = JSQMessagesTimestampFormatter.sharedFormatter
        XCTAssertNotNil(formatter, "Formatter should not be nil")
        XCTAssertEqual(formatter, JSQMessagesTimestampFormatter.sharedFormatter, "Shared formatter should return the same instance")
        XCTAssertNotNil(formatter.dateFormatter, "Property should not be nil")
    }
}