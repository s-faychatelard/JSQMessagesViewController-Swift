//
//  String.swift
//  JSQMessagesViewController
//
//  Created by Sylvain FAY-CHATELARD on 19/08/2015.
//  Copyright (c) 2015 Dviance. All rights reserved.
//

import Foundation

extension String {
    
    public func jsq_className() -> String {
        
        return self.componentsSeparatedByString(".").last ?? self
    }
    
    public func jsq_stringByTrimingWhitespace() -> String {
        
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }
}