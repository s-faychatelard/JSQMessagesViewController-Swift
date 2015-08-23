//
//  JSQMessagesComposerTextView_Tests.swift
//  JSQMessagesViewController
//
//  Created by Sylvain FAY-CHATELARD on 20/08/2015.
//  Copyright (c) 2015 Dviance. All rights reserved.
//

import XCTest
import JSQMessagesViewController

class JSQMessagesComposerTextView_Tests: XCTestCase {

    var textView: JSQMessagesComposerTextView!
    
    override func setUp() {
        
        super.setUp()
        
        self.textView = JSQMessagesComposerTextView(frame: CGRectMake(0, 0, 300, 50), textContainer: NSTextContainer())
    }
    
    override func tearDown() {
        
        super.tearDown()
        
        self.textView = nil
    }
    
    func testComposerTextViewInit() {
        
        XCTAssertNotNil(self.textView, "Text view should falset be nil")
        
        XCTAssertNil(self.textView.text, "Property should be equal to default value")
        XCTAssertNil(self.textView.placeHolder, "Property should be equal to default value")
        XCTAssertEqual(self.textView.placeHolderTextColor, UIColor.lightGrayColor(), "Property should be equal to default value")
        
        XCTAssertEqual(self.textView.backgroundColor!, UIColor.whiteColor(), "Property should be equal to default value")
        
        XCTAssertEqual(self.textView.layer.borderWidth, 0.5, "Property should be equal to default value")
        XCTAssertEqual(UIColor(CGColor: self.textView.layer.borderColor)!, UIColor.lightGrayColor(), "Property should be equal to default value")
        XCTAssertEqual(self.textView.layer.cornerRadius, 6, "Property should be equal to default value")
        
        XCTAssertTrue(UIEdgeInsetsEqualToEdgeInsets(self.textView.scrollIndicatorInsets, UIEdgeInsetsMake(6, 0, 6, 0)), "Property should be equal to default value")
        
        XCTAssertTrue(UIEdgeInsetsEqualToEdgeInsets(self.textView.textContainerInset, UIEdgeInsetsMake(4, 2, 4, 2)), "Property should be equal to default value")
        XCTAssertTrue(UIEdgeInsetsEqualToEdgeInsets(self.textView.contentInset, UIEdgeInsetsMake(1, 0, 1, 0)), "Property should be equal to default value")
        
        XCTAssertEqual(self.textView.scrollEnabled, true, "Property should be equal to default value")
        XCTAssertEqual(self.textView.scrollsToTop, false, "Property should be equal to default value")
        XCTAssertEqual(self.textView.userInteractionEnabled, true, "Property should be equal to default value")
        
        XCTAssertEqual(self.textView.contentMode, .Redraw, "Property should be equal to default value")
        XCTAssertEqual(self.textView.dataDetectorTypes, .None, "Property should be equal to default value")
        XCTAssertEqual(self.textView.keyboardAppearance, .Default, "Property should be equal to default value")
        XCTAssertEqual(self.textView.keyboardType, .Default, "Property should be equal to default value")
        XCTAssertEqual(self.textView.returnKeyType, .Default, "Property should be equal to default value")
    }
}