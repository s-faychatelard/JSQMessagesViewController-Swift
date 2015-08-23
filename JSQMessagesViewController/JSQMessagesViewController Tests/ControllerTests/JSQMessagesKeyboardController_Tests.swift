//
//  JSQMessagesKeyboardController_Tests.swift
//  JSQMessagesViewController
//
//  Created by Sylvain FAY-CHATELARD on 21/08/2015.
//  Copyright (c) 2015 Dviance. All rights reserved.
//

import XCTest
import JSQMessagesViewController

class JSQMessagesKeyboardController_Tests: XCTestCase {

    func testKeyboardControllerInit() {
        
        let keyboardController = JSQMessagesKeyboardController(textView: UITextView(), contextView: UIView(), panGestureRecognizer: UIPanGestureRecognizer(), delegate: nil)

        XCTAssertNotNil(keyboardController, "Keyboard controller should not be nil")

        keyboardController.beginListeningForKeyboard()
        keyboardController.endListeningForKeyboard()
    }
}