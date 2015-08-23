//
//  String_Tests.swift
//  JSQMessagesViewController
//
//  Created by Sylvain FAY-CHATELARD on 19/08/2015.
//  Copyright (c) 2015 Dviance. All rights reserved.
//

import XCTest
import JSQMessagesViewController

class String_Tests: XCTestCase {
    
    func testTrimingStringWhitespace() {
        
        let loremIpsum = "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
        
        let string1 = "       \(loremIpsum)      "
        let string2 = "       \(loremIpsum)"
        let string3 = "\(loremIpsum)      "
        
        XCTAssertEqual(loremIpsum, string1.jsq_stringByTrimingWhitespace(), "Strings should be equal after trimming whitespace")
        XCTAssertEqual(loremIpsum, string2.jsq_stringByTrimingWhitespace(), "Strings should be equal after trimming whitespace")
        XCTAssertEqual(loremIpsum, string3.jsq_stringByTrimingWhitespace(), "Strings should be equal after trimming whitespace")
    }
}