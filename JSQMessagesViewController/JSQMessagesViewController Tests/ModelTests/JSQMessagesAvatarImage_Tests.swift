//
//  JSQMessagesAvatarImage_Tests.swift
//  JSQMessagesViewController
//
//  Created by Sylvain FAY-CHATELARD on 20/08/2015.
//  Copyright (c) 2015 Dviance. All rights reserved.
//

import XCTest
import JSQMessagesViewController

class JSQMessagesAvatarImage_Tests: XCTestCase {

    func testInitValid() {
        
        let mockImage = UIImage.jsq_bubbleCompactImage()!
        let avatar = JSQMessagesAvatarImage.avatar(placeholder: mockImage)
        XCTAssertNotNil(avatar, "Avatar should not be nil")
        
        let avatar2  = JSQMessagesAvatarImage.avatar(image: mockImage)
        XCTAssertNotNil(avatar2, "Avatar should not be nil")
        
        XCTAssertNotNil(avatar2.avatarImage, "Avatar image should not be nil")
        XCTAssertNotNil(avatar2.avatarHighlightedImage, "Avatar highlighted image should not be nil")
        
        XCTAssertEqual(avatar2.avatarImage!, avatar2.avatarHighlightedImage!)
        XCTAssertEqual(avatar2.avatarHighlightedImage!, avatar2.avatarPlaceholderImage)
    }
    
    func testCopy() {
        
        let mockImage = UIImage.jsq_bubbleCompactImage()!
        let avatar = JSQMessagesAvatarImage(avatarImage: mockImage, highlightedImage: mockImage, placeholderImage: mockImage)
        
        let copy = avatar.copy() as? JSQMessagesAvatarImage
        
        XCTAssertNotNil(copy, "Copy should not be nil")
        XCTAssertNotNil(copy?.avatarImage, "Copied avatar image should not be nil")
        XCTAssertNotNil(copy?.avatarHighlightedImage, "Copy highlighted avatar should not be nil")
        
        XCTAssertFalse(avatar == copy, "Copy should return new, distinct instance")
        
        XCTAssertNotEqual(avatar.avatarImage!, copy!.avatarImage!, "Images should not be equal")
        XCTAssertNotEqual(avatar.avatarHighlightedImage!, copy!.avatarHighlightedImage!, "Images should not be equal")
        XCTAssertNotEqual(avatar.avatarPlaceholderImage, copy!.avatarPlaceholderImage, "Images should not be equal")
    }
}