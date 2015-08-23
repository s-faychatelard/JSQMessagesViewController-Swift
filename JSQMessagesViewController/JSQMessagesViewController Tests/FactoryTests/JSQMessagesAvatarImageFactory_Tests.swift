//
//  JSQMessagesAvatarImageFactory_Tests.swift
//  JSQMessagesViewController
//
//  Created by Sylvain FAY-CHATELARD on 21/08/2015.
//  Copyright (c) 2015 Dviance. All rights reserved.
//

import XCTest
import JSQMessagesViewController

class JSQMessagesAvatarImageFactory_Tests: XCTestCase {

    func testAvatarImage() {
        
        let image = UIImage.jsq_bubbleCompactImage()
        XCTAssertNotNil(image, "Image should not be nil")
        
        let diameter: CGFloat = 50
        let avatar = JSQMessagesAvatarImageFactory.avatarImage(placholder: image!, diameter: diameter)
        
        XCTAssertNotNil(avatar, "Avatar should not be nil")
        XCTAssertTrue(CGSizeEqualToSize(avatar.avatarPlaceholderImage.size, CGSizeMake(diameter, diameter)), "Avatar size should be equal to diameter")
        XCTAssertEqual(avatar.avatarPlaceholderImage.scale, UIScreen.mainScreen().scale, "Avatar scale should be equal to screen scale")
        
        avatar.avatarImage = JSQMessagesAvatarImageFactory.circularAvatar(image: image!, diameter: diameter)
        XCTAssertNotNil(avatar.avatarImage, "Avatar image should not be nil")
        XCTAssertTrue(CGSizeEqualToSize(avatar.avatarImage!.size, CGSizeMake(diameter, diameter)), "Avatar size should be equal to diameter")
        XCTAssertEqual(avatar.avatarImage!.scale, UIScreen.mainScreen().scale, "Avatar scale should be equal to screen scale")
        
        avatar.avatarHighlightedImage = JSQMessagesAvatarImageFactory.circularAvatar(highlightedImage: image!, diameter: diameter)
        XCTAssertNotNil(avatar.avatarImage, "Avatar highlighted image should not be nil")
        XCTAssertTrue(CGSizeEqualToSize(avatar.avatarHighlightedImage!.size, CGSizeMake(diameter, diameter)), "Avatar size should be equal to diameter")
        XCTAssertEqual(avatar.avatarHighlightedImage!.scale, UIScreen.mainScreen().scale, "Avatar scale should be equal to screen scale")
    }
}