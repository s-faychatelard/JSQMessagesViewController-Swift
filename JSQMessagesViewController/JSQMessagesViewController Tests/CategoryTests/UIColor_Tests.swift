//
//  UIColor_Tests.swift
//  JSQMessagesViewController
//
//  Created by Sylvain FAY-CHATELARD on 19/08/2015.
//  Copyright (c) 2015 Dviance. All rights reserved.
//

import XCTest
import JSQMessagesViewController

class UIColor_Tests: XCTestCase {

    func testDarkeningColors() {
        
        // GIVEN: a color and darkening value
        let r: CGFloat = 0.89, g: CGFloat = 0.34, b: CGFloat = 0.67, a: CGFloat = 1.0
        let darkeningValue: CGFloat = 0.12
        let color = UIColor(red: r, green: g, blue: b, alpha: a)
        
        // WHEN: we darken that color
        let darkColor = color.jsq_colorByDarkeningColorWithValue(darkeningValue)
        
        // THEN: each RGB value is changed accordingly
        var dr: CGFloat = 0, dg: CGFloat = 0, db: CGFloat = 0, da: CGFloat = 0
        darkColor.getRed(&dr, green: &dg, blue: &db, alpha: &da)
        
        XCTAssertEqual(dr, r - darkeningValue, "Red values should be equal")
        XCTAssertEqual(dg, g - darkeningValue, "Green values should be equal")
        XCTAssertEqual(db, b - darkeningValue, "Blue values should be equal")
        XCTAssertEqual(da, a, "Alpha values should be equal")
    }
    
    func testDarkeningColorsFloorToZero() {

        // GIVEN: a color and darkening value
        let r: CGFloat = 0.89, g: CGFloat = 0.24, b: CGFloat = 0.67, a: CGFloat = 1.0
        let darkeningValue: CGFloat = 0.5
        let color = UIColor(red: r, green: g, blue: b, alpha: a)
        
        // WHEN: we darken that color
        let darkColor = color.jsq_colorByDarkeningColorWithValue(darkeningValue)
        
        // THEN: each RGB value is changed accordingly
        var dr: CGFloat = 0, dg: CGFloat = 0, db: CGFloat = 0, da: CGFloat = 0
        darkColor.getRed(&dr, green: &dg, blue: &db, alpha: &da)
        
        XCTAssertEqual(dr, r - darkeningValue, "Red values should be equal")
        XCTAssertEqual(dg, 0.0, "Green values should be floored to zero")
        XCTAssertEqual(db, b - darkeningValue, "Blue values should be equal")
        XCTAssertEqual(da, a, "Alpha values should be equal")
    }
}