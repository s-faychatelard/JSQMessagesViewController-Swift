//
//  UIView_Tests.swift
//  JSQMessagesViewController
//
//  Created by Sylvain FAY-CHATELARD on 19/08/2015.
//  Copyright (c) 2015 Dviance. All rights reserved.
//

import XCTest
import JSQMessagesViewController

class UIView_Tests: XCTestCase {
    
    func testViewAutoLayoutPinEdges() {

        // GIVEN: a superview and subview
        let superview = UIView(frame: CGRectMake(0, 0, 50, 50))
        superview.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        let subview = UIView(frame: CGRectMake(0, 0, 25, 25))
        subview.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        // WHEN: we add the subview to the superview
        superview.addSubview(subview)
        
        // WHEN: we pin the edges of the subview to the superview
        superview.jsq_pinAllEdgesOfSubview(subview)
        //TODO: Swift 2 -> XCTAssertNoThrow([superview jsq_pinAllEdgesOfSubview:subview], @"Pinning edges of subview to superview should not throw");
        superview.setNeedsUpdateConstraints()
        superview.layoutIfNeeded()
        
        // THEN: add the layout constraints and laying out the views succeeds
        
        XCTAssertEqual(superview.constraints().count, 4, "Superview should have 4 constraints")
        
        XCTAssertEqual(subview.constraints().count, 0, "Subview should have 0 constraints")
        
        for eachConstraint in superview.constraints() {
            
            XCTAssertEqual(eachConstraint.firstItem as! UIView, superview, "Constraint first item should be equal to superview")
            
            XCTAssertEqual(eachConstraint.secondItem as! UIView, subview, "Constraint second item should be equal to subview")
            
            XCTAssertEqual(eachConstraint.relation, .Equal, "Constraint relation should be NSLayoutRelationEqual")
            
            XCTAssertEqual(eachConstraint.multiplier, 1, "Constraint multiplier should be 1.0")
            
            XCTAssertEqual(eachConstraint.constant, 0, "Constraint constant should be 0.0")
        }
    }
}