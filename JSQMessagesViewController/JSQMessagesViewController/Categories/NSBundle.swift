//
//  NSBundle.swift
//  JSQMessagesViewController
//
//  Created by Sylvain FAY-CHATELARD on 19/08/2015.
//  Copyright (c) 2015 Dviance. All rights reserved.
//

import Foundation

extension NSBundle {
    
    public class func jsq_messagesBundle() -> NSBundle? {
        
        return NSBundle(forClass: JSQMessagesViewController.self)
    }
    
    public class func jsq_messagesAssetBundle() -> NSBundle? {

        let bundlePath = NSBundle.jsq_messagesBundle()!.pathForResource("JSQMessagesAssets", ofType: "bundle")
        return NSBundle(path: bundlePath!)
    }
    
    public class func jsq_localizedStringForKey(key: String) -> String {
        
        if let bundle = NSBundle.jsq_messagesAssetBundle() {
        
            return NSLocalizedString(key, tableName: "JSQMessages", bundle: bundle, comment: "")
        }
        return key
    }
}