//
//  JSQMessagesCollectionViewCellOutgoing.swift
//  JSQMessagesViewController
//
//  Created by Sylvain FAY-CHATELARD on 20/08/2015.
//  Copyright (c) 2015 Dviance. All rights reserved.
//

import UIKit

public class JSQMessagesCollectionViewCellOutgoing: JSQMessagesCollectionViewCell {
    
    public override func awakeFromNib() {
        
        super.awakeFromNib()
        
        self.messageBubbleTopLabel.textAlignment = .Right
        self.cellBottomLabel.textAlignment = .Right
    }
    
    public override class func nib() -> UINib {
        
        return UINib(nibName: "\(JSQMessagesCollectionViewCellOutgoing.self)".jsq_className(), bundle: NSBundle(forClass: JSQMessagesCollectionViewCellOutgoing.self))
    }
    
    public override class func cellReuseIdentifier() -> String {
        
        return "\(JSQMessagesCollectionViewCellOutgoing.self)".jsq_className()
    }
    
    public override class func mediaCellReuseIdentifier() -> String {
        
        return "\(JSQMessagesCollectionViewCellOutgoing.self)".jsq_className() + "_JSQMedia"
    }
}