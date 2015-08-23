//
//  UIImage_Tests.swift
//  JSQMessagesViewController
//
//  Created by Sylvain FAY-CHATELARD on 19/08/2015.
//  Copyright (c) 2015 Dviance. All rights reserved.
//

import XCTest
import JSQMessagesViewController

class UIImage_Tests: XCTestCase {
    
    func testImageMasking() {

        // GIVEN: an image
        let img = UIImage.jsq_bubbleCompactImage()
        XCTAssertNotNil(img, "Image should not be nil")
        
        // WHEN: we mask that image
        let imgMasked = img!.jsq_imageMaskedWithColor(UIColor.whiteColor())
        XCTAssertNotNil(imgMasked, "Image should not be nil")
        
        // THEN: masking should succeed, and the new image should have the same properties
        XCTAssertTrue(CGSizeEqualToSize(img!.size, imgMasked.size), "Image sizes should be equal")
        
        XCTAssertEqual(img!.scale, imgMasked.scale, "Image scales should be equal")
    }
    
    func testImageAssets() {
        
        // GIVEN: our image assets
        
        // WHEN: we create a new UIImage.object
        
        // THEN: the image is created successfully
        
        XCTAssertNotNil(UIImage.jsq_bubbleRegularImage())
        
        XCTAssertNotNil(UIImage.jsq_bubbleRegularTaillessImage())
        
        XCTAssertNotNil(UIImage.jsq_bubbleRegularStrokedImage())
        
        XCTAssertNotNil(UIImage.jsq_bubbleRegularStrokedTaillessImage())
        
        XCTAssertNotNil(UIImage.jsq_bubbleCompactImage())
        
        XCTAssertNotNil(UIImage.jsq_bubbleCompactTaillessImage())
        
        XCTAssertNotNil(UIImage.jsq_defaultAccessoryImage())
        
        XCTAssertNotNil(UIImage.jsq_defaultTypingIndicatorImage())
        
        XCTAssertNotNil(UIImage.jsq_defaultPlayImage())
    }
}