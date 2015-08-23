//
//  JSQMessagesMediaViewBubbleImageMasker_Tests.swift
//  JSQMessagesViewController
//
//  Created by Sylvain FAY-CHATELARD on 20/08/2015.
//  Copyright (c) 2015 Dviance. All rights reserved.
//

import XCTest
import JSQMessagesViewController

class JSQMessagesMediaViewBubbleImageMasker_Tests: XCTestCase {

    func testMediaViewBubbleImageMasker() {
        
        // GIVEN: a new masker object
        let masker = JSQMessagesMediaViewBubbleImageMasker()
        XCTAssertNotNil(masker)
        
        // WHEN: we apply a mask to a view
        let view1 = UIView(frame: CGRectMake(0, 0, 100, 100))
        let view2 = UIView(frame: CGRectMake(0, 0, 100, 100))
        
        // THEN: it succeeds without an error
        masker.applyOutgoingBubbleImageMask(mediaView: view1)
        masker.applyIncomingBubbleImageMask(mediaView: view2)
    }
}