//
//  JSQMessagesLabel.swift
//  JSQMessagesViewController
//
//  Created by Sylvain FAY-CHATELARD on 20/08/2015.
//  Copyright (c) 2015 Dviance. All rights reserved.
//

import UIKit

class JSQMessagesLabel: UILabel {
    
    var textInsets: UIEdgeInsets = UIEdgeInsetsZero {
        
        didSet {
            
            self.setNeedsDisplay()
        }
    }
    
    // MARK: - Initialization
    
    func jsq_configureLabel() {
        
        self.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        self.textInsets = UIEdgeInsetsZero
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.jsq_configureLabel()
    }

    required init(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        self.jsq_configureLabel()
    }
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        self.jsq_configureLabel()
    }
    
    // MARK: - Drawing
    
    override func drawTextInRect(rect: CGRect) {
        
        super.drawTextInRect(CGRectMake(CGRectGetMinX(rect) + self.textInsets.left, CGRectGetMinY(rect) + self.textInsets.top, rect.width - self.textInsets.right, rect.height - self.textInsets.bottom))
    }
}
