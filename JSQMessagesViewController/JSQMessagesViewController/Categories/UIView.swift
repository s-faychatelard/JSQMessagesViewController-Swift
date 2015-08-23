//
//  UIView.swift
//  JSQMessagesViewController
//
//  Created by Sylvain FAY-CHATELARD on 19/08/2015.
//  Copyright (c) 2015 Dviance. All rights reserved.
//

import UIKit

extension UIView {

    public func jsq_pinSubview(subview: UIView, toEdge attribute: NSLayoutAttribute) {
        
        self.addConstraint(NSLayoutConstraint(item: self, attribute: attribute, relatedBy: .Equal, toItem: subview, attribute: attribute, multiplier: 1, constant: 0))
    }
    
    public func jsq_pinAllEdgesOfSubview(subview: UIView) {
        
        self.jsq_pinSubview(subview, toEdge: .Bottom)
        self.jsq_pinSubview(subview, toEdge: .Top)
        self.jsq_pinSubview(subview, toEdge: .Leading)
        self.jsq_pinSubview(subview, toEdge: .Trailing)
    }
}