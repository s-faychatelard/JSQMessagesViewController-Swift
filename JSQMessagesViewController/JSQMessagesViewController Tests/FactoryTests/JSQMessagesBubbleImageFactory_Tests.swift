//
//  JSQMessagesBubbleImageFactory_Tests.swift
//  JSQMessagesViewController
//
//  Created by Sylvain FAY-CHATELARD on 20/08/2015.
//  Copyright (c) 2015 Dviance. All rights reserved.
//

import XCTest
import JSQMessagesViewController

class JSQMessagesBubbleImageFactory_Tests: XCTestCase {

    var factory: JSQMessagesBubbleImageFactory = JSQMessagesBubbleImageFactory()
    
    override func setUp() {
        
        super.setUp()
        
        self.factory = JSQMessagesBubbleImageFactory()
    }
    
    func testOutgoingMessageBubbleImageView() {
        
        let bubble = UIImage.jsq_bubbleCompactImage()
        XCTAssertNotNil(bubble, "Bubble image should not be nil")
        
        let center = CGPointMake(bubble!.size.width / 2, bubble!.size.height / 2)
        let capInsets = UIEdgeInsetsMake(center.y, center.x, center.y, center.x)
        
        let bubbleImage = self.factory.outgoingMessagesBubbleImage(color: UIColor.lightGrayColor())
        XCTAssertNotNil(bubbleImage, "Bubble image should not be nil")
        
        XCTAssertNotNil(bubbleImage.messageBubbleImage, "Image should not be nil")
        XCTAssertEqual(bubbleImage.messageBubbleImage.scale, bubble!.scale, "Image scale should equal bubble image scale")
        XCTAssertEqual(bubbleImage.messageBubbleImage.imageOrientation, bubble!.imageOrientation, "Image orientation should equal bubble image orientation")
        XCTAssertTrue(bubbleImage.messageBubbleImage.resizingMode == .Stretch, "Image should be stretchable")
        XCTAssertTrue(UIEdgeInsetsEqualToEdgeInsets(bubbleImage.messageBubbleImage.capInsets, capInsets), "Image capInsets should be equal to capInsets")
        
        
        XCTAssertNotNil(bubbleImage.messageBubbleHighlightedImage, "Highlighted image should not be nil")
        XCTAssertEqual(bubbleImage.messageBubbleHighlightedImage.scale, bubble!.scale, "HighlightedImage scale should equal bubble image scale")
        XCTAssertEqual(bubbleImage.messageBubbleHighlightedImage.imageOrientation, bubble!.imageOrientation, "HighlightedImage orientation should equal bubble image orientation")
        XCTAssertTrue(bubbleImage.messageBubbleHighlightedImage.resizingMode == .Stretch, "HighlightedImage should be stretchable")
        XCTAssertTrue(UIEdgeInsetsEqualToEdgeInsets(bubbleImage.messageBubbleHighlightedImage.capInsets, capInsets), "HighlightedImage capInsets should be equal to capInsets")
    }
    
    func testIncomingMessageBubbleImageView() {
        
        let bubble = UIImage.jsq_bubbleCompactImage()
        XCTAssertNotNil(bubble, "Bubble image should not be nil")
        
        let center = CGPointMake(bubble!.size.width / 2, bubble!.size.height / 2)
        let capInsets = UIEdgeInsetsMake(center.y, center.x, center.y, center.x)
        
        let bubbleImage = self.factory.incomingMessagesBubbleImage(color: UIColor.lightGrayColor())
        XCTAssertNotNil(bubbleImage, "Bubble image should not be nil")
        
        XCTAssertNotNil(bubbleImage.messageBubbleImage, "Image should not be nil")
        XCTAssertEqual(bubbleImage.messageBubbleImage.scale, bubble!.scale, "Image scale should equal bubble image scale")
        XCTAssertEqual(bubbleImage.messageBubbleImage.imageOrientation, .UpMirrored, "Image orientation should equal bubble image orientation")
        
        XCTAssertTrue(bubbleImage.messageBubbleImage.resizingMode == .Stretch, "Image should be stretchable")
        XCTAssertTrue(UIEdgeInsetsEqualToEdgeInsets(bubbleImage.messageBubbleImage.capInsets, capInsets), "Image capInsets should be equal to capInsets")
        XCTAssertNotNil(bubbleImage.messageBubbleHighlightedImage, "Highlighted image should not be nil")
        XCTAssertEqual(bubbleImage.messageBubbleHighlightedImage.scale, bubble!.scale, "HighlightedImage scale should equal bubble image scale")
        XCTAssertEqual(bubbleImage.messageBubbleHighlightedImage.imageOrientation, .UpMirrored, "HighlightedImage orientation should equal bubble image orientation")
        XCTAssertTrue(bubbleImage.messageBubbleHighlightedImage.resizingMode == .Stretch, "HighlightedImage should be stretchable")
        XCTAssertTrue(UIEdgeInsetsEqualToEdgeInsets(bubbleImage.messageBubbleHighlightedImage.capInsets, capInsets), "HighlightedImage capInsets should be equal to capInsets")
    }
    
