//
//  JSQMessagesCollectionViewLayoutAttributes_Tests.swift
//  JSQMessagesViewController
//
//  Created by Sylvain FAY-CHATELARD on 20/08/2015.
//  Copyright (c) 2015 Dviance. All rights reserved.
//

import XCTest
import JSQMessagesViewController

class JSQMessagesCollectionViewLayoutAttributes_Tests: XCTestCase {
    
    func testLayoutAttributesInitAndIsEqual() {
        
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        
        let attrs = JSQMessagesCollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        attrs.messageBubbleFont = UIFont.systemFontOfSize(15)
        attrs.messageBubbleContainerViewWidth = 40
        attrs.textViewTextContainerInsets = UIEdgeInsetsMake(10, 8, 10, 8)
        attrs.textViewFrameInsets = UIEdgeInsetsMake(0, 0, 0, 6)
        attrs.incomingAvatarViewSize = CGSizeMake(34, 34)
        attrs.outgoingAvatarViewSize = CGSizeZero
        attrs.cellTopLabelHeight = 20
        attrs.messageBubbleTopLabelHeight = 10
        attrs.cellBottomLabelHeight = 15
        XCTAssertNotNil(attrs, "Layout attributes should not be nil")
        
        let copy = attrs.copy() as? JSQMessagesCollectionViewLayoutAttributes
        XCTAssertNotNil(copy, "Copie layout attributes should not be nil")
        
        XCTAssertEqual(attrs, copy!, "Copied attributes should be equal")
        XCTAssertEqual(attrs.hash, copy!.hash, "Copied attributes hashes should be equal")
    }
}