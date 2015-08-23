//
//  JSQLocationMediaItem_Tests.swift
//  JSQMessagesViewController
//
//  Created by Sylvain FAY-CHATELARD on 20/08/2015.
//  Copyright (c) 2015 Dviance. All rights reserved.
//

import XCTest
import MapKit
import JSQMessagesViewController

class JSQLocationMediaItem_Tests: XCTestCase {
    
    let location: CLLocation = CLLocation(latitude: 37.795313, longitude: -122.393757)

    func testLocationItemInit() {
        
        let item = JSQLocationMediaItem(location: self.location)
        XCTAssertNotNil(item, "Location message should not be nil")
    }
    
    func testLocationItemIsEqual() {
        
        let item = JSQLocationMediaItem(location: self.location)
        let copy = item.copy() as? JSQLocationMediaItem
        
        XCTAssertNotNil(copy, "Copied location message should not be nil")
        
        XCTAssertEqual(item, copy!, "Copied items should be equal")
        XCTAssertEqual(item.hash, copy!.hash, "Copied items should be equal")
        XCTAssertEqual(item, item, "Item should be equal to itself")
    }
    
    func testLocationItemArchiving() {
        
        let item = JSQLocationMediaItem(location: self.location)
        let data = NSKeyedArchiver.archivedDataWithRootObject(item)
        
        let unarchivedItem = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? JSQLocationMediaItem
        
        XCTAssertNotNil(unarchivedItem, "Unarchived location message should not be nil")
        XCTAssertEqual(item, unarchivedItem!, "Unarchived location message should be equal to the base one")
    }
    
    func testMediaDataProtocol() {
        
        let item = JSQLocationMediaItem()
        
        XCTAssertTrue(!CGSizeEqualToSize(item.mediaViewDisplaySize, CGSizeZero))
        XCTAssertNotNil(item.mediaPlaceholderView)
        XCTAssertNil(item.mediaView, "Media view should be nil if image is nil")
        
        let expectation: XCTestExpectation = self.expectationWithDescription(__FUNCTION__)
        
        item.set(self.location) {
            
            expectation.fulfill()
        }
        
        self.waitForExpectationsWithTimeout(5, handler: { (error) -> Void in
            
            XCTAssertNil(error, "Expectation should not error")
        })
        
        XCTAssertNotNil(item.mediaView, "Media view should NOT be nil once item has media data")
    }
}