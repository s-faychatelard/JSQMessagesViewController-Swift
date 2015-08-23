//
//  JSQMessagesCollectionViewFlowLayoutInvalidationContext.swift
//  JSQMessagesViewController
//
//  Created by Sylvain FAY-CHATELARD on 20/08/2015.
//  Copyright (c) 2015 Dviance. All rights reserved.
//

import UIKit

class JSQMessagesCollectionViewFlowLayoutInvalidationContext: UICollectionViewFlowLayoutInvalidationContext {
    
    var invalidateFlowLayoutMessagesCache: Bool = false
    
    override init() {
        
        super.init()
        
        self.invalidateFlowLayoutDelegateMetrics = false
        self.invalidateFlowLayoutAttributes = false
        self.invalidateFlowLayoutMessagesCache = false
    }
    
    class func context() -> JSQMessagesCollectionViewFlowLayoutInvalidationContext {
        
        let context = JSQMessagesCollectionViewFlowLayoutInvalidationContext()
        context.invalidateFlowLayoutDelegateMetrics = true
        context.invalidateFlowLayoutAttributes = true
        return context
    }
    
    // MARK: - NSObject
    
    override var description: String {
        
        get {
            
            return "<\(self.dynamicType): invalidateFlowLayoutDelegateMetrics=\(self.invalidateFlowLayoutDelegateMetrics), invalidateFlowLayoutAttributes=\(self.invalidateFlowLayoutAttributes), invalidateDataSourceCounts=\(self.invalidateDataSourceCounts), invalidateFlowLayoutMessagesCache=\(self.invalidateFlowLayoutMessagesCache)>"
        }
    }
}