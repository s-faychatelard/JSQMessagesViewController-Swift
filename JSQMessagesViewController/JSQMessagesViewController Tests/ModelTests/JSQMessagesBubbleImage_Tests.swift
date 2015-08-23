//
//  JSQMessagesBubbleImage_Tests.swift
//  JSQMessagesViewController
//
//  Created by Sylvain FAY-CHATELARD on 20/08/2015.
//  Copyright (c) 2015 Dviance. All rights reserved.
//

import XCTest
import JSQMessagesViewController

class JSQMessagesBubbleImage_Tests: XCTestCase {
    
    func testInitValid() {
        
        let mockImage = UIImage.jsq_bubbleCompactImage()!
        let bubbleImage = JSQMessagesBubbleImage(bubbleImage: mockImage, highlightedImage: mockImage)
        
        XCTAssertNotNil(bubbleImage, "Valid init should succeed")
    }
    
    func testCopy() {
        
        let mockImage = UIImage.jsq_bubbleCompactImage()!
        let bubbleImage = JSQMessagesBubbleImage(bubbleImage: mockImage, highlightedImage: mockImage)
        
        let copy = bubbleImage.copy() as? JSQMessagesBubbleImage
        
        XCTAssertNotNil(copy, "Copy should not be nil")
        
        XCTAssertFalse(bubbleImage == copy, "Copy should return new, distinct instance")
        
        XCTAssertNotEqual(bubbleImage.messageBubbleImage, copy!.messageBubbleImage, "Images should not be equal")
        XCTAssertNotEqual(bubbleImage.messageBubbleImage, copy!.messageBubbleImage, "Images should not be equal")
        
        XCTAssertNotEqual(bubbleImage.messageBubbleHighlightedImage, copy!.messageBubbleHighlightedImage, "Images should not be equal")
        XCTAssertNotEqual(bubbleImage.messageBubbleHighlightedImage, copy!.messageBubbleHighlightedImage, "Images should not be equal")
    }
}