//
//  JSQMessagesCollectionViewCell_Tests.swift
//  JSQMessagesViewController
//
//  Created by Sylvain FAY-CHATELARD on 20/08/2015.
//  Copyright (c) 2015 Dviance. All rights reserved.
//

import XCTest
import JSQMessagesViewController

class JSQMessagesCollectionViewCell_Tests: XCTestCase {

    func testMessagesIncomingCollectionViewCellInit() {
        
        let incomingCell = JSQMessagesCollectionViewCellIncoming.nib()
        XCTAssertNotNil(incomingCell, "Nib should not be nil")
        
        let incomingCellId = JSQMessagesCollectionViewCellIncoming.cellReuseIdentifier()
        XCTAssertNotNil(incomingCellId, "Cell identifier should not be nil")
        XCTAssertEqual(incomingCellId, "\(JSQMessagesCollectionViewCellIncoming.self)".jsq_className())
        
        let views = incomingCell.instantiateWithOwner(nil, options: nil)
        let view = views.first as? JSQMessagesCollectionViewCellIncoming
        XCTAssertNotNil(view, "JSQMessagesCollectionViewCellIncoming view should not be nil")
    }
    
    func testMessagesOutgoingCollectionViewCellInit() {
        
        let outgoingCell = JSQMessagesCollectionViewCellOutgoing.nib()
        XCTAssertNotNil(outgoingCell, "Nib should not be nil")
        
        let outgoingCellId = JSQMessagesCollectionViewCellOutgoing.cellReuseIdentifier()
        XCTAssertNotNil(outgoingCellId, "Cell identifier should not be nil")
        XCTAssertEqual(outgoingCellId, "\(JSQMessagesCollectionViewCellOutgoing.self)".jsq_className())
        
        let views = outgoingCell.instantiateWithOwner(nil, options: nil)
        let view = views.first as? JSQMessagesCollectionViewCellOutgoing
        XCTAssertNotNil(view, "JSQMessagesCollectionViewCellOutgoing view should not be nil")
    }
}