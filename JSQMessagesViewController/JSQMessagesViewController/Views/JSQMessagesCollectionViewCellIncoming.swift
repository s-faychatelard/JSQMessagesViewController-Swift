//
//  JSQMessagesCollectionViewCellIncoming.swift
//  JSQMessagesViewController
//
//  Created by Sylvain FAY-CHATELARD on 20/08/2015.
//  Copyright (c) 2015 Dviance. All rights reserved.
//

import UIKit

class JSQMessagesCollectionViewCellIncoming: JSQMessagesCollectionViewCell {
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        self.messageBubbleTopLabel.textAlignment = .Left
        self.cellBottomLabel.textAlignment = .Left
    }
    
    override class func nib() -> UINib {
        
        return UINib(nibName: "\(JSQMessagesCollectionViewCellIncoming.self)".jsq_className(), bundle: NSBundle(forClass: JSQMessagesCollectionViewCellIncoming.self))
    }
    
    override class func cellReuseIdentifier() -> String {
        
        return "\(JSQMessagesCollectionViewCellIncoming.self)".jsq_className()
    }
    
    override class func mediaCellReuseIdentifier() -> String {
        
        return "\(JSQMessagesCollectionViewCellIncoming.self)".jsq_className() + "_JSQMedia"
    }
}