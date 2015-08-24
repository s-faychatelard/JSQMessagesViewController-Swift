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
        
        if let bundleResourcePath = NSBundle.jsq_messagesBundle()?.resourcePath {
            
            let assetPath = bundleResourcePath.stringByAppendingPathComponent("JSQMessagesAssets.bundle")
            return NSBundle(path: assetPath)
        }
        
        return nil
    }
    
    public class func jsq_localizedStringForKey(key: String) -> String {
        
        if let bundle = NSBundle.jsq_messagesAssetBundle() {
        
            return NSLocalizedString(key, tableName: "JSQMessages", bundle: bundle, comment: "")
        }
        return key
    }
}