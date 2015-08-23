//
//  JSQVideoMediaItem_Tests.swift
//  JSQMessagesViewController
//
//  Created by Sylvain FAY-CHATELARD on 20/08/2015.
//  Copyright (c) 2015 Dviance. All rights reserved.
//

import XCTest
import JSQMessagesViewController

class JSQVideoMediaItem_Tests: XCTestCase {
    
    func testVideoItemInit() {
        
        let item = JSQVideoMediaItem(fileURL: NSURL(string: "file://")!, isReadyToPlay: false)
        XCTAssertNotNil(item, "Video message should not be nil")
    }
    
    func testVideoItemIsEqual() {
        
        let item = JSQVideoMediaItem(fileURL: NSURL(string: "file://")!, isReadyToPlay: true)
        let copy = item.copy() as? JSQVideoMediaItem
        
        XCTAssertNotNil(copy, "Copied video message should not be nil")
        
        XCTAssertEqual(item, copy!, "Copied items should be equal")
        XCTAssertEqual(item.hash, copy!.hash, "Copied items should be equal")
        XCTAssertEqual(item, item, "Item should be equal to itself")
    }
    
    func testVideoItemArchiving() {
        
        let item = JSQVideoMediaItem(fileURL: NSURL(string: "file://")!, isReadyToPlay: true)
        let data = NSKeyedArchiver.archivedDataWithRootObject(item)
        
        let unarchivedItem = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? JSQVideoMediaItem
        
        XCTAssertNotNil(unarchivedItem, "Unarchived video message should not be nil")
        XCTAssertEqual(item, unarchivedItem!, "Unarchived video message should be equal to the base one")
    }
    
    func testMediaDataProtocol() {
        
        let item = JSQVideoMediaItem()
        
        XCTAssertTrue(!CGSizeEqualToSize(item.mediaViewDisplaySize, CGSizeZero))
        XCTAssertNotNil(item.mediaPlaceholderView)
        XCTAssertNil(item.mediaView, "Media view should be nil if image is nil")
        
        item.fileURL = NSURL(string: "file://")!
        item.isReadyToPlay = true
        
        XCTAssertNotNil(item.mediaView, "Media view should NOT be nil once item has media data")
    }
}