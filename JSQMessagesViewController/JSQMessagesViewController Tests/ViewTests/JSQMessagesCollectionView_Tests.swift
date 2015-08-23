//
//  JSQMessagesCollectionView_Tests.swift
//  JSQMessagesViewController
//
//  Created by Sylvain FAY-CHATELARD on 20/08/2015.
//  Copyright (c) 2015 Dviance. All rights reserved.
//

import XCTest
import JSQMessagesViewController

class JSQMessagesCollectionView_Tests: XCTestCase {

    func testCollectionViewInit() {
        
        let layout = JSQMessagesCollectionViewFlowLayout()
        let view = JSQMessagesCollectionView(frame: UIScreen.mainScreen().bounds, collectionViewLayout: layout)
        
        XCTAssertNotNil(view, "Collection view should not be nil")
        XCTAssertEqual(view.backgroundColor!, UIColor.whiteColor(), "Property should be equal to default value")
        XCTAssertEqual(view.keyboardDismissMode, .None, "Property should be equal to default value")
        XCTAssertEqual(view.alwaysBounceVertical, true, "Property should be equal to default value")
        XCTAssertEqual(view.bounces, true, "Property should be equal to default value")
    }
}