//
//  JSQMessagesViewController_Tests.swift
//  JSQMessagesViewController
//
//  Created by Sylvain FAY-CHATELARD on 21/08/2015.
//  Copyright (c) 2015 Dviance. All rights reserved.
//

import XCTest
import JSQMessagesViewController

class JSQMessagesViewController_Tests: XCTestCase {
    
    class TestMessagesViewController: JSQMessagesViewController {
        
        override func viewDidLoad() {
            
            super.viewDidLoad()
            
            self.senderID = "053496-4509-289"
            self.senderDisplayName = "Jesse Squires"
        }
    }

    func testJSQMessagesViewControllerInit() {
        
        let nib = JSQMessagesViewController.nib()
        XCTAssertNotNil(nib, "Nib should not be nil")
        
        let vc = JSQMessagesViewController.messagesViewController()
        vc.loadView()
        
        XCTAssertNotNil(vc, "View controller should not be nil")
        XCTAssertNotNil(vc.view, "View should not be nil")
        XCTAssertNotNil(vc.collectionView, "Collection view should not be nil")
        XCTAssertNotNil(vc.inputToolbar, "Input toolbar should not be nil")
        
        XCTAssertEqual(vc.automaticallyAdjustsScrollViewInsets, true, "Property should be equal to default value")
        
        XCTAssertEqual(vc.incomingCellIdentifier, JSQMessagesCollectionViewCellIncoming.cellReuseIdentifier(), "Property should be equal to default value")
        XCTAssertEqual(vc.outgoingCellIdentifier, JSQMessagesCollectionViewCellOutgoing.cellReuseIdentifier(), "Property should be equal to default value")
        
        XCTAssertEqual(vc.showTypingIndicator, false, "Property should be equal to default value")
        XCTAssertEqual(vc.showLoadEarlierMessagesHeader, false, "Property should be equal to default value")
    }
    
    func testJSQMessagesViewControllerSubclassInitProgramatically() {
        
        let vc = TestMessagesViewController.messagesViewController()
        vc.loadView()
        
        XCTAssertNotNil(vc, "View controller should not be nil")
        XCTAssertTrue(vc is TestMessagesViewController, "View controller should be kind of class: \(TestMessagesViewController.self), got \(vc.self)")
        XCTAssertNotNil(vc.view, "View should not be nil")
        XCTAssertNotNil(vc.collectionView, "Collection view should not be nil")
        XCTAssertNotNil(vc.inputToolbar, "Input toolbar should not be nil")
    }
}