    func testCustomOutgoingMessageBubbleImageView() {
        
        let bubble = UIImage.jsq_bubbleCompactImage()
        XCTAssertNotNil(bubble, "Bubble image should not be nil")
        
        let capInsets = UIEdgeInsetsMake(1, 1, 1, 1)
        let factory = JSQMessagesBubbleImageFactory(bubbleImage: bubble!, capInsets: capInsets)
        let bubbleImage = factory.outgoingMessagesBubbleImage(color: UIColor.lightGrayColor())
        XCTAssertNotNil(bubbleImage, "Bubble image should not be nil")
        
        XCTAssertNotNil(bubbleImage.messageBubbleImage, "Image should not be nil")
        XCTAssertEqual(bubbleImage.messageBubbleImage.scale, bubble!.scale, "Image scale should equal bubble image scale")
        XCTAssertEqual(bubbleImage.messageBubbleImage.imageOrientation, bubble!.imageOrientation, "Image orientation should equal bubble image orientation")
        XCTAssertTrue(bubbleImage.messageBubbleImage.resizingMode == .Stretch, "Image should be stretchable")
        XCTAssertTrue(UIEdgeInsetsEqualToEdgeInsets(bubbleImage.messageBubbleImage.capInsets, capInsets), "Image capInsets should be equal to capInsets")
        
        
        XCTAssertNotNil(bubbleImage.messageBubbleHighlightedImage, "Highlighted image should not be nil")
        XCTAssertEqual(bubbleImage.messageBubbleHighlightedImage.scale, bubble!.scale, "HighlightedImage scale should equal bubble image scale")
        XCTAssertEqual(bubbleImage.messageBubbleHighlightedImage.imageOrientation, bubble!.imageOrientation, "HighlightedImage orientation should equal bubble image orientation")
        XCTAssertTrue(bubbleImage.messageBubbleHighlightedImage.resizingMode == .Stretch, "HighlightedImage should be stretchable")
        XCTAssertTrue(UIEdgeInsetsEqualToEdgeInsets(bubbleImage.messageBubbleHighlightedImage.capInsets, capInsets), "HighlightedImage capInsets should be equal to capInsets")
    }
    
    func testCustomIncomingMessageBubbleImageView() {
        
        let bubble = UIImage.jsq_bubbleCompactImage()
        XCTAssertNotNil(bubble, "Bubble image should not be nil")
        
        let capInsets = UIEdgeInsetsMake(1, 1, 1, 1)
        let factory = JSQMessagesBubbleImageFactory(bubbleImage: bubble!, capInsets: capInsets)
        let bubbleImage = factory.incomingMessagesBubbleImage(color: UIColor.lightGrayColor())
        XCTAssertNotNil(bubbleImage, "Bubble image should not be nil")
        
        XCTAssertNotNil(bubbleImage.messageBubbleImage, "Image should not be nil")
        XCTAssertEqual(bubbleImage.messageBubbleImage.scale, bubble!.scale, "Image scale should equal bubble image scale")
        XCTAssertEqual(bubbleImage.messageBubbleImage.imageOrientation, .UpMirrored, "Image orientation should equal bubble image orientation")
        XCTAssertTrue(bubbleImage.messageBubbleImage.resizingMode == .Stretch, "Image should be stretchable")
        XCTAssertTrue(UIEdgeInsetsEqualToEdgeInsets(bubbleImage.messageBubbleImage.capInsets, capInsets), "Image capInsets should be equal to capInsets")
        
        
        XCTAssertNotNil(bubbleImage.messageBubbleHighlightedImage, "Highlighted image should not be nil")
        XCTAssertEqual(bubbleImage.messageBubbleHighlightedImage.scale, bubble!.scale, "HighlightedImage scale should equal bubble image scale")
        XCTAssertEqual(bubbleImage.messageBubbleHighlightedImage.imageOrientation, .UpMirrored, "HighlightedImage orientation should equal bubble image orientation")
        XCTAssertTrue(bubbleImage.messageBubbleHighlightedImage.resizingMode == .Stretch, "HighlightedImage should be stretchable")
        XCTAssertTrue(UIEdgeInsetsEqualToEdgeInsets(bubbleImage.messageBubbleHighlightedImage.capInsets, capInsets), "HighlightedImage capInsets should be equal to capInsets")
    }
}