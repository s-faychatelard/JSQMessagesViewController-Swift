//
//  JSQPhotoMediaItem_Tests.swift
//  JSQMessagesViewController
//
//  Created by Sylvain FAY-CHATELARD on 20/08/2015.
//  Copyright (c) 2015 Dviance. All rights reserved.
//

import XCTest
import JSQMessagesViewController

class JSQPhotoMediaItem_Tests: XCTestCase {

    func testPhotoItemInit() {
     
        let item = JSQPhotoMediaItem(image: UIImage())
        XCTAssertNotNil(item, "Photo message should not be nil")
    }
    
    func testPhotoItemIsEqual() {
     
        let item = JSQPhotoMediaItem(image: UIImage.jsq_bubbleCompactImage()!)
        let copy = item.copy() as? JSQPhotoMediaItem
        
        XCTAssertNotNil(copy, "Copied photo message should not be nil")
        
        XCTAssertEqual(item, copy!, "Copied items should be equal")
        XCTAssertEqual(item.hash, copy!.hash, "Copied items should be equal")
        XCTAssertEqual(item, item, "Item should be equal to itself")
    }
    
    func testPhotoItemArchiving() {
        
        let item = JSQPhotoMediaItem(image: UIImage())
        let data = NSKeyedArchiver.archivedDataWithRootObject(item)
        
        let unarchivedItem = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? JSQPhotoMediaItem
        
        XCTAssertNotNil(unarchivedItem, "Unarchived photo message should not be nil")
        XCTAssertEqual(item, unarchivedItem!, "Unarchived photo message should be equal to the base one")
    }
    
    func testMediaDataProtocol() {
     
        let item = JSQPhotoMediaItem(image: nil)
        
        XCTAssertTrue(!CGSizeEqualToSize(item.mediaViewDisplaySize, CGSizeZero))
        XCTAssertNotNil(item.mediaPlaceholderView)
        XCTAssertNil(item.mediaView, "Media view should be nil if image is nil")
        
        item.image = UIImage.jsq_bubbleCompactImage()
        
        XCTAssertNotNil(item.mediaView, "Media view should NOT be nil once item has media data")
    }
